import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
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
          child: MaterialApp(
            theme: ThemeData(useMaterial3: true),
            home: const Scaffold(body: NotesScreen()),
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
      expect(find.text('Notes'), findsOneWidget);
    });

    testWidgets('has a New Note FAB', (tester) async {
      await tester.pumpWidget(buildApp());
      await tester.pumpAndSettle();
      expect(find.text('New Note'), findsOneWidget);
      expect(find.byType(FloatingActionButton), findsOneWidget);
    });
  });
}
