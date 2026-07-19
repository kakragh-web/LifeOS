import 'package:lifeos_ai/shared/models/base_model.dart';

enum TaskPriority { low, medium, high }

enum TaskStatus { todo, inProgress, done }

class Task extends BaseModel {
  const Task({
    required super.id,
    required super.createdAt,
    super.updatedAt,
    required this.title,
    this.description,
    this.priority = TaskPriority.medium,
    this.status = TaskStatus.todo,
    this.category,
    this.dueDate,
  });

  final String title;
  final String? description;
  final TaskPriority priority;
  final TaskStatus status;
  final String? category;
  final DateTime? dueDate;

  Task copyWith({
    String? id,
    DateTime? createdAt,
    DateTime? updatedAt,
    String? title,
    String? description,
    TaskPriority? priority,
    TaskStatus? status,
    String? category,
    DateTime? dueDate,
  }) {
    return Task(
      id: id ?? this.id,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      title: title ?? this.title,
      description: description ?? this.description,
      priority: priority ?? this.priority,
      status: status ?? this.status,
      category: category ?? this.category,
      dueDate: dueDate ?? this.dueDate,
    );
  }

  @override
  Map<String, dynamic> toJson() => {
        'id': id,
        'createdAt': createdAt.toIso8601String(),
        'updatedAt': updatedAt?.toIso8601String(),
        'title': title,
        'description': description,
        'priority': priority.name,
        'status': status.name,
        'category': category,
        'dueDate': dueDate?.toIso8601String(),
      };

  factory Task.fromJson(Map<String, dynamic> json) {
    return Task(
      id: json['id'] as String,
      createdAt: DateTime.parse(json['createdAt'] as String),
      updatedAt:
          json['updatedAt'] != null ? DateTime.parse(json['updatedAt'] as String) : null,
      title: json['title'] as String,
      description: json['description'] as String?,
      priority: TaskPriority.values.firstWhere(
        (e) => e.name == json['priority'] as String,
        orElse: () => TaskPriority.medium,
      ),
      status: TaskStatus.values.firstWhere(
        (e) => e.name == json['status'] as String,
        orElse: () => TaskStatus.todo,
      ),
      category: json['category'] as String?,
      dueDate: json['dueDate'] != null ? DateTime.parse(json['dueDate'] as String) : null,
    );
  }
}
