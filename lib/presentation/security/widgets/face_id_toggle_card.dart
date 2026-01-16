import 'package:flutter/material.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_text_styles.dart';

/// Face ID toggle card widget
class FaceIdToggleCard extends StatelessWidget {
  final bool isEnabled;
  final ValueChanged<bool> onChanged;

  const FaceIdToggleCard({
    super.key,
    required this.isEnabled,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.cardBackground,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          // Face ID Icon
          Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              color: AppColors.primaryBlue.withOpacity(0.2),
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.face,
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
                  'Face ID',
                  style: AppTextStyles.body.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  'Fast and secure login',
                  style: AppTextStyles.bodySecondary.copyWith(fontSize: 14),
                ),
              ],
            ),
          ),
          // Toggle Switch
          Switch(
            value: isEnabled,
            onChanged: onChanged,
            activeThumbColor: AppColors.primaryBlue,
          ),
        ],
      ),
    );
  }
}
