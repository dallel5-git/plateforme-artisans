import 'package:built_value/serializer.dart';
import 'package:sanaya/core/api/generated/api.dart';
import 'package:sanaya/core/cache/disk_cache.dart';
import 'package:sanaya/features/search/data/search_filters.dart';
import 'package:sanaya/features/search/data/search_repository.dart';

/// Cache disque de la PREMIÈRE page de résultats par jeu de filtres (FM-28) :
/// seule la page déjà visible à l'écran doit rester consultable en mode
/// avion — les pages suivantes chargées en session restent en mémoire côté
/// notifier (FM-28c), elles ne survivent pas à un redémarrage de l'app.
/// Aucun TTL ici volontairement : la fraîcheur (ignorer le cache si en
/// ligne, le servir tel quel si hors ligne) est une décision de l'appelant,
/// pas de ce cache — même principe que `DiskCache`.
///
/// Sérialise via `standardSerializers` (généré, déjà utilisé en interne par
/// le client Dio et par `OnboardingRepository`) — pas de modèle parallèle
/// écrit à la main (P4).
class SearchResultsCache {
  SearchResultsCache(this._disk);

  SearchResultsCache.withDefaultBox() : _disk = DiskCache(_boxName);

  static const _boxName = 'sanaya.search_results_cache';

  final DiskCache _disk;

  Future<SearchResultsPage?> readFirstPage(SearchFilters filters) async {
    final json = await _disk.read(filters.cacheKey);
    if (json == null) return null;
    return standardSerializers.deserialize(
          json,
          specifiedType: const FullType(SearchResultsPage),
        )
        as SearchResultsPage?;
  }

  Future<void> writeFirstPage(
    SearchFilters filters,
    SearchResultsPage page,
  ) async {
    final json = standardSerializers.serialize(
      page,
      specifiedType: const FullType(SearchResultsPage),
    );
    await _disk.write(filters.cacheKey, json! as Map<String, dynamic>);
  }
}
