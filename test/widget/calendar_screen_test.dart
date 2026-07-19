import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:lifeos_ai/features/calendar/presentation/screens/calendar_screen.dart';

void main() {
  group('CalendarScreen', () {
    testWidgets('renders calendar header and empty state', (tester) async {
      await tester.pumpWidget(
        ProviderScope(
          child: MaterialApp.router(
            routerConfig: GoRouter(
              initialLocation: '/calendar',
              routes: [
                GoRoute(path: '/calendar', builder: (_, __) => const CalendarScreen()),
              ],
            ),
          ),
        ),
      );

      expect(find.text('Calendar'), findsOneWidget);
      expect(find.text('No events on this day'), findsOneWidget);
    });

    testWidgets('shows add event FAB', (tester) async {
      await tester.pumpWidget(
        ProviderScope(
          child: MaterialApp.router(
            routerConfig: GoRouter(
              initialLocation: '/calendar',
              routes: [
                GoRoute(path: '/calendar', builder: (_, __) => const CalendarScreen()),
              ],
            ),
          ),
        ),
      );

      expect(find.byType(FloatingActionButton), findsOneWidget);
    });
  });
}
