import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../data/repositories/expense_repository.dart';
import '../../data/models/expense_model.dart';

/// Provider for expense repository
final expenseRepositoryProvider = Provider<ExpenseRepository>((ref) {
  return ExpenseRepository();
});

/// Expense list state
class ExpenseListState {
  final List<ExpenseModel> expenses;
  final bool isLoading;
  final String? error;

  ExpenseListState({
    this.expenses = const [],
    this.isLoading = false,
    this.error,
  });

  ExpenseListState copyWith({
    List<ExpenseModel>? expenses,
    bool? isLoading,
    String? error,
  }) {
    return ExpenseListState(
      expenses: expenses ?? this.expenses,
      isLoading: isLoading ?? this.isLoading,
      error: error,
    );
  }
}

/// Expense list notifier
class ExpenseListNotifier extends StateNotifier<ExpenseListState> {
  final ExpenseRepository _repository;
  bool _hasAttemptedLoad = false;

  ExpenseListNotifier(this._repository) : super(ExpenseListState()) {
    // Don't auto-load on initialization - let widgets trigger it
  }

  /// Load all expenses
  Future<void> loadExpenses({
    DateTime? startDate,
    DateTime? endDate,
    int? categoryId,
    bool force = false,
  }) async {
    // Don't reload if already loading (unless forced)
    if (!force && state.isLoading) {
      return;
    }

    // Don't reload if we've already attempted to load and succeeded (unless forced)
    // Allow reload if there was an error
    if (!force && _hasAttemptedLoad && state.error == null) {
      return;
    }

    _hasAttemptedLoad = true;
    state = state.copyWith(isLoading: true, error: null);
    try {
      final expenses = await _repository.getAllExpenses(
        startDate: startDate,
        endDate: endDate,
        categoryId: categoryId,
      );
      state = state.copyWith(
        expenses: expenses,
        isLoading: false,
      );
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        error: e.toString(),
      );
    }
  }

  /// Add new expense
  Future<bool> addExpense({
    required double amount,
    int? categoryId,
    String? description,
    required DateTime date,
    String? paymentMethod,
    String? receiptPath,
    List<String>? tags,
  }) async {
    state = state.copyWith(isLoading: true, error: null);
    try {
      await _repository.createExpense(
        amount: amount,
        categoryId: categoryId,
        description: description,
        date: date,
        paymentMethod: paymentMethod,
        receiptPath: receiptPath,
        tags: tags,
      );
      // Reload expenses (force reload)
      await loadExpenses(force: true);
      return true;
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        error: e.toString(),
      );
      return false;
    }
  }

  /// Update expense
  Future<bool> updateExpense({
    required int id,
    double? amount,
    int? categoryId,
    String? description,
    DateTime? date,
    String? paymentMethod,
    String? receiptPath,
    List<String>? tags,
  }) async {
    state = state.copyWith(isLoading: true, error: null);
    try {
      await _repository.updateExpense(
        id: id,
        amount: amount,
        categoryId: categoryId,
        description: description,
        date: date,
        paymentMethod: paymentMethod,
        receiptPath: receiptPath,
        tags: tags,
      );
      // Reload expenses (force reload)
      await loadExpenses(force: true);
      return true;
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        error: e.toString(),
      );
      return false;
    }
  }

  /// Delete expense
  Future<bool> deleteExpense(int id) async {
    state = state.copyWith(isLoading: true, error: null);
    try {
      await _repository.deleteExpense(id);
      // Reload expenses (force reload)
      await loadExpenses(force: true);
      return true;
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        error: e.toString(),
      );
      return false;
    }
  }

  /// Get total spending
  Future<double> getTotalSpending({
    DateTime? startDate,
    DateTime? endDate,
    int? categoryId,
  }) async {
    try {
      return await _repository.getTotalSpending(
        startDate: startDate,
        endDate: endDate,
        categoryId: categoryId,
      );
    } catch (e) {
      return 0.0;
    }
  }
}

/// Expense list provider
final expenseListProvider =
    StateNotifierProvider<ExpenseListNotifier, ExpenseListState>((ref) {
  final repository = ref.watch(expenseRepositoryProvider);
  return ExpenseListNotifier(repository);
});

/// Provider for total spending this month
final totalSpendingThisMonthProvider = FutureProvider<double>((ref) async {
  final repository = ref.watch(expenseRepositoryProvider);
  final now = DateTime.now();
  final startOfMonth = DateTime(now.year, now.month, 1);
  final endOfMonth = DateTime(now.year, now.month + 1, 0);

  return await repository.getTotalSpending(
    startDate: startOfMonth,
    endDate: endOfMonth,
  );
});
