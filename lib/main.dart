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

  debugPrint('[LifeOS] Application started');
  debugPrint('[LifeOS] Flutter binding initialized');

  bool firebaseReady = false;
  try {
    debugPrint('[LifeOS] Firebase initialization started');
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );
    firebaseReady = true;
    debugPrint('[LifeOS] Firebase initialized successfully');
  } catch (e) {
    debugPrint('[LifeOS] Firebase initialization failed: $e');
    debugPrint('[LifeOS] Development Preview Mode enabled — app will run without Firebase');
  }

  debugPrint('[LifeOS] Initializing storage service');
  final storage = await StorageService.init();
  debugPrint('[LifeOS] Storage service initialized');

  debugPrint('[LifeOS] Starting app with firebaseReady=$firebaseReady');
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
