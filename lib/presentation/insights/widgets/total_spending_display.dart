import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../core/providers/expense_provider.dart';
import 'time_period_selector.dart';

/// Total spending display widget
class TotalSpendingDisplay extends ConsumerWidget {
  final TimePeriod period;

  const TotalSpendingDisplay({
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

  String _getPeriodText(TimePeriod period) {
    final now = DateTime.now();
    switch (period) {
      case TimePeriod.week:
        return 'Total spent this week';
      case TimePeriod.month:
        final months = [
          'January',
          'February',
          'March',
          'April',
          'May',
          'June',
          'July',
          'August',
          'September',
          'October',
          'November',
          'December'
        ];
        return 'Total spent in ${months[now.month - 1]}';
      case TimePeriod.year:
        return 'Total spent this year';
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final startDate = _getStartDate(period);
    final endDate = _getEndDate(period);
    
    final totalSpendingAsync = ref.watch(
      totalSpendingProvider(DateRange(
        startDate: startDate,
        endDate: endDate,
      )),
    );

    return totalSpendingAsync.when(
      data: (totalSpent) => Center(
        child: Column(
          children: [
            Text(
              '\$${totalSpent.toStringAsFixed(2)}',
              style: AppTextStyles.heading.copyWith(
                fontSize: 48,
                fontWeight: FontWeight.bold,
                color: isDark ? AppColors.textPrimary : Colors.black87,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              _getPeriodText(period),
              style: AppTextStyles.bodySecondary.copyWith(
                fontSize: 14,
                color: isDark ? AppColors.textSecondary : Colors.grey.shade700,
              ),
            ),
          ],
        ),
      ),
      loading: () => const Center(
        child: CircularProgressIndicator(),
      ),
      error: (_, __) => Center(
        child: Column(
          children: [
            Text(
              '\$0.00',
              style: AppTextStyles.heading.copyWith(
                fontSize: 48,
                fontWeight: FontWeight.bold,
                color: isDark ? AppColors.textPrimary : Colors.black87,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              _getPeriodText(period),
              style: AppTextStyles.bodySecondary.copyWith(
                fontSize: 14,
                color: isDark ? AppColors.textSecondary : Colors.grey.shade700,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
