import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:lifeos_ai/core/constants/app_constants.dart';
import 'package:lifeos_ai/core/theme/design_system.dart';
import 'package:lifeos_ai/shared/widgets/animated_button.dart';
import 'package:lifeos_ai/shared/widgets/glass_card.dart';

class WelcomeScreen extends StatelessWidget {
  const WelcomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final size = MediaQuery.sizeOf(context);

    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const Spacer(flex: 2),
              _BrandHero(size: size),
              const Spacer(flex: 2),
              Text(
                'Take control of\nyour life.',
                style: AppTypography.displaySmall.copyWith(
                  fontWeight: FontWeight.w800,
                  color: colorScheme.onBackground,
                  height: 1.1,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: AppSpacing.lg),
              ..._features.map(
                (f) => Padding(
                  padding: const EdgeInsets.only(bottom: AppSpacing.md),
                  child: Row(
                    children: [
                      _FeatureDot(color: _featureColor(f.index)),
                      const SizedBox(width: AppSpacing.md),
                      Expanded(
                        child: Text(
                          f.label,
                          style: AppTypography.bodyLarge.copyWith(
                            color: colorScheme.onSurfaceVariant,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const Spacer(flex: 3),
              _GetStartedButton(context: context),
              const SizedBox(height: AppSpacing.md),
              _SignInLink(context: context),
              const SizedBox(height: AppSpacing.xxl),
            ],
          ),
        ),
      ),
    );
  }

  Color _featureColor(int index) {
    final colors = [
      AppColors.primary,
      AppColors.secondary,
      AppColors.tertiary,
    ];
    return colors[index % colors.length];
  }

  Widget _GetStartedButton({required BuildContext context}) {
    return AnimatedButton(
      label: 'Get Started',
      onPressed: () => context.go(AppRoutes.register),
      variant: ButtonVariant.filled,
      size: ButtonSize.large,
      width: double.infinity,
    );
  }

  Widget _SignInLink({required BuildContext context}) {
    final theme = Theme.of(context);
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          'Already have an account? ',
          style: AppTypography.bodyMedium.copyWith(
            color: theme.colorScheme.onSurfaceVariant,
          ),
        ),
        TextButton(
          onPressed: () => context.go(AppRoutes.login),
          child: Text(
            'Sign In',
            style: AppTypography.bodyMedium.copyWith(
              fontWeight: FontWeight.w600,
              color: theme.colorScheme.primary,
            ),
          ),
        ),
      ],
    );
  }

  static const _features = [
    (index: 0, icon: Icons.check_circle_outline_rounded, label: 'Smart task & habit tracking'),
    (index: 1, icon: Icons.calendar_month_outlined, label: 'AI-powered daily planner'),
    (index: 2, icon: Icons.chat_bubble_outline_rounded, label: 'Personal AI life coach'),
  ];
}

class _BrandHero extends StatelessWidget {
  const _BrandHero({required this.size});

  final Size size;

  @override
  Widget build(BuildContext context) {
    return TweenAnimationBuilder<double>(
      tween: Tween(begin: 0.0, end: 1.0),
      duration: const Duration(milliseconds: 800),
      curve: Curves.easeOutBack,
      builder: (context, value, child) {
        return Transform.scale(scale: value, child: child);
      },
      child: GlassCard(
        padding: const EdgeInsets.all(AppSpacing.xxl),
        elevation: 3,
        blur: 24,
        opacity: 0.85,
        child: Column(
          children: [
            Container(
              width: size.width * 0.25,
              height: size.width * 0.25,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(28),
                boxShadow: AppShadows.primaryGlow(),
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(28),
                child: Image.asset(
                  'assets/images/lifeos_logo.PNG',
                  fit: BoxFit.contain,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _FeatureDot extends StatelessWidget {
  const _FeatureDot({required this.color});

  final Color color;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 8,
      height: 8,
      decoration: BoxDecoration(
        color: color,
        shape: BoxShape.circle,
      ),
    );
  }
}
