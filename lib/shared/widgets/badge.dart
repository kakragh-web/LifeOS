import 'package:flutter/material.dart';
import 'package:lifeos_ai/core/theme/app_colors.dart';
import 'package:lifeos_ai/core/theme/app_radius.dart';
import 'package:lifeos_ai/core/theme/app_spacing.dart';

/// Badge component for notifications, counts, and status indicators.
class AppBadge extends StatelessWidget {
  const AppBadge({
    super.key,
    this.count,
    this.text,
    this.color,
    this.textColor,
    this.isSmall = false,
    this.showZero = false,
    this.maxCount = 99,
    this.child,
  });

  final int? count;
  final String? text;
  final Color? color;
  final Color? textColor;
  final bool isSmall;
  final bool showZero;
  final int maxCount;
  final Widget? child;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    final effectiveColor = color ?? colorScheme.error;
    final effectiveTextColor = textColor ?? colorScheme.onError;

    final badgeContent = _buildBadgeContent();

    if (badgeContent == null && child == null) return const SizedBox.shrink();

    final badgeWidget = Container(
      constraints: BoxConstraints(
        minWidth: isSmall ? 16 : 20,
        minHeight: isSmall ? 16 : 20,
      ),
      padding: EdgeInsets.symmetric(
        horizontal: isSmall ? 4 : 6,
        vertical: isSmall ? 2 : 4,
      ),
      decoration: BoxDecoration(
        color: effectiveColor,
        borderRadius: AppRadius.badgeRadius,
      ),
      child: Center(
        child: Text(
          badgeContent ?? '',
          style: TextStyle(
            color: effectiveTextColor,
            fontSize: isSmall ? 10 : 12,
            fontWeight: FontWeight.w600,
            height: 1.2,
          ),
          textAlign: TextAlign.center,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
      ),
    );

    if (child == null) return badgeWidget;

    return Stack(
      clipBehavior: Clip.none,
      children: [
        child!,
        if (badgeContent != null)
          Positioned(
            top: -4,
            right: -4,
            child: badgeWidget,
          ),
      ],
    );
  }

  String? _buildBadgeContent() {
    if (count != null) {
      if (count == 0 && !showZero) return null;
      if (count! > maxCount) return '$maxCount+';
      return count.toString();
    }
    if (text != null) return text;
    return null;
  }

  /// Dot badge for unread indicators.
  factory AppBadge.dot({
    Color? color,
    double size = 8,
  }) {
    return AppBadge(
      color: color,
      child: SizedBox(width: size, height: size),
    );
  }
}
