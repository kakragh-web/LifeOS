import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:lifeos_ai/features/tasks/domain/task.dart';
import 'package:lifeos_ai/features/tasks/providers/task_providers.dart';
import 'package:lifeos_ai/features/tasks/presentation/screens/tasks_screen.dart';
import '../helpers/asset_mocks.dart';

Future<void> pumpSettle(WidgetTester tester) async {
  for (var i = 0; i < 5; i++) {
    await tester.pump(const Duration(milliseconds: 100));
  }
}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  setUp(() {
    mockAssets();
  });

  Widget buildApp() => ProviderScope(
        overrides: [
          tasksProvider.overrideWith((ref) => Stream.value(<Task>[])),
        ],
        child: MediaQuery(
          data: const MediaQueryData(size: Size(800, 1200)),
          child: MaterialApp.router(
            theme: ThemeData(useMaterial3: true),
            routerConfig: GoRouter(
              initialLocation: '/tasks',
              routes: [
                GoRoute(
                    path: '/tasks', builder: (_, __) => const TasksScreen()),
              ],
            ),
          ),
        ),
      );

  group('TasksScreen', () {
    testWidgets('shows empty state when no tasks', (tester) async {
      await tester.pumpWidget(buildApp());
      await pumpSettle(tester);
      expect(find.text('No tasks yet'), findsOneWidget);
      expect(find.text('Create your first task'), findsOneWidget);
    });

    testWidgets('shows the app bar title', (tester) async {
      await tester.pumpWidget(buildApp());
      await pumpSettle(tester);
      expect(find.text('Tasks'), findsAtLeastNWidgets(1));
    });

    testWidgets('has an add action in the app bar', (tester) async {
      await tester.pumpWidget(buildApp());
      await pumpSettle(tester);
      expect(
        find.widgetWithIcon(IconButton, Icons.add_rounded),
        findsOneWidget,
      );
    });
  });
}
