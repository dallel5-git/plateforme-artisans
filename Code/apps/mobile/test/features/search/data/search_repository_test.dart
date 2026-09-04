import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import 'package:sanaya/core/api/generated/api.dart';
import 'package:sanaya/features/search/data/search_filters.dart';
import 'package:sanaya/features/search/data/search_repository.dart';

class _DefaultApiMock extends Mock implements DefaultApi {}

Response<T> _okResponse<T>(String path, T data) => Response<T>(
  requestOptions: RequestOptions(path: path),
  statusCode: 200,
  data: data,
);

void main() {
  late _DefaultApiMock api;
  late SearchRepository repository;

  setUp(() {
    api = _DefaultApiMock();
    repository = SearchRepository(api);
  });

  group('SearchRepository.search', () {
    test(
      'mappe tous les filtres vers les query params de /v1/providers/search',
      () async {
        when(
          () => api.v1ProvidersSearchGet(
            governorate: any(named: 'governorate'),
            category: any(named: 'category'),
            delegation: any(named: 'delegation'),
            verified: any(named: 'verified'),
            minRating: any(named: 'minRating'),
            cursor: any(named: 'cursor'),
            limit: any(named: 'limit'),
          ),
        ).thenAnswer(
          (_) async => _okResponse(
            '/v1/providers/search',
            V1ProvidersSearchGet200Response((b) => b..nextCursor = ''),
          ),
        );

        await repository.search(
          const SearchFilters(
            governorateId: 'sousse',
            categorySlug: 'plomberie',
            delegationId: 'del-1',
            isVerified: true,
            minRating: 4,
          ),
          cursor: 'cur-1',
          limit: 10,
        );

        verify(
          () => api.v1ProvidersSearchGet(
            governorate: 'sousse',
            category: 'plomberie',
            delegation: 'del-1',
            verified: 'true',
            minRating: 4,
            cursor: 'cur-1',
            limit: 10,
          ),
        ).called(1);
      },
    );

    test('isVerified=false devient la chaîne "false", pas omis', () async {
      when(
        () => api.v1ProvidersSearchGet(
          governorate: any(named: 'governorate'),
          verified: any(named: 'verified'),
          cursor: any(named: 'cursor'),
          limit: any(named: 'limit'),
        ),
      ).thenAnswer(
        (_) async => _okResponse(
          '/v1/providers/search',
          V1ProvidersSearchGet200Response((b) => b..nextCursor = ''),
        ),
      );

      await repository.search(
        const SearchFilters(governorateId: 'sousse', isVerified: false),
      );

      verify(
        () =>
            api.v1ProvidersSearchGet(governorate: 'sousse', verified: 'false'),
      ).called(1);
    });

    test(
      "propage l'exception réseau — jamais un fallback silencieux",
      () async {
        // 🔒 NON-RÉGRESSION — un échec réseau doit rester visible (état
        // d'erreur / repli sur le cache disque en amont), jamais masqué par
        // une liste vide silencieuse (même principe que CatalogRepository).
        when(
          () => api.v1ProvidersSearchGet(
            governorate: any(named: 'governorate'),
            category: any(named: 'category'),
            delegation: any(named: 'delegation'),
            verified: any(named: 'verified'),
            minRating: any(named: 'minRating'),
            cursor: any(named: 'cursor'),
            limit: any(named: 'limit'),
          ),
        ).thenThrow(
          DioException(
            requestOptions: RequestOptions(path: '/v1/providers/search'),
          ),
        );

        expect(
          repository.search(const SearchFilters(governorateId: 'sousse')),
          throwsA(isA<DioException>()),
        );
      },
    );
  });
}
