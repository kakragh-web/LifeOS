import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:lifeos_ai/core/theme/app_colors.dart';
import 'package:lifeos_ai/core/theme/app_radius.dart';
import 'package:lifeos_ai/core/theme/app_shadows.dart';
import 'package:lifeos_ai/core/theme/app_spacing.dart';

/// Animated text field with focus animations and glass effect.
class AnimatedTextField extends StatefulWidget {
  const AnimatedTextField({
    super.key,
    required this.controller,
    required this.label,
    this.hint,
    this.prefixIcon,
    this.suffixIcon,
    this.obscureText = false,
    this.keyboardType,
    this.textInputAction,
    this.validator,
    this.onFieldSubmitted,
    this.enabled = true,
    this.maxLines = 1,
    this.isGlass = false,
    this.autofillHints,
    this.inputFormatters,
    this.onChanged,
  });

  final TextEditingController controller;
  final String label;
  final String? hint;
  final IconData? prefixIcon;
  final Widget? suffixIcon;
  final bool obscureText;
  final TextInputType? keyboardType;
  final TextInputAction? textInputAction;
  final String? Function(String?)? validator;
  final void Function(String)? onFieldSubmitted;
  final bool enabled;
  final int maxLines;
  final bool isGlass;
  final Iterable<String>? autofillHints;
  final List<TextInputFormatter>? inputFormatters;
  final ValueChanged<String>? onChanged;

  @override
  State<AnimatedTextField> createState() => _AnimatedTextFieldState();
}

class _AnimatedTextFieldState extends State<AnimatedTextField>
    with SingleTickerProviderStateMixin {
  late AnimationController _focusController;
  late Animation<double> _focusAnimation;
  bool _isFocused = false;
  bool _hasValue = false;

  @override
  void initState() {
    super.initState();
    _focusController = AnimationController(
      duration: const Duration(milliseconds: 200),
      vsync: this,
    );
    _focusAnimation = CurvedAnimation(
      parent: _focusController,
      curve: Curves.easeInOut,
    );
    _hasValue = widget.controller.text.isNotEmpty;
  }

  @override
  void didUpdateWidget(AnimatedTextField oldWidget) {
    super.didUpdateWidget(oldWidget);
    _hasValue = widget.controller.text.isNotEmpty;
  }

  @override
  void dispose() {
    _focusController.dispose();
    super.dispose();
  }

  void _handleFocusChange(bool hasFocus) {
    setState(() {
      _isFocused = hasFocus;
      _hasValue = widget.controller.text.isNotEmpty;
    });
    if (hasFocus) {
      _focusController.forward();
      HapticFeedback.lightImpact();
    } else {
      _focusController.reverse();
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return AnimatedBuilder(
      animation: _focusAnimation,
      builder: (context, child) {
        final borderColor = _isFocused
            ? colorScheme.primary
            : colorScheme.outline.withOpacity(0.3 + 0.4 * (1 - _focusAnimation.value));

        final containerColor = widget.isGlass
            ? AppColors.glass.withOpacity(0.1 + 0.1 * _focusAnimation.value)
            : colorScheme.surfaceContainerHighest.withOpacity(0.6);

        return Container(
          decoration: BoxDecoration(
            borderRadius: AppRadius.textFieldRadius,
            border: Border.all(
              color: borderColor,
              width: _isFocused ? 2 : 1,
            ),
            boxShadow: _isFocused
                ? AppShadows.primaryGlow()
                : AppShadows.elevation1,
          ),
          child: TextFormField(
            controller: widget.controller,
            obscureText: widget.obscureText,
            keyboardType: widget.keyboardType,
            textInputAction: widget.textInputAction,
            validator: widget.validator,
            onFieldSubmitted: widget.onFieldSubmitted,
            enabled: widget.enabled,
            maxLines: widget.maxLines,
            autofillHints: widget.autofillHints,
            inputFormatters: widget.inputFormatters,
            onChanged: (value) {
              setState(() => _hasValue = value.isNotEmpty);
              widget.onChanged?.call(value);
            },
            decoration: InputDecoration(
              labelText: widget.label,
              hintText: widget.hint,
              prefixIcon: widget.prefixIcon != null
                  ? Icon(widget.prefixIcon, color: _isFocused
                      ? colorScheme.primary
                      : colorScheme.onSurfaceVariant)
                  : null,
              suffixIcon: widget.suffixIcon,
              filled: true,
              fillColor: containerColor,
              border: OutlineInputBorder(
                borderRadius: AppRadius.textFieldRadius,
                borderSide: BorderSide.none,
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: AppRadius.textFieldRadius,
                borderSide: BorderSide.none,
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: AppRadius.textFieldRadius,
                borderSide: BorderSide.none,
              ),
              errorBorder: OutlineInputBorder(
                borderRadius: AppRadius.textFieldRadius,
                borderSide: BorderSide(color: colorScheme.error, width: 1),
              ),
              focusedErrorBorder: OutlineInputBorder(
                borderRadius: AppRadius.textFieldRadius,
                borderSide: BorderSide(color: colorScheme.error, width: 2),
              ),
              contentPadding: EdgeInsets.symmetric(
                horizontal: AppSpacing.lg,
                vertical: widget.maxLines > 1 ? AppSpacing.md : AppSpacing.buttonHeight / 2,
              ),
            ),
            onTapOutside: (event) {
              final focusNode = FocusScope.of(context);
              if (focusNode.hasFocus) {
                focusNode.unfocus();
              }
            },
          ),
        );
      },
    );
  }
}
