import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:lifeos_ai/features/dashboard/presentation/screens/dashboard_screen.dart';

void main() {
  group('DashboardScreen', () {
    testWidgets('renders dashboard with feature cards', (tester) async {
      await tester.pumpWidget(
        ProviderScope(
          child: MaterialApp.router(
            routerConfig: GoRouter(
              initialLocation: '/dashboard',
              routes: [
                GoRoute(path: '/dashboard', builder: (_, __) => const DashboardScreen()),
              ],
            ),
          ),
        ),
      );

      expect(find.text('LifeOS'), findsOneWidget);
      expect(find.text('Hello, there'), findsOneWidget);
      expect(find.text('Planner'), findsOneWidget);
      expect(find.text('Calendar'), findsOneWidget);
      expect(find.text('Tasks'), findsOneWidget);
      expect(find.text('Notes'), findsOneWidget);
      expect(find.text('AI Chat'), findsOneWidget);
      expect(find.text('Settings'), findsOneWidget);
    });
  });
}
