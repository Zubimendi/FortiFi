import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../widgets/settings_profile_header.dart';
import '../widgets/settings_section_card.dart';
import '../widgets/settings_item_row.dart';
import '../../core/widgets/bottom_navigation.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../core/providers/theme_provider.dart';

/// Settings screen with security, appearance, and data management
class SettingsScreen extends ConsumerWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final themeMode = ref.watch(themeModeProvider);
    final isDarkMode = themeMode == ThemeMode.dark;

    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(
            Icons.chevron_left,
            color: Theme.of(context).brightness == Brightness.dark
                ? AppColors.textPrimary
                : Colors.black87,
          ),
          onPressed: () => context.pop(),
        ),
        title: Text(
          'Settings',
          style: AppTextStyles.appName.copyWith(
            fontSize: 20,
            color: Theme.of(context).brightness == Brightness.dark
                ? AppColors.textPrimary
                : Colors.black87,
          ),
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 24),
              // Profile Header
              const SettingsProfileHeader(),
              const SizedBox(height: 32),
              // SECURITY Section
              SettingsSectionCard(
                title: 'SECURITY',
                children: [
                  SettingsItemRow(
                    icon: Icons.lock_outline,
                    title: 'Master Password',
                    onTap: () {
                      // TODO: Navigate to change master password
                    },
                  ),
                  SettingsItemRow(
                    icon: Icons.fingerprint,
                    title: 'Face ID / Touch ID',
                    trailing: Switch(
                      value: true, // TODO: Get from state
                      onChanged: (value) {
                        // TODO: Update biometric setting
                      },
                      activeColor: AppColors.primaryBlue,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 24),
              // APPEARANCE Section
              SettingsSectionCard(
                title: 'APPEARANCE',
                children: [
                  SettingsItemRow(
                    icon: Icons.dark_mode_outlined,
                    title: 'Dark Mode',
                    trailing: Switch(
                      value: isDarkMode,
                      onChanged: (value) {
                        ref.read(themeModeProvider.notifier).setThemeMode(
                              value ? ThemeMode.dark : ThemeMode.light,
                            );
                      },
                      activeColor: AppColors.primaryBlue,
                    ),
                  ),
                  SettingsItemRow(
                    icon: Icons.palette_outlined,
                    title: 'Accent Color',
                    subtitle: 'Royal Blue',
                    onTap: () {
                      // TODO: Show accent color picker
                    },
                  ),
                ],
              ),
              const SizedBox(height: 24),
              // DATA & PRIVACY Section
              SettingsSectionCard(
                title: 'DATA & PRIVACY',
                children: [
                  SettingsItemRow(
                    icon: Icons.file_download_outlined,
                    title: 'Export CSV Report',
                    trailing: const Icon(
                      Icons.download,
                      color: AppColors.primaryBlue,
                      size: 20,
                    ),
                    onTap: () {
                      // TODO: Export CSV
                    },
                  ),
                  SettingsItemRow(
                    icon: Icons.privacy_tip_outlined,
                    title: 'Privacy Policy',
                    trailing: const Icon(
                      Icons.open_in_new,
                      color: AppColors.primaryBlue,
                      size: 20,
                    ),
                    onTap: () {
                      // TODO: Show privacy policy
                    },
                  ),
                  SettingsItemRow(
                    icon: Icons.delete_outline,
                    title: 'Clear All Data',
                    iconColor: AppColors.error,
                    titleColor: AppColors.error,
                    onTap: () {
                      // TODO: Show confirmation dialog
                    },
                  ),
                ],
              ),
              const SizedBox(height: 16),
              // Warning message
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: Text(
                  'Clearing data is permanent and cannot be undone. All your expense history, linked accounts, and budget goals will be wiped.',
                  style: AppTextStyles.bodySecondary.copyWith(
                    fontSize: 12,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
              const SizedBox(height: 32),
              // App Version Info
              Center(
                child: Column(
                  children: [
                    Text(
                      'FORTIFI',
                      style: AppTextStyles.bodySecondary.copyWith(
                        fontSize: 12,
                        letterSpacing: 2,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'Version 1.0.0 (Build 1)',
                      style: AppTextStyles.bodySecondary.copyWith(
                        fontSize: 12,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      '© 2024 FortiFi',
                      style: AppTextStyles.bodySecondary.copyWith(
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),
            ],
          ),
        ),
      ),
      bottomNavigationBar: const AppBottomNavigation(currentIndex: 3),
    );
  }
}
