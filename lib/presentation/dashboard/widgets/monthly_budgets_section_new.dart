import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../core/utils/route_names.dart';
import '../../../core/providers/budget_provider.dart';
import '../../../core/providers/category_provider.dart';
import '../../../data/models/budget_model.dart';
import '../../../data/models/category_model.dart';
import 'budget_grid_card.dart';

/// Monthly budgets section with grid layout
class MonthlyBudgetsSectionNew extends ConsumerWidget {
  const MonthlyBudgetsSectionNew({super.key});

  IconData _getCategoryIcon(String? categoryName) {
    switch (categoryName?.toLowerCase()) {
      case 'dining':
        return Icons.restaurant;
      case 'shopping':
        return Icons.shopping_bag;
      case 'transport':
        return Icons.directions_car;
      case 'groceries':
        return Icons.shopping_cart;
      case 'housing':
        return Icons.home;
      case 'health':
        return Icons.local_hospital;
      case 'fun':
      case 'entertainment':
        return Icons.movie;
      case 'education':
        return Icons.school;
      case 'travel':
        return Icons.flight;
      default:
        return Icons.category;
    }
  }

  Color _getCategoryColor(String? categoryName) {
    switch (categoryName?.toLowerCase()) {
      case 'dining':
        return Colors.amber;
      case 'shopping':
        return Colors.pink;
      case 'transport':
        return AppColors.primaryBlue;
      case 'groceries':
        return Colors.orange;
      case 'housing':
        return AppColors.primaryBlue;
      case 'health':
        return Colors.green;
      case 'fun':
      case 'entertainment':
        return Colors.red;
      case 'education':
        return AppColors.primaryBlue;
      case 'travel':
        return Colors.purple;
      default:
        return AppColors.textSecondary;
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final activeBudgetsAsync = ref.watch(activeBudgetsProvider);
    final categoryState = ref.watch(categoryListProvider);
    final budgetNotifier = ref.read(budgetListProvider.notifier);

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
          activeBudgetsAsync.when(
            data: (budgets) {
              // Take first 4 budgets for 2x2 grid
              final displayBudgets = budgets.take(4).toList();

              if (displayBudgets.isEmpty) {
                return Center(
                  child: Padding(
                    padding: const EdgeInsets.all(24.0),
                    child: Text(
                      'No budgets set up yet',
                      style: AppTextStyles.bodySecondary,
                    ),
                  ),
                );
              }

              // Fill remaining slots with "Add New" if needed
              final List<Widget> budgetWidgets = [];
              for (int i = 0; i < 4; i++) {
                if (i < displayBudgets.length) {
                  final budget = displayBudgets[i];
                  final category = budget.categoryId != null
                      ? categoryState.categories.firstWhere(
                          (cat) => cat.id == budget.categoryId,
                          orElse: () => categoryState.categories.first,
                        )
                      : null;

                  budgetWidgets.add(
                    FutureBuilder<Map<String, dynamic>?>(
                      future: budgetNotifier.getBudgetStatus(budget.id!),
                      builder: (context, snapshot) {
                        if (snapshot.connectionState ==
                            ConnectionState.waiting) {
                          return const BudgetGridCard(
                            category: 'Loading...',
                            icon: Icons.category,
                            iconColor: AppColors.textSecondary,
                            spent: 0.0,
                            limit: 0.0,
                          );
                        }

                        final status = snapshot.data;
                        if (status == null) {
                          return const SizedBox.shrink();
                        }

                        final spent = status['spent'] as double;
                        final limit = status['budget'] as double;

                        return BudgetGridCard(
                          category: category?.name ?? 'General',
                          icon: _getCategoryIcon(category?.name),
                          iconColor: _getCategoryColor(category?.name),
                          spent: spent,
                          limit: limit,
                        );
                      },
                    ),
                  );
                } else if (i == displayBudgets.length) {
                  // Add "Add New" card
                  budgetWidgets.add(
                    const BudgetGridCard(
                      category: 'New Category',
                      icon: Icons.add,
                      iconColor: AppColors.textSecondary,
                      isAddNew: true,
                    ),
                  );
                } else {
                  // Empty slot
                  budgetWidgets.add(const SizedBox.shrink());
                }
              }

              return Row(
                children: [
                  Expanded(
                    child: Column(
                      children: [
                        budgetWidgets[0],
                        if (budgetWidgets.length > 2) ...[
                          const SizedBox(height: 12),
                          budgetWidgets[2],
                        ],
                      ],
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      children: [
                        if (budgetWidgets.length > 1) budgetWidgets[1],
                        if (budgetWidgets.length > 3) ...[
                          const SizedBox(height: 12),
                          budgetWidgets[3],
                        ],
                      ],
                    ),
                  ),
                ],
              );
            },
            loading: () => const Center(
              child: Padding(
                padding: EdgeInsets.all(24.0),
                child: CircularProgressIndicator(),
              ),
            ),
            error: (_, __) => Center(
              child: Padding(
                padding: const EdgeInsets.all(24.0),
                child: Text(
                  'Failed to load budgets',
                  style: AppTextStyles.bodySecondary,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
