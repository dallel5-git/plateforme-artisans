import 'package:flutter/material.dart';

import 'package:sanaya/core/theme/app_colors.dart';
import 'package:sanaya/core/theme/app_elevation.dart';
import 'package:sanaya/core/theme/app_spacing.dart';
import 'package:sanaya/core/theme/app_text.dart';

/// Construit un [ThemeData] clair ou sombre en ne consommant que les
/// fichiers générés SO-04 ([AppColors], [AppText]) — aucune valeur de style
/// en dur.
ThemeData buildTheme({
  required Brightness brightness,
  required Locale locale,
}) {
  final colors = brightness == Brightness.light
      ? AppColors.light
      : AppColors.dark;
  final elevation = brightness == Brightness.light
      ? AppElevation.light
      : AppElevation.dark;

  // Les rôles M3 sans correspondant direct dans AppColors (tertiary,
  // surfaceContainer*…) restent sur la dérivation algorithmique de
  // fromSeed — assumé, pas un oubli : rien n'est designé pour eux pour
  // l'instant.
  final colorScheme =
      ColorScheme.fromSeed(
        seedColor: Palette.brand500,
        brightness: brightness,
      ).copyWith(
        primary: colors.accent,
        onPrimary: colors.onAccent,
        secondaryContainer: colors.accentSubtle,
        surface: colors.surface,
        onSurface: colors.textPrimary,
        error: colors.destructive,
        errorContainer: colors.destructiveSubtle,
        outline: colors.border,
        outlineVariant: colors.borderStrong,
      );

  return ThemeData(
    useMaterial3: true,
    brightness: brightness,
    extensions: [colors, elevation],
    colorScheme: colorScheme,
    scaffoldBackgroundColor: colors.background,
    textTheme: _textThemeFrom(colors, locale),
    appBarTheme: AppBarTheme(
      backgroundColor: colors.surface,
      foregroundColor: colors.textPrimary,
      elevation: 0,
      scrolledUnderElevation: 0,
      titleTextStyle: AppText.h3(locale).copyWith(color: colors.textPrimary),
      iconTheme: IconThemeData(color: colors.textPrimary),
    ),
    // backgroundColor et modalBackgroundColor sont tous les deux fixés sur
    // colors.surface pour qu'une showModalBottomSheet() sans style explicite
    // ne retombe pas sur colorScheme.surfaceContainerLow (dérivation M3 par
    // défaut) — aucun rôle AppColors dédié n'existe pour ce palier.
    bottomSheetTheme: BottomSheetThemeData(
      backgroundColor: colors.surface,
      modalBackgroundColor: colors.surface,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: AppRadius.xl),
      ),
    ),
    dialogTheme: DialogThemeData(backgroundColor: colors.surface),
    chipTheme: ChipThemeData(
      backgroundColor: colors.surfaceRaised,
      selectedColor: colors.accentSubtle,
      side: BorderSide(color: colors.border),
      labelStyle: AppText.small(locale).copyWith(color: colors.textPrimary),
    ),
    dividerTheme: DividerThemeData(
      color: colors.border,
      thickness: 1,
      space: 1,
    ),
    // Pas de rôle AppColors dédié type « inverseSurface » : textPrimary/
    // textInverse forment la paire fond sombre/texte clair la plus proche.
    snackBarTheme: SnackBarThemeData(
      backgroundColor: colors.textPrimary,
      contentTextStyle: AppText.body(
        locale,
      ).copyWith(color: colors.textInverse),
      behavior: SnackBarBehavior.floating,
    ),
    checkboxTheme: CheckboxThemeData(
      fillColor: WidgetStateProperty.resolveWith(
        (states) => states.contains(WidgetState.selected)
            ? colors.accent
            : Colors.transparent,
      ),
      checkColor: WidgetStateProperty.all(colors.onAccent),
      side: BorderSide(color: colors.border, width: 1.5),
    ),
    progressIndicatorTheme: ProgressIndicatorThemeData(
      color: colors.accent,
      linearTrackColor: colors.accentSubtle,
      circularTrackColor: colors.accentSubtle,
    ),
  );
}

// AppSpacing/AppRadius n'ont pas d'équivalent dans ThemeData (Flutter n'a
// pas de notion de padding par défaut) — consommés directement par les
// widgets, pas via le thème.
TextTheme _textThemeFrom(AppColors colors, Locale locale) => TextTheme(
  displayLarge: AppText.display(locale).copyWith(color: colors.textPrimary),
  headlineLarge: AppText.h1(locale).copyWith(color: colors.textPrimary),
  headlineMedium: AppText.h2(locale).copyWith(color: colors.textPrimary),
  headlineSmall: AppText.h3(locale).copyWith(color: colors.textPrimary),
  bodyLarge: AppText.bodyStrong(locale).copyWith(color: colors.textPrimary),
  bodyMedium: AppText.body(locale).copyWith(color: colors.textPrimary),
  bodySmall: AppText.small(locale).copyWith(color: colors.textSecondary),
  labelSmall: AppText.caption(locale).copyWith(color: colors.textMuted),
);
