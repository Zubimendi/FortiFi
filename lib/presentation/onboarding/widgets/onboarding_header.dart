import 'package:flutter/material.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../core/constants/app_constants.dart';

/// Header widget with shield icon and app name
class OnboardingHeader extends StatelessWidget {
  const OnboardingHeader({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(24, 16, 24, 0),
      child: Row(
        children: [
          // Shield icon with padlock
          Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              color: AppColors.cardBackground,
              shape: BoxShape.circle,
            ),
            child: Stack(
              alignment: Alignment.center,
              children: [
                // Shield background
                Icon(
                  Icons.shield,
                  color: AppColors.textPrimary,
                  size: 32,
                ),
                // Padlock overlay
                Positioned(
                  bottom: 4,
                  child: Container(
                    width: 16,
                    height: 16,
                    decoration: BoxDecoration(
                      color: AppColors.primaryBlue,
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      Icons.lock,
                      color: AppColors.textPrimary,
                      size: 10,
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 12),
          // App name
          Text(
            AppConstants.appName,
            style: AppTextStyles.appName,
          ),
        ],
      ),
    );
  }
}
