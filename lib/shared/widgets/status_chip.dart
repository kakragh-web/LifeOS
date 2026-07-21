import 'package:flutter/material.dart';
import 'package:lifeos_ai/core/theme/app_colors.dart';
import 'package:lifeos_ai/core/theme/app_radius.dart';
import 'package:lifeos_ai/core/theme/app_spacing.dart';

/// Status chip for displaying task status, categories, etc.
class StatusChip extends StatelessWidget {
  const StatusChip({
    super.key,
    required this.label,
    this.icon,
    this.backgroundColor,
    this.foregroundColor,
    this.borderColor,
    this.onTap,
    this.onDeleted,
    this.isSelected = false,
    this.variant = ChipVariant.filled,
  });

  final String label;
  final IconData? icon;
  final Color? backgroundColor;
  final Color? foregroundColor;
  final Color? borderColor;
  final VoidCallback? onTap;
  final VoidCallback? onDeleted;
  final bool isSelected;
  final ChipVariant variant;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    final effectiveBackgroundColor = switch (variant) {
      ChipVariant.filled => backgroundColor ??
          (isSelected
              ? colorScheme.primary
              : colorScheme.secondaryContainer),
      ChipVariant.outlined => Colors.transparent,
      ChipVariant.elevated => backgroundColor ??
          colorScheme.surfaceContainerHighest,
    };

    final effectiveForegroundColor = switch (variant) {
      ChipVariant.filled => foregroundColor ??
          (isSelected ? colorScheme.onPrimary : colorScheme.onSecondaryContainer),
      ChipVariant.outlined => foregroundColor ?? colorScheme.onSurfaceVariant,
      ChipVariant.elevated => foregroundColor ?? colorScheme.onSurface,
    };

    final effectiveBorderColor = switch (variant) {
      ChipVariant.filled => Colors.transparent,
      ChipVariant.outlined => borderColor ?? colorScheme.outline,
      ChipVariant.elevated => Colors.transparent,
    };

    return Chip(
      label: Text(label),
      avatar: icon != null ? Icon(icon, size: AppSpacing.iconSm) : null,
      backgroundColor: effectiveBackgroundColor,
      side: effectiveBorderColor != Colors.transparent
          ? BorderSide(color: effectiveBorderColor)
          : null,
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.md,
        vertical: AppSpacing.xs,
      ),
      labelPadding: icon != null
          ? const EdgeInsets.only(left: AppSpacing.xs)
          : null,
      onDeleted: onDeleted,
      elevation: variant == ChipVariant.elevated ? 1 : 0,
      shape: RoundedRectangleBorder(
        borderRadius: AppRadius.chipRadius,
      ),
      materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
      visualDensity: VisualDensity.compact,
    );
  }

  /// Predefined status chips for common use cases.
  factory StatusChip.todo(String label) => StatusChip(
        label: label,
        icon: Icons.circle_outlined,
        backgroundColor: AppColors.surfaceVariant,
        foregroundColor: AppColors.onSurfaceVariant,
        variant: ChipVariant.filled,
      );

  factory StatusChip.inProgress(String label) => StatusChip(
        label: label,
        icon: Icons.pending_outlined,
        backgroundColor: AppColors.infoContainer,
        foregroundColor: AppColors.onInfoContainer,
        variant: ChipVariant.filled,
      );

  factory StatusChip.done(String label) => StatusChip(
        label: label,
        icon: Icons.check_circle_outline,
        backgroundColor: AppColors.successContainer,
        foregroundColor: AppColors.onSuccessContainer,
        variant: ChipVariant.filled,
      );

  factory StatusChip.highPriority() => const StatusChip(
        label: 'High',
        icon: Icons.arrow_upward_rounded,
        backgroundColor: AppColors.errorContainer,
        foregroundColor: AppColors.onErrorContainer,
        variant: ChipVariant.filled,
      );

  factory StatusChip.mediumPriority() => const StatusChip(
        label: 'Medium',
        icon: Icons.remove_rounded,
        backgroundColor: AppColors.warningContainer,
        foregroundColor: AppColors.onWarningContainer,
        variant: ChipVariant.filled,
      );

  factory StatusChip.lowPriority() => const StatusChip(
        label: 'Low',
        icon: Icons.arrow_downward_rounded,
        backgroundColor: AppColors.infoContainer,
        foregroundColor: AppColors.onInfoContainer,
        variant: ChipVariant.filled,
      );
}

enum ChipVariant { filled, outlined, elevated }
