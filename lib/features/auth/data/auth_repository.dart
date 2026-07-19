import 'dart:developer' as developer;
import 'package:lifeos_ai/features/auth/domain/app_user.dart';
import 'package:lifeos_ai/features/auth/domain/i_auth_repository.dart';

/// Preview-mode stub. Replace with FirebaseAuthRepository in authRepositoryProvider
/// once `flutterfire configure` is complete and firebase_options.dart is populated.
class AuthRepository implements IAuthRepository {
  @override
  Stream<AppUser?> get authStateChanges {
    developer.log('[LifeOS Auth] Stub authStateChanges emitting null');
    return Stream.value(null);
  }

  @override
  AppUser? get currentUser {
    developer.log('[LifeOS Auth] Stub currentUser returning null');
    return null;
  }

  @override
  Future<AppUser> signInWithGoogle() async {
    developer.log('[LifeOS Auth] Stub signInWithGoogle called');
    return Future.error('Firebase is not configured. Google Sign-In is unavailable.');
  }

  @override
  Future<AppUser> signInWithEmail(String email, String password) async {
    developer.log('[LifeOS Auth] Stub signInWithEmail called for $email');
    return Future.error('Firebase is not configured. Email sign-in is unavailable.');
  }

  @override
  Future<AppUser> signUpWithEmail(
    String email,
    String password,
    String displayName,
  ) async {
    developer.log('[LifeOS Auth] Stub signUpWithEmail called for $email');
    return Future.error('Firebase is not configured. Email sign-up is unavailable.');
  }

  @override
  Future<void> signOut() async {
    developer.log('[LifeOS Auth] Stub signOut called');
  }

  @override
  Future<void> sendPasswordResetEmail(String email) async {
    developer.log('[LifeOS Auth] Stub sendPasswordResetEmail called for $email');
    return Future.error('Firebase is not configured. Password reset is unavailable.');
  }
}
