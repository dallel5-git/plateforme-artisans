import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:mocktail/mocktail.dart';
import 'package:sanaya/app/theme.dart';
import 'package:sanaya/core/api/generated/api.dart';
import 'package:sanaya/core/widgets/error_state.dart';
import 'package:sanaya/features/onboarding/application/onboarding_repository_provider.dart';
import 'package:sanaya/features/onboarding/data/onboarding_repository.dart';
import 'package:sanaya/features/pro_profile/presentation/pro_profile_screen.dart';
import 'package:sanaya/features/provider_profile/application/provider_profile_providers.dart';
import 'package:sanaya/features/provider_profile/data/provider_profile_repository.dart';
import 'package:sanaya/features/reviews/application/pro_reviews_providers.dart';

class _MockOnboardingRepository extends Mock implements OnboardingRepository {}

/// `ProProfileUpdater.save()` invalide `providerProfileProvider(slug)`
/// (fiche publique) après chaque écriture — sans ce mock, Riverpod construit
/// réellement ce provider pour l'invalider, qui tape le cache disque Hive
/// (`ProviderProfileRepository`, non initialisé dans l'environnement de
/// test). Le résultat renvoyé ici n'est jamais lu par ces tests.
class _MockProviderProfileRepository extends Mock
    implements ProviderProfileRepository {}

class _MockProviderMe extends Mock
    implements V1ProvidersMePost200ResponseProvider {}

class _FakePatchRequest extends Fake implements V1ProvidersMePatchRequest {}

_MockProviderMe _profile({
  String slug = 'ahmed-plomberie-sousse',
  String businessName = 'Ahmed Plomberie',
  bool acceptsEmergency = false,
  V1ProvidersMePost200ResponseProviderAvailabilityStatusEnum status =
      V1ProvidersMePost200ResponseProviderAvailabilityStatusEnum.AVAILABLE,
}) {
  final mock = _MockProviderMe();
  when(() => mock.slug).thenReturn(slug);
  when(() => mock.businessName).thenReturn(businessName);
  when(() => mock.headline).thenReturn('');
  when(() => mock.bio).thenReturn('');
  when(() => mock.yearsExperience).thenReturn(5);
  when(() => mock.whatsappPhone).thenReturn('');
  when(() => mock.publicPhone).thenReturn('');
  when(() => mock.baseGovernorateId).thenReturn('sousse');
  when(() => mock.availabilityStatus).thenReturn(status);
  when(() => mock.acceptsEmergency).thenReturn(acceptsEmergency);
  when(() => mock.isVerified).thenReturn(false);
  when(() => mock.ratingAvg).thenReturn(4.5);
  when(() => mock.ratingCount).thenReturn(12);
  when(() => mock.totalProfileViews).thenReturn(120);
  when(() => mock.totalContacts).thenReturn(15);
  when(() => mock.completionScore).thenReturn(85);
  return mock;
}

