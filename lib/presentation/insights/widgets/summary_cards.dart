import 'package:flutter/material.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_text_styles.dart';

/// Summary cards widget (Top Spending and Savings Rate)
class SummaryCards extends StatelessWidget {
  const SummaryCards({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Row(
        children: [
          // Top Spending Card
          Expanded(
            child: _SummaryCard(
              icon: Icons.restaurant,
              iconColor: Colors.orange,
              title: 'Top Spending',
              mainText: 'Dining',
              subText: '\$1,700 SPENT',
              subTextColor: AppColors.textSecondary,
            ),
          ),
          const SizedBox(width: 12),
          // Savings Rate Card
          Expanded(
            child: _SummaryCard(
              icon: Icons.savings,
              iconColor: AppColors.success,
              title: 'Savings Rate',
              mainText: '+18.5%',
              subText: 'ABOVE TARGET',
              subTextColor: AppColors.success,
            ),
          ),
        ],
      ),
    );
  }
}

class _SummaryCard extends StatelessWidget {
  final IconData icon;
  final Color iconColor;
  final String title;
  final String mainText;
  final String subText;
  final Color subTextColor;

  const _SummaryCard({
    required this.icon,
    required this.iconColor,
    required this.title,
    required this.mainText,
    required this.subText,
    required this.subTextColor,
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
          Icon(
            icon,
            color: iconColor,
            size: 24,
          ),
          const SizedBox(height: 12),
          Text(
            title,
            style: AppTextStyles.bodySecondary.copyWith(
              fontSize: 12,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            mainText,
            style: AppTextStyles.heading.copyWith(
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            subText,
            style: AppTextStyles.bodySecondary.copyWith(
              fontSize: 11,
              color: subTextColor,
            ),
          ),
        ],
      ),
    );
  }
}
