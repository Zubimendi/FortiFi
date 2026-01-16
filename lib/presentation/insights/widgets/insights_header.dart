import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_text_styles.dart';

/// Insights screen header with back button and share icon
class InsightsHeader extends StatelessWidget {
  const InsightsHeader({super.key});

  void _handleShare() {
    // TODO: Implement share functionality
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
            'Spending Insights',
            style: AppTextStyles.appName.copyWith(fontSize: 20),
          ),
          IconButton(
            icon: const Icon(Icons.share, color: AppColors.textPrimary),
            onPressed: _handleShare,
          ),
        ],
      ),
    );
  }
}
