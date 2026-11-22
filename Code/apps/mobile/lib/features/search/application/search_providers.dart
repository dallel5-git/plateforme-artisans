import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sanaya/core/api/api_client_provider.dart';
import 'package:sanaya/features/search/data/search_filters.dart';
import 'package:sanaya/features/search/data/search_repository.dart';
import 'package:sanaya/features/search/data/search_results_cache.dart';

final searchRepositoryProvider = Provider<SearchRepository>(
  (ref) => SearchRepository(ref.watch(defaultApiProvider)),
);

final searchResultsCacheProvider = Provider<SearchResultsCache>(
  (ref) => SearchResultsCache.withDefaultBox(),
);

// ---------------------------------------------------------------------------
// Résultats de recherche paginés, par jeu de filtres — state object
// ---------------------------------------------------------------------------

/// État immutable des résultats chargés + curseur de pagination. Même forme
/// que `ReviewsState`/`HistoryState` (`provider_profile_providers.dart`,
/// `contact_history_providers.dart`).
class SearchResultsState {
  const SearchResultsState({
    required this.items,
    required this.nextCursor,
    required this.isLoadingMore,
  });

  final List<SearchResultItem> items;

  /// Curseur opaque. Chaîne vide = plus de pages (le modèle généré ne rend
  /// pas `String` nullable, on utilise la chaîne vide comme sentinel).
  final String nextCursor;

  /// true pendant le chargement de la page suivante (pas le chargement
  /// initial, géré par l'état `AsyncLoading` du notifier).
  final bool isLoadingMore;

  bool get hasMore => nextCursor.isNotEmpty;

  SearchResultsState copyWith({
    List<SearchResultItem>? items,
    String? nextCursor,
    bool? isLoadingMore,
  }) {
    return SearchResultsState(
      items: items ?? this.items,
      nextCursor: nextCursor ?? this.nextCursor,
      isLoadingMore: isLoadingMore ?? this.isLoadingMore,
    );
  }
}

SearchResultsState _stateFromPage(SearchResultsPage page, [String? query]) {
  var items = page.items.toList();
  if (query != null && query.trim().isNotEmpty) {
    final q = query.trim().toLowerCase();
    items = items.where((item) {
      final bName = item.businessName.toLowerCase();
      final headline = item.headline.toLowerCase();
      final matchCat = item.categories.any((c) {
        return c.nameFr.toLowerCase().contains(q) ||
            c.nameAr.toLowerCase().contains(q) ||
            c.slug.toLowerCase().contains(q);
      });
      return bName.contains(q) || headline.contains(q) || matchCat;
    }).toList();
  }
  return SearchResultsState(
    items: items,
    nextCursor: page.nextCursor,
    isLoadingMore: false,
  );
}

// ---------------------------------------------------------------------------
// Résultats de recherche paginés — notifier
// ---------------------------------------------------------------------------

/// Gère la première page de résultats par jeu de filtres + la pagination par
/// curseur (FM-28c / P5).
///
/// - Page 1 chargée à [build] : réseau d'abord, écriture en cache disque de
///   cette première page (`SearchResultsCache`) après chaque succès. Sur
///   échec réseau, sert la dernière page 1 en cache pour ce même jeu de
///   filtres au lieu d'un écran d'erreur — décision de fraîcheur laissée au
///   notifier, comme documenté dans `SearchRepository`/`SearchResultsCache`.
///   Si le cache est vide aussi, l'erreur d'origine remonte (`AsyncError`).
/// - [loadMore] charge la page suivante et accumule les résultats en mémoire
///   uniquement — seule la page 1 survit à un redémarrage de l'app, par
///   design (voir `SearchResultsCache`).
/// - [refresh] recharge la page 1 (pull-to-refresh), même repli sur cache
///   que [build].
///
/// `.family<SearchFilters>` : un jeu de filtres différent est un état
/// entièrement différent, jamais un patch du précédent. Repose sur l'égalité
/// de valeur ajoutée à `SearchFilters` (FM-28c) — sans elle, deux instances
/// portant les mêmes filtres seraient traitées comme des familles distinctes.
class SearchResultsNotifier
    extends AutoDisposeFamilyAsyncNotifier<SearchResultsState, SearchFilters> {
  @override
  Future<SearchResultsState> build(SearchFilters filters) async {
    final repo = ref.watch(searchRepositoryProvider);
    final cache = ref.watch(searchResultsCacheProvider);
    return _loadFirstPage(repo, cache, filters);
  }

  /// Charge la page suivante si elle existe. Sans effet si `isLoadingMore`
  /// est déjà true ou s'il n'y a plus de pages.
  Future<void> loadMore() async {
    final current = state.valueOrNull;
    if (current == null || current.isLoadingMore || !current.hasMore) return;

    state = AsyncData(current.copyWith(isLoadingMore: true));

    try {
      final repo = ref.read(searchRepositoryProvider);
      final page = await repo.search(arg, cursor: current.nextCursor);
      final newItems = _stateFromPage(page, arg.query).items;
      state = AsyncData(
        current.copyWith(
          items: [...current.items, ...newItems],
          nextCursor: page.nextCursor,
          isLoadingMore: false,
        ),
      );
    } on Object catch (e, st) {
      // Ne bascule pas en AsyncError pour conserver les résultats déjà
      // chargés — seule la page 1 a un repli cache, les pages suivantes
      // n'existent qu'en session (cf. docstring de la classe).
      state = AsyncData(current.copyWith(isLoadingMore: false));
      Error.throwWithStackTrace(e, st);
    }
  }

  /// Recharge manuellement la page 1 depuis le réseau (`RefreshIndicator`),
  /// même repli sur cache que [build] en cas d'échec.
  Future<void> refresh() async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() {
      final repo = ref.read(searchRepositoryProvider);
      final cache = ref.read(searchResultsCacheProvider);
      return _loadFirstPage(repo, cache, arg);
    });
  }

  Future<SearchResultsState> _loadFirstPage(
    SearchRepository repo,
    SearchResultsCache cache,
    SearchFilters filters,
  ) async {
    try {
      final page = await repo.search(filters);
      unawaited(cache.writeFirstPage(filters, page));
      return _stateFromPage(page, filters.query);
    } on Object catch (error, stackTrace) {
      final cached = await cache.readFirstPage(filters);
      if (cached != null) return _stateFromPage(cached, filters.query);
      Error.throwWithStackTrace(error, stackTrace);
    }
  }
}

final AutoDisposeAsyncNotifierProviderFamily<
  SearchResultsNotifier,
  SearchResultsState,
  SearchFilters
>
searchResultsProvider = AsyncNotifierProvider.autoDispose
    .family<SearchResultsNotifier, SearchResultsState, SearchFilters>(
      SearchResultsNotifier.new,
    );
