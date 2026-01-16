import 'package:flutter/material.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_text_styles.dart';
import 'activity_item.dart';

/// Recent activity section with transaction list
class RecentActivitySection extends StatelessWidget {
  const RecentActivitySection({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Section header
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Recent Activity',
                style: AppTextStyles.heading.copyWith(fontSize: 22),
              ),
              IconButton(
                icon: const Icon(
                  Icons.tune,
                  color: AppColors.textSecondary,
                ),
                onPressed: () {
                  // TODO: Show filter options
                },
              ),
            ],
          ),
          const SizedBox(height: 16),
          // Activity items
          Column(
            children: [
              ActivityItem(
                merchant: 'Starbucks Coffee',
                amount: 12.50,
                date: DateTime.now(),
                icon: Icons.local_cafe,
                iconColor: Colors.brown,
              ),
              const SizedBox(height: 12),
              ActivityItem(
                merchant: 'Whole Foods Market',
                amount: 142.00,
                date: DateTime.now().subtract(const Duration(days: 1)),
                icon: Icons.shopping_bag,
                iconColor: Colors.green,
              ),
              const SizedBox(height: 12),
              ActivityItem(
                merchant: 'Apple Store Online',
                amount: 1299.00,
                date: DateTime.now().subtract(const Duration(days: 2)),
                icon: Icons.shopping_cart,
                iconColor: Colors.grey.shade800,
              ),
            ],
          ),
        ],
      ),
    );
  }
}
