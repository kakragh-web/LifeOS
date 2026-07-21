import 'dart:async';
import 'dart:developer' as developer;

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lifeos_ai/features/auth/data/auth_repository.dart';
import 'package:lifeos_ai/features/auth/data/firebase_auth_repository.dart';
import 'package:lifeos_ai/features/auth/domain/app_user.dart';
import 'package:lifeos_ai/features/auth/domain/i_auth_repository.dart';
import 'package:lifeos_ai/main.dart' show firebaseReadyProvider;

final authRepositoryProvider = Provider<IAuthRepository>((ref) {
  final firebaseReady = ref.read(firebaseReadyProvider);
  developer.log(
      '[LifeOS Auth] Repository selected: ${firebaseReady ? 'Firebase' : 'Stub'}');
  return firebaseReady ? FirebaseAuthRepository() : AuthRepository();
});

final authStateProvider = StreamProvider<AppUser?>((ref) {
  final repo = ref.watch(authRepositoryProvider);
  return repo.authStateChanges;
});

class AuthNotifier extends AsyncNotifier<AppUser?> {
  IAuthRepository get _repo => ref.read(authRepositoryProvider);

  @override
  Future<AppUser?> build() async => _repo.currentUser;

  Future<void> signInWithGoogle() async {
    developer.log('[LifeOS Auth] signInWithGoogle called');
    state = const AsyncLoading();
    state = await AsyncValue.guard<AppUser?>(() => _repo.signInWithGoogle());
    if (state.hasError) {
      developer.log('[LifeOS Auth] signInWithGoogle failed',
          error: state.error);
    }
  }

  Future<void> signInWithEmail(String email, String password) async {
    developer.log('[LifeOS Auth] signInWithEmail called for $email');
    state = const AsyncLoading();
    state = await AsyncValue.guard<AppUser?>(
      () => _repo.signInWithEmail(email, password),
    );
    if (state.hasError) {
      developer.log('[LifeOS Auth] signInWithEmail failed', error: state.error);
    }
  }

  Future<void> signUpWithEmail(
      String email, String password, String name) async {
    developer.log('[LifeOS Auth] signUpWithEmail called for $email');
    state = const AsyncLoading();
    state = await AsyncValue.guard<AppUser?>(
      () => _repo.signUpWithEmail(email, password, name),
    );
    if (state.hasError) {
      developer.log('[LifeOS Auth] signUpWithEmail failed', error: state.error);
    }
  }

  Future<void> signOut() async {
    developer.log('[LifeOS Auth] signOut called');
    await _repo.signOut();
    state = const AsyncData(null);
  }

  Future<void> sendPasswordResetEmail(String email) async {
    developer.log('[LifeOS Auth] sendPasswordResetEmail called for $email');
    return _repo.sendPasswordResetEmail(email);
  }
}

final authNotifierProvider =
    AsyncNotifierProvider<AuthNotifier, AppUser?>(AuthNotifier.new);
