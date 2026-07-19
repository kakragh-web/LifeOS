import 'package:lifeos_ai/features/chat/domain/chat_message.dart';

abstract class ChatRepository {
  List<ChatMessage> getMessages();
  void addMessage(ChatMessage message);
  void clearMessages();
}
