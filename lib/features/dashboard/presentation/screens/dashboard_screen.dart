import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:lifeos_ai/core/constants/app_constants.dart';
import 'package:lifeos_ai/core/utils/responsive.dart';
import 'package:lifeos_ai/features/auth/providers/auth_provider.dart';

class DashboardScreen extends ConsumerWidget {
  const DashboardScreen({super.key});

  static const _features = [
    (
      icon: Icons.calendar_today_outlined,
      label: 'Planner',
      route: AppRoutes.planner
    ),
    (icon: Icons.event_outlined, label: 'Calendar', route: AppRoutes.calendar),
    (
      icon: Icons.check_circle_outline_rounded,
      label: 'Tasks',
      route: AppRoutes.tasks
    ),
    (icon: Icons.note_outlined, label: 'Notes', route: AppRoutes.notes),
    (icon: Icons.smart_toy_outlined, label: 'AI Chat', route: AppRoutes.chat),
    (
      icon: Icons.settings_outlined,
      label: 'Settings',
      route: AppRoutes.settings
    ),
  ];

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final user = ref.watch(authStateProvider).valueOrNull;
    final cs = Theme.of(context).colorScheme;
    // Adaptive grid: 2 columns on phones, 3 on tablets, 4 on wide desktop.
    final crossAxisCount =
        context.responsive(compact: 2, medium: 3, expanded: 4);
    final horizontalPadding = context.horizontalPagePadding;

    return Scaffold(
      appBar: AppBar(
        title: const Text('LifeOS'),
        actions: [
          Semantics(
            label: 'Open settings',
            child: IconButton(
              icon: CircleAvatar(
                radius: 16,
                backgroundImage: user?.photoUrl != null
                    ? NetworkImage(user!.photoUrl!)
                    : null,
                child: user?.photoUrl == null
                    ? Text(
                        user?.displayName?.substring(0, 1).toUpperCase() ?? 'U',
                      )
                    : null,
              ),
              onPressed: () => context.go(AppRoutes.settings),
            ),
          ),
          const SizedBox(width: 8),
        ],
      ),
      body: CustomScrollView(
        slivers: [
          SliverToBoxAdapter(
            child: Center(
              child: ConstrainedBox(
                constraints: const BoxConstraints(
                    maxWidth: Breakpoints.maxWideContentWidth),
                child: Padding(
                  padding: EdgeInsets.fromLTRB(
                      horizontalPadding + 4, 20, horizontalPadding + 4, 8),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Hello, ${user?.displayName?.split(' ').first ?? 'there'} 👋',
                        style:
                            Theme.of(context).textTheme.headlineSmall?.copyWith(
                                  fontWeight: FontWeight.bold,
                                ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        "Here's your overview",
                        style: Theme.of(context)
                            .textTheme
                            .bodyMedium
                            ?.copyWith(color: cs.onSurfaceVariant),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
          SliverPadding(
            padding: EdgeInsets.symmetric(
                horizontal: horizontalPadding, vertical: 16),
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
                      crossAxisSpacing: 12,
                      mainAxisSpacing: 12,
                      childAspectRatio: 1.2,
                    ),
                    itemCount: _features.length,
                    itemBuilder: (context, i) {
                      final f = _features[i];
                      return _FeatureCard(
                        icon: f.icon,
                        label: f.label,
                        onTap: () => context.go(f.route),
                      );
                    },
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _FeatureCard extends StatelessWidget {
  const _FeatureCard({
    required this.icon,
    required this.label,
    required this.onTap,
  });

  final IconData icon;
  final String label;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return Card(
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(icon,
                  size:
                      context.responsive(compact: 32, medium: 36, expanded: 40),
                  color: cs.primary),
              const SizedBox(height: 12),
              Flexible(
                child: Text(
                  label,
                  textAlign: TextAlign.center,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: Theme.of(context)
                      .textTheme
                      .titleSmall
                      ?.copyWith(fontWeight: FontWeight.w600),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
