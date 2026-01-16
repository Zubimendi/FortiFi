import 'package:flutter/material.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_text_styles.dart';

/// Description input field with camera icon
class DescriptionInput extends StatelessWidget {
  final TextEditingController controller;

  const DescriptionInput({
    super.key,
    required this.controller,
  });

  void _handleCameraTap() {
    // TODO: Open camera to capture receipt
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'DESCRIPTION',
          style: AppTextStyles.bodySecondary.copyWith(
            fontSize: 12,
            letterSpacing: 1.2,
          ),
        ),
        const SizedBox(height: 12),
        TextField(
          controller: controller,
          style: AppTextStyles.body,
          decoration: InputDecoration(
            hintText: 'What did you buy?',
            hintStyle: AppTextStyles.bodySecondary,
            filled: true,
            fillColor: AppColors.cardBackground,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide.none,
            ),
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 16,
              vertical: 16,
            ),
            suffixIcon: IconButton(
              icon: const Icon(
                Icons.camera_alt,
                color: AppColors.primaryBlue,
              ),
              onPressed: _handleCameraTap,
            ),
          ),
        ),
      ],
    );
  }
}
