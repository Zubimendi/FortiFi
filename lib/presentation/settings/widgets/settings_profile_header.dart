import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../core/providers/user_profile_provider.dart';
import '../../../core/utils/route_names.dart';
import 'dart:io';

/// Settings profile header with avatar and account info
class SettingsProfileHeader extends ConsumerWidget {
  const SettingsProfileHeader({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final profile = ref.watch(userProfileProvider).profile;
    final userName = profile?.name ?? 'User';
    final profilePicturePath = profile?.profilePicturePath;

    return GestureDetector(
      onTap: () => context.push(RouteNames.editProfile),
      child: Center(
        child: Column(
          children: [
            // Profile Picture
            Stack(
              children: [
                Container(
                  width: 80,
                  height: 80,
                  decoration: BoxDecoration(
                    color: isDark
                        ? AppColors.cardBackground
                        : Colors.grey.shade200,
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: AppColors.primaryBlue.withOpacity(0.3),
                      width: 2,
                    ),
                  ),
                  child: profilePicturePath != null
                      ? ClipOval(
                          child: Image.file(
                            File(profilePicturePath),
                            fit: BoxFit.cover,
                          ),
                        )
                      : Icon(
                          Icons.person,
                          color: AppColors.primaryBlue,
                          size: 40,
                        ),
                ),
                Positioned(
                  bottom: 0,
                  right: 0,
                  child: Container(
                    width: 24,
                    height: 24,
                    decoration: BoxDecoration(
                      color: AppColors.primaryBlue,
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: isDark ? AppColors.backgroundDark : Colors.white,
                        width: 2,
                      ),
                    ),
                    child: const Icon(
                      Icons.edit,
                      color: AppColors.textPrimary,
                      size: 12,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            // Account Name
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  userName,
                  style: AppTextStyles.heading.copyWith(
                    fontSize: 24,
                    color: isDark ? AppColors.textPrimary : Colors.black87,
                  ),
                ),
                const SizedBox(width: 8),
                Icon(
                  Icons.edit,
                  size: 16,
                  color: isDark ? AppColors.textSecondary : Colors.grey.shade600,
                ),
              ],
            ),
            const SizedBox(height: 4),
            // Account Type
            Text(
              'Personal Account',
              style: AppTextStyles.bodySecondary.copyWith(
                fontSize: 14,
                color: isDark ? AppColors.textSecondary : Colors.grey.shade700,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              'Tap to edit profile',
              style: AppTextStyles.bodySecondary.copyWith(
                fontSize: 12,
                color: isDark ? AppColors.textSecondary : Colors.grey.shade600,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
