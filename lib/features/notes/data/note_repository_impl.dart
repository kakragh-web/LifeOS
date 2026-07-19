import 'dart:async';
import 'package:lifeos_ai/features/notes/domain/note.dart';
import 'package:lifeos_ai/features/notes/domain/i_note_repository.dart';

class InMemoryNoteRepository implements INoteRepository {
  final List<Note> _notes = [];
  final _controller = StreamController<List<Note>>.broadcast();

  @override
  Stream<List<Note>> watchNotes() {
    _controller.add(List.unmodifiable(_notes));
    return _controller.stream;
  }

  @override
  Future<List<Note>> getNotes() async {
    await Future.delayed(const Duration(milliseconds: 100));
    return List.unmodifiable(_notes);
  }

  @override
  Future<Note> createNote(Note note) async {
    await Future.delayed(const Duration(milliseconds: 100));
    _notes.add(note);
    _notify();
    return note;
  }

  @override
  Future<Note> updateNote(Note note) async {
    await Future.delayed(const Duration(milliseconds: 100));
    final idx = _notes.indexWhere((n) => n.id == note.id);
    if (idx >= 0) {
      _notes[idx] = note;
      _notify();
    }
    return note;
  }

  @override
  Future<void> deleteNote(String id) async {
    await Future.delayed(const Duration(milliseconds: 100));
    _notes.removeWhere((n) => n.id == id);
    _notify();
  }

  void _notify() {
    if (!_controller.isClosed) {
      _controller.add(List.unmodifiable(_notes));
    }
  }

  void dispose() {
    _controller.close();
  }
}
