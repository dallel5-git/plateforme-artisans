import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:hive/hive.dart';

import 'package:sanaya/core/api/generated/api.dart';
import 'package:sanaya/core/cache/disk_cache.dart';
import 'package:sanaya/features/search/data/search_filters.dart';
import 'package:sanaya/features/search/data/search_results_cache.dart';

V1ProvidersSearchGet200ResponseItemsInner _sampleItem() =>
    V1ProvidersSearchGet200ResponseItemsInner(
      (i) => i
        ..id = 'p1'
        ..slug = 'artisan-1'
        ..businessName = 'Plomberie X'
        ..headline = ''
        ..isVerified = true
        ..ratingAvg = 4.5
        ..ratingCount = 10
        ..completionScore = 80
        ..availabilityStatus =
            V1ProvidersSearchGet200ResponseItemsInnerAvailabilityStatusEnum
                .AVAILABLE,
    );

void main() {
  late Directory tempDir;

  setUp(() async {
    tempDir = await Directory.systemTemp.createTemp(
      'sanaya_search_cache_test',
    );
    Hive.init(tempDir.path);
  });

  tearDown(() async {
    await Hive.deleteFromDisk();
    await tempDir.delete(recursive: true);
  });

  test('cache miss renvoie null', () async {
    final cache = SearchResultsCache(DiskCache('test_box'));

    final result = await cache.readFirstPage(
      const SearchFilters(governorateId: 'sousse'),
    );

    expect(result, isNull);
  });

  test(
    'write puis read fait un aller-retour fidèle sur un objet built_value réel',
    () async {
      final cache = SearchResultsCache(DiskCache('test_box'));
      final page = V1ProvidersSearchGet200Response(
        (b) => b
          ..nextCursor = 'cur-2'
          ..items.add(_sampleItem()),
      );
      const filters = SearchFilters(governorateId: 'sousse');

      await cache.writeFirstPage(filters, page);
      final result = await cache.readFirstPage(filters);

      expect(result, page);
    },
  );

  test(
    'deux jeux de filtres différents ne partagent pas leur entrée',
    () async {
      final cache = SearchResultsCache(DiskCache('test_box'));
      final page = V1ProvidersSearchGet200Response((b) => b.nextCursor = '');
      await cache.writeFirstPage(
        const SearchFilters(governorateId: 'sousse'),
        page,
      );

      final result = await cache.readFirstPage(
        const SearchFilters(governorateId: 'monastir'),
      );

      expect(result, isNull);
    },
  );
}
