import 'package:flutter/material.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_text_styles.dart';

/// Profile header with avatar and user info
class ProfileHeader extends StatelessWidget {
  const ProfileHeader({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(24),
      child: Row(
        children: [
          // Avatar
          Container(
            width: 80,
            height: 80,
            decoration: BoxDecoration(
              color: AppColors.primaryBlue,
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.person,
              color: AppColors.textPrimary,
              size: 40,
            ),
          ),
          const SizedBox(width: 20),
          // User Info
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Alex Johnson', // TODO: Get from user data
                  style: AppTextStyles.heading.copyWith(fontSize: 24),
                ),
                const SizedBox(height: 4),
                Text(
                  'alex.johnson@example.com', // TODO: Get from user data
                  style: AppTextStyles.bodySecondary,
                ),
              ],
            ),
          ),
          // Edit Button
          IconButton(
            icon: const Icon(
              Icons.edit_outlined,
              color: AppColors.primaryBlue,
            ),
            onPressed: () {
              // TODO: Navigate to profile edit
            },
          ),
        ],
      ),
    );
  }
}
