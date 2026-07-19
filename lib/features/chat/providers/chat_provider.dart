import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lifeos_ai/features/chat/data/chat_repository_impl.dart';
import 'package:lifeos_ai/features/chat/domain/chat_message.dart';
import 'package:lifeos_ai/features/chat/domain/chat_repository.dart';

final chatRepositoryProvider = Provider<ChatRepository>(
  (_) => InMemoryChatRepository(),
);

final chatMessagesProvider =
    NotifierProvider<ChatNotifier, List<ChatMessage>>(ChatNotifier.new);

class ChatNotifier extends Notifier<List<ChatMessage>> {
  @override
  List<ChatMessage> build() => [];

  void send(String content) {
    _append(content, MessageRole.user);
    final lower = content.toLowerCase();
    String reply;
    if (lower.contains('task') || lower.contains('todo')) {
      reply =
          'You have ${_randomInt(3, 8)} pending tasks today. Want me to prioritize them?';
    } else if (lower.contains('calendar') || lower.contains('schedule')) {
      reply =
          'Your calendar looks clear until ${_randomInt(1, 5)} PM. Should I schedule a focus block?';
    } else if (lower.contains('note') || lower.contains('remember')) {
      reply = 'I can help you capture that as a note. Want me to save it?';
    } else if (lower.contains('hello') || lower.contains('hi')) {
      reply = 'Hey! How can I help you organize your day?';
    } else {
      reply =
          'Got it. In a production build I would connect this to an AI model. For now, try asking about tasks, calendar, or notes.';
    }
    Future.delayed(const Duration(milliseconds: 800), () {
      _append(reply, MessageRole.assistant);
    });
  }

  int _randomInt(int min, int max) =>
      DateTime.now().millisecond % (max - min) + min;

  void _append(String content, MessageRole role) {
    final repo = ref.read(chatRepositoryProvider);
    final message = ChatMessage(
      id: DateTime.now().microsecondsSinceEpoch.toString(),
      content: content,
      role: role,
      createdAt: DateTime.now(),
    );
    repo.addMessage(message);
    state = [...state, message];
  }

  void clear() {
    ref.read(chatRepositoryProvider).clearMessages();
    state = [];
  }
}
