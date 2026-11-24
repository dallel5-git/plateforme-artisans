import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sanaya/core/api/generated/api.dart';
import 'package:sanaya/features/onboarding/application/onboarding_repository_provider.dart';
import 'package:sanaya/features/onboarding/data/onboarding_repository.dart';
import 'package:sanaya/features/provider_profile/application/provider_profile_providers.dart';
import 'package:sanaya/features/reviews/application/pro_reviews_providers.dart';

/// Enregistre les modifications du profil pro (`PATCH /v1/providers/me`) et
/// invalide les caches dérivés : `myProviderProfileProvider` (FM-39a — profil
/// de l'artisan connecté, déjà réutilisé par FM-37/FM-39, `ProProfileScreen`
/// s'appuie dessus pour son pré-remplissage plutôt que de dupliquer un
/// second provider pour la même route) et la fiche publique
/// [providerProfileProvider] du même artisan — sans quoi un client verrait
/// encore l'ancienne bio/disponibilité après que l'artisan vient de la
/// mettre à jour (critère d'acceptation FM-38, issue #235).
class ProProfileUpdater {
  ProProfileUpdater(this._ref);

  final Ref _ref;

  Future<ProviderMe> save(V1ProvidersMePatchRequest body) async {
    final updated = await _ref
        .read(onboardingRepositoryProvider)
        .updateProfile(body);
    _ref
      ..invalidate(myProviderProfileProvider)
      ..invalidate(providerProfileProvider(updated.slug));
    return updated;
  }

  Future<CategoriesResult> saveCategories(
    V1ProvidersMeCategoriesPutRequest body, {
    String? slug,
  }) async {
    final result = await _ref
        .read(onboardingRepositoryProvider)
        .setCategories(body);
    _ref.invalidate(myProviderProfileProvider);
    if (slug != null) {
      _ref.invalidate(providerProfileProvider(slug));
    }
    return result;
  }

  Future<CoverageAreasResult> saveCoverageAreas(
    V1ProvidersMeCoverageAreasPutRequest body, {
    String? slug,
  }) async {
    final result = await _ref
        .read(onboardingRepositoryProvider)
        .setCoverageAreas(body);
    _ref.invalidate(myProviderProfileProvider);
    if (slug != null) {
      _ref.invalidate(providerProfileProvider(slug));
    }
    return result;
  }
}

final Provider<ProProfileUpdater> proProfileUpdaterProvider =
    Provider<ProProfileUpdater>(ProProfileUpdater.new);
