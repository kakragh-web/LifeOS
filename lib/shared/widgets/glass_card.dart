import 'dart:ui';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:lifeos_ai/core/theme/app_colors.dart';
import 'package:lifeos_ai/core/theme/app_radius.dart';
import 'package:lifeos_ai/core/theme/app_shadows.dart';
import 'package:lifeos_ai/core/theme/app_spacing.dart';

/// Premium frosted glass card with blur effect and layered shadows.
/// On web, BackdropFilter is disabled for better performance and compatibility.
class GlassCard extends StatelessWidget {
  const GlassCard({
    super.key,
    this.child,
    this.padding,
    this.margin,
    this.width,
    this.height,
    this.borderRadius,
    this.blur = 20.0,
    this.opacity = 0.85,
    this.borderWidth = 1.0,
    this.borderColor,
    this.gradient,
    this.shadows,
    this.elevation = 2,
    this.clipBehavior = Clip.none,
    this.onTap,
    this.onLongPress,
    this.semanticLabel,
  });

  final Widget? child;
  final EdgeInsetsGeometry? padding;
  final EdgeInsetsGeometry? margin;
  final double? width;
  final double? height;
  final double? borderRadius;
  final double blur;
  final double opacity;
  final double borderWidth;
  final Color? borderColor;
  final Gradient? gradient;
  final List<BoxShadow>? shadows;
  final int elevation;
  final Clip clipBehavior;
  final VoidCallback? onTap;
  final VoidCallback? onLongPress;
  final String? semanticLabel;

  @override
  Widget build(BuildContext context) {
    final effectiveBorderRadius = borderRadius ?? AppRadius.card;
    final effectiveBorderColor = borderColor ??
        Theme.of(context).colorScheme.outlineVariant.withOpacity(0.3);
    final effectiveShadows = shadows ??
        switch (elevation) {
          0 => AppShadows.elevation0,
          1 => AppShadows.elevation1,
          2 => AppShadows.elevation2,
          3 => AppShadows.elevation3,
          4 => AppShadows.elevation4,
          5 || 6 => AppShadows.elevation6,
          _ => AppShadows.elevation8,
        };

    const bool isWeb = kIsWeb;

    Widget cardContent = Container(
      padding: padding ?? const EdgeInsets.all(AppSpacing.cardPadding),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(effectiveBorderRadius),
        color: isWeb
            ? Theme.of(context).colorScheme.surfaceContainerHighest
            : AppColors.glass.withOpacity(opacity),
        gradient: isWeb ? null : (gradient ?? AppColors.glassGradient),
        border: Border.all(
          color: effectiveBorderColor,
          width: borderWidth,
        ),
      ),
      child: child,
    );

    if (!isWeb) {
      cardContent = BackdropFilter(
        filter: ImageFilter.blur(sigmaX: blur, sigmaY: blur),
        child: Container(
          padding: padding ?? const EdgeInsets.all(AppSpacing.cardPadding),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(effectiveBorderRadius),
            color: AppColors.glass.withOpacity(opacity),
            gradient: gradient ?? AppColors.glassGradient,
          ),
          child: child,
        ),
      );
    }

    Widget card = AnimatedContainer(
      duration: const Duration(milliseconds: 200),
      curve: Curves.easeInOut,
      width: width,
      height: height,
      margin: margin,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(effectiveBorderRadius),
        border: Border.all(
          color: effectiveBorderColor,
          width: borderWidth,
        ),
        boxShadow: effectiveShadows,
      ),
      clipBehavior: clipBehavior,
      child: cardContent,
    );

    if (onTap != null || onLongPress != null) {
      card = GestureDetector(
        onTap: onTap,
        onLongPress: onLongPress,
        child: card,
      );
    }

    if (semanticLabel != null) {
      card = Semantics(
        label: semanticLabel,
        button: onTap != null,
        child: card,
      );
    }

    return card;
  }

  /// Creates a glass card with image header.
  factory GlassCard.imageHeader({
    Key? key,
    required Widget image,
    required Widget title,
    Widget? subtitle,
    Widget? trailing,
    VoidCallback? onTap,
  }) {
    return GlassCard(
      key: key,
      onTap: onTap,
      padding: EdgeInsets.zero,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ClipRRect(
            borderRadius: const BorderRadius.vertical(
              top: Radius.circular(AppRadius.card),
            ),
            child: image,
          ),
          Padding(
            padding: const EdgeInsets.all(AppSpacing.cardPadding),
            child: Row(
              children: [
                Expanded(child: title),
                if (subtitle != null) ...[
                  const SizedBox(width: AppSpacing.sm),
                  subtitle,
                ],
                if (trailing != null) ...[
                  const SizedBox(width: AppSpacing.sm),
                  trailing,
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }

  /// Creates a tappable glass card with icon and label.
  factory GlassCard.feature({
    Key? key,
    required IconData icon,
    required String label,
    required VoidCallback onTap,
    Color? iconColor,
  }) {
    return GlassCard(
      key: key,
      onTap: onTap,
      elevation: 1,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, size: AppSpacing.iconXl, color: iconColor),
          const SizedBox(height: AppSpacing.sm),
          Text(
            label,
            style: const TextStyle(fontWeight: FontWeight.w500),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}
