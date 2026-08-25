import 'package:flutter/widgets.dart';
import 'package:sanaya/core/i18n/translations.g.dart';
import 'package:shared_preferences/shared_preferences.dart';

const _localeKey = 'sanaya.locale';

/// Locale à utiliser au démarrage : la préférence persistée si elle existe,
/// sinon la meilleure correspondance avec les locales du device (repli sur
/// `fr`, la base_locale, si aucune des locales du device n'est supportée) —
/// `AppLocaleUtils.findDeviceLocale()` (généré par slang) gère déjà ce repli.
Future<Locale> readInitialLocale() async {
  final prefs = await SharedPreferences.getInstance();
  final stored = prefs.getString(_localeKey);
  if (stored == 'fr' || stored == 'ar') {
    return Locale(stored!);
  }
  return AppLocaleUtils.findDeviceLocale().flutterLocale;
}

/// Persiste le choix de langue — appelé à chaque changement de
/// `localeProvider` (cf. lib/main.dart).
Future<void> persistLocale(Locale locale) async {
  final prefs = await SharedPreferences.getInstance();
  await prefs.setString(_localeKey, locale.languageCode);
}
