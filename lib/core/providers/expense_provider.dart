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

  ExpenseListNotifier(this._repository) : super(ExpenseListState()) {
    loadExpenses();
  }

  /// Load all expenses
  Future<void> loadExpenses({
    DateTime? startDate,
    DateTime? endDate,
    int? categoryId,
  }) async {
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
      // Reload expenses
      await loadExpenses();
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
      // Reload expenses
      await loadExpenses();
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
      // Reload expenses
      await loadExpenses();
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
