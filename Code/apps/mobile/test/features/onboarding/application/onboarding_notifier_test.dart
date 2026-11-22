import 'package:built_collection/built_collection.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:sanaya/core/api/api_client_provider.dart';
import 'package:sanaya/core/api/auth_token_store.dart';
import 'package:sanaya/core/api/generated/api.dart';
import 'package:sanaya/features/auth/application/auth_state_provider.dart';
import 'package:sanaya/features/auth/application/auth_status.dart';
import 'package:sanaya/features/onboarding/application/onboarding_providers.dart';
import 'package:sanaya/features/onboarding/data/onboarding_repository.dart';

// ---------------------------------------------------------------------------
// Mock du repository et de l'authentification
// ---------------------------------------------------------------------------

class MockOnboardingRepository extends Mock implements OnboardingRepository {}

class MockAuthTokenStore extends Mock implements AuthTokenStore {}

class TestAuthStateNotifier extends AuthStateNotifier {
  bool setAuthenticatedCalled = false;
  List<V1AuthOtpVerifyPost200ResponseUserRolesEnum>? lastRoles;

  @override
  Future<AuthStatus> build() async =>
      const AuthStatus.authenticated(isProvider: false);

  @override
  void setAuthenticated(
    Iterable<V1AuthOtpVerifyPost200ResponseUserRolesEnum> roles,
  ) {
    setAuthenticatedCalled = true;
    lastRoles = roles.toList();
    state = AsyncData(
      AuthStatus.authenticated(
        isProvider: roles.contains(
          V1AuthOtpVerifyPost200ResponseUserRolesEnum.PROVIDER,
        ),
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// Fakes pour registerFallbackValue (types BuiltValue abstraits)
// ---------------------------------------------------------------------------

class _FakePostRequest extends Fake implements V1ProvidersMePostRequest {}

class _FakePatchRequest extends Fake implements V1ProvidersMePatchRequest {}

class _FakeCategoriesPutRequest extends Fake
    implements V1ProvidersMeCategoriesPutRequest {}

class _FakeCoverageAreasPutRequest extends Fake
    implements V1ProvidersMeCoverageAreasPutRequest {}

// ---------------------------------------------------------------------------
// Mocks pour les réponses API (nécessite Mock, pas Fake, pour stubber les
// getter après construction — Fake.noSuchMethod lance UnimplementedError).
// ---------------------------------------------------------------------------

class MockCreateResponse extends Mock implements V1ProvidersMePost200Response {}

class MockProviderMe extends Mock
    implements V1ProvidersMePost200ResponseProvider {}

class MockCategoriesResult extends Mock
    implements V1ProvidersMeCategoriesPut200Response {}

class MockCoverageAreasResult extends Mock
    implements V1ProvidersMeCoverageAreasPut200Response {}

// ---------------------------------------------------------------------------
// Container helper
// ---------------------------------------------------------------------------

ProviderContainer _makeContainer({
  required MockOnboardingRepository mockRepo,
  required MockAuthTokenStore mockTokenStore,
  required TestAuthStateNotifier testAuthStateNotifier,
}) => ProviderContainer(
  overrides: [
    onboardingRepositoryProvider.overrideWithValue(mockRepo),
    authTokenStoreProvider.overrideWithValue(mockTokenStore),
    authStateProvider.overrideWith(() => testAuthStateNotifier),
  ],
);

// ---------------------------------------------------------------------------
// Helpers de réponses — stubs configurés AVANT d'être passés au when().
// ---------------------------------------------------------------------------

MockCreateResponse _makeCreateResponse(
  int score, {
  String accessToken = 'mock-access',
  String refreshToken = 'mock-refresh',
}) {
  final providerMock = MockProviderMe();
  when(() => providerMock.completionScore).thenReturn(score);
  when(() => providerMock.categories).thenReturn(BuiltList());
  when(() => providerMock.coverageAreas).thenReturn(BuiltList());
  when(() => providerMock.portfolio).thenReturn(BuiltList());
  final responseMock = MockCreateResponse();
  when(() => responseMock.provider).thenReturn(providerMock);
  when(() => responseMock.accessToken).thenReturn(accessToken);
  when(() => responseMock.refreshToken).thenReturn(refreshToken);
  return responseMock;
}

MockProviderMe _makeProviderMe(
  int score, {
  Iterable<V1ProvidersMePost200ResponseProviderCategoriesInner> categories =
      const [],
  Iterable<V1ProvidersMePost200ResponseProviderCoverageAreasInner>
      coverageAreas = const [],
  Iterable<V1ProvidersMePost200ResponseProviderPortfolioInner> portfolio =
      const [],
}) {
  final mock = MockProviderMe();
  when(() => mock.completionScore).thenReturn(score);
  when(() => mock.categories).thenReturn(BuiltList(categories));
  when(() => mock.coverageAreas).thenReturn(BuiltList(coverageAreas));
  when(() => mock.portfolio).thenReturn(BuiltList(portfolio));
  return mock;
}

V1ProvidersMePost200ResponseProviderCategoriesInner _catItem(
  String id, {
  bool isPrimary = true,
  int yearsExperience = 0,
}) =>
    V1ProvidersMePost200ResponseProviderCategoriesInner(
      (b) => b
        ..categoryId = id
        ..isPrimary = isPrimary
        ..yearsExperience = yearsExperience,
    );

V1ProvidersMePost200ResponseProviderCoverageAreasInner _covItem(
  String id,
  String govId, {
  String delegationId = '',
  num travelFee = 0,
}) =>
    V1ProvidersMePost200ResponseProviderCoverageAreasInner(
      (b) => b
        ..id = id
        ..governorateId = govId
        ..delegationId = delegationId
        ..travelFee = travelFee,
    );

V1ProvidersMePost200ResponseProviderPortfolioInner _portfolioItem(
  String id, {
  String mediaId = 'media-1',
  String categoryId = '',
  String caption = '',
  int sortOrder = 0,
}) =>
    V1ProvidersMePost200ResponseProviderPortfolioInner(
      (b) => b
        ..id = id
        ..mediaId = mediaId
        ..categoryId = categoryId
        ..caption = caption
        ..sortOrder = sortOrder,
    );

MockCategoriesResult _makeCatResult(int score) {
  final mock = MockCategoriesResult();
  when(() => mock.completionScore).thenReturn(score);
  return mock;
}

MockCoverageAreasResult _makeCovResult(int score) {
  final mock = MockCoverageAreasResult();
  when(() => mock.completionScore).thenReturn(score);
  return mock;
}

// ---------------------------------------------------------------------------
// Tests
// ---------------------------------------------------------------------------

void main() {
  setUpAll(() {
    registerFallbackValue(_FakePostRequest());
    registerFallbackValue(_FakePatchRequest());
    registerFallbackValue(_FakeCategoriesPutRequest());
    registerFallbackValue(_FakeCoverageAreasPutRequest());
  });

  late MockOnboardingRepository mockRepo;
  late MockAuthTokenStore mockTokenStore;
  late TestAuthStateNotifier testAuthStateNotifier;
  late ProviderContainer container;

  setUp(() {
    mockRepo = MockOnboardingRepository();
    mockTokenStore = MockAuthTokenStore();
    testAuthStateNotifier = TestAuthStateNotifier();
    when(
      () => mockTokenStore.saveSession(
        accessToken: any(named: 'accessToken'),
        refreshToken: any(named: 'refreshToken'),
      ),
    ).thenAnswer((_) async {});
    container = _makeContainer(
      mockRepo: mockRepo,
      mockTokenStore: mockTokenStore,
      testAuthStateNotifier: testAuthStateNotifier,
    );
  });

  tearDown(() => container.dispose());

  // ---------------------------------------------------------------------------
  // État initial
  // ---------------------------------------------------------------------------

  group('état initial', () {
    test('démarre à l étape profil avec score 0', () {
      final s = container.read(onboardingProvider);
      expect(s.currentStep, OnboardingStep.profile);
      expect(s.completionScore, 0);
      expect(s.isSaving, isFalse);
      expect(s.profile, isNull);
      expect(s.errorCode, isNull);
    });

    test('isFirstStep true, isLastStep false', () {
      final s = container.read(onboardingProvider);
      expect(s.isFirstStep, isTrue);
      expect(s.isLastStep, isFalse);
    });

    test('canPublish false à score 0', () {
      expect(container.read(onboardingProvider).canPublish, isFalse);
    });
  });

  // ---------------------------------------------------------------------------
  // resumeSession (FM-36 — reprise après fermeture de l'app)
  // ---------------------------------------------------------------------------

  group('resumeSession', () {
    test('profil existant → reprend à catégories, préremplie', () async {
      final profile = _makeProviderMe(45);
      when(mockRepo.getMyProfile).thenAnswer((_) async => profile);

      await container.read(onboardingProvider.notifier).resumeSession();

      final s = container.read(onboardingProvider);
      expect(s.currentStep, OnboardingStep.categories);
      expect(s.completionScore, 45);
      expect(s.profile, isNotNull);
    });

    test('aucun profil (404 → null) → reste à l étape profil', () async {
      when(mockRepo.getMyProfile).thenAnswer((_) async => null);

      await container.read(onboardingProvider.notifier).resumeSession();

      final s = container.read(onboardingProvider);
      expect(s.currentStep, OnboardingStep.profile);
      expect(s.profile, isNull);
      expect(s.completionScore, 0);
    });

    test('erreur réseau → échec silencieux, reste à l étape profil', () async {
      when(mockRepo.getMyProfile).thenThrow(Exception('réseau'));

      await container.read(onboardingProvider.notifier).resumeSession();

      final s = container.read(onboardingProvider);
      expect(s.currentStep, OnboardingStep.profile);
      expect(s.errorCode, isNull);
    });
  });

  // ---------------------------------------------------------------------------
  // saveProfile
  // ---------------------------------------------------------------------------

  group('saveProfile', () {
    test('avance à catégories après succès', () async {
      final body = V1ProvidersMePostRequest(
        (b) => b
          ..businessName = 'Plomberie Sidi Bou Said'
          ..baseGovernorateId = 'gov-sousse',
      );
      final resp = _makeCreateResponse(40);
      when(() => mockRepo.createProfile(any())).thenAnswer((_) async => resp);

      await container.read(onboardingProvider.notifier).saveProfile(body);

      final s = container.read(onboardingProvider);
      expect(s.currentStep, OnboardingStep.categories);
      expect(s.completionScore, 40);
      expect(s.isSaving, isFalse);
      expect(s.profile, isNotNull);
    });

    test('isSaving true pendant l appel réseau', () async {
      final body = V1ProvidersMePostRequest(
        (b) => b
          ..businessName = 'Test'
          ..baseGovernorateId = 'gov-id',
      );
      final resp = _makeCreateResponse(30);
      when(() => mockRepo.createProfile(any())).thenAnswer((_) async {
        await Future<void>.delayed(const Duration(milliseconds: 10));
        return resp;
      });

      final notifier = container.read(onboardingProvider.notifier);
      final future = notifier.saveProfile(body);
      expect(container.read(onboardingProvider).isSaving, isTrue);
      await future;
      expect(container.read(onboardingProvider).isSaving, isFalse);
    });

    test('positionne errorCode sur echec réseau', () async {
      final body = V1ProvidersMePostRequest(
        (b) => b
          ..businessName = 'Test'
          ..baseGovernorateId = 'gov',
      );
      when(() => mockRepo.createProfile(any())).thenThrow(Exception('réseau'));

      await expectLater(
        container.read(onboardingProvider.notifier).saveProfile(body),
        throwsA(anything),
      );

      final s = container.read(onboardingProvider);
      expect(s.errorCode, 'ONBOARDING_PROFILE_SAVE_FAILED');
      expect(s.isSaving, isFalse);
      expect(s.currentStep, OnboardingStep.profile);
    });

    test(
      'MOB-003 — saveProfile (étape 1) : persiste les nouveaux jetons PROVIDER '
      'dans AuthTokenStore // régression #MOB-003',
      () async {
        final body = V1ProvidersMePostRequest(
          (b) => b
            ..businessName = 'Plomberie Express'
            ..baseGovernorateId = 'gov-sousse',
        );
        final resp = _makeCreateResponse(
          40,
          accessToken: 'new-provider-access-token',
          refreshToken: 'new-provider-refresh-token',
        );
        when(() => mockRepo.createProfile(any())).thenAnswer((_) async => resp);

        await container.read(onboardingProvider.notifier).saveProfile(body);

        verify(
          () => mockTokenStore.saveSession(
            accessToken: 'new-provider-access-token',
            refreshToken: 'new-provider-refresh-token',
          ),
        ).called(1);
      },
    );

    test(
      'MOB-003 — saveProfile (étape 1) : propage le rôle PROVIDER à '
      'authStateProvider // régression #MOB-003',
      () async {
        final body = V1ProvidersMePostRequest(
          (b) => b
            ..businessName = 'Plomberie Express'
            ..baseGovernorateId = 'gov-sousse',
        );
        final resp = _makeCreateResponse(40);
        when(() => mockRepo.createProfile(any())).thenAnswer((_) async => resp);

        await container.read(onboardingProvider.notifier).saveProfile(body);

        expect(testAuthStateNotifier.setAuthenticatedCalled, isTrue);
        expect(
          testAuthStateNotifier.lastRoles,
          contains(V1AuthOtpVerifyPost200ResponseUserRolesEnum.PROVIDER),
        );
      },
    );

    test(
      'MOB-003 — mise à jour (PATCH) : n appelle pas saveSession ni '
      'setAuthenticated // régression #MOB-003',
      () async {
        // Pré-remplir le state avec un profil existant (étape > 1 ou retour)
        final postBody = V1ProvidersMePostRequest(
          (b) => b
            ..businessName = 'Plomberie Initiale'
            ..baseGovernorateId = 'gov-sousse',
        );
        final initialResp = _makeCreateResponse(40);
        when(
          () => mockRepo.createProfile(any()),
        ).thenAnswer((_) async => initialResp);
        await container.read(onboardingProvider.notifier).saveProfile(postBody);

        // Reset des compteurs / flags
        clearInteractions(mockTokenStore);
        testAuthStateNotifier.setAuthenticatedCalled = false;

        // Mise à jour (PATCH)
        final patchResp = _makeProviderMe(50);
        when(
          () => mockRepo.updateProfile(any()),
        ).thenAnswer((_) async => patchResp);

        final updateBody = V1ProvidersMePostRequest(
          (b) => b
            ..businessName = 'Plomberie Modifiée'
            ..baseGovernorateId = 'gov-sousse',
        );
        await container
            .read(onboardingProvider.notifier)
            .saveProfile(updateBody);

        verifyNever(
          () => mockTokenStore.saveSession(
            accessToken: any(named: 'accessToken'),
            refreshToken: any(named: 'refreshToken'),
          ),
        );
        expect(testAuthStateNotifier.setAuthenticatedCalled, isFalse);
      },
    );
  });

  // ---------------------------------------------------------------------------
  // saveCategories
  // ---------------------------------------------------------------------------

  group('saveCategories', () {
    test('avance à zones avec completionScore mis à jour', () async {
      final body = V1ProvidersMeCategoriesPutRequest();
      final resp = _makeCatResult(70);
      when(() => mockRepo.setCategories(any())).thenAnswer((_) async => resp);

      await container.read(onboardingProvider.notifier).saveCategories(body);

      final s = container.read(onboardingProvider);
      expect(s.currentStep, OnboardingStep.zones);
      expect(s.completionScore, 70);
    });

    test('positionne errorCode sur echec réseau', () async {
      final body = V1ProvidersMeCategoriesPutRequest();
      when(() => mockRepo.setCategories(any())).thenThrow(Exception('réseau'));

      await expectLater(
        container.read(onboardingProvider.notifier).saveCategories(body),
        throwsA(anything),
      );

      expect(
        container.read(onboardingProvider).errorCode,
        'ONBOARDING_CATEGORIES_SAVE_FAILED',
      );
    });
  });

  // ---------------------------------------------------------------------------
  // saveCoverageAreas
  // ---------------------------------------------------------------------------

  group('saveCoverageAreas', () {
    test('avance aux photos avec completionScore mis à jour', () async {
      final body = V1ProvidersMeCoverageAreasPutRequest();
      final resp = _makeCovResult(80);
      when(
        () => mockRepo.setCoverageAreas(any()),
      ).thenAnswer((_) async => resp);

      await container.read(onboardingProvider.notifier).saveCoverageAreas(body);

      final s = container.read(onboardingProvider);
      expect(s.currentStep, OnboardingStep.photos);
      expect(s.completionScore, 80);
    });
  });

  // ---------------------------------------------------------------------------
  // advanceFromPhotos
  // ---------------------------------------------------------------------------

  group('advanceFromPhotos', () {
    test('passe directement au récapitulatif, sans appel réseau', () async {
      final body = V1ProvidersMeCoverageAreasPutRequest();
      when(
        () => mockRepo.setCoverageAreas(any()),
      ).thenAnswer((_) async => _makeCovResult(80));
      await container.read(onboardingProvider.notifier).saveCoverageAreas(body);
      expect(
        container.read(onboardingProvider).currentStep,
        OnboardingStep.photos,
      );

      container.read(onboardingProvider.notifier).advanceFromPhotos();

      expect(
        container.read(onboardingProvider).currentStep,
        OnboardingStep.summary,
      );
      verifyNever(() => mockRepo.updateProfile(any()));
    });
  });

  // ---------------------------------------------------------------------------
  // canPublish
  // ---------------------------------------------------------------------------

  group('canPublish', () {
    test('false sous 60 %', () {
      expect(container.read(onboardingProvider).canPublish, isFalse);
    });

    test('true à exactement 60 %', () async {
      final body = V1ProvidersMeCategoriesPutRequest();
      final resp = _makeCatResult(60);
      when(() => mockRepo.setCategories(any())).thenAnswer((_) async => resp);

      await container.read(onboardingProvider.notifier).saveCategories(body);

      expect(container.read(onboardingProvider).canPublish, isTrue);
    });
  });

  // ---------------------------------------------------------------------------
  // publishProfile
  // ---------------------------------------------------------------------------

  group('publishProfile', () {
    test('n appelle pas updateProfile si canPublish est false', () async {
      // Score initial = 0 → canPublish = false.
      await container.read(onboardingProvider.notifier).publishProfile([
        'businessName',
        'categories',
      ]);

      verifyNever(() => mockRepo.updateProfile(any()));

      expect(
        container.read(onboardingProvider).missingFields,
        ['businessName', 'categories'],
      );
    });

    test('appelle updateProfile si canPublish est true', () async {
      // Amener le score à 80 %.
      final catBody = V1ProvidersMeCategoriesPutRequest();
      final catResp = _makeCatResult(80);
      when(
        () => mockRepo.setCategories(any()),
      ).thenAnswer((_) async => catResp);
      await container.read(onboardingProvider.notifier).saveCategories(catBody);

      // Publication.
      final pubResp = _makeProviderMe(80);
      when(
        () => mockRepo.updateProfile(any()),
      ).thenAnswer((_) async => pubResp);
      await container.read(onboardingProvider.notifier).publishProfile([]);

      verify(() => mockRepo.updateProfile(any())).called(1);
    });
  });

  // ---------------------------------------------------------------------------
  // previousStep
  // ---------------------------------------------------------------------------

  group('previousStep', () {
    test('sans effet sur la première étape', () {
      container.read(onboardingProvider.notifier).previousStep();
      expect(
        container.read(onboardingProvider).currentStep,
        OnboardingStep.profile,
      );
    });

    test('revient à catégories depuis zones', () async {
      final body = V1ProvidersMeCategoriesPutRequest();
      final resp = _makeCatResult(50);
      when(() => mockRepo.setCategories(any())).thenAnswer((_) async => resp);
      await container.read(onboardingProvider.notifier).saveCategories(body);

      expect(
        container.read(onboardingProvider).currentStep,
        OnboardingStep.zones,
      );

      container.read(onboardingProvider.notifier).previousStep();

      expect(
        container.read(onboardingProvider).currentStep,
        OnboardingStep.categories,
      );
    });

    test('efface errorCode au retour en arrière', () async {
      // Profil → succès → catégories.
      final postBody = V1ProvidersMePostRequest(
        (b) => b
          ..businessName = 'Test'
          ..baseGovernorateId = 'gov',
      );
      final createResp = _makeCreateResponse(20);
      when(
        () => mockRepo.createProfile(any()),
      ).thenAnswer((_) async => createResp);
      await container.read(onboardingProvider.notifier).saveProfile(postBody);

      // Catégories → erreur.
      final catBody = V1ProvidersMeCategoriesPutRequest();
      when(
        () => mockRepo.setCategories(any()),
      ).thenThrow(Exception('erreur API'));
      await expectLater(
        container.read(onboardingProvider.notifier).saveCategories(catBody),
        throwsA(anything),
      );

      expect(container.read(onboardingProvider).errorCode, isNotNull);

      // Retour en arrière → errorCode effacé.
      container.read(onboardingProvider.notifier).previousStep();
      expect(container.read(onboardingProvider).errorCode, isNull);
    });
  });

  // ---------------------------------------------------------------------------
  // resumeSession & determineResumeStep (MOB-027)
  // ---------------------------------------------------------------------------

  group('resumeSession & determineResumeStep (MOB-027)', () {
    test('aucun profil existant (404 / null) : reste à profile', () async {
      when(mockRepo.getMyProfile).thenAnswer((_) async => null);

      await container.read(onboardingProvider.notifier).resumeSession();

      final state = container.read(onboardingProvider);
      expect(state.currentStep, OnboardingStep.profile);
      expect(state.profile, isNull);
    });

    test('erreur réseau : échec silencieux, reste à profile', () async {
      when(mockRepo.getMyProfile).thenThrow(Exception('réseau coupé'));

      await container.read(onboardingProvider.notifier).resumeSession();

      final state = container.read(onboardingProvider);
      expect(state.currentStep, OnboardingStep.profile);
      expect(state.profile, isNull);
    });

    test('profil créé sans catégorie : reprend à categories', () async {
      final profile = _makeProviderMe(20, categories: []);
      when(mockRepo.getMyProfile).thenAnswer((_) async => profile);

      await container.read(onboardingProvider.notifier).resumeSession();

      final state = container.read(onboardingProvider);
      expect(state.currentStep, OnboardingStep.categories);
      expect(state.completionScore, 20);
      expect(state.profile, profile);
    });

    test('profil avec catégories mais sans zone : reprend à zones', () async {
      final profile = _makeProviderMe(
        40,
        categories: [_catItem('plomberie')],
        coverageAreas: [],
      );
      when(mockRepo.getMyProfile).thenAnswer((_) async => profile);

      await container.read(onboardingProvider.notifier).resumeSession();

      final state = container.read(onboardingProvider);
      expect(state.currentStep, OnboardingStep.zones);
      expect(state.completionScore, 40);
    });

    test(
      'profil avec catégories et zones, portfolio vide, score < 60 : '
      'reprend à photos',
      () async {
        final profile = _makeProviderMe(
          50,
          categories: [_catItem('plomberie')],
          coverageAreas: [_covItem('cov1', 'sousse')],
          portfolio: [],
        );
        when(mockRepo.getMyProfile).thenAnswer((_) async => profile);

        await container.read(onboardingProvider.notifier).resumeSession();

        final state = container.read(onboardingProvider);
        expect(state.currentStep, OnboardingStep.photos);
        expect(state.completionScore, 50);
      },
    );

    test(
      'profil complet prêt à publier (score >= 60) : reprend à summary',
      () async {
        final profile = _makeProviderMe(
          70,
          categories: [_catItem('plomberie')],
          coverageAreas: [_covItem('cov1', 'sousse')],
          portfolio: [_portfolioItem('p1')],
        );
        when(mockRepo.getMyProfile).thenAnswer((_) async => profile);

        await container.read(onboardingProvider.notifier).resumeSession();

        final state = container.read(onboardingProvider);
        expect(state.currentStep, OnboardingStep.summary);
        expect(state.canPublish, isTrue);
      },
    );

    test('determineResumeStep couvre exhaustivement tous les scénarios', () {
      final p1 = _makeProviderMe(20, categories: []);
      expect(
        OnboardingNotifier.determineResumeStep(p1),
        OnboardingStep.categories,
      );

      final p2 = _makeProviderMe(
        35,
        categories: [_catItem('elec')],
        coverageAreas: [],
      );
      expect(OnboardingNotifier.determineResumeStep(p2), OnboardingStep.zones);

      final p3 = _makeProviderMe(
        45,
        categories: [_catItem('elec')],
        coverageAreas: [_covItem('cov1', 'tunis')],
        portfolio: [],
      );
      expect(OnboardingNotifier.determineResumeStep(p3), OnboardingStep.photos);

      final p4 = _makeProviderMe(
        65,
        categories: [_catItem('elec')],
        coverageAreas: [_covItem('cov1', 'tunis')],
        portfolio: [],
      );
      expect(OnboardingNotifier.determineResumeStep(p4), OnboardingStep.summary);

      final p5 = _makeProviderMe(
        80,
        categories: [_catItem('elec')],
        coverageAreas: [_covItem('cov1', 'tunis')],
        portfolio: [_portfolioItem('photo1')],
      );
      expect(OnboardingNotifier.determineResumeStep(p5), OnboardingStep.summary);
    });
  });
}
