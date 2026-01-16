import 'package:flutter/material.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_text_styles.dart';

/// Settings profile header with avatar and account info
class SettingsProfileHeader extends StatelessWidget {
  const SettingsProfileHeader({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Center(
      child: Column(
        children: [
          // Profile Picture
          Container(
            width: 80,
            height: 80,
            decoration: BoxDecoration(
              color: isDark
                  ? AppColors.cardBackground
                  : Colors.grey.shade200,
              shape: BoxShape.circle,
            ),
            child: Icon(
              Icons.account_balance_wallet,
              color: AppColors.primaryBlue,
              size: 40,
            ),
          ),
          const SizedBox(height: 16),
          // Account Name
          Text(
            'FortiFi',
            style: AppTextStyles.heading.copyWith(
              fontSize: 24,
              color: isDark ? AppColors.textPrimary : Colors.black87,
            ),
          ),
          const SizedBox(height: 4),
          // Account Type
          Text(
            'Personal Account',
            style: AppTextStyles.bodySecondary.copyWith(
              fontSize: 14,
              color: isDark ? AppColors.textSecondary : Colors.grey.shade700,
            ),
          ),
        ],
      ),
    );
  }
}
