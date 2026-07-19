import 'package:lifeos_ai/features/chat/domain/chat_message.dart';
import 'package:lifeos_ai/features/chat/domain/chat_repository.dart';

class InMemoryChatRepository implements ChatRepository {
  final List<ChatMessage> _messages = [];

  @override
  List<ChatMessage> getMessages() => List.unmodifiable(_messages);

  @override
  void addMessage(ChatMessage message) => _messages.add(message);

  @override
  void clearMessages() => _messages.clear();
}
