import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_text_styles.dart';

/// Category donut chart with total spend in center
class CategoryDonutChart extends StatelessWidget {
  const CategoryDonutChart({super.key});

  @override
  Widget build(BuildContext context) {
    // Category data
    final categories = [
      {'name': 'Shopping', 'amount': 1700.0, 'color': AppColors.primaryBlue},
      {'name': 'Dining Out', 'amount': 1062.50, 'color': Colors.orange},
      {'name': 'Housing', 'amount': 850.0, 'color': Colors.green},
      {'name': 'Transport', 'amount': 637.50, 'color': Colors.purple},
    ];

    final totalSpend = categories.fold<double>(
      0,
      (sum, cat) => sum + (cat['amount'] as double),
    );

    return Center(
      child: SizedBox(
        width: 280,
        height: 280,
        child: Stack(
          alignment: Alignment.center,
          children: [
            PieChart(
              PieChartData(
                sectionsSpace: 2,
                centerSpaceRadius: 100,
                sections: categories.map((category) {
                  return PieChartSectionData(
                    value: category['amount'] as double,
                    color: category['color'] as Color,
                    radius: 80,
                    title: '',
                  );
                }).toList(),
              ),
            ),
            // Center text
            Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  'Total Spend',
                  style: AppTextStyles.bodySecondary.copyWith(
                    fontSize: 12,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  '\$${totalSpend.toStringAsFixed(0)}',
                  style: AppTextStyles.heading.copyWith(
                    fontSize: 32,
                    fontWeight: FontWeight.bold,
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
