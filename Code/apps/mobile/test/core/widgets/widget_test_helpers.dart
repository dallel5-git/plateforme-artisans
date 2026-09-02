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
  TextScaler? textScaler,
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
    // FM-17b : point d'injection recommandé par Flutter pour forcer un
    // textScaler en test — un MediaQuery posé hors de MaterialApp serait
    // écrasé par celui que WidgetsApp construit lui-même.
    builder: textScaler == null
        ? null
        : (context, child) => MediaQuery(
            data: MediaQuery.of(context).copyWith(textScaler: textScaler),
            child: child!,
          ),
    home: child,
  );
}
