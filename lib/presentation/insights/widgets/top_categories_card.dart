import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_text_styles.dart';

/// Top categories card with donut chart
class TopCategoriesCard extends StatelessWidget {
  const TopCategoriesCard({super.key});

  @override
  Widget build(BuildContext context) {
    // Category data
    final categories = [
      {'name': 'Dining', 'percentage': 40.0, 'color': AppColors.primaryBlue},
      {'name': 'Shopping', 'percentage': 25.0, 'color': Colors.purple},
      {'name': 'Entertainment', 'percentage': 20.0, 'color': Colors.pink},
      {'name': 'Other', 'percentage': 15.0, 'color': Colors.grey.shade700},
    ];

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: AppColors.cardBackground,
          borderRadius: BorderRadius.circular(16),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Top Categories',
              style: AppTextStyles.heading.copyWith(fontSize: 18),
            ),
            const SizedBox(height: 20),
            Row(
              children: [
                // Donut Chart with center text
                SizedBox(
                  width: 150,
                  height: 150,
                  child: Stack(
                    alignment: Alignment.center,
                    children: [
                      PieChart(
                        PieChartData(
                          sectionsSpace: 2,
                          centerSpaceRadius: 50,
                          sections: categories.map((category) {
                            return PieChartSectionData(
                              value: category['percentage'] as double,
                              color: category['color'] as Color,
                              radius: 50,
                              title: '',
                            );
                          }).toList(),
                        ),
                      ),
                      Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            'Total',
                            style: AppTextStyles.bodySecondary.copyWith(
                              fontSize: 12,
                            ),
                          ),
                          Text(
                            '100%',
                            style: AppTextStyles.body.copyWith(
                              fontWeight: FontWeight.w600,
                              fontSize: 14,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 20),
                // Legend
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: categories.map((category) {
                      return Padding(
                        padding: const EdgeInsets.only(bottom: 12),
                        child: Row(
                          children: [
                            Container(
                              width: 12,
                              height: 12,
                              decoration: BoxDecoration(
                                color: category['color'] as Color,
                                shape: BoxShape.circle,
                              ),
                            ),
                            const SizedBox(width: 8),
                            Expanded(
                              child: Text(
                                category['name'] as String,
                                style: AppTextStyles.body.copyWith(
                                  fontSize: 14,
                                ),
                              ),
                            ),
                            Text(
                              '${category['percentage']}%',
                              style: AppTextStyles.body.copyWith(
                                fontWeight: FontWeight.w600,
                                fontSize: 14,
                              ),
                            ),
                          ],
                        ),
                      );
                    }).toList(),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
