import '../database/database_helper.dart';
import '../models/expense_model.dart';
import '../services/encryption_service.dart';
import '../../core/utils/logger.dart';

/// Repository for expense operations
class ExpenseRepository {
  final DatabaseHelper _dbHelper = DatabaseHelper.instance;
  final EncryptionService _encryption = EncryptionService.instance;

  /// Create a new expense (amount and description are encrypted)
  Future<int> createExpense({
    required double amount,
    int? categoryId,
    String? description,
    required DateTime date,
    String? paymentMethod,
    String? receiptPath,
    List<String>? tags,
  }) async {
    try {
      if (!_encryption.isInitialized) {
        throw Exception('Encryption not initialized');
      }

      final db = await _dbHelper.database;
      final now = DateTime.now();

      // Encrypt sensitive data
      final amountEncrypted = _encryption.encryptAmount(amount);
      final descriptionEncrypted = description != null && description.isNotEmpty
          ? _encryption.encrypt(description)
          : null;

      final expense = ExpenseModel(
        amountEncrypted: amountEncrypted,
        categoryId: categoryId,
        descriptionEncrypted: descriptionEncrypted,
        date: date,
        paymentMethod: paymentMethod,
        receiptPath: receiptPath,
        tags: tags?.join(','),
        createdAt: now,
        updatedAt: now,
      );

      return await db.insert('expenses', expense.toMap());
    } catch (e) {
      Logger.error('Failed to create expense', e);
      rethrow;
    }
  }

  /// Get all expenses (with decryption)
  Future<List<ExpenseModel>> getAllExpenses({
    DateTime? startDate,
    DateTime? endDate,
    int? categoryId,
    int? limit,
    int? offset,
  }) async {
    try {
      if (!_encryption.isInitialized) {
        throw Exception('Encryption not initialized');
      }

      final db = await _dbHelper.database;
      final List<String> whereClauses = [];
      final List<dynamic> whereArgs = [];

      if (startDate != null) {
        whereClauses.add('date >= ?');
        whereArgs.add(startDate.toIso8601String().split('T')[0]);
      }

      if (endDate != null) {
        whereClauses.add('date <= ?');
        whereArgs.add(endDate.toIso8601String().split('T')[0]);
      }

      if (categoryId != null) {
        whereClauses.add('category_id = ?');
        whereArgs.add(categoryId);
      }

      final where = whereClauses.isNotEmpty ? whereClauses.join(' AND ') : null;

      final maps = await db.query(
        'expenses',
        where: where,
        whereArgs: whereArgs.isNotEmpty ? whereArgs : null,
        orderBy: 'date DESC, created_at DESC',
        limit: limit,
        offset: offset,
      );

      return maps.map((map) => ExpenseModel.fromMap(map)).toList();
    } catch (e) {
      Logger.error('Failed to get expenses', e);
      rethrow;
    }
  }

  /// Get expense by ID (with decryption)
  Future<ExpenseModel?> getExpenseById(int id) async {
    try {
      if (!_encryption.isInitialized) {
        throw Exception('Encryption not initialized');
      }

      final db = await _dbHelper.database;
      final maps = await db.query(
        'expenses',
        where: 'id = ?',
        whereArgs: [id],
        limit: 1,
      );

      if (maps.isEmpty) return null;
      return ExpenseModel.fromMap(maps.first);
    } catch (e) {
      Logger.error('Failed to get expense by ID', e);
      rethrow;
    }
  }

  /// Decrypt expense amount
  double decryptAmount(ExpenseModel expense) {
    try {
      return _encryption.decryptAmount(expense.amountEncrypted);
    } catch (e) {
      Logger.error('Failed to decrypt amount', e);
      rethrow;
    }
  }

  /// Decrypt expense description
  String? decryptDescription(ExpenseModel expense) {
    try {
      if (expense.descriptionEncrypted == null) return null;
      return _encryption.decrypt(expense.descriptionEncrypted!);
    } catch (e) {
      Logger.error('Failed to decrypt description', e);
      return null;
    }
  }

  /// Update expense
  Future<int> updateExpense({
    required int id,
    double? amount,
    int? categoryId,
    String? description,
    DateTime? date,
    String? paymentMethod,
    String? receiptPath,
    List<String>? tags,
  }) async {
    try {
      if (!_encryption.isInitialized) {
        throw Exception('Encryption not initialized');
      }

      final db = await _dbHelper.database;
      final existing = await getExpenseById(id);
      if (existing == null) {
        throw Exception('Expense not found');
      }

      // Encrypt updated fields
      final amountEncrypted = amount != null
          ? _encryption.encryptAmount(amount)
          : existing.amountEncrypted;
      final descriptionEncrypted = description != null
          ? (description.isNotEmpty
              ? _encryption.encrypt(description)
              : null)
          : existing.descriptionEncrypted;

      final updated = existing.copyWith(
        amountEncrypted: amountEncrypted,
        categoryId: categoryId ?? existing.categoryId,
        descriptionEncrypted: descriptionEncrypted,
        date: date ?? existing.date,
        paymentMethod: paymentMethod ?? existing.paymentMethod,
        receiptPath: receiptPath ?? existing.receiptPath,
        tags: tags != null ? tags.join(',') : existing.tags,
        updatedAt: DateTime.now(),
      );

      return await db.update(
        'expenses',
        updated.toMap(),
        where: 'id = ?',
        whereArgs: [id],
      );
    } catch (e) {
      Logger.error('Failed to update expense', e);
      rethrow;
    }
  }

  /// Delete expense
  Future<int> deleteExpense(int id) async {
    try {
      final db = await _dbHelper.database;
      return await db.delete(
        'expenses',
        where: 'id = ?',
        whereArgs: [id],
      );
    } catch (e) {
      Logger.error('Failed to delete expense', e);
      rethrow;
    }
  }

  /// Get total spending for a date range
  Future<double> getTotalSpending({
    DateTime? startDate,
    DateTime? endDate,
    int? categoryId,
  }) async {
    try {
      if (!_encryption.isInitialized) {
        throw Exception('Encryption not initialized');
      }

      final expenses = await getAllExpenses(
        startDate: startDate,
        endDate: endDate,
        categoryId: categoryId,
      );

      double total = 0.0;
      for (final expense in expenses) {
        total += decryptAmount(expense);
      }

      return total;
    } catch (e) {
      Logger.error('Failed to get total spending', e);
      rethrow;
    }
  }
}
