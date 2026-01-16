import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_text_styles.dart';

/// Category Analysis header with back button, title, and calendar icon
class CategoryAnalysisHeader extends StatelessWidget {
  const CategoryAnalysisHeader({super.key});

  void _handleCalendarTap() {
    // TODO: Show date range picker
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          IconButton(
            icon: const Icon(Icons.arrow_back, color: AppColors.textPrimary),
            onPressed: () => context.pop(),
          ),
          Text(
            'Category Analysis',
            style: AppTextStyles.appName.copyWith(fontSize: 20),
          ),
          IconButton(
            icon: const Icon(Icons.calendar_today, color: AppColors.textPrimary),
            onPressed: _handleCalendarTap,
          ),
        ],
      ),
    );
  }
}
