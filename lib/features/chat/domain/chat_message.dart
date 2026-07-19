import 'package:lifeos_ai/shared/models/base_model.dart';

enum MessageRole { user, assistant }

class ChatMessage extends BaseModel {
  const ChatMessage({
    required super.id,
    required super.createdAt,
    required this.content,
    required this.role,
    super.updatedAt,
  });

  final String content;
  final MessageRole role;

  @override
  Map<String, dynamic> toJson() => {
        'id': id,
        'content': content,
        'role': role.name,
        'createdAt': createdAt.toIso8601String(),
      };
}
