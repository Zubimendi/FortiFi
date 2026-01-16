import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../widgets/master_password_input.dart';
import '../widgets/face_id_toggle_card.dart';
import '../widgets/encryption_info_card.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../core/utils/route_names.dart';

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
  void dispose() {
    _passwordController.dispose();
    super.dispose();
  }

  void _handleSecureAccount() {
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

    // TODO: Save master password (encrypted) to secure storage
    // For now, navigate to dashboard
    context.go(RouteNames.dashboard);
  }

  @override
  Widget build(BuildContext context) {
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
              // Face ID Toggle Card
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
              onPressed: _handleSecureAccount,
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primaryBlue,
                foregroundColor: AppColors.textPrimary,
                padding: const EdgeInsets.symmetric(vertical: 18),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: Row(
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
