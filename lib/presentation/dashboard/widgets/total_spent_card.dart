import 'package:flutter/material.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_text_styles.dart';

/// Total spent this month card with budget progress
class TotalSpentCard extends StatelessWidget {
  const TotalSpentCard({super.key});

  @override
  Widget build(BuildContext context) {
    const totalSpent = 2450.00;
    const budget = 3800.00;
    final percentageUsed = (totalSpent / budget * 100).round();

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Container(
        padding: const EdgeInsets.all(24),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              AppColors.primaryBlue.withOpacity(0.2),
              AppColors.primaryBlue.withOpacity(0.1),
            ],
          ),
          borderRadius: BorderRadius.circular(20),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Top row: Label and SECURE badge
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Total spent this month',
                  style: AppTextStyles.bodySecondary.copyWith(fontSize: 14),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(
                    color: AppColors.success,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    'SECURE',
                    style: AppTextStyles.badge.copyWith(
                      color: AppColors.textPrimary,
                      fontSize: 10,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            // Amount
            Text(
              '\$${totalSpent.toStringAsFixed(2)}',
              style: AppTextStyles.heading.copyWith(
                fontSize: 36,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 20),
            // Budget progress
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'BUDGET: \$${budget.toStringAsFixed(2)}',
                  style: AppTextStyles.bodySecondary.copyWith(fontSize: 12),
                ),
                Text(
                  '$percentageUsed% USED',
                  style: AppTextStyles.body.copyWith(
                    color: AppColors.primaryBlue,
                    fontWeight: FontWeight.w600,
                    fontSize: 12,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            // Progress bar
            ClipRRect(
              borderRadius: BorderRadius.circular(4),
              child: LinearProgressIndicator(
                value: totalSpent / budget,
                backgroundColor: AppColors.cardBackground,
                valueColor: const AlwaysStoppedAnimation<Color>(
                  AppColors.primaryBlue,
                ),
                minHeight: 8,
              ),
            ),
            const SizedBox(height: 16),
            // Graph button
            Align(
              alignment: Alignment.centerRight,
              child: Container(
                width: 48,
                height: 48,
                decoration: BoxDecoration(
                  color: AppColors.primaryBlue,
                  shape: BoxShape.circle,
                ),
                child: IconButton(
                  icon: const Icon(
                    Icons.show_chart,
                    color: AppColors.textPrimary,
                  ),
                  onPressed: () {
                    // TODO: Navigate to insights/analytics
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
