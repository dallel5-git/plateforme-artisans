import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:mocktail/mocktail.dart';
import 'package:sanaya/app/providers.dart';
import 'package:sanaya/app/theme.dart';
import 'package:sanaya/core/api/api_client_provider.dart';
import 'package:sanaya/core/api/auth_token_store.dart';
import 'package:sanaya/core/api/generated/api.dart';
import 'package:sanaya/features/auth/application/auth_providers.dart';
import 'package:sanaya/features/auth/application/auth_state_provider.dart';
import 'package:sanaya/features/auth/application/auth_status.dart';
import 'package:sanaya/features/auth/data/auth_repository.dart';
import 'package:sanaya/features/profile/presentation/client_profile_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../core/widgets/widget_test_helpers.dart';

class _AuthRepositoryMock extends Mock implements AuthRepository {}

/// Fixe `authStateProvider` à une valeur connue sans dépendre du vrai
/// `AuthTokenStore`/`AuthRepository` (indisponibles en test widget) — même
/// pattern que `profile_placeholder_screen_test.dart` (FM-23a, supprimé par
/// FM-32 qui fusionne les deux écrans).
class _FixedAuthStateNotifier extends AuthStateNotifier {
  _FixedAuthStateNotifier(this._status);

  final AuthStatus _status;

  @override
  Future<AuthStatus> build() async => _status;
}

