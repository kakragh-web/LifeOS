import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:lifeos_ai/features/auth/domain/app_user.dart';
import 'package:lifeos_ai/features/auth/domain/i_auth_repository.dart';
import 'package:lifeos_ai/core/services/storage_service.dart';
import 'package:lifeos_ai/features/auth/providers/auth_provider.dart';
import 'package:lifeos_ai/shared/providers/theme_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// Records calls and returns canned values for provider tests.
class FakeAuthRepository implements IAuthRepository {
  AppUser? currentUserValue;
  bool signOutCalled = false;
  String? lastSignInEmail;
  String? lastSignUpEmail;
  String? lastSignUpName;
  bool signInThrows = false;
  bool signUpThrows = false;

  @override
  Stream<AppUser?> get authStateChanges => Stream.value(currentUserValue);

  @override
  AppUser? get currentUser => currentUserValue;

  @override
  Future<AppUser> signInWithEmail(String email, String password) async {
    lastSignInEmail = email;
    if (signInThrows) throw Exception('sign-in failed');
    return AppUser(uid: 'u1', email: email);
  }

  @override
  Future<AppUser> signUpWithEmail(
    String email,
    String password,
    String displayName,
  ) async {
    lastSignUpEmail = email;
    lastSignUpName = displayName;
    if (signUpThrows) throw Exception('sign-up failed');
    return AppUser(uid: 'u1', email: email, displayName: displayName);
  }

  @override
  Future<AppUser> signInWithGoogle() async =>
      AppUser(uid: 'g1', email: 'g@example.com');

  @override
  Future<void> signOut() async => signOutCalled = true;

  @override
  Future<void> sendPasswordResetEmail(String email) async {}
}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('authNotifierProvider', () {
    late FakeAuthRepository fakeRepo;
    late ProviderContainer container;

    setUp(() {
      fakeRepo = FakeAuthRepository();
      container = ProviderContainer(
        overrides: [
          authRepositoryProvider.overrideWithValue(fakeRepo),
        ],
      );
    });

    tearDown(() => container.dispose());

    test('signInWithEmail updates state with the signed-in user', () async {
      await container
          .read(authNotifierProvider.notifier)
          .signInWithEmail('a@b.com', 'pw');

      final state = container.read(authNotifierProvider);
      expect(state.hasError, isFalse);
      expect(state.value?.email, 'a@b.com');
      expect(fakeRepo.lastSignInEmail, 'a@b.com');
    });

    test('signUpWithEmail updates state with the new user', () async {
      await container
          .read(authNotifierProvider.notifier)
          .signUpWithEmail('a@b.com', 'pw', 'Ada');

      final state = container.read(authNotifierProvider);
      expect(state.value?.displayName, 'Ada');
      expect(fakeRepo.lastSignUpName, 'Ada');
    });

    test('signOut clears the user', () async {
      fakeRepo.currentUserValue = AppUser(uid: 'u1', email: 'a@b.com');
      await container.read(authNotifierProvider.notifier).signOut();

      final state = container.read(authNotifierProvider);
      expect(state.valueOrNull, isNull);
      expect(fakeRepo.signOutCalled, isTrue);
    });

    test('signInWithEmail error is captured in state', () async {
      fakeRepo.signInThrows = true;
      await container
          .read(authNotifierProvider.notifier)
          .signInWithEmail('a@b.com', 'pw');

      final state = container.read(authNotifierProvider);
      expect(state.hasError, isTrue);
    });

    test('signUpWithEmail error is captured in state', () async {
      fakeRepo.signUpThrows = true;
      await container
          .read(authNotifierProvider.notifier)
          .signUpWithEmail('a@b.com', 'pw', 'Ada');

      final state = container.read(authNotifierProvider);
      expect(state.hasError, isTrue);
    });
  });

  group('themeModeProvider', () {
    late ProviderContainer container;

    setUp(() async {
      SharedPreferences.setMockInitialValues({});
      final prefs = await SharedPreferences.getInstance();
      container = ProviderContainer(
        overrides: [
          storageServiceProvider.overrideWithValue(
            StorageService(prefs),
          ),
        ],
      );
    });

    tearDown(() => container.dispose());

    test('defaults to system theme', () {
      expect(container.read(themeModeProvider), ThemeMode.system);
    });

    test('toggle switches between dark and light', () async {
      await container.read(themeModeProvider.notifier).setMode(ThemeMode.dark);
      expect(container.read(themeModeProvider), ThemeMode.dark);

      container.read(themeModeProvider.notifier).toggle();
      expect(container.read(themeModeProvider), ThemeMode.light);
    });

    test('persists the selected mode to storage', () async {
      await container
          .read(themeModeProvider.notifier)
          .setMode(ThemeMode.dark);
      // Rebuild a container sharing the same prefs to confirm persistence.
      final stored = container
          .read(storageServiceProvider)
          .getString('theme_mode');
      expect(stored, 'dark');
    });
  });
}
