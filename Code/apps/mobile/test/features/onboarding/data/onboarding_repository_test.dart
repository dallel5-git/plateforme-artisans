import 'package:built_collection/built_collection.dart';
import 'package:built_value/json_object.dart';
import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:sanaya/core/api/generated/api.dart';
import 'package:sanaya/features/onboarding/data/onboarding_repository.dart';

class _ApiMock extends Mock implements DefaultApi {}

OnboardingProfile _provider({int completionScore = 54}) {
  return OnboardingProfile(
    (b) => b
      ..id = 'prov-1'
      ..slug = 'ahmed-plomberie'
      ..businessName = 'Ahmed Plomberie'
      ..headline = ''
      ..bio = ''
      ..yearsExperience = 0
      ..whatsappPhone = ''
      ..publicPhone = ''
      ..baseGovernorateId = 'gov-1'
      ..baseDelegationId = 'del-1'
      ..latitude = 0
      ..longitude = 0
      ..publicationStatus =
          V1ProvidersMePost200ResponseProviderPublicationStatusEnum.DRAFT
      ..availabilityStatus =
          V1ProvidersMePost200ResponseProviderAvailabilityStatusEnum.AVAILABLE
      ..availableAgainAt = DateTime.utc(2026)
      ..acceptsEmergency = false
      ..workingHours = JsonObject(<String, dynamic>{})
      ..isVerified = false
      ..verifiedAt = DateTime.utc(2026)
      ..ratingAvg = 0
      ..ratingCount = 0
      ..totalProfileViews = 0
      ..totalContacts = 0
      ..completionScore = completionScore
      ..rankingScore = 0
      ..lastActiveAt = DateTime.utc(2026)
      ..createdAt = DateTime.utc(2026)
      ..updatedAt = DateTime.utc(2026),
  );
}

Response<T> _ok<T>(T data) => Response<T>(
  data: data,
  requestOptions: RequestOptions(path: '/v1/test'),
);

DioException _forbiddenIncomplete({int completionScore = 54}) {
  final options = RequestOptions(path: '/v1/providers/me');
  final response = Response<Object>(
    requestOptions: options,
    statusCode: 403,
    data: {
      'error': {
        'code': 'PROVIDER_PROFILE_INCOMPLETE',
        'message': 'Complétude insuffisante',
        'details': {
          'completionScore': completionScore,
          'missingFields': ['bio', 'coverageAreas'],
        },
      },
    },
  );
  return DioException(
    requestOptions: options,
    type: DioExceptionType.badResponse,
    response: response,
    error: ForbiddenException(
      code: 'PROVIDER_PROFILE_INCOMPLETE',
      message: 'Complétude insuffisante',
      details: {
        'completionScore': completionScore,
        'missingFields': ['bio', 'coverageAreas'],
      },
    ),
  );
}

