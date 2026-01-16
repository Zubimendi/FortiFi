import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../core/utils/route_names.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_text_styles.dart';
import '../onboarding/screens/onboarding_screen.dart';
import '../security/screens/security_screen.dart';
import '../dashboard/screens/dashboard_screen.dart';
import '../expense/screens/new_expense_screen.dart';

/// App router configuration using go_router
final GoRouter appRouter = GoRouter(
  initialLocation: RouteNames.onboarding,
  debugLogDiagnostics: true,
  errorBuilder: (context, state) => Scaffold(
    appBar: AppBar(
      leading: IconButton(
        icon: const Icon(Icons.arrow_back, color: AppColors.textPrimary),
        onPressed: () => context.go(RouteNames.onboarding),
      ),
      title: Text(
        'Page Not Found',
        style: AppTextStyles.appName.copyWith(fontSize: 20),
      ),
      backgroundColor: Colors.transparent,
    ),
    body: Center(
      child: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Page Not Found',
              style: AppTextStyles.heading,
            ),
            const SizedBox(height: 16),
            Text(
              'GoException: ${state.error}',
              style: AppTextStyles.bodySecondary,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 32),
            TextButton(
              onPressed: () => context.go(RouteNames.onboarding),
              child: Text(
                'Home',
                style: AppTextStyles.link.copyWith(fontSize: 18),
              ),
            ),
          ],
        ),
      ),
    ),
  ),
  routes: [
    GoRoute(
      path: RouteNames.onboarding,
      name: 'onboarding',
      builder: (context, state) => const OnboardingScreen(),
    ),
    GoRoute(
      path: RouteNames.masterPasswordSetup,
      name: 'master-password-setup',
      builder: (context, state) => const SecurityScreen(),
    ),
    GoRoute(
      path: RouteNames.dashboard,
      name: 'dashboard',
      builder: (context, state) => const DashboardScreen(),
    ),
    GoRoute(
      path: RouteNames.addExpense,
      name: 'add-expense',
      builder: (context, state) => const NewExpenseScreen(),
    ),
    // Additional routes will be added as screens are implemented
    // GoRoute(
    //   path: RouteNames.login,
    //   builder: (context, state) => const LoginScreen(),
    // ),
  ],
);
