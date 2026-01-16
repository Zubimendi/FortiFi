import 'package:flutter/material.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_text_styles.dart';

/// End-to-End Encryption information card
class EncryptionInfoCard extends StatelessWidget {
  const EncryptionInfoCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppColors.primaryBlue.withOpacity(0.15),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: AppColors.primaryBlue.withOpacity(0.3),
          width: 1,
        ),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Shield Icon
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: AppColors.primaryBlue.withOpacity(0.2),
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.verified,
              color: AppColors.primaryBlue,
              size: 24,
            ),
          ),
          const SizedBox(width: 16),
          // Text Content
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'End-to-End Encryption',
                  style: AppTextStyles.body.copyWith(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  'We use AES-256 military-grade encryption. Your master password is never stored on our servers.',
                  style: AppTextStyles.bodySecondary.copyWith(fontSize: 14),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
