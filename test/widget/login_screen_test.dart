import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/goRouter.dart';
import 'package:lifeos_ai/features/login/presentation/screens/login_screen.dart';

void main() {
  group('LoginScreen', () {
    testWidgets('renders login form fields', (tester) async {
      await tester.pumpWidget(
        ProviderScope(
          child: MaterialApp.router(
            routerConfig: GoRouter(
              initialLocation: '/login',
              routes: [
                GoRoute(path: '/login', builder: (_, __) => const LoginScreen()),
              ],
            ),
          ),
        ),
      );

      expect(find.text('Welcome back'), findsOneWidget);
      expect(find.byType(TextFormField), findsNWidgets(2));
      expect(find.text('Sign In'), findsOneWidget);
    });

    testWidgets('shows error when email is empty', (tester) async {
      await tester.pumpWidget(
        ProviderScope(
          child: MaterialApp.router(
            routerConfig: GoRouter(
              initialLocation: '/login',
              routes: [
                GoRoute(path: '/login', builder: (_, __) => const LoginScreen()),
              ],
            ),
          ),
        ),
      );

      await tester.tap(find.text('Sign In'));
      await tester.pump();

      expect(find.text('Email is required'), findsOneWidget);
    });
  });
}
