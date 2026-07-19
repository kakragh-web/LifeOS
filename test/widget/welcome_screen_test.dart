import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:lifeos_ai/features/welcome/presentation/screens/welcome_screen.dart';

void main() {
  group('WelcomeScreen', () {
    testWidgets('renders welcome message and CTAs', (tester) async {
      await tester.pumpWidget(
        ProviderScope(
          child: MaterialApp.router(
            routerConfig: GoRouter(
              initialLocation: '/welcome',
              routes: [
                GoRoute(path: '/welcome', builder: (_, __) => const WelcomeScreen()),
              ],
            ),
          ),
        ),
      );

      expect(find.text('Take control of'), findsOneWidget);
      expect(find.text('Get Started'), findsOneWidget);
      expect(find.text('I already have an account'), findsOneWidget);
    });

    testWidgets('logo asset loads', (tester) async {
      await tester.pumpWidget(
        ProviderScope(
          child: MaterialApp.router(
            routerConfig: GoRouter(
              initialLocation: '/welcome',
              routes: [
                GoRoute(path: '/welcome', builder: (_, __) => const WelcomeScreen()),
              ],
            ),
          ),
        ),
      );

      final logo = find.byType(Image);
      expect(logo, findsOneWidget);
    });

    testWidgets('Get Started navigates to register', (tester) async {
      final router = GoRouter(
        initialLocation: '/welcome',
        routes: [
          GoRoute(path: '/welcome', builder: (_, __) => const WelcomeScreen()),
          GoRoute(path: '/register', builder: (_, __) => const Scaffold(body: Text('Register'))),
        ],
      );

      await tester.pumpWidget(
        ProviderScope(
          child: MaterialApp.router(routerConfig: router),
        ),
      );

      await tester.tap(find.text('Get Started'));
      await tester.pumpAndSettle();
      expect(find.text('Register'), findsOneWidget);
    });
  });
}
