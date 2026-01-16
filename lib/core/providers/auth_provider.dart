import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../data/services/auth_service.dart';
import '../../data/services/encryption_service.dart';

/// Provider for authentication service
final authServiceProvider = Provider<AuthService>((ref) {
  return AuthService.instance;
});

/// Provider for encryption service
final encryptionServiceProvider = Provider<EncryptionService>((ref) {
  return EncryptionService.instance;
});

/// State for authentication status
class AuthState {
  final bool isAuthenticated;
  final bool hasMasterPassword;
  final bool isBiometricEnabled;
  final bool isBiometricAvailable;
  final bool isLoading;
  final String? error;

  AuthState({
    this.isAuthenticated = false,
    this.hasMasterPassword = false,
    this.isBiometricEnabled = false,
    this.isBiometricAvailable = false,
    this.isLoading = false,
    this.error,
  });

  AuthState copyWith({
    bool? isAuthenticated,
    bool? hasMasterPassword,
    bool? isBiometricEnabled,
    bool? isBiometricAvailable,
    bool? isLoading,
    String? error,
  }) {
    return AuthState(
      isAuthenticated: isAuthenticated ?? this.isAuthenticated,
      hasMasterPassword: hasMasterPassword ?? this.hasMasterPassword,
      isBiometricEnabled: isBiometricEnabled ?? this.isBiometricEnabled,
      isBiometricAvailable: isBiometricAvailable ?? this.isBiometricAvailable,
      isLoading: isLoading ?? this.isLoading,
      error: error,
    );
  }
}

/// Auth state notifier
class AuthNotifier extends StateNotifier<AuthState> {
  final AuthService _authService;
  final EncryptionService _encryptionService;

  AuthNotifier(this._authService, this._encryptionService)
      : super(AuthState()) {
    _checkAuthStatus();
  }

  Future<void> _checkAuthStatus() async {
    state = state.copyWith(isLoading: true);
    try {
      final hasPassword = await _authService.hasMasterPassword();
      final biometricEnabled = hasPassword
          ? await _authService.isBiometricEnabled()
          : false;
      final biometricAvailable = await _authService.isBiometricAvailable();

      state = state.copyWith(
        hasMasterPassword: hasPassword,
        isBiometricEnabled: biometricEnabled,
        isBiometricAvailable: biometricAvailable,
        isLoading: false,
      );
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        error: e.toString(),
      );
    }
  }

  /// Set master password (first time setup)
  Future<bool> setMasterPassword(String password) async {
    state = state.copyWith(isLoading: true, error: null);
    try {
      final success = await _authService.setMasterPassword(password);
      if (success) {
        // Initialize encryption with the password
        await _encryptionService.initialize(password);
        state = state.copyWith(
          hasMasterPassword: true,
          isAuthenticated: true,
          isLoading: false,
        );
      }
      return success;
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        error: e.toString(),
      );
      return false;
    }
  }

  /// Verify and authenticate with master password
  Future<bool> authenticate(String password) async {
    state = state.copyWith(isLoading: true, error: null);
    try {
      final isValid = await _authService.verifyMasterPassword(password);
      if (isValid) {
        // Initialize encryption with the password
        await _encryptionService.initialize(password);
        state = state.copyWith(
          isAuthenticated: true,
          isLoading: false,
        );
      } else {
        state = state.copyWith(
          isLoading: false,
          error: 'Invalid password',
        );
      }
      return isValid;
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        error: e.toString(),
      );
      return false;
    }
  }

  /// Authenticate with biometrics
  Future<bool> authenticateWithBiometrics() async {
    state = state.copyWith(isLoading: true, error: null);
    try {
      final success = await _authService.authenticateWithBiometrics();
      if (success) {
        // Note: For biometric auth, we need to retrieve the master password
        // from secure storage or use a derived key. For now, we'll assume
        // encryption is already initialized if biometric succeeds.
        state = state.copyWith(
          isAuthenticated: true,
          isLoading: false,
        );
      } else {
        state = state.copyWith(
          isLoading: false,
          error: 'Biometric authentication failed',
        );
      }
      return success;
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        error: e.toString(),
      );
      return false;
    }
  }

  /// Enable/disable biometric authentication
  Future<bool> setBiometricEnabled(bool enabled) async {
    state = state.copyWith(isLoading: true);
    try {
      final success = await _authService.setBiometricEnabled(enabled);
      if (success) {
        state = state.copyWith(
          isBiometricEnabled: enabled,
          isLoading: false,
        );
      }
      return success;
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        error: e.toString(),
      );
      return false;
    }
  }

  /// Logout
  void logout() {
    _encryptionService.clear();
    state = AuthState(
      hasMasterPassword: state.hasMasterPassword,
      isBiometricEnabled: state.isBiometricEnabled,
      isBiometricAvailable: state.isBiometricAvailable,
    );
  }

  /// Refresh auth status
  Future<void> refresh() async {
    await _checkAuthStatus();
  }
}

/// Auth state provider
final authProvider = StateNotifierProvider<AuthNotifier, AuthState>((ref) {
  final authService = ref.watch(authServiceProvider);
  final encryptionService = ref.watch(encryptionServiceProvider);
  return AuthNotifier(authService, encryptionService);
});
