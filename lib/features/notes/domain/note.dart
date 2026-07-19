import 'package:lifeos_ai/shared/models/base_model.dart';

class Note extends BaseModel {
  const Note({
    required super.id,
    required super.createdAt,
    super.updatedAt,
    required this.title,
    this.content,
    this.pinned = false,
    this.category,
    this.color,
  });

  final String title;
  final String? content;
  final bool pinned;
  final String? category;
  final String? color;

  Note copyWith({
    String? id,
    DateTime? createdAt,
    DateTime? updatedAt,
    String? title,
    String? content,
    bool? pinned,
    String? category,
    String? color,
  }) {
    return Note(
      id: id ?? this.id,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      title: title ?? this.title,
      content: content ?? this.content,
      pinned: pinned ?? this.pinned,
      category: category ?? this.category,
      color: color ?? this.color,
    );
  }

  @override
  Map<String, dynamic> toJson() => {
        'id': id,
        'createdAt': createdAt.toIso8601String(),
        'updatedAt': updatedAt?.toIso8601String(),
        'title': title,
        'content': content,
        'pinned': pinned,
        'category': category,
        'color': color,
      };

  factory Note.fromJson(Map<String, dynamic> json) {
    return Note(
      id: json['id'] as String,
      createdAt: DateTime.parse(json['createdAt'] as String),
      updatedAt: json['updatedAt'] != null
          ? DateTime.parse(json['updatedAt'] as String)
          : null,
      title: json['title'] as String,
      content: json['content'] as String?,
      pinned: json['pinned'] as bool? ?? false,
      category: json['category'] as String?,
      color: json['color'] as String?,
    );
  }
}
