import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:sanaya/app/providers.dart';
import 'package:sanaya/features/auth/application/auth_providers.dart';
import 'package:sanaya/features/auth/application/auth_state_provider.dart';
import 'package:sanaya/features/auth/application/auth_status.dart';
import 'package:sanaya/features/auth/data/auth_repository.dart';
import 'package:sanaya/features/settings/presentation/account_settings_section.dart';

import '../../../core/widgets/widget_test_helpers.dart';

class _AuthRepositoryMock extends Mock implements AuthRepository {}

class _FixedAuthStateNotifier extends AuthStateNotifier {
  _FixedAuthStateNotifier(this._status);

  final AuthStatus _status;

  @override
  Future<AuthStatus> build() async => _status;
}

/// Tests dédiés à `AccountSettingsSection` (FM-38a) — extraite de
/// `ClientProfileScreen` (FM-32b, dont les tests de comportement langue/
/// thème/légal/déconnexion restent inchangés et verts). Ici on couvre
/// spécifiquement le contrat de paramétrage introduit par l'extraction :
/// `onOpenLegal` et `accountActions`, réutilisés tels quels par
/// `ProProfileScreen` (FM-38c).
void main() {
  late _AuthRepositoryMock authRepository;

  setUp(() {
    authRepository = _AuthRepositoryMock();
  });

  Widget buildSection({
    required VoidCallback onOpenLegal,
    List<Widget> accountActions = const [],
    Locale locale = const Locale('fr'),
    AuthStatus authStatus = const AuthStatus.authenticated(isProvider: false),
  }) {
    return ProviderScope(
      overrides: [
        authRepositoryProvider.overrideWithValue(authRepository),
        authStateProvider.overrideWith(
          () => _FixedAuthStateNotifier(authStatus),
        ),
      ],
      child: themedApp(
        Scaffold(
          body: ListView(
            children: [
              AccountSettingsSection(
                onOpenLegal: onOpenLegal,
                accountActions: accountActions,
              ),
            ],
          ),
        ),
        locale: locale,
      ),
    );
  }

  group('FM-38a — AccountSettingsSection', () {
    testWidgets('affiche les 4 sections Langue/Apparence/Légal/Compte', (
      tester,
    ) async {
      await tester.pumpWidget(buildSection(onOpenLegal: () {}));
      await tester.pumpAndSettle();

      expect(find.text('Langue'), findsOneWidget);
      expect(find.text('Apparence'), findsOneWidget);
      expect(find.text('Informations & Légal'), findsOneWidget);
      expect(find.text('Compte'), findsOneWidget);
      expect(find.text('Se déconnecter'), findsOneWidget);
    });

    testWidgets('taper sur Mentions légales appelle onOpenLegal', (
      tester,
    ) async {
      var called = false;
      await tester.pumpWidget(
        buildSection(onOpenLegal: () => called = true),
      );
      await tester.pumpAndSettle();

      await tester.tap(find.text('Mentions légales'));
      await tester.pumpAndSettle();

      expect(called, isTrue);
    });

    testWidgets(
      'insère les accountActions avant le bouton de déconnexion',
      (tester) async {
        await tester.pumpWidget(
          buildSection(
            onOpenLegal: () {},
            accountActions: const [Text('ACTION_PERSONNALISEE')],
          ),
        );
        await tester.pumpAndSettle();

        expect(find.text('ACTION_PERSONNALISEE'), findsOneWidget);

        final actionCenter = tester.getCenter(
          find.text('ACTION_PERSONNALISEE'),
        );
        final logoutCenter = tester.getCenter(find.text('Se déconnecter'));
        expect(actionCenter.dy, lessThan(logoutCenter.dy));
      },
    );

    testWidgets('sans accountActions, seul le bouton de déconnexion apparaît '
        'dans la section Compte', (tester) async {
      await tester.pumpWidget(buildSection(onOpenLegal: () {}));
      await tester.pumpAndSettle();

      expect(find.text('Se déconnecter'), findsOneWidget);
    });

    testWidgets(
      'changer la langue met à jour immédiatement localeProvider',
      (tester) async {
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
                  Scaffold(
                    body: ListView(
                      children: [
                        AccountSettingsSection(onOpenLegal: () {}),
                      ],
                    ),
                  ),
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
      },
    );

    testWidgets(
      'le bouton de déconnexion ouvre le dialogue de confirmation',
      (tester) async {
        await tester.pumpWidget(buildSection(onOpenLegal: () {}));
        await tester.pumpAndSettle();

        await tester.tap(find.text('Se déconnecter'));
        await tester.pumpAndSettle();

        expect(find.text('Déconnexion'), findsOneWidget);
        expect(
          find.text('Êtes-vous sûr de vouloir vous déconnecter ?'),
          findsOneWidget,
        );
      },
    );

    testWidgets(
      'affiche le bouton Se connecter ou s’inscrire quand non authentifié',
      (tester) async {
        await tester.pumpWidget(
          buildSection(
            onOpenLegal: () {},
            authStatus: const AuthStatus.unauthenticated(),
          ),
        );
        await tester.pumpAndSettle();

        expect(find.text("Se connecter ou s'inscrire"), findsOneWidget);
        expect(find.text('Se déconnecter'), findsNothing);
      },
    );
  });
}
