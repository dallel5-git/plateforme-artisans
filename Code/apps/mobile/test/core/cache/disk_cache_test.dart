import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:hive/hive.dart';
import 'package:sanaya/core/cache/disk_cache.dart';

void main() {
  late Directory tempDir;

  setUp(() async {
    tempDir = await Directory.systemTemp.createTemp('sanaya_disk_cache_test');
    Hive.init(tempDir.path);
  });

  tearDown(() async {
    await Hive.deleteFromDisk();
    await tempDir.delete(recursive: true);
  });

  test('cache miss renvoie null', () async {
    final cache = DiskCache('test_box');

    expect(await cache.read('absent'), isNull);
  });

  test('write puis read fait un aller-retour fidèle', () async {
    final cache = DiskCache('test_box');

    await cache.write('k', {'a': 1, 'b': 'x'});

    expect(await cache.read('k'), {'a': 1, 'b': 'x'});
  });

  test('delete supprime la clé', () async {
    final cache = DiskCache('test_box');
    await cache.write('k', {'a': 1});

    await cache.delete('k');

    expect(await cache.read('k'), isNull);
  });

  test(
    'une valeur corrompue (JSON invalide) renvoie null, pas une exception',
    () async {
      final cache = DiskCache('test_box');
      final box = await Hive.openBox<String>('test_box');
      await box.put('k', 'pas-du-json{{{');

      expect(await cache.read('k'), isNull);
    },
  );
}
