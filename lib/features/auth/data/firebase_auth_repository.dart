import 'dart:developer' as developer;
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:lifeos_ai/features/auth/domain/app_user.dart';
import 'package:lifeos_ai/features/auth/domain/i_auth_repository.dart';

class FirebaseAuthRepository implements IAuthRepository {
  FirebaseAuthRepository({FirebaseAuth? auth})
      : _auth = auth ?? FirebaseAuth.instance;

  final FirebaseAuth _auth;

  @override
  Stream<AppUser?> get authStateChanges =>
      _auth.authStateChanges().map(_mapUser);

  @override
  AppUser? get currentUser => _mapUser(_auth.currentUser);

  @override
  Future<AppUser> signInWithEmail(String email, String password) async {
    try {
      developer.log('[AUTH] operation=login email=$email');
      final cred = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      developer.log('[AUTH] login success uid=${cred.user?.uid}');
      return _requireUser(cred.user);
    } on FirebaseAuthException catch (e) {
      developer
          .log('[AUTH] operation=login code=${e.code} message=${e.message}');
      rethrow;
    } catch (e) {
      developer.log('[AUTH] operation=login error=$e');
      rethrow;
    }
  }

  @override
  Future<AppUser> signUpWithEmail(
    String email,
    String password,
    String displayName,
  ) async {
    try {
      developer.log(
          '[AUTH] operation=register email=$email displayName=$displayName');
      final cred = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      await cred.user?.updateDisplayName(displayName);
      await cred.user?.reload();
      developer.log('[AUTH] register success uid=${cred.user?.uid}');
      return _requireUser(_auth.currentUser);
    } on FirebaseAuthException catch (e) {
      developer
          .log('[AUTH] operation=register code=${e.code} message=${e.message}');
      rethrow;
    } catch (e) {
      developer.log('[AUTH] operation=register error=$e');
      rethrow;
    }
  }

  @override
  Future<AppUser> signInWithGoogle() async {
    try {
      developer.log('[AUTH] operation=googleSignIn');
      final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();
      if (googleUser == null) {
        developer.log('[AUTH] operation=googleSignIn result=cancelled');
        throw Exception('Google Sign-In was cancelled.');
      }
      final GoogleSignInAuthentication googleAuth =
          await googleUser.authentication;
      final credential = GoogleAuthProvider.credential(
        idToken: googleAuth.idToken,
        accessToken: googleAuth.accessToken,
      );
      final userCredential = await _auth.signInWithCredential(credential);
      developer
          .log('[AUTH] googleSignIn success uid=${userCredential.user?.uid}');
      return _requireUser(userCredential.user);
    } on FirebaseAuthException catch (e) {
      developer.log(
          '[AUTH] operation=googleSignIn code=${e.code} message=${e.message}');
      rethrow;
    } catch (e) {
      developer.log('[AUTH] operation=googleSignIn error=$e');
      rethrow;
    }
  }

  @override
  Future<void> signOut() async {
    try {
      await _auth.signOut();
    } catch (e) {
      developer.log('[AUTH] signOut error=$e');
      rethrow;
    }
  }

  @override
  Future<void> sendPasswordResetEmail(String email) =>
      _auth.sendPasswordResetEmail(email: email);

  AppUser? _mapUser(User? user) {
    if (user == null) return null;
    return AppUser(
      uid: user.uid,
      email: user.email ?? '',
      displayName: user.displayName,
      photoUrl: user.photoURL,
    );
  }

  AppUser _requireUser(User? user) {
    if (user == null) throw Exception('Authentication failed: user is null.');
    return _mapUser(user)!;
  }
}
