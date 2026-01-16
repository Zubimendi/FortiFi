import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:go_router/go_router.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../core/utils/route_names.dart';
import '../../../core/providers/analytics_provider.dart';

/// Top categories card with donut chart
class TopCategoriesCard extends ConsumerWidget {
  const TopCategoriesCard({super.key});

  Color _getCategoryColor(String categoryName) {
    switch (categoryName.toLowerCase()) {
      case 'dining':
        return AppColors.primaryBlue;
      case 'shopping':
        return Colors.purple;
      case 'entertainment':
      case 'fun':
        return Colors.pink;
      case 'groceries':
        return Colors.orange;
      case 'transport':
        return Colors.blue;
      case 'housing':
        return Colors.green;
      default:
        return Colors.grey.shade700;
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final now = DateTime.now();
    final startOfMonth = DateTime(now.year, now.month, 1);
    final endOfMonth = DateTime(now.year, now.month + 1, 0);
    
    final breakdownAsync = ref.watch(
      categoryBreakdownProvider(AnalyticsDateRange(
        startDate: startOfMonth,
        endDate: endOfMonth,
      )),
    );

    final isDark = Theme.of(context).brightness == Brightness.dark;

    return breakdownAsync.when(
      data: (breakdown) {
        if (breakdown.isEmpty) {
          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: isDark ? AppColors.cardBackground : Colors.white,
                borderRadius: BorderRadius.circular(16),
              ),
              child: Center(
                child: Text(
                  'No spending data available',
                  style: AppTextStyles.bodySecondary.copyWith(
                    color: isDark ? AppColors.textSecondary : Colors.grey.shade700,
                  ),
                ),
              ),
            ),
          );
        }

        // Take top 4 categories
        final topCategories = breakdown.take(4).toList();
        final total = breakdown.fold<double>(
          0.0,
          (sum, item) => sum + (item['amount'] as double),
        );

        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: isDark ? AppColors.cardBackground : Colors.white,
              borderRadius: BorderRadius.circular(16),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Top Categories',
                      style: AppTextStyles.heading.copyWith(
                        fontSize: 18,
                        color: isDark ? AppColors.textPrimary : Colors.black87,
                      ),
                    ),
                    TextButton(
                      onPressed: () => context.push(RouteNames.categoryAnalysis),
                      child: Text(
                        'View All',
                        style: AppTextStyles.link.copyWith(fontSize: 14),
                      ),
                    ),
                  ],
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
                              sections: topCategories.map((item) {
                                final percentage = item['percentage'] as double;
                                final category = item['category'] as dynamic;
                                return PieChartSectionData(
                                  value: percentage,
                                  color: _getCategoryColor(category.name),
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
                                  color: isDark
                                      ? AppColors.textSecondary
                                      : Colors.grey.shade700,
                                ),
                              ),
                              Text(
                                '\$${total.toStringAsFixed(0)}',
                                style: AppTextStyles.body.copyWith(
                                  fontWeight: FontWeight.w600,
                                  fontSize: 14,
                                  color: isDark
                                      ? AppColors.textPrimary
                                      : Colors.black87,
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
                        children: topCategories.map((item) {
                          final category = item['category'] as dynamic;
                          final percentage = item['percentage'] as double;
                          return Padding(
                            padding: const EdgeInsets.only(bottom: 12),
                            child: Row(
                              children: [
                                Container(
                                  width: 12,
                                  height: 12,
                                  decoration: BoxDecoration(
                                    color: _getCategoryColor(category.name),
                                    shape: BoxShape.circle,
                                  ),
                                ),
                                const SizedBox(width: 8),
                                Expanded(
                                  child: Text(
                                    category.name,
                                    style: AppTextStyles.body.copyWith(
                                      fontSize: 14,
                                      color: isDark
                                          ? AppColors.textPrimary
                                          : Colors.black87,
                                    ),
                                  ),
                                ),
                                Text(
                                  '${percentage.toStringAsFixed(1)}%',
                                  style: AppTextStyles.body.copyWith(
                                    fontWeight: FontWeight.w600,
                                    fontSize: 14,
                                    color: isDark
                                        ? AppColors.textPrimary
                                        : Colors.black87,
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
      },
      loading: () => Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24),
        child: Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: isDark ? AppColors.cardBackground : Colors.white,
            borderRadius: BorderRadius.circular(16),
          ),
          child: const Center(child: CircularProgressIndicator()),
        ),
      ),
      error: (_, __) => Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24),
        child: Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: isDark ? AppColors.cardBackground : Colors.white,
            borderRadius: BorderRadius.circular(16),
          ),
          child: Center(
            child: Text(
              'Failed to load category data',
              style: AppTextStyles.bodySecondary.copyWith(
                color: isDark ? AppColors.textSecondary : Colors.grey.shade700,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
