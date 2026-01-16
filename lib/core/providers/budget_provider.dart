import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../data/repositories/budget_repository.dart';
import '../../data/models/budget_model.dart';

/// Provider for budget repository
final budgetRepositoryProvider = Provider<BudgetRepository>((ref) {
  return BudgetRepository();
});

/// Budget list state
class BudgetListState {
  final List<BudgetModel> budgets;
  final bool isLoading;
  final String? error;

  BudgetListState({
    this.budgets = const [],
    this.isLoading = false,
    this.error,
  });

  BudgetListState copyWith({
    List<BudgetModel>? budgets,
    bool? isLoading,
    String? error,
  }) {
    return BudgetListState(
      budgets: budgets ?? this.budgets,
      isLoading: isLoading ?? this.isLoading,
      error: error,
    );
  }
}

/// Budget list notifier
class BudgetListNotifier extends StateNotifier<BudgetListState> {
  final BudgetRepository _repository;

  BudgetListNotifier(this._repository) : super(BudgetListState()) {
    loadBudgets();
  }

  /// Load all budgets
  Future<void> loadBudgets({
    int? categoryId,
    String? period,
    DateTime? startDate,
    DateTime? endDate,
  }) async {
    state = state.copyWith(isLoading: true, error: null);
    try {
      final budgets = await _repository.getAllBudgets(
        categoryId: categoryId,
        period: period,
        startDate: startDate,
        endDate: endDate,
      );
      state = state.copyWith(
        budgets: budgets,
        isLoading: false,
      );
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        error: e.toString(),
      );
    }
  }

  /// Load active budgets
  Future<void> loadActiveBudgets() async {
    state = state.copyWith(isLoading: true, error: null);
    try {
      final budgets = await _repository.getActiveBudgets();
      state = state.copyWith(
        budgets: budgets,
        isLoading: false,
      );
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        error: e.toString(),
      );
    }
  }

  /// Add new budget
  Future<bool> addBudget({
    int? categoryId,
    required double amount,
    String period = 'monthly',
    required DateTime startDate,
    DateTime? endDate,
    double alertThreshold = 0.8,
  }) async {
    state = state.copyWith(isLoading: true, error: null);
    try {
      await _repository.createBudget(
        categoryId: categoryId,
        amount: amount,
        period: period,
        startDate: startDate,
        endDate: endDate,
        alertThreshold: alertThreshold,
      );
      await loadBudgets();
      return true;
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        error: e.toString(),
      );
      return false;
    }
  }

  /// Update budget
  Future<bool> updateBudget({
    required int id,
    double? amount,
    int? categoryId,
    String? period,
    DateTime? startDate,
    DateTime? endDate,
    double? alertThreshold,
  }) async {
    state = state.copyWith(isLoading: true, error: null);
    try {
      await _repository.updateBudget(
        id: id,
        amount: amount,
        categoryId: categoryId,
        period: period,
        startDate: startDate,
        endDate: endDate,
        alertThreshold: alertThreshold,
      );
      await loadBudgets();
      return true;
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        error: e.toString(),
      );
      return false;
    }
  }

  /// Delete budget
  Future<bool> deleteBudget(int id) async {
    state = state.copyWith(isLoading: true, error: null);
    try {
      await _repository.deleteBudget(id);
      await loadBudgets();
      return true;
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        error: e.toString(),
      );
      return false;
    }
  }

  /// Get budget status
  Future<Map<String, dynamic>?> getBudgetStatus(int budgetId) async {
    try {
      return await _repository.getBudgetStatus(budgetId);
    } catch (e) {
      return null;
    }
  }

  /// Check budget alerts
  Future<List<Map<String, dynamic>>> checkBudgetAlerts() async {
    try {
      return await _repository.checkBudgetAlerts();
    } catch (e) {
      return [];
    }
  }
}

/// Budget list provider
final budgetListProvider =
    StateNotifierProvider<BudgetListNotifier, BudgetListState>((ref) {
  final repository = ref.watch(budgetRepositoryProvider);
  return BudgetListNotifier(repository);
});

/// Provider for active budgets
final activeBudgetsProvider = FutureProvider<List<BudgetModel>>((ref) async {
  final repository = ref.watch(budgetRepositoryProvider);
  return await repository.getActiveBudgets();
});
