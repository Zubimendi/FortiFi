import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../widgets/master_password_input.dart';
import '../widgets/face_id_toggle_card.dart';
import '../widgets/encryption_info_card.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../core/utils/route_names.dart';
import '../../../core/providers/auth_provider.dart';

/// Security screen for master password setup
class SecurityScreen extends ConsumerStatefulWidget {
  const SecurityScreen({super.key});

  @override
  ConsumerState<SecurityScreen> createState() => _SecurityScreenState();
}

class _SecurityScreenState extends ConsumerState<SecurityScreen> {
  final TextEditingController _passwordController = TextEditingController();
  bool _isFaceIdEnabled = false;

  @override
  void initState() {
    super.initState();
    // Check if master password already exists
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _checkExistingPassword();
      _checkBiometricAvailability();
    });
  }

  Future<void> _checkExistingPassword() async {
    final authState = ref.read(authProvider);
    // If master password already exists, redirect to login
    if (authState.hasMasterPassword && mounted) {
      context.go(RouteNames.login);
    }
  }

  @override
  void dispose() {
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _checkBiometricAvailability() async {
    final authState = ref.read(authProvider);
    if (authState.isBiometricAvailable) {
      setState(() {
        _isFaceIdEnabled = authState.isBiometricEnabled;
      });
    }
  }

  Future<void> _handleSecureAccount() async {
    final password = _passwordController.text;
    if (password.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please enter a master password'),
          backgroundColor: AppColors.error,
        ),
      );
      return;
    }

    // Validate password strength
    if (password.length < 12) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Password must be at least 12 characters'),
          backgroundColor: AppColors.error,
        ),
      );
      return;
    }

    // Set master password
    final authNotifier = ref.read(authProvider.notifier);
    final success = await authNotifier.setMasterPassword(password);

    if (success) {
      // Enable biometric if requested
      if (_isFaceIdEnabled) {
        await authNotifier.setBiometricEnabled(true);
      }

      // Navigate to dashboard
      if (mounted) {
        context.go(RouteNames.dashboard);
      }
    } else {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              ref.read(authProvider).error ?? 'Failed to set master password',
            ),
            backgroundColor: AppColors.error,
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final authState = ref.watch(authProvider);

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: AppColors.textPrimary),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: Text(
          'Security',
          style: AppTextStyles.appName.copyWith(fontSize: 20),
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 32),
              // Heading
              Text(
                'Secure Your Account',
                style: AppTextStyles.heading,
              ),
              const SizedBox(height: 12),
              // Description
              Text(
                'Your financial data is encrypted and accessible only by you. Create a master password to get started.',
                style: AppTextStyles.bodySecondary,
              ),
              const SizedBox(height: 40),
              // Master Password Input
              MasterPasswordInput(
                controller: _passwordController,
              ),
              const SizedBox(height: 32),
              // Face ID Toggle Card (only show if biometric is available)
              if (authState.isBiometricAvailable)
                FaceIdToggleCard(
                  isEnabled: _isFaceIdEnabled,
                  onChanged: (value) {
                    setState(() {
                      _isFaceIdEnabled = value;
                    });
                  },
                ),
              const SizedBox(height: 24),
              // Encryption Info Card
              const EncryptionInfoCard(),
              const SizedBox(height: 40),
            ],
          ),
        ),
      ),
      bottomNavigationBar: Container(
        padding: const EdgeInsets.all(24),
        decoration: BoxDecoration(
          color: AppColors.backgroundDark,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.3),
              blurRadius: 10,
              offset: const Offset(0, -5),
            ),
          ],
        ),
        child: SafeArea(
          child: SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: authState.isLoading ? null : _handleSecureAccount,
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primaryBlue,
                foregroundColor: AppColors.textPrimary,
                padding: const EdgeInsets.symmetric(vertical: 18),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: authState.isLoading
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
                  : Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          'Secure My Account',
                          style: AppTextStyles.button,
                        ),
                        const SizedBox(width: 8),
                        const Icon(Icons.arrow_forward, size: 20),
                      ],
                    ),
            ),
          ),
        ),
      ),
    );
  }
}
