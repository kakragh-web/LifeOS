/// Maps raw exception messages (Firebase, network, etc.) to user-friendly strings.
abstract final class ErrorHandler {
  static String friendly(Object? error) {
    final msg = error?.toString() ?? '';

    // Firebase Auth errors
    if (msg.contains('user-not-found')) return 'No account found with this email.';
    if (msg.contains('wrong-password') || msg.contains('invalid-credential')) {
      return 'Incorrect email or password.';
    }
    if (msg.contains('email-already-in-use')) return 'An account with this email already exists.';
    if (msg.contains('invalid-email')) return 'The email address is not valid.';
    if (msg.contains('weak-password')) return 'Password is too weak.';
    if (msg.contains('too-many-requests')) return 'Too many attempts. Try again later.';
    if (msg.contains('user-disabled')) return 'This account has been disabled.';
    if (msg.contains('requires-recent-login')) return 'Please sign in again to continue.';
    if (msg.contains('account-exists-with-different-credential')) {
      return 'An account already exists with a different sign-in method.';
    }

    // Network
    if (msg.contains('network-request-failed') || msg.contains('SocketException')) {
      return 'No internet connection. Please check your network.';
    }

    // Firebase not configured (preview mode)
    if (msg.contains('Firebase not configured')) return 'Service unavailable. Please try again later.';

    return 'Something went wrong. Please try again.';
  }
}
