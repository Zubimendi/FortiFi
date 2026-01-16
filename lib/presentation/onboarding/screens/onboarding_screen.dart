import 'package:flutter/material.dart';
import '../widgets/onboarding_header.dart';
import '../widgets/encryption_hero_card.dart';
import '../widgets/onboarding_cta_section.dart';

/// Main onboarding/landing screen
class OnboardingScreen extends StatelessWidget {
  const OnboardingScreen({super.key});

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
