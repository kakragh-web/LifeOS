import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:lifeos_ai/core/theme/app_colors.dart';
import 'package:lifeos_ai/core/theme/app_radius.dart';
import 'package:lifeos_ai/core/theme/app_shadows.dart';
import 'package:lifeos_ai/core/theme/app_spacing.dart';

/// Premium dialog with glass effect and smooth animations.
class AppDialog {
  AppDialog._();

  static Future<T?> show<T>({
    required BuildContext context,
    required String title,
    String? message,
    required List<DialogAction> actions,
    bool barrierDismissible = true,
    Color? backgroundColor,
    double blur = 20.0,
  }) {
    HapticFeedback.lightImpact();

    final theme = Theme.of(context);
    final effectiveBackgroundColor =
        backgroundColor ?? theme.colorScheme.surface.withOpacity(0.95);

    return showDialog<T>(
      context: context,
      barrierDismissible: barrierDismissible,
      barrierColor: AppColors.scrim,
      builder: (context) => Dialog(
        backgroundColor: Colors.transparent,
        elevation: 0,
        child: Container(
          decoration: BoxDecoration(
            borderRadius: AppRadius.dialogRadius,
            color: effectiveBackgroundColor,
            boxShadow: AppShadows.elevation8,
          ),
          child: ClipRRect(
            borderRadius: AppRadius.dialogRadius,
            child: BackdropFilter(
              filter: ImageFilter.blur(sigmaX: blur, sigmaY: blur),
              child: Padding(
                padding: const EdgeInsets.all(AppSpacing.xl),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      title,
                      style: theme.textTheme.headlineSmall,
                      textAlign: TextAlign.center,
                    ),
                    if (message != null) ...[
                      const SizedBox(height: AppSpacing.md),
                      Text(
                        message,
                        style: theme.textTheme.bodyMedium,
                        textAlign: TextAlign.center,
                      ),
                    ],
                    const SizedBox(height: AppSpacing.xl),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: actions.map((action) {
                        return _DialogActionButton(action: action);
                      }).toList(),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  static Future<bool?> showConfirm({
    required BuildContext context,
    required String title,
    String? message,
    String confirmText = 'Confirm',
    String cancelText = 'Cancel',
    bool isDestructive = false,
  }) {
    return show<bool>(
      context: context,
      title: title,
      message: message,
      actions: [
        DialogAction(
          label: cancelText,
          onTap: () => Navigator.of(context).pop(false),
        ),
        DialogAction(
          label: confirmText,
          onTap: () => Navigator.of(context).pop(true),
          isDestructive: isDestructive,
          isPrimary: true,
        ),
      ],
    );
  }

  static Future<void> showAlert({
    required BuildContext context,
    required String title,
    String? message,
    String buttonText = 'OK',
  }) {
    return show(
      context: context,
      title: title,
      message: message,
      actions: [
        DialogAction(
          label: buttonText,
          onTap: () => Navigator.of(context).pop(),
          isPrimary: true,
        ),
      ],
      barrierDismissible: true,
    );
  }
}

class DialogAction {
  const DialogAction({
    required this.label,
    required this.onTap,
    this.isDestructive = false,
    this.isPrimary = false,
    this.enabled = true,
  });

  final String label;
  final VoidCallback onTap;
  final bool isDestructive;
  final bool isPrimary;
  final bool enabled;
}

class _DialogActionButton extends StatelessWidget {
  const _DialogActionButton({required this.action});

  final DialogAction action;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    final effectiveColor = action.isDestructive
        ? colorScheme.error
        : (action.isPrimary ? colorScheme.primary : colorScheme.onSurface);

    return Padding(
      padding: const EdgeInsets.only(left: AppSpacing.sm),
      child: TextButton(
        onPressed: action.enabled ? action.onTap : null,
        style: TextButton.styleFrom(
          foregroundColor: effectiveColor,
          padding: const EdgeInsets.symmetric(
            horizontal: AppSpacing.lg,
            vertical: AppSpacing.md,
          ),
        ),
        child: Text(
          action.label,
          style: TextStyle(
            fontWeight: action.isPrimary ? FontWeight.w600 : FontWeight.normal,
          ),
        ),
      ),
    );
  }
}
