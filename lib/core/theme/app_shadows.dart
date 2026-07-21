import 'package:flutter/material.dart';

/// Premium shadow system for LifeOS.
/// Uses layered shadows for depth and glassmorphism effects.
class AppShadows {
  AppShadows._();

  // ─── Elevation Shadows ─────────────────────────────────────────────
  static List<BoxShadow> get elevation0 => [];
  static List<BoxShadow> get elevation1 => [
        BoxShadow(
          color: const Color(0xFF000000).withOpacity(0.04),
          offset: const Offset(0, 1),
          blurRadius: 2,
          spreadRadius: 0,
        ),
      ];
  static List<BoxShadow> get elevation2 => [
        BoxShadow(
          color: const Color(0xFF000000).withOpacity(0.06),
          offset: const Offset(0, 1),
          blurRadius: 3,
          spreadRadius: 0,
        ),
        BoxShadow(
          color: const Color(0xFF000000).withOpacity(0.04),
          offset: const Offset(0, 2),
          blurRadius: 4,
          spreadRadius: 0,
        ),
      ];
  static List<BoxShadow> get elevation3 => [
        BoxShadow(
          color: const Color(0xFF000000).withOpacity(0.08),
          offset: const Offset(0, 1),
          blurRadius: 3,
          spreadRadius: 0,
        ),
        BoxShadow(
          color: const Color(0xFF000000).withOpacity(0.05),
          offset: const Offset(0, 4),
          blurRadius: 6,
          spreadRadius: 0,
        ),
      ];
  static List<BoxShadow> get elevation4 => [
        BoxShadow(
          color: const Color(0xFF000000).withOpacity(0.08),
          offset: const Offset(0, 2),
          blurRadius: 4,
          spreadRadius: 0,
        ),
        BoxShadow(
          color: const Color(0xFF000000).withOpacity(0.05),
          offset: const Offset(0, 8),
          blurRadius: 12,
          spreadRadius: -2,
        ),
      ];
  static List<BoxShadow> get elevation6 => [
        BoxShadow(
          color: const Color(0xFF000000).withOpacity(0.1),
          offset: const Offset(0, 4),
          blurRadius: 6,
          spreadRadius: 0,
        ),
        BoxShadow(
          color: const Color(0xFF000000).withOpacity(0.06),
          offset: const Offset(0, 12),
          blurRadius: 20,
          spreadRadius: -4,
        ),
      ];
  static List<BoxShadow> get elevation8 => [
        BoxShadow(
          color: const Color(0xFF000000).withOpacity(0.12),
          offset: const Offset(0, 8),
          blurRadius: 10,
          spreadRadius: 0,
        ),
        BoxShadow(
          color: const Color(0xFF000000).withOpacity(0.08),
          offset: const Offset(0, 16),
          blurRadius: 28,
          spreadRadius: -8,
        ),
      ];

  // ─── Glass Shadows ─────────────────────────────────────────────────
  static List<BoxShadow> get glass => [
        BoxShadow(
          color: const Color(0xFFFFFFFF).withOpacity(0.15),
          offset: const Offset(0, 1),
          blurRadius: 2,
          spreadRadius: 0,
        ),
        BoxShadow(
          color: const Color(0xFF000000).withOpacity(0.05),
          offset: const Offset(0, 4),
          blurRadius: 8,
          spreadRadius: 0,
        ),
      ];

  // ─── Glow Shadows ──────────────────────────────────────────────────
  static List<BoxShadow> primaryGlow([Color? color]) => [
        BoxShadow(
          color: (color ?? const Color(0xFF6750A4)).withOpacity(0.3),
          offset: const Offset(0, 0),
          blurRadius: 12,
          spreadRadius: -4,
        ),
      ];

  // ─── Shadow Helpers ────────────────────────────────────────────────
  static List<BoxShadow> colored(Color color,
          {double blur = 12, double spread = -4}) =>
      [
        BoxShadow(
          color: color.withOpacity(0.3),
          offset: const Offset(0, 0),
          blurRadius: blur,
          spreadRadius: spread,
        ),
      ];

  static List<BoxShadow> layered(List<List<BoxShadow>> layers) =>
      layers.expand((layer) => layer).toList();
}
