import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../data/repositories/expense_repository.dart';
import '../../data/repositories/category_repository.dart';
import 'expense_provider.dart';
import 'category_provider.dart';

/// Date range parameter for analytics providers
class AnalyticsDateRange {
  final DateTime? startDate;
  final DateTime? endDate;

  const AnalyticsDateRange({
    this.startDate,
    this.endDate,
  });

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is AnalyticsDateRange &&
          runtimeType == other.runtimeType &&
          startDate?.millisecondsSinceEpoch == other.startDate?.millisecondsSinceEpoch &&
          endDate?.millisecondsSinceEpoch == other.endDate?.millisecondsSinceEpoch;

  @override
  int get hashCode =>
      (startDate?.millisecondsSinceEpoch.hashCode ?? 0) ^
      (endDate?.millisecondsSinceEpoch.hashCode ?? 0);
}

/// Spending trend parameters
class SpendingTrendParams {
  final DateTime startDate;
  final DateTime endDate;
  final String groupBy;

  const SpendingTrendParams({
    required this.startDate,
    required this.endDate,
    this.groupBy = 'day',
  });

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is SpendingTrendParams &&
          runtimeType == other.runtimeType &&
          startDate.millisecondsSinceEpoch == other.startDate.millisecondsSinceEpoch &&
          endDate.millisecondsSinceEpoch == other.endDate.millisecondsSinceEpoch &&
          groupBy == other.groupBy;

  @override
  int get hashCode =>
      startDate.millisecondsSinceEpoch.hashCode ^
      endDate.millisecondsSinceEpoch.hashCode ^
      groupBy.hashCode;
}

/// Provider for analytics calculations
final analyticsProvider = Provider<AnalyticsService>((ref) {
  final expenseRepo = ref.watch(expenseRepositoryProvider);
  final categoryRepo = ref.watch(categoryRepositoryProvider);
  return AnalyticsService(expenseRepo, categoryRepo);
});

/// Analytics service for insights and calculations
class AnalyticsService {
  final ExpenseRepository _expenseRepository;
  final CategoryRepository _categoryRepository;

  AnalyticsService(this._expenseRepository, this._categoryRepository);

  /// Get spending by category for a date range
  Future<Map<int, double>> getSpendingByCategory({
    DateTime? startDate,
    DateTime? endDate,
  }) async {
    try {
      final expenses = await _expenseRepository.getAllExpenses(
        startDate: startDate,
        endDate: endDate,
      );

      if (expenses.isEmpty) {
        return {};
      }

      final Map<int, double> categorySpending = {};

      for (final expense in expenses) {
        if (expense.categoryId != null) {
          try {
            final amount = _expenseRepository.decryptAmount(expense);
            categorySpending[expense.categoryId!] =
                (categorySpending[expense.categoryId] ?? 0.0) + amount;
          } catch (e) {
            // Skip expenses that can't be decrypted
            continue;
          }
        }
      }

      return categorySpending;
    } catch (e) {
      return {};
    }
  }

  /// Get category breakdown with percentages
  Future<List<Map<String, dynamic>>> getCategoryBreakdown({
    DateTime? startDate,
    DateTime? endDate,
  }) async {
    try {
      final spendingByCategory = await getSpendingByCategory(
        startDate: startDate,
        endDate: endDate,
      );

      final total = spendingByCategory.values.fold<double>(
        0.0,
        (sum, amount) => sum + amount,
      );

      if (total == 0) return [];

      final List<Map<String, dynamic>> breakdown = [];

      for (final entry in spendingByCategory.entries) {
        final category = await _categoryRepository.getCategoryById(entry.key);
        if (category != null) {
          final percentage = (entry.value / total * 100);
          breakdown.add({
            'category': category,
            'amount': entry.value,
            'percentage': percentage,
          });
        }
      }

      // Sort by amount descending
      breakdown.sort((a, b) => (b['amount'] as double).compareTo(a['amount'] as double));

      return breakdown;
    } catch (e) {
      return [];
    }
  }

