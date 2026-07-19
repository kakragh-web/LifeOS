import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lifeos_ai/core/constants/app_constants.dart';
import 'package:lifeos_ai/features/auth/providers/auth_provider.dart';

/// Entry point of the app. Shown while [authStateProvider] is resolving.
///
/// Navigation logic lives entirely in the GoRouter redirect — this screen
/// only renders the brand identity and a loading indicator.
class SplashScreen extends ConsumerStatefulWidget {
  const SplashScreen({super.key});

  @override
  ConsumerState<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends ConsumerState<SplashScreen>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<double> _fadeIn;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 900),
    )..forward();

    _fadeIn = CurvedAnimation(parent: _controller, curve: Curves.easeIn);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;

    ref.listen(authStateProvider, (_, next) {
      debugPrint(
          '[LifeOS Splash] Auth state changed: isLoading=${next.isLoading}, value=${next.valueOrNull}');
      if (!next.isLoading) {
        debugPrint(
            '[LifeOS Splash] Auth state resolved, router redirect should handle navigation');
      }
    });

    return Scaffold(
      backgroundColor: cs.surface,
      body: FadeTransition(
        opacity: _fadeIn,
        child: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Semantics(
                label: 'LifeOS logo',
                child: Image.asset(
                  'assets/images/lifeos_logo.PNG',
                  width: 96,
                  height: 96,
                  fit: BoxFit.contain,
                ),
              ),
              const SizedBox(height: 24),
              Semantics(
                label: 'LifeOS',
                child: const Text(
                  AppConstants.appName,
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    letterSpacing: -0.5,
                  ),
                ),
              ),
              const SizedBox(height: 8),
              Semantics(
                label: 'Your AI-powered life organizer',
                child: const Text(
                  'Your AI-powered life organizer',
                ),
              ),
              const SizedBox(height: 48),
              Semantics(
                label: 'Loading',
                child: const CircularProgressIndicator(strokeWidth: 2.5),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
