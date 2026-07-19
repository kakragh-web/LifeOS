import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:lifeos_ai/core/constants/app_constants.dart';
import 'package:lifeos_ai/features/auth/domain/app_user.dart';
import 'package:lifeos_ai/features/auth/providers/auth_provider.dart';
import 'package:lifeos_ai/features/auth/presentation/screens/login_screen.dart';
import 'package:lifeos_ai/features/auth/presentation/screens/register_screen.dart';
import 'package:lifeos_ai/features/calendar/presentation/screens/calendar_screen.dart';
import 'package:lifeos_ai/features/chat/presentation/screens/chat_screen.dart';
import 'package:lifeos_ai/features/dashboard/presentation/screens/dashboard_screen.dart';
import 'package:lifeos_ai/features/notes/presentation/screens/notes_screen.dart';
import 'package:lifeos_ai/features/planner/presentation/screens/planner_screen.dart';
import 'package:lifeos_ai/features/settings/presentation/screens/settings_screen.dart';
import 'package:lifeos_ai/features/splash/presentation/screens/splash_screen.dart';
import 'package:lifeos_ai/features/tasks/presentation/screens/tasks_screen.dart';
import 'package:lifeos_ai/features/welcome/presentation/screens/welcome_screen.dart';

/// Bridges Riverpod's [authStateProvider] stream to GoRouter's
/// [refreshListenable]. Every auth state change triggers a redirect re-eval.
class _AuthRouterNotifier extends ChangeNotifier {
  _AuthRouterNotifier(this._ref) {
    _sub = _ref.listen<AsyncValue<AppUser?>>(
      authStateProvider,
      (_, __) => notifyListeners(),
    );
  }

  final Ref _ref;
  late final ProviderSubscription<AsyncValue<AppUser?>> _sub;

  /// The current auth state — used by the redirect function.
  AsyncValue<AppUser?> get authState => _ref.read(authStateProvider);

  @override
  void dispose() {
    _sub.close();
    super.dispose();
  }
}

/// The single [GoRouter] instance. Created once, never recreated.
final routerProvider = Provider<GoRouter>((ref) {
  final notifier = _AuthRouterNotifier(ref);

  final router = GoRouter(
    initialLocation: AppRoutes.splash,
    refreshListenable: notifier,
    redirect: (context, state) => _redirect(notifier, state),
    routes: _buildRoutes(),
    errorBuilder: (context, state) => Scaffold(
      body: Center(child: Text('Route not found: ${state.uri}')),
    ),
  );

  ref.onDispose(() {
    notifier.dispose();
    router.dispose();
  });

  return router;
});

/// Redirect logic — pure function, easy to unit test.
///
/// Rules:
/// - Splash: always allowed (it's the loading gate).
/// - Auth loading: stay on splash.
/// - Not logged in: only welcome/login/register allowed.
/// - Logged in: redirect away from auth screens to dashboard.
String? _redirect(_AuthRouterNotifier notifier, GoRouterState state) {
  final authState = notifier.authState;
  final location = state.matchedLocation;

  // While Firebase resolves the auth state, stay on splash.
  if (authState.isLoading) {
    return location == AppRoutes.splash ? null : AppRoutes.splash;
  }

  final isLoggedIn = authState.valueOrNull != null;
  final isOnAuthFlow = location == AppRoutes.welcome ||
      location == AppRoutes.login ||
      location == AppRoutes.register;
  final isOnSplash = location == AppRoutes.splash;

  if (!isLoggedIn) {
    // Unauthenticated: allow auth flow screens, redirect everything else.
    if (isOnSplash || isOnAuthFlow) return null;
    return AppRoutes.welcome;
  }

  // Authenticated: redirect away from splash and auth screens.
  if (isOnSplash || isOnAuthFlow) return AppRoutes.dashboard;

  return null; // No redirect needed.
}

List<RouteBase> _buildRoutes() => [
      GoRoute(path: AppRoutes.splash, builder: (_, __) => const SplashScreen()),
      GoRoute(path: AppRoutes.welcome, builder: (_, __) => const WelcomeScreen()),
      GoRoute(path: AppRoutes.login, builder: (_, __) => const LoginScreen()),
      GoRoute(path: AppRoutes.register, builder: (_, __) => const RegisterScreen()),
      GoRoute(path: AppRoutes.dashboard, builder: (_, __) => const DashboardScreen()),
      GoRoute(path: AppRoutes.planner, builder: (_, __) => const PlannerScreen()),
      GoRoute(path: AppRoutes.calendar, builder: (_, __) => const CalendarScreen()),
      GoRoute(path: AppRoutes.tasks, builder: (_, __) => const TasksScreen()),
      GoRoute(path: AppRoutes.notes, builder: (_, __) => const NotesScreen()),
      GoRoute(path: AppRoutes.chat, builder: (_, __) => const ChatScreen()),
      GoRoute(path: AppRoutes.settings, builder: (_, __) => const SettingsScreen()),
    ];
