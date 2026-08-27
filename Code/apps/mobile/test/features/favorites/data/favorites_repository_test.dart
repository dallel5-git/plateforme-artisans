import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:sanaya/core/api/generated/api.dart';
import 'package:sanaya/features/favorites/data/favorites_repository.dart';

class _DefaultApiMock extends Mock implements DefaultApi {}

Response<T> _okResponse<T>(String path, T data) => Response<T>(
  requestOptions: RequestOptions(path: path),
  statusCode: 200,
  data: data,
);

Response<void> _noContentResponse(String path) => Response<void>(
  requestOptions: RequestOptions(path: path),
  statusCode: 204,
);

void main() {
  late _DefaultApiMock api;
  late FavoritesRepository repository;

  setUp(() {
    api = _DefaultApiMock();
    repository = FavoritesRepository(api);
  });

  group('FavoritesRepository.fetchFavorites', () {
    test('renvoie la liste des favoris paginée depuis /v1/favorites', () async {
      final item = FavoriteItem(
        (b) => b
          ..providerId = 'prov-1'
          ..slug = 'sami-plombier'
          ..businessName = 'Sami Plomberie'
          ..headline = 'Plombier sanitaire et chauffage'
          ..isVerified = true
          ..ratingAvg = 4.8
          ..ratingCount = 12
          ..availabilityStatus =
              V1FavoritesGet200ResponseItemsInnerAvailabilityStatusEnum
                  .AVAILABLE
          ..favoritedAt = DateTime.utc(2026, 8, 25),
      );

      final responseDto = FavoritesResponse(
        (b) => b
          ..items.add(item)
          ..nextCursor = 'cursor-next-123',
      );

      when(
        () => api.v1FavoritesGet(
          cursor: any(named: 'cursor'),
          limit: any(named: 'limit'),
        ),
      ).thenAnswer((_) async => _okResponse('/v1/favorites', responseDto));

      final result = await repository.fetchFavorites(cursor: 'cursor-1');

      expect(result.items.length, 1);
      expect(result.items.first.providerId, 'prov-1');
      expect(result.nextCursor, 'cursor-next-123');
      verify(() => api.v1FavoritesGet(cursor: 'cursor-1')).called(1);
    });

    test("propage l'exception en cas d'échec réseau", () async {
      when(
        () => api.v1FavoritesGet(
          cursor: any(named: 'cursor'),
          limit: any(named: 'limit'),
        ),
      ).thenThrow(
        DioException(requestOptions: RequestOptions(path: '/v1/favorites')),
      );

      expect(() => repository.fetchFavorites(), throwsA(isA<DioException>()));
    });
  });

  group('FavoritesRepository.addFavorite', () {
    test(
      'appelle PUT /v1/favorites/:providerId de façon idempotente',
      () async {
        final responseDto = V1FavoritesProviderIdPut200Response(
          (b) => b
            ..providerId = 'prov-1'
            ..createdAt = DateTime.utc(2026, 8, 25),
        );

        when(
          () => api.v1FavoritesProviderIdPut(providerId: 'prov-1'),
        ).thenAnswer(
          (_) async => _okResponse('/v1/favorites/prov-1', responseDto),
        );

        await repository.addFavorite('prov-1');

        verify(
          () => api.v1FavoritesProviderIdPut(providerId: 'prov-1'),
        ).called(1);
      },
    );
  });

  group('FavoritesRepository.removeFavorite', () {
    test('appelle DELETE /v1/favorites/:providerId (204 No Content)', () async {
      when(
        () => api.v1FavoritesProviderIdDelete(providerId: 'prov-1'),
      ).thenAnswer((_) async => _noContentResponse('/v1/favorites/prov-1'));

      await repository.removeFavorite('prov-1');

      verify(
        () => api.v1FavoritesProviderIdDelete(providerId: 'prov-1'),
      ).called(1);
    });
  });
}
