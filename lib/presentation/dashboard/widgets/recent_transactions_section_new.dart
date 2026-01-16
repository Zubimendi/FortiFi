import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../core/providers/expense_provider.dart';
import '../../../core/providers/category_provider.dart';
import 'transaction_item_new.dart';

/// Recent transactions section
class RecentTransactionsSectionNew extends ConsumerWidget {
  const RecentTransactionsSectionNew({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final expenseState = ref.watch(expenseListProvider);
    final expenseNotifier = ref.read(expenseListProvider.notifier);
    final expenseRepo = ref.watch(expenseRepositoryProvider);
    final categoryRepo = ref.watch(categoryRepositoryProvider);

    // Load expenses once on first build
    final hasLoaded = ref.read(expenseListProvider).expenses.isNotEmpty;
    if (!hasLoaded && !expenseState.isLoading) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        expenseNotifier.loadExpenses();
      });
    }

    // Get recent expenses (last 5)
    final recentExpenses = expenseState.expenses.take(5).toList();

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
                'Recent Transactions',
                style: AppTextStyles.heading.copyWith(fontSize: 22),
              ),
              IconButton(
                icon: const Icon(
                  Icons.tune,
                  color: AppColors.textSecondary,
                ),
                onPressed: () {
                  // TODO: Show filter options
                },
              ),
            ],
          ),
          const SizedBox(height: 16),
          // Transaction items
          if (expenseState.isLoading)
            const Center(
              child: Padding(
                padding: EdgeInsets.all(24.0),
                child: CircularProgressIndicator(),
              ),
            )
          else if (recentExpenses.isEmpty)
            Center(
              child: Padding(
                padding: const EdgeInsets.all(24.0),
                child: Text(
                  'No transactions yet',
                  style: AppTextStyles.bodySecondary,
                ),
              ),
            )
          else
            Column(
              children: recentExpenses.asMap().entries.map((entry) {
                final expense = entry.value;
                final index = entry.key;
                
                // Decrypt expense data
                double amount;
                String? description;
                
                try {
                  amount = expenseRepo.decryptAmount(expense);
                  description = expenseRepo.decryptDescription(expense);
                } catch (e) {
                  amount = 0.0;
                  description = null;
                }

                // Get category synchronously from state
                final categories = ref.read(categoryListProvider).categories;
                final category = expense.categoryId != null
                    ? categories.firstWhere(
                        (cat) => cat.id == expense.categoryId,
                        orElse: () => categories.first,
                      )
                    : null;

                return Column(
                  children: [
                    if (index > 0) const SizedBox(height: 12),
                    TransactionItemNew(
                      merchant: description ?? 'Expense',
                      amount: -amount,
                      date: expense.date,
                      category: category?.name ?? 'Uncategorized',
                      icon: _getCategoryIcon(category?.name),
                      status: TransactionStatus.completed,
                    ),
                  ],
                );
              }).toList(),
            ),
        ],
      ),
    );
  }

  IconData _getCategoryIcon(String? categoryName) {
    switch (categoryName?.toLowerCase()) {
      case 'dining':
      case 'restaurant':
        return Icons.restaurant;
      case 'shopping':
        return Icons.shopping_bag;
      case 'transport':
      case 'transportation':
        return Icons.directions_car;
      case 'groceries':
        return Icons.shopping_cart;
      case 'housing':
      case 'home':
        return Icons.home;
      case 'health':
        return Icons.local_hospital;
      case 'entertainment':
      case 'fun':
        return Icons.movie;
      case 'education':
        return Icons.school;
      case 'travel':
        return Icons.flight;
      default:
        return Icons.category;
    }
  }
}
