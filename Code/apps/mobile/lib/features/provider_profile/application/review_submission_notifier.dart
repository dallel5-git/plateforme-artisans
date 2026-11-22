import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sanaya/core/api/api_client_provider.dart';
import 'package:sanaya/features/history/application/contact_history_providers.dart';
import 'package:sanaya/features/provider_profile/application/provider_profile_providers.dart';
import 'package:sanaya/features/provider_profile/data/reviews_repository.dart';

/// Provider pour [ReviewsRepository].
final Provider<ReviewsRepository> reviewsRepositoryProvider =
    Provider<ReviewsRepository>(
      (ref) => ReviewsRepository(ref.watch(defaultApiProvider)),
    );

/// Gère l'état asynchrone de la soumission d'un avis (FM-10).
///
/// Après un dépôt réussi, invalide immédiatement le profil
/// (`providerProfileProvider`), la liste d'avis (`providerReviewsProvider`)
/// et l'historique (`contactHistoryProvider`) pour mettre à jour la note
/// moyenne (US-C-07) et l'état de l'avis dans l'historique.
class ReviewSubmissionNotifier extends AutoDisposeNotifier<AsyncValue<void>> {
  @override
  AsyncValue<void> build() => const AsyncData<void>(null);

  /// Tente de soumettre un avis pour l'artisan [providerId] identifié par
  /// [slug].
  ///
  /// Retourne `true` si le dépôt a réussi, `false` en cas d'erreur.
  Future<bool> submitReview({
    required String providerId,
    required String slug,
    required int rating,
    String? comment,
  }) async {
    state = const AsyncLoading<void>();

    try {
      final repository = ref.read(reviewsRepositoryProvider);
      await repository.createReview(
        providerId: providerId,
        rating: rating,
        comment: comment,
      );

      // Invalidation réactive immédiate de la note moyenne, des avis (FM-10)
      // et de l'historique de contacts (FM-31).
      ref
        ..invalidate(providerProfileProvider(slug))
        ..invalidate(providerReviewsProvider(slug))
        ..invalidate(contactHistoryProvider);

      state = const AsyncData<void>(null);
      return true;
    } on Object catch (e, st) {

      state = AsyncError<void>(e, st);
      return false;
    }
  }
}

/// Provider pour [ReviewSubmissionNotifier].
final AutoDisposeNotifierProvider<ReviewSubmissionNotifier, AsyncValue<void>>
reviewSubmissionProvider =
    NotifierProvider.autoDispose<ReviewSubmissionNotifier, AsyncValue<void>>(
      ReviewSubmissionNotifier.new,
    );
