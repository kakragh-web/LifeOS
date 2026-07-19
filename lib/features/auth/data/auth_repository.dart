import 'package:lifeos_ai/features/auth/domain/app_user.dart';
import 'package:lifeos_ai/features/auth/domain/i_auth_repository.dart';

/// Preview-mode stub. Replace with FirebaseAuthRepository in authRepositoryProvider
/// once `flutterfire configure` is complete and firebase_options.dart is populated.
class AuthRepository implements IAuthRepository {
  @override
  Stream<AppUser?> get authStateChanges => Stream.value(null);

  @override
  AppUser? get currentUser => null;

  @override
  Future<AppUser> signInWithGoogle() =>
      Future.error('Firebase not configured yet.');

  @override
  Future<AppUser> signInWithEmail(String email, String password) =>
      Future.error('Firebase not configured yet.');

  @override
  Future<AppUser> signUpWithEmail(
    String email,
    String password,
    String displayName,
  ) =>
      Future.error('Firebase not configured yet.');

  @override
  Future<void> signOut() async {}

  @override
  Future<void> sendPasswordResetEmail(String email) =>
      Future.error('Firebase not configured yet.');
}
