import 'dart:convert';
import 'dart:typed_data';
import 'package:crypto/crypto.dart';
import 'package:local_auth/local_auth.dart';
import '../database/database_helper.dart';
import '../../core/utils/logger.dart';

/// Authentication service for master password and biometric auth
class AuthService {
  static final AuthService instance = AuthService._init();
  final DatabaseHelper _dbHelper = DatabaseHelper.instance;
  final LocalAuthentication _localAuth = LocalAuthentication();

  AuthService._init();

  /// Hash password using PBKDF2
  Future<String> _hashPassword(String password, String salt) async {
    final passwordBytes = utf8.encode(password);
    final saltBytes = utf8.encode(salt);

    // PBKDF2 with 100,000 iterations
    var key = Uint8List.fromList(passwordBytes);
    for (int i = 0; i < 100000; i++) {
      final hmac = Hmac(sha256, saltBytes);
      key = Uint8List.fromList(hmac.convert(key).bytes);
    }

    return base64Encode(key);
  }

  /// Generate random salt
  String _generateSalt() {
    final random = DateTime.now().millisecondsSinceEpoch.toString();
    final bytes = utf8.encode(random);
    final hash = sha256.convert(bytes);
    return base64Encode(hash.bytes);
  }

  /// Check if master password is set
  Future<bool> hasMasterPassword() async {
    try {
      final db = await _dbHelper.database;
      final result = await db.query(
        'app_settings',
        limit: 1,
      );
      return result.isNotEmpty;
    } catch (e) {
      Logger.error('Failed to check master password', e);
      return false;
    }
  }

  /// Set master password (first time setup or after reset)
  Future<bool> setMasterPassword(String password, {bool force = false}) async {
    try {
      // Validate password strength
      if (password.length < 12) {
        throw Exception('Password must be at least 12 characters');
      }

      // Check if password already exists (unless forcing)
      if (!force && await hasMasterPassword()) {
        throw Exception('Master password already set. Please reset it first or use the login screen.');
      }

      // Generate salt
      final salt = _generateSalt();

      // Hash password
      final passwordHash = await _hashPassword(password, salt);

      // Store in database (update if exists, insert if new)
      final db = await _dbHelper.database;
      final existing = await db.query('app_settings', limit: 1);
      
      if (existing.isNotEmpty && force) {
        // Update existing password
        await db.update(
          'app_settings',
          {
            'master_password_hash': passwordHash,
            'salt': salt,
            'updated_at': DateTime.now().toIso8601String(),
          },
          where: 'id = ?',
          whereArgs: [existing.first['id']],
        );
      } else {
        // Insert new password
        await db.insert('app_settings', {
          'master_password_hash': passwordHash,
          'salt': salt,
          'biometric_enabled': 0,
          'currency_code': 'USD',
          'theme_mode': 'system',
        });
      }

      Logger.info('Master password set successfully');
      return true;
    } catch (e) {
      Logger.error('Failed to set master password', e);
      rethrow;
    }
  }

  /// Verify master password
  Future<bool> verifyMasterPassword(String password) async {
    try {
      final db = await _dbHelper.database;
      final result = await db.query(
        'app_settings',
        limit: 1,
      );

      if (result.isEmpty) {
        return false;
      }

      final settings = result.first;
      final storedHash = settings['master_password_hash'] as String;
      final salt = settings['salt'] as String;

      // Hash provided password with stored salt
      final providedHash = await _hashPassword(password, salt);

      // Compare hashes
      return providedHash == storedHash;
    } catch (e) {
      Logger.error('Failed to verify master password', e);
      return false;
    }
  }

  /// Check if biometric authentication is available
  Future<bool> isBiometricAvailable() async {
    try {
      final canCheck = await _localAuth.canCheckBiometrics;
      final isDeviceSupported = await _localAuth.isDeviceSupported();
      return canCheck && isDeviceSupported;
    } catch (e) {
      Logger.error('Failed to check biometric availability', e);
      return false;
    }
  }

