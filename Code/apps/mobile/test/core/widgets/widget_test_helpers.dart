import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

import 'package:sanaya/app/theme.dart';

/// Enrobe [child] dans un `MaterialApp` qui reproduit la configuration réelle
/// de `SanayaApp` (délégués de localisation, thème généré depuis les
/// tokens) — nécessaire pour tout widget qui lit `context.colors`
/// (`ThemeExtension<AppColors>`, absent du thème par défaut de
/// `MaterialApp`) ou `Localizations.localeOf(context)`.
Widget themedApp(
  Widget child, {
  Brightness brightness = Brightness.light,
  Locale locale = const Locale('fr'),
}) {
  return MaterialApp(
    locale: locale,
    supportedLocales: const [Locale('fr'), Locale('ar')],
    localizationsDelegates: const [
      GlobalMaterialLocalizations.delegate,
      GlobalWidgetsLocalizations.delegate,
      GlobalCupertinoLocalizations.delegate,
    ],
    theme: buildTheme(brightness: brightness, locale: locale),
    home: child,
  );
}
