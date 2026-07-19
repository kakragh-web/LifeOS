import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:lifeos_ai/features/settings/presentation/screens/settings_screen.dart';

void main() {
  group('SettingsScreen', () {
    testWidgets('renders settings options', (tester) async {
      await tester.pumpWidget(
        ProviderScope(
          child: MaterialApp.router(
            routerConfig: GoRouter(
              initialLocation: '/settings',
              routes: [
                GoRoute(path: '/settings', builder: (_, __) => const SettingsScreen()),
              ],
            ),
          ),
        ),
      );

      expect(find.text('Settings'), findsOneWidget);
      expect(find.text('Dark mode'), findsOneWidget);
      expect(find.text('Notifications'), findsOneWidget);
      expect(find.text('Privacy & Security'), findsOneWidget);
      expect(find.text('About'), findsOneWidget);
    });

    testWidgets('shows sign out button', (tester) async {
      await tester.pumpWidget(
        ProviderScope(
          child: MaterialApp.router(
            routerConfig: GoRouter(
              initialLocation: '/settings',
              routes: [
                GoRoute(path: '/settings', builder: (_, __) => const SettingsScreen()),
              ],
            ),
          ),
        ),
      );

      expect(find.text('Sign Out'), findsOneWidget);
    });
  });
}
