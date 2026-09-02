import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:sanaya/core/theme/theme_persistence.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  group('FM-17a — persistance du thème', () {
    testWidgets(
      'readInitialThemeMode() retourne ThemeMode.system quand rien '
      "n'est persisté",
      (tester) async {
        SharedPreferences.setMockInitialValues({});

        expect(await readInitialThemeMode(), ThemeMode.system);
      },
    );

    testWidgets(
      'readInitialThemeMode() retourne la préférence persistée (light)',
      (tester) async {
        SharedPreferences.setMockInitialValues({
          'sanaya.theme_mode': 'light',
        });

        expect(await readInitialThemeMode(), ThemeMode.light);
      },
    );

    testWidgets(
      'readInitialThemeMode() retourne la préférence persistée (dark)',
      (tester) async {
        SharedPreferences.setMockInitialValues({'sanaya.theme_mode': 'dark'});

        expect(await readInitialThemeMode(), ThemeMode.dark);
      },
    );

    testWidgets(
      'readInitialThemeMode() ignore une valeur persistée invalide et se '
      'rabat sur ThemeMode.system',
      (tester) async {
        SharedPreferences.setMockInitialValues({'sanaya.theme_mode': 'xx'});

        expect(await readInitialThemeMode(), ThemeMode.system);
      },
    );

    testWidgets(
      'persistThemeMode() écrit une valeur relue par '
      'readInitialThemeMode()',
      (tester) async {
        SharedPreferences.setMockInitialValues({});

        await persistThemeMode(ThemeMode.dark);

        expect(await readInitialThemeMode(), ThemeMode.dark);
      },
    );
  });
}
