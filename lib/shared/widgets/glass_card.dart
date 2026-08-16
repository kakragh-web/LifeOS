import 'package:flutter/material.dart';
import 'package:lifeos_ai/core/theme/app_colors.dart';
import 'package:lifeos_ai/core/theme/app_radius.dart';
import 'package:lifeos_ai/core/theme/app_spacing.dart';

class GlassCard extends StatelessWidget {
  const GlassCard({
    super.key,
    this.child,
    this.padding,
    this.margin,
    this.width,
    this.height,
    this.borderRadius,
    this.borderWidth = 1.0,
    this.borderColor,
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
  final double borderWidth;
  final Color? borderColor;
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

    Widget card = Card(
      margin: margin,
      elevation: elevation.toDouble(),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(effectiveBorderRadius),
        side: BorderSide(
          color: effectiveBorderColor,
          width: borderWidth,
        ),
      ),
      color: AppColors.surfaceContainerHighest,
      clipBehavior: clipBehavior,
      child: child,
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
