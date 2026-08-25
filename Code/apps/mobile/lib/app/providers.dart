import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// FM-01 : tient la locale active pour AppText.familyFor()/Directionality
/// (pilotée au niveau de MaterialApp, cf. apps/mobile/CLAUDE.md). Persistance
/// (SharedPreferences) et détection de la locale OS : FM-03.
final localeProvider = StateProvider<Locale>((ref) => const Locale('fr'));

/// Bascule manuelle pour vérifier le thème sombre en revue, sans dépendre
/// des réglages système de l'émulateur/device.
final themeModeProvider = StateProvider<ThemeMode>((ref) => ThemeMode.system);
