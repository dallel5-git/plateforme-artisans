import 'package:sanaya/core/api/generated/api.dart';

/// Résolution intelligente de catégories et autocomplétion pour la recherche.
///
/// Permet de faire correspondre une saisie utilisateur (ex: « plomberie »,
/// « plombier », « fuite », « سباك ») à une catégorie du catalogue,
/// même en cas de fautes d'accents, casse différente ou synonymes métier.
class CategoryResolver {
  CategoryResolver._();

  static const Map<String, List<String>> _synonymsBySlug = {
    'plomberie': [
      'plomberie',
      'plombier',
      'plombiers',
      'fuite',
      'fuites',
      'robinet',
      'robinets',
      'robinetterie',
      'tuyau',
      'tuyaux',
      'chauffe-eau',
      'sanitaire',
      'sanitaires',
      'debouchage',
      'canalisation',
      'canalisations',
      'lavabo',
      'evier',
      'wc',
      'toilette',
      'toilettes',
      'baignoire',
      'douche',
      'سباكة',
      'سباك',
      'تسريب',
      'تسرب',
      'حنفيات',
      'حنفية',
      'سخان',
      'مرحاض',
      'بالوعة',
    ],
    'electricite': [
      'electricite',
      'electricien',
      'electriciens',
      'prise',
      'prises',
      'disjoncteur',
      'disjoncteurs',
      'tableau',
      'eclairage',
      'lumiere',
      'lumieres',
      'court-circuit',
      'cablage',
      'panne',
      'courant',
      'interrupteur',
      'ampoule',
      'كهرباء',
      'كهربائي',
      'انارة',
      'قاطع',
      'مأخذ',
      'سلك',
    ],
    'peinture': [
      'peinture',
      'peintre',
      'peintres',
      'peindre',
      'facade',
      'facades',
      'enduit',
      'mural',
      'decorateur',
      'decoration',
      'tapisserie',
      'papier peint',
      'دهانة',
      'دهان',
      'صباغ',
      'صباغة',
      'طلاء',
      'ديكور',
      'معجون',
    ],
    'menuiserie': [
      'menuiserie',
      'menuisier',
      'menuisiers',
      'bois',
      'porte',
      'portes',
      'fenetre',
      'fenetres',
      'meuble',
      'meubles',
      'placard',
      'placards',
      'aluminium',
      'alu',
      'dressing',
      'volet',
      'volets',
      'نجارة',
      'نجار',
      'خشب',
      'المنيوم',
      'ابواب',
      'باب',
      'نوافذ',
      'نافذة',
      'شباك',
      'اثاث',
    ],
    'climatisation': [
      'climatisation',
      'clim',
      'clims',
      'climatiseur',
      'climatiseurs',
      'frigoriste',
      'froid',
      'gaz',
      'recharge gaz',
      'chauffage',
      'ventilation',
      'مكيفات',
      'مكيف',
      'تكييف',
      'تبريد',
      'غاز',
    ],
    'serrurerie': [
      'serrurerie',
      'serrurier',
      'serruriers',
      'serrure',
      'serrures',
      'cle',
      'cles',
      'clef',
      'clefs',
      'verrou',
      'verrous',
      'blindage',
      'porte bloquee',
      'cylindre',
      'اقفال',
      'قفل',
      'مفتاح',
      'مفاتيح',
      'كالون',
    ],
  };

  /// Normalise une chaîne : minuscules, suppression diacritiques/accents
  /// et normalisation arabe basique (alef, taa marbuta, harakat).
  static String normalize(String input) {
    var s = input.trim().toLowerCase();
    // Diacritiques français
    s = s
        .replaceAll(RegExp('[àáâãäå]'), 'a')
        .replaceAll(RegExp('[ç]'), 'c')
        .replaceAll(RegExp('[èéêë]'), 'e')
        .replaceAll(RegExp('[ìíîï]'), 'i')
        .replaceAll(RegExp('[ñ]'), 'n')
        .replaceAll(RegExp('[òóôõö]'), 'o')
        .replaceAll(RegExp('[ùúûü]'), 'u')
        .replaceAll(RegExp('[ýÿ]'), 'y')
        .replaceAll(RegExp('[œ]'), 'oe')
        .replaceAll(RegExp('[æ]'), 'ae');

    // Lettres arabes et diacritiques
    s = s
        .replaceAll(RegExp('[إأآا]'), 'ا')
        .replaceAll(RegExp('[ة]'), 'ه')
        .replaceAll(RegExp('[ى]'), 'ي')
        .replaceAll(RegExp(r'[\u064B-\u065F]'), ''); // harakat / tashkeel

    return s;
  }

