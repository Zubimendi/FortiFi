import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../data/models/category_model.dart';

class AddBudgetDialog extends StatefulWidget {
  final List<CategoryModel> categories;

  const AddBudgetDialog({super.key, required this.categories});

  @override
  State<AddBudgetDialog> createState() => _AddBudgetDialogState();
}

class _AddBudgetDialogState extends State<AddBudgetDialog> {
  int? _selectedCategoryId;
  final TextEditingController _amountController = TextEditingController();
  String _selectedPeriod = 'monthly';

  @override
  void dispose() {
    _amountController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return AlertDialog(
      backgroundColor: isDark ? AppColors.cardBackground : Colors.white,
      title: Text(
        'Add New Budget',
        style: AppTextStyles.heading.copyWith(
          fontSize: 20,
          color: isDark ? AppColors.textPrimary : Colors.black87,
        ),
      ),
      content: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Category dropdown
            Text(
              'Category',
              style: AppTextStyles.bodySecondary.copyWith(
                fontSize: 12,
                color: isDark ? AppColors.textSecondary : Colors.grey.shade700,
              ),
            ),
            const SizedBox(height: 8),
            DropdownButtonFormField<int>(
              initialValue: _selectedCategoryId,
              decoration: InputDecoration(
                filled: true,
                fillColor: isDark ? AppColors.backgroundDark : Colors.grey.shade100,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide.none,
                ),
              ),
              items: widget.categories.map((category) {
                return DropdownMenuItem<int>(
                  value: category.id,
                  child: Text(
                    category.name,
                    style: TextStyle(
                      color: isDark ? AppColors.textPrimary : Colors.black87,
                    ),
                  ),
                );
              }).toList(),
              onChanged: (value) {
                setState(() {
                  _selectedCategoryId = value;
                });
              },
            ),
            const SizedBox(height: 16),
            // Amount input
            Text(
              'Budget Amount',
              style: AppTextStyles.bodySecondary.copyWith(
                fontSize: 12,
                color: isDark ? AppColors.textSecondary : Colors.grey.shade700,
              ),
            ),
            const SizedBox(height: 8),
            TextField(
              controller: _amountController,
              keyboardType: const TextInputType.numberWithOptions(decimal: true),
              inputFormatters: [
                FilteringTextInputFormatter.allow(RegExp(r'^\d+\.?\d{0,2}')),
              ],
              decoration: InputDecoration(
                prefixText: '\$ ',
                filled: true,
                fillColor: isDark ? AppColors.backgroundDark : Colors.grey.shade100,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide.none,
                ),
              ),
              style: TextStyle(
                color: isDark ? AppColors.textPrimary : Colors.black87,
              ),
            ),
            const SizedBox(height: 16),
            // Period selector
            Text(
              'Period',
              style: AppTextStyles.bodySecondary.copyWith(
                fontSize: 12,
                color: isDark ? AppColors.textSecondary : Colors.grey.shade700,
              ),
            ),
            const SizedBox(height: 8),
            DropdownButtonFormField<String>(
              initialValue: _selectedPeriod,
              decoration: InputDecoration(
                filled: true,
                fillColor: isDark ? AppColors.backgroundDark : Colors.grey.shade100,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide.none,
                ),
              ),
              items: ['daily', 'weekly', 'monthly', 'yearly'].map((period) {
                return DropdownMenuItem<String>(
                  value: period,
                  child: Text(
                    period[0].toUpperCase() + period.substring(1),
                    style: TextStyle(
                      color: isDark ? AppColors.textPrimary : Colors.black87,
                    ),
                  ),
                );
              }).toList(),
              onChanged: (value) {
                setState(() {
                  _selectedPeriod = value!;
                });
              },
            ),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: Text(
            'Cancel',
            style: TextStyle(
              color: isDark ? AppColors.textSecondary : Colors.grey.shade700,
            ),
          ),
        ),
        ElevatedButton(
          onPressed: () {
            final amount = double.tryParse(_amountController.text);
            if (amount == null || amount <= 0) {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Please enter a valid amount'),
                  backgroundColor: AppColors.error,
                ),
              );
              return;
            }

            Navigator.of(context).pop({
              'categoryId': _selectedCategoryId,
              'amount': amount,
              'period': _selectedPeriod,
              'startDate': DateTime.now(),
            });
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: AppColors.primaryBlue,
            foregroundColor: AppColors.textPrimary,
          ),
          child: const Text('Create'),
        ),
      ],
    );
  }
}
