import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fl_chart/fl_chart.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../core/providers/analytics_provider.dart';
import '../../../core/providers/expense_provider.dart';

/// Spending trend card with line graph
class SpendingTrendCard extends ConsumerWidget {
  const SpendingTrendCard({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final now = DateTime.now();
    final startOfMonth = DateTime(now.year, now.month, 1);
    final endOfMonth = DateTime(now.year, now.month + 1, 0);
    
    // Get spending trend for current month (weekly grouping)
    final trendAsync = ref.watch(
      spendingTrendProvider({
        'startDate': startOfMonth,
        'endDate': endOfMonth,
        'groupBy': 'week',
      }),
    );

    // Get last month for comparison
    final lastMonth = DateTime(now.year, now.month - 1, 1);
    final lastMonthEnd = DateTime(now.year, now.month, 0);
    final lastMonthTotalAsync = ref.watch(
      FutureProvider<double>((ref) async {
        final repo = ref.watch(expenseRepositoryProvider);
        return await repo.getTotalSpending(
          startDate: lastMonth,
          endDate: lastMonthEnd,
        );
      }),
    );

    return trendAsync.when(
      data: (trendData) {
        return lastMonthTotalAsync.when(
          data: (lastMonthTotal) {
            final currentTotal = trendData.fold<double>(
              0.0,
              (sum, item) => sum + (item['amount'] as double),
            );
            
            final percentageChange = lastMonthTotal > 0
                ? ((currentTotal - lastMonthTotal) / lastMonthTotal * 100)
                : 0.0;
            
            // Convert trend data to FlSpot format
            final spots = trendData.asMap().entries.map((entry) {
              return FlSpot(
                entry.key.toDouble(),
                entry.value['amount'] as double,
              );
            }).toList();

            if (spots.isEmpty) {
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
                        color: isDark
                            ? AppColors.textSecondary
                            : Colors.grey.shade700,
                      ),
                    ),
                  ),
                ),
              );
            }

            final maxY = spots.map((s) => s.y).reduce((a, b) => a > b ? a : b) * 1.2;
            final maxX = spots.isNotEmpty ? (spots.length - 1).toDouble() : 6.0;

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
                    // Title and trend indicator
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'SPENDING TREND',
                          style: AppTextStyles.bodySecondary.copyWith(
                            fontSize: 12,
                            letterSpacing: 1.2,
                            color: isDark
                                ? AppColors.textSecondary
                                : Colors.grey.shade700,
                          ),
                        ),
                        Row(
                          children: [
                            Icon(
                              percentageChange >= 0
                                  ? Icons.trending_up
                                  : Icons.trending_down,
                              color: percentageChange >= 0
                                  ? Colors.red
                                  : AppColors.success,
                              size: 20,
                            ),
                            const SizedBox(width: 4),
                            Text(
                              '${percentageChange >= 0 ? '+' : ''}${percentageChange.toStringAsFixed(1)}% vs last month',
                              style: AppTextStyles.bodySecondary.copyWith(
                                color: percentageChange >= 0
                                    ? Colors.red
                                    : AppColors.success,
                                fontSize: 12,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                    const SizedBox(height: 24),
                    // Line Chart
                    SizedBox(
                      height: 200,
                      child: LineChart(
                        LineChartData(
                          gridData: FlGridData(
                            show: true,
                            drawVerticalLine: false,
                            horizontalInterval: maxY / 4,
                            getDrawingHorizontalLine: (value) {
                              return FlLine(
                                color: (isDark
                                        ? AppColors.cardBackground
                                        : Colors.grey.shade200)
                                    .withOpacity(0.3),
                                strokeWidth: 1,
                              );
                            },
                          ),
                          titlesData: FlTitlesData(
                            show: true,
                            rightTitles: const AxisTitles(
                              sideTitles: SideTitles(showTitles: false),
                            ),
                            topTitles: const AxisTitles(
                              sideTitles: SideTitles(showTitles: false),
                            ),
                            bottomTitles: AxisTitles(
                              sideTitles: SideTitles(
                                showTitles: true,
                                reservedSize: 30,
                                interval: 1,
                                getTitlesWidget: (value, meta) {
                                  if (value.toInt() < trendData.length) {
                                    final period = trendData[value.toInt()]['period'] as String;
                                    return Padding(
                                      padding: const EdgeInsets.only(top: 8),
                                      child: Text(
                                        period.length > 8
                                            ? period.substring(0, 8)
                                            : period,
                                        style: AppTextStyles.bodySecondary.copyWith(
                                          fontSize: 10,
                                          color: isDark
                                              ? AppColors.textSecondary
                                              : Colors.grey.shade700,
                                        ),
                                      ),
                                    );
                                  }
                                  return const Text('');
                                },
                              ),
                            ),
                            leftTitles: AxisTitles(
                              sideTitles: SideTitles(
                                showTitles: true,
                                reservedSize: 40,
                                interval: maxY / 4,
                                getTitlesWidget: (value, meta) {
                                  return Text(
                                    '\$${value.toInt()}',
                                    style: AppTextStyles.bodySecondary.copyWith(
                                      fontSize: 10,
                                      color: isDark
                                          ? AppColors.textSecondary
                                          : Colors.grey.shade700,
                                    ),
                                  );
                                },
                              ),
                            ),
                          ),
                          borderData: FlBorderData(show: false),
                          minX: 0,
                          maxX: maxX,
                          minY: 0,
                          maxY: maxY,
                          lineBarsData: [
                            LineChartBarData(
                              spots: spots,
                              isCurved: true,
                              color: AppColors.primaryBlue,
                              barWidth: 3,
                              isStrokeCapRound: true,
                              dotData: FlDotData(show: false),
                              belowBarData: BarAreaData(
                                show: true,
                                color: AppColors.primaryBlue.withOpacity(0.1),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
          loading: () => _buildLoadingCard(isDark),
          error: (_, __) => _buildErrorCard(isDark),
        );
      },
      loading: () => _buildLoadingCard(isDark),
      error: (_, __) => _buildErrorCard(isDark),
    );
  }

  Widget _buildLoadingCard(bool isDark) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: isDark ? AppColors.cardBackground : Colors.white,
          borderRadius: BorderRadius.circular(16),
        ),
        child: const Center(child: CircularProgressIndicator()),
      ),
    );
  }

  Widget _buildErrorCard(bool isDark) {
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
            'Failed to load trend data',
            style: AppTextStyles.bodySecondary.copyWith(
              color: isDark ? AppColors.textSecondary : Colors.grey.shade700,
            ),
          ),
        ),
      ),
    );
  }
}
