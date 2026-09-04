import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:sanaya/core/api/generated/api.dart';
import 'package:sanaya/features/history/application/contact_history_providers.dart';
import 'package:sanaya/features/history/data/contact_history_repository.dart';

class _ContactHistoryRepositoryMock extends Mock
    implements ContactHistoryRepository {}

ContactHistoryItem _item(String id, {bool hasReview = false}) =>
    ContactHistoryItem(
      (b) => b
        ..id = id
        ..providerId = 'prov-$id'
        ..slug = 'artisan-$id'
        ..businessName = 'Artisan $id'
        ..categoryName = 'Plombier'
        ..channel = V1ContactEventsGet200ResponseItemsInnerChannelEnum.PHONE
        ..contactedAt = DateTime.utc(2026, 9)
        ..hasReview = hasReview,
    );

void main() {
  late _ContactHistoryRepositoryMock repository;

  setUp(() {
    repository = _ContactHistoryRepositoryMock();
  });

  ProviderContainer createContainer() {
    final container = ProviderContainer(
      overrides: [
        contactHistoryRepositoryProvider.overrideWithValue(repository),
      ],
    );
    addTearDown(container.dispose);
    return container;
  }

  group('contactHistoryProvider', () {
    test('charge la page 1 avec succès', () async {
      when(() => repository.fetchHistory()).thenAnswer(
        (_) async => ContactHistoryPage(
          (b) => b
            ..items.add(_item('1'))
            ..nextCursor = '',
        ),
      );

      final container = createContainer();
      final state = await container.read(contactHistoryProvider.future);

      expect(state.items.length, 1);
      expect(state.hasMore, isFalse);
    });

    test('loadMore accumule les items et avance le curseur', () async {
      when(() => repository.fetchHistory()).thenAnswer(
        (_) async => ContactHistoryPage(
          (b) => b
            ..items.add(_item('1'))
            ..nextCursor = 'cursor-2',
        ),
      );
      when(
        () => repository.fetchHistory(cursor: 'cursor-2'),
      ).thenAnswer(
        (_) async => ContactHistoryPage(
          (b) => b
            ..items.add(_item('2'))
            ..nextCursor = '',
        ),
      );

      final container = createContainer();
      await container.read(contactHistoryProvider.future);

      final notifier = container.read(contactHistoryProvider.notifier);
      await notifier.loadMore();

      final state = container.read(contactHistoryProvider).value!;
      expect(state.items.map((i) => i.id), ['1', '2']);
      expect(state.hasMore, isFalse);
      verify(() => repository.fetchHistory(cursor: 'cursor-2')).called(1);
    });

    test('loadMore ne fait rien si hasMore est false', () async {
      when(() => repository.fetchHistory()).thenAnswer(
        (_) async => ContactHistoryPage(
          (b) => b
            ..items.add(_item('1'))
            ..nextCursor = '',
        ),
      );

      final container = createContainer();
      await container.read(contactHistoryProvider.future);

      final notifier = container.read(contactHistoryProvider.notifier);
      await notifier.loadMore();

      // Un seul appel total : celui de build() (page 1). loadMore() n'a pas
      // dû recontacter le repository puisque hasMore est déjà false.
      verify(() => repository.fetchHistory()).called(1);
    });

    test('refresh recharge la page 1 depuis zéro', () async {
      when(() => repository.fetchHistory()).thenAnswer(
        (_) async => ContactHistoryPage(
          (b) => b
            ..items.add(_item('1'))
            ..nextCursor = 'cursor-2',
        ),
      );

      final container = createContainer();
      await container.read(contactHistoryProvider.future);

      when(() => repository.fetchHistory()).thenAnswer(
        (_) async => ContactHistoryPage(
          (b) => b
            ..items.add(_item('1'))
            ..nextCursor = '',
        ),
      );

      final notifier = container.read(contactHistoryProvider.notifier);
      await notifier.refresh();

      final state = container.read(contactHistoryProvider).value!;
      expect(state.items.length, 1);
      expect(state.hasMore, isFalse);
      verify(() => repository.fetchHistory()).called(2);
    });
  });
}
