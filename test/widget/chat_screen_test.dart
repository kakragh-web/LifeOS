import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lifeos_ai/features/chat/presentation/screens/chat_screen.dart';
import '../helpers/asset_mocks.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  setUp(() {
    mockAssets();
  });

  Widget buildApp() => ProviderScope(
        child: MediaQuery(
          data: const MediaQueryData(size: Size(800, 1200)),
          child: MaterialApp(
            theme: ThemeData(useMaterial3: true),
            home: const Scaffold(body: ChatScreen()),
          ),
        ),
      );

  group('ChatScreen', () {
    testWidgets('shows empty state when no messages', (tester) async {
      await tester.pumpWidget(buildApp());
      await tester.pumpAndSettle();
      expect(find.text('LifeOS AI'), findsOneWidget);
      expect(
        find.text('Ask me anything about your tasks, schedule, or goals.'),
        findsOneWidget,
      );
    });

    testWidgets('renders the message input field', (tester) async {
      await tester.pumpWidget(buildApp());
      await tester.pumpAndSettle();
      expect(find.text('Message LifeOS AI…'), findsOneWidget);
    });

    testWidgets('send button is present', (tester) async {
      await tester.pumpWidget(buildApp());
      await tester.pumpAndSettle();
      expect(find.widgetWithIcon(FilledButton, Icons.send_rounded),
          findsOneWidget);
    });
  });
}
