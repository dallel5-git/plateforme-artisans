import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import 'package:sanaya/core/api/generated/api.dart';
import 'package:sanaya/features/search/application/search_providers.dart';
import 'package:sanaya/features/search/data/search_filters.dart';
import 'package:sanaya/features/search/data/search_repository.dart';
import 'package:sanaya/features/search/data/search_results_cache.dart';

class _SearchRepositoryMock extends Mock implements SearchRepository {}

class _SearchResultsCacheMock extends Mock implements SearchResultsCache {}

const _filters = SearchFilters(governorateId: 'sousse');

class _SearchFiltersFake extends Fake implements SearchFilters {}

class _SearchResultsPageFake extends Fake implements SearchResultsPage {}

SearchResultItem _item(String id) => V1ProvidersSearchGet200ResponseItemsInner(
  (i) => i
    ..id = id
    ..slug = 'artisan-$id'
    ..businessName = 'Artisan $id'
    ..headline = ''
    ..isVerified = true
    ..ratingAvg = 4.5
    ..ratingCount = 10
    ..completionScore = 80
    ..availabilityStatus =
        V1ProvidersSearchGet200ResponseItemsInnerAvailabilityStatusEnum
            .AVAILABLE,
);

SearchResultsPage _page(List<String> ids, {String nextCursor = ''}) =>
    V1ProvidersSearchGet200Response(
      (b) => b
        ..nextCursor = nextCursor
        ..items.addAll(ids.map(_item)),
    );

void main() {
  late _SearchRepositoryMock repository;
  late _SearchResultsCacheMock cache;

  setUpAll(() {
    registerFallbackValue(_SearchFiltersFake());
    registerFallbackValue(_SearchResultsPageFake());
  });

  setUp(() {
    repository = _SearchRepositoryMock();
    cache = _SearchResultsCacheMock();
    when(
      () => cache.writeFirstPage(any(), any()),
    ).thenAnswer((_) async {});
  });

  ProviderContainer createContainer() {
    final container = ProviderContainer(
      overrides: [
        searchRepositoryProvider.overrideWithValue(repository),
        searchResultsCacheProvider.overrideWithValue(cache),
      ],
    );
    addTearDown(container.dispose);
    return container;
  }

  group('searchResultsProvider', () {
    test('charge la page 1 avec succès et l écrit en cache', () async {
      when(
        () => repository.search(_filters),
      ).thenAnswer((_) async => _page(['1'], nextCursor: 'cur-2'));

      final container = createContainer();
      final state = await container.read(
        searchResultsProvider(_filters).future,
      );

      expect(state.items.map((i) => i.id), ['1']);
      expect(state.hasMore, isTrue);
      verify(() => cache.writeFirstPage(_filters, any())).called(1);
    });

    test(
      "sert le cache disque sur échec réseau — pas d'écran blanc hors ligne",
      () async {
        when(() => repository.search(_filters)).thenThrow(Exception('offline'));
        when(
          () => cache.readFirstPage(_filters),
        ).thenAnswer((_) async => _page(['cached']));

        final container = createContainer();
        final state = await container.read(
          searchResultsProvider(_filters).future,
        );

        expect(state.items.map((i) => i.id), ['cached']);
      },
    );

    test(
      'relance l erreur d origine si le cache est vide aussi',
      () async {
        when(() => repository.search(_filters)).thenThrow(Exception('offline'));
        when(() => cache.readFirstPage(_filters)).thenAnswer((_) async => null);

        final container = createContainer();

        await expectLater(
          container.read(searchResultsProvider(_filters).future),
          throwsA(isA<Exception>()),
        );
      },
    );

    test('loadMore accumule les résultats et avance le curseur', () async {
      when(
        () => repository.search(_filters),
      ).thenAnswer((_) async => _page(['1'], nextCursor: 'cur-2'));
      when(
        () => repository.search(_filters, cursor: 'cur-2'),
      ).thenAnswer((_) async => _page(['2']));

      final container = createContainer();
      await container.read(searchResultsProvider(_filters).future);

      final notifier = container.read(searchResultsProvider(_filters).notifier);
      await notifier.loadMore();

      final state = container.read(searchResultsProvider(_filters)).value!;
      expect(state.items.map((i) => i.id), ['1', '2']);
      expect(state.hasMore, isFalse);
      verify(() => repository.search(_filters, cursor: 'cur-2')).called(1);
    });

    test('loadMore ne fait rien si hasMore est false', () async {
      when(
        () => repository.search(_filters),
      ).thenAnswer((_) async => _page(['1']));

      final container = createContainer();
      await container.read(searchResultsProvider(_filters).future);

      final notifier = container.read(searchResultsProvider(_filters).notifier);
      await notifier.loadMore();

      verify(() => repository.search(_filters)).called(1);
    });

    test('refresh recharge la page 1 depuis zéro', () async {
      when(
        () => repository.search(_filters),
      ).thenAnswer((_) async => _page(['1'], nextCursor: 'cur-2'));

      final container = createContainer();
      await container.read(searchResultsProvider(_filters).future);

      when(
        () => repository.search(_filters),
      ).thenAnswer((_) async => _page(['1']));

      final notifier = container.read(searchResultsProvider(_filters).notifier);
      await notifier.refresh();

      final state = container.read(searchResultsProvider(_filters)).value!;
      expect(state.hasMore, isFalse);
      verify(() => repository.search(_filters)).called(2);
    });

    test('filtre les résultats selon filters.query', () async {
      const queryFilters = SearchFilters(
        governorateId: 'sousse',
        query: 'Artisan 1',
      );
      when(
        () => repository.search(queryFilters),
      ).thenAnswer((_) async => _page(['1', '2']));

      final container = createContainer();
      final state = await container.read(
        searchResultsProvider(queryFilters).future,
      );

      expect(state.items.length, 1);
      expect(state.items.first.id, '1');
    });
  });
}
