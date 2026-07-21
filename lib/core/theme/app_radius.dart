import 'package:flutter/material.dart';

/// Border radius tokens for consistent corner rounding.
class AppRadius {
  AppRadius._();

  // ─── Base Units ────────────────────────────────────────────────────
  static const double xs = 4.0;
  static const double sm = 8.0;
  static const double md = 12.0;
  static const double lg = 16.0;
  static const double xl = 24.0;
  static const double xxl = 32.0;
  static const double full = 999.0; // Pill shape

  // ─── Component Radii ───────────────────────────────────────────────
  static const double card = lg;
  static const double button = md;
  static const double dialog = xl;
  static const double bottomSheet = xl;
  static const double fab = full;
  static const double chip = full;
  static const double textField = md;
  static const double avatar = full;
  static const double badge = full;

  // ─── BorderRadius Helpers ──────────────────────────────────────────
  static BorderRadius get cardRadius => BorderRadius.circular(card);
  static BorderRadius get buttonRadius => BorderRadius.circular(button);
  static BorderRadius get dialogRadius => BorderRadius.circular(dialog);
  static BorderRadius get bottomSheetRadius =>
      const BorderRadius.vertical(top: Radius.circular(xl));
  static BorderRadius get fabRadius => BorderRadius.circular(fab);
  static BorderRadius get chipRadius => BorderRadius.circular(chip);
  static BorderRadius get textFieldRadius => BorderRadius.circular(textField);
  static BorderRadius get avatarRadius => BorderRadius.circular(avatar);
  static BorderRadius get badgeRadius => BorderRadius.circular(badge);

  // ─── RRect Helpers ─────────────────────────────────────────────────
  static RRect rRect(Size size, double radius) =>
      RRect.fromRectAndRadius(Offset.zero & size, Radius.circular(radius));

  static RRect cardRRect(Size size) => rRect(size, card);
  static RRect buttonRRect(Size size) => rRect(size, button);
  static RRect dialogRRect(Size size) => rRect(size, dialog);
}
