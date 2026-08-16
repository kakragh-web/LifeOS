import 'package:flutter/widgets.dart';

/// Central definition of responsive breakpoints and helpers so every screen
/// adapts consistently across phones, tablets and desktop widths.
///
/// Breakpoints follow the common Material 3 window-size classes:
/// * compact  ( < 600 )  — phones in portrait
/// * medium   ( 600–839 ) — small tablets / phones in landscape
/// * expanded ( >= 840 ) — tablets in landscape / desktop
abstract final class Breakpoints {
  static const double compact = 600;
  static const double medium = 840;
  static const double expanded = 1200;

  /// Maximum content width used to keep forms and reading content from
  /// stretching uncomfortably wide on large screens.
  static const double maxContentWidth = 480;
  static const double maxWideContentWidth = 1200;
}

enum ScreenSize { compact, medium, expanded }

extension ResponsiveContext on BuildContext {
  Size get screenSize => MediaQuery.sizeOf(this);
  double get screenWidth => MediaQuery.sizeOf(this).width;
  double get screenHeight => MediaQuery.sizeOf(this).height;

  ScreenSize get sizeClass {
    final w = screenWidth;
    if (w >= Breakpoints.medium) return ScreenSize.expanded;
    if (w >= Breakpoints.compact) return ScreenSize.medium;
    return ScreenSize.compact;
  }

  bool get isCompact => sizeClass == ScreenSize.compact;
  bool get isMedium => sizeClass == ScreenSize.medium;
  bool get isExpanded => sizeClass == ScreenSize.expanded;

  /// True for any width that is at least a small tablet.
  bool get isTabletOrWider => screenWidth >= Breakpoints.compact;

  /// Returns one of the provided values based on the current size class,
  /// falling back to smaller values when a larger one is not supplied.
  T responsive<T>({required T compact, T? medium, T? expanded}) {
    switch (sizeClass) {
      case ScreenSize.expanded:
        return expanded ?? medium ?? compact;
      case ScreenSize.medium:
        return medium ?? compact;
      case ScreenSize.compact:
        return compact;
    }
  }

  /// Horizontal page padding that grows with the available width.
  double get horizontalPagePadding =>
      responsive(compact: 16, medium: 24, expanded: 32);
}
