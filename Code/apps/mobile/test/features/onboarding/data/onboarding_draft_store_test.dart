import 'package:built_value/json_object.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:sanaya/core/api/generated/api.dart';
import 'package:sanaya/features/onboarding/data/onboarding_draft_store.dart';
import 'package:sanaya/features/onboarding/data/onboarding_repository.dart';
import 'package:shared_preferences/shared_preferences.dart';

OnboardingProfile _provider() {
  return OnboardingProfile(
    (b) => b
      ..id = 'prov-1'
      ..slug = 'ahmed-plomberie'
      ..businessName = 'Ahmed Plomberie'
      ..headline = ''
      ..bio = ''
      ..yearsExperience = 0
      ..whatsappPhone = ''
      ..publicPhone = ''
      ..baseGovernorateId = 'gov-1'
      ..baseDelegationId = 'del-1'
      ..latitude = 0
      ..longitude = 0
      ..publicationStatus =
          V1ProvidersMePost200ResponseProviderPublicationStatusEnum.DRAFT
      ..availabilityStatus =
          V1ProvidersMePost200ResponseProviderAvailabilityStatusEnum.AVAILABLE
      ..availableAgainAt = DateTime.utc(2026)
      ..acceptsEmergency = false
      ..workingHours = JsonObject(<String, dynamic>{})
      ..isVerified = false
      ..verifiedAt = DateTime.utc(2026)
      ..ratingAvg = 0
      ..ratingCount = 0
      ..totalProfileViews = 0
      ..totalContacts = 0
      ..completionScore = 54
      ..rankingScore = 0
      ..lastActiveAt = DateTime.utc(2026)
      ..createdAt = DateTime.utc(2026)
      ..updatedAt = DateTime.utc(2026),
  );
}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  late SharedPreferencesOnboardingDraftStore store;

  setUp(() {
    SharedPreferences.setMockInitialValues({});
    store = SharedPreferencesOnboardingDraftStore();
  });

  test("read() est null tant que rien n'a été sauvegardé", () async {
    expect(await store.read(), isNull);
  });

  test("save() puis read() font l'aller-retour", () async {
    final profile = _provider();
    await store.save(profile);

    expect(await store.read(), profile);
  });

  test('clear() efface le profil sauvegardé', () async {
    await store.save(_provider());
    await store.clear();

    expect(await store.read(), isNull);
  });

  test('survit à une nouvelle instance (persistance disque réelle)', () async {
    // 🔒 NON-RÉGRESSION — seul moyen de reprendre l'assistant après un
    // redémarrage de l'app tant qu'il n'existe aucun GET /providers/me.
    final profile = _provider();
    await store.save(profile);

    final reloaded = SharedPreferencesOnboardingDraftStore();

    expect(await reloaded.read(), profile);
  });
}