  /// Get available biometric types
  Future<List<BiometricType>> getAvailableBiometrics() async {
    try {
      return await _localAuth.getAvailableBiometrics();
    } catch (e) {
      Logger.error('Failed to get available biometrics', e);
      return [];
    }
  }

  /// Enable/disable biometric authentication
  Future<bool> setBiometricEnabled(bool enabled) async {
    try {
      final db = await _dbHelper.database;
      final result = await db.query('app_settings', limit: 1);

      if (result.isEmpty) {
        throw Exception('Master password not set');
      }

      await db.update(
        'app_settings',
        {'biometric_enabled': enabled ? 1 : 0},
        where: 'id = ?',
        whereArgs: [result.first['id']],
      );

      Logger.info('Biometric authentication ${enabled ? 'enabled' : 'disabled'}');
      return true;
    } catch (e) {
      Logger.error('Failed to set biometric enabled', e);
      return false;
    }
  }

  /// Check if biometric is enabled
  Future<bool> isBiometricEnabled() async {
    try {
      final db = await _dbHelper.database;
      final result = await db.query('app_settings', limit: 1);

      if (result.isEmpty) return false;

      return (result.first['biometric_enabled'] as int? ?? 0) == 1;
    } catch (e) {
      Logger.error('Failed to check biometric enabled', e);
      return false;
    }
  }

  /// Authenticate with biometrics
  Future<bool> authenticateWithBiometrics() async {
    try {
      if (!await isBiometricEnabled()) {
        return false;
      }

      final isAvailable = await isBiometricAvailable();
      if (!isAvailable) {
        return false;
      }

      final authenticated = await _localAuth.authenticate(
        localizedReason: 'Authenticate to access FortiFi',
        options: const AuthenticationOptions(
          biometricOnly: true,
          stickyAuth: true,
        ),
      );

      return authenticated;
    } catch (e) {
      Logger.error('Biometric authentication failed', e);
      return false;
    }
  }

  /// Get app settings
  Future<Map<String, dynamic>?> getAppSettings() async {
    try {
      final db = await _dbHelper.database;
      final result = await db.query('app_settings', limit: 1);

      if (result.isEmpty) return null;

      return {
        'biometric_enabled': (result.first['biometric_enabled'] as int? ?? 0) == 1,
        'currency_code': result.first['currency_code'] as String? ?? 'USD',
        'theme_mode': result.first['theme_mode'] as String? ?? 'system',
      };
    } catch (e) {
      Logger.error('Failed to get app settings', e);
      return null;
    }
  }

  /// Update app settings
  Future<bool> updateAppSettings({
    String? currencyCode,
    String? themeMode,
  }) async {
    try {
      final db = await _dbHelper.database;
      final result = await db.query('app_settings', limit: 1);

      if (result.isEmpty) {
        throw Exception('App settings not found');
      }

      final updates = <String, dynamic>{
        'updated_at': DateTime.now().toIso8601String(),
      };

      if (currencyCode != null) {
        updates['currency_code'] = currencyCode;
      }

      if (themeMode != null) {
        updates['theme_mode'] = themeMode;
      }

      await db.update(
        'app_settings',
        updates,
        where: 'id = ?',
        whereArgs: [result.first['id']],
      );

      Logger.info('App settings updated');
      return true;
    } catch (e) {
      Logger.error('Failed to update app settings', e);
      return false;
    }
  }

  /// Reset master password (WARNING: This deletes all encrypted data)
  /// This method clears all encrypted expenses, budgets, and resets the master password
  Future<bool> resetMasterPassword() async {
    try {
      final db = await _dbHelper.database;
      
      // Delete all encrypted data
      await db.delete('expenses');
      await db.delete('budgets');
      await db.delete('recurring_expenses');
      await db.delete('analytics_cache');
      
      // Delete app settings (which contains the master password hash)
      await db.delete('app_settings');
      
      // Note: We keep categories and user_profile as they're not encrypted
      // User can optionally clear these separately if needed
      
      Logger.info('Master password reset - all encrypted data cleared');
      return true;
    } catch (e) {
      Logger.error('Failed to reset master password', e);
      return false;
    }
  }
}
