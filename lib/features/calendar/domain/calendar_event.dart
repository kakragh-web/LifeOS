import 'package:lifeos_ai/shared/models/base_model.dart';

class CalendarEvent extends BaseModel {
  const CalendarEvent({
    required super.id,
    required super.createdAt,
    super.updatedAt,
    required this.title,
    this.description,
    required this.start,
    required this.end,
    this.color,
    this.allDay = false,
  });

  final String title;
  final String? description;
  final DateTime start;
  final DateTime end;
  final String? color;
  final bool allDay;

  CalendarEvent copyWith({
    String? id,
    DateTime? createdAt,
    DateTime? updatedAt,
    String? title,
    String? description,
    DateTime? start,
    DateTime? end,
    String? color,
    bool? allDay,
  }) {
    return CalendarEvent(
      id: id ?? this.id,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      title: title ?? this.title,
      description: description ?? this.description,
      start: start ?? this.start,
      end: end ?? this.end,
      color: color ?? this.color,
      allDay: allDay ?? this.allDay,
    );
  }

  @override
  Map<String, dynamic> toJson() => {
        'id': id,
        'createdAt': createdAt.toIso8601String(),
        'updatedAt': updatedAt?.toIso8601String(),
        'title': title,
        'description': description,
        'start': start.toIso8601String(),
        'end': end.toIso8601String(),
        'color': color,
        'allDay': allDay,
      };

  factory CalendarEvent.fromJson(Map<String, dynamic> json) {
    return CalendarEvent(
      id: json['id'] as String,
      createdAt: DateTime.parse(json['createdAt'] as String),
      updatedAt: json['updatedAt'] != null
          ? DateTime.parse(json['updatedAt'] as String)
          : null,
      title: json['title'] as String,
      description: json['description'] as String?,
      start: DateTime.parse(json['start'] as String),
      end: DateTime.parse(json['end'] as String),
      color: json['color'] as String?,
      allDay: json['allDay'] as bool? ?? false,
    );
  }
}
