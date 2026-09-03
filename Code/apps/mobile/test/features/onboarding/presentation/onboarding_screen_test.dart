import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:mocktail/mocktail.dart';
import 'package:sanaya/app/theme.dart';
import 'package:sanaya/core/api/generated/api.dart';
import 'package:sanaya/core/i18n/translations.g.dart';
import 'package:sanaya/core/widgets/app_text_field.dart';
import 'package:sanaya/features/onboarding/application/onboarding_providers.dart';
import 'package:sanaya/features/onboarding/data/onboarding_repository.dart';
import 'package:sanaya/features/onboarding/presentation/onboarding_screen.dart';
import 'package:sanaya/features/search/application/catalog_providers.dart';
import 'package:sanaya/features/search/data/catalog_repository.dart';

class MockOnboardingRepository extends Mock implements OnboardingRepository {}

class _FakePostRequest extends Fake implements V1ProvidersMePostRequest {}

class _FakePatchRequest extends Fake implements V1ProvidersMePatchRequest {}

class MockCreateResponse extends Mock implements V1ProvidersMePost200Response {}

class MockProviderMe extends Mock
    implements V1ProvidersMePost200ResponseProvider {}

/// Démarre directement au récapitulatif, `canPublish: true` — évite de
/// rejouer les 3 étapes précédentes pour tester uniquement `publishProfile`
/// (FM-24a). `publishProfile()` reste celui d'`OnboardingNotifier` (non
/// surchargé), résolu via `onboardingRepositoryProvider` comme en
/// production — seul l'état de départ est préréglé.
class _SummaryReadyNotifier extends OnboardingNotifier {
  _SummaryReadyNotifier(this._initialProfile);

  final ProviderMe _initialProfile;

  @override
  OnboardingState build() => OnboardingState(
    currentStep: OnboardingStep.summary,
    completionScore: 80,
    missingFields: const [],
    isSaving: false,
    profile: _initialProfile,
  );
}

Governorate _governorate(String id, String nameFr) => Governorate(
  (b) => b
    ..id = id
    ..code = id
    ..nameFr = nameFr
    ..nameAr = nameFr
    ..slug = id
    ..latitude = 0
    ..longitude = 0
    ..sortOrder = 1,
);

Future<void> _pumpTall(WidgetTester tester, Widget widget) async {
  tester.view.physicalSize = const Size(400, 2400);
  tester.view.devicePixelRatio = 1.0;
  addTearDown(tester.view.reset);
  await tester.pumpWidget(widget);
}

