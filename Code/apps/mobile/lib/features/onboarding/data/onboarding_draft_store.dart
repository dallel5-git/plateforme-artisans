import 'dart:convert';

import 'package:sanaya/core/api/generated/api.dart';
import 'package:sanaya/features/onboarding/data/onboarding_repository.dart';
import 'package:shared_preferences/shared_preferences.dart';

const _storageKey = 'sanaya.onboarding_last_known_profile';

/// Dernier profil connu localement — seul moyen de reprendre l'assistant
/// après un redémarrage de l'app : il n'existe aucun `GET /providers/me`
/// (`providers.ts`), seules les réponses de création/mise à jour renvoient
/// le profil complet. Réutilise le sérialiseur généré (`standardSerializers`,
/// celui déjà employé par `SanayaApiClient`) plutôt que de redéclarer
/// l'encodage JSON à la main (P4, CLAUDE.md).
abstract class OnboardingDraftStore {
  Future<void> save(OnboardingProfile profile);
  Future<OnboardingProfile?> read();
  Future<void> clear();
}

class SharedPreferencesOnboardingDraftStore implements OnboardingDraftStore {
  @override
  Future<void> save(OnboardingProfile profile) async {
    final prefs = await SharedPreferences.getInstance();
    final json = standardSerializers.serializeWith(
      OnboardingProfile.serializer,
      profile,
    );
    await prefs.setString(_storageKey, jsonEncode(json));
  }

  @override
  Future<OnboardingProfile?> read() async {
    final prefs = await SharedPreferences.getInstance();
    final raw = prefs.getString(_storageKey);
    if (raw == null) return null;
    return standardSerializers.deserializeWith(
      OnboardingProfile.serializer,
      jsonDecode(raw),
    );
  }

  @override
  Future<void> clear() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_storageKey);
  }
}
