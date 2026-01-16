import 'package:flutter/material.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_text_styles.dart';

/// Category selector with horizontal scrollable pills
class CategorySelector extends StatelessWidget {
  final String selectedCategory;
  final ValueChanged<String> onCategorySelected;

  const CategorySelector({
    super.key,
    required this.selectedCategory,
    required this.onCategorySelected,
  });

  final List<Map<String, dynamic>> _categories = const [
    {'name': 'Dining', 'icon': Icons.restaurant},
    {'name': 'Shopping', 'icon': Icons.shopping_bag},
    {'name': 'Transportation', 'icon': Icons.directions_car},
    {'name': 'Groceries', 'icon': Icons.shopping_cart},
    {'name': 'Entertainment', 'icon': Icons.movie},
    {'name': 'Bills', 'icon': Icons.receipt},
    {'name': 'Health', 'icon': Icons.local_hospital},
    {'name': 'Education', 'icon': Icons.school},
    {'name': 'Travel', 'icon': Icons.flight},
    {'name': 'Other', 'icon': Icons.category},
  ];

  @override
  Widget build(BuildContext context) {
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
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: _categories.length,
            itemBuilder: (context, index) {
              final category = _categories[index];
              final isSelected = selectedCategory == category['name'];
              
              return Padding(
                padding: EdgeInsets.only(
                  right: index < _categories.length - 1 ? 12 : 0,
                ),
                child: _CategoryPill(
                  name: category['name'] as String,
                  icon: category['icon'] as IconData,
                  isSelected: isSelected,
                  onTap: () => onCategorySelected(category['name'] as String),
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}

class _CategoryPill extends StatelessWidget {
  final String name;
  final IconData icon;
  final bool isSelected;
  final VoidCallback onTap;

  const _CategoryPill({
    required this.name,
    required this.icon,
    required this.isSelected,
    required this.onTap,
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
              : AppColors.cardBackground,
          borderRadius: BorderRadius.circular(25),
          border: Border.all(
            color: isSelected
                ? AppColors.primaryBlue
                : AppColors.cardBackground,
            width: 1,
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
