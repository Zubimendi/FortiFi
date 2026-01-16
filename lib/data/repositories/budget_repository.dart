import '../database/database_helper.dart';
import '../models/budget_model.dart';
import '../services/encryption_service.dart';
import '../repositories/expense_repository.dart';
import '../../core/utils/logger.dart';

/// Repository for budget operations
class BudgetRepository {
  final DatabaseHelper _dbHelper = DatabaseHelper.instance;
  final EncryptionService _encryption = EncryptionService.instance;
  final ExpenseRepository _expenseRepository = ExpenseRepository();

  /// Create a new budget (amount is encrypted)
  Future<int> createBudget({
    int? categoryId,
    required double amount,
    String period = 'monthly',
    required DateTime startDate,
    DateTime? endDate,
    double alertThreshold = 0.8,
  }) async {
    try {
      if (!_encryption.isInitialized) {
        throw Exception('Encryption not initialized');
      }

      final db = await _dbHelper.database;
      final now = DateTime.now();

      // Encrypt budget amount
      final amountEncrypted = _encryption.encryptAmount(amount);

      final budget = BudgetModel(
        categoryId: categoryId,
        amountEncrypted: amountEncrypted,
        period: period,
        startDate: startDate,
        endDate: endDate,
        alertThreshold: alertThreshold,
        createdAt: now,
      );

      return await db.insert('budgets', budget.toMap());
    } catch (e) {
      Logger.error('Failed to create budget', e);
      rethrow;
    }
  }

  /// Get all budgets (with decryption)
  Future<List<BudgetModel>> getAllBudgets({
    int? categoryId,
    String? period,
    DateTime? startDate,
    DateTime? endDate,
  }) async {
    try {
      if (!_encryption.isInitialized) {
        throw Exception('Encryption not initialized');
      }

      final db = await _dbHelper.database;
      final List<String> whereClauses = [];
      final List<dynamic> whereArgs = [];

      if (categoryId != null) {
        whereClauses.add('category_id = ?');
        whereArgs.add(categoryId);
      }

      if (period != null) {
        whereClauses.add('period = ?');
        whereArgs.add(period);
      }

      if (startDate != null) {
        whereClauses.add('start_date >= ?');
        whereArgs.add(startDate.toIso8601String().split('T')[0]);
      }

      if (endDate != null) {
        whereClauses.add('end_date <= ?');
        whereArgs.add(endDate.toIso8601String().split('T')[0]);
      }

      final where = whereClauses.isNotEmpty ? whereClauses.join(' AND ') : null;

      final maps = await db.query(
        'budgets',
        where: where,
        whereArgs: whereArgs.isNotEmpty ? whereArgs : null,
        orderBy: 'start_date DESC',
      );

      return maps.map((map) => BudgetModel.fromMap(map)).toList();
    } catch (e) {
      Logger.error('Failed to get budgets', e);
      rethrow;
    }
  }

  /// Get active budgets (current date within start/end range)
  Future<List<BudgetModel>> getActiveBudgets() async {
    try {
      final now = DateTime.now();
      final today = DateTime(now.year, now.month, now.day);

      final allBudgets = await getAllBudgets();

      return allBudgets.where((budget) {
        final start = DateTime(budget.startDate.year, budget.startDate.month, budget.startDate.day);
        final end = budget.endDate != null
            ? DateTime(budget.endDate!.year, budget.endDate!.month, budget.endDate!.day)
            : null;

        // Check if today is within budget period
        if (end != null) {
          return today.isAfter(start.subtract(const Duration(days: 1))) &&
              today.isBefore(end.add(const Duration(days: 1)));
        } else {
          // No end date means ongoing budget
          return today.isAfter(start.subtract(const Duration(days: 1)));
        }
      }).toList();
    } catch (e) {
      Logger.error('Failed to get active budgets', e);
      rethrow;
    }
  }

  /// Get budget by ID (with decryption)
  Future<BudgetModel?> getBudgetById(int id) async {
    try {
      if (!_encryption.isInitialized) {
        throw Exception('Encryption not initialized');
      }

      final db = await _dbHelper.database;
      final maps = await db.query(
        'budgets',
        where: 'id = ?',
        whereArgs: [id],
        limit: 1,
      );

      if (maps.isEmpty) return null;
      return BudgetModel.fromMap(maps.first);
    } catch (e) {
      Logger.error('Failed to get budget by ID', e);
      rethrow;
    }
  }

