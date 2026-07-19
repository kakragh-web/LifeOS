import 'package:flutter_test/flutter_test.dart';
import 'package:lifeos_ai/features/calendar/domain/calendar_event.dart';
import 'package:lifeos_ai/features/calendar/data/calendar_repository_impl.dart';

void main() {
  group('InMemoryCalendarRepository', () {
    late InMemoryCalendarRepository repo;

    setUp(() {
      repo = InMemoryCalendarRepository();
    });

    tearDown(() {
      repo.dispose();
    });

    test('starts empty', () async {
      final events = await repo.getEventsForMonth(2026, 7);
      expect(events, isEmpty);
    });

    test('createEvent adds an event', () async {
      final event = CalendarEvent(
        id: '1',
        createdAt: DateTime.now(),
        title: 'Meeting',
        start: DateTime(2026, 7, 20, 9),
        end: DateTime(2026, 7, 20, 10),
      );
      final result = await repo.createEvent(event);
      expect(result.title, 'Meeting');
      final monthEvents = await repo.getEventsForMonth(2026, 7);
      expect(monthEvents, [event]);
    });

    test('updateEvent modifies an event', () async {
      final event = CalendarEvent(
        id: '1',
        createdAt: DateTime.now(),
        title: 'Original',
        start: DateTime(2026, 7, 20, 9),
        end: DateTime(2026, 7, 20, 10),
      );
      await repo.createEvent(event);
      final updated = event.copyWith(title: 'Updated');
      await repo.updateEvent(updated);
      final events = await repo.getEventsForMonth(2026, 7);
      expect(events.single.title, 'Updated');
    });

    test('deleteEvent removes an event', () async {
      final event = CalendarEvent(
        id: '1',
        createdAt: DateTime.now(),
        title: 'To delete',
        start: DateTime(2026, 7, 20, 9),
        end: DateTime(2026, 7, 20, 10),
      );
      await repo.createEvent(event);
      await repo.deleteEvent('1');
      expect(await repo.getEventsForMonth(2026, 7), isEmpty);
    });

    test('getEventsForDay filters correctly', () async {
      final event1 = CalendarEvent(
        id: '1',
        createdAt: DateTime.now(),
        title: 'Day event',
        start: DateTime(2026, 7, 20, 9),
        end: DateTime(2026, 7, 20, 10),
      );
      final event2 = CalendarEvent(
        id: '2',
        createdAt: DateTime.now(),
        title: 'Other day',
        start: DateTime(2026, 7, 21, 9),
        end: DateTime(2026, 7, 21, 10),
      );
      await repo.createEvent(event1);
      await repo.createEvent(event2);
      final dayEvents = await repo.getEventsForDay(DateTime(2026, 7, 20));
      expect(dayEvents, [event1]);
    });
  });
}
