import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:sanaya/core/api/generated/api.dart';
import 'package:sanaya/features/onboarding/application/onboarding_repository_provider.dart';
import 'package:sanaya/features/onboarding/data/onboarding_repository.dart';
import 'package:sanaya/features/reviews/application/pro_reviews_providers.dart';

class _MockOnboardingRepository extends Mock implements OnboardingRepository {}

class _MockProviderMe extends Mock
    implements V1ProvidersMePost200ResponseProvider {}

void main() {
  late _MockOnboardingRepository mockRepo;

  setUp(() {
    mockRepo = _MockOnboardingRepository();
  });

  ProviderContainer createContainer() {
    final container = ProviderContainer(
      overrides: [
        onboardingRepositoryProvider.overrideWithValue(mockRepo),
      ],
    );
    addTearDown(container.dispose);
    return container;
  }

  group('myProviderProfileProvider', () {
    test(
      "retourne le profil de l'artisan connecté avec succès (BE-44)",
      () async {
        final mockProfile = _MockProviderMe();
        when(() => mockProfile.slug).thenReturn('artisan-sousse-123');
        when(() => mockProfile.businessName).thenReturn('Plomberie Sousse');
        when(() => mockProfile.ratingAvg).thenReturn(4.8);
        when(() => mockProfile.ratingCount).thenReturn(15);
        when(
          () => mockRepo.getMyProfile(),
        ).thenAnswer((_) async => mockProfile);

        final container = createContainer();
        final result = await container.read(myProviderProfileProvider.future);

        expect(result, isNotNull);
        expect(result!.slug, 'artisan-sousse-123');
        expect(result.businessName, 'Plomberie Sousse');
        expect(result.ratingAvg, 4.8);
        expect(result.ratingCount, 15);
        verify(() => mockRepo.getMyProfile()).called(1);
      },
    );

    test("retourne null si aucun profil n'a encore été créé (404)", () async {
      when(() => mockRepo.getMyProfile()).thenAnswer((_) async => null);

      final container = createContainer();
      final result = await container.read(myProviderProfileProvider.future);

      expect(result, isNull);
      verify(() => mockRepo.getMyProfile()).called(1);
    });

    test("propage l'exception en cas d'erreur réseau", () async {
      when(
        () => mockRepo.getMyProfile(),
      ).thenThrow(Exception('Réseau indisponible'));

      final container = createContainer();
      expect(
        () => container.read(myProviderProfileProvider.future),
        throwsA(isA<Exception>()),
      );
    });
  });

  group('myProviderSlugProvider', () {
    test('extrait le slug lorsque le profil existe', () async {
      final mockProfile = _MockProviderMe();
      when(() => mockProfile.slug).thenReturn('electricien-monastir-456');
      when(() => mockRepo.getMyProfile()).thenAnswer((_) async => mockProfile);

      final container = createContainer();
      final slug = await container.read(myProviderSlugProvider.future);

      expect(slug, 'electricien-monastir-456');
    });

    test('retourne null si le profil est null', () async {
      when(() => mockRepo.getMyProfile()).thenAnswer((_) async => null);

      final container = createContainer();
      final slug = await container.read(myProviderSlugProvider.future);

      expect(slug, isNull);
    });
  });
}
