import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:lifeos_ai/core/theme/app_radius.dart';
import 'package:lifeos_ai/core/theme/app_shadows.dart';
import 'package:lifeos_ai/core/theme/app_spacing.dart';

/// Animated floating action button with scale and rotation effects.
class AnimatedFAB extends StatefulWidget {
  const AnimatedFAB({
    super.key,
    required this.onPressed,
    this.icon,
    this.label,
    this.isExtended = false,
    this.mini = false,
    this.backgroundColor,
    this.foregroundColor,
    this.heroTag,
    this.tooltip,
    this.semanticLabel,
  });

  final VoidCallback? onPressed;
  final IconData? icon;
  final String? label;
  final bool isExtended;
  final bool mini;
  final Color? backgroundColor;
  final Color? foregroundColor;
  final Object? heroTag;
  final String? tooltip;
  final String? semanticLabel;

  @override
  State<AnimatedFAB> createState() => _AnimatedFABState();
}

class _AnimatedFABState extends State<AnimatedFAB>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;
  late Animation<double> _rotationAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 150),
      vsync: this,
    );
    _scaleAnimation = Tween<double>(begin: 1.0, end: 0.92).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );
    _rotationAnimation = Tween<double>(begin: 0.0, end: 0.1).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _handleTapDown(TapDownDetails details) {
    if (widget.onPressed != null) {
      HapticFeedback.mediumImpact();
      _controller.forward();
    }
  }

  void _handleTapUp(TapUpDetails details) {
    _controller.reverse();
  }

  void _handleTapCancel() {
    _controller.reverse();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    final effectiveSize = switch (widget.mini) {
      true => 40.0,
      false when widget.isExtended => 56.0,
      _ => 56.0,
    };

    final effectiveIconSize = switch (widget.mini) {
      true => 20.0,
      _ => 24.0,
    };

    final effectiveBackgroundColor = widget.backgroundColor ??
        (widget.isExtended
            ? colorScheme.primary
            : colorScheme.primaryContainer);

    final effectiveForegroundColor = widget.foregroundColor ??
        (widget.isExtended
            ? colorScheme.onPrimary
            : colorScheme.onPrimaryContainer);

    return GestureDetector(
      onTapDown: _handleTapDown,
      onTapUp: _handleTapUp,
      onTapCancel: _handleTapCancel,
      child: AnimatedBuilder(
        animation: _scaleAnimation,
        builder: (context, child) {
          return Transform.scale(
            scale: _scaleAnimation.value,
            child: Transform.rotate(
              angle: _rotationAnimation.value,
              child: child,
            ),
          );
        },
        child: widget.isExtended
            ? _buildExtendedFAB(context, effectiveSize, effectiveIconSize,
                effectiveBackgroundColor, effectiveForegroundColor)
            : _buildCircularFAB(context, effectiveSize, effectiveIconSize,
                effectiveBackgroundColor, effectiveForegroundColor),
      ),
    );
  }

  Widget _buildCircularFAB(
    BuildContext context,
    double size,
    double iconSize,
    Color backgroundColor,
    Color foregroundColor,
  ) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: backgroundColor,
        boxShadow: AppShadows.elevation3,
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: widget.onPressed,
          customBorder: const CircleBorder(),
          child: Icon(
            widget.icon ?? Icons.add_rounded,
            size: iconSize,
            color: foregroundColor,
          ),
        ),
      ),
    );
  }

  Widget _buildExtendedFAB(
    BuildContext context,
    double size,
    double iconSize,
    Color backgroundColor,
    Color foregroundColor,
  ) {
    return Container(
      height: size,
      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg),
      decoration: BoxDecoration(
        borderRadius: AppRadius.fabRadius,
        color: backgroundColor,
        boxShadow: AppShadows.elevation3,
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: widget.onPressed,
          borderRadius: AppRadius.fabRadius,
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              if (widget.icon != null) ...[
                Icon(widget.icon, size: iconSize, color: foregroundColor),
                const SizedBox(width: AppSpacing.sm),
              ],
              if (widget.label != null)
                Text(
                  widget.label!,
                  style: TextStyle(
                    color: foregroundColor,
                    fontWeight: FontWeight.w500,
                    fontSize: 16,
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
