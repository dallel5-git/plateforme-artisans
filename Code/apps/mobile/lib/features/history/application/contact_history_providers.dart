import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sanaya/core/api/api_client_provider.dart';
import 'package:sanaya/features/history/data/contact_history_repository.dart';

final contactHistoryRepositoryProvider = Provider<ContactHistoryRepository>(
  (ref) => ContactHistoryRepository(ref.watch(contactEventsApiProvider)),
);

// ---------------------------------------------------------------------------
// Historique de contacts paginé — state object
// ---------------------------------------------------------------------------

/// État immutable de l'historique chargé + curseur de pagination. Même
/// forme que `ReviewsState` (`provider_profile_providers.dart`, BE-17) :
/// seule pagination par curseur réellement câblée dans l'app à ce jour.
class HistoryState {
  const HistoryState({
    required this.items,
    required this.nextCursor,
    required this.isLoadingMore,
  });

  final List<ContactHistoryItem> items;

  /// Curseur opaque. Chaîne vide = plus de pages (le modèle généré ne rend
  /// pas `String` nullable, on utilise la chaîne vide comme sentinel).
  final String nextCursor;

  /// true pendant le chargement de la page suivante (pas le chargement
  /// initial, géré par l'état `AsyncLoading` du notifier).
  final bool isLoadingMore;

  bool get hasMore => nextCursor.isNotEmpty;

  HistoryState copyWith({
    List<ContactHistoryItem>? items,
    String? nextCursor,
    bool? isLoadingMore,
  }) {
    return HistoryState(
      items: items ?? this.items,
      nextCursor: nextCursor ?? this.nextCursor,
      isLoadingMore: isLoadingMore ?? this.isLoadingMore,
    );
  }
}

// ---------------------------------------------------------------------------
// Historique de contacts paginé — notifier
// ---------------------------------------------------------------------------

/// Gère la liste d'historique paginée par curseur (BE-45 / FM-31 / P5).
///
/// - Page 1 chargée à [build] (état initial `AsyncLoading` -> `AsyncData`).
/// - [loadMore] charge la page suivante et accumule les items. Sans effet
///   si `isLoadingMore` est true ou s'il n'y a plus de pages.
/// - [refresh] recharge la page 1 (pull-to-refresh).
///
/// Pas de `.family` : contrairement aux avis d'une fiche artisan (par
/// `slug`), l'historique est celui du client authentifié — un seul état
/// possible par session.
class ContactHistoryNotifier extends AutoDisposeAsyncNotifier<HistoryState> {
  @override
  Future<HistoryState> build() async {
    final repo = ref.watch(contactHistoryRepositoryProvider);
    final page = await repo.fetchHistory();
    return HistoryState(
      items: page.items.toList(),
      nextCursor: page.nextCursor,
      isLoadingMore: false,
    );
  }

  /// Charge la page suivante si elle existe.
  Future<void> loadMore() async {
    final current = state.valueOrNull;
    if (current == null || current.isLoadingMore || !current.hasMore) return;

    state = AsyncData(current.copyWith(isLoadingMore: true));

    try {
      final repo = ref.read(contactHistoryRepositoryProvider);
      final page = await repo.fetchHistory(cursor: current.nextCursor);
      state = AsyncData(
        current.copyWith(
          items: [...current.items, ...page.items],
          nextCursor: page.nextCursor,
          isLoadingMore: false,
        ),
      );
    } on Object catch (e, st) {
      // Ne bascule pas en AsyncError pour conserver la liste déjà chargée.
      state = AsyncData(current.copyWith(isLoadingMore: false));
      Error.throwWithStackTrace(e, st);
    }
  }

  /// Recharge manuellement la liste depuis la page 1 (`RefreshIndicator`).
  Future<void> refresh() async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() async {
      final repo = ref.read(contactHistoryRepositoryProvider);
      final page = await repo.fetchHistory();
      return HistoryState(
        items: page.items.toList(),
        nextCursor: page.nextCursor,
        isLoadingMore: false,
      );
    });
  }
}

final AutoDisposeAsyncNotifierProvider<ContactHistoryNotifier, HistoryState>
contactHistoryProvider =
    AsyncNotifierProvider.autoDispose<ContactHistoryNotifier, HistoryState>(
      ContactHistoryNotifier.new,
    );
