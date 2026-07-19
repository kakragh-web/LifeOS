import 'package:flutter_test/flutter_test.dart';
import 'package:lifeos_ai/core/utils/error_handler.dart';
import 'package:firebase_auth/firebase_auth.dart';

void main() {
  group('ErrorHandler', () {
    test('maps FirebaseAuthException invalid-email', () {
      final error = FirebaseAuthException(
        code: 'invalid-email',
        message: 'The email address is badly formatted.',
      );
      expect(ErrorHandler.friendly(error), 'The email address is not valid.');
    });

    test('maps FirebaseAuthException user-not-found', () {
      final error = FirebaseAuthException(
        code: 'user-not-found',
        message: 'There is no user record corresponding to this identifier.',
      );
      expect(ErrorHandler.friendly(error), 'No account found with this email.');
    });

    test('maps FirebaseAuthException wrong-password', () {
      final error = FirebaseAuthException(
        code: 'wrong-password',
        message: 'The password is invalid.',
      );
      expect(ErrorHandler.friendly(error), 'Incorrect email or password.');
    });

    test('maps FirebaseAuthException email-already-in-use', () {
      final error = FirebaseAuthException(
        code: 'email-already-in-use',
        message: 'The email address is already in use.',
      );
      expect(ErrorHandler.friendly(error),
          'An account with this email already exists.');
    });

    test('maps FirebaseAuthException weak-password', () {
      final error = FirebaseAuthException(
        code: 'weak-password',
        message: 'Password should be at least 6 characters.',
      );
      expect(ErrorHandler.friendly(error),
          'Password is too weak. Use at least 6 characters.');
    });

    test('maps FirebaseAuthException too-many-requests', () {
      final error = FirebaseAuthException(
        code: 'too-many-requests',
        message: 'Too many requests.',
      );
      expect(ErrorHandler.friendly(error),
          'Too many attempts. Please try again later.');
    });

    test('maps FirebaseAuthException network-request-failed', () {
      final error = FirebaseAuthException(
        code: 'network-request-failed',
        message: 'A network error occurred.',
      );
      expect(ErrorHandler.friendly(error),
          'No internet connection. Please check your network.');
    });

    test('maps FirebaseAuthException operation-not-allowed', () {
      final error = FirebaseAuthException(
        code: 'operation-not-allowed',
        message: 'Email/password accounts are not enabled.',
      );
      expect(ErrorHandler.friendly(error),
          'Email/password sign-in is not enabled in Firebase.');
    });

    test('maps FirebaseAuthException internal-error', () {
      final error = FirebaseAuthException(
        code: 'internal-error',
        message: 'An internal error occurred.',
      );
      expect(ErrorHandler.friendly(error), 'Internal error. Please try again.');
    });

    test('maps FirebaseAuthException invalid-credential', () {
      final error = FirebaseAuthException(
        code: 'invalid-credential',
        message: 'The supplied credential is invalid.',
      );
      expect(ErrorHandler.friendly(error), 'Incorrect email or password.');
    });

    test('maps generic string error containing Firebase not configured', () {
      expect(
        ErrorHandler.friendly(Exception('Firebase is not configured yet.')),
        'Authentication is unavailable. Please configure Firebase to sign in.',
      );
    });

    test('maps generic string error containing network exception', () {
      expect(
        ErrorHandler.friendly(
            Exception('SocketException: Network is unreachable')),
        'No internet connection. Please check your network.',
      );
    });

    test('returns fallback for unknown error', () {
      expect(
        ErrorHandler.friendly(Exception('Some unknown error')),
        'Something went wrong. Please try again.',
      );
    });

    test('handles null error gracefully', () {
      expect(ErrorHandler.friendly(null),
          'Something went wrong. Please try again.');
    });
  });
}
