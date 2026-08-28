import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:sanaya/core/api/generated/api.dart';
import 'package:sanaya/features/provider_profile/application/provider_profile_providers.dart';
import 'package:sanaya/features/provider_profile/application/review_submission_notifier.dart';
import 'package:sanaya/features/provider_profile/data/provider_profile_repository.dart';
import 'package:sanaya/features/provider_profile/data/reviews_repository.dart';

class _ReviewsRepositoryMock extends Mock implements ReviewsRepository {}

class _ProviderProfileRepositoryMock extends Mock
    implements ProviderProfileRepository {}

void main() {
  late _ReviewsRepositoryMock reviewsRepository;
  late _ProviderProfileRepositoryMock profileRepository;
  late ProviderContainer container;

  setUp(() {
    reviewsRepository = _ReviewsRepositoryMock();
    profileRepository = _ProviderProfileRepositoryMock();

    container = ProviderContainer(
      overrides: [
        reviewsRepositoryProvider.overrideWithValue(reviewsRepository),
        providerProfileRepositoryProvider.overrideWithValue(profileRepository),
      ],
    );
  });

  tearDown(() => container.dispose());

  group('ReviewSubmissionNotifier', () {
    test('état initial est AsyncData(null)', () {
      final state = container.read(reviewSubmissionProvider);
      expect(state, const AsyncData<void>(null));
    });

    test(
      'soumet un avis avec succès et invalide profil + liste avis (FM-10)',
      () async {
        final reviewDto = V1ProvidersIdReviewsPost200Response(
          (b) => b
            ..id = 'rev-1'
            ..rating = 5
            ..comment = 'Top pro !'
            ..isVerifiedContact = true
            ..createdAt = DateTime.utc(2026, 8, 28),
        );

        when(
          () => reviewsRepository.createReview(
            providerId: 'prov-1',
            rating: 5,
            comment: 'Top pro !',
          ),
        ).thenAnswer((_) async => reviewDto);

        final notifier = container.read(reviewSubmissionProvider.notifier);
        final success = await notifier.submitReview(
          providerId: 'prov-1',
          slug: 'sami-plombier',
          rating: 5,
          comment: 'Top pro !',
        );

        expect(success, isTrue);
        expect(
          container.read(reviewSubmissionProvider),
          const AsyncData<void>(null),
        );

        verify(
          () => reviewsRepository.createReview(
            providerId: 'prov-1',
            rating: 5,
            comment: 'Top pro !',
          ),
        ).called(1);
      },
    );

    test(
      'gère le rejet 403 (REVIEW_REQUIRES_CONTACT) et passe en AsyncError',
      () async {
        final forbiddenError = ForbiddenException(
          code: 'REVIEW_REQUIRES_CONTACT',
          message: 'Aucun contact éligible pour un avis',
        );

        when(
          () => reviewsRepository.createReview(
            providerId: 'prov-1',
            rating: 5,
            comment: any(named: 'comment'),
          ),
        ).thenThrow(forbiddenError);

        final notifier = container.read(reviewSubmissionProvider.notifier);
        final success = await notifier.submitReview(
          providerId: 'prov-1',
          slug: 'sami-plombier',
          rating: 5,
        );

        expect(success, isFalse);
        final state = container.read(reviewSubmissionProvider);
        expect(state, isA<AsyncError<void>>());
        expect((state as AsyncError<void>).error, forbiddenError);
      },
    );

    test('gère les erreurs réseau et passe en AsyncError', () async {
      final networkError = NetworkException();

      when(
        () => reviewsRepository.createReview(
          providerId: 'prov-2',
          rating: 4,
          comment: any(named: 'comment'),
        ),
      ).thenThrow(networkError);

      final notifier = container.read(reviewSubmissionProvider.notifier);
      final success = await notifier.submitReview(
        providerId: 'prov-2',
        slug: 'anis-electricien',
        rating: 4,
      );

      expect(success, isFalse);
      final state = container.read(reviewSubmissionProvider);
      expect(state, isA<AsyncError<void>>());
      expect((state as AsyncError<void>).error, networkError);
    });
  });
}
