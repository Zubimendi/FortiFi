import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../core/providers/analytics_provider.dart';
import '../../../core/providers/expense_provider.dart';
import '../../../core/providers/budget_provider.dart';
import 'time_period_selector.dart';

/// Summary cards widget (Top Spending and Savings Rate)
class SummaryCards extends ConsumerWidget {
  final TimePeriod period;

  const SummaryCards({
    super.key,
    required this.period,
  });

  DateTime _getStartDate(TimePeriod period) {
    final now = DateTime.now();
    switch (period) {
      case TimePeriod.week:
        // Get start of current week (Monday)
        final weekStart = now.subtract(Duration(days: now.weekday - 1));
        return DateTime(weekStart.year, weekStart.month, weekStart.day);
      case TimePeriod.month:
        return DateTime(now.year, now.month, 1);
      case TimePeriod.year:
        return DateTime(now.year, 1, 1);
    }
  }

  DateTime _getEndDate(TimePeriod period) {
    final now = DateTime.now();
    switch (period) {
      case TimePeriod.week:
        // Get end of current week (today, normalized to start of day)
        return DateTime(now.year, now.month, now.day);
      case TimePeriod.month:
        return DateTime(now.year, now.month + 1, 0);
      case TimePeriod.year:
        return DateTime(now.year, 12, 31);
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final startDate = _getStartDate(period);
    final endDate = _getEndDate(period);

    final breakdownAsync = ref.watch(
      categoryBreakdownProvider(AnalyticsDateRange(
        startDate: startDate,
        endDate: endDate,
      )),
    );

    final totalSpendingAsync = ref.watch(
      totalSpendingProvider(DateRange(
        startDate: startDate,
        endDate: endDate,
      )),
    );

    final budgetsAsync = ref.watch(activeBudgetsProvider);

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Row(
        children: [
          // Top Spending Card
          Expanded(
            child: breakdownAsync.when(
              data: (breakdown) {
                if (breakdown.isEmpty) {
                  return _SummaryCard(
                    icon: Icons.category,
                    iconColor: Colors.grey,
                    title: 'Top Spending',
                    mainText: 'No data',
                    subText: '\$0.00 SPENT',
                    subTextColor: AppColors.textSecondary,
                  );
                }
                final topCategory = breakdown.first;
                final category = topCategory['category'];
                final amount = topCategory['amount'] as double;
                
                // Get icon and color from category
                IconData icon = Icons.category;
                Color iconColor = Colors.orange;
                if (category != null) {
                  icon = IconData(category.iconCode ?? 0xe5d2, fontFamily: 'MaterialIcons');
                  iconColor = category.colorHex != null
                      ? Color(int.parse(category.colorHex!.replaceFirst('#', '0xFF')))
                      : Colors.orange;
                }

                return _SummaryCard(
                  icon: icon,
                  iconColor: iconColor,
                  title: 'Top Spending',
                  mainText: category?.name ?? 'Unknown',
                  subText: '\$${amount.toStringAsFixed(0)} SPENT',
                  subTextColor: AppColors.textSecondary,
                );
              },
              loading: () => _buildLoadingCard(isDark),
              error: (_, __) => _SummaryCard(
                icon: Icons.error_outline,
                iconColor: Colors.red,
                title: 'Top Spending',
                mainText: 'Error',
                subText: 'Failed to load',
                subTextColor: Colors.red,
              ),
            ),
          ),
          const SizedBox(width: 12),
          // Savings Rate Card
          Expanded(
            child: totalSpendingAsync.when(
              data: (totalSpent) {
                return budgetsAsync.when(
                  data: (budgets) {
                    // Calculate total budget for the period
                    final budgetRepo = ref.read(budgetRepositoryProvider);
                    double totalBudget = 0.0;
                    for (final budget in budgets) {
                      final budgetAmount = budgetRepo.decryptAmount(budget);
                      totalBudget += budgetAmount;
                    }

                    if (totalBudget == 0) {
                      return _SummaryCard(
                        icon: Icons.savings,
                        iconColor: AppColors.textSecondary,
                        title: 'Savings Rate',
                        mainText: 'N/A',
                        subText: 'No budget set',
                        subTextColor: AppColors.textSecondary,
                      );
                    }

                    // Calculate savings rate (budget - spent) / budget * 100
                    final savings = totalBudget - totalSpent;
                    final savingsRate = (savings / totalBudget * 100);
                    final isPositive = savingsRate >= 0;

                    return _SummaryCard(
                      icon: Icons.savings,
                      iconColor: isPositive ? AppColors.success : Colors.red,
                      title: 'Savings Rate',
                      mainText: '${isPositive ? '+' : ''}${savingsRate.toStringAsFixed(1)}%',
                      subText: isPositive ? 'UNDER BUDGET' : 'OVER BUDGET',
                      subTextColor: isPositive ? AppColors.success : Colors.red,
                    );
                  },
                  loading: () => _buildLoadingCard(isDark),
                  error: (_, __) => _SummaryCard(
                    icon: Icons.savings,
                    iconColor: AppColors.textSecondary,
                    title: 'Savings Rate',
                    mainText: 'N/A',
                    subText: 'No budget set',
                    subTextColor: AppColors.textSecondary,
                  ),
                );
              },
              loading: () => _buildLoadingCard(isDark),
              error: (_, __) => _SummaryCard(
                icon: Icons.savings,
                iconColor: AppColors.textSecondary,
                title: 'Savings Rate',
                mainText: 'N/A',
                subText: 'No data',
                subTextColor: AppColors.textSecondary,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLoadingCard(bool isDark) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: isDark ? AppColors.cardBackground : Colors.white,
        borderRadius: BorderRadius.circular(16),
      ),
      child: const Center(child: CircularProgressIndicator()),
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
