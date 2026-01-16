import 'dart:convert';
import 'dart:math';
import 'dart:typed_data';
import 'package:crypto/crypto.dart';
import 'package:encrypt/encrypt.dart' as enc;
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import '../../core/utils/logger.dart';

/// AES-256 encryption service with PBKDF2 key derivation
class EncryptionService {
  static final EncryptionService instance = EncryptionService._init();
  final FlutterSecureStorage _secureStorage = const FlutterSecureStorage();
  enc.Encrypter? _encrypter;

  EncryptionService._init();

  /// Derive encryption key from master password using PBKDF2
  Uint8List _deriveKey(String password, String salt) {
    final saltBytes = utf8.encode(salt);
    final passwordBytes = utf8.encode(password);

    // PBKDF2 with 100,000 iterations using crypto package
    // Using a simple implementation: hash(password + salt) iteratively
    var key = Uint8List.fromList(passwordBytes);
    for (int i = 0; i < 100000; i++) {
      final hmac = Hmac(sha256, saltBytes);
      key = Uint8List.fromList(hmac.convert(key).bytes);
    }

    // Ensure we have exactly 32 bytes (256 bits) for AES-256
    if (key.length < 32) {
      // If shorter, pad with zeros
      final padded = Uint8List(32);
      padded.setRange(0, key.length, key);
      key = padded;
    } else if (key.length > 32) {
      // If longer, truncate
      key = key.sublist(0, 32);
    }

    return key;
  }

  /// Initialize encryption with master password
  Future<bool> initialize(String masterPassword) async {
    try {
      // Get or create salt
      String? salt = await _secureStorage.read(key: 'encryption_salt');
      if (salt == null) {
        // Generate random salt
        final random = Random.secure();
        final saltBytes = List<int>.generate(32, (_) => random.nextInt(256));
        salt = base64Encode(saltBytes);
        await _secureStorage.write(key: 'encryption_salt', value: salt);
      }

      // Derive key from password
      final keyBytes = _deriveKey(masterPassword, salt);
      final key = enc.Key(keyBytes);

      // Create encrypter with AES-256
      _encrypter = enc.Encrypter(enc.AES(key));

      Logger.info('Encryption service initialized');
      return true;
    } catch (e) {
      Logger.error('Failed to initialize encryption', e);
      return false;
    }
  }

  /// Encrypt plaintext data
  String encrypt(String plaintext) {
    if (_encrypter == null) {
      throw Exception('Encryption not initialized. Call initialize() first.');
    }

    try {
      // Generate new IV for each encryption
      final iv = enc.IV.fromSecureRandom(16);

      final encrypted = _encrypter!.encrypt(plaintext, iv: iv);
      
      // Combine IV and encrypted data (IV is needed for decryption)
      // Format: base64(iv):base64(encrypted)
      final combined = '${iv.base64}:${encrypted.base64}';
      return combined;
    } catch (e) {
      Logger.error('Encryption failed', e);
      rethrow;
    }
  }

  /// Decrypt encrypted data
  String decrypt(String encryptedData) {
    if (_encrypter == null) {
      throw Exception('Encryption not initialized. Call initialize() first.');
    }

    try {
      // Split IV and encrypted data
      final parts = encryptedData.split(':');
      if (parts.length != 2) {
        throw Exception('Invalid encrypted data format');
      }

      final iv = enc.IV.fromBase64(parts[0]);
      final encrypted = enc.Encrypted.fromBase64(parts[1]);

      final decrypted = _encrypter!.decrypt(encrypted, iv: iv);
      return decrypted;
    } catch (e) {
      Logger.error('Decryption failed', e);
      rethrow;
    }
  }

  /// Encrypt a double amount
  String encryptAmount(double amount) {
    return encrypt(amount.toStringAsFixed(2));
  }

  /// Decrypt and parse amount
  double decryptAmount(String encryptedAmount) {
    final decrypted = decrypt(encryptedAmount);
    return double.parse(decrypted);
  }

  /// Check if encryption is initialized
  bool get isInitialized => _encrypter != null;

  /// Clear encryption state (for logout)
  void clear() {
    _encrypter = null;
  }
}
