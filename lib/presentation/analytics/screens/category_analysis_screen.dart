import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../widgets/category_analysis_header.dart';
import '../widgets/category_donut_chart.dart';
import '../widgets/category_filters.dart';
import '../widgets/category_list.dart';
import '../widgets/biggest_expense_card.dart';
import '../../core/widgets/bottom_navigation.dart';

/// Category Analysis screen showing spending breakdown by category
class CategoryAnalysisScreen extends ConsumerWidget {
  const CategoryAnalysisScreen({super.key});

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
              const CategoryAnalysisHeader(),
              const SizedBox(height: 24),
              // Donut Chart
              const CategoryDonutChart(),
              const SizedBox(height: 24),
              // Category Filters
              const CategoryFilters(),
              const SizedBox(height: 32),
              // Category List
              const CategoryList(),
              const SizedBox(height: 32),
              // Biggest Expense Card
              const BiggestExpenseCard(),
              const SizedBox(height: 24),
            ],
          ),
        ),
      ),
      bottomNavigationBar: const AppBottomNavigation(currentIndex: 2),
    );
  }
}
