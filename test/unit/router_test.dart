import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:lifeos_ai/core/constants/app_constants.dart';
import 'package:lifeos_ai/core/router/app_router.dart';
import 'package:lifeos_ai/features/auth/domain/app_user.dart';
import 'package:lifeos_ai/features/auth/providers/auth_provider.dart';
import 'package:lifeos_ai/features/dashboard/presentation/screens/dashboard_screen.dart';
import 'package:lifeos_ai/features/welcome/presentation/screens/welcome_screen.dart';

/// Wraps the real [GoRouter] in a MaterialApp so redirects actually resolve.
WidgetHarness makeApp(
  WidgetTester tester,
  AsyncValue<AppUser?> authState,
) {
  final container = ProviderContainer(
    overrides: [
      authStateProvider.overrideWith((ref) => Stream.value(authState.value)),
    ],
  );
  final router = container.read(routerProvider);

  // Allow Image.asset (used by splash/welcome/register screens) to resolve and
  // provide an empty binary asset manifest so lookups don't crash.
  final manifestCodec = StandardMessageCodec();
  final Object? encodedManifest = manifestCodec.encodeMessage(<Object?, Object?>{});
  final emptyManifest = encodedManifest as ByteData;
  // 1x1 transparent PNG so image decoding succeeds.
  final pngBytes = Uint8List.fromList(<int>[
    0x89, 0x50, 0x4E, 0x47, 0x0D, 0x0A, 0x1A, 0x0A, 0x00, 0x00, 0x00, 0x0D,
    0x49, 0x48, 0x44, 0x52, 0x00, 0x00, 0x00, 0x01, 0x00, 0x00, 0x00, 0x01,
    0x08, 0x06, 0x00, 0x00, 0x00, 0x1F, 0x15, 0xC4, 0x89, 0x00, 0x00, 0x00,
    0x0A, 0x49, 0x44, 0x41, 0x54, 0x78, 0x9C, 0x63, 0x00, 0x01, 0x00, 0x00,
    0x05, 0x00, 0x01, 0x0D, 0x0A, 0x2D, 0xB4, 0x00, 0x00, 0x00, 0x00, 0x49,
    0x45, 0x4E, 0x44, 0xAE, 0x42, 0x60, 0x82,
  ]);
  tester.binding.defaultBinaryMessenger.setMockMessageHandler(
    'flutter/assets',
    (message) async {
      final key = String.fromCharCodes(message!.buffer.asUint8List());
      if (key.contains('AssetManifest')) {
        return ByteData.sublistView(emptyManifest);
      }
      return ByteData.sublistView(pngBytes);
    },
  );

  // Give screens enough room so layout assertions don't overflow.
  tester.view.physicalSize = const Size(800, 1200);
  tester.view.devicePixelRatio = 1.0;

  return WidgetHarness(container, router);
}

class WidgetHarness {
  WidgetHarness(this.container, this.router);
  final ProviderContainer container;
  final GoRouter router;

  Widget build() => UncontrolledProviderScope(
        container: container,
        child: MaterialApp.router(
          routerConfig: router,
          theme: ThemeData(useMaterial3: true),
        ),
      );

  void dispose() => container.dispose();
}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('Router redirect flow', () {
    testWidgets('unauthenticated user at splash → welcome', (tester) async {
      final harness =
          makeApp(tester, const AsyncData<AppUser?>(null));
      await tester.pumpWidget(harness.build());
      await tester.pumpAndSettle();
      expect(find.byType(WelcomeScreen), findsOneWidget);
      harness.dispose();
    });

    testWidgets('authenticated user at splash → dashboard', (tester) async {
      final harness = makeApp(
        tester,
        AsyncData<AppUser?>(AppUser(uid: 'u1', email: 'a@b.com')),
      );
      await tester.pumpWidget(harness.build());
      await tester.pumpAndSettle();
      expect(find.byType(DashboardScreen), findsOneWidget);
      harness.dispose();
    });

    testWidgets('authenticated user on login → dashboard', (tester) async {
      final harness = makeApp(
        tester,
        AsyncData<AppUser?>(AppUser(uid: 'u1', email: 'a@b.com')),
      );
      await tester.pumpWidget(harness.build());
      await tester.pumpAndSettle();
      harness.router.go(AppRoutes.login);
      await tester.pumpAndSettle();
      expect(find.byType(DashboardScreen), findsOneWidget);
      harness.dispose();
    });

    testWidgets('unauthenticated user on dashboard → welcome', (tester) async {
      final harness =
          makeApp(tester, const AsyncData<AppUser?>(null));
      await tester.pumpWidget(harness.build());
      await tester.pumpAndSettle();
      harness.router.go(AppRoutes.dashboard);
      await tester.pumpAndSettle();
      expect(find.byType(WelcomeScreen), findsOneWidget);
      harness.dispose();
    });

    testWidgets('unauthenticated user can reach register screen',
        (tester) async {
      final harness =
          makeApp(tester, const AsyncData<AppUser?>(null));
      await tester.pumpWidget(harness.build());
      await tester.pumpAndSettle();
      harness.router.go(AppRoutes.register);
      await tester.pumpAndSettle();
      expect(find.text('Create your account'), findsOneWidget);
      harness.dispose();
    });
  });
}