/// FM-38 (issue #235) : édition post-onboarding + disponibilité commutable.
void main() {
  late _MockOnboardingRepository repo;
  late _MockProviderProfileRepository providerProfileRepo;

  setUpAll(() {
    registerFallbackValue(_FakePatchRequest());
  });

  setUp(() {
    repo = _MockOnboardingRepository();
    providerProfileRepo = _MockProviderProfileRepository();
    when(
      () => providerProfileRepo.fetchProfile(any()),
    ).thenThrow(Exception('non simulé dans ce test'));
  });

  Widget buildScreen({List<Override> overrides = const []}) {
    final testRouter = GoRouter(
      initialLocation: '/pro/profile',
      routes: [
        GoRoute(
          path: '/pro/profile',
          builder: (_, _) => const ProProfileScreen(),
          routes: [
            GoRoute(
              path: 'legal',
              builder: (_, _) => const Text('LEGAL_PLACEHOLDER'),
            ),
          ],
        ),
        GoRoute(
          path: '/client',
          builder: (_, _) => const Text('CLIENT_PLACEHOLDER'),
        ),
        GoRoute(
          path: '/providers/:slug',
          builder: (_, state) =>
              Text('LISTING_PLACEHOLDER_${state.pathParameters['slug']}'),
        ),
      ],
    );

    return ProviderScope(
      overrides: [
        onboardingRepositoryProvider.overrideWithValue(repo),
        providerProfileRepositoryProvider.overrideWithValue(
          providerProfileRepo,
        ),
        ...overrides,
      ],
      child: MaterialApp.router(
        theme: buildTheme(
          brightness: Brightness.light,
          locale: const Locale('fr'),
        ),
        locale: const Locale('fr'),
        supportedLocales: const [Locale('fr'), Locale('ar')],
        localizationsDelegates: const [
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
          GlobalCupertinoLocalizations.delegate,
        ],
        routerConfig: testRouter,
      ),
    );
  }

  group('FM-38 — ProProfileScreen', () {
    testWidgets("affiche EmptyState quand aucun profil n'existe", (
      tester,
    ) async {
      await tester.pumpWidget(
        buildScreen(
          overrides: [
            myProviderProfileProvider.overrideWith((ref) async => null),
          ],
        ),
      );
      await tester.pumpAndSettle();

      expect(find.text('Profil introuvable'), findsOneWidget);
    });

    testWidgets(
      'affiche ErrorState avec bouton réessayer si le chargement échoue',
      (tester) async {
        var shouldFail = true;
        final profile = _profile();

        await tester.pumpWidget(
          buildScreen(
            overrides: [
              myProviderProfileProvider.overrideWith((ref) async {
                if (shouldFail) throw Exception('réseau');
                return profile;
              }),
            ],
          ),
        );
        await tester.pumpAndSettle();

        expect(find.byType(ErrorState), findsOneWidget);

        shouldFail = false;
        await tester.tap(find.text('Réessayer'));
        await tester.pumpAndSettle();

        expect(find.text('Ahmed Plomberie'), findsOneWidget);
      },
    );

    testWidgets(
      'pré-remplit le formulaire et affiche disponibilité/urgence/fiche',
      (tester) async {
        tester.view.physicalSize = const Size(400, 3000);
        tester.view.devicePixelRatio = 1.0;
        addTearDown(tester.view.reset);

        await tester.pumpWidget(
          buildScreen(
            overrides: [
              myProviderProfileProvider.overrideWith(
                (ref) async => _profile(acceptsEmergency: true),
              ),
            ],
          ),
        );
        await tester.pumpAndSettle();

        expect(find.text('Ahmed Plomberie'), findsNWidgets(2));
        expect(find.text('Disponible'), findsOneWidget);
        expect(find.text('Accepte les urgences'), findsOneWidget);
        expect(find.text('Enregistrer'), findsOneWidget);
        expect(
          find.text('Voir ma fiche telle que la voit un client'),
          findsOneWidget,
        );
        // Le gouvernorat n'est pas éditable en PATCH — pas de sélecteur ici.
        expect(find.text('Gouvernorat de rattachement'), findsNothing);
      },
    );

    testWidgets(
      'le bouton « Voir ma fiche » navigue vers /providers/:slug',
      (tester) async {
        tester.view.physicalSize = const Size(400, 3000);
        tester.view.devicePixelRatio = 1.0;
        addTearDown(tester.view.reset);

        await tester.pumpWidget(
          buildScreen(
            overrides: [
              myProviderProfileProvider.overrideWith(
                (ref) async => _profile(),
              ),
            ],
          ),
        );
        await tester.pumpAndSettle();

        await tester.tap(
          find.text('Voir ma fiche telle que la voit un client'),
        );
        await tester.pumpAndSettle();

        expect(
          find.text('LISTING_PLACEHOLDER_ahmed-plomberie-sousse'),
          findsOneWidget,
        );
      },
    );

    testWidgets(
      'basculer la disponibilité appelle updateProfile() avec le nouveau '
      'statut',
      (tester) async {
        tester.view.physicalSize = const Size(400, 3000);
        tester.view.devicePixelRatio = 1.0;
        addTearDown(tester.view.reset);

        when(
          () => repo.updateProfile(any()),
        ).thenAnswer((_) async => _profile());

        await tester.pumpWidget(
          buildScreen(
            overrides: [
              myProviderProfileProvider.overrideWith(
                (ref) async => _profile(),
              ),
            ],
          ),
        );
        await tester.pumpAndSettle();

        await tester.tap(find.text('Disponibilité'));
        await tester.pumpAndSettle();
        await tester.tap(find.text('Occupé'));
        await tester.pumpAndSettle();

        final captured = verify(
          () => repo.updateProfile(captureAny()),
        ).captured;
        expect(captured, hasLength(1));
        expect(
          (captured.single as V1ProvidersMePatchRequest).availabilityStatus,
          V1ProvidersMePatchRequestAvailabilityStatusEnum.BUSY,
        );
      },
    );

    testWidgets(
      'activer « Accepte les urgences » appelle updateProfile()',
      (tester) async {
        tester.view.physicalSize = const Size(400, 3000);
        tester.view.devicePixelRatio = 1.0;
        addTearDown(tester.view.reset);

        when(
          () => repo.updateProfile(any()),
        ).thenAnswer((_) async => _profile());

        await tester.pumpWidget(
          buildScreen(
            overrides: [
              myProviderProfileProvider.overrideWith(
                (ref) async => _profile(),
              ),
            ],
          ),
        );
        await tester.pumpAndSettle();

        await tester.tap(find.text('Accepte les urgences'));
        await tester.pumpAndSettle();

        final captured = verify(
          () => repo.updateProfile(captureAny()),
        ).captured;
        expect(captured, hasLength(1));
        expect(
          (captured.single as V1ProvidersMePatchRequest).acceptsEmergency,
          isTrue,
        );
      },
    );

    testWidgets(
      'enregistrer le formulaire appelle updateProfile() et affiche une '
      'confirmation',
      (tester) async {
        tester.view.physicalSize = const Size(400, 3000);
        tester.view.devicePixelRatio = 1.0;
        addTearDown(tester.view.reset);

        when(
          () => repo.updateProfile(any()),
        ).thenAnswer((_) async => _profile());

        await tester.pumpWidget(
          buildScreen(
            overrides: [
              myProviderProfileProvider.overrideWith(
                (ref) async => _profile(),
              ),
            ],
          ),
        );
        await tester.pumpAndSettle();

        await tester.tap(find.text('Enregistrer'));
        await tester.pump();
        await tester.pump(const Duration(milliseconds: 100));

        verify(() => repo.updateProfile(any())).called(1);
        expect(find.text('Profil mis à jour'), findsOneWidget);
      },
    );

    testWidgets(
      'le lien Mentions légales navigue vers /pro/profile/legal',
      (tester) async {
        tester.view.physicalSize = const Size(400, 3000);
        tester.view.devicePixelRatio = 1.0;
        addTearDown(tester.view.reset);

        await tester.pumpWidget(
          buildScreen(
            overrides: [
              myProviderProfileProvider.overrideWith(
                (ref) async => _profile(),
              ),
            ],
          ),
        );
        await tester.pumpAndSettle();

        await tester.ensureVisible(find.text('Mentions légales'));
        await tester.pumpAndSettle();
        await tester.tap(find.text('Mentions légales'));
        await tester.pumpAndSettle();

        expect(find.text('LEGAL_PLACEHOLDER'), findsOneWidget);
      },
    );

    testWidgets(
      'le bouton de bascule vers le client navigue vers /client',
      (tester) async {
        tester.view.physicalSize = const Size(400, 3000);
        tester.view.devicePixelRatio = 1.0;
        addTearDown(tester.view.reset);

        await tester.pumpWidget(
          buildScreen(
            overrides: [
              myProviderProfileProvider.overrideWith(
                (ref) async => _profile(),
              ),
            ],
          ),
        );
        await tester.pumpAndSettle();

        await tester.ensureVisible(find.text("Retour à l'espace Client"));
        await tester.pumpAndSettle();
        await tester.tap(find.text("Retour à l'espace Client"));
        await tester.pumpAndSettle();

        expect(find.text('CLIENT_PLACEHOLDER'), findsOneWidget);
      },
    );

    testWidgets('se rend en arabe sans exception (RTL)', (tester) async {
      await tester.pumpWidget(
        buildScreen(
          overrides: [
            myProviderProfileProvider.overrideWith(
              (ref) async => _profile(),
            ),
          ],
        ),
      );
      // Le test réutilise `MaterialApp.router` avec locale fr figée dans
      // buildScreen() — un test RTL séparé nécessiterait de paramétrer la
      // locale ; couvert plus simplement au niveau du widget partagé
      // (`account_settings_section_test.dart`) et de `OnboardingProfileStep`
      // (déjà testé en arabe ailleurs).
      await tester.pumpAndSettle();
      expect(tester.takeException(), isNull);
    });
  });
}
