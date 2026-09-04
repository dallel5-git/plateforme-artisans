import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:hive/hive.dart';

import 'package:sanaya/core/api/generated/api.dart';
import 'package:sanaya/core/cache/disk_cache.dart';
import 'package:sanaya/features/provider_profile/data/provider_profile_cache.dart';
import 'package:sanaya/features/provider_profile/data/provider_profile_repository.dart';

ProviderProfile _sampleProfile(String slug) => V1ProvidersSlugGet200Response(
  (b) => b
    ..id = 'p1'
    ..slug = slug
    ..businessName = 'Plomberie X'
    ..headline = ''
    ..bio = ''
    ..yearsExperience = 5
    ..baseGovernorate.slug = 'sousse'
    ..baseGovernorate.nameFr = 'Sousse'
    ..baseGovernorate.nameAr = 'سوسة'
    ..baseDelegation.slug = 'sousse-ville'
    ..baseDelegation.nameFr = 'Sousse Ville'
    ..baseDelegation.nameAr = 'سوسة المدينة'
    ..latitude = 35.8
    ..longitude = 10.6
    ..isVerified = true
    ..availabilityStatus =
        V1ProvidersSlugGet200ResponseAvailabilityStatusEnum.AVAILABLE
    ..availableAgainAt = DateTime.utc(2026)
    ..acceptsEmergency = false
    ..completionScore = 80
    ..reviewAggregate.average = 4.5
    ..reviewAggregate.count = 10
    ..reviewAggregate.breakdown.n1 = 0
    ..reviewAggregate.breakdown.n2 = 0
    ..reviewAggregate.breakdown.n3 = 1
    ..reviewAggregate.breakdown.n4 = 3
    ..reviewAggregate.breakdown.n5 = 6,
);

void main() {
  late Directory tempDir;

  setUp(() async {
    tempDir = await Directory.systemTemp.createTemp(
      'sanaya_provider_profile_cache_test',
    );
    Hive.init(tempDir.path);
  });

  tearDown(() async {
    await Hive.deleteFromDisk();
    await tempDir.delete(recursive: true);
  });

  test('cache miss renvoie null', () async {
    final cache = ProviderProfileCache(DiskCache('test_box'));

    expect(await cache.read('mon-artisan'), isNull);
  });

  test(
    'write puis read fait un aller-retour fidèle sur une fiche réelle',
    () async {
      final cache = ProviderProfileCache(DiskCache('test_box'));
      final profile = _sampleProfile('mon-artisan');

      await cache.write('mon-artisan', profile);
      final result = await cache.read('mon-artisan');

      expect(result, profile);
    },
  );

  test('deux slugs différents ne partagent pas leur entrée', () async {
    final cache = ProviderProfileCache(DiskCache('test_box'));
    await cache.write('artisan-a', _sampleProfile('artisan-a'));

    expect(await cache.read('artisan-b'), isNull);
  });
}
