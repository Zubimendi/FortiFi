import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../core/utils/route_names.dart';
import '../../../core/providers/expense_provider.dart';

/// New total spent card with month, amount, percentage change, and view insights button
class TotalSpentCardNew extends ConsumerWidget {
  const TotalSpentCardNew({super.key});

  String _getCurrentMonth() {
    final now = DateTime.now();
    final months = [
      'JANUARY',
      'FEBRUARY',
      'MARCH',
      'APRIL',
      'MAY',
      'JUNE',
      'JULY',
      'AUGUST',
      'SEPTEMBER',
      'OCTOBER',
      'NOVEMBER',
      'DECEMBER'
    ];
    return months[now.month - 1];
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final totalSpendingAsync = ref.watch(totalSpendingThisMonthProvider);
    
    // Calculate percentage change (compare with last month)
    final now = DateTime.now();
    final lastMonth = DateTime(now.year, now.month - 1, 1);
    final lastMonthEnd = DateTime(now.year, now.month, 0);
    final lastMonthSpendingAsync = ref.watch(
      FutureProvider<double>((ref) async {
        final repo = ref.watch(expenseRepositoryProvider);
        return await repo.getTotalSpending(
          startDate: lastMonth,
          endDate: lastMonthEnd,
        );
      }),
    );

    return totalSpendingAsync.when(
      data: (totalSpent) {
        return lastMonthSpendingAsync.when(
          data: (lastMonthSpent) {
            final percentageChange = lastMonthSpent > 0
                ? ((totalSpent - lastMonthSpent) / lastMonthSpent * 100)
                : 0.0;
            
            return _buildCard(
              context,
              isDark,
              totalSpent,
              percentageChange,
            );
          },
          loading: () => _buildCard(context, isDark, totalSpent, 0.0),
          error: (_, __) => _buildCard(context, isDark, totalSpent, 0.0),
        );
      },
      loading: () => _buildCard(context, isDark, 0.0, 0.0),
      error: (_, __) => _buildCard(context, isDark, 0.0, 0.0),
    );
  }

  Widget _buildCard(
    BuildContext context,
    bool isDark,
    double totalSpent,
    double percentageChange,
  ) {

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Container(
        padding: const EdgeInsets.all(24),
        decoration: BoxDecoration(
          color: isDark ? AppColors.cardBackground : Colors.white,
          borderRadius: BorderRadius.circular(20),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Title
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'TOTAL SPENT • ${_getCurrentMonth()}',
                  style: AppTextStyles.bodySecondary.copyWith(
                    fontSize: 12,
                    letterSpacing: 1.2,
                  ),
                ),
                Row(
                  children: [
                    Icon(
                      percentageChange >= 0
                          ? Icons.trending_up
                          : Icons.trending_down,
                      color: percentageChange >= 0
                          ? AppColors.success
                          : AppColors.error,
                      size: 16,
                    ),
                    const SizedBox(width: 4),
                    Text(
                      '${percentageChange >= 0 ? '+' : ''}${percentageChange.toStringAsFixed(1)}%',
                      style: AppTextStyles.bodySecondary.copyWith(
                        color: percentageChange >= 0
                            ? AppColors.success
                            : AppColors.error,
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 16),
            // Amount
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '\$${totalSpent.toStringAsFixed(2)}',
                  style: AppTextStyles.heading.copyWith(
                    fontSize: 36,
                    fontWeight: FontWeight.bold,
                    color: isDark ? AppColors.textPrimary : Colors.black87,
                  ),
                ),
                // Icons
                Row(
                  children: [
                    Container(
                      width: 32,
                      height: 32,
                      decoration: BoxDecoration(
                        color: isDark
                            ? AppColors.cardBackground.withOpacity(0.5)
                            : Colors.grey.shade100,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: const Icon(
                        Icons.remove,
                        color: AppColors.textPrimary,
                        size: 20,
                      ),
                    ),
                    const SizedBox(width: 8),
                    Container(
                      width: 32,
                      height: 32,
                      decoration: BoxDecoration(
                        color: AppColors.primaryBlue,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: const Icon(
                        Icons.bolt,
                        color: AppColors.textPrimary,
                        size: 20,
                      ),
                    ),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 20),
            // View Insights Button
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  context.go(RouteNames.analytics);
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primaryBlue,
                  foregroundColor: AppColors.textPrimary,
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: Text(
                  'View Insights',
                  style: AppTextStyles.button,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
