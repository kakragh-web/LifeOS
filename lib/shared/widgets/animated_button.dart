import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:lifeos_ai/core/theme/app_colors.dart';
import 'package:lifeos_ai/core/theme/app_radius.dart';
import 'package:lifeos_ai/core/theme/app_shadows.dart';
import 'package:lifeos_ai/core/theme/app_spacing.dart';

/// Animated button with haptic feedback and smooth transitions.
class AnimatedButton extends StatefulWidget {
  const AnimatedButton({
    super.key,
    required this.label,
    required this.onPressed,
    this.icon,
    this.variant = ButtonVariant.filled,
    this.size = ButtonSize.medium,
    this.isLoading = false,
    this.isEnabled = true,
    this.width,
    this.height,
    this.semanticLabel,
  });

  final String label;
  final VoidCallback? onPressed;
  final IconData? icon;
  final ButtonVariant variant;
  final ButtonSize size;
  final bool isLoading;
  final bool isEnabled;
  final double? width;
  final double? height;
  final String? semanticLabel;

  @override
  State<AnimatedButton> createState() => _AnimatedButtonState();
}

enum ButtonVariant { filled, outlined, text, glass }
enum ButtonSize { small, medium, large }

class _AnimatedButtonState extends State<AnimatedButton>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;
  bool _isPressed = false;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 100),
      vsync: this,
    );
    _scaleAnimation = Tween<double>(begin: 1.0, end: 0.95).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _handleTapDown(TapDownDetails details) {
    if (widget.onPressed != null && widget.isEnabled) {
      HapticFeedback.lightImpact();
      setState(() => _isPressed = true);
      _controller.forward();
    }
  }

  void _handleTapUp(TapUpDetails details) {
    setState(() => _isPressed = false);
    _controller.reverse();
  }

  void _handleTapCancel() {
    setState(() => _isPressed = false);
    _controller.reverse();
  }

  @override
  Widget build(BuildContext context) {
    final effectiveCallback = widget.isEnabled && !widget.isLoading
        ? widget.onPressed
        : null;

    return GestureDetector(
      onTapDown: _handleTapDown,
      onTapUp: _handleTapUp,
      onTapCancel: _handleTapCancel,
      child: AnimatedBuilder(
        animation: _scaleAnimation,
        builder: (context, child) {
          return Transform.scale(
            scale: _scaleAnimation.value,
            child: _buildButton(context, effectiveCallback),
          );
        },
      ),
    );
  }

  Widget _buildButton(BuildContext context, VoidCallback? onPressed) {
    final theme = Theme.of(context);
    final isFilled = widget.variant == ButtonVariant.filled;
    final isGlass = widget.variant == ButtonVariant.glass;
    final isOutlined = widget.variant == ButtonVariant.outlined;

    final effectiveHeight = switch (widget.size) {
      ButtonSize.small => 40.0,
      ButtonSize.medium => AppSpacing.buttonHeight,
      ButtonSize.large => 64.0,
    };

    final effectiveFontSize = switch (widget.size) {
      ButtonSize.small => 14.0,
      ButtonSize.medium => 16.0,
      ButtonSize.large => 18.0,
    };

    final effectivePadding = switch (widget.size) {
      ButtonSize.small => const EdgeInsets.symmetric(horizontal: AppSpacing.md),
      ButtonSize.medium => const EdgeInsets.symmetric(horizontal: AppSpacing.lg),
      ButtonSize.large => const EdgeInsets.symmetric(horizontal: AppSpacing.xl),
    };

    Color? backgroundColor;
    Color? foregroundColor;
    Color? overlayColor;
    BorderSide? side;

    if (isFilled) {
      backgroundColor = onPressed != null
          ? theme.colorScheme.primary
          : theme.colorScheme.surfaceContainerHighest;
      foregroundColor = onPressed != null
          ? theme.colorScheme.onPrimary
          : theme.colorScheme.onSurfaceVariant;
      overlayColor = theme.colorScheme.primary.withOpacity(0.2);
    } else if (isGlass) {
      backgroundColor = AppColors.glass.withOpacity(0.15);
      foregroundColor = theme.colorScheme.onSurface;
      side = BorderSide(
        color: theme.colorScheme.outlineVariant.withOpacity(0.3),
        width: 1,
      );
      overlayColor = theme.colorScheme.primary.withOpacity(0.1);
    } else if (isOutlined) {
      backgroundColor = Colors.transparent;
      foregroundColor = onPressed != null
          ? theme.colorScheme.primary
          : theme.colorScheme.onSurfaceVariant;
      side = BorderSide(
        color: onPressed != null
            ? theme.colorScheme.primary
            : theme.colorScheme.outline,
        width: 1,
      );
      overlayColor = theme.colorScheme.primary.withOpacity(0.1);
    } else {
      backgroundColor = Colors.transparent;
      foregroundColor = onPressed != null
          ? theme.colorScheme.primary
          : theme.colorScheme.onSurfaceVariant;
      overlayColor = theme.colorScheme.primary.withOpacity(0.1);
    }

    Widget button = Container(
      width: widget.width,
      height: effectiveHeight,
      decoration: BoxDecoration(
        borderRadius: AppRadius.buttonRadius,
        border: side != null ? Border.fromBorderSide(side) : null,
        boxShadow: isGlass ? AppShadows.glass : null,
      ),
      child: Material(
        color: backgroundColor,
        child: InkWell(
          onTap: onPressed,
          splashColor: overlayColor,
          highlightColor: overlayColor,
          borderRadius: AppRadius.buttonRadius,
          child: Container(
            padding: effectivePadding,
            alignment: Alignment.center,
            child: _buildContent(context, effectiveFontSize, foregroundColor),
          ),
        ),
      ),
    );

    if (widget.semanticLabel != null) {
      button = Semantics(
        label: widget.semanticLabel,
        button: true,
        enabled: widget.isEnabled,
        child: button,
      );
    }

    return button;
  }

  Widget _buildContent(BuildContext context, double fontSize, Color? color) {
    if (widget.isLoading) {
      return SizedBox(
        width: fontSize,
        height: fontSize,
        child: CircularProgressIndicator(
          strokeWidth: 2,
          valueColor: AlwaysStoppedAnimation(color),
        ),
      );
    }

    final children = <Widget>[];

    if (widget.icon != null) {
      children.add(Icon(widget.icon, size: fontSize + 4));
    }

    children.add(const SizedBox(width: AppSpacing.sm));

    children.add(
      Text(
        widget.label,
        style: TextStyle(
          fontSize: fontSize,
          fontWeight: FontWeight.w500,
          color: color,
          letterSpacing: 0.5,
        ),
      ),
    );

    return Row(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.center,
      children: children,
    );
  }
}
