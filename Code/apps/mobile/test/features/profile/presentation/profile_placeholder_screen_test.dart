import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:sanaya/app/providers.dart';
import 'package:sanaya/app/theme.dart';
import 'package:sanaya/features/auth/application/auth_state_provider.dart';
import 'package:sanaya/features/auth/application/auth_status.dart';
import 'package:sanaya/features/profile/presentation/profile_placeholder_screen.dart';

import '../../../core/widgets/widget_test_helpers.dart';

/// Fixe `authStateProvider` à une valeur connue sans dépendre du vrai
/// `AuthTokenStore`/`AuthRepository` (indisponibles en test widget).
class _FixedAuthStateNotifier extends AuthStateNotifier {
  _FixedAuthStateNotifier(this._status);

  final AuthStatus _status;

  @override
  Future<AuthStatus> build() async => _status;
}

void main() {
  Widget buildScreen({
    Locale locale = const Locale('fr'),
    AuthStatus authStatus = const AuthStatus.unauthenticated(),
  }) {
    return ProviderScope(
      overrides: [
        localeProvider.overrideWith((ref) => locale),
        authStateProvider.overrideWith(
          () => _FixedAuthStateNotifier(authStatus),
        ),
      ],
      child: themedApp(const ProfilePlaceholderScreen(), locale: locale),
    );
  }

  group('FM-23a — ProfilePlaceholderScreen', () {
    testWidgets('affiche le titre et le message « bientôt disponible » en '
        'français', (tester) async {
      await tester.pumpWidget(buildScreen());
      await tester.pumpAndSettle();

      expect(find.text('Profil'), findsOneWidget);
      expect(find.text('Profil bientôt disponible'), findsOneWidget);
    });

    testWidgets('se rend en arabe sans exception (RTL)', (tester) async {
      await tester.pumpWidget(buildScreen(locale: const Locale('ar')));
      await tester.pumpAndSettle();

      expect(find.text('الملف الشخصي قريباً'), findsOneWidget);
      expect(tester.takeException(), isNull);
    });

    testWidgets(
      '🔒 réglages relogés depuis le hub (FM-23) : la bascule langue '
      'fonctionne toujours',
      (tester) async {
        await tester.pumpWidget(buildScreen());
        await tester.pumpAndSettle();

        expect(find.text('Profil'), findsOneWidget);

        await tester.tap(find.byIcon(Icons.language));
        await tester.pumpAndSettle();

        expect(find.text('الملف الشخصي'), findsOneWidget);
      },
    );

    testWidgets(
      '🔒 réglages relogés depuis le hub (FM-23) : la bascule thème '
      'fonctionne toujours',
      (tester) async {
        await tester.pumpWidget(buildScreen());
        await tester.pumpAndSettle();

        expect(find.byIcon(Icons.light_mode), findsOneWidget);

        await tester.tap(find.byIcon(Icons.light_mode));
        await tester.pumpAndSettle();

        expect(find.byIcon(Icons.dark_mode), findsOneWidget);
      },
    );

    testWidgets(
      "FM-25 : compte avec le rôle PROVIDER voit la bascule vers l'espace "
      'Pro',
      (tester) async {
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
      "l'espace Pro",
      (tester) async {
        await tester.pumpWidget(
          buildScreen(
            authStatus: const AuthStatus.authenticated(isProvider: false),
          ),
        );
        await tester.pumpAndSettle();

        expect(find.text('Passer en espace Pro'), findsNothing);
      },
    );

    testWidgets(
      'FM-25 : le bouton de bascule navigue vers /pro',
      (tester) async {
        final container = ProviderContainer(
          overrides: [
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
              builder: (_, _) => const ProfilePlaceholderScreen(),
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
              routerConfig: testRouter,
            ),
          ),
        );
        await tester.pumpAndSettle();

        await tester.tap(find.text('Passer en espace Pro'));
        await tester.pumpAndSettle();

        expect(find.text('PRO_PLACEHOLDER'), findsOneWidget);
      },
    );
  });
}
