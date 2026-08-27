// ⚠️ FICHIER GÉNÉRÉ — NE PAS ÉDITER À LA MAIN.
// Source : packages/design-tokens/tokens.json
// Régénérer : pnpm tokens:build
// ignore_for_file: constant_identifier_names

import 'package:flutter/material.dart';

/// Échelle typographique. `fontFamily` est choisi automatiquement selon la
/// locale active : Manrope en latin, Noto Kufi Arabic en arabe.
abstract final class AppText {
  static const latinFamily = 'Manrope';
  static const arabicFamily = 'Noto Kufi Arabic';

  static String familyFor(Locale locale) =>
      locale.languageCode == 'ar' ? arabicFamily : latinFamily;

  static TextStyle display(Locale locale) => TextStyle(
    fontFamily: familyFor(locale),
    fontSize: 36.0,
    height: 1.167,
    fontWeight: FontWeight.w800,
  );

  static TextStyle h1(Locale locale) => TextStyle(
    fontFamily: familyFor(locale),
    fontSize: 28.0,
    height: 1.214,
    fontWeight: FontWeight.w800,
  );

  static TextStyle h2(Locale locale) => TextStyle(
    fontFamily: familyFor(locale),
    fontSize: 22.0,
    height: 1.273,
    fontWeight: FontWeight.w700,
  );

  static TextStyle h3(Locale locale) => TextStyle(
    fontFamily: familyFor(locale),
    fontSize: 18.0,
    height: 1.333,
    fontWeight: FontWeight.w700,
  );

  static TextStyle body(Locale locale) => TextStyle(
    fontFamily: familyFor(locale),
    fontSize: 15.0,
    height: 1.467,
    fontWeight: FontWeight.w400,
  );

  static TextStyle bodyStrong(Locale locale) => TextStyle(
    fontFamily: familyFor(locale),
    fontSize: 15.0,
    height: 1.467,
    fontWeight: FontWeight.w600,
  );

  static TextStyle small(Locale locale) => TextStyle(
    fontFamily: familyFor(locale),
    fontSize: 13.0,
    height: 1.385,
    fontWeight: FontWeight.w400,
  );

  static TextStyle caption(Locale locale) => TextStyle(
    fontFamily: familyFor(locale),
    fontSize: 11.0,
    height: 1.273,
    fontWeight: FontWeight.w600,
  );
}
