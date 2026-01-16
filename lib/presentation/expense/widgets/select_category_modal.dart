import 'package:flutter/material.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_text_styles.dart';

/// Category selection modal/bottom sheet
class SelectCategoryModal extends StatefulWidget {
  final String amount;
  final String? selectedCategory;
  final ValueChanged<String> onCategorySelected;
  final VoidCallback? onCreateCustom;

  const SelectCategoryModal({
    super.key,
    required this.amount,
    this.selectedCategory,
    required this.onCategorySelected,
    this.onCreateCustom,
  });

  @override
  State<SelectCategoryModal> createState() => _SelectCategoryModalState();
}

class _SelectCategoryModalState extends State<SelectCategoryModal> {
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }


  List<Map<String, dynamic>> get _categories => const [
        {
          'name': 'Housing',
          'icon': Icons.home,
          'color': AppColors.primaryBlue,
        },
        {
          'name': 'Utilities',
          'icon': Icons.bolt,
          'color': Colors.orange,
        },
        {
          'name': 'Health',
          'icon': Icons.local_hospital,
          'color': Colors.green,
        },
        {
          'name': 'Fun',
          'icon': Icons.sports_esports,
          'color': Colors.purple,
        },
        {
          'name': 'Groceries',
          'icon': Icons.shopping_basket,
          'color': Colors.orange,
        },
        {
          'name': 'Transport',
          'icon': Icons.directions_car,
          'color': AppColors.primaryBlue,
        },
        {
          'name': 'Dining',
          'icon': Icons.restaurant,
          'color': Colors.red,
        },
        {
          'name': 'Shopping',
          'icon': Icons.shopping_bag,
          'color': Colors.pink,
        },
        {
          'name': 'Savings',
          'icon': Icons.savings,
          'color': Colors.yellow,
        },
        {
          'name': 'Education',
          'icon': Icons.school,
          'color': AppColors.primaryBlue,
        },
        {
          'name': 'Travel',
          'icon': Icons.flight,
          'color': Colors.teal,
        },
        {
          'name': 'Other',
          'icon': Icons.more_horiz,
          'color': Colors.grey,
        },
      ];

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final filteredCategories = _categories.where((cat) {
      if (_searchQuery.isEmpty) return true;
      return cat['name'].toString().toLowerCase().contains(_searchQuery.toLowerCase());
    }).toList();

    return Container(
      height: MediaQuery.of(context).size.height * 0.85,
      decoration: BoxDecoration(
        color: Theme.of(context).scaffoldBackgroundColor,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
      ),
      child: Column(
        children: [
          // Handle bar
          Container(
            margin: const EdgeInsets.only(top: 12),
            width: 40,
            height: 4,
            decoration: BoxDecoration(
              color: isDark
                  ? AppColors.cardBackground.withOpacity(0.5)
                  : Colors.grey.shade300,
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          // Header
          Padding(
            padding: const EdgeInsets.all(24),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Select Category',
                        style: AppTextStyles.heading.copyWith(
                          fontSize: 28,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'Where did you spend it?',
                        style: AppTextStyles.bodySecondary.copyWith(
                          fontSize: 14,
                        ),
                      ),
                    ],
                  ),
                ),
                // Amount badge
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 10,
                  ),
                  decoration: BoxDecoration(
                    color: AppColors.primaryBlue,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    '\$${widget.amount}',
                    style: AppTextStyles.body.copyWith(
                      color: AppColors.textPrimary,
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                ),
              ],
            ),
          ),
          // Search bar
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: Container(
              decoration: BoxDecoration(
                color: isDark ? AppColors.cardBackground : Colors.white,
                borderRadius: BorderRadius.circular(12),
              ),
              child: TextField(
                controller: _searchController,
                decoration: InputDecoration(
                  hintText: 'Search categories...',
                  hintStyle: AppTextStyles.bodySecondary.copyWith(
                    fontSize: 14,
                  ),
                  prefixIcon: const Icon(
                    Icons.search,
                    color: AppColors.textSecondary,
                  ),
                  border: InputBorder.none,
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 14,
                  ),
                ),
                style: AppTextStyles.body,
                onChanged: (value) {
                  setState(() {
                    _searchQuery = value;
                  });
                },
              ),
            ),
          ),
          const SizedBox(height: 24),
          // Category grid
          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: GridView.builder(
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 3,
                  crossAxisSpacing: 16,
                  mainAxisSpacing: 16,
                  childAspectRatio: 0.9,
                ),
                itemCount: filteredCategories.length,
                itemBuilder: (context, index) {
                  final category = filteredCategories[index];
                  final isSelected = widget.selectedCategory == category['name'];

                  return _CategoryGridItem(
                    name: category['name'] as String,
                    icon: category['icon'] as IconData,
                    color: category['color'] as Color,
                    isSelected: isSelected,
                    onTap: () {
                      widget.onCategorySelected(category['name'] as String);
                      Navigator.of(context).pop();
                    },
                  );
                },
              ),
            ),
          ),
          // Create Custom Category button
          Padding(
            padding: const EdgeInsets.all(24),
            child: SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: () {
                  if (widget.onCreateCustom != null) {
                    widget.onCreateCustom!();
                  }
                  Navigator.of(context).pop();
                },
                icon: const Icon(Icons.add, color: AppColors.textPrimary),
                label: Text(
                  'Create Custom Category',
                  style: AppTextStyles.button,
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primaryBlue,
                  foregroundColor: AppColors.textPrimary,
                  padding: const EdgeInsets.symmetric(vertical: 18),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _CategoryGridItem extends StatelessWidget {
  final String name;
  final IconData icon;
  final Color color;
  final bool isSelected;
  final VoidCallback onTap;

  const _CategoryGridItem({
    required this.name,
    required this.icon,
    required this.color,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          color: isDark ? AppColors.cardBackground : Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: isSelected
                ? AppColors.primaryBlue
                : (isDark
                    ? AppColors.cardBackground.withOpacity(0.5)
                    : Colors.grey.shade200),
            width: isSelected ? 2 : 1,
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 56,
              height: 56,
              decoration: BoxDecoration(
                color: color.withOpacity(0.2),
                shape: BoxShape.circle,
              ),
              child: Icon(
                icon,
                color: color,
                size: 28,
              ),
            ),
            const SizedBox(height: 12),
            Text(
              name,
              style: AppTextStyles.body.copyWith(
                fontSize: 12,
                fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
              ),
              textAlign: TextAlign.center,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ),
      ),
    );
  }
}
