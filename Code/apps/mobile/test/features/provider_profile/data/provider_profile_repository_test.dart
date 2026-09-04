import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:sanaya/core/api/generated/api.dart';
import 'package:sanaya/features/provider_profile/data/provider_profile_cache.dart';
import 'package:sanaya/features/provider_profile/data/provider_profile_repository.dart';

class MockDefaultApi extends Mock implements DefaultApi {}

class MockProviderProfileCache extends Mock implements ProviderProfileCache {}

class _ProfileFake extends Fake implements ProviderProfile {}

/// Crée une [RequestOptions] minimale pour les fakes de [Response].
RequestOptions _opts([String path = '/']) => RequestOptions(path: path);

void main() {
  late MockDefaultApi mockApi;
  late MockProviderProfileCache mockCache;
  late ProviderProfileRepository repository;

  setUpAll(() {
    registerFallbackValue(_ProfileFake());
  });

  setUp(() {
    mockApi = MockDefaultApi();
    mockCache = MockProviderProfileCache();
    // Comportement par défaut réaliste — cache vide, écriture acceptée —
    // que chaque test peut surcharger pour son propre scénario.
    when(() => mockCache.read(any())).thenAnswer((_) async => null);
    when(() => mockCache.write(any(), any())).thenAnswer((_) async {});
    repository = ProviderProfileRepository(mockApi, cache: mockCache);
  });

  // -------------------------------------------------------------------------
  // fetchProfile
  // -------------------------------------------------------------------------

  group('fetchProfile', () {
    test('appelle v1ProvidersSlugGet avec le bon slug', () async {
      // La valeur de data n'est pas testee ici — seul le slug transmis compte.
      // On cree un mock qui renvoie null.data pour declencher une NPE
      // si le code essaie de deserialiser — mais on intercepte avant.
      final fakeResponse = Response<V1ProvidersSlugGet200Response>(
        requestOptions: _opts('/v1/providers/mon-artisan'),
        statusCode: 200,
      );

      when(
        () => mockApi.v1ProvidersSlugGet(slug: 'mon-artisan'),
      ).thenAnswer((_) async => fakeResponse);

      // On attend une exception (data! sur null) — l'important est que le mock
      // a ete appele avec le bon slug.
      await expectLater(
        repository.fetchProfile('mon-artisan'),
        throwsA(anything),
      );

      verify(() => mockApi.v1ProvidersSlugGet(slug: 'mon-artisan')).called(1);
    });

    test('propage DioException si l API renvoie une erreur', () async {
      when(
        () => mockApi.v1ProvidersSlugGet(slug: any(named: 'slug')),
      ).thenThrow(
        DioException(
          requestOptions: _opts('/v1/providers/inexistant'),
          type: DioExceptionType.badResponse,
        ),
      );

      await expectLater(
        repository.fetchProfile('inexistant'),
        throwsA(isA<DioException>()),
      );
    });

    test(
      'écrit la fiche en cache disque après un succès réseau (FM-28)',
      () async {
        final profile = _ProfileFake();
        when(
          () => mockApi.v1ProvidersSlugGet(slug: 'mon-artisan'),
        ).thenAnswer(
          (_) async => Response(
            requestOptions: _opts('/v1/providers/mon-artisan'),
            statusCode: 200,
            data: profile,
          ),
        );

        final result = await repository.fetchProfile('mon-artisan');

        expect(result, profile);
        verify(() => mockCache.write('mon-artisan', profile)).called(1);
      },
    );

    test(
      'sert la fiche en cache sur échec réseau — pas de crash hors ligne',
      () async {
        final cachedProfile = _ProfileFake();
        when(
          () => mockApi.v1ProvidersSlugGet(slug: any(named: 'slug')),
        ).thenThrow(
          DioException(
            requestOptions: _opts('/v1/providers/mon-artisan'),
            type: DioExceptionType.connectionError,
          ),
        );
        when(
          () => mockCache.read('mon-artisan'),
        ).thenAnswer((_) async => cachedProfile);

        final result = await repository.fetchProfile('mon-artisan');

        expect(result, cachedProfile);
      },
    );
  });

  // -------------------------------------------------------------------------
  // fetchReviews
  // -------------------------------------------------------------------------

  group('fetchReviews', () {
    test('transmet slug, cursor et limit corrects', () async {
      when(
        () => mockApi.v1ProvidersSlugReviewsGet(
          slug: 'mon-artisan',
          cursor: 'cursor-abc',
          limit: 5,
        ),
      ).thenAnswer(
        (_) async => Response(
          requestOptions: _opts(),
          statusCode: 200,
        ),
      );

      await expectLater(
        repository.fetchReviews('mon-artisan', cursor: 'cursor-abc', limit: 5),
        throwsA(anything),
      );

      verify(
        () => mockApi.v1ProvidersSlugReviewsGet(
          slug: 'mon-artisan',
          cursor: 'cursor-abc',
          limit: 5,
        ),
      ).called(1);
    });

    test('utilise limit=10 et cursor=null par defaut', () async {
      when(
        () => mockApi.v1ProvidersSlugReviewsGet(
          slug: 'mon-artisan',
          limit: 10,
        ),
      ).thenAnswer(
        (_) async => Response(
          requestOptions: _opts(),
          statusCode: 200,
        ),
      );

      await expectLater(
        repository.fetchReviews('mon-artisan'),
        throwsA(anything),
      );

      verify(
        () => mockApi.v1ProvidersSlugReviewsGet(
          slug: 'mon-artisan',
          limit: 10,
        ),
      ).called(1);
    });

    test('propage DioException sur erreur reseau', () async {
      when(
        () => mockApi.v1ProvidersSlugReviewsGet(
          slug: any(named: 'slug'),
          cursor: any(named: 'cursor'),
          limit: any(named: 'limit'),
        ),
      ).thenThrow(
        DioException(
          requestOptions: _opts(),
          type: DioExceptionType.connectionTimeout,
        ),
      );

      await expectLater(
        repository.fetchReviews('mon-artisan'),
        throwsA(isA<DioException>()),
      );
    });
  });
}
