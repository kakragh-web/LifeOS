import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:lifeos_ai/features/splash/presentation/screens/splash_screen.dart';
import 'package:lifeos_ai/main.dart';

void main() {
  group('SplashScreen', () {
    testWidgets('renders logo and loading indicator', (tester) async {
      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            firebaseReadyProvider.overrideWithValue(false),
          ],
          child: MediaQuery(
            data: const MediaQueryData(size: Size(420, 800)),
            child: MaterialApp.router(
            routerConfig: GoRouter(
              initialLocation: '/',
              routes: [
                GoRoute(path: '/', builder: (_, __) => const SplashScreen()),
              ],
            ),
            ),
          ),
        ),
      );

      expect(find.byType(CircularProgressIndicator), findsOneWidget);
      expect(find.text('LifeOS'), findsOneWidget);
      expect(find.text('Your AI-powered life organizer'), findsOneWidget);
    });

    testWidgets('logo asset loads', (tester) async {
      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            firebaseReadyProvider.overrideWithValue(false),
          ],
          child: MediaQuery(
            data: const MediaQueryData(size: Size(420, 800)),
            child: MaterialApp.router(
            routerConfig: GoRouter(
              initialLocation: '/',
              routes: [
                GoRoute(path: '/', builder: (_, __) => const SplashScreen()),
              ],
            ),
            ),
          ),
        ),
      );

      final logo = find.byType(Image);
      expect(logo, findsOneWidget);
    });
  });
}
