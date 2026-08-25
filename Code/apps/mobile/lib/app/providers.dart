import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:sanaya/core/i18n/translations.g.dart';

/// Locale active — pilote AppText.familyFor()/Directionality (au niveau de
/// MaterialApp, cf. apps/mobile/CLAUDE.md). Valeur initiale réelle injectée
/// via overrideWith dans main() (préférence persistée ou locale du device,
/// cf. lib/core/i18n/locale_persistence.dart) ; ce défaut ne sert qu'aux
/// contextes sans override (tests unitaires isolés).
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
