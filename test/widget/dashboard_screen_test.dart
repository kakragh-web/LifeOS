import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
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
          authStateProvider.overrideWith((ref) => Stream<AppUser?>.value(null)),
        ],
        child: MediaQuery(
          data: const MediaQueryData(size: Size(800, 1200)),
          child: MaterialApp.router(
            theme: ThemeData(useMaterial3: true),
            routerConfig: GoRouter(
              initialLocation: '/dashboard',
              routes: [
                GoRoute(
                    path: '/dashboard',
                    builder: (_, __) => const DashboardScreen()),
              ],
            ),
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
      expect(find.text('Planner'), findsAtLeastNWidgets(1));
      expect(find.text('Calendar'), findsAtLeastNWidgets(1));
      expect(find.text('Tasks'), findsAtLeastNWidgets(1));
      expect(find.text('Notes'), findsAtLeastNWidgets(1));
      expect(find.text('AI Chat'), findsAtLeastNWidgets(1));
      expect(find.text('Settings'), findsAtLeastNWidgets(1));
    });

    testWidgets('renders the app bar title', (tester) async {
      await tester.pumpWidget(buildApp());
      await tester.pumpAndSettle();
      expect(find.text('LifeOS'), findsAtLeastNWidgets(1));
    });
  });
}
