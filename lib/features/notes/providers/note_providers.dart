import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lifeos_ai/features/notes/data/note_repository_impl.dart';
import 'package:lifeos_ai/features/notes/domain/i_note_repository.dart';
import 'package:lifeos_ai/features/notes/domain/note.dart';

final noteRepositoryProvider = Provider<INoteRepository>((ref) {
  return InMemoryNoteRepository();
});

final notesProvider = StreamProvider<List<Note>>((ref) {
  final repo = ref.watch(noteRepositoryProvider);
  return repo.watchNotes();
});

final noteCategoriesProvider = Provider.autoDispose<List<String>>((ref) {
  final notes = ref.watch(notesProvider).value ?? const <Note>[];
  final cats = <String>{};
  for (final n in notes) {
    if (n.category != null && n.category!.isNotEmpty) {
      cats.add(n.category!);
    }
  }
  return cats.toList()..sort();
});
