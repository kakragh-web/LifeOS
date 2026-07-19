import 'package:flutter_test/flutter_test.dart';
import 'package:lifeos_ai/features/notes/domain/note.dart';
import 'package:lifeos_ai/features/notes/data/note_repository_impl.dart';

void main() {
  group('InMemoryNoteRepository', () {
    late InMemoryNoteRepository repo;

    setUp(() {
      repo = InMemoryNoteRepository();
    });

    tearDown(() {
      repo.dispose();
    });

    test('starts empty', () async {
      final notes = await repo.getNotes();
      expect(notes, isEmpty);
    });

    test('createNote adds a note', () async {
      final note = Note(
        id: '1',
        createdAt: DateTime.now(),
        title: 'Test note',
        pinned: true,
        category: 'Work',
      );
      final result = await repo.createNote(note);
      expect(result.title, 'Test note');
      expect(await repo.getNotes(), [note]);
    });

    test('updateNote modifies a note', () async {
      final note = Note(
        id: '1',
        createdAt: DateTime.now(),
        title: 'Original',
        pinned: false,
      );
      await repo.createNote(note);
      final updated = note.copyWith(title: 'Updated', pinned: true);
      await repo.updateNote(updated);
      final notes = await repo.getNotes();
      expect(notes.single.title, 'Updated');
      expect(notes.single.pinned, isTrue);
    });

    test('deleteNote removes a note', () async {
      final note = Note(
        id: '1',
        createdAt: DateTime.now(),
        title: 'To delete',
      );
      await repo.createNote(note);
      await repo.deleteNote('1');
      expect(await repo.getNotes(), isEmpty);
    });

    test('watchNotes emits updates', () async {
      final note = Note(
        id: '1',
        createdAt: DateTime.now(),
        title: 'Watched',
      );
      final stream = repo.watchNotes();
      final values = <List<Note>>[];
      final sub = stream.listen(values.add);
      await repo.createNote(note);
      await Future.delayed(const Duration(milliseconds: 200));
      expect(values.last, [note]);
      await sub.cancel();
    });
  });
}
