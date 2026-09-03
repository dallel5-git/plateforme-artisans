import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:sanaya/app/providers.dart';
import 'package:sanaya/app/theme.dart';
import 'package:sanaya/core/api/api_client_provider.dart';
import 'package:sanaya/core/api/auth_token_store.dart';
import 'package:sanaya/core/i18n/locale_persistence.dart';
import 'package:sanaya/features/auth/application/auth_providers.dart';
import 'package:sanaya/features/auth/application/auth_state_provider.dart';
import 'package:sanaya/features/auth/application/auth_status.dart';
import 'package:sanaya/features/auth/data/auth_repository.dart';
import 'package:sanaya/features/settings/presentation/settings_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';

class _AuthRepositoryMock extends Mock implements AuthRepository {}

class _AuthTokenStoreMock extends Mock implements AuthTokenStore {}

void main() {
  late _AuthRepositoryMock authRepository;
  late _AuthTokenStoreMock authTokenStore;

  setUp(() {
    authRepository = _AuthRepositoryMock();
    authTokenStore = _AuthTokenStoreMock();
    when(authTokenStore.restoreSession).thenAnswer((_) async => false);
    SharedPreferences.setMockInitialValues({});
  });

  Widget buildSettingsApp(ProviderContainer container) {
    return UncontrolledProviderScope(
      container: container,
      child: Consumer(
        builder: (context, ref, _) {
          final locale = ref.watch(localeProvider);
          final themeMode = ref.watch(themeModeProvider);

          return MaterialApp(
            locale: locale,
            supportedLocales: const [Locale('fr'), Locale('ar')],
            localizationsDelegates: const [
              GlobalMaterialLocalizations.delegate,
              GlobalWidgetsLocalizations.delegate,
              GlobalCupertinoLocalizations.delegate,
            ],
            theme: buildTheme(brightness: Brightness.light, locale: locale),
            darkTheme: buildTheme(brightness: Brightness.dark, locale: locale),
            themeMode: themeMode,
            home: const SettingsScreen(),
          );
        },
      ),
    );
  }

  group('SettingsScreen', () {
    testWidgets(
      '🔒 Critère d’acceptation : changer la langue depuis les réglages '
      'bascule immédiatement l’interface',
      (tester) async {
        final container = ProviderContainer(
          overrides: [
            authRepositoryProvider.overrideWithValue(authRepository),
            authTokenStoreProvider.overrideWithValue(authTokenStore),
          ],
        );
        addTearDown(container.dispose);

        await tester.pumpWidget(buildSettingsApp(container));
        await tester.pumpAndSettle();

        // 1. Initialement en Français
        expect(find.text('Réglages'), findsOneWidget);
        expect(find.text('Langue'), findsOneWidget);
        expect(find.text('Apparence'), findsOneWidget);
        expect(find.text('Se déconnecter'), findsOneWidget);

        // 2. Bascule vers l'arabe
        await tester.tap(find.text('العربية (تونس)'));
        await tester.pumpAndSettle();

        // 3. Vérification de la bascule immédiate en arabe
        expect(container.read(localeProvider), const Locale('ar'));
        expect(find.text('الإعدادات'), findsOneWidget);
        expect(find.text('اللغة'), findsOneWidget);
        expect(find.text('المظهر'), findsOneWidget);
        expect(find.text('تسجيل الخروج'), findsOneWidget);

        // 4. Vérification de la persistance
        final savedLocale = await readInitialLocale();
        expect(savedLocale.languageCode, 'ar');

        // 5. Bascule retour vers le français
        await tester.tap(find.text('Français'));
        await tester.pumpAndSettle();

        expect(container.read(localeProvider), const Locale('fr'));
        expect(find.text('Réglages'), findsOneWidget);
        expect(find.text('Langue'), findsOneWidget);
      },
    );

    testWidgets('changer le thème met à jour themeModeProvider', (
      tester,
    ) async {
      final container = ProviderContainer(
        overrides: [
          authRepositoryProvider.overrideWithValue(authRepository),
        ],
      );
      addTearDown(container.dispose);

      await tester.pumpWidget(buildSettingsApp(container));
      await tester.pumpAndSettle();

      expect(container.read(themeModeProvider), ThemeMode.system);

      await tester.tap(find.text('Sombre'));
      await tester.pumpAndSettle();

      expect(container.read(themeModeProvider), ThemeMode.dark);

      await tester.tap(find.text('Clair'));
      await tester.pumpAndSettle();

      expect(container.read(themeModeProvider), ThemeMode.light);
    });

    testWidgets(
      // régression #222 : le call-site appelait authRepository.logout()
      // sans argument (no-op garanti par le guard `refreshToken != null`).
      // Ce test vérifie désormais le vrai chemin de déconnexion,
      // AuthStateNotifier.signOut(), qui révoque + purge + change l'état.
      'le bouton de déconnexion ouvre le dialogue de confirmation '
      'et appelle signOut()',
      (tester) async {
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

        await tester.pumpWidget(buildSettingsApp(container));
        await tester.pumpAndSettle();

        // 1. Clic sur Déconnexion
        await tester.tap(find.text('Se déconnecter'));
        await tester.pumpAndSettle();

        // 2. Dialogue présent
        expect(find.text('Déconnexion'), findsOneWidget);
        expect(
          find.text('Êtes-vous sûr de vouloir vous déconnecter ?'),
          findsOneWidget,
        );

        // 3. Annulation
        await tester.tap(find.text('Annuler'));
        await tester.pumpAndSettle();

        verifyNever(
          () => authRepository.logout(
            refreshToken: any(named: 'refreshToken'),
          ),
        );
        expect(find.text('Déconnexion'), findsNothing);

        // 4. Réouverture et confirmation
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
  });
}