  /// Résout la catégorie la plus pertinente à partir d'une requête textuelle.
  ///
  /// Renvoie `null` si aucune catégorie correspondante n'a été détectée.
  static CategoryTreeNode? resolveCategory(
    String query,
    List<CategoryTreeNode> categories,
  ) {
    final normQuery = normalize(query);
    if (normQuery.isEmpty) return null;

    // 1. Correspondance exacte sur slug, nom FR ou nom AR
    for (final category in categories) {
      if (normalize(category.slug) == normQuery ||
          normalize(category.nameFr) == normQuery ||
          normalize(category.nameAr) == normQuery) {
        return category;
      }
    }

    // 2. Correspondance exacte sur le dictionnaire de synonymes
    for (final entry in _synonymsBySlug.entries) {
      final matchesSynonym = entry.value.any(
        (syn) => normalize(syn) == normQuery,
      );
      if (matchesSynonym) {
        final match = _findBySlug(categories, entry.key);
        if (match != null) return match;
      }
    }

    // 3. Décomposition par mots (pour les requêtes « artisan plombier », etc.)
    final words = normQuery
        .split(RegExp(r'[\s,\-_/]+'))
        .where((w) => w.length >= 3)
        .toList();

    for (final word in words) {
      // Vérification mot par mot dans les synonymes
      for (final entry in _synonymsBySlug.entries) {
        if (entry.value.any((syn) => normalize(syn) == word)) {
          final match = _findBySlug(categories, entry.key);
          if (match != null) return match;
        }
      }

      // Vérification mot par mot dans les noms de catégories
      for (final category in categories) {
        final normFr = normalize(category.nameFr);
        final normAr = normalize(category.nameAr);
        if (normFr.contains(word) || normAr.contains(word)) {
          return category;
        }
      }
    }

    // 4. Recherche par inclusion (sous-chaîne)
    if (normQuery.length >= 3) {
      for (final category in categories) {
        final normFr = normalize(category.nameFr);
        final normAr = normalize(category.nameAr);
        final normSlug = normalize(category.slug);
        if (normFr.contains(normQuery) ||
            normAr.contains(normQuery) ||
            normSlug.contains(normQuery) ||
            normQuery.contains(normFr) ||
            normQuery.contains(normAr)) {
          return category;
        }
      }
    }

    return null;
  }

  /// Retourne une liste ordonnée de suggestions de catégories
  /// pour l'autocomplétion.
  static List<CategoryTreeNode> getSuggestions(
    String query,
    List<CategoryTreeNode> categories, {
    int limit = 4,
  }) {
    final normQuery = normalize(query);
    if (normQuery.length < 2) return const [];

    final scored = <CategoryTreeNode, int>{};

    for (final category in categories) {
      final normFr = normalize(category.nameFr);
      final normAr = normalize(category.nameAr);
      final normSlug = normalize(category.slug);

      var score = 0;
      if (normFr == normQuery || normAr == normQuery || normSlug == normQuery) {
        score += 100;
      } else if (normFr.startsWith(normQuery) ||
          normAr.startsWith(normQuery) ||
          normSlug.startsWith(normQuery)) {
        score += 50;
      } else if (normFr.contains(normQuery) || normAr.contains(normQuery)) {
        score += 20;
      }

      // Score synonymes
      final synonyms = _synonymsBySlug[category.slug] ?? const [];
      for (final syn in synonyms) {
        final normSyn = normalize(syn);
        if (normSyn == normQuery) {
          score = score < 90 ? 90 : score;
        } else if (normSyn.startsWith(normQuery)) {
          score = score < 40 ? 40 : score;
        } else if (normSyn.contains(normQuery) && normQuery.length >= 3) {
          score = score < 15 ? 15 : score;
        }
      }

      if (score > 0) {
        scored[category] = score;
      }
    }

    final sorted = scored.keys.toList()
      ..sort((a, b) => scored[b]!.compareTo(scored[a]!));

    return sorted.take(limit).toList();
  }

  static CategoryTreeNode? _findBySlug(
    List<CategoryTreeNode> categories,
    String slug,
  ) {
    for (final c in categories) {
      if (c.slug == slug) return c;
    }
    return null;
  }
}
