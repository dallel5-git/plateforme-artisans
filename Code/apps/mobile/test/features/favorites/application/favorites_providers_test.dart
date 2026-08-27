import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:sanaya/core/api/generated/api.dart';
import 'package:sanaya/features/favorites/application/favorites_providers.dart';
import 'package:sanaya/features/favorites/data/favorites_repository.dart';

class _FavoritesRepositoryMock extends Mock implements FavoritesRepository {}

void main() {
  late _FavoritesRepositoryMock repository;
  late FavoriteItem sampleItem;

  setUp(() {
    repository = _FavoritesRepositoryMock();
    sampleItem = FavoriteItem(
      (b) => b
        ..providerId = 'prov-1'
        ..slug = 'sami-plombier'
        ..businessName = 'Sami Plomberie'
        ..headline = 'Plombier sanitaire'
        ..isVerified = true
        ..ratingAvg = 5.0
        ..ratingCount = 3
        ..availabilityStatus =
            V1FavoritesGet200ResponseItemsInnerAvailabilityStatusEnum.AVAILABLE
        ..favoritedAt = DateTime.utc(2026, 8, 26),
    );
  });

  ProviderContainer createContainer() {
    final container = ProviderContainer(
      overrides: [
        favoritesRepositoryProvider.overrideWithValue(repository),
      ],
    );
    addTearDown(container.dispose);
    return container;
  }

  group('favoritesListProvider & isFavoriteProvider', () {
    test('charge la liste des favoris avec succès', () async {
      when(() => repository.fetchFavorites()).thenAnswer(
        (_) async => FavoritesResponse(
          (b) => b
            ..items.add(sampleItem)
            ..nextCursor = '',
        ),
      );

      final container = createContainer();

      final items = await container.read(favoritesListProvider.future);

      expect(items.length, 1);
      expect(items.first.providerId, 'prov-1');
      expect(container.read(isFavoriteProvider('prov-1')), isTrue);
      expect(container.read(isFavoriteProvider('prov-unknown')), isFalse);
    });

    test(
      'removeFavorite supprime de façon optimiste et appelle le repository',
      () async {
        when(() => repository.fetchFavorites()).thenAnswer(
          (_) async => FavoritesResponse(
            (b) => b
              ..items.add(sampleItem)
              ..nextCursor = '',
          ),
        );
        when(
          () => repository.removeFavorite('prov-1'),
        ).thenAnswer((_) async {});

        final container = createContainer();
        await container.read(favoritesListProvider.future);

        final notifier = container.read(favoritesListProvider.notifier);
        await notifier.removeFavorite('prov-1');

        final updatedItems = container.read(favoritesListProvider).value;
        expect(updatedItems, isEmpty);
        expect(container.read(isFavoriteProvider('prov-1')), isFalse);
        verify(() => repository.removeFavorite('prov-1')).called(1);
      },
    );

    test('removeFavorite restaure l’état en cas d’échec', () async {
      when(() => repository.fetchFavorites()).thenAnswer(
        (_) async => FavoritesResponse(
          (b) => b
            ..items.add(sampleItem)
            ..nextCursor = '',
        ),
      );
      when(
        () => repository.removeFavorite('prov-1'),
      ).thenThrow(Exception('Erreur réseau'));

      final container = createContainer();
      await container.read(favoritesListProvider.future);

      final notifier = container.read(favoritesListProvider.notifier);

      expect(
        () => notifier.removeFavorite('prov-1'),
        throwsA(isA<Exception>()),
      );
    });
  });
}
