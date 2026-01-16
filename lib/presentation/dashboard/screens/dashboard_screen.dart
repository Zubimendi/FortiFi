import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../widgets/dashboard_header_new.dart';
import '../widgets/total_spent_card_new.dart';
import '../widgets/monthly_budgets_section_new.dart';
import '../widgets/recent_transactions_section_new.dart';
import '../../core/widgets/bottom_navigation.dart';

/// Main dashboard screen (updated design)
class DashboardScreen extends ConsumerWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header
              const DashboardHeaderNew(),
              const SizedBox(height: 24),
              // Total Spent Card
              const TotalSpentCardNew(),
              const SizedBox(height: 32),
              // Monthly Budgets Section
              const MonthlyBudgetsSectionNew(),
              const SizedBox(height: 32),
              // Recent Transactions Section
              const RecentTransactionsSectionNew(),
              const SizedBox(height: 24),
            ],
          ),
        ),
      ),
      bottomNavigationBar: const AppBottomNavigation(currentIndex: 0),
    );
  }
}
