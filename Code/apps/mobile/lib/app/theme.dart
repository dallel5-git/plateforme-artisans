import 'package:flutter/material.dart';

import 'package:sanaya/core/theme/app_colors.dart';
import 'package:sanaya/core/theme/app_elevation.dart';
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
  );
}

// AppSpacing/AppRadius n'ont pas d'équivalent dans ThemeData (Flutter n'a
// pas de notion de padding par défaut) — consommés directement par les
// widgets, pas via le thème.
//
// AppText n'expose que 9 paliers (FM-15f), pas les 15 du TextTheme M3.
// Plusieurs paliers M3 réutilisent donc le même style AppText — assumé,
// pas un oubli : ajouter un nouveau palier de typographie serait hors
// périmètre FM-16 (générateur de tokens, pas consommation). La taille
// reste strictement décroissante de *Large à *Small dans chaque famille M3.
TextTheme _textThemeFrom(AppColors colors, Locale locale) => TextTheme(
  displayLarge: AppText.display(locale).copyWith(color: colors.textPrimary),
  displayMedium: AppText.h1(locale).copyWith(color: colors.textPrimary),
  displaySmall: AppText.h2(locale).copyWith(color: colors.textPrimary),
  headlineLarge: AppText.h1(locale).copyWith(color: colors.textPrimary),
  headlineMedium: AppText.h2(locale).copyWith(color: colors.textPrimary),
  headlineSmall: AppText.h3(locale).copyWith(color: colors.textPrimary),
  titleLarge: AppText.subtitle(locale).copyWith(color: colors.textPrimary),
  titleMedium: AppText.subtitle(locale).copyWith(color: colors.textPrimary),
  titleSmall: AppText.bodyStrong(locale).copyWith(color: colors.textPrimary),
  bodyLarge: AppText.bodyStrong(locale).copyWith(color: colors.textPrimary),
  bodyMedium: AppText.body(locale).copyWith(color: colors.textPrimary),
  bodySmall: AppText.small(locale).copyWith(color: colors.textSecondary),
  labelLarge: AppText.bodyStrong(locale).copyWith(color: colors.textPrimary),
  labelMedium: AppText.small(locale).copyWith(color: colors.textSecondary),
  labelSmall: AppText.caption(locale).copyWith(color: colors.textMuted),
);
