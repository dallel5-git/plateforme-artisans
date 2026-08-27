import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sanaya/core/api/api_client_provider.dart';
import 'package:sanaya/features/provider_profile/data/provider_profile_repository.dart';

final Provider<ProviderProfileRepository> providerProfileRepositoryProvider =
    Provider<ProviderProfileRepository>(
      (ref) => ProviderProfileRepository(ref.watch(defaultApiProvider)),
    );

// ---------------------------------------------------------------------------
// Fiche artisan (profil complet)
// ---------------------------------------------------------------------------

/// Fiche artisan publique — état serveur géré par FutureProvider.family :
/// loading/error/data gratuits, aucun setState (règle mobile CLAUDE.md §5).
/// autoDispose libère la mémoire dès que l'écran quitte la navigation.
final AutoDisposeFutureProviderFamily<ProviderProfile, String>
providerProfileProvider = FutureProvider.autoDispose
    .family<ProviderProfile, String>(
      (ref, slug) =>
          ref.watch(providerProfileRepositoryProvider).fetchProfile(slug),
    );

// ---------------------------------------------------------------------------
// Avis paginés — state object
// ---------------------------------------------------------------------------

/// État immutable des avis chargés + curseur de pagination.
class ReviewsState {
  const ReviewsState({
    required this.reviews,
    required this.nextCursor,
    required this.isLoadingMore,
  });

  final List<ProviderReview> reviews;

  /// Curseur opaque. Chaîne vide = plus de pages (le modèle généré
  /// ne rend pas String nullable, on utilise la chaîne vide comme sentinel).
  final String nextCursor;

  /// true pendant le chargement de la page suivante (pas le chargement
  /// initial, géré par l'état AsyncLoading du notifier).
  final bool isLoadingMore;

  bool get hasMore => nextCursor.isNotEmpty;

  ReviewsState copyWith({
    List<ProviderReview>? reviews,
    String? nextCursor,
    bool? isLoadingMore,
  }) {
    return ReviewsState(
      reviews: reviews ?? this.reviews,
      nextCursor: nextCursor ?? this.nextCursor,
      isLoadingMore: isLoadingMore ?? this.isLoadingMore,
    );
  }
}

// ---------------------------------------------------------------------------
// Avis paginés — notifier
// ---------------------------------------------------------------------------

/// Gère la liste d'avis paginée par curseur (BE-17 / P5).
///
/// - Page 1 chargée à [build] (état initial AsyncLoading -> AsyncData).
/// - [loadMore] charge la page suivante et accumule les avis.
///   Sans effet si isLoadingMore est true ou s'il n'y a plus de pages.
class ProviderReviewsNotifier
    extends AutoDisposeFamilyAsyncNotifier<ReviewsState, String> {
  @override
  Future<ReviewsState> build(String slug) async {
    final repo = ref.watch(providerProfileRepositoryProvider);
    final page = await repo.fetchReviews(slug);
    return ReviewsState(
      reviews: page.items.toList(),
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
      final repo = ref.read(providerProfileRepositoryProvider);
      final page = await repo.fetchReviews(arg, cursor: current.nextCursor);
      state = AsyncData(
        current.copyWith(
          reviews: [...current.reviews, ...page.items],
          nextCursor: page.nextCursor,
          isLoadingMore: false,
        ),
      );
    } on Object catch (e, st) {
      // Ne bascule pas en AsyncError pour conserver la liste existante.
      state = AsyncData(current.copyWith(isLoadingMore: false));
      Error.throwWithStackTrace(e, st);
    }
  }
}

final AutoDisposeAsyncNotifierProviderFamily<
  ProviderReviewsNotifier,
  ReviewsState,
  String
>
providerReviewsProvider = AsyncNotifierProvider.autoDispose
    .family<ProviderReviewsNotifier, ReviewsState, String>(
      ProviderReviewsNotifier.new,
    );
