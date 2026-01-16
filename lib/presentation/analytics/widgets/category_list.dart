import 'package:flutter/material.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_text_styles.dart';

/// Category list with detailed breakdown
class CategoryList extends StatelessWidget {
  const CategoryList({super.key});

  final List<Map<String, dynamic>> _categories = const [
    {
      'name': 'Shopping',
      'icon': Icons.shopping_bag,
      'color': AppColors.primaryBlue,
      'percentage': 40.0,
      'amount': 1700.0,
    },
    {
      'name': 'Dining Out',
      'icon': Icons.restaurant,
      'color': Colors.orange,
      'percentage': 25.0,
      'amount': 1062.50,
    },
    {
      'name': 'Housing',
      'icon': Icons.home,
      'color': Colors.green,
      'percentage': 20.0,
      'amount': 850.0,
    },
    {
      'name': 'Transport',
      'icon': Icons.directions_bus,
      'color': Colors.purple,
      'percentage': 15.0,
      'amount': 637.50,
    },
  ];

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Container(
        decoration: BoxDecoration(
          color: isDark ? AppColors.cardBackground : Colors.white,
          borderRadius: BorderRadius.circular(16),
        ),
        child: Column(
          children: List.generate(
            _categories.length,
            (index) {
              final category = _categories[index];
              final isLast = index == _categories.length - 1;

              return Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(16),
                    child: Row(
                      children: [
                        // Icon
                        Container(
                          width: 48,
                          height: 48,
                          decoration: BoxDecoration(
                            color: (category['color'] as Color).withOpacity(0.2),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Icon(
                            category['icon'] as IconData,
                            color: category['color'] as Color,
                            size: 24,
                          ),
                        ),
                        const SizedBox(width: 16),
                        // Category name
                        Expanded(
                          child: Text(
                            category['name'] as String,
                            style: AppTextStyles.body.copyWith(
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                        // Percentage and amount
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            Text(
                              '${category['percentage']}%',
                              style: AppTextStyles.body.copyWith(
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              '\$${(category['amount'] as double).toStringAsFixed(2)}',
                              style: AppTextStyles.bodySecondary.copyWith(
                                fontSize: 14,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  if (!isLast)
                    Divider(
                      height: 1,
                      thickness: 1,
                      color: isDark
                          ? AppColors.cardBackground.withOpacity(0.5)
                          : Colors.grey.shade200,
                      indent: 80,
                    ),
                ],
              );
            },
          ),
        ),
      ),
    );
  }
}
