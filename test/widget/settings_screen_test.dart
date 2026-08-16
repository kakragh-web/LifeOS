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

      await tester.pumpAndSettle();
      expect(find.text('Settings'), findsAtLeastNWidgets(1));
      expect(find.text('Dark Mode'), findsOneWidget);
    });

    testWidgets('shows sign out button', (tester) async {
      await tester.pumpWidget(
        ProviderScope(
          child: MediaQuery(
            data: const MediaQueryData(size: Size(420, 1200)),
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

      await tester.pumpAndSettle();

      final exception = tester.takeException();
      if (exception != null) {
        fail('Widget build threw exception: $exception');
      }

      expect(find.text('Sign Out'), findsOneWidget);
    });
  });
}
