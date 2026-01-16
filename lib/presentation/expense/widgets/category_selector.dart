import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../core/providers/category_provider.dart';
import 'select_category_modal.dart';

/// Category selector with horizontal scrollable pills
class CategorySelector extends ConsumerWidget {
  final String selectedCategory;
  final ValueChanged<String> onCategorySelected;
  final String? amount;

  const CategorySelector({
    super.key,
    required this.selectedCategory,
    required this.onCategorySelected,
    this.amount,
  });

  IconData _getIconForCategory(String categoryName) {
    switch (categoryName.toLowerCase()) {
      case 'dining':
        return Icons.restaurant;
      case 'shopping':
        return Icons.shopping_bag;
      case 'transport':
      case 'transportation':
        return Icons.directions_car;
      case 'groceries':
        return Icons.shopping_cart;
      case 'entertainment':
      case 'fun':
        return Icons.movie;
      case 'bills':
      case 'utilities':
        return Icons.receipt;
      case 'health':
        return Icons.local_hospital;
      case 'education':
        return Icons.school;
      case 'travel':
        return Icons.flight;
      case 'housing':
      case 'home':
        return Icons.home;
      case 'savings':
        return Icons.savings;
      default:
        return Icons.category;
    }
  }


  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final categoryState = ref.watch(categoryListProvider);
    
    // Load categories if not loaded
    if (categoryState.categories.isEmpty && !categoryState.isLoading) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        ref.read(categoryListProvider.notifier).loadCategories();
      });
    }

    // Get expense categories (limit to 10 for horizontal scroll)
    final categories = categoryState.categories
        .where((cat) => cat.type == 'expense')
        .take(10)
        .toList();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'CATEGORY',
          style: AppTextStyles.bodySecondary.copyWith(
            fontSize: 12,
            letterSpacing: 1.2,
          ),
        ),
        const SizedBox(height: 16),
        SizedBox(
          height: 50,
          child: categoryState.isLoading
              ? const Center(child: CircularProgressIndicator())
              : ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: categories.length + 1, // +1 for "View All" button
                  itemBuilder: (context, index) {
                    if (index == categories.length) {
                      // "View All" button
                      return Padding(
                        padding: const EdgeInsets.only(left: 12),
                        child: _CategoryPill(
                          name: 'View All',
                          icon: Icons.grid_view,
                          isSelected: false,
                          onTap: () => _showCategoryModal(context, ref),
                          isViewAll: true,
                        ),
                      );
                    }

                    final category = categories[index];
                    final isSelected = selectedCategory == category.name;
                    
                    return Padding(
                      padding: EdgeInsets.only(
                        right: index < categories.length - 1 ? 12 : 0,
                      ),
                      child: _CategoryPill(
                        name: category.name,
                        icon: _getIconForCategory(category.name),
                        isSelected: isSelected,
                        onTap: () => onCategorySelected(category.name),
                      ),
                    );
                  },
                ),
        ),
      ],
    );
  }

  void _showCategoryModal(BuildContext context, WidgetRef ref) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => SelectCategoryModal(
        amount: amount ?? '0.00',
        selectedCategory: selectedCategory,
        onCategorySelected: onCategorySelected,
      ),
    );
  }
}

class _CategoryPill extends StatelessWidget {
  final String name;
  final IconData icon;
  final bool isSelected;
  final VoidCallback onTap;
  final bool isViewAll;

  const _CategoryPill({
    required this.name,
    required this.icon,
    required this.isSelected,
    required this.onTap,
    this.isViewAll = false,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
        decoration: BoxDecoration(
          color: isSelected
              ? AppColors.primaryBlue
              : (isViewAll
                  ? AppColors.primaryBlue.withOpacity(0.1)
                  : AppColors.cardBackground),
          borderRadius: BorderRadius.circular(25),
          border: Border.all(
            color: isSelected
                ? AppColors.primaryBlue
                : (isViewAll
                    ? AppColors.primaryBlue.withOpacity(0.3)
                    : AppColors.cardBackground),
            width: isViewAll ? 1.5 : 1,
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              icon,
              color: AppColors.textPrimary,
              size: 20,
            ),
            const SizedBox(width: 8),
            Text(
              name.length > 8 ? '${name.substring(0, 8)}...' : name,
              style: AppTextStyles.body.copyWith(
                fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
                fontSize: 14,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
