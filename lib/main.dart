import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lifeos_ai/core/firebase/firebase_options.dart';
import 'package:lifeos_ai/core/router/app_router.dart';
import 'package:lifeos_ai/core/services/storage_service.dart';
import 'package:lifeos_ai/core/theme/app_theme.dart';
import 'package:lifeos_ai/shared/providers/theme_provider.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize Firebase — catches misconfiguration gracefully.
  // If firebase_options.dart still has placeholder values, the app
  // falls back to unauthenticated mode (stub AuthRepository stays active).
  bool firebaseReady = false;
  try {
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );
    firebaseReady = true;
  } catch (_) {
    // Firebase not yet configured — app runs in preview mode.
    // Run `flutterfire configure` and populate firebase_options.dart.
    debugPrint('[LifeOS] Firebase not configured — running in preview mode.');
  }

  final storage = await StorageService.init();

  runApp(
    ProviderScope(
      overrides: [
        storageServiceProvider.overrideWithValue(storage),
        firebaseReadyProvider.overrideWithValue(firebaseReady),
      ],
      child: const LifeOsApp(),
    ),
  );
}

/// Exposes whether Firebase initialized successfully.
/// Used by [authRepositoryProvider] to decide which implementation to use.
final firebaseReadyProvider = Provider<bool>((_) => false);

class LifeOsApp extends ConsumerWidget {
  const LifeOsApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final router = ref.watch(routerProvider);
    final themeMode = ref.watch(themeModeProvider);

    return MaterialApp.router(
      title: 'LifeOS',
      theme: appTheme,
      darkTheme: appDarkTheme,
      themeMode: themeMode,
      routerConfig: router,
      debugShowCheckedModeBanner: false,
    );
  }
}
