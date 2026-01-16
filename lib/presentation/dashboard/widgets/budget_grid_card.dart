import 'package:flutter/material.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_text_styles.dart';

/// Budget grid card for monthly budgets section
class BudgetGridCard extends StatelessWidget {
  final String category;
  final IconData icon;
  final Color iconColor;
  final double? spent;
  final double? limit;
  final bool isAddNew;

  const BudgetGridCard({
    super.key,
    required this.category,
    required this.icon,
    required this.iconColor,
    this.spent,
    this.limit,
    this.isAddNew = false,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final percentage = isAddNew
        ? 0.0
        : ((spent ?? 0) / (limit ?? 1) * 100).round();

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: isDark ? AppColors.cardBackground : Colors.white,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Top row: Icon and percentage
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  color: iconColor.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Icon(
                  icon,
                  color: iconColor,
                  size: 20,
                ),
              ),
              if (!isAddNew)
                Text(
                  '$percentage%',
                  style: AppTextStyles.body.copyWith(
                    fontWeight: FontWeight.w600,
                    fontSize: 14,
                  ),
                ),
            ],
          ),
          const SizedBox(height: 12),
          // Category name
          Text(
            category,
            style: AppTextStyles.body.copyWith(
              fontWeight: FontWeight.w600,
              fontSize: 14,
            ),
          ),
          if (!isAddNew) ...[
            const SizedBox(height: 8),
            // Amount
            Text(
              '\$${spent?.toStringAsFixed(0) ?? '0'}/${limit?.toStringAsFixed(0) ?? '0'}',
              style: AppTextStyles.bodySecondary.copyWith(fontSize: 12),
            ),
            const SizedBox(height: 12),
            // Progress bar
            ClipRRect(
              borderRadius: BorderRadius.circular(4),
              child: LinearProgressIndicator(
                value: spent! / limit!,
                backgroundColor: isDark
                    ? AppColors.cardBackground.withOpacity(0.5)
                    : Colors.grey.shade200,
                valueColor: AlwaysStoppedAnimation<Color>(iconColor),
                minHeight: 6,
              ),
            ),
          ],
        ],
      ),
    );
  }
}
