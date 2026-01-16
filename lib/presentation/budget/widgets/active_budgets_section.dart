import 'package:flutter/material.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_text_styles.dart';

/// Active Budgets section header
class ActiveBudgetsSectionHeader extends StatelessWidget {
  const ActiveBudgetsSectionHeader({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            'Active Budgets',
            style: AppTextStyles.heading.copyWith(fontSize: 22),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              color: AppColors.primaryBlue,
              borderRadius: BorderRadius.circular(8),
            ),
            child: Text(
              'LIVE UPDATES',
              style: AppTextStyles.badge.copyWith(
                color: AppColors.textPrimary,
                fontSize: 10,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
