import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../core/utils/route_names.dart';
import 'budget_grid_card.dart';

/// Monthly budgets section with grid layout
class MonthlyBudgetsSectionNew extends StatelessWidget {
  const MonthlyBudgetsSectionNew({super.key});

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
                'Monthly Budgets',
                style: AppTextStyles.heading.copyWith(fontSize: 22),
              ),
              TextButton(
                onPressed: () {
                  context.go(RouteNames.budget);
                },
                child: Text(
                  'Manage',
                  style: AppTextStyles.link,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          // Budget Grid (2x2)
          Row(
            children: [
              Expanded(
                child: Column(
                  children: [
                    BudgetGridCard(
                      category: 'Groceries',
                      icon: Icons.shopping_cart,
                      iconColor: Colors.orange,
                      spent: 400.0,
                      limit: 500.0,
                    ),
                    const SizedBox(height: 12),
                    BudgetGridCard(
                      category: 'Travel',
                      icon: Icons.flight,
                      iconColor: Colors.purple,
                      spent: 400.0,
                      limit: 1000.0,
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  children: [
                    BudgetGridCard(
                      category: 'Tech & Gadgets',
                      icon: Icons.laptop,
                      iconColor: AppColors.primaryBlue,
                      spent: 975.0,
                      limit: 1500.0,
                    ),
                    const SizedBox(height: 12),
                    BudgetGridCard(
                      category: 'New Category',
                      icon: Icons.add,
                      iconColor: AppColors.textSecondary,
                      isAddNew: true,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
