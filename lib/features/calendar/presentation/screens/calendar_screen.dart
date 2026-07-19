import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lifeos_ai/core/utils/responsive.dart';
import 'package:lifeos_ai/features/calendar/domain/calendar_event.dart';
import 'package:lifeos_ai/features/calendar/providers/calendar_providers.dart';
import 'package:lifeos_ai/shared/widgets/app_text_field.dart';

class CalendarScreen extends ConsumerStatefulWidget {
  const CalendarScreen({super.key});

  @override
  ConsumerState<CalendarScreen> createState() => _CalendarScreenState();
}

class _CalendarScreenState extends ConsumerState<CalendarScreen> {
  late DateTime _focusedMonth;

  @override
  void initState() {
    super.initState();
    _focusedMonth = DateTime(DateTime.now().year, DateTime.now().month);
  }

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final eventsAsync = ref.watch(calendarEventsProvider);
    final selectedDate = ref.watch(selectedDateProvider);

    final daysInMonth =
        DateUtils.getDaysInMonth(_focusedMonth.year, _focusedMonth.month);
    final firstDayOffset =
        DateTime(_focusedMonth.year, _focusedMonth.month, 1).weekday % 7;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Calendar'),
        actions: [
          IconButton(
            icon: const Icon(Icons.add_rounded),
            tooltip: 'Add event',
            onPressed: () => _showEventForm(context),
          ),
        ],
      ),
      body: Center(
        child: ConstrainedBox(
          constraints:
              const BoxConstraints(maxWidth: Breakpoints.maxWideContentWidth),
          child: Column(
            children: [
              Padding(
                padding: EdgeInsets.symmetric(
                    horizontal: context.horizontalPagePadding, vertical: 12),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    IconButton(
                      icon: const Icon(Icons.chevron_left_rounded),
                      tooltip: 'Previous month',
                      onPressed: () => setState(() {
                        _focusedMonth = DateTime(
                            _focusedMonth.year, _focusedMonth.month - 1);
                      }),
                    ),
                    Flexible(
                      child: Text(
                        '${_monthName(_focusedMonth.month)} ${_focusedMonth.year}',
                        style: Theme.of(context).textTheme.titleLarge,
                        overflow: TextOverflow.ellipsis,
                        textAlign: TextAlign.center,
                      ),
                    ),
                    IconButton(
                      icon: const Icon(Icons.chevron_right_rounded),
                      tooltip: 'Next month',
                      onPressed: () => setState(() {
                        _focusedMonth = DateTime(
                            _focusedMonth.year, _focusedMonth.month + 1);
                      }),
                    ),
                  ],
                ),
              ),
              _WeekdayHeader(cs: cs),
              _MonthGrid(
                cs: cs,
                daysInMonth: daysInMonth,
                firstDayOffset: firstDayOffset,
                focusedMonth: _focusedMonth,
                selectedDate: selectedDate,
                onDateSelected: (d) {
                  ref.read(selectedDateProvider.notifier).state = d;
                  setState(() {});
                },
              ),
              const Divider(height: 24),
              Expanded(
                child: eventsAsync.when(
                  loading: () =>
                      const Center(child: CircularProgressIndicator()),
                  error: (e, _) => Center(
                    child: Semantics(
                      label: 'Error loading events',
                      child: Text('Error: $e'),
                    ),
                  ),
                  data: (events) {
                    final dayEvents = events.where((e) {
                      return e.start.year == selectedDate.year &&
                          e.start.month == selectedDate.month &&
                          e.start.day == selectedDate.day;
                    }).toList()
                      ..sort((a, b) => a.start.compareTo(b.start));

                    if (dayEvents.isEmpty) {
                      return _EmptyDay(
                        cs: cs,
                        onAdd: () =>
                            _showEventForm(context, date: selectedDate),
                      );
                    }
                    return ListView.builder(
                      padding: EdgeInsets.symmetric(
                          horizontal: context.horizontalPagePadding,
                          vertical: 8),
                      itemCount: dayEvents.length,
                      itemBuilder: (_, i) {
                        final event = dayEvents[i];
                        return _EventTile(
                          event: event,
                          onEdit: () => _showEventForm(context, event: event),
                          onDelete: () => _confirmDelete(context, event),
                        );
                      },
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => _showEventForm(context, date: selectedDate),
        icon: const Icon(Icons.add_rounded),
        label: const Text('Add Event'),
      ),
    );
  }

  String _monthName(int m) => const [
        'January',
        'February',
        'March',
        'April',
        'May',
        'June',
        'July',
        'August',
        'September',
        'October',
        'November',
        'December'
      ][m - 1];

  void _showEventForm(BuildContext context,
      {CalendarEvent? event, DateTime? date}) {
    final isEdit = event != null;
    final titleCtrl = TextEditingController(text: event?.title ?? '');
    final descCtrl = TextEditingController(text: event?.description ?? '');
    final startDateCtrl = TextEditingController(
      text: event != null
          ? '${event.start.year}-${event.start.month.toString().padLeft(2, '0')}-${event.start.day.toString().padLeft(2, '0')}'
          : date != null
              ? '${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}'
              : '',
    );
    final startTimeCtrl = TextEditingController(
      text: event != null
          ? '${event.start.hour.toString().padLeft(2, '0')}:${event.start.minute.toString().padLeft(2, '0')}'
          : '09:00',
    );
    final endDateCtrl = TextEditingController(
      text: event != null
          ? '${event.end.year}-${event.end.month.toString().padLeft(2, '0')}-${event.end.day.toString().padLeft(2, '0')}'
          : date != null
              ? '${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}'
              : '',
    );
    final endTimeCtrl = TextEditingController(
      text: event != null
          ? '${event.end.hour.toString().padLeft(2, '0')}:${event.end.minute.toString().padLeft(2, '0')}'
          : '10:00',
    );
    var allDay = event?.allDay ?? false;

    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: Text(isEdit ? 'Edit Event' : 'New Event'),
        content: SizedBox(
          width: (MediaQuery.sizeOf(context).width - 80)
              .clamp(0.0, 440.0)
              .toDouble(),
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                AppTextField(
                  controller: titleCtrl,
                  label: 'Title',
                ),
                const SizedBox(height: 12),
                AppTextField(
                  controller: descCtrl,
                  label: 'Description',
                  maxLines: 3,
                ),
                const SizedBox(height: 12),
                Row(
                  children: [
                    Expanded(
                        child: AppTextField(
                            controller: startDateCtrl, label: 'Start date')),
                    const SizedBox(width: 8),
                    Expanded(
                        child: AppTextField(
                            controller: startTimeCtrl, label: 'Start time')),
                  ],
                ),
                const SizedBox(height: 12),
                Row(
                  children: [
                    Expanded(
                        child: AppTextField(
                            controller: endDateCtrl, label: 'End date')),
                    const SizedBox(width: 8),
                    Expanded(
                        child: AppTextField(
                            controller: endTimeCtrl, label: 'End time')),
                  ],
                ),
                const SizedBox(height: 12),
                SwitchListTile(
                  contentPadding: EdgeInsets.zero,
                  title: const Text('All day'),
                  value: allDay,
                  onChanged: (v) => setState(() => allDay = v),
                ),
              ],
            ),
          ),
        ),
        actions: [
          if (isEdit)
            TextButton(
              onPressed: () async {
                final navigator = Navigator.of(context);
                await ref
                    .read(calendarRepositoryProvider)
                    .deleteEvent(event.id);
                if (mounted) navigator.pop();
              },
              child: Text('Delete',
                  style: TextStyle(color: Theme.of(context).colorScheme.error)),
            ),
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          FilledButton(
            onPressed: () async {
              final title = titleCtrl.text.trim();
              if (title.isEmpty) return;
              final navigator = Navigator.of(context);
              final repo = ref.read(calendarRepositoryProvider);
              final now = DateTime.now();
              final start = _parseDateTime(
                  startDateCtrl.text, startTimeCtrl.text, allDay);
              final end =
                  _parseDateTime(endDateCtrl.text, endTimeCtrl.text, allDay);
              final eventModel = CalendarEvent(
                id: event?.id ??
                    '${now.millisecondsSinceEpoch}-${DateTime.now().microsecondsSinceEpoch}',
                createdAt: event?.createdAt ?? now,
                updatedAt: now,
                title: title,
                description:
                    descCtrl.text.trim().isEmpty ? null : descCtrl.text.trim(),
                start: start,
                end: end,
                allDay: allDay,
              );
              if (isEdit) {
                await repo.updateEvent(eventModel);
              } else {
                await repo.createEvent(eventModel);
              }
              if (mounted) navigator.pop();
            },
            child: Text(isEdit ? 'Save' : 'Create'),
          ),
        ],
      ),
    );
  }

  DateTime _parseDateTime(String dateStr, String timeStr, bool allDay) {
    final dateParts = dateStr.split('-');
    final date = DateTime(
      int.parse(dateParts[0]),
      int.parse(dateParts[1]),
      int.parse(dateParts[2]),
    );
    if (allDay) return DateTime(date.year, date.month, date.day);
    final timeParts = timeStr.split(':');
    return DateTime(date.year, date.month, date.day, int.parse(timeParts[0]),
        int.parse(timeParts[1]));
  }

  void _confirmDelete(BuildContext context, CalendarEvent event) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Delete event?'),
        content: Text('"${event.title}" will be removed.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          FilledButton(
            onPressed: () async {
              final navigator = Navigator.of(context);
              await ref.read(calendarRepositoryProvider).deleteEvent(event.id);
              if (mounted) navigator.pop();
            },
            child: const Text('Delete'),
          ),
        ],
      ),
    );
  }
}

