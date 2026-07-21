import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:lifeos_ai/core/theme/app_radius.dart';
import 'package:lifeos_ai/core/theme/app_shadows.dart';
import 'package:lifeos_ai/core/theme/app_spacing.dart';

/// Premium bottom sheet with glass effect and smooth animations.
class AppBottomSheet {
  AppBottomSheet._();

  static Future<T?> show<T>({
    required BuildContext context,
    required WidgetBuilder builder,
    bool isDismissible = true,
    bool enableDrag = true,
    double? height,
    Color? backgroundColor,
    double blur = 20.0,
  }) {
    HapticFeedback.lightImpact();

    final effectiveBackgroundColor = backgroundColor ??
        Theme.of(context).colorScheme.surface.withOpacity(0.95);

    return showModalBottomSheet<T>(
      context: context,
      isDismissible: isDismissible,
      enableDrag: enableDrag,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
        height: height,
        decoration: BoxDecoration(
          borderRadius: AppRadius.bottomSheetRadius,
          color: effectiveBackgroundColor,
          boxShadow: AppShadows.elevation8,
        ),
        child: ClipRRect(
          borderRadius: AppRadius.bottomSheetRadius,
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: blur, sigmaY: blur),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  width: 40,
                  height: 4,
                  margin: const EdgeInsets.symmetric(vertical: AppSpacing.sm),
                  decoration: BoxDecoration(
                    color: Theme.of(context).colorScheme.outlineVariant,
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
                Flexible(child: builder(context)),
              ],
            ),
          ),
        ),
      ),
    );
  }

  static Future<T?> showActionSheet<T>({
    required BuildContext context,
    required String title,
    required List<BottomSheetAction> actions,
    VoidCallback? onCancel,
    String? cancelText,
  }) {
    return show<T>(
      context: context,
      height: null,
      builder: (context) => Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Padding(
            padding: const EdgeInsets.all(AppSpacing.lg),
            child: Text(
              title,
              style: Theme.of(context).textTheme.titleMedium,
              textAlign: TextAlign.center,
            ),
          ),
          const Divider(height: 1),
          ...actions.map((action) => _ActionTile(action: action)),
          if (onCancel != null || cancelText != null) ...[
            const Divider(height: 1),
            _ActionTile(
              action: BottomSheetAction(
                label: cancelText ?? 'Cancel',
                isDestructive: false,
                onTap: () {
                  Navigator.of(context).pop();
                  onCancel?.call();
                },
              ),
            ),
          ],
          const SizedBox(height: AppSpacing.sm),
        ],
      ),
    );
  }
}

class BottomSheetAction {
  const BottomSheetAction({
    required this.label,
    required this.onTap,
    this.icon,
    this.isDestructive = false,
    this.enabled = true,
  });

  final String label;
  final VoidCallback onTap;
  final IconData? icon;
  final bool isDestructive;
  final bool enabled;
}

class _ActionTile extends StatelessWidget {
  const _ActionTile({required this.action});

  final BottomSheetAction action;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final textColor = action.isDestructive
        ? theme.colorScheme.error
        : (action.enabled
            ? theme.colorScheme.onSurface
            : theme.colorScheme.onSurfaceVariant);

    return InkWell(
      onTap: action.enabled ? action.onTap : null,
      child: Container(
        padding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.lg,
          vertical: AppSpacing.md,
        ),
        child: Row(
          children: [
            if (action.icon != null) ...[
              Icon(action.icon, color: textColor, size: AppSpacing.iconMd),
              const SizedBox(width: AppSpacing.md),
            ],
            Expanded(
              child: Text(
                action.label,
                style: TextStyle(
                  fontSize: 16,
                  color: textColor,
                  fontWeight: action.isDestructive ? FontWeight.w500 : null,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
