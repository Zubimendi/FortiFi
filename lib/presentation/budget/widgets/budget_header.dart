import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../core/providers/user_profile_provider.dart';
import '../../../core/utils/route_names.dart';

/// Budget screen header with profile and title
class BudgetHeader extends ConsumerWidget {
  const BudgetHeader({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final profile = ref.watch(userProfileProvider).profile;
    final userName = profile?.name ?? 'User';
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
      child: Row(
        children: [
          // Profile Picture
          Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              color: AppColors.cardBackground,
              borderRadius: BorderRadius.circular(12),
            ),
            child: const Icon(
              Icons.person,
              color: AppColors.textPrimary,
              size: 24,
            ),
          ),
          const SizedBox(width: 16),
          // Welcome Text
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Welcome back,',
                  style: AppTextStyles.bodySecondary.copyWith(fontSize: 14),
                ),
                const SizedBox(height: 2),
                Text(
                  userName,
                  style: AppTextStyles.heading.copyWith(fontSize: 24),
                ),
              ],
            ),
          ),
          // Settings Icon
          IconButton(
            icon: const Icon(
              Icons.settings_outlined,
              color: AppColors.textPrimary,
            ),
            onPressed: () {
              context.push(RouteNames.settings);
            },
          ),
        ],
      ),
    );
  }
}
