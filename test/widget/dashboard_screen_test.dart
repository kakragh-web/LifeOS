import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lifeos_ai/features/auth/domain/app_user.dart';
import 'package:lifeos_ai/features/auth/providers/auth_provider.dart';
import 'package:lifeos_ai/features/dashboard/presentation/screens/dashboard_screen.dart';
import '../helpers/asset_mocks.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  setUp(() {
    mockAssets();
  });

  Widget buildApp() => ProviderScope(
        overrides: [
          authStateProvider
              .overrideWith((ref) => Stream<AppUser?>.value(null)),
        ],
        child: MediaQuery(
          data: const MediaQueryData(size: Size(800, 1200)),
          child: MaterialApp(
            theme: ThemeData(useMaterial3: true),
            home: const Scaffold(body: DashboardScreen()),
          ),
        ),
      );

  group('DashboardScreen', () {
    testWidgets('greets the user', (tester) async {
      await tester.pumpWidget(buildApp());
      await tester.pumpAndSettle();
      expect(find.textContaining('Hello,'), findsOneWidget);
    });

    testWidgets('renders the feature cards', (tester) async {
      await tester.pumpWidget(buildApp());
      await tester.pumpAndSettle();
      expect(find.text('Planner'), findsOneWidget);
      expect(find.text('Calendar'), findsOneWidget);
      expect(find.text('Tasks'), findsOneWidget);
      expect(find.text('Notes'), findsOneWidget);
      expect(find.text('AI Chat'), findsOneWidget);
      expect(find.text('Settings'), findsOneWidget);
    });

    testWidgets('renders the app bar title', (tester) async {
      await tester.pumpWidget(buildApp());
      await tester.pumpAndSettle();
      expect(find.text('LifeOS'), findsWidgets);
    });
  });
}
