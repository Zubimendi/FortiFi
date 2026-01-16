import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../core/constants/app_constants.dart';
import '../../../core/utils/route_names.dart';

/// CTA section with marketing text, Get Started button, and Sign In link
class OnboardingCtaSection extends StatelessWidget {
  const OnboardingCtaSection({super.key});

  void _handleGetStarted(BuildContext context) {
    // Navigate to master password setup
    context.push(RouteNames.masterPasswordSetup);
  }

  void _handleSignIn(BuildContext context) {
    // Navigate to login screen
    context.push(RouteNames.login);
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Heading
          Text(
            AppConstants.onboardingHeading,
            style: AppTextStyles.heading,
          ),
          const SizedBox(height: 16),
          // Description
          Text(
            AppConstants.onboardingDescription,
            style: AppTextStyles.bodySecondary,
          ),
          const SizedBox(height: 48),
          // Get Started button
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: () => _handleGetStarted(context),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primaryBlue,
                foregroundColor: AppColors.textPrimary,
                padding: const EdgeInsets.symmetric(vertical: 18),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: Text(
                AppConstants.getStartedButton,
                style: AppTextStyles.button,
              ),
            ),
          ),
          const SizedBox(height: 32),
          // Sign In link
          Center(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  AppConstants.signInText,
                  style: AppTextStyles.bodySecondary,
                ),
                const SizedBox(width: 4),
                GestureDetector(
                  onTap: () => _handleSignIn(context),
                  child: Text(
                    AppConstants.signInLink,
                    style: AppTextStyles.link,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
