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
import '../../../core/providers/auth_provider.dart';
import '../../../core/providers/expense_provider.dart';
import '../../../core/providers/category_provider.dart';
import '../../../core/providers/budget_provider.dart';
import '../../../data/services/auth_service.dart';
import '../../../data/services/export_service.dart';
import '../../../core/utils/route_names.dart';
import 'package:share_plus/share_plus.dart';
import 'dart:io';

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
                    onTap: () => _showChangePasswordDialog(context, ref),
                  ),
                  SettingsItemRow(
                    icon: Icons.fingerprint,
                    title: 'Face ID / Touch ID',
                    trailing: Switch(
                      value: true, // TODO: Get from state
                      onChanged: (value) {
                        // TODO: Update biometric setting
                      },
                      activeThumbColor: AppColors.primaryBlue,
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
                      activeThumbColor: AppColors.primaryBlue,
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
                    onTap: () => _exportCSV(context, ref),
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
                    icon: Icons.lock_reset,
                    title: 'Reset Master Password',
                    subtitle: 'Warning: Deletes all encrypted data',
                    iconColor: AppColors.error,
                    titleColor: AppColors.error,
                    onTap: () => _showResetPasswordDialog(context, ref),
                  ),
                  SettingsItemRow(
                    icon: Icons.delete_outline,
                    title: 'Clear All Data',
                    iconColor: AppColors.error,
                    titleColor: AppColors.error,
                    onTap: () => _showClearDataDialog(context, ref),
                  ),
                  SettingsItemRow(
                    icon: Icons.logout,
                    title: 'Logout',
                    iconColor: AppColors.error,
                    titleColor: AppColors.error,
                    onTap: () => _handleLogout(context, ref),
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
                      '© 2026 FortiFi',
                      style: AppTextStyles.bodySecondary.copyWith(
                        fontSize: 12,
                        color: Theme.of(context).brightness == Brightness.dark
                            ? AppColors.textSecondary
                            : Colors.grey.shade700,
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

  Future<void> _exportCSV(BuildContext context, WidgetRef ref) async {
    try {
      final expenseRepo = ref.read(expenseRepositoryProvider);
      final categoryRepo = ref.read(categoryRepositoryProvider);
      final exportService = ExportService(expenseRepo, categoryRepo);

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Exporting CSV...'),
          duration: Duration(seconds: 1),
        ),
      );

      final filePath = await exportService.exportToCSV();
      
      if (filePath != null && context.mounted) {
        final file = File(filePath);
        if (await file.exists()) {
          await Share.shareXFiles([XFile(filePath)], text: 'FortiFi Expense Report');
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('CSV exported successfully'),
              backgroundColor: AppColors.success,
            ),
          );
        }
      }
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Failed to export CSV: $e'),
            backgroundColor: AppColors.error,
          ),
        );
      }
    }
  }

  Future<void> _showChangePasswordDialog(BuildContext context, WidgetRef ref) async {
    final oldPasswordController = TextEditingController();
    final newPasswordController = TextEditingController();
    final confirmPasswordController = TextEditingController();

    await showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Change Master Password'),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: oldPasswordController,
                obscureText: true,
                decoration: const InputDecoration(
                  labelText: 'Current Password',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 16),
              TextField(
                controller: newPasswordController,
                obscureText: true,
                decoration: const InputDecoration(
                  labelText: 'New Password',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 16),
              TextField(
                controller: confirmPasswordController,
                obscureText: true,
                decoration: const InputDecoration(
                  labelText: 'Confirm New Password',
                  border: OutlineInputBorder(),
                ),
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () async {
              if (newPasswordController.text.length < 12) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Password must be at least 12 characters'),
                    backgroundColor: AppColors.error,
                  ),
                );
                return;
              }

              if (newPasswordController.text != confirmPasswordController.text) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Passwords do not match'),
                    backgroundColor: AppColors.error,
                  ),
                );
                return;
              }

              final authService = ref.read(authServiceProvider);
              final verified = await authService.verifyMasterPassword(
                oldPasswordController.text,
              );

              if (!verified) {
                if (context.mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Current password is incorrect'),
                      backgroundColor: AppColors.error,
                    ),
                  );
                }
                return;
              }

              final authNotifier = ref.read(authProvider.notifier);
              final success = await authNotifier.setMasterPassword(
                newPasswordController.text,
              );

              if (context.mounted) {
                Navigator.of(context).pop();
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(
                      success
                          ? 'Password changed successfully'
                          : 'Failed to change password',
                    ),
                    backgroundColor:
                        success ? AppColors.success : AppColors.error,
                  ),
                );
              }
            },
            child: const Text('Change'),
          ),
        ],
      ),
    );
  }

  Future<void> _showClearDataDialog(BuildContext context, WidgetRef ref) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Clear All Data'),
        content: const Text(
          'This will permanently delete all your expenses, budgets, and categories. This action cannot be undone.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () => Navigator.of(context).pop(true),
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.error,
            ),
            child: const Text('Delete All'),
          ),
        ],
      ),
    );

    if (confirmed == true) {
      try {
        final expenseNotifier = ref.read(expenseListProvider.notifier);
        final budgetNotifier = ref.read(budgetListProvider.notifier);

        // Clear all data
        final expenses = ref.read(expenseListProvider).expenses;
        for (final expense in expenses) {
          await expenseNotifier.deleteExpense(expense.id!);
        }

        final budgets = ref.read(budgetListProvider).budgets;
        for (final budget in budgets) {
          await budgetNotifier.deleteBudget(budget.id!);
        }

        if (context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('All data cleared successfully'),
              backgroundColor: AppColors.success,
            ),
          );
        }
      } catch (e) {
        if (context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Failed to clear data: $e'),
              backgroundColor: AppColors.error,
            ),
          );
        }
      }
    }
  }

  Future<void> _handleLogout(BuildContext context, WidgetRef ref) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Logout'),
        content: const Text('Are you sure you want to logout?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () => Navigator.of(context).pop(true),
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.error,
            ),
            child: const Text('Logout'),
          ),
        ],
      ),
    );

    if (confirmed == true && context.mounted) {
      ref.read(authProvider.notifier).logout();
      context.go(RouteNames.onboarding);
    }
  }

  Future<void> _showResetPasswordDialog(BuildContext context, WidgetRef ref) async {
    // First confirmation - explain what will happen
    final firstConfirm = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('⚠️ Reset Master Password'),
        content: const Text(
          'This will permanently delete ALL your encrypted data including:\n\n'
          '• All expense records\n'
          '• All budget information\n'
          '• All recurring expenses\n\n'
          'This action CANNOT be undone. You will need to set a new master password and start fresh.\n\n'
          'Are you absolutely sure you want to continue?',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () => Navigator.of(context).pop(true),
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.error,
            ),
            child: const Text('I Understand'),
          ),
        ],
      ),
    );

    if (firstConfirm != true) return;

    // Second confirmation - require typing "RESET" to confirm
    final confirmController = TextEditingController();
    final secondConfirm = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Final Confirmation'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text(
              'To confirm, please type "RESET" in the box below:',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: confirmController,
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                hintText: 'Type RESET',
              ),
              autofocus: true,
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              if (confirmController.text.trim().toUpperCase() == 'RESET') {
                Navigator.of(context).pop(true);
              } else {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Please type "RESET" exactly to confirm'),
                    backgroundColor: AppColors.error,
                  ),
                );
              }
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.error,
            ),
            child: const Text('Reset Password'),
          ),
        ],
      ),
    );

    if (secondConfirm != true) return;

    // Perform the reset
    try {
      final authService = ref.read(authServiceProvider);
      final success = await authService.resetMasterPassword();

      if (success && context.mounted) {
        // Clear encryption service
        final encryptionService = ref.read(encryptionServiceProvider);
        encryptionService.clear();

        // Clear auth state
        ref.read(authProvider.notifier).logout();

        // Show success message
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text(
              'Master password reset. Please set a new password.',
            ),
            backgroundColor: AppColors.success,
            duration: Duration(seconds: 3),
          ),
        );

        // Navigate to onboarding/security screen
        if (context.mounted) {
          context.go(RouteNames.onboarding);
        }
      } else if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Failed to reset master password'),
            backgroundColor: AppColors.error,
          ),
        );
      }
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error: $e'),
            backgroundColor: AppColors.error,
          ),
        );
      }
    }
  }
}
