import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:lifeos_ai/core/theme/app_colors.dart';
import 'package:lifeos_ai/core/theme/app_radius.dart';
import 'package:lifeos_ai/core/theme/app_shadows.dart';
import 'package:lifeos_ai/core/theme/app_spacing.dart';
import 'package:lifeos_ai/core/theme/app_typography.dart';

/// Premium Material 3 theme for LifeOS with glassmorphism support.
class AppTheme {
  AppTheme._();

  static const _seed = Color(0xFF6750A4);

  static ThemeData get lightTheme {
    final colorScheme = ColorScheme.fromSeed(
      seedColor: _seed,
      brightness: Brightness.light,
    );

    return ThemeData(
      useMaterial3: true,
      colorScheme: colorScheme,
      fontFamily: 'Roboto',
      brightness: Brightness.light,

      // ─── App Bar ─────────────────────────────────────────────────────
      appBarTheme: AppBarTheme(
        backgroundColor: AppColors.surface.withOpacity(0.9),
        foregroundColor: AppColors.onSurface,
        elevation: 0,
        centerTitle: false,
        systemOverlayStyle: SystemUiOverlayStyle.dark,
        titleTextStyle: AppTypography.titleLarge.copyWith(
          color: AppColors.onSurface,
        ),
      ),

      // ─── Cards ───────────────────────────────────────────────────────
      cardTheme: CardTheme(
        color: AppColors.surfaceContainer,
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: AppRadius.cardRadius,
          side: BorderSide(
            color: AppColors.outlineVariant.withOpacity(0.3),
            width: 1,
          ),
        ),
      ),

      // ─── Inputs ──────────────────────────────────────────────────────
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: AppColors.surfaceContainerHighest,
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
          borderSide: const BorderSide(color: AppColors.primary, width: 2),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: AppRadius.textFieldRadius,
          borderSide: const BorderSide(color: AppColors.error, width: 1),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: AppRadius.textFieldRadius,
          borderSide: const BorderSide(color: AppColors.error, width: 2),
        ),
        contentPadding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.lg,
          vertical: AppSpacing.md,
        ),
        labelStyle: const TextStyle(color: AppColors.onSurfaceVariant),
        hintStyle: const TextStyle(color: AppColors.onSurfaceVariant),
      ),

      // ─── Buttons ─────────────────────────────────────────────────────
      filledButtonTheme: FilledButtonThemeData(
        style: FilledButton.styleFrom(
          backgroundColor: AppColors.primary,
          foregroundColor: AppColors.onPrimary,
          minimumSize: const Size(double.infinity, AppSpacing.buttonHeight),
          shape: RoundedRectangleBorder(
            borderRadius: AppRadius.buttonRadius,
          ),
          textStyle: AppTypography.button,
        ),
      ),

      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: AppColors.primary,
          minimumSize: const Size(double.infinity, AppSpacing.buttonHeight),
          shape: RoundedRectangleBorder(
            borderRadius: AppRadius.buttonRadius,
          ),
          side: const BorderSide(color: AppColors.primary, width: 1.5),
          textStyle: AppTypography.button,
        ),
      ),

      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          foregroundColor: AppColors.primary,
          textStyle: AppTypography.button,
        ),
      ),

      // ─── FAB ─────────────────────────────────────────────────────────
      floatingActionButtonTheme: const FloatingActionButtonThemeData(
        backgroundColor: AppColors.primaryContainer,
        foregroundColor: AppColors.onPrimaryContainer,
        elevation: 3,
        shape: CircleBorder(),
      ),

      // ─── Navigation Bar ──────────────────────────────────────────────
      navigationBarTheme: NavigationBarThemeData(
        backgroundColor: AppColors.surface.withOpacity(0.9),
        elevation: 0,
        indicatorColor: AppColors.primaryContainer,
        labelTextStyle: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.selected)) {
            return AppTypography.labelMedium.copyWith(
              color: AppColors.onPrimaryContainer,
              fontWeight: FontWeight.w600,
            );
          }
          return AppTypography.labelMedium.copyWith(
            color: AppColors.onSurfaceVariant,
          );
        }),
        iconTheme: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.selected)) {
            return IconThemeData(
              color: AppColors.onPrimaryContainer,
              size: AppSpacing.iconMd,
            );
          }
          return IconThemeData(
            color: AppColors.onSurfaceVariant,
            size: AppSpacing.iconMd,
          );
        }),
      ),

      // ─── Divider ─────────────────────────────────────────────────────
      dividerTheme: DividerThemeData(
        color: AppColors.outlineVariant.withOpacity(0.5),
        thickness: AppSpacing.dividerThickness,
        space: AppSpacing.dividerIndent,
      ),

      // ─── Text Theme ──────────────────────────────────────────────────
      textTheme: AppTypography.textTheme.apply(
        bodyColor: AppColors.onSurface,
        displayColor: AppColors.onSurface,
      ),

      // ─── Icon Theme ──────────────────────────────────────────────────
      iconTheme: IconThemeData(
        color: AppColors.onSurfaceVariant,
        size: AppSpacing.iconMd,
      ),

      // ─── Primary Icon Theme ──────────────────────────────────────────
      primaryIconTheme: const IconThemeData(
        color: AppColors.primary,
        size: AppSpacing.iconMd,
      ),

      // ─── Slider ──────────────────────────────────────────────────────
      sliderTheme: SliderThemeData(
        activeTrackColor: AppColors.primary,
        inactiveTrackColor: AppColors.surfaceContainerHighest,
        thumbColor: AppColors.primary,
        overlayColor: AppColors.primary.withOpacity(0.2),
      ),

      // ─── Switch ──────────────────────────────────────────────────────
      switchTheme: SwitchThemeData(
        thumbColor: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.selected)) {
            return AppColors.onPrimary;
          }
          return AppColors.outline;
        }),
        trackColor: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.selected)) {
            return AppColors.primary;
          }
          return AppColors.surfaceContainerHighest;
        }),
      ),

      // ─── Checkbox ────────────────────────────────────────────────────
      checkboxTheme: CheckboxThemeData(
        fillColor: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.selected)) {
            return AppColors.primary;
          }
          return null;
        }),
        checkColor: WidgetStateProperty.all(AppColors.onPrimary),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppRadius.xs),
        ),
      ),

      // ─── Radio ───────────────────────────────────────────────────────
      radioTheme: RadioThemeData(
        fillColor: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.selected)) {
            return AppColors.primary;
          }
          return AppColors.outline;
        }),
      ),

      // ─── Progress Indicator ──────────────────────────────────────────
      progressIndicatorTheme: const ProgressIndicatorThemeData(
        color: AppColors.primary,
        linearTrackColor: AppColors.surfaceContainerHighest,
      ),

      // ─── Bottom Sheet ────────────────────────────────────────────────
      bottomSheetTheme: const BottomSheetThemeData(
        backgroundColor: AppColors.surface,
        elevation: 8,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(
            top: Radius.circular(AppRadius.bottomSheet),
          ),
        ),
      ),

      // ─── Dialog ──────────────────────────────────────────────────────
      dialogTheme: DialogTheme(
        backgroundColor: AppColors.surface.withOpacity(0.95),
        elevation: 8,
        shape: RoundedRectangleBorder(
          borderRadius: AppRadius.dialogRadius,
        ),
      ),

      // ─── Tooltip ─────────────────────────────────────────────────────
      tooltipTheme: TooltipThemeData(
        decoration: BoxDecoration(
          color: AppColors.inverseSurface,
          borderRadius: BorderRadius.circular(AppRadius.sm),
        ),
        textStyle: AppTypography.labelSmall.copyWith(
          color: AppColors.onInverseSurface,
        ),
      ),
    );
  }

  static ThemeData get darkTheme {
    final colorScheme = ColorScheme.fromSeed(
      seedColor: _seed,
      brightness: Brightness.dark,
    );

    return ThemeData(
      useMaterial3: true,
      colorScheme: colorScheme,
      fontFamily: 'Roboto',
      brightness: Brightness.dark,

      // ─── App Bar ─────────────────────────────────────────────────────
      appBarTheme: AppBarTheme(
        backgroundColor: AppColors.inverseSurface.withOpacity(0.9),
        foregroundColor: AppColors.onInverseSurface,
        elevation: 0,
        centerTitle: false,
        systemOverlayStyle: SystemUiOverlayStyle.light,
        titleTextStyle: AppTypography.titleLarge.copyWith(
          color: AppColors.onInverseSurface,
        ),
      ),

      // ─── Cards ───────────────────────────────────────────────────────
      cardTheme: CardTheme(
        color: AppColors.surfaceContainerHighest.withOpacity(0.1),
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: AppRadius.cardRadius,
          side: BorderSide(
            color: AppColors.outlineVariant.withOpacity(0.2),
            width: 1,
          ),
        ),
      ),

      // ─── Inputs ──────────────────────────────────────────────────────
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: AppColors.surfaceContainerHighest.withOpacity(0.2),
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
          borderSide: const BorderSide(color: AppColors.primary, width: 2),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: AppRadius.textFieldRadius,
          borderSide: const BorderSide(color: AppColors.error, width: 1),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: AppRadius.textFieldRadius,
          borderSide: const BorderSide(color: AppColors.error, width: 2),
        ),
        contentPadding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.lg,
          vertical: AppSpacing.md,
        ),
        labelStyle: const TextStyle(color: AppColors.onSurfaceVariant),
        hintStyle: const TextStyle(color: AppColors.onSurfaceVariant),
      ),

      // ─── Buttons ─────────────────────────────────────────────────────
      filledButtonTheme: FilledButtonThemeData(
        style: FilledButton.styleFrom(
          backgroundColor: AppColors.primary,
          foregroundColor: AppColors.onPrimary,
          minimumSize: const Size(double.infinity, AppSpacing.buttonHeight),
          shape: RoundedRectangleBorder(
            borderRadius: AppRadius.buttonRadius,
          ),
          textStyle: AppTypography.button,
        ),
      ),

      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: AppColors.primary,
          minimumSize: const Size(double.infinity, AppSpacing.buttonHeight),
          shape: RoundedRectangleBorder(
            borderRadius: AppRadius.buttonRadius,
          ),
          side: const BorderSide(color: AppColors.primary, width: 1.5),
          textStyle: AppTypography.button,
        ),
      ),

      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          foregroundColor: AppColors.primary,
          textStyle: AppTypography.button,
        ),
      ),

      // ─── FAB ─────────────────────────────────────────────────────────
      floatingActionButtonTheme: const FloatingActionButtonThemeData(
        backgroundColor: AppColors.primaryContainer,
        foregroundColor: AppColors.onPrimaryContainer,
        elevation: 3,
        shape: CircleBorder(),
      ),

      // ─── Navigation Bar ──────────────────────────────────────────────
      navigationBarTheme: NavigationBarThemeData(
        backgroundColor: AppColors.inverseSurface.withOpacity(0.9),
        elevation: 0,
        indicatorColor: AppColors.primaryContainer.withOpacity(0.3),
        labelTextStyle: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.selected)) {
            return AppTypography.labelMedium.copyWith(
              color: AppColors.onPrimaryContainer,
              fontWeight: FontWeight.w600,
            );
          }
          return AppTypography.labelMedium.copyWith(
            color: AppColors.onSurfaceVariant,
          );
        }),
        iconTheme: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.selected)) {
            return IconThemeData(
              color: AppColors.onPrimaryContainer,
              size: AppSpacing.iconMd,
            );
          }
          return IconThemeData(
            color: AppColors.onSurfaceVariant,
            size: AppSpacing.iconMd,
          );
        }),
      ),

      // ─── Divider ─────────────────────────────────────────────────────
      dividerTheme: DividerThemeData(
        color: AppColors.outlineVariant.withOpacity(0.3),
        thickness: AppSpacing.dividerThickness,
        space: AppSpacing.dividerIndent,
      ),

      // ─── Text Theme ──────────────────────────────────────────────────
      textTheme: AppTypography.textTheme.apply(
        bodyColor: AppColors.onBackground,
        displayColor: AppColors.onBackground,
      ),

      // ─── Icon Theme ──────────────────────────────────────────────────
      iconTheme: IconThemeData(
        color: AppColors.onSurfaceVariant,
        size: AppSpacing.iconMd,
      ),

      // ─── Primary Icon Theme ──────────────────────────────────────────
      primaryIconTheme: const IconThemeData(
        color: AppColors.primary,
        size: AppSpacing.iconMd,
      ),

      // ─── Slider ──────────────────────────────────────────────────────
      sliderTheme: SliderThemeData(
        activeTrackColor: AppColors.primary,
        inactiveTrackColor: AppColors.surfaceContainerHighest.withOpacity(0.3),
        thumbColor: AppColors.primary,
        overlayColor: AppColors.primary.withOpacity(0.2),
      ),

      // ─── Switch ──────────────────────────────────────────────────────
      switchTheme: SwitchThemeData(
        thumbColor: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.selected)) {
            return AppColors.onPrimary;
          }
          return AppColors.outline;
        }),
        trackColor: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.selected)) {
            return AppColors.primary;
          }
          return AppColors.surfaceContainerHighest.withOpacity(0.5);
        }),
      ),

      // ─── Checkbox ────────────────────────────────────────────────────
      checkboxTheme: CheckboxThemeData(
        fillColor: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.selected)) {
            return AppColors.primary;
          }
          return null;
        }),
        checkColor: WidgetStateProperty.all(AppColors.onPrimary),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppRadius.xs),
        ),
      ),

      // ─── Radio ───────────────────────────────────────────────────────
      radioTheme: RadioThemeData(
        fillColor: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.selected)) {
            return AppColors.primary;
          }
          return AppColors.outline;
        }),
      ),

      // ─── Progress Indicator ──────────────────────────────────────────
      progressIndicatorTheme: const ProgressIndicatorThemeData(
        color: AppColors.primary,
        linearTrackColor: AppColors.surfaceContainerHighest,
      ),

      // ─── Bottom Sheet ────────────────────────────────────────────────
      bottomSheetTheme: BottomSheetThemeData(
        backgroundColor: AppColors.inverseSurface.withOpacity(0.95),
        elevation: 8,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(
            top: Radius.circular(AppRadius.bottomSheet),
          ),
        ),
      ),

      // ─── Dialog ──────────────────────────────────────────────────────
      dialogTheme: DialogTheme(
        backgroundColor: AppColors.inverseSurface.withOpacity(0.95),
        elevation: 8,
        shape: RoundedRectangleBorder(
          borderRadius: AppRadius.dialogRadius,
        ),
      ),

      // ─── Tooltip ─────────────────────────────────────────────────────
      tooltipTheme: TooltipThemeData(
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(AppRadius.sm),
        ),
        textStyle: AppTypography.labelSmall.copyWith(
          color: AppColors.onInverseSurface,
        ),
      ),
    );
  }
}
