import 'package:built_value/serializer.dart';
import 'package:sanaya/core/api/generated/api.dart';
import 'package:sanaya/core/cache/disk_cache.dart';
import 'package:sanaya/features/provider_profile/data/provider_profile_repository.dart';

/// Cache disque de la fiche artisan par `slug` (FM-28) — les fiches déjà
/// consultées restent visibles en mode avion. Aucun TTL ici volontairement :
/// la fraîcheur (ignorer le cache si en ligne, le servir tel quel si hors
/// ligne) est une décision de l'appelant, même principe que `DiskCache` et
/// `SearchResultsCache`.
///
/// Sérialise via `standardSerializers` (généré, même idiome que
/// `SearchResultsCache`/`OnboardingRepository`) — pas de modèle parallèle
/// écrit à la main (P4).
class ProviderProfileCache {
  ProviderProfileCache(this._disk);

  ProviderProfileCache.withDefaultBox() : _disk = DiskCache(_boxName);

  static const _boxName = 'sanaya.provider_profile_cache';

  final DiskCache _disk;

  Future<ProviderProfile?> read(String slug) async {
    final json = await _disk.read(slug);
    if (json == null) return null;
    return standardSerializers.deserialize(
          json,
          specifiedType: const FullType(ProviderProfile),
        )
        as ProviderProfile?;
  }

  Future<void> write(String slug, ProviderProfile profile) async {
    final json = standardSerializers.serialize(
      profile,
      specifiedType: const FullType(ProviderProfile),
    );
    await _disk.write(slug, json! as Map<String, dynamic>);
  }
}
