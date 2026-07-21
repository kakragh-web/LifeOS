import 'package:flutter/material.dart';

/// Staggered animation utilities for smooth, orchestrated UI reveals.
class StaggeredAnimations {
  StaggeredAnimations._();

  // ─── Staggered Fade In ─────────────────────────────────────────────
  static List<Animation<double>> staggeredFadeIn(
    AnimationController controller, {
    int itemCount = 3,
    Duration staggerDelay = const Duration(milliseconds: 80),
    Curve curve = Curves.easeOut,
  }) {
    final animations = <Animation<double>>[];
    for (int i = 0; i < itemCount; i++) {
      final start = i / itemCount;
      final end = (i + 1) / itemCount;
      final animation = Tween(begin: 0.0, end: 1.0).animate(
        CurvedAnimation(
          parent: controller,
          curve: Interval(start, end, curve: curve),
        ),
      );
      animations.add(animation);
    }
    return animations;
  }

  // ─── Staggered Slide Up ────────────────────────────────────────────
  static List<Animation<Offset>> staggeredSlideUp(
    AnimationController controller, {
    int itemCount = 3,
    Duration staggerDelay = const Duration(milliseconds: 80),
    Curve curve = Curves.easeOutCubic,
    double beginY = 0.3,
  }) {
    final animations = <Animation<Offset>>[];
    for (int i = 0; i < itemCount; i++) {
      final start = i / itemCount;
      final end = (i + 1) / itemCount;
      final animation =
          Tween(begin: Offset(0, beginY), end: Offset.zero).animate(
        CurvedAnimation(
          parent: controller,
          curve: Interval(start, end, curve: curve),
        ),
      );
      animations.add(animation);
    }
    return animations;
  }

  // ─── Staggered Scale ───────────────────────────────────────────────
  static List<Animation<double>> staggeredScale(
    AnimationController controller, {
    int itemCount = 3,
    Duration staggerDelay = const Duration(milliseconds: 80),
    Curve curve = Curves.easeOutBack,
    double beginScale = 0.8,
  }) {
    final animations = <Animation<double>>[];
    for (int i = 0; i < itemCount; i++) {
      final start = i / itemCount;
      final end = (i + 1) / itemCount;
      final animation = Tween(begin: beginScale, end: 1.0).animate(
        CurvedAnimation(
          parent: controller,
          curve: Interval(start, end, curve: curve),
        ),
      );
      animations.add(animation);
    }
    return animations;
  }

  // ─── Staggered Helper Widget ───────────────────────────────────────
  static Widget staggeredItem({
    required int index,
    required Animation<double> animation,
    required Widget child,
    Offset begin = const Offset(0.0, 0.2),
    Offset end = Offset.zero,
  }) {
    return FadeTransition(
      opacity: animation,
      child: SlideTransition(
        position: Tween(begin: begin, end: end).animate(animation),
        child: child,
      ),
    );
  }
}
