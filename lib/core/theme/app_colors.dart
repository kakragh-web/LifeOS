import 'package:flutter/material.dart';

/// Premium color system for LifeOS.
/// Supports dynamic color on Android 12+ and Material 3 dynamic themes.
class AppColors {
  AppColors._();

  // ─── Brand / Primary ───────────────────────────────────────────────
  static const Color primary = Color(0xFF6750A4);
  static const Color onPrimary = Color(0xFFFFFFFF);
  static const Color primaryContainer = Color(0xFFEADDFF);
  static const Color onPrimaryContainer = Color(0xFF21005D);

  // ─── Secondary ────────────────────────────────────────────────────
  static const Color secondary = Color(0xFF625B71);
  static const Color onSecondary = Color(0xFFFFFFFF);
  static const Color secondaryContainer = Color(0xFFE8DEF8);
  static const Color onSecondaryContainer = Color(0xFF1D192B);

  // ─── Tertiary ─────────────────────────────────────────────────────
  static const Color tertiary = Color(0xFF7D5260);
  static const Color onTertiary = Color(0xFFFFFFFF);
  static const Color tertiaryContainer = Color(0xFFFFD8E4);
  static const Color onTertiaryContainer = Color(0xFF31111D);

  // ─── Error ─────────────────────────────────────────────────────────
  static const Color error = Color(0xFFB3261E);
  static const Color onError = Color(0xFFFFFFFF);
  static const Color errorContainer = Color(0xFFF9DEDC);
  static const Color onErrorContainer = Color(0xFF410E0B);

  // ─── Surface / Background ──────────────────────────────────────────
  static const Color surface = Color(0xFFFEF7FF);
  static const Color onSurface = Color(0xFF1D1B20);
  static const Color surfaceVariant = Color(0xFFE7E0EC);
  static const Color onSurfaceVariant = Color(0xFF49454F);
  static const Color surfaceContainerHighest = Color(0xFFE6E0E9);
  static const Color surfaceContainerHigh = Color(0xFFECE6F0);
  static const Color surfaceContainer = Color(0xFFF3EDF7);
  static const Color surfaceContainerLow = Color(0xFFF7F2FA);
  static const Color surfaceContainerLowest = Color(0xFFFFFFFF);

  static const Color background = Color(0xFFFEF7FF);
  static const Color onBackground = Color(0xFF1D1B20);

  // ─── Outline ───────────────────────────────────────────────────────
  static const Color outline = Color(0xFF79747E);
  static const Color outlineVariant = Color(0xFFCAC4D0);

  // ─── Inverse ───────────────────────────────────────────────────────
  static const Color inverseSurface = Color(0xFF313033);
  static const Color onInverseSurface = Color(0xFFF4EFF4);
  static const Color inversePrimary = Color(0xFFD0BCFF);
  static const Color onInversePrimary = Color(0xFF381E72);

  // ─── Glass / Overlay ───────────────────────────────────────────────
  static const Color glass = Color(0x99FFFFFF);
  static const Color glassDark = Color(0x99FFFFFF);
  static const Color glassBorder = Color(0x33FFFFFF);
  static const Color scrim = Color(0x66000000);

  // ─── Semantic ──────────────────────────────────────────────────────
  static const Color success = Color(0xFF4CAF50);
  static const Color onSuccess = Color(0xFFFFFFFF);
  static const Color successContainer = Color(0xFFE8F5E9);
  static const Color onSuccessContainer = Color(0xFF1B5E20);

  static const Color warning = Color(0xFFFF9800);
  static const Color onWarning = Color(0xFFFFFFFF);
  static const Color warningContainer = Color(0xFFFFF3E0);
  static const Color onWarningContainer = Color(0xFFE65100);

  static const Color info = Color(0xFF2196F3);
  static const Color onInfo = Color(0xFFFFFFFF);
  static const Color infoContainer = Color(0xFFE3F2FD);
  static const Color onInfoContainer = Color(0xFF0D47A1);

  // ─── Gradients ─────────────────────────────────────────────────────
  static const LinearGradient primaryGradient = LinearGradient(
    colors: [Color(0xFF6750A4), Color(0xFF9A82DB)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const LinearGradient surfaceGradient = LinearGradient(
    colors: [Color(0xFFFEF7FF), Color(0xFFF3EDF7)],
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
  );

  static const LinearGradient glassGradient = LinearGradient(
    colors: [Color(0x33FFFFFF), Color(0x1AFFFFFF)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  // ─── Helpers ───────────────────────────────────────────────────────
  static ColorScheme get colorScheme => ColorScheme.fromSeed(
        seedColor: primary,
        brightness: Brightness.light,
      );

  static ColorScheme get darkColorScheme => ColorScheme.fromSeed(
        seedColor: primary,
        brightness: Brightness.dark,
      );
}
