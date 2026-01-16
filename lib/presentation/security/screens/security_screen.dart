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
import '../../../core/providers/user_profile_provider.dart';

/// Security screen for master password setup
class SecurityScreen extends ConsumerStatefulWidget {
  const SecurityScreen({super.key});

  @override
  ConsumerState<SecurityScreen> createState() => _SecurityScreenState();
}

class _SecurityScreenState extends ConsumerState<SecurityScreen> {
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _nameController = TextEditingController();
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
    // Wait a bit for auth state to load
    await Future.delayed(const Duration(milliseconds: 300));
    final authState = ref.read(authProvider);
    // If master password already exists, show a message and redirect to login
    if (authState.hasMasterPassword && mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            'Master password already exists. Please login or reset it first.',
          ),
          backgroundColor: AppColors.error,
          duration: Duration(seconds: 3),
        ),
      );
      // Small delay before redirect
      await Future.delayed(const Duration(milliseconds: 500));
      if (mounted) {
        context.go(RouteNames.login);
      }
    }
  }

  @override
  void dispose() {
    _passwordController.dispose();
    _nameController.dispose();
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
    final password = _passwordController.text.trim();
    final name = _nameController.text.trim();

    // Validate name
    if (name.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please enter your name'),
          backgroundColor: AppColors.error,
        ),
      );
      return;
    }

    if (name.length < 2) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Name must be at least 2 characters'),
          backgroundColor: AppColors.error,
        ),
      );
      return;
    }

    // Validate password
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

    // Check if we're setting password after reset
    final authState = ref.read(authProvider);
    final isAfterReset = !authState.hasMasterPassword;
    
    // Set master password (force if after reset)
    final authNotifier = ref.read(authProvider.notifier);
    final success = await authNotifier.setMasterPassword(password, force: isAfterReset);

    if (success) {
      // Save user name to profile
      final userProfileNotifier = ref.read(userProfileProvider.notifier);
      await userProfileNotifier.updateName(name);

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
                'Your financial data is encrypted and accessible only by you. Create your account to get started.',
                style: AppTextStyles.bodySecondary,
              ),
              const SizedBox(height: 40),
              // Name Input
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Your Name',
                    style: AppTextStyles.body.copyWith(
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const SizedBox(height: 12),
                  TextField(
                    controller: _nameController,
                    style: AppTextStyles.body,
                    decoration: InputDecoration(
                      hintText: 'Enter your name',
                      hintStyle: AppTextStyles.bodySecondary,
                      filled: true,
                      fillColor: AppColors.cardBackground,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide.none,
                      ),
                      contentPadding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 16,
                      ),
                    ),
                    textCapitalization: TextCapitalization.words,
                  ),
                ],
              ),
              const SizedBox(height: 24),
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
