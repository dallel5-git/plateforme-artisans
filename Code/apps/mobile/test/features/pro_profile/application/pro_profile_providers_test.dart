import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:sanaya/core/api/generated/api.dart';
import 'package:sanaya/features/onboarding/application/onboarding_repository_provider.dart';
import 'package:sanaya/features/onboarding/data/onboarding_repository.dart';
import 'package:sanaya/features/pro_profile/application/pro_profile_providers.dart';

class MockOnboardingRepository extends Mock implements OnboardingRepository {}

class MockProviderMe extends Mock
    implements V1ProvidersMePost200ResponseProvider {}

class _FakePatchRequest extends Fake implements V1ProvidersMePatchRequest {}

MockProviderMe _profile({String slug = 'ahmed-plomberie-sousse'}) {
  final mock = MockProviderMe();
  when(() => mock.slug).thenReturn(slug);
  return mock;
}

/// FM-38b : `ProProfileUpdater` réutilise `OnboardingRepository`
/// (`getMyProfile`/`updateProfile`, déjà exposées pour la reprise
/// d'onboarding FM-36) — aucun nouveau repository. La lecture du profil
/// pro (pré-remplissage de `ProProfileScreen`, FM-38c) réutilise elle-même
/// `myProviderProfileProvider` (FM-39a), donc non retestée ici.
void main() {
  late MockOnboardingRepository repo;

  setUpAll(() {
    registerFallbackValue(_FakePatchRequest());
  });

  setUp(() {
    repo = MockOnboardingRepository();
  });

  ProviderContainer makeContainer() => ProviderContainer(
    overrides: [onboardingRepositoryProvider.overrideWithValue(repo)],
  );

  group('FM-38b — ProProfileUpdater', () {
    test(
      'save() transmet le body à updateProfile() et renvoie le profil mis '
      'à jour — sans quoi ProProfileScreen (FM-38c) ne verrait jamais ses '
      'propres changements reflétés après enregistrement',
      () async {
        final updated = _profile();
        when(
          () => repo.updateProfile(any()),
        ).thenAnswer((_) async => updated);

        final container = makeContainer();
        addTearDown(container.dispose);

        final body = V1ProvidersMePatchRequest((b) => b..bio = 'Nouvelle bio');
        final result = await container
            .read(proProfileUpdaterProvider)
            .save(body);

        expect(result, same(updated));
        verify(() => repo.updateProfile(body)).called(1);
      },
    );

    test(
      "save() propage l'exception si updateProfile() échoue, sans "
      'invalider les caches sur un échec (rien à rafraîchir)',
      () async {
        when(
          () => repo.updateProfile(any()),
        ).thenThrow(Exception('réseau indisponible'));

        final container = makeContainer();
        addTearDown(container.dispose);

        await expectLater(
          container
              .read(proProfileUpdaterProvider)
              .save(V1ProvidersMePatchRequest((b) => b..bio = 'x')),
          throwsA(isException),
        );
      },
    );
  });
}
