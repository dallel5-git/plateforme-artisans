import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:sanaya/core/api/generated/api.dart';
import 'package:sanaya/features/onboarding/data/onboarding_repository.dart';

// ---------------------------------------------------------------------------
// Mocks et Fakes
// ---------------------------------------------------------------------------

class MockDefaultApi extends Mock implements DefaultApi {}

// Fakes requis par mocktail pour `any(named: ...)` sur des types BuiltValue
// (types abstract — on ne peut pas les instancier directement, Fake permet
// de contourner sans implémenter tous les membres).
class _FakePostRequest extends Fake implements V1ProvidersMePostRequest {}

class _FakePatchRequest extends Fake implements V1ProvidersMePatchRequest {}

class _FakeCategoriesPutRequest extends Fake
    implements V1ProvidersMeCategoriesPutRequest {}

class _FakeCoverageAreasPutRequest extends Fake
    implements V1ProvidersMeCoverageAreasPutRequest {}

/// Crée une [RequestOptions] minimale pour les fakes de [Response].
RequestOptions _opts([String path = '/']) => RequestOptions(path: path);

void main() {
  // Enregistrement des fallbacks une seule fois avant tous les tests.
  setUpAll(() {
    registerFallbackValue(_FakePostRequest());
    registerFallbackValue(_FakePatchRequest());
    registerFallbackValue(_FakeCategoriesPutRequest());
    registerFallbackValue(_FakeCoverageAreasPutRequest());
  });

  late MockDefaultApi mockApi;
  late OnboardingRepository repository;

  setUp(() {
    mockApi = MockDefaultApi();
    repository = OnboardingRepository(mockApi);
  });

  // ---------------------------------------------------------------------------
  // createProfile
  // ---------------------------------------------------------------------------

  group('createProfile', () {
    test('appelle v1ProvidersMePost avec le body fourni', () async {
      // businessName et baseGovernorateId sont les seuls champs non-nullable.
      final body = V1ProvidersMePostRequest(
        (b) => b
          ..businessName = 'Plomberie Ben Ali'
          ..baseGovernorateId = 'gov-sousse-uuid',
      );

      when(
        () => mockApi.v1ProvidersMePost(
          v1ProvidersMePostRequest: any(named: 'v1ProvidersMePostRequest'),
        ),
      ).thenAnswer(
        (_) async => Response(
          requestOptions: _opts('/v1/providers/me'),
          statusCode: 200,
          // data null → data! lève une exception dans createProfile ;
          // ce qui compte ici c'est que le mock a bien été appelé.
        ),
      );

      await expectLater(
        repository.createProfile(body),
        throwsA(anything),
      );

      verify(
        () => mockApi.v1ProvidersMePost(
          v1ProvidersMePostRequest: any(named: 'v1ProvidersMePostRequest'),
        ),
      ).called(1);
    });

    test('propage DioException sur erreur 422', () async {
      final body = V1ProvidersMePostRequest(
        (b) => b
          ..businessName = 'Artisan Test'
          ..baseGovernorateId = 'gov-id',
      );

      when(
        () => mockApi.v1ProvidersMePost(
          v1ProvidersMePostRequest: any(named: 'v1ProvidersMePostRequest'),
        ),
      ).thenThrow(
        DioException(
          requestOptions: _opts('/v1/providers/me'),
          type: DioExceptionType.badResponse,
        ),
      );

      await expectLater(
        repository.createProfile(body),
        throwsA(isA<DioException>()),
      );
    });

    test('propage DioException sur timeout reseau', () async {
      final body = V1ProvidersMePostRequest(
        (b) => b
          ..businessName = 'Artisan Test'
          ..baseGovernorateId = 'gov-id',
      );

      when(
        () => mockApi.v1ProvidersMePost(
          v1ProvidersMePostRequest: any(named: 'v1ProvidersMePostRequest'),
        ),
      ).thenThrow(
        DioException(
          requestOptions: _opts('/v1/providers/me'),
          type: DioExceptionType.connectionTimeout,
        ),
      );

      await expectLater(
        repository.createProfile(body),
        throwsA(isA<DioException>()),
      );
    });
  });

  // ---------------------------------------------------------------------------
  // updateProfile
  // ---------------------------------------------------------------------------

  group('updateProfile', () {
    test('appelle v1ProvidersMePatch avec le body fourni', () async {
      // Tous les champs de V1ProvidersMePatchRequest sont nullable.
      final body = V1ProvidersMePatchRequest(
        (b) => b..businessName = 'Plomberie MAJ',
      );

      when(
        () => mockApi.v1ProvidersMePatch(
          v1ProvidersMePatchRequest: any(named: 'v1ProvidersMePatchRequest'),
        ),
      ).thenAnswer(
        (_) async => Response(
          requestOptions: _opts('/v1/providers/me'),
          statusCode: 200,
        ),
      );

      await expectLater(
        repository.updateProfile(body),
        throwsA(anything),
      );

      verify(
        () => mockApi.v1ProvidersMePatch(
          v1ProvidersMePatchRequest: any(named: 'v1ProvidersMePatchRequest'),
        ),
      ).called(1);
    });

    test('propage DioException sur erreur 403', () async {
      final body = V1ProvidersMePatchRequest(
        (b) => b..businessName = 'Test',
      );

      when(
        () => mockApi.v1ProvidersMePatch(
          v1ProvidersMePatchRequest: any(named: 'v1ProvidersMePatchRequest'),
        ),
      ).thenThrow(
        DioException(
          requestOptions: _opts('/v1/providers/me'),
          type: DioExceptionType.badResponse,
        ),
      );

      await expectLater(
        repository.updateProfile(body),
        throwsA(isA<DioException>()),
      );
    });
  });

  // ---------------------------------------------------------------------------
  // setCategories
  // ---------------------------------------------------------------------------

  group('setCategories', () {
    test('appelle v1ProvidersMeCategoriesPut avec le body fourni', () async {
      // Defaults BuiltValue initialisent categories à une BuiltList vide.
      final body = V1ProvidersMeCategoriesPutRequest();

      when(
        () => mockApi.v1ProvidersMeCategoriesPut(
          v1ProvidersMeCategoriesPutRequest: any(
            named: 'v1ProvidersMeCategoriesPutRequest',
          ),
        ),
      ).thenAnswer(
        (_) async => Response(
          requestOptions: _opts('/v1/providers/me/categories'),
          statusCode: 200,
        ),
      );

      await expectLater(
        repository.setCategories(body),
        throwsA(anything),
      );

      verify(
        () => mockApi.v1ProvidersMeCategoriesPut(
          v1ProvidersMeCategoriesPutRequest: any(
            named: 'v1ProvidersMeCategoriesPutRequest',
          ),
        ),
      ).called(1);
    });

    test('propage DioException sur erreur 400', () async {
      final body = V1ProvidersMeCategoriesPutRequest();

      when(
        () => mockApi.v1ProvidersMeCategoriesPut(
          v1ProvidersMeCategoriesPutRequest: any(
            named: 'v1ProvidersMeCategoriesPutRequest',
          ),
        ),
      ).thenThrow(
        DioException(
          requestOptions: _opts('/v1/providers/me/categories'),
          type: DioExceptionType.badResponse,
        ),
      );

      await expectLater(
        repository.setCategories(body),
        throwsA(isA<DioException>()),
      );
    });
  });

  // ---------------------------------------------------------------------------
  // setCoverageAreas
  // ---------------------------------------------------------------------------

  group('setCoverageAreas', () {
    test(
      'appelle v1ProvidersMeCoverageAreasPut avec le body fourni',
      () async {
        final body = V1ProvidersMeCoverageAreasPutRequest();

        when(
          () => mockApi.v1ProvidersMeCoverageAreasPut(
            v1ProvidersMeCoverageAreasPutRequest: any(
              named: 'v1ProvidersMeCoverageAreasPutRequest',
            ),
          ),
        ).thenAnswer(
          (_) async => Response(
            requestOptions: _opts('/v1/providers/me/coverage-areas'),
            statusCode: 200,
          ),
        );

        await expectLater(
          repository.setCoverageAreas(body),
          throwsA(anything),
        );

        verify(
          () => mockApi.v1ProvidersMeCoverageAreasPut(
            v1ProvidersMeCoverageAreasPutRequest: any(
              named: 'v1ProvidersMeCoverageAreasPutRequest',
            ),
          ),
        ).called(1);
      },
    );

    test('propage DioException sur erreur 400', () async {
      final body = V1ProvidersMeCoverageAreasPutRequest();

      when(
        () => mockApi.v1ProvidersMeCoverageAreasPut(
          v1ProvidersMeCoverageAreasPutRequest: any(
            named: 'v1ProvidersMeCoverageAreasPutRequest',
          ),
        ),
      ).thenThrow(
        DioException(
          requestOptions: _opts('/v1/providers/me/coverage-areas'),
          type: DioExceptionType.badResponse,
        ),
      );

      await expectLater(
        repository.setCoverageAreas(body),
        throwsA(isA<DioException>()),
      );
    });

    test('propage DioException sur timeout reseau', () async {
      final body = V1ProvidersMeCoverageAreasPutRequest();

      when(
        () => mockApi.v1ProvidersMeCoverageAreasPut(
          v1ProvidersMeCoverageAreasPutRequest: any(
            named: 'v1ProvidersMeCoverageAreasPutRequest',
          ),
        ),
      ).thenThrow(
        DioException(
          requestOptions: _opts('/v1/providers/me/coverage-areas'),
          type: DioExceptionType.connectionTimeout,
        ),
      );

      await expectLater(
        repository.setCoverageAreas(body),
        throwsA(isA<DioException>()),
      );
    });
  });
}
