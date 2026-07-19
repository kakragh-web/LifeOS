import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:lifeos_ai/features/tasks/presentation/screens/tasks_screen.dart';

void main() {
  group('TasksScreen', () {
    testWidgets('renders empty state when no tasks', (tester) async {
      await tester.pumpWidget(
        ProviderScope(
          child: MaterialApp.router(
            routerConfig: GoRouter(
              initialLocation: '/tasks',
              routes: [
                GoRoute(path: '/tasks', builder: (_, __) => const TasksScreen()),
              ],
            ),
          ),
        ),
      );

      expect(find.text('Tasks'), findsOneWidget);
      expect(find.text('No tasks yet'), findsOneWidget);
    });

    testWidgets('shows add task FAB', (tester) async {
      await tester.pumpWidget(
        ProviderScope(
          child: MaterialApp.router(
            routerConfig: GoRouter(
              initialLocation: '/tasks',
              routes: [
                GoRoute(path: '/tasks', builder: (_, __) => const TasksScreen()),
              ],
            ),
          ),
        ),
      );

      expect(find.byType(FloatingActionButton), findsOneWidget);
    });
  });
}
