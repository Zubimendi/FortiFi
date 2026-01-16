import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../widgets/budget_header.dart';
import '../widgets/active_budgets_section.dart';
import '../widgets/budget_card.dart';
import '../widgets/add_budget_card.dart';
import '../../core/widgets/bottom_navigation.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/providers/budget_provider.dart';
import '../../../core/providers/category_provider.dart';
import '../../../data/models/budget_model.dart';
import '../../../data/models/category_model.dart';

/// Budget Limits screen showing active budgets
class BudgetScreen extends ConsumerWidget {
  const BudgetScreen({super.key});

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
        return Colors.green;
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
    final budgetState = ref.watch(budgetListProvider);
    final budgetNotifier = ref.read(budgetListProvider.notifier);
    final categoryState = ref.watch(categoryListProvider);
    final budgetRepo = ref.watch(budgetRepositoryProvider);

    // Load active budgets if not loaded
    if (budgetState.budgets.isEmpty && !budgetState.isLoading) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        budgetNotifier.loadActiveBudgets();
      });
    }

    // Load categories if not loaded
    if (categoryState.categories.isEmpty && !categoryState.isLoading) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        ref.read(categoryListProvider.notifier).loadCategories();
      });
    }

    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: SafeArea(
        child: budgetState.isLoading
            ? const Center(child: CircularProgressIndicator())
            : SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Header
                    const BudgetHeader(),
                    const SizedBox(height: 24),
                    // Active Budgets Section Header
                    const ActiveBudgetsSectionHeader(),
                    const SizedBox(height: 16),
                    // Budget Cards
                    if (budgetState.budgets.isEmpty)
                      Padding(
                        padding: const EdgeInsets.all(24.0),
                        child: Center(
                          child: Text(
                            'No budgets set up yet',
                            style: TextStyle(
                              color: AppColors.textSecondary,
                            ),
                          ),
                        ),
                      )
                    else
                      ...budgetState.budgets.map((budget) {
                        // Get category info
                        final category = budget.categoryId != null
                            ? categoryState.categories.firstWhere(
                                (cat) => cat.id == budget.categoryId,
                                orElse: () => categoryState.categories.first,
                              )
                            : null;

                        // Get budget status
                        return FutureBuilder<Map<String, dynamic>?>(
                          future: budgetNotifier.getBudgetStatus(budget.id!),
                          builder: (context, snapshot) {
                            if (snapshot.connectionState ==
                                ConnectionState.waiting) {
                              return const Padding(
                                padding: EdgeInsets.only(bottom: 16),
                                child: Center(
                                  child: CircularProgressIndicator(),
                                ),
                              );
                            }

                            final status = snapshot.data;
                            if (status == null) {
                              return const SizedBox.shrink();
                            }

                            final spent = status['spent'] as double;
                            final limit = status['budget'] as double;
                            final percentUsed = status['percentUsed'] as double;

                            return Padding(
                              padding: const EdgeInsets.only(bottom: 16),
                              child: BudgetCard(
                                category: category?.name ?? 'General',
                                icon: _getCategoryIcon(category?.name),
                                iconColor: _getCategoryColor(category?.name),
                                spent: spent,
                                limit: limit,
                                alertThreshold: budget.alertThreshold * 100,
                              ),
                            );
                          },
                        );
                      }),
                    const SizedBox(height: 16),
                    // Add New Budget Card
                    const AddBudgetCard(),
                    const SizedBox(height: 24),
                  ],
                ),
              ),
      ),
      bottomNavigationBar: const AppBottomNavigation(currentIndex: 1),
    );
  }
}
