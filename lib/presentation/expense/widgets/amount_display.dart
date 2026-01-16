import 'package:flutter/material.dart';
import '../../../core/theme/app_text_styles.dart';

/// Amount display widget showing the current expense amount
class AmountDisplay extends StatelessWidget {
  final String amount;

  const AmountDisplay({
    super.key,
    required this.amount,
  });

  String _formatAmount(String amount) {
    // Ensure proper formatting with 2 decimal places
    final parsed = double.tryParse(amount) ?? 0.0;
    return parsed.toStringAsFixed(2);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'AMOUNT',
          style: AppTextStyles.bodySecondary.copyWith(
            fontSize: 12,
            letterSpacing: 1.2,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          '\$${_formatAmount(amount)}',
          style: AppTextStyles.heading.copyWith(
            fontSize: 48,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }
}
