import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'package:intl/intl.dart';
import '../repositories/expense_repository.dart';
import '../repositories/category_repository.dart';
import '../../core/utils/logger.dart';

/// Service for exporting data to CSV
class ExportService {
  final ExpenseRepository _expenseRepository;
  final CategoryRepository _categoryRepository;

  ExportService(this._expenseRepository, this._categoryRepository);

  /// Export expenses to CSV file
  Future<String?> exportToCSV({
    DateTime? startDate,
    DateTime? endDate,
  }) async {
    try {
      final expenses = await _expenseRepository.getAllExpenses(
        startDate: startDate,
        endDate: endDate,
      );

      if (expenses.isEmpty) {
        throw Exception('No expenses to export');
      }

      // Get categories for lookup
      final categories = await _categoryRepository.getAllCategories();
      final categoryMap = {
        for (var cat in categories) cat.id: cat.name
      };

      // Build CSV content
      final csvBuffer = StringBuffer();
      csvBuffer.writeln('Date,Category,Description,Amount,Payment Method');

      for (final expense in expenses) {
        final date = DateFormat('yyyy-MM-dd').format(expense.date);
        final category = expense.categoryId != null
            ? categoryMap[expense.categoryId] ?? 'Uncategorized'
            : 'Uncategorized';
        final description = _expenseRepository.decryptDescription(expense) ?? '';
        final amount = _expenseRepository.decryptAmount(expense);
        final paymentMethod = expense.paymentMethod ?? '';

        csvBuffer.writeln(
          '$date,"$category","$description",$amount,"$paymentMethod"',
        );
      }

      // Save to file
      final directory = await getApplicationDocumentsDirectory();
      final timestamp = DateFormat('yyyyMMdd_HHmmss').format(DateTime.now());
      final file = File('${directory.path}/fortifi_export_$timestamp.csv');
      await file.writeAsString(csvBuffer.toString());

      Logger.info('CSV exported to: ${file.path}');
      return file.path;
    } catch (e) {
      Logger.error('Failed to export CSV', e);
      rethrow;
    }
  }
}
