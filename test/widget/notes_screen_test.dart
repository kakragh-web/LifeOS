import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:lifeos_ai/features/notes/domain/note.dart';
import 'package:lifeos_ai/features/notes/providers/note_providers.dart';
import 'package:lifeos_ai/features/notes/presentation/screens/notes_screen.dart';
import '../helpers/asset_mocks.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  setUp(() {
    mockAssets();
  });

  Widget buildApp() => ProviderScope(
        overrides: [
          notesProvider.overrideWith((ref) => Stream.value(<Note>[])),
        ],
        child: MediaQuery(
          data: const MediaQueryData(size: Size(800, 1200)),
          child: MaterialApp.router(
            theme: ThemeData(useMaterial3: true),
            routerConfig: GoRouter(
              initialLocation: '/notes',
              routes: [
                GoRoute(
                    path: '/notes', builder: (_, __) => const NotesScreen()),
              ],
            ),
          ),
        ),
      );

  group('NotesScreen', () {
    testWidgets('shows empty state when no notes', (tester) async {
      await tester.pumpWidget(buildApp());
      await tester.pumpAndSettle();
      expect(find.text('No notes yet'), findsOneWidget);
      expect(find.text('Create your first note'), findsOneWidget);
    });

    testWidgets('shows the app bar title', (tester) async {
      await tester.pumpWidget(buildApp());
      await tester.pumpAndSettle();
      expect(find.text('Notes'), findsAtLeastNWidgets(1));
    });

    testWidgets('has an add note action in the app bar', (tester) async {
      await tester.pumpWidget(buildApp());
      await tester.pumpAndSettle();
      expect(
        find.widgetWithIcon(IconButton, Icons.add_rounded),
        findsOneWidget,
      );
    });
  });
}
