import 'package:flutter/foundation.dart';

/// Paramètres de filtrage de la recherche (FM-28), reflet direct des query
/// params acceptés par `GET /v1/providers/search` — pas de champ
/// urgence/`acceptsEmergency`, non filtrable côté serveur (issue #225).
@immutable
class SearchFilters {
  const SearchFilters({
    required this.governorateId,
    this.categorySlug,
    this.delegationId,
    this.isVerified,
    this.minRating,
  });

  final String governorateId;
  final String? categorySlug;
  final String? delegationId;
  final bool? isVerified;
  final num? minRating;

  /// Clé stable et déterministe (paires triées alphabétiquement, un champ
  /// absent est simplement omis) — sert à la fois de clé de cache disque
  /// (`SearchResultsCache`) et d'entrée reproductible en test.
  String get cacheKey {
    final parts = <String>[
      'governorate=$governorateId',
      if (categorySlug != null) 'category=$categorySlug',
      if (delegationId != null) 'delegation=$delegationId',
      if (isVerified != null) 'verified=$isVerified',
      if (minRating != null) 'minRating=$minRating',
    ]..sort();
    return parts.join('&');
  }

  /// Valeur-égalité sur `cacheKey` (FM-28c) : clé de famille Riverpod pour
  /// `SearchResultsNotifier`, construite au runtime depuis les sélections de
  /// l'écran — jamais `const`, donc jamais canonicalisée par le compilateur.
  /// Sans ceci, deux instances portant les mêmes filtres seraient traitées
  /// comme des familles distinctes (identité par défaut), multipliant les
  /// appels réseau et les entrées de cache pour un seul jeu de filtres.
  @override
  bool operator ==(Object other) =>
      other is SearchFilters && other.cacheKey == cacheKey;

  @override
  int get hashCode => cacheKey.hashCode;
}
