import 'package:lifeos_ai/features/calendar/domain/calendar_event.dart';

abstract class ICalendarRepository {
  Stream<List<CalendarEvent>> watchEvents();
  Future<List<CalendarEvent>> getEventsForMonth(int year, int month);
  Future<List<CalendarEvent>> getEventsForDay(DateTime day);
  Future<CalendarEvent> createEvent(CalendarEvent event);
  Future<CalendarEvent> updateEvent(CalendarEvent event);
  Future<void> deleteEvent(String id);
}
