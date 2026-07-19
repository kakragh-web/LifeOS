import 'package:lifeos_ai/features/auth/domain/app_user.dart';

/// Contract for all auth implementations (stub, Firebase, mock for tests).
abstract class IAuthRepository {
  Stream<AppUser?> get authStateChanges;
  AppUser? get currentUser;
  Future<AppUser> signInWithEmail(String email, String password);
  Future<AppUser> signUpWithEmail(String email, String password, String displayName);
  Future<AppUser> signInWithGoogle();
  Future<void> signOut();
  Future<void> sendPasswordResetEmail(String email);
}
