import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../widgets/dashboard_header.dart';
import '../widgets/total_spent_card.dart';
import '../widgets/active_budgets_section.dart';
import '../widgets/recent_activity_section.dart';
import '../../core/widgets/bottom_navigation.dart';
import '../../../core/theme/app_colors.dart';

/// Main dashboard screen
class DashboardScreen extends ConsumerWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      backgroundColor: AppColors.backgroundDark,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header
              const DashboardHeader(),
              const SizedBox(height: 24),
              // Total Spent Card
              const TotalSpentCard(),
              const SizedBox(height: 32),
              // Active Budgets Section
              const ActiveBudgetsSection(),
              const SizedBox(height: 32),
              // Recent Activity Section
              const RecentActivitySection(),
              const SizedBox(height: 24),
            ],
          ),
        ),
      ),
      bottomNavigationBar: const AppBottomNavigation(currentIndex: 0),
    );
  }
}
