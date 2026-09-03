import 'package:flutter/material.dart';

import 'package:sanaya/core/theme/app_colors.dart';

/// Écran de démarrage — affiché tant que `authStateProvider` n'a pas résolu
/// la restauration de session (FM-23). Volontairement minimal, sans logo
/// (asset de marque hors périmètre) : ne lit ni ne redirige lui-même,
/// `redirect:` (`router.dart`) est l'unique source de vérité de navigation.
class SplashScreen extends StatelessWidget {
  const SplashScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: context.colors.background,
      body: const Center(child: CircularProgressIndicator()),
    );
  }
}
