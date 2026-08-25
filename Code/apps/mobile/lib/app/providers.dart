import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:sanaya/core/i18n/translations.g.dart';

/// FM-01 : tient la locale active pour AppText.familyFor()/Directionality
/// (pilotée au niveau de MaterialApp, cf. apps/mobile/CLAUDE.md). Persistance
/// (SharedPreferences) et détection de la locale OS : FM-03b.
final localeProvider = StateProvider<Locale>((ref) => const Locale('fr'));

/// Bascule manuelle pour vérifier le thème sombre en revue, sans dépendre
/// des réglages système de l'émulateur/device.
final themeModeProvider = StateProvider<ThemeMode>((ref) => ThemeMode.system);

/// Instance de traductions pour la locale active. `localeProvider` reste
/// l'unique source de vérité — on n'utilise pas le LocaleSettings/
/// TranslationProvider intégré de slang (locale_handling: false dans
/// slang.yaml), qui créerait un second état concurrent.
final translationsProvider = Provider<Translations>((ref) {
  final locale = ref.watch(localeProvider);
  return locale.languageCode == 'ar'
      ? AppLocale.ar.buildSync()
      : AppLocale.fr.buildSync();
});
