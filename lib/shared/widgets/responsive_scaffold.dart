import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lifeos_ai/core/theme/design_system.dart';
import 'package:lifeos_ai/core/utils/responsive.dart';

class ResponsiveShell extends ConsumerWidget {
  const ResponsiveShell({
    super.key,
    required this.body,
    this.title,
    this.currentIndex,
    required this.onDestinationSelected,
    required this.destinations,
    this.actions,
    this.extendBody = false,
  });

  final Widget body;
  final String? title;
  final int? currentIndex;
  final ValueChanged<int> onDestinationSelected;
  final List<({IconData icon, String label, String route})> destinations;
  final List<Widget>? actions;
  final bool extendBody;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final width = MediaQuery.sizeOf(context).width;
    final isWide = width >= Breakpoints.medium;

    final appBar = AppBar(
      backgroundColor: AppColors.surface,
      foregroundColor: Theme.of(context).colorScheme.onSurface,
      elevation: 0,
      title: title != null
          ? Text(
              title!,
              style: AppTypography.titleLarge.copyWith(
                fontWeight: FontWeight.w700,
              ),
            )
          : null,
      actions: actions,
    );

    final content = body;

    if (isWide) {
      return Scaffold(
        backgroundColor: AppColors.background,
        appBar: appBar,
        body: Row(
          children: [
            NavigationRail(
              destinations: destinations
                  .map(
                    (d) => NavigationRailDestination(
                      icon: Icon(d.icon),
                      selectedIcon: Icon(d.icon),
                      label: Text(d.label),
                    ),
                  )
                  .toList(),
              selectedIndex: currentIndex ?? 0,
              onDestinationSelected: (index) {
                onDestinationSelected(index);
              },
              labelType: NavigationRailLabelType.all,
              backgroundColor: AppColors.surface,
              indicatorColor: Theme.of(context)
                  .colorScheme
                  .primaryContainer
                  .withOpacity(0.5),
            ),
            const VerticalDivider(thickness: 1, width: 1),
            Expanded(child: content),
          ],
        ),
      );
    }

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: appBar,
      body: content,
      bottomNavigationBar: NavigationBar(
        destinations: destinations
            .map(
              (d) => NavigationDestination(
                icon: Icon(d.icon),
                selectedIcon: Icon(d.icon),
                label: d.label,
              ),
            )
            .toList(),
        selectedIndex: currentIndex ?? 0,
        onDestinationSelected: (index) {
          onDestinationSelected(index);
        },
      ),
    );
  }
}
