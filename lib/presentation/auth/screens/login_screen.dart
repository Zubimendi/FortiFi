import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../core/utils/route_names.dart';
import '../../../core/providers/auth_provider.dart';

/// Login screen for returning users
class LoginScreen extends ConsumerStatefulWidget {
  const LoginScreen({super.key});

  @override
  ConsumerState<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends ConsumerState<LoginScreen> {
  final TextEditingController _passwordController = TextEditingController();
  bool _isPasswordVisible = false;
  bool _isLoading = false;
  String? _errorMessage;

  @override
  void initState() {
    super.initState();
    // Try biometric authentication if available
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _tryBiometricAuth();
    });
  }

  @override
  void dispose() {
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _tryBiometricAuth() async {
    final authState = ref.read(authProvider);
    if (authState.isBiometricEnabled && authState.isBiometricAvailable) {
      // Small delay to let the screen render
      await Future.delayed(const Duration(milliseconds: 500));
      if (mounted) {
        await _handleBiometricAuth();
      }
    }
  }

  Future<void> _handleBiometricAuth() async {
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    final authNotifier = ref.read(authProvider.notifier);
    final success = await authNotifier.authenticateWithBiometrics();

    if (success && mounted) {
      // Navigate to dashboard
      context.go(RouteNames.dashboard);
    } else if (mounted) {
      setState(() {
        _isLoading = false;
        if (!success) {
          _errorMessage = 'Biometric authentication failed';
        }
      });
    }
  }

  Future<void> _handleLogin() async {
    final password = _passwordController.text.trim();
    
    if (password.isEmpty) {
      setState(() {
        _errorMessage = 'Please enter your master password';
      });
      return;
    }

    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    final authNotifier = ref.read(authProvider.notifier);
    final success = await authNotifier.authenticate(password);

    if (success && mounted) {
      // Navigate to dashboard
      context.go(RouteNames.dashboard);
    } else if (mounted) {
      setState(() {
        _isLoading = false;
        _errorMessage = ref.read(authProvider).error ?? 'Invalid password';
        _passwordController.clear();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final authState = ref.watch(authProvider);
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back,
            color: isDark ? AppColors.textPrimary : Colors.black87,
          ),
          onPressed: () => context.go(RouteNames.onboarding),
        ),
        title: Text(
          'Welcome Back',
          style: AppTextStyles.appName.copyWith(
            fontSize: 20,
            color: isDark ? AppColors.textPrimary : Colors.black87,
          ),
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const SizedBox(height: 40),
              // Logo/Icon
              Center(
                child: Container(
                  width: 80,
                  height: 80,
                  decoration: BoxDecoration(
                    color: isDark ? AppColors.cardBackground : Colors.grey.shade200,
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    Icons.lock_outline,
                    size: 40,
                    color: AppColors.primaryBlue,
                  ),
                ),
              ),
              const SizedBox(height: 32),
              // Title
              Text(
                'Enter Master Password',
                style: AppTextStyles.heading.copyWith(
                  fontSize: 28,
                  color: isDark ? AppColors.textPrimary : Colors.black87,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 12),
              // Subtitle
              Text(
                'Access your encrypted expense data',
                style: AppTextStyles.bodySecondary.copyWith(
                  color: isDark ? AppColors.textSecondary : Colors.grey.shade700,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 48),
              // Password Input
              TextField(
                controller: _passwordController,
                obscureText: !_isPasswordVisible,
                style: AppTextStyles.body.copyWith(
                  color: isDark ? AppColors.textPrimary : Colors.black87,
                ),
                decoration: InputDecoration(
                  hintText: 'Master Password',
                  hintStyle: AppTextStyles.bodySecondary.copyWith(
                    color: isDark ? AppColors.textSecondary : Colors.grey.shade700,
                  ),
                  filled: true,
                  fillColor: isDark ? AppColors.cardBackground : Colors.white,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide.none,
                  ),
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 16,
                  ),
                  suffixIcon: IconButton(
                    icon: Icon(
                      _isPasswordVisible ? Icons.visibility_off : Icons.visibility,
                      color: isDark ? AppColors.textSecondary : Colors.grey.shade700,
                    ),
                    onPressed: () {
                      setState(() {
                        _isPasswordVisible = !_isPasswordVisible;
                      });
                    },
                  ),
                ),
                onSubmitted: (_) => _handleLogin(),
              ),
              // Error Message
              if (_errorMessage != null) ...[
                const SizedBox(height: 16),
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: AppColors.error.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: AppColors.error.withOpacity(0.3)),
                  ),
                  child: Row(
                    children: [
                      Icon(
                        Icons.error_outline,
                        color: AppColors.error,
                        size: 20,
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Text(
                          _errorMessage!,
                          style: AppTextStyles.bodySecondary.copyWith(
                            color: AppColors.error,
                            fontSize: 14,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
              const SizedBox(height: 32),
              // Login Button
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: _isLoading ? null : _handleLogin,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primaryBlue,
                    foregroundColor: AppColors.textPrimary,
                    padding: const EdgeInsets.symmetric(vertical: 18),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    disabledBackgroundColor: AppColors.primaryBlue.withOpacity(0.5),
                  ),
                  child: _isLoading
                      ? const SizedBox(
                          height: 20,
                          width: 20,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            valueColor: AlwaysStoppedAnimation<Color>(
                              AppColors.textPrimary,
                            ),
                          ),
                        )
                      : Text(
                          'Unlock',
                          style: AppTextStyles.button,
                        ),
                ),
              ),
              // Biometric Auth Button
              if (authState.isBiometricAvailable && authState.isBiometricEnabled) ...[
                const SizedBox(height: 24),
                Center(
                  child: Text(
                    'or',
                    style: AppTextStyles.bodySecondary.copyWith(
                      color: isDark ? AppColors.textSecondary : Colors.grey.shade700,
                    ),
                  ),
                ),
                const SizedBox(height: 24),
                SizedBox(
                  width: double.infinity,
                  child: OutlinedButton.icon(
                    onPressed: _isLoading ? null : _handleBiometricAuth,
                    style: OutlinedButton.styleFrom(
                      foregroundColor: isDark ? AppColors.textPrimary : Colors.black87,
                      side: BorderSide(
                        color: isDark
                            ? AppColors.textSecondary.withOpacity(0.3)
                            : Colors.grey.shade300,
                      ),
                      padding: const EdgeInsets.symmetric(vertical: 18),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    icon: Icon(
                      authState.isBiometricAvailable
                          ? Icons.fingerprint
                          : Icons.face,
                      size: 24,
                    ),
                    label: Text(
                      authState.isBiometricAvailable
                          ? 'Use Fingerprint'
                          : 'Use Face ID',
                      style: AppTextStyles.button.copyWith(
                        color: isDark ? AppColors.textPrimary : Colors.black87,
                      ),
                    ),
                  ),
                ),
              ],
              const SizedBox(height: 32),
              // Forgot Password Link
              Center(
                child: TextButton(
                  onPressed: () => _showResetPasswordDialog(context, ref),
                  child: Text(
                    'Forgot Password?',
                    style: AppTextStyles.link.copyWith(
                      fontSize: 14,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 24),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _showResetPasswordDialog(BuildContext context, WidgetRef ref) async {
    // First confirmation - explain what will happen
    final firstConfirm = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('⚠️ Reset Master Password'),
        content: const Text(
          'This will permanently delete ALL your encrypted data including:\n\n'
          '• All expense records\n'
          '• All budget information\n'
          '• All recurring expenses\n\n'
          'This action CANNOT be undone. You will need to set a new master password and start fresh.\n\n'
          'Are you absolutely sure you want to continue?',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () => Navigator.of(context).pop(true),
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.error,
            ),
            child: const Text('I Understand'),
          ),
        ],
      ),
    );

    if (firstConfirm != true) return;

    // Second confirmation - require typing "RESET" to confirm
    final confirmController = TextEditingController();
    final secondConfirm = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Final Confirmation'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text(
              'To confirm, please type "RESET" in the box below:',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: confirmController,
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                hintText: 'Type RESET',
              ),
              autofocus: true,
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              if (confirmController.text.trim().toUpperCase() == 'RESET') {
                Navigator.of(context).pop(true);
              } else {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Please type "RESET" exactly to confirm'),
                    backgroundColor: AppColors.error,
                  ),
                );
              }
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.error,
            ),
            child: const Text('Reset Password'),
          ),
        ],
      ),
    );

    if (secondConfirm != true) return;

    // Perform the reset
    try {
      final authService = ref.read(authServiceProvider);
      final success = await authService.resetMasterPassword();

      if (success && context.mounted) {
        // Clear encryption service
        final encryptionService = ref.read(encryptionServiceProvider);
        encryptionService.clear();

        // Clear auth state
        ref.read(authProvider.notifier).logout();

        // Show success message
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text(
              'Master password reset. Please set a new password.',
            ),
            backgroundColor: AppColors.success,
            duration: Duration(seconds: 3),
          ),
        );

        // Navigate to security screen to set new password
        if (context.mounted) {
          context.go(RouteNames.masterPasswordSetup);
        }
      } else if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Failed to reset master password'),
            backgroundColor: AppColors.error,
          ),
        );
      }
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error: $e'),
            backgroundColor: AppColors.error,
          ),
        );
      }
    }
  }
}
