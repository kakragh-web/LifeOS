import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lifeos_ai/features/auth/data/auth_repository.dart';
import 'package:lifeos_ai/features/auth/data/firebase_auth_repository.dart';
import 'package:lifeos_ai/features/auth/domain/app_user.dart';
import 'package:lifeos_ai/features/auth/domain/i_auth_repository.dart';
import 'package:lifeos_ai/main.dart' show firebaseReadyProvider;

final authRepositoryProvider = Provider<IAuthRepository>((ref) {
  final firebaseReady = ref.watch(firebaseReadyProvider);
  return firebaseReady ? FirebaseAuthRepository() : AuthRepository();
});

final authStateProvider = StreamProvider<AppUser?>((ref) {
  final repo = ref.watch(authRepositoryProvider);
  return repo.authStateChanges
      .timeout(
        const Duration(seconds: 2),
        onTimeout: (sink) => sink.add(null),
      );
});

class AuthNotifier extends AsyncNotifier<AppUser?> {
  IAuthRepository get _repo => ref.read(authRepositoryProvider);

  @override
  Future<AppUser?> build() async => _repo.currentUser;

  Future<void> signInWithGoogle() async {
    state = const AsyncLoading();
    state = await AsyncValue.guard<AppUser?>(() => _repo.signInWithGoogle());
  }

  Future<void> signInWithEmail(String email, String password) async {
    state = const AsyncLoading();
    state = await AsyncValue.guard<AppUser?>(
      () => _repo.signInWithEmail(email, password),
    );
  }

  Future<void> signUpWithEmail(String email, String password, String name) async {
    state = const AsyncLoading();
    state = await AsyncValue.guard<AppUser?>(
      () => _repo.signUpWithEmail(email, password, name),
    );
  }

  Future<void> signOut() async {
    state = const AsyncLoading();
    await _repo.signOut();
    state = const AsyncData(null);
  }

  Future<void> sendPasswordResetEmail(String email) =>
      _repo.sendPasswordResetEmail(email);
}

final authNotifierProvider =
    AsyncNotifierProvider<AuthNotifier, AppUser?>(AuthNotifier.new);
