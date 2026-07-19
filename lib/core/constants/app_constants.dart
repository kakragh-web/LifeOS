/// App-wide constants. Use these instead of magic strings everywhere.
abstract final class AppConstants {
  static const appName = 'LifeOS';
  static const appVersion = '1.0.0';
  static const seedColorHex = 0xFF6750A4;
}

/// All named GoRouter paths in one place.
/// Always use these — never hardcode route strings in widgets.
abstract final class AppRoutes {
  static const splash = '/';
  static const welcome = '/welcome';
  static const login = '/login';
  static const register = '/register';
  static const dashboard = '/dashboard';
  static const planner = '/planner';
  static const calendar = '/calendar';
  static const tasks = '/tasks';
  static const notes = '/notes';
  static const chat = '/chat';
  static const settings = '/settings';
}

/// Storage keys for SharedPreferences.
abstract final class StorageKeys {
  static const themeMode = 'theme_mode';
  static const onboardingComplete = 'onboarding_complete';
}
