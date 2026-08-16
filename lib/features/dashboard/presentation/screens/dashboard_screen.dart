import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:lifeos_ai/core/constants/app_constants.dart';
import 'package:lifeos_ai/core/theme/design_system.dart';
import 'package:lifeos_ai/core/utils/responsive.dart';
import 'package:lifeos_ai/features/auth/domain/app_user.dart';
import 'package:lifeos_ai/features/auth/providers/auth_provider.dart';
import 'package:lifeos_ai/shared/widgets/avatar.dart';
import 'package:lifeos_ai/shared/widgets/responsive_scaffold.dart';

class DashboardScreen extends ConsumerStatefulWidget {
  const DashboardScreen({super.key});

  @override
  ConsumerState<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends ConsumerState<DashboardScreen> {
  final _destinations = <({IconData icon, String label, String route})>[
    (icon: Icons.dashboard_outlined, label: 'Home', route: AppRoutes.dashboard),
    (
      icon: Icons.check_circle_outline_rounded,
      label: 'Tasks',
      route: AppRoutes.tasks
    ),
    (icon: Icons.event_outlined, label: 'Calendar', route: AppRoutes.calendar),
    (icon: Icons.note_outlined, label: 'Notes', route: AppRoutes.notes),
    (icon: Icons.smart_toy_outlined, label: 'AI Chat', route: AppRoutes.chat),
    (
      icon: Icons.settings_outlined,
      label: 'Settings',
      route: AppRoutes.settings
    ),
  ];

  @override
  Widget build(BuildContext context) {
    final user = ref.watch(authStateProvider).valueOrNull;

    return ResponsiveShell(
      title: 'LifeOS',
      currentIndex: 0,
      onDestinationSelected: (index) {
        final route = _destinations[index].route;
        context.push(route);
      },
      destinations: _destinations,
      actions: [
        Semantics(
          label: 'Open settings',
          child: IconButton(
            icon: AppAvatar(
              name: user?.displayName,
              imageUrl: user?.photoUrl,
              size: AvatarSize.small,
              onTap: () => context.push(AppRoutes.settings),
            ),
            onPressed: () => context.push(AppRoutes.settings),
          ),
        ),
        const SizedBox(width: AppSpacing.sm),
      ],
      body: _DashboardBody(user: user),
    );
  }
}

class _DashboardBody extends ConsumerWidget {
  const _DashboardBody({required this.user});

  final AppUser? user;

  static const _features = [
    (
      icon: Icons.calendar_today_outlined,
      label: 'Planner',
      route: AppRoutes.planner,
      color: AppColors.primary
    ),
    (
      icon: Icons.event_outlined,
      label: 'Calendar',
      route: AppRoutes.calendar,
      color: AppColors.secondary
    ),
    (
      icon: Icons.check_circle_outline_rounded,
      label: 'Tasks',
      route: AppRoutes.tasks,
      color: AppColors.tertiary
    ),
    (
      icon: Icons.note_outlined,
      label: 'Notes',
      route: AppRoutes.notes,
      color: AppColors.primaryContainer
    ),
    (
      icon: Icons.smart_toy_outlined,
      label: 'AI Chat',
      route: AppRoutes.chat,
      color: AppColors.secondaryContainer
    ),
    (
      icon: Icons.settings_outlined,
      label: 'Settings',
      route: AppRoutes.settings,
      color: AppColors.tertiaryContainer
    ),
  ];

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final cs = Theme.of(context).colorScheme;
    final crossAxisCount =
        context.responsive(compact: 2, medium: 3, expanded: 4);
    final horizontalPadding = context.horizontalPagePadding;

    return CustomScrollView(
      slivers: [
        SliverToBoxAdapter(
          child: Center(
            child: ConstrainedBox(
              constraints: const BoxConstraints(
                  maxWidth: Breakpoints.maxWideContentWidth),
              child: Padding(
                padding: EdgeInsets.fromLTRB(horizontalPadding + 4,
                    AppSpacing.xl, horizontalPadding + 4, AppSpacing.lg),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Hello, ${user?.displayName?.split(' ').first ?? 'there'} 👋',
                      style: AppTypography.headlineSmall.copyWith(
                        fontWeight: FontWeight.w700,
                        color: cs.onSurface,
                      ),
                    ),
                    const SizedBox(height: AppSpacing.xs),
                    Text(
                      "Here's your overview",
                      style: AppTypography.bodyMedium.copyWith(
                        color: cs.onSurfaceVariant,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
        SliverPadding(
          padding: EdgeInsets.symmetric(
              horizontal: horizontalPadding, vertical: AppSpacing.lg),
          sliver: SliverToBoxAdapter(
            child: Center(
              child: ConstrainedBox(
                constraints: const BoxConstraints(
                    maxWidth: Breakpoints.maxWideContentWidth),
                child: GridView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: crossAxisCount,
                    crossAxisSpacing: AppSpacing.lg,
                    mainAxisSpacing: AppSpacing.lg,
                    childAspectRatio: 1.2,
                  ),
                  itemCount: _features.length,
                  itemBuilder: (context, i) {
                    final f = _features[i];
                    return _FeatureCard(
                      icon: f.icon,
                      label: f.label,
                      route: f.route,
                      color: f.color,
                    );
                  },
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class _FeatureCard extends StatelessWidget {
  const _FeatureCard({
    required this.icon,
    required this.label,
    required this.route,
    required this.color,
  });

  final IconData icon;
  final String label;
  final String route;
  final Color color;

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return GestureDetector(
      onTap: () => context.push(route),
      child: Card(
        elevation: 1,
        margin: EdgeInsets.zero,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppRadius.card),
          side: BorderSide(
            color: cs.outlineVariant.withOpacity(0.3),
            width: 1,
          ),
        ),
        color: AppColors.surfaceContainerHighest,
        child: Padding(
          padding: const EdgeInsets.all(AppSpacing.lg),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                width: 48,
                height: 48,
                decoration: BoxDecoration(
                  color: color,
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Icon(icon, color: cs.onPrimary, size: 24),
              ),
              const SizedBox(height: AppSpacing.md),
              Flexible(
                child: Text(
                  label,
                  textAlign: TextAlign.center,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: AppTypography.labelLarge.copyWith(
                    fontWeight: FontWeight.w600,
                    color: cs.onSurface,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
