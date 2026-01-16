import 'package:flutter/material.dart';
import '../../../core/theme/app_text_styles.dart';
import 'budget_card.dart';

/// Active budgets section with budget cards
class ActiveBudgetsSection extends StatelessWidget {
  const ActiveBudgetsSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Section header
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Active Budgets',
                style: AppTextStyles.heading.copyWith(fontSize: 22),
              ),
              TextButton(
                onPressed: () {
                  // TODO: Navigate to budgets screen
                },
                child: Text(
                  'View all',
                  style: AppTextStyles.link,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          // Budget cards
          Row(
            children: [
              Expanded(
                child: BudgetCard(
                  category: 'Dining',
                  icon: Icons.restaurant,
                  iconColor: Colors.red,
                  spent: 400.00,
                  budget: 500.00,
                  progressColor: Colors.red,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: BudgetCard(
                  category: 'Groceries',
                  icon: Icons.shopping_cart,
                  iconColor: Colors.green,
                  spent: 200.00,
                  budget: 600.00,
                  progressColor: Colors.green,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
