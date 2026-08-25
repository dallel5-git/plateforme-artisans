import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:sanaya/core/i18n/locale_persistence.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  group('FM-03b — persistance de la locale', () {
    testWidgets('readInitialLocale() retourne la préférence persistée (ar)', (
      tester,
    ) async {
      SharedPreferences.setMockInitialValues({'sanaya.locale': 'ar'});

      expect(await readInitialLocale(), const Locale('ar'));
    });

    testWidgets('readInitialLocale() retourne la préférence persistée (fr)', (
      tester,
    ) async {
      SharedPreferences.setMockInitialValues({'sanaya.locale': 'fr'});

      expect(await readInitialLocale(), const Locale('fr'));
    });

    testWidgets(
      'readInitialLocale() se rabat sur une locale supportée (fr/ar) '
      "quand rien n'est persisté",
      (tester) async {
        SharedPreferences.setMockInitialValues({});

        final locale = await readInitialLocale();

        expect(['fr', 'ar'], contains(locale.languageCode));
      },
    );

    testWidgets(
      'readInitialLocale() ignore une valeur persistée invalide et se '
      'rabat sur une locale supportée',
      (tester) async {
        SharedPreferences.setMockInitialValues({'sanaya.locale': 'xx'});

        final locale = await readInitialLocale();

        expect(['fr', 'ar'], contains(locale.languageCode));
      },
    );

    testWidgets(
      'persistLocale() écrit une valeur relue par readInitialLocale()',
      (
        tester,
      ) async {
        SharedPreferences.setMockInitialValues({});

        await persistLocale(const Locale('ar'));

        expect(await readInitialLocale(), const Locale('ar'));
      },
    );
  });
}
