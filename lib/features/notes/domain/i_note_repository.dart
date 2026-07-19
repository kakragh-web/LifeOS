import 'package:lifeos_ai/features/notes/domain/note.dart';

abstract class INoteRepository {
  Stream<List<Note>> watchNotes();
  Future<List<Note>> getNotes();
  Future<Note> createNote(Note note);
  Future<Note> updateNote(Note note);
  Future<void> deleteNote(String id);
}
