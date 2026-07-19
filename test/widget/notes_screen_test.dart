import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:lifeos_ai/features/notes/presentation/screens/notes_screen.dart';

void main() {
  group('NotesScreen', () {
    testWidgets('renders empty state when no notes', (tester) async {
      await tester.pumpWidget(
        ProviderScope(
          child: MaterialApp.router(
            routerConfig: GoRouter(
              initialLocation: '/notes',
              routes: [
                GoRoute(path: '/notes', builder: (_, __) => const NotesScreen()),
              ],
            ),
          ),
        ),
      );

      expect(find.text('Notes'), findsOneWidget);
      expect(find.text('No notes yet'), findsOneWidget);
    });

    testWidgets('shows new note FAB', (tester) async {
      await tester.pumpWidget(
        ProviderScope(
          child: MaterialApp.router(
            routerConfig: GoRouter(
              initialLocation: '/notes',
              routes: [
                GoRoute(path: '/notes', builder: (_, __) => const NotesScreen()),
              ],
            ),
          ),
        ),
      );

      expect(find.byType(FloatingActionButton), findsOneWidget);
    });
  });
}
