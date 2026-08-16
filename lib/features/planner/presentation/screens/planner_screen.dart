import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:lifeos_ai/core/constants/app_constants.dart';
import 'package:lifeos_ai/shared/widgets/responsive_scaffold.dart';

class PlannerScreen extends ConsumerWidget {
  const PlannerScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final destinations = <({IconData icon, String label, String route})>[
      (
        icon: Icons.dashboard_outlined,
        label: 'Home',
        route: AppRoutes.dashboard
      ),
      (
        icon: Icons.check_circle_outline_rounded,
        label: 'Tasks',
        route: AppRoutes.tasks
      ),
      (
        icon: Icons.event_outlined,
        label: 'Calendar',
        route: AppRoutes.calendar
      ),
      (icon: Icons.note_outlined, label: 'Notes', route: AppRoutes.notes),
      (icon: Icons.smart_toy_outlined, label: 'AI Chat', route: AppRoutes.chat),
      (
        icon: Icons.settings_outlined,
        label: 'Settings',
        route: AppRoutes.settings
      ),
    ];

    return ResponsiveShell(
      title: 'Planner',
      currentIndex: 0,
      onDestinationSelected: (index) {
        final route = destinations[index].route;
        context.push(route);
      },
      destinations: destinations,
      body: const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.calendar_month_outlined, size: 64, color: Colors.grey),
            SizedBox(height: 16),
            Text(
              'Planner coming soon',
              style: TextStyle(fontSize: 18, color: Colors.grey),
            ),
            SizedBox(height: 8),
            Text(
              'AI-powered daily planning will be available here',
              style: TextStyle(fontSize: 14, color: Colors.grey),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}
