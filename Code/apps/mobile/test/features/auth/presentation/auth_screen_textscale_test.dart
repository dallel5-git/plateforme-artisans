import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:sanaya/app/theme.dart';
import 'package:sanaya/core/api/api_client_provider.dart';
import 'package:sanaya/core/api/auth_token_store.dart';
import 'package:sanaya/features/auth/application/auth_providers.dart';
import 'package:sanaya/features/auth/data/auth_repository.dart';
import 'package:sanaya/features/auth/presentation/auth_screen.dart';

import '../../../support/overflow_guard.dart';

class _MockAuthRepository extends Mock implements AuthRepository {}

class _MockAuthTokenStore extends Mock implements AuthTokenStore {}

Widget _wrap({required Locale locale, required TextScaler textScaler}) {
  return ProviderScope(
    overrides: [
      authRepositoryProvider.overrideWithValue(_MockAuthRepository()),
      authTokenStoreProvider.overrideWithValue(_MockAuthTokenStore()),
    ],
    child: MaterialApp(
      locale: locale,
      supportedLocales: const [Locale('fr'), Locale('ar')],
      localizationsDelegates: const [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      theme: buildTheme(brightness: Brightness.light, locale: locale),
      builder: (context, child) => MediaQuery(
        data: MediaQuery.of(context).copyWith(textScaler: textScaler),
        child: child!,
      ),
      home: const AuthScreen(),
    ),
  );
}

/// FM-43 — étend le patron `TextScaler` 1.3 (FM-17b) à `AuthScreen`
/// (substitut documenté pour l'écran de résultats de recherche visé à
/// l'origine par l'issue, FM-28d, pas encore construit) : saisie du
/// téléphone + préfixe `+216` + mention légale, l'écran le plus dense de
/// tout le parcours non authentifié.
void main() {
  group('FM-43 — AuthScreen, TextScaler 1.3 (accessibilité)', () {
    testWidgets(
      "aucun débordement à 130% sur l'écran de saisie du téléphone, en "
      'français',
      (tester) async {
        await tester.binding.setSurfaceSize(const Size(360, 800));
        addTearDown(() => tester.binding.setSurfaceSize(null));

        final errors = await captureFlutterErrors(() async {
          await tester.pumpWidget(
            _wrap(
              locale: const Locale('fr'),
              textScaler: const TextScaler.linear(1.3),
            ),
          );
          await tester.pumpAndSettle();
        });

        expect(
          errors,
          isEmpty,
          reason: errors.map((e) => e.exceptionAsString()).join('\n'),
        );
      },
    );

    testWidgets(
      "aucun débordement à 130% sur l'écran de saisie du téléphone, en "
      'arabe (RTL)',
      (tester) async {
        await tester.binding.setSurfaceSize(const Size(360, 800));
        addTearDown(() => tester.binding.setSurfaceSize(null));

        final errors = await captureFlutterErrors(() async {
          await tester.pumpWidget(
            _wrap(
              locale: const Locale('ar'),
              textScaler: const TextScaler.linear(1.3),
            ),
          );
          await tester.pumpAndSettle();
        });

        expect(
          errors,
          isEmpty,
          reason: errors.map((e) => e.exceptionAsString()).join('\n'),
        );
      },
    );
  });
}
