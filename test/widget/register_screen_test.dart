import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lifeos_ai/features/auth/presentation/screens/register_screen.dart';
import 'package:lifeos_ai/shared/widgets/app_text_field.dart';
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
            home: const Scaffold(body: RegisterScreen()),
          ),
        ),
      );

  /// Enters text into the AppTextField at [index] (top-to-bottom order).
  Future<void> enterInto(AppTextField field, String text) async {
    final controller = field.controller;
    controller.text = text;
  }

  group('RegisterScreen', () {
    testWidgets('shows the title and subtitle', (tester) async {
      await tester.pumpWidget(buildApp());
      await tester.pumpAndSettle();
      expect(find.text('Create your account'), findsOneWidget);
      expect(find.textContaining('Join'), findsOneWidget);
    });

    testWidgets('renders the name and email fields', (tester) async {
      await tester.pumpWidget(buildApp());
      await tester.pumpAndSettle();
      expect(find.text('Full Name'), findsOneWidget);
      expect(find.text('Email'), findsOneWidget);
    });

    testWidgets('renders the password fields', (tester) async {
      await tester.pumpWidget(buildApp());
      await tester.pumpAndSettle();
      expect(find.text('Password'), findsOneWidget);
      expect(find.text('Confirm Password'), findsOneWidget);
    });

    testWidgets('renders the create account button', (tester) async {
      await tester.pumpWidget(buildApp());
      await tester.pumpAndSettle();
      expect(find.widgetWithText(FilledButton, 'Create Account'),
          findsOneWidget);
    });

    testWidgets('validates and rejects an invalid email', (tester) async {
      await tester.pumpWidget(buildApp());
      await tester.pumpAndSettle();

      final fields =
          tester.widgetList<AppTextField>(find.byType(AppTextField)).toList();
      // Order: name, email, password, confirm.
      await enterInto(fields[0], 'Ada');
      await enterInto(fields[1], 'not-an-email');
      await enterInto(fields[2], 'Password1');
      await enterInto(fields[3], 'Password1');

      await tester
          .tap(find.widgetWithText(FilledButton, 'Create Account'));
      await tester.pumpAndSettle();

      expect(find.text('Enter a valid email address'), findsOneWidget);
    });
  });
}