  /// Decrypt budget amount
  double decryptAmount(BudgetModel budget) {
    try {
      return _encryption.decryptAmount(budget.amountEncrypted);
    } catch (e) {
      Logger.error('Failed to decrypt budget amount', e);
      rethrow;
    }
  }

  /// Get budget status (spent, remaining, percentage used)
  Future<Map<String, dynamic>> getBudgetStatus(int budgetId) async {
    try {
      final budget = await getBudgetById(budgetId);
      if (budget == null) {
        throw Exception('Budget not found');
      }

      final budgetAmount = decryptAmount(budget);

      // Calculate spent amount for this budget period
      double spent = 0.0;

      if (budget.categoryId != null) {
        // Get expenses for this category within budget period
        final endDate = budget.endDate ?? DateTime.now();
        final expenses = await _expenseRepository.getAllExpenses(
          startDate: budget.startDate,
          endDate: endDate,
          categoryId: budget.categoryId,
        );

        for (final expense in expenses) {
          spent += _expenseRepository.decryptAmount(expense);
        }
      } else {
        // General budget (all categories)
        final endDate = budget.endDate ?? DateTime.now();
        final expenses = await _expenseRepository.getAllExpenses(
          startDate: budget.startDate,
          endDate: endDate,
        );

        for (final expense in expenses) {
          spent += _expenseRepository.decryptAmount(expense);
        }
      }

      final remaining = budgetAmount - spent;
      final percentUsed = budgetAmount > 0 ? (spent / budgetAmount) : 0.0;
      final isOverBudget = spent > budgetAmount;

      return {
        'budget': budgetAmount,
        'spent': spent,
        'remaining': remaining,
        'percentUsed': percentUsed,
        'isOverBudget': isOverBudget,
      };
    } catch (e) {
      Logger.error('Failed to get budget status', e);
      rethrow;
    }
  }

  /// Update budget
  Future<int> updateBudget({
    required int id,
    double? amount,
    int? categoryId,
    String? period,
    DateTime? startDate,
    DateTime? endDate,
    double? alertThreshold,
  }) async {
    try {
      if (!_encryption.isInitialized) {
        throw Exception('Encryption not initialized');
      }

      final db = await _dbHelper.database;
      final existing = await getBudgetById(id);
      if (existing == null) {
        throw Exception('Budget not found');
      }

      // Encrypt updated amount if provided
      final amountEncrypted = amount != null
          ? _encryption.encryptAmount(amount)
          : existing.amountEncrypted;

      final updated = existing.copyWith(
        amountEncrypted: amountEncrypted,
        categoryId: categoryId ?? existing.categoryId,
        period: period ?? existing.period,
        startDate: startDate ?? existing.startDate,
        endDate: endDate ?? existing.endDate,
        alertThreshold: alertThreshold ?? existing.alertThreshold,
      );

      return await db.update(
        'budgets',
        updated.toMap(),
        where: 'id = ?',
        whereArgs: [id],
      );
    } catch (e) {
      Logger.error('Failed to update budget', e);
      rethrow;
    }
  }

  /// Delete budget
  Future<int> deleteBudget(int id) async {
    try {
      final db = await _dbHelper.database;
      return await db.delete(
        'budgets',
        where: 'id = ?',
        whereArgs: [id],
      );
    } catch (e) {
      Logger.error('Failed to delete budget', e);
      rethrow;
    }
  }

  /// Check budget alerts (budgets that have exceeded threshold)
  Future<List<Map<String, dynamic>>> checkBudgetAlerts() async {
    try {
      final activeBudgets = await getActiveBudgets();
      final alerts = <Map<String, dynamic>>[];

      for (final budget in activeBudgets) {
        final status = await getBudgetStatus(budget.id!);
        final percentUsed = status['percentUsed'] as double;

        if (percentUsed >= budget.alertThreshold) {
          alerts.add({
            'budget': budget,
            'status': status,
            'alertType': percentUsed >= 1.0 ? 'exceeded' : 'warning',
          });
        }
      }

      return alerts;
    } catch (e) {
      Logger.error('Failed to check budget alerts', e);
      rethrow;
    }
  }
}
