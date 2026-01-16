import 'package:flutter/material.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_text_styles.dart';

/// Individual budget card widget
class BudgetCard extends StatelessWidget {
  final String category;
  final IconData icon;
  final Color iconColor;
  final double spent;
  final double budget;
  final Color progressColor;

  const BudgetCard({
    super.key,
    required this.category,
    required this.icon,
    required this.iconColor,
    required this.spent,
    required this.budget,
    required this.progressColor,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.cardBackground,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Icon
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
              size: 24,
            ),
          ),
          const SizedBox(height: 12),
          // Category name
          Text(
            category,
            style: AppTextStyles.body.copyWith(
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 4),
          // Amount
          Text(
            '\$${spent.toStringAsFixed(0)} / \$${budget.toStringAsFixed(0)}',
            style: AppTextStyles.bodySecondary.copyWith(fontSize: 14),
          ),
          const SizedBox(height: 12),
          // Progress bar
          ClipRRect(
            borderRadius: BorderRadius.circular(4),
            child: LinearProgressIndicator(
              value: spent / budget,
              backgroundColor: AppColors.cardBackground.withOpacity(0.5),
              valueColor: AlwaysStoppedAnimation<Color>(progressColor),
              minHeight: 6,
            ),
          ),
        ],
      ),
    );
  }
}
