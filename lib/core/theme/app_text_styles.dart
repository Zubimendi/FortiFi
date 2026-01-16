import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'app_colors.dart';

/// App text styles for consistent typography
class AppTextStyles {
  AppTextStyles._();

  // App name style (24-28sp, bold)
  static TextStyle get appName => GoogleFonts.inter(
        fontSize: 26,
        fontWeight: FontWeight.bold,
        color: AppColors.textPrimary,
        letterSpacing: -0.5,
      );

  // Heading style (32-36sp, bold)
  static TextStyle get heading => GoogleFonts.inter(
        fontSize: 34,
        fontWeight: FontWeight.bold,
        color: AppColors.textPrimary,
        letterSpacing: -0.5,
      );

  // Body text style (16sp, regular)
  static TextStyle get body => GoogleFonts.inter(
        fontSize: 16,
        fontWeight: FontWeight.normal,
        color: AppColors.textPrimary,
        height: 1.5,
      );

  // Body secondary style (16sp, regular, secondary color)
  static TextStyle get bodySecondary => GoogleFonts.inter(
        fontSize: 16,
        fontWeight: FontWeight.normal,
        color: AppColors.textSecondary,
        height: 1.5,
      );

  // Button text style (16sp, semi-bold)
  static TextStyle get button => GoogleFonts.inter(
        fontSize: 16,
        fontWeight: FontWeight.w600,
        color: AppColors.textPrimary,
        letterSpacing: 0.5,
      );

  // Badge/Label style (small, semi-bold)
  static TextStyle get badge => GoogleFonts.inter(
        fontSize: 12,
        fontWeight: FontWeight.w600,
        color: AppColors.textPrimary,
        letterSpacing: 1.2,
      );

  // Link style (16sp, regular, primary blue)
  static TextStyle get link => GoogleFonts.inter(
        fontSize: 16,
        fontWeight: FontWeight.normal,
        color: AppColors.primaryBlue,
        decoration: TextDecoration.none,
      );
}
