import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../widgets/onboarding_header.dart';
import '../widgets/encryption_hero_card.dart';
import '../widgets/onboarding_cta_section.dart';
import '../../../core/providers/auth_provider.dart';
import '../../../core/utils/route_names.dart';

/// Main onboarding/landing screen
class OnboardingScreen extends ConsumerStatefulWidget {
  const OnboardingScreen({super.key});

  @override
  ConsumerState<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends ConsumerState<OnboardingScreen> {
  @override
  void initState() {
    super.initState();
    // Check if user already has a master password
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _checkAuthStatus();
    });
  }

  Future<void> _checkAuthStatus() async {
    // Wait for auth state to load
    await Future.delayed(const Duration(milliseconds: 500));
    
    if (mounted) {
      final authState = ref.read(authProvider);
      // If master password exists, redirect to login
      if (authState.hasMasterPassword) {
        context.go(RouteNames.login);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const SizedBox(height: 20),
              // Header
              const OnboardingHeader(),
              const SizedBox(height: 20),
              // Hero section
              const EncryptionHeroCard(),
              // CTA section
              const OnboardingCtaSection(),
              const SizedBox(height: 40),
            ],
          ),
        ),
      ),
    );
  }
}
