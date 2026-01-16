import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../core/utils/route_names.dart';

/// Bottom navigation bar for main app screens
class AppBottomNavigation extends StatelessWidget {
  final int currentIndex;

  const AppBottomNavigation({
    super.key,
    required this.currentIndex,
  });

  void _onItemTapped(BuildContext context, int index) {
    switch (index) {
      case 0:
        context.go(RouteNames.dashboard);
        break;
      case 1:
        // TODO: Navigate to budget screen
        break;
      case 2:
        // TODO: Navigate to insights screen
        break;
      case 3:
        // TODO: Navigate to profile screen
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.cardBackground,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 10,
            offset: const Offset(0, -5),
          ),
        ],
      ),
      child: SafeArea(
        child: Container(
          height: 70,
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _buildNavItem(
                context,
                icon: Icons.home,
                label: 'Home',
                index: 0,
              ),
              _buildNavItem(
                context,
                icon: Icons.account_balance_wallet,
                label: 'Budget',
                index: 1,
              ),
              _buildNavItem(
                context,
                icon: Icons.insights,
                label: 'Insights',
                index: 2,
              ),
              _buildNavItem(
                context,
                icon: Icons.person,
                label: 'Profile',
                index: 3,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildNavItem(
    BuildContext context, {
    required IconData icon,
    required String label,
    required int index,
  }) {
    final isSelected = currentIndex == index;
    return Expanded(
      child: InkWell(
        onTap: () => _onItemTapped(context, index),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              icon,
              color: isSelected ? AppColors.primaryBlue : AppColors.textSecondary,
              size: 24,
            ),
            const SizedBox(height: 4),
            Text(
              label,
              style: AppTextStyles.bodySecondary.copyWith(
                color: isSelected ? AppColors.primaryBlue : AppColors.textSecondary,
                fontSize: 12,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
