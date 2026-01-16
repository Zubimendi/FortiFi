import 'package:flutter/material.dart';
import '../../../core/theme/app_text_styles.dart';
import 'time_period_selector.dart';

/// Total spending display widget
class TotalSpendingDisplay extends StatelessWidget {
  final TimePeriod period;

  const TotalSpendingDisplay({
    super.key,
    required this.period,
  });

  String _getPeriodText(TimePeriod period) {
    switch (period) {
      case TimePeriod.week:
        return 'Total spent this week';
      case TimePeriod.month:
        return 'Total spent in February';
      case TimePeriod.year:
        return 'Total spent this year';
    }
  }

  @override
  Widget build(BuildContext context) {
    // TODO: Get actual spending data based on period
    const totalSpent = 4250.00;

    return Center(
      child: Column(
        children: [
          Text(
            '\$${totalSpent.toStringAsFixed(2)}',
            style: AppTextStyles.heading.copyWith(
              fontSize: 48,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            _getPeriodText(period),
            style: AppTextStyles.bodySecondary.copyWith(fontSize: 14),
          ),
        ],
      ),
    );
  }
}
