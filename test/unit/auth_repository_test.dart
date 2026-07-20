import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:lifeos_ai/features/auth/data/auth_repository.dart';
import 'package:lifeos_ai/features/auth/data/firebase_auth_repository.dart';
import 'package:lifeos_ai/features/auth/domain/app_user.dart';
import 'package:lifeos_ai/features/auth/domain/i_auth_repository.dart';
import 'package:mocktail/mocktail.dart';

class MockFirebaseAuth extends Mock implements FirebaseAuth {}

class MockUser extends Mock implements User {}

class MockUserCredential extends Mock implements UserCredential {}

class MockGoogleSignIn extends Mock implements GoogleSignIn {}

/// A fake [IAuthRepository] that records calls and returns canned results.
/// Used to exercise the provider layer without Firebase.
class FakeAuthRepository implements IAuthRepository {
  AppUser? currentUserValue;
  bool signOutCalled = false;
  bool resetCalled = false;
  String? lastSignInEmail;
  String? lastSignInPassword;
  String? lastSignUpEmail;
  String? lastSignUpPassword;
  String? lastSignUpName;

  @override
  Stream<AppUser?> get authStateChanges => Stream.value(currentUserValue);

  @override
  AppUser? get currentUser => currentUserValue;

  @override
  Future<AppUser> signInWithEmail(String email, String password) async {
    lastSignInEmail = email;
    lastSignInPassword = password;
    return AppUser(uid: 'u1', email: email);
  }

  @override
  Future<AppUser> signUpWithEmail(
    String email,
    String password,
    String displayName,
  ) async {
    lastSignUpEmail = email;
    lastSignUpPassword = password;
    lastSignUpName = displayName;
    return AppUser(uid: 'u1', email: email, displayName: displayName);
  }

  @override
  Future<AppUser> signInWithGoogle() async =>
      AppUser(uid: 'g1', email: 'g@example.com');

  @override
  Future<void> signOut() async => signOutCalled = true;

  @override
  Future<void> sendPasswordResetEmail(String email) async => resetCalled = true;
}

void main() {
  group('AuthRepository (stub)', () {
    late AuthRepository repo;

    setUp(() => repo = AuthRepository());

    test('currentUser returns null', () {
      expect(repo.currentUser, isNull);
    });

    test('authStateChanges emits null', () async {
      final values = await repo.authStateChanges.toList();
      expect(values, [null]);
    });

    test('signInWithEmail throws not configured', () {
      expect(
        () => repo.signInWithEmail('a@b.com', 'pw'),
        throwsA(isA<String>()),
      );
    });

    test('signUpWithEmail throws not configured', () {
      expect(
        () => repo.signUpWithEmail('a@b.com', 'pw', 'Name'),
        throwsA(isA<String>()),
      );
    });

    test('signInWithGoogle throws not configured', () {
      expect(
        () => repo.signInWithGoogle(),
        throwsA(isA<String>()),
      );
    });

    test('sendPasswordResetEmail throws not configured', () {
      expect(
        () => repo.sendPasswordResetEmail('a@b.com'),
        throwsA(isA<String>()),
      );
    });

    test('signOut completes without error', () async {
      await expectLater(repo.signOut(), completes);
    });
  });

  group('FirebaseAuthRepository (mocked FirebaseAuth)', () {
    late MockFirebaseAuth mockAuth;
    late MockGoogleSignIn mockGoogle;
    late FirebaseAuthRepository repo;

    setUp(() {
      mockAuth = MockFirebaseAuth();
      mockGoogle = MockGoogleSignIn();
      repo = FirebaseAuthRepository(auth: mockAuth, googleSignIn: mockGoogle);
    });

    MockUser buildUser({String uid = 'u1', String email = 'a@b.com'}) {
      final user = MockUser();
      when(() => user.uid).thenReturn(uid);
      when(() => user.email).thenReturn(email);
      when(() => user.displayName).thenReturn('Ada');
      when(() => user.photoURL).thenReturn(null);
      when(() => user.updateDisplayName(any())).thenAnswer((_) async {});
      when(() => user.reload()).thenAnswer((_) async {});
      return user;
    }

    MockUserCredential buildCredential(MockUser user) {
      final cred = MockUserCredential();
      when(() => cred.user).thenReturn(user);
      return cred;
    }

    test('signInWithEmail delegates to Firebase and maps the user', () async {
      final user = buildUser();
      when(() => mockAuth.signInWithEmailAndPassword(
            email: any(named: 'email'),
            password: any(named: 'password'),
          )).thenAnswer((_) async => buildCredential(user));

      final result = await repo.signInWithEmail('a@b.com', 'secret');
      expect(result.email, 'a@b.com');
      expect(result.displayName, 'Ada');
      verify(() => mockAuth.signInWithEmailAndPassword(
            email: 'a@b.com',
            password: 'secret',
          )).called(1);
    });

    test('signUpWithEmail creates user and updates display name', () async {
      final user = buildUser();
      when(() => mockAuth.createUserWithEmailAndPassword(
            email: any(named: 'email'),
            password: any(named: 'password'),
          )).thenAnswer((_) async => buildCredential(user));
      when(() => mockAuth.currentUser).thenReturn(user);

      final result =
          await repo.signUpWithEmail('a@b.com', 'secret', 'Ada');
      expect(result.email, 'a@b.com');
      expect(result.displayName, 'Ada');
      verify(() => user.updateDisplayName('Ada')).called(1);
      verify(() => user.reload()).called(1);
    });

    test('signOut calls auth.signOut and googleSignIn.signOut', () async {
      when(() => mockAuth.signOut()).thenAnswer((_) async {});
      when(() => mockGoogle.signOut()).thenAnswer((_) async => null);

      await repo.signOut();
      verify(() => mockAuth.signOut()).called(1);
      verify(() => mockGoogle.signOut()).called(1);
    });

    test('sendPasswordResetEmail forwards the email', () async {
      when(() => mockAuth.sendPasswordResetEmail(
            email: any(named: 'email'),
          )).thenAnswer((_) async {});

      await repo.sendPasswordResetEmail('a@b.com');
      verify(() => mockAuth.sendPasswordResetEmail(email: 'a@b.com'))
          .called(1);
    });

    test('currentUser maps the signed-in user', () {
      final user = buildUser(uid: 'x1', email: 'x@y.com');
      when(() => mockAuth.currentUser).thenReturn(user);

      final result = repo.currentUser;
      expect(result?.uid, 'x1');
      expect(result?.email, 'x@y.com');
    });

    test('currentUser returns null when no user is signed in', () {
      when(() => mockAuth.currentUser).thenReturn(null);
      expect(repo.currentUser, isNull);
    });

    test('authStateChanges maps the emitted user', () async {
      final user = buildUser();
      when(() => mockAuth.authStateChanges()).thenAnswer(
        (_) => Stream.value(user),
      );

      final values = await repo.authStateChanges.toList();
      expect(values.single?.uid, 'u1');
    });
  });

  group('FirebaseAuthRepository error mapping', () {
    test('signInWithEmail throws when the user is null', () async {
      final mockAuth = MockFirebaseAuth();
      final cred = MockUserCredential();
      when(() => cred.user).thenReturn(null);
      when(() => mockAuth.signInWithEmailAndPassword(
            email: any(named: 'email'),
            password: any(named: 'password'),
          )).thenAnswer((_) async => cred);

      final repo = FirebaseAuthRepository(auth: mockAuth);
      expect(
        () => repo.signInWithEmail('a@b.com', 'pw'),
        throwsA(isA<Exception>()),
      );
    });
  });
}
