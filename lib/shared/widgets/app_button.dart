import 'package:flutter/material.dart';

enum _Variant { filled, outlined, text }

/// Reusable button with three variants: filled (primary), outlined, text.
///
/// Usage:
/// ```dart
/// AppButton(label: 'Save', onPressed: _save)
/// AppButton.outlined(label: 'Cancel', onPressed: _cancel)
/// AppButton.text(label: 'Skip', onPressed: _skip)
/// ```
class AppButton extends StatelessWidget {
  const AppButton({
    super.key,
    required this.label,
    required this.onPressed,
    this.icon,
    this.isLoading = false,
  }) : _variant = _Variant.filled;

  const AppButton.outlined({
    super.key,
    required this.label,
    required this.onPressed,
    this.icon,
    this.isLoading = false,
  }) : _variant = _Variant.outlined;

  const AppButton.text({
    super.key,
    required this.label,
    required this.onPressed,
    this.icon,
    this.isLoading = false,
  }) : _variant = _Variant.text;

  final String label;

  /// Pass null to disable the button.
  final VoidCallback? onPressed;
  final IconData? icon;
  final bool isLoading;
  final _Variant _variant;

  @override
  Widget build(BuildContext context) {
    final effectiveCallback = isLoading ? null : onPressed;
    final child =
        _ButtonContent(label: label, icon: icon, isLoading: isLoading);

    return switch (_variant) {
      _Variant.filled => FilledButton(
          onPressed: effectiveCallback,
          child: child,
        ),
      _Variant.outlined => OutlinedButton(
          onPressed: effectiveCallback,
          child: child,
        ),
      _Variant.text => TextButton(
          onPressed: effectiveCallback,
          child: child,
        ),
    };
  }
}

class _ButtonContent extends StatelessWidget {
  const _ButtonContent({
    required this.label,
    this.icon,
    required this.isLoading,
  });

  final String label;
  final IconData? icon;
  final bool isLoading;

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return const SizedBox.square(
        dimension: 20,
        child: CircularProgressIndicator(strokeWidth: 2.5),
      );
    }
    if (icon != null) {
      return Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 20),
          const SizedBox(width: 8),
          Text(label),
        ],
      );
    }
    return Text(label);
  }
}