V1AuthMeGet200Response _user({
  String firstName = 'Salma',
  String lastName = 'Ben Ali',
  String phone = '+21622123456',
}) {
  return V1AuthMeGet200Response(
    (b) => b
      ..id = 'u1'
      ..phone = phone
      ..phoneVerifiedAt = DateTime(2026)
      ..email = ''
      ..emailVerifiedAt = DateTime(2026)
      ..firstName = firstName
      ..lastName = lastName
      ..avatarMediaId = ''
      ..roles.add(V1AuthOtpVerifyPost200ResponseUserRolesEnum.CLIENT)
      ..status = V1AuthMeGet200ResponseStatusEnum.ACTIVE
      ..locale = 'fr'
      ..lastLoginAt = DateTime(2026)
      ..marketingOptIn = false
      ..createdAt = DateTime(2026)
      ..updatedAt = DateTime(2026),
  );
}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  late _AuthRepositoryMock authRepository;

  setUpAll(() {
    registerFallbackValue(_user());
  });

  setUp(() {
    SharedPreferences.setMockInitialValues({});
    authRepository = _AuthRepositoryMock();
    when(authRepository.getCurrentUser).thenAnswer((_) async => _user());
  });

  /// La liste de sections dépasse le viewport de test par défaut (800×600)
  /// — un `ListView` virtualise ses enfants hors écran, donc les
  /// assertions sur les dernières sections (Compte, déconnexion) ont besoin
  /// d'un viewport assez grand pour que ces widgets soient réellement
  /// construits.
  void useTallViewport(WidgetTester tester) {
    tester.view.physicalSize = const Size(400, 2400);
    tester.view.devicePixelRatio = 1.0;
    addTearDown(tester.view.reset);
  }

  Widget buildScreen({
    Locale locale = const Locale('fr'),
    AuthStatus authStatus = const AuthStatus.authenticated(isProvider: false),
  }) {
    return ProviderScope(
      overrides: [
        authRepositoryProvider.overrideWithValue(authRepository),
        localeProvider.overrideWith((ref) => locale),
        authStateProvider.overrideWith(
          () => _FixedAuthStateNotifier(authStatus),
        ),
      ],
      child: themedApp(const ClientProfileScreen(), locale: locale),
    );
  }

  group('FM-32b — ClientProfileScreen', () {
    testWidgets(
      "affiche le nom et le numéro masqué de l'utilisateur courant",
      (tester) async {
        await tester.pumpWidget(buildScreen());
        await tester.pumpAndSettle();

        expect(find.text('Salma Ben Ali'), findsOneWidget);
        expect(find.text('+216 •••••• 56'), findsOneWidget);
      },
    );

    testWidgets(
      "affiche le nom de compte par défaut si l'utilisateur n'a pas de nom",
      (tester) async {
        when(
          authRepository.getCurrentUser,
        ).thenAnswer((_) async => _user(firstName: '', lastName: ''));

        await tester.pumpWidget(buildScreen());
        await tester.pumpAndSettle();

        expect(find.text('Mon compte'), findsOneWidget);
      },
    );

    testWidgets(
      'reprend les sections Langue/Apparence/Légal/Compte de l’ancien '
      'SettingsScreen (FM-13)',
      (tester) async {
        useTallViewport(tester);
        await tester.pumpWidget(buildScreen());
        await tester.pumpAndSettle();

        expect(find.text('Langue'), findsOneWidget);
        expect(find.text('Apparence'), findsOneWidget);
        expect(find.text('Informations & Légal'), findsOneWidget);
        expect(find.text('Mentions légales'), findsOneWidget);
        expect(find.text('Compte'), findsOneWidget);
        expect(find.text('Se déconnecter'), findsOneWidget);
      },
    );

    testWidgets('changer la langue bascule immédiatement l’interface', (
      tester,
    ) async {
      final container = ProviderContainer(
        overrides: [
          authRepositoryProvider.overrideWithValue(authRepository),
          authStateProvider.overrideWith(
            () => _FixedAuthStateNotifier(
              const AuthStatus.authenticated(isProvider: false),
            ),
          ),
        ],
      );
      addTearDown(container.dispose);

      await tester.pumpWidget(
        UncontrolledProviderScope(
          container: container,
          child: Consumer(
            builder: (context, ref, _) {
              final locale = ref.watch(localeProvider);
              return themedApp(
                const ClientProfileScreen(),
                locale: locale,
              );
            },
          ),
        ),
      );
      await tester.pumpAndSettle();

      await tester.tap(find.text('العربية (تونس)'));
      await tester.pumpAndSettle();

      expect(container.read(localeProvider), const Locale('ar'));
      expect(find.text('الملف الشخصي'), findsOneWidget);
    });

    testWidgets('changer le thème met à jour themeModeProvider', (
      tester,
    ) async {
      useTallViewport(tester);
      final container = ProviderContainer(
        overrides: [
          authRepositoryProvider.overrideWithValue(authRepository),
          authStateProvider.overrideWith(
            () => _FixedAuthStateNotifier(
              const AuthStatus.authenticated(isProvider: false),
            ),
          ),
        ],
      );
      addTearDown(container.dispose);

      await tester.pumpWidget(
        UncontrolledProviderScope(
          container: container,
          child: themedApp(const ClientProfileScreen()),
        ),
      );
      await tester.pumpAndSettle();

      expect(container.read(themeModeProvider), ThemeMode.system);

      await tester.tap(find.text('Sombre'));
      await tester.pumpAndSettle();

      expect(container.read(themeModeProvider), ThemeMode.dark);
    });

    testWidgets(
      'FM-25 : compte avec le rôle PROVIDER voit la bascule vers l’espace '
      'Pro',
      (tester) async {
        useTallViewport(tester);
        await tester.pumpWidget(
          buildScreen(
            authStatus: const AuthStatus.authenticated(isProvider: true),
          ),
        );
        await tester.pumpAndSettle();
        expect(find.text('Passer en espace Pro'), findsOneWidget);
      },
    );

    testWidgets(
      'FM-25 : compte sans le rôle PROVIDER ne voit pas la bascule vers '
      'l’espace Pro',
      (tester) async {
        useTallViewport(tester);
        await tester.pumpWidget(buildScreen());
        await tester.pumpAndSettle();
        expect(find.text('Passer en espace Pro'), findsNothing);
      },
    );

    testWidgets('le bouton de bascule Pro navigue vers /pro', (
      tester,
    ) async {
      final container = ProviderContainer(
        overrides: [
          authRepositoryProvider.overrideWithValue(authRepository),
          authStateProvider.overrideWith(
            () => _FixedAuthStateNotifier(
              const AuthStatus.authenticated(isProvider: true),
            ),
          ),
        ],
      );
      addTearDown(container.dispose);

      final testRouter = GoRouter(
        initialLocation: '/client/profile',
        routes: [
          GoRoute(
            path: '/client/profile',
            builder: (_, _) => const ClientProfileScreen(),
          ),
          GoRoute(
            path: '/pro',
            builder: (_, _) => const Text('PRO_PLACEHOLDER'),
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
            supportedLocales: const [Locale('fr'), Locale('ar')],
            localizationsDelegates: const [
              GlobalMaterialLocalizations.delegate,
              GlobalWidgetsLocalizations.delegate,
              GlobalCupertinoLocalizations.delegate,
            ],
            routerConfig: testRouter,
          ),
        ),
      );
      await tester.pumpAndSettle();

      await tester.tap(find.text('Passer en espace Pro'));
      await tester.pumpAndSettle();

      expect(find.text('PRO_PLACEHOLDER'), findsOneWidget);
    });

    testWidgets('le lien Mentions légales navigue vers /client/profile/legal', (
      tester,
    ) async {
      useTallViewport(tester);
      final container = ProviderContainer(
        overrides: [
          authRepositoryProvider.overrideWithValue(authRepository),
          authStateProvider.overrideWith(
            () => _FixedAuthStateNotifier(
              const AuthStatus.authenticated(isProvider: false),
            ),
          ),
        ],
      );
      addTearDown(container.dispose);

      final testRouter = GoRouter(
        initialLocation: '/client/profile',
        routes: [
          GoRoute(
            path: '/client/profile',
            builder: (_, _) => const ClientProfileScreen(),
            routes: [
              GoRoute(
                path: 'legal',
                builder: (_, _) => const Text('LEGAL_PLACEHOLDER'),
              ),
            ],
          ),
        ],
      );

      await tester.pumpWidget(
        UncontrolledProviderScope(
          container: container,
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
        ),
      );
      await tester.pumpAndSettle();

      await tester.tap(find.text('Mentions légales'));
      await tester.pumpAndSettle();

      expect(find.text('LEGAL_PLACEHOLDER'), findsOneWidget);
    });

    group('MOB-018 — Bannière Devenir artisan', () {
      testWidgets(
        'affiche la bannière Devenir artisan pour un client régulier',
        (tester) async {
          useTallViewport(tester);
          await tester.pumpWidget(
            buildScreen(),
          );
          await tester.pumpAndSettle();

          expect(find.text('Devenir artisan sur Sanaya'), findsOneWidget);
          expect(find.text('Créer mon profil artisan'), findsOneWidget);
        },
      );

      testWidgets(
        'ne pas afficher la bannière Devenir artisan pour un profil Pro',
        (tester) async {
          useTallViewport(tester);
          await tester.pumpWidget(
            buildScreen(
              authStatus: const AuthStatus.authenticated(isProvider: true),
            ),
          );
          await tester.pumpAndSettle();

          expect(find.text('Devenir artisan sur Sanaya'), findsNothing);
          expect(find.text('Créer mon profil artisan'), findsNothing);
        },
      );

      testWidgets(
        'ne pas afficher la bannière Devenir artisan pour un invité',
        (tester) async {
          useTallViewport(tester);
          await tester.pumpWidget(
            buildScreen(
              authStatus: const AuthStatus.unauthenticated(),
            ),
          );
          await tester.pumpAndSettle();

          expect(find.text('Devenir artisan sur Sanaya'), findsNothing);
          expect(find.text('Créer mon profil artisan'), findsNothing);
        },
      );

      testWidgets(
        'le bouton Créer mon profil artisan navigue vers /pro/onboarding',
        (tester) async {
          useTallViewport(tester);
          final container = ProviderContainer(
            overrides: [
              authRepositoryProvider.overrideWithValue(authRepository),
              authStateProvider.overrideWith(
                () => _FixedAuthStateNotifier(
                  const AuthStatus.authenticated(isProvider: false),
                ),
              ),
            ],
          );
          addTearDown(container.dispose);

          final testRouter = GoRouter(
            initialLocation: '/client/profile',
            routes: [
              GoRoute(
                path: '/client/profile',
                builder: (_, _) => const ClientProfileScreen(),
              ),
              GoRoute(
                path: '/pro/onboarding',
                builder: (_, _) => const Text('ONBOARDING_PLACEHOLDER'),
              ),
            ],
          );

          await tester.pumpWidget(
            UncontrolledProviderScope(
              container: container,
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
            ),
          );
          await tester.pumpAndSettle();

          await tester.tap(find.text('Créer mon profil artisan'));
          await tester.pumpAndSettle();

          expect(find.text('ONBOARDING_PLACEHOLDER'), findsOneWidget);
        },
      );
    });

    testWidgets(
      'le bouton de déconnexion ouvre le dialogue de confirmation et '
      'appelle signOut()',
      (tester) async {
        final authTokenStore = _AuthTokenStoreMock();
        when(authTokenStore.restoreSession).thenAnswer((_) async => true);
        when(
          () => authRepository.getCurrentUser(),
        ).thenAnswer((_) async => _user());
        when(
          authTokenStore.peekRefreshToken,
        ).thenAnswer((_) async => 'session-id.refresh-token');
        when(
          () => authRepository.logout(
            refreshToken: any(named: 'refreshToken'),
          ),
        ).thenAnswer((_) async {});
        when(authTokenStore.clear).thenAnswer((_) async {});

        final container = ProviderContainer(
          overrides: [
            authRepositoryProvider.overrideWithValue(authRepository),
            authTokenStoreProvider.overrideWithValue(authTokenStore),
          ],
        );
        addTearDown(container.dispose);
        useTallViewport(tester);

        await tester.pumpWidget(
          UncontrolledProviderScope(
            container: container,
            child: themedApp(const ClientProfileScreen()),
          ),
        );
        await tester.pumpAndSettle();

        await tester.tap(find.text('Se déconnecter'));
        await tester.pumpAndSettle();

        expect(find.text('Déconnexion'), findsOneWidget);
        expect(
          find.text('Êtes-vous sûr de vouloir vous déconnecter ?'),
          findsOneWidget,
        );

        await tester.tap(find.text('Annuler'));
        await tester.pumpAndSettle();

        verifyNever(
          () => authRepository.logout(
            refreshToken: any(named: 'refreshToken'),
          ),
        );

        await tester.tap(find.text('Se déconnecter'));
        await tester.pumpAndSettle();
        await tester.tap(find.text('Confirmer'));
        await tester.pumpAndSettle();

        verify(
          () => authRepository.logout(
            refreshToken: 'session-id.refresh-token',
          ),
        ).called(1);
        verify(authTokenStore.clear).called(1);
        expect(
          container.read(authStateProvider).value?.kind,
          AuthStatusKind.unauthenticated,
        );
      },
    );

    testWidgets('se rend en arabe sans exception (RTL)', (tester) async {
      await tester.pumpWidget(buildScreen(locale: const Locale('ar')));
      await tester.pumpAndSettle();

      expect(find.text('الملف الشخصي'), findsOneWidget);
      expect(tester.takeException(), isNull);
    });

    testWidgets(
      'affiche les informations invité et le bouton de connexion quand non '
      'authentifié',
      (tester) async {
        await tester.pumpWidget(
          buildScreen(authStatus: const AuthStatus.unauthenticated()),
        );
        await tester.pumpAndSettle();

        expect(find.text('Invité'), findsOneWidget);
        expect(find.text('Non connecté'), findsOneWidget);
        expect(find.text("Se connecter ou s'inscrire"), findsOneWidget);
        expect(find.text('Se déconnecter'), findsNothing);
      },
    );
  });
}

class _AuthTokenStoreMock extends Mock implements AuthTokenStore {}