void main() {
  final t = AppLocale.fr.buildSync();

  setUpAll(() {
    registerFallbackValue(_FakePostRequest());
    registerFallbackValue(_FakePatchRequest());
  });

  testWidgets("affiche l'étape profil au démarrage", (tester) async {
    final mockRepo = MockOnboardingRepository();

    await _pumpTall(
      tester,
      ProviderScope(
        overrides: [
          onboardingRepositoryProvider.overrideWithValue(mockRepo),
          categoriesProvider.overrideWith((ref) async => []),
          governoratesProvider.overrideWith((ref) async => []),
        ],
        child: MaterialApp(
          theme: buildTheme(
            brightness: Brightness.light,
            locale: const Locale('fr'),
          ),
          locale: const Locale('fr'),
          home: const OnboardingScreen(),
        ),
      ),
    );
    await tester.pumpAndSettle();

    expect(find.text(t.onboarding.wizardTitle), findsOneWidget);
    expect(find.text(t.onboarding.stepProfile), findsOneWidget);
    expect(find.text(t.onboarding.profileBusinessName), findsOneWidget);
  });

  testWidgets(
    "🔒 remplir + Suivant sur le profil avance à l'étape catégories "
    'avec le completionScore du serveur (P3)',
    (tester) async {
      // 🔒 NON-RÉGRESSION — vérifie le câblage complet écran → notifier →
      // repository : sans lui, une erreur de wiring dans OnboardingScreen
      // (mauvais provider, mauvais callback) ne serait détectée par aucun
      // des tests unitaires de plus bas niveau (notifier seul, widgets seuls).
      final mockRepo = MockOnboardingRepository();
      final providerMock = MockProviderMe();
      when(() => providerMock.completionScore).thenReturn(36);
      final responseMock = MockCreateResponse();
      when(() => responseMock.provider).thenReturn(providerMock);
      when(
        () => mockRepo.createProfile(any()),
      ).thenAnswer((_) async => responseMock);

      await _pumpTall(
        tester,
        ProviderScope(
          overrides: [
            onboardingRepositoryProvider.overrideWithValue(mockRepo),
            categoriesProvider.overrideWith((ref) async => []),
            governoratesProvider.overrideWith(
              (ref) async => [_governorate('sousse', 'Sousse')],
            ),
          ],
          child: MaterialApp(
            theme: buildTheme(
              brightness: Brightness.light,
              locale: const Locale('fr'),
            ),
            locale: const Locale('fr'),
            home: const OnboardingScreen(),
          ),
        ),
      );
      await tester.pumpAndSettle();

      await tester.enterText(
        find.widgetWithText(AppTextField, t.onboarding.profileBusinessName),
        'Ahmed Plomberie',
      );
      await tester.pump();

      await tester.tap(find.text(t.onboarding.profileGovernorate));
      await tester.pumpAndSettle();
      await tester.tap(find.text('Sousse'));
      await tester.pumpAndSettle();

      await tester.tap(find.text(t.onboarding.next));
      await tester.pumpAndSettle();

      verify(() => mockRepo.createProfile(any())).called(1);
      expect(find.text(t.onboarding.categoriesTitle), findsOneWidget);

      final progress = tester.widget<LinearProgressIndicator>(
        find.byType(LinearProgressIndicator),
      );
      expect(progress.value, closeTo(0.36, 0.001));
    },
  );

  testWidgets(
    'FM-24a — publier avec succès marque hasPublishedProfileProvider et '
    'navigue vers /pro/dashboard',
    (tester) async {
      final mockRepo = MockOnboardingRepository();
      final providerMock = MockProviderMe();
      when(() => providerMock.completionScore).thenReturn(80);
      when(() => providerMock.publicationStatus).thenReturn(
        V1ProvidersMePost200ResponseProviderPublicationStatusEnum.PUBLISHED,
      );
      // computeMissingKeys() (onboarding_summary_step.dart) les lit
      // inconditionnellement, même quand canPublish est vrai.
      when(
        () => providerMock.bio,
      ).thenReturn('Plombier expérimenté, disponible 7j/7 sur le Sahel.');
      when(() => providerMock.headline).thenReturn('Plombier certifié');
      when(() => providerMock.yearsExperience).thenReturn(5);
      when(() => providerMock.whatsappPhone).thenReturn('+21622123456');
      when(() => providerMock.publicPhone).thenReturn('');
      when(
        () => mockRepo.updateProfile(any()),
      ).thenAnswer((_) async => providerMock);

      final container = ProviderContainer(
        overrides: [
          onboardingRepositoryProvider.overrideWithValue(mockRepo),
          onboardingProvider.overrideWith(
            () => _SummaryReadyNotifier(providerMock),
          ),
        ],
      );
      addTearDown(container.dispose);

      final testRouter = GoRouter(
        initialLocation: '/pro/onboarding',
        routes: [
          GoRoute(
            path: '/pro/onboarding',
            builder: (_, _) => const OnboardingScreen(),
          ),
          GoRoute(
            path: '/pro/dashboard',
            builder: (_, _) => const Text('DASHBOARD_PLACEHOLDER'),
          ),
        ],
      );

      tester.view.physicalSize = const Size(400, 2400);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(tester.view.reset);

      await tester.pumpWidget(
        UncontrolledProviderScope(
          container: container,
          child: MaterialApp.router(
            theme: buildTheme(
              brightness: Brightness.light,
              locale: const Locale('fr'),
            ),
            locale: const Locale('fr'),
            routerConfig: testRouter,
          ),
        ),
      );
      await tester.pumpAndSettle();

      expect(container.read(hasPublishedProfileProvider), isFalse);

      await tester.tap(find.text(t.onboarding.summaryPublish));
      await tester.pumpAndSettle();

      expect(container.read(hasPublishedProfileProvider), isTrue);
      expect(find.text('DASHBOARD_PLACEHOLDER'), findsOneWidget);
    },
  );
}
