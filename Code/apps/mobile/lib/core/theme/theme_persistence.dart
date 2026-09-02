import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

const _themeModeKey = 'sanaya.theme_mode';

/// Thème à utiliser au démarrage : la préférence persistée si elle existe,
/// sinon `ThemeMode.system` (comportement par défaut de `themeModeProvider`
/// avant FM-17 — aucune régression si rien n'est encore persisté).
Future<ThemeMode> readInitialThemeMode() async {
  final prefs = await SharedPreferences.getInstance();
  final stored = prefs.getString(_themeModeKey);
  return ThemeMode.values.firstWhere(
    (mode) => mode.name == stored,
    orElse: () => ThemeMode.system,
  );
}

/// Persiste le choix de thème — appelé à chaque changement de
/// `themeModeProvider` (cf. lib/main.dart).
Future<void> persistThemeMode(ThemeMode mode) async {
  final prefs = await SharedPreferences.getInstance();
  await prefs.setString(_themeModeKey, mode.name);
}
