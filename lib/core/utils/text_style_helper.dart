import 'package:flutter/material.dart';
import '../theme/app_text_styles.dart';

/// Extension to make text styles theme-aware
extension TextStyleThemeExtension on TextStyle {
  /// Apply theme-aware color to text style
  TextStyle withTheme(BuildContext context) {
    final brightness = Theme.of(context).brightness;
    if (brightness == Brightness.light) {
      // In light mode, use dark text
      return copyWith(
        color: color == AppColors.textPrimary
            ? Colors.black87
            : (color == AppColors.textSecondary
                ? Colors.grey.shade700
                : color),
      );
    }
    // In dark mode, keep original colors
    return this;
  }
}
