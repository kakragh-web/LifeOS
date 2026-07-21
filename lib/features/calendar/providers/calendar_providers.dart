import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lifeos_ai/features/calendar/data/calendar_repository_impl.dart';
import 'package:lifeos_ai/features/calendar/domain/calendar_event.dart';
import 'package:lifeos_ai/features/calendar/domain/i_calendar_repository.dart';

final calendarRepositoryProvider = Provider<ICalendarRepository>((ref) {
  return InMemoryCalendarRepository();
});

final calendarEventsProvider = StreamProvider<List<CalendarEvent>>((ref) {
  final repo = ref.watch(calendarRepositoryProvider);
  return repo.watchEvents();
});

final selectedDateProvider = StateProvider<DateTime>((ref) {
  final now = DateTime.now();
  return DateTime(now.year, now.month, now.day);
});

final calendarFocusedMonthProvider = StateProvider<DateTime>((ref) {
  final now = DateTime.now();
  return DateTime(now.year, now.month);
});

final calendarEventsForDayProvider =
    Provider.family<List<CalendarEvent>, DateTime>((ref, day) {
  final eventsAsync = ref.watch(calendarEventsProvider);
  return eventsAsync.valueOrNull
          ?.where((e) =>
              e.start.year == day.year &&
              e.start.month == day.month &&
              e.start.day == day.day)
          .toList() ??
      const [];
});

final calendarEventsForMonthProvider =
    Provider.family<List<CalendarEvent>, DateTime>((ref, month) {
  final eventsAsync = ref.watch(calendarEventsProvider);
  return eventsAsync.valueOrNull
          ?.where(
              (e) => e.start.year == month.year && e.start.month == month.month)
          .toList() ??
      const [];
});
