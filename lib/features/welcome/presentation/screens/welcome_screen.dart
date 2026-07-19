import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:lifeos_ai/core/constants/app_constants.dart';
import 'package:lifeos_ai/shared/widgets/app_button.dart';

/// Shown to first-time users (not yet signed in, onboarding not complete).
/// Presents the app value proposition and routes to login or register.
class WelcomeScreen extends StatelessWidget {
  const WelcomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final tt = Theme.of(context).textTheme;
    final size = MediaQuery.sizeOf(context);

    return Scaffold(
      backgroundColor: cs.surface,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 28),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const Spacer(flex: 2),

              // Hero illustration area
              Center(
                child: Container(
                  width: size.width * 0.55,
                  height: size.width * 0.55,
                  decoration: BoxDecoration(
                    color: cs.primaryContainer,
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    Icons.self_improvement_rounded,
                    size: size.width * 0.28,
                    color: cs.onPrimaryContainer,
                  ),
                ),
              ),

              const Spacer(flex: 2),

              // Headline
              Text(
                'Take control of\nyour life.',
                style: tt.displaySmall?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: cs.onSurface,
                  height: 1.15,
                ),
              ),
              const SizedBox(height: 16),

              // Feature highlights
              ..._features.map(
                (f) => Padding(
                  padding: const EdgeInsets.only(bottom: 10),
                  child: Row(
                    children: [
                      Icon(f.icon, size: 20, color: cs.primary),
                      const SizedBox(width: 12),
                      Text(f.label, style: tt.bodyLarge?.copyWith(color: cs.onSurfaceVariant)),
                    ],
                  ),
                ),
              ),

              const Spacer(flex: 3),

              // CTA buttons
              AppButton(
                label: 'Get Started',
                onPressed: () => context.go(AppRoutes.register),
              ),
              const SizedBox(height: 12),
              AppButton.outlined(
                label: 'I already have an account',
                onPressed: () => context.go(AppRoutes.login),
              ),
              const SizedBox(height: 24),
            ],
          ),
        ),
      ),
    );
  }

  static const _features = [
    (icon: Icons.check_circle_outline_rounded, label: 'Smart task & habit tracking'),
    (icon: Icons.calendar_month_outlined, label: 'AI-powered daily planner'),
    (icon: Icons.chat_bubble_outline_rounded, label: 'Personal AI life coach'),
  ];
}
