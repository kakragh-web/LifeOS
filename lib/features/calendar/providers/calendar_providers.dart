import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lifeos_ai/features/calendar/domain/i_calendar_repository.dart';
import 'package:lifeos_ai/features/calendar/data/calendar_repository_impl.dart';
import 'package:lifeos_ai/features/calendar/domain/calendar_event.dart';

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
