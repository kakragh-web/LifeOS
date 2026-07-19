import 'dart:developer' as developer;
import 'package:firebase_auth/firebase_auth.dart';

/// Maps raw exception messages (Firebase, network, etc.) to user-friendly strings.
abstract final class ErrorHandler {
  static String friendly(Object? error) {
    final String msg;
    final String? code;

    if (error is FirebaseAuthException) {
      code = error.code;
      msg = code;
      developer.log(
        '[LifeOS Auth] FirebaseAuthException: code=$code, message=${error.message}',
        error: error,
      );
    } else {
      code = null;
      msg = error?.toString() ?? '';
      developer.log('[LifeOS] Error: $msg', error: error);
    }

    switch (code) {
      case 'invalid-email':
        return 'The email address is not valid.';
      case 'user-disabled':
        return 'This account has been disabled.';
      case 'user-not-found':
        return 'No account found with this email.';
      case 'wrong-password':
      case 'invalid-credential':
        return 'Incorrect email or password.';
      case 'email-already-in-use':
        return 'An account with this email already exists.';
      case 'weak-password':
        return 'Password is too weak. Use at least 6 characters.';
      case 'too-many-requests':
        return 'Too many attempts. Please try again later.';
      case 'requires-recent-login':
        return 'Please sign in again to continue.';
      case 'account-exists-with-different-credential':
        return 'An account already exists with a different sign-in method.';
      case 'network-request-failed':
        return 'No internet connection. Please check your network.';
      case 'operation-not-allowed':
        return 'Email/password sign-in is not enabled in Firebase.';
      case 'internal-error':
        return 'Internal error. Please try again.';
      case 'expired-action-code':
        return 'This link has expired. Please request a new one.';
      case 'invalid-action-code':
        return 'This link is invalid. Please request a new one.';
      case 'invalid-verification-code':
        return 'The verification code is invalid.';
      case 'invalid-verification-id':
        return 'The verification ID is invalid.';
      case 'missing-android-pkg-name':
        return 'Android package name is missing.';
      case 'missing-ios-bundle-id':
        return 'iOS bundle ID is missing.';
      case 'null-user':
        return 'No user is currently signed in.';
      case 'user-token-expired':
        return 'Session expired. Please sign in again.';
      case 'user-mismatch':
        return 'The user credentials do not match.';
      case 'web-storage-unsupported':
        return 'Web storage is not supported in this browser.';
    }

    // Firebase not configured (preview mode)
    if (msg.contains('Firebase is not configured')) {
      return 'Authentication is unavailable. Please configure Firebase to sign in.';
    }

    // Network
    if (msg.contains('network-request-failed') ||
        msg.contains('SocketException')) {
      return 'No internet connection. Please check your network.';
    }

    return 'Something went wrong. Please try again.';
  }
}