void main() {
  late _ApiMock api;
  late OnboardingRepository repository;

  setUpAll(() {
    registerFallbackValue(
      V1ProvidersMePostRequest(
        (b) => b
          ..businessName = 'x'
          ..baseGovernorateId = 'g',
      ),
    );
    registerFallbackValue(V1ProvidersMePatchRequest((b) => b));
    registerFallbackValue(V1ProvidersMeCategoriesPutRequest((b) => b));
    registerFallbackValue(V1ProvidersMeCoverageAreasPutRequest((b) => b));
  });

  setUp(() {
    api = _ApiMock();
    repository = OnboardingRepository(api);
  });

  group('createProfile', () {
    test(
      'envoie businessName/baseGovernorateId requis et renvoie tokens+provider',
      () async {
        final provider = _provider();
        when(
          () => api.v1ProvidersMePost(
            v1ProvidersMePostRequest: any(named: 'v1ProvidersMePostRequest'),
          ),
        ).thenAnswer(
          (_) async => _ok(
            V1ProvidersMePost200Response(
              (b) => b
                ..accessToken = 'access'
                ..refreshToken = 'refresh'
                ..provider.replace(provider),
            ),
          ),
        );

        final result = await repository.createProfile(
          businessName: 'Ahmed Plomberie',
          baseGovernorateId: 'gov-1',
        );

        expect(result.accessToken, 'access');
        expect(result.provider, provider);

        final captured =
            verify(
                  () => api.v1ProvidersMePost(
                    v1ProvidersMePostRequest: captureAny(
                      named: 'v1ProvidersMePostRequest',
                    ),
                  ),
                ).captured.single
                as V1ProvidersMePostRequest;
        expect(captured.businessName, 'Ahmed Plomberie');
        expect(captured.baseGovernorateId, 'gov-1');
      },
    );
  });

  group('updateProfile', () {
    test('renvoie le profil mis à jour', () async {
      final provider = _provider(completionScore: 72);
      when(
        () => api.v1ProvidersMePatch(
          v1ProvidersMePatchRequest: any(named: 'v1ProvidersMePatchRequest'),
        ),
      ).thenAnswer((_) async => _ok(provider));

      final result = await repository.updateProfile(
        bio: 'Plombier depuis 10 ans à Sousse.',
      );

      expect(result.completionScore, 72);
    });

    test(
      '🔒 PublicationBlocked.fromException distingue le 403 de complétude '
      "d'un 403 générique",
      () async {
        // 🔒 NON-RÉGRESSION — sans cette distinction, l'écran de publication
        // ne peut pas afficher la liste des champs manquants (critère
        // d'acceptation FM-11 : « liste explicite des manques »).
        when(
          () => api.v1ProvidersMePatch(
            v1ProvidersMePatchRequest: any(named: 'v1ProvidersMePatchRequest'),
          ),
        ).thenThrow(_forbiddenIncomplete());

        try {
          await repository.updateProfile(
            publicationStatus: PublicationStatus.PUBLISHED,
          );
          fail('devait lancer ForbiddenException');
        } on ForbiddenException catch (e) {
          final blocked = PublicationBlocked.fromException(e);
          expect(blocked, isNotNull);
          expect(blocked!.completionScore, 54);
          expect(blocked.missingFields, ['bio', 'coverageAreas']);
        }
      },
    );

    test(
      'PublicationBlocked.fromException renvoie null pour un 403 générique',
      () {
        final other = ForbiddenException();
        expect(PublicationBlocked.fromException(other), isNull);
      },
    );

    test(
      'PublicationBlocked.fromException renvoie null pour une autre exception',
      () {
        expect(PublicationBlocked.fromException(NetworkException()), isNull);
      },
    );
  });

  group('replaceCategories', () {
    test('envoie la liste et renvoie completionScore', () async {
      when(
        () => api.v1ProvidersMeCategoriesPut(
          v1ProvidersMeCategoriesPutRequest: any(
            named: 'v1ProvidersMeCategoriesPutRequest',
          ),
        ),
      ).thenAnswer(
        (_) async => _ok(
          V1ProvidersMeCategoriesPut200Response(
            (b) => b
              ..categories = ListBuilder([])
              ..completionScore = 72,
          ),
        ),
      );

      final result = await repository.replaceCategories([
        CategoryInput(
          (b) => b
            ..categoryId = 'cat-1'
            ..isPrimary = true,
        ),
      ]);

      expect(result.completionScore, 72);

      final captured =
          verify(
                () => api.v1ProvidersMeCategoriesPut(
                  v1ProvidersMeCategoriesPutRequest: captureAny(
                    named: 'v1ProvidersMeCategoriesPutRequest',
                  ),
                ),
              ).captured.single
              as V1ProvidersMeCategoriesPutRequest;
      expect(captured.categories, hasLength(1));
      expect(captured.categories.single.categoryId, 'cat-1');
    });
  });

  group('replaceCoverageAreas', () {
    test('envoie la liste et renvoie completionScore', () async {
      when(
        () => api.v1ProvidersMeCoverageAreasPut(
          v1ProvidersMeCoverageAreasPutRequest: any(
            named: 'v1ProvidersMeCoverageAreasPutRequest',
          ),
        ),
      ).thenAnswer(
        (_) async => _ok(
          V1ProvidersMeCoverageAreasPut200Response(
            (b) => b
              ..coverageAreas = ListBuilder([])
              ..completionScore = 90,
          ),
        ),
      );

      final result = await repository.replaceCoverageAreas([
        CoverageAreaInput((b) => b..governorateId = 'gov-1'),
      ]);

      expect(result.completionScore, 90);
    });
  });
}
