import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../widgets/budget_header.dart';
import '../widgets/active_budgets_section.dart';
import '../widgets/budget_card.dart';
import '../widgets/add_budget_card.dart';
import '../../core/widgets/bottom_navigation.dart';
import '../../../core/theme/app_colors.dart';

/// Budget Limits screen showing active budgets
class BudgetScreen extends ConsumerWidget {
  const BudgetScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Sample budget data
    final budgets = [
      {
        'category': 'Dining Out',
        'icon': Icons.restaurant,
        'iconColor': Colors.amber,
        'spent': 450.0,
        'limit': 600.0,
        'alertThreshold': 80.0,
      },
      {
        'category': 'Groceries',
        'icon': Icons.shopping_cart,
        'iconColor': Colors.green,
        'spent': 210.0,
        'limit': 800.0,
        'alertThreshold': 70.0,
      },
      {
        'category': 'Entertainment',
        'icon': Icons.movie,
        'iconColor': Colors.red,
        'spent': 145.0,
        'limit': 150.0,
        'alertThreshold': 80.0,
      },
    ];

    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: SafeArea(
        child: SingleChildScrollView(
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
              ...budgets.map((budget) => Padding(
                    padding: const EdgeInsets.only(bottom: 16),
                    child: BudgetCard(
                      category: budget['category'] as String,
                      icon: budget['icon'] as IconData,
                      iconColor: budget['iconColor'] as Color,
                      spent: budget['spent'] as double,
                      limit: budget['limit'] as double,
                      alertThreshold: budget['alertThreshold'] as double,
                    ),
                  )),
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
