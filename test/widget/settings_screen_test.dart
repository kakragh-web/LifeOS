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
          child: MediaQuery(
            data: const MediaQueryData(size: Size(420, 800)),
            child: MaterialApp.router(
              routerConfig: GoRouter(
                initialLocation: '/settings',
                routes: [
                  GoRoute(
                      path: '/settings',
                      builder: (_, __) => const SettingsScreen()),
                ],
              ),
            ),
          ),
        ),
      );

      expect(find.text('Settings'), findsOneWidget);
      expect(find.text('Dark Mode'), findsAtLeastNWidgets(1));
      expect(find.text('Notifications'), findsAtLeastNWidgets(1));
      expect(find.text('Privacy & Security'), findsAtLeastNWidgets(1));
      expect(find.text('About'), findsAtLeastNWidgets(1));
    });

    testWidgets('shows sign out button', (tester) async {
      await tester.pumpWidget(
        ProviderScope(
          child: MediaQuery(
            data: const MediaQueryData(size: Size(420, 800)),
            child: MaterialApp.router(
              routerConfig: GoRouter(
                initialLocation: '/settings',
                routes: [
                  GoRoute(
                      path: '/settings',
                      builder: (_, __) => const SettingsScreen()),
                ],
              ),
            ),
          ),
        ),
      );

      expect(find.text('Sign Out'), findsOneWidget);
    });
  });
}
