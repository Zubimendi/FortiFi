import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../widgets/insights_header.dart';
import '../widgets/time_period_selector.dart';
import '../widgets/total_spending_display.dart';
import '../widgets/spending_trend_card.dart';
import '../widgets/top_categories_card.dart';
import '../widgets/summary_cards.dart';
import '../../core/widgets/bottom_navigation.dart';
import '../../../core/theme/app_colors.dart';

/// Spending insights screen with analytics and charts
class InsightsScreen extends ConsumerStatefulWidget {
  const InsightsScreen({super.key});

  @override
  ConsumerState<InsightsScreen> createState() => _InsightsScreenState();
}

class _InsightsScreenState extends ConsumerState<InsightsScreen> {
  TimePeriod _selectedPeriod = TimePeriod.month;

  void _onPeriodChanged(TimePeriod period) {
    setState(() {
      _selectedPeriod = period;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header
              const InsightsHeader(),
              const SizedBox(height: 24),
              // Time Period Selector
              TimePeriodSelector(
                selectedPeriod: _selectedPeriod,
                onPeriodChanged: _onPeriodChanged,
              ),
              const SizedBox(height: 24),
              // Total Spending Display
              TotalSpendingDisplay(period: _selectedPeriod),
              const SizedBox(height: 32),
              // Spending Trend Card
              const SpendingTrendCard(),
              const SizedBox(height: 24),
              // Top Categories Card
              const TopCategoriesCard(),
              const SizedBox(height: 24),
              // Summary Cards
              const SummaryCards(),
              const SizedBox(height: 24),
            ],
          ),
        ),
      ),
      bottomNavigationBar: const AppBottomNavigation(currentIndex: 2),
    );
  }
}