  /// Get spending trend (daily/weekly/monthly)
  Future<List<Map<String, dynamic>>> getSpendingTrend({
    required DateTime startDate,
    required DateTime endDate,
    String groupBy = 'day', // 'day', 'week', 'month'
  }) async {
    try {
      final expenses = await _expenseRepository.getAllExpenses(
        startDate: startDate,
        endDate: endDate,
      );

      if (expenses.isEmpty) {
        return [];
      }

      final Map<String, double> trend = {};

      for (final expense in expenses) {
        try {
          String key;
          final date = expense.date;

          switch (groupBy) {
            case 'week':
              // Get week number
              final weekStart = date.subtract(Duration(days: date.weekday - 1));
              key = '${weekStart.year}-W${_getWeekNumber(weekStart)}';
              break;
            case 'month':
              key = '${date.year}-${date.month.toString().padLeft(2, '0')}';
              break;
            case 'day':
            default:
              key = '${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}';
              break;
          }

          final amount = _expenseRepository.decryptAmount(expense);
          trend[key] = (trend[key] ?? 0.0) + amount;
        } catch (e) {
          // Skip expenses that can't be decrypted
          continue;
        }
      }

      if (trend.isEmpty) {
        return [];
      }

      // Convert to list and sort by date
      final List<Map<String, dynamic>> trendList = trend.entries
          .map((entry) => {
                'period': entry.key,
                'amount': entry.value,
              })
          .toList();

      trendList.sort((a, b) => a['period'].compareTo(b['period']));

      return trendList;
    } catch (e) {
      return [];
    }
  }

  /// Get month-over-month comparison
  Future<List<Map<String, dynamic>>> getMonthlyComparison({
    int months = 6,
  }) async {
    try {
      final now = DateTime.now();
      final List<Map<String, dynamic>> comparison = [];

      for (int i = months - 1; i >= 0; i--) {
        final month = DateTime(now.year, now.month - i, 1);
        final startOfMonth = DateTime(month.year, month.month, 1);
        final endOfMonth = DateTime(month.year, month.month + 1, 0);

        final total = await _expenseRepository.getTotalSpending(
          startDate: startOfMonth,
          endDate: endOfMonth,
        );

        comparison.add({
          'month': month,
          'total': total,
          'label': '${_getMonthName(month.month)} ${month.year}',
        });
      }

      return comparison;
    } catch (e) {
      return [];
    }
  }

  /// Get top expenses
  Future<List<Map<String, dynamic>>> getTopExpenses({
    int limit = 10,
    DateTime? startDate,
    DateTime? endDate,
  }) async {
    try {
      final expenses = await _expenseRepository.getAllExpenses(
        startDate: startDate,
        endDate: endDate,
      );

      final List<Map<String, dynamic>> topExpenses = [];

      for (final expense in expenses) {
        final amount = _expenseRepository.decryptAmount(expense);
        final category = expense.categoryId != null
            ? await _categoryRepository.getCategoryById(expense.categoryId!)
            : null;
        final description = _expenseRepository.decryptDescription(expense);

        topExpenses.add({
          'expense': expense,
          'amount': amount,
          'category': category,
          'description': description,
        });
      }

      // Sort by amount descending
      topExpenses.sort((a, b) => (b['amount'] as double).compareTo(a['amount'] as double));

      return topExpenses.take(limit).toList();
    } catch (e) {
      return [];
    }
  }

  int _getWeekNumber(DateTime date) {
    final startOfYear = DateTime(date.year, 1, 1);
    final firstMonday = startOfYear.add(Duration(days: (8 - startOfYear.weekday) % 7));
    final daysSinceFirstMonday = date.difference(firstMonday).inDays;
    return (daysSinceFirstMonday / 7).floor() + 1;
  }

  String _getMonthName(int month) {
    const months = [
      'Jan',
      'Feb',
      'Mar',
      'Apr',
      'May',
      'Jun',
      'Jul',
      'Aug',
      'Sep',
      'Oct',
      'Nov',
      'Dec'
    ];
    return months[month - 1];
  }
}

/// Provider for category breakdown
final categoryBreakdownProvider = FutureProvider.family<List<Map<String, dynamic>>, AnalyticsDateRange>((ref, dateRange) async {
  final analytics = ref.watch(analyticsProvider);
  return await analytics.getCategoryBreakdown(
    startDate: dateRange.startDate,
    endDate: dateRange.endDate,
  );
});

/// Provider for spending trend
final spendingTrendProvider = FutureProvider.family<List<Map<String, dynamic>>, SpendingTrendParams>((ref, params) async {
  final analytics = ref.watch(analyticsProvider);
  return await analytics.getSpendingTrend(
    startDate: params.startDate,
    endDate: params.endDate,
    groupBy: params.groupBy,
  );
});

/// Provider for monthly comparison
final monthlyComparisonProvider = FutureProvider.family<List<Map<String, dynamic>>, int>((ref, months) async {
  final analytics = ref.watch(analyticsProvider);
  return await analytics.getMonthlyComparison(months: months);
});
