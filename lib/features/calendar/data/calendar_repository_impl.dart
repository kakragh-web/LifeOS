import 'dart:async';
import 'package:lifeos_ai/features/calendar/domain/calendar_event.dart';
import 'package:lifeos_ai/features/calendar/domain/i_calendar_repository.dart';

class InMemoryCalendarRepository implements ICalendarRepository {
  final List<CalendarEvent> _events = [];
  final _controller = StreamController<List<CalendarEvent>>.broadcast();

  @override
  Stream<List<CalendarEvent>> watchEvents() {
    _controller.add(List.unmodifiable(_events));
    return _controller.stream;
  }

  @override
  Future<List<CalendarEvent>> getEventsForMonth(int year, int month) async {
    await Future.delayed(const Duration(milliseconds: 100));
    return _events
        .where((e) => e.start.year == year && e.start.month == month)
        .toList()
      ..sort((a, b) => a.start.compareTo(b.start));
  }

  @override
  Future<List<CalendarEvent>> getEventsForDay(DateTime day) async {
    await Future.delayed(const Duration(milliseconds: 100));
    return _events
        .where((e) =>
            e.start.year == day.year &&
            e.start.month == day.month &&
            e.start.day == day.day)
        .toList()
      ..sort((a, b) => a.start.compareTo(b.start));
  }

  @override
  Future<CalendarEvent> createEvent(CalendarEvent event) async {
    await Future.delayed(const Duration(milliseconds: 100));
    _events.add(event);
    _notify();
    return event;
  }

  @override
  Future<CalendarEvent> updateEvent(CalendarEvent event) async {
    await Future.delayed(const Duration(milliseconds: 100));
    final idx = _events.indexWhere((e) => e.id == event.id);
    if (idx >= 0) {
      _events[idx] = event;
      _notify();
    }
    return event;
  }

  @override
  Future<void> deleteEvent(String id) async {
    await Future.delayed(const Duration(milliseconds: 100));
    _events.removeWhere((e) => e.id == id);
    _notify();
  }

  void _notify() {
    if (!_controller.isClosed) {
      _controller.add(List.unmodifiable(_events));
    }
  }

  void dispose() {
    _controller.close();
  }
}
