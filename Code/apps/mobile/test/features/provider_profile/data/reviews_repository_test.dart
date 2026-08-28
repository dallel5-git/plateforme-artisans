import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:sanaya/core/api/generated/api.dart';
import 'package:sanaya/features/provider_profile/data/reviews_repository.dart';

class _DefaultApiMock extends Mock implements DefaultApi {}

class _V1ProvidersIdReviewsPostRequestFake extends Fake
    implements V1ProvidersIdReviewsPostRequest {}

Response<T> _okResponse<T>(String path, T data) => Response<T>(
  requestOptions: RequestOptions(path: path),
  statusCode: 200,
  data: data,
);

void main() {
  setUpAll(() {
    registerFallbackValue(_V1ProvidersIdReviewsPostRequestFake());
  });

  late _DefaultApiMock api;
  late ReviewsRepository repository;

  setUp(() {
    api = _DefaultApiMock();
    repository = ReviewsRepository(api);
  });

  group('ReviewsRepository.createReview', () {
    test(
      'dépose un avis avec note et commentaire via POST /v1/providers/:id/reviews',
      () async {
        final responseDto = V1ProvidersIdReviewsPost200Response(
          (b) => b
            ..id = 'rev-1'
            ..rating = 5
            ..comment = 'Excellent travail rapide et propre !'
            ..isVerifiedContact = true
            ..createdAt = DateTime.utc(2026, 8, 28),
        );

        when(
          () => api.v1ProvidersIdReviewsPost(
            id: 'prov-1',
            v1ProvidersIdReviewsPostRequest: any(
              named: 'v1ProvidersIdReviewsPostRequest',
            ),
          ),
        ).thenAnswer(
          (_) async => _okResponse('/v1/providers/prov-1/reviews', responseDto),
        );

        final result = await repository.createReview(
          providerId: 'prov-1',
          rating: 5,
          comment: 'Excellent travail rapide et propre !',
        );

        expect(result.id, 'rev-1');
        expect(result.rating, 5);
        expect(result.comment, 'Excellent travail rapide et propre !');
        expect(result.isVerifiedContact, isTrue);

        final captured = verify(
          () => api.v1ProvidersIdReviewsPost(
            id: 'prov-1',
            v1ProvidersIdReviewsPostRequest: captureAny(
              named: 'v1ProvidersIdReviewsPostRequest',
            ),
          ),
        ).captured;

        final request = captured.first as V1ProvidersIdReviewsPostRequest;
        expect(request.rating, 5);
        expect(request.comment, 'Excellent travail rapide et propre !');
      },
    );

    test('dépose un avis avec note seule (sans commentaire)', () async {
      final responseDto = V1ProvidersIdReviewsPost200Response(
        (b) => b
          ..id = 'rev-2'
          ..rating = 4
          ..comment = ''
          ..isVerifiedContact = true
          ..createdAt = DateTime.utc(2026, 8, 28),
      );

      when(
        () => api.v1ProvidersIdReviewsPost(
          id: 'prov-2',
          v1ProvidersIdReviewsPostRequest: any(
            named: 'v1ProvidersIdReviewsPostRequest',
          ),
        ),
      ).thenAnswer(
        (_) async => _okResponse('/v1/providers/prov-2/reviews', responseDto),
      );

      final result = await repository.createReview(
        providerId: 'prov-2',
        rating: 4,
      );

      expect(result.id, 'rev-2');
      expect(result.rating, 4);

      final captured = verify(
        () => api.v1ProvidersIdReviewsPost(
          id: 'prov-2',
          v1ProvidersIdReviewsPostRequest: captureAny(
            named: 'v1ProvidersIdReviewsPostRequest',
          ),
        ),
      ).captured;

      final request = captured.first as V1ProvidersIdReviewsPostRequest;
      expect(request.rating, 4);
      expect(request.comment, isNull);
    });

    test("propage l'exception typée ForbiddenException sur 403", () async {
      when(
        () => api.v1ProvidersIdReviewsPost(
          id: 'prov-3',
          v1ProvidersIdReviewsPostRequest: any(
            named: 'v1ProvidersIdReviewsPostRequest',
          ),
        ),
      ).thenThrow(
        DioException(
          requestOptions: RequestOptions(path: '/v1/providers/prov-3/reviews'),
          error: ForbiddenException(
            code: 'REVIEW_REQUIRES_CONTACT',
            message: 'Aucun contact éligible pour un avis',
          ),
        ),
      );

      expect(
        () => repository.createReview(providerId: 'prov-3', rating: 5),
        throwsA(
          isA<ForbiddenException>().having(
            (e) => e.code,
            'code',
            'REVIEW_REQUIRES_CONTACT',
          ),
        ),
      );
    });
  });
}
