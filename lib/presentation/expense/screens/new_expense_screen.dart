import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../widgets/amount_display.dart';
import '../widgets/category_selector.dart';
import '../widgets/description_input.dart';
import '../widgets/numeric_keypad.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../core/providers/expense_provider.dart';
import '../../../core/providers/category_provider.dart';

/// New expense screen for adding expenses
class NewExpenseScreen extends ConsumerStatefulWidget {
  const NewExpenseScreen({super.key});

  @override
  ConsumerState<NewExpenseScreen> createState() => _NewExpenseScreenState();
}

class _NewExpenseScreenState extends ConsumerState<NewExpenseScreen> {
  String _amount = '0.00';
  int? _selectedCategoryId;
  String _selectedCategoryName = 'Dining';
  final TextEditingController _descriptionController = TextEditingController();

  void _onKeypadInput(String value) {
    setState(() {
      if (value == 'backspace') {
        if (_amount.length > 1) {
          _amount = _amount.substring(0, _amount.length - 1);
        } else {
          _amount = '0.00';
        }
      } else if (value == '.') {
        if (!_amount.contains('.')) {
          _amount += '.';
        }
      } else {
        if (_amount == '0.00' || _amount == '0') {
          _amount = value;
        } else {
          _amount += value;
        }
        // Format to 2 decimal places
        if (_amount.contains('.')) {
          final parts = _amount.split('.');
          if (parts[1].length > 2) {
            _amount = '${parts[0]}.${parts[1].substring(0, 2)}';
          }
        }
      }
    });
  }

  void _onCategorySelected(String categoryName) {
    setState(() {
      _selectedCategoryName = categoryName;
      // Find category ID from the list
      final categories = ref.read(categoryListProvider).categories;
      final category = categories.firstWhere(
        (cat) => cat.name == categoryName,
        orElse: () => categories.first,
      );
      _selectedCategoryId = category.id;
    });
  }

  void _handleReset() {
    setState(() {
      _amount = '0.00';
      _selectedCategoryId = null;
      _selectedCategoryName = 'Dining';
      _descriptionController.clear();
    });
  }

  Future<void> _handleSave() async {
    final amount = double.tryParse(_amount);
    if (amount == null || amount <= 0) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please enter a valid amount'),
          backgroundColor: AppColors.error,
        ),
      );
      return;
    }

    final expenseNotifier = ref.read(expenseListProvider.notifier);
    final success = await expenseNotifier.addExpense(
      amount: amount,
      categoryId: _selectedCategoryId,
      description: _descriptionController.text.trim().isEmpty
          ? null
          : _descriptionController.text.trim(),
      date: DateTime.now(),
    );

    if (success && mounted) {
      context.pop();
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Expense of \$${amount.toStringAsFixed(2)} saved'),
          backgroundColor: AppColors.success,
        ),
      );
    } else if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            ref.read(expenseListProvider).error ?? 'Failed to save expense',
          ),
          backgroundColor: AppColors.error,
        ),
      );
    }
  }

  @override
  void dispose() {
    _descriptionController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final expenseState = ref.watch(expenseListProvider);
    final categoryState = ref.watch(categoryListProvider);

    // Load categories if not loaded
    if (categoryState.categories.isEmpty && !categoryState.isLoading) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        ref.read(categoryListProvider.notifier).loadCategories();
      });
    }

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.close, color: AppColors.textPrimary),
          onPressed: () => context.pop(),
        ),
        title: Text(
          'New Expense',
          style: AppTextStyles.appName.copyWith(fontSize: 20),
        ),
        actions: [
          TextButton(
            onPressed: _handleReset,
            child: Text(
              'Reset',
              style: AppTextStyles.link,
            ),
          ),
        ],
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 24),
                  // Amount Display
                  AmountDisplay(amount: _amount),
                  const SizedBox(height: 32),
                  // Category Selector
                  CategorySelector(
                    selectedCategory: _selectedCategoryName,
                    onCategorySelected: _onCategorySelected,
                    amount: _amount,
                  ),
                  const SizedBox(height: 32),
                  // Description Input
                  DescriptionInput(controller: _descriptionController),
                  const SizedBox(height: 32),
                  // Save Button
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: expenseState.isLoading ? null : _handleSave,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.primaryBlue,
                        foregroundColor: AppColors.textPrimary,
                        padding: const EdgeInsets.symmetric(vertical: 18),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child: expenseState.isLoading
                          ? const SizedBox(
                              height: 20,
                              width: 20,
                              child: CircularProgressIndicator(
                                strokeWidth: 2,
                                valueColor: AlwaysStoppedAnimation<Color>(
                                  AppColors.textPrimary,
                                ),
                              ),
                            )
                          : Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  'Save Expense',
                                  style: AppTextStyles.button,
                                ),
                                const SizedBox(width: 8),
                                const Icon(Icons.check, size: 20),
                              ],
                            ),
                    ),
                  ),
                  const SizedBox(height: 24),
                ],
              ),
            ),
          ),
          // Numeric Keypad
          NumericKeypad(onInput: _onKeypadInput),
        ],
      ),
    );
  }
}
