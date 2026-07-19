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
    Future.delayed(const Duration(milliseconds: 800), () {
      _append(
        "I'm LifeOS AI. Full AI integration coming soon!",
        MessageRole.assistant,
      );
    });
  }

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
