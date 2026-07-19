import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:lifeos_ai/core/constants/app_constants.dart';
import 'package:lifeos_ai/shared/widgets/app_button.dart';

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

              Semantics(
                label: 'LifeOS logo',
                child: Image.asset(
                  'assets/images/lifeos_logo.PNG',
                  width: size.width * 0.4,
                  height: size.width * 0.4,
                  fit: BoxFit.contain,
                ),
              ),

              const Spacer(flex: 2),

              Semantics(
                label: 'Take control of your life',
                child: Text(
                  'Take control of\nyour life.',
                  style: tt.displaySmall?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: cs.onSurface,
                    height: 1.15,
                  ),
                ),
              ),
              const SizedBox(height: 16),

              ..._features.map(
                (f) => Padding(
                  padding: const EdgeInsets.only(bottom: 10),
                  child: Row(
                    children: [
                      Semantics(
                        label: '${f.label} icon',
                        child: Icon(f.icon, size: 20, color: cs.primary),
                      ),
                      const SizedBox(width: 12),
                      Semantics(
                        label: f.label,
                        child: Text(f.label, style: tt.bodyLarge?.copyWith(color: cs.onSurfaceVariant)),
                      ),
                    ],
                  ),
                ),
              ),

              const Spacer(flex: 3),

              Semantics(
                label: 'Get Started button',
                child: AppButton(
                  label: 'Get Started',
                  onPressed: () => context.go(AppRoutes.register),
                ),
              ),
              const SizedBox(height: 12),
              Semantics(
                label: 'I already have an account button',
                child: AppButton.outlined(
                  label: 'I already have an account',
                  onPressed: () => context.go(AppRoutes.login),
                ),
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
