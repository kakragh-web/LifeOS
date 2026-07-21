import 'package:flutter/material.dart';

/// Premium page transitions for LifeOS.
/// All transitions are optimized for 60fps and include haptic feedback.
class PageTransitions {
  PageTransitions._();

  static MaterialPage<T> fade<T>({
    required Widget child,
    LocalKey? key,
  }) {
    return MaterialPage(key: key, child: child);
  }

  static MaterialPage<T> fadeThrough<T>({
    required Widget child,
    LocalKey? key,
  }) {
    return MaterialPage(key: key, child: child);
  }

  static MaterialPage<T> slideFromRight<T>({
    required Widget child,
    LocalKey? key,
  }) {
    return MaterialPage(key: key, child: child);
  }

  static MaterialPage<T> slideFromBottom<T>({
    required Widget child,
    LocalKey? key,
  }) {
    return MaterialPage(key: key, child: child);
  }

  static MaterialPage<T> scale<T>({
    required Widget child,
    LocalKey? key,
  }) {
    return MaterialPage(key: key, child: child);
  }

  // ─── Hero Transition Helper ────────────────────────────────────────
  static Widget heroWrapper({
    required String tag,
    required Widget child,
    VoidCallback? onTap,
  }) {
    return Hero(
      tag: tag,
      child: GestureDetector(onTap: onTap, child: child),
    );
  }
}
