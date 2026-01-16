import 'package:flutter/material.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../core/constants/app_constants.dart';

/// Hero card with padlock icon, currency symbols, and encryption badge
class EncryptionHeroCard extends StatelessWidget {
  const EncryptionHeroCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 32),
      child: Container(
        padding: const EdgeInsets.all(32),
        decoration: BoxDecoration(
          color: AppColors.cardBackground,
          borderRadius: BorderRadius.circular(24),
        ),
        child: Column(
          children: [
            // Currency symbols and padlock row
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                // Dollar sign
                Text(
                  '\$',
                  style: AppTextStyles.heading.copyWith(
                    fontSize: 48,
                    fontWeight: FontWeight.w300,
                  ),
                ),
                // Large padlock icon
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: AppColors.primaryBlue.withOpacity(0.2),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    Icons.lock,
                    color: AppColors.primaryBlue,
                    size: 64,
                  ),
                ),
                // Pound sign
                Text(
                  '£',
                  style: AppTextStyles.heading.copyWith(
                    fontSize: 48,
                    fontWeight: FontWeight.w300,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 24),
            // Encryption badge
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              decoration: BoxDecoration(
                color: AppColors.primaryBlue.withOpacity(0.15),
                borderRadius: BorderRadius.circular(20),
                border: Border.all(
                  color: AppColors.primaryBlue.withOpacity(0.3),
                  width: 1,
                ),
              ),
              child: Text(
                AppConstants.encryptionBadge,
                style: AppTextStyles.badge,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
