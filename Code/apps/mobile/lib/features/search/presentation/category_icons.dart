import 'package:flutter/material.dart';

/// Correspondance `iconKey` (slug de catégorie — `packages/db/prisma/seed/
/// categories.ts`) → icône Material. Aucune convention d'icônes n'existe
/// encore côté backend (voir commentaire du seed) : cette table est un
/// choix de présentation propre à l'écran d'accueil, pas une règle métier
/// (P3). Une catégorie inconnue retombe sur [_fallback] plutôt que de
/// planter — le référentiel catégories peut évoluer sans redéploiement
/// mobile immédiat.
const IconData _fallback = Icons.handyman_outlined;

const Map<String, IconData> _categoryIcons = {
  'plomberie': Icons.plumbing_outlined,
  'electricite': Icons.bolt_outlined,
  'peinture': Icons.format_paint_outlined,
  'climatisation': Icons.ac_unit_outlined,
  'menuiserie': Icons.carpenter_outlined,
  'maconnerie': Icons.foundation_outlined,
  'serrurerie': Icons.key_outlined,
  'jardinage': Icons.yard_outlined,
  'nettoyage': Icons.cleaning_services_outlined,
};

IconData categoryIconFor(String iconKey) =>
    _categoryIcons[iconKey] ?? _fallback;
