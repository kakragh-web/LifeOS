import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:lifeos_ai/features/chat/presentation/screens/chat_screen.dart';

void main() {
  group('ChatScreen', () {
    testWidgets('renders empty state when no messages', (tester) async {
      await tester.pumpWidget(
        ProviderScope(
          child: MaterialApp.router(
            routerConfig: GoRouter(
              initialLocation: '/chat',
              routes: [
                GoRoute(path: '/chat', builder: (_, __) => const ChatScreen()),
              ],
            ),
          ),
        ),
      );

      expect(find.text('AI Assistant'), findsOneWidget);
      expect(find.text('LifeOS AI'), findsOneWidget);
    });

    testWidgets('renders message input field', (tester) async {
      await tester.pumpWidget(
        ProviderScope(
          child: MaterialApp.router(
            routerConfig: GoRouter(
              initialLocation: '/chat',
              routes: [
                GoRoute(path: '/chat', builder: (_, __) => const ChatScreen()),
              ],
            ),
          ),
        ),
      );

      expect(find.byType(TextField), findsOneWidget);
    });
  });
}