class _WeekdayHeader extends StatelessWidget {
  const _WeekdayHeader({required this.cs});
  final ColorScheme cs;

  @override
  Widget build(BuildContext context) {
    const days = ['Sun', 'Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat'];
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12),
      child: Row(
        children: days
            .map((d) => Expanded(
                  child: Center(
                    child: Text(
                      d,
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w700,
                        color: cs.onSurfaceVariant,
                      ),
                    ),
                  ),
                ))
            .toList(),
      ),
    );
  }
}

class _MonthGrid extends ConsumerWidget {
  const _MonthGrid({
    required this.cs,
    required this.daysInMonth,
    required this.firstDayOffset,
    required this.focusedMonth,
    required this.selectedDate,
    required this.onDateSelected,
  });

  final ColorScheme cs;
  final int daysInMonth;
  final int firstDayOffset;
  final DateTime focusedMonth;
  final DateTime selectedDate;
  final ValueChanged<DateTime> onDateSelected;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final eventsAsync = ref.watch(calendarEventsProvider);
    final today = DateTime.now();

    // Total cells = leading blanks + days, padded to whole weeks so the grid
    // renders a clean rectangle on any width.
    final totalCells = firstDayOffset + daysInMonth;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12),
      child: GridView.builder(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        padding: EdgeInsets.zero,
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 7,
          childAspectRatio: 1,
        ),
        itemCount: totalCells,
        itemBuilder: (context, index) {
          if (index < firstDayOffset) return const SizedBox.shrink();
          final day = index - firstDayOffset + 1;
          final date = DateTime(focusedMonth.year, focusedMonth.month, day);
          final isSelected = date.year == selectedDate.year &&
              date.month == selectedDate.month &&
              date.day == selectedDate.day;
          final isToday = date.year == today.year &&
              date.month == today.month &&
              date.day == today.day;

          final events = eventsAsync.value?.where((e) {
                return e.start.year == date.year &&
                    e.start.month == date.month &&
                    e.start.day == date.day;
              }).toList() ??
              const [];

          return GestureDetector(
            onTap: () => onDateSelected(date),
            child: Container(
              margin: const EdgeInsets.all(4),
              decoration: BoxDecoration(
                color: isSelected ? cs.primaryContainer : null,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Stack(
                children: [
                  Center(
                    child: Text(
                      '$day',
                      style: TextStyle(
                        fontWeight: isToday ? FontWeight.w900 : FontWeight.w500,
                        color: isSelected
                            ? cs.onPrimaryContainer
                            : isToday
                                ? cs.primary
                                : cs.onSurface,
                      ),
                    ),
                  ),
                  if (events.isNotEmpty)
                    Positioned(
                      bottom: 6,
                      left: 0,
                      right: 0,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: List.generate(
                          events.length.clamp(0, 3),
                          (i) => Container(
                            width: 6,
                            height: 6,
                            margin: const EdgeInsets.symmetric(horizontal: 1),
                            decoration: BoxDecoration(
                              color: cs.primary,
                              shape: BoxShape.circle,
                            ),
                          ),
                        ),
                      ),
                    ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}

class _EmptyDay extends StatelessWidget {
  const _EmptyDay({required this.cs, required this.onAdd});
  final ColorScheme cs;
  final VoidCallback onAdd;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        return SingleChildScrollView(
          child: ConstrainedBox(
            constraints: BoxConstraints(minHeight: constraints.maxHeight),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 24),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Semantics(
                    label: 'No events on this day icon',
                    child: Icon(Icons.event_outlined,
                        size: 56, color: cs.onSurfaceVariant),
                  ),
                  const SizedBox(height: 16),
                  Semantics(
                    label: 'No events on this day',
                    child: Text('No events on this day',
                        style: Theme.of(context).textTheme.titleMedium),
                  ),
                  const SizedBox(height: 8),
                  Semantics(
                    label: 'Add event button',
                    child: TextButton.icon(
                      onPressed: onAdd,
                      icon: const Icon(Icons.add_rounded),
                      label: const Text('Add event'),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}

class _EventTile extends ConsumerWidget {
  const _EventTile({
    required this.event,
    required this.onEdit,
    required this.onDelete,
  });

  final CalendarEvent event;
  final VoidCallback onEdit;
  final VoidCallback onDelete;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final cs = Theme.of(context).colorScheme;
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 6),
      child: ListTile(
        leading: Container(
          width: 4,
          height: 40,
          decoration: BoxDecoration(
            color: cs.primary,
            borderRadius: BorderRadius.circular(2),
          ),
        ),
        title: Text(event.title, maxLines: 1, overflow: TextOverflow.ellipsis),
        subtitle: Text(
          '${_formatTime(event.start)} - ${_formatTime(event.end)}${event.allDay ? ' (All day)' : ''}',
        ),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            IconButton(icon: const Icon(Icons.edit_rounded), onPressed: onEdit),
            IconButton(
              icon: Icon(Icons.delete_outline_rounded, color: cs.error),
              onPressed: onDelete,
            ),
          ],
        ),
      ),
    );
  }

  String _formatTime(DateTime d) {
    if (d.hour == 0 && d.minute == 0) return 'All day';
    return '${d.hour.toString().padLeft(2, '0')}:${d.minute.toString().padLeft(2, '0')}';
  }
}
