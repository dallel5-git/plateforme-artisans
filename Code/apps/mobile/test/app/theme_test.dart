import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:sanaya/app/theme.dart';
import 'package:sanaya/core/theme/app_colors.dart';
import 'package:sanaya/core/theme/app_text.dart';

void main() {
  /// FM-16a — les 15 paliers du `TextTheme` Material 3 doivent tous être
  /// renseignés par `buildTheme()`, avec la police correcte par locale
  /// (Manrope FR / Noto Kufi Arabic AR) : avant cette tâche, seuls 8 des 15
  /// paliers étaient mappés, et les titres d'AppBar (`titleLarge`) tombaient
  /// sur la police par défaut de Material (Roboto) faute de style explicite.
  group('FM-16a — TextTheme M3 complet', () {
    const locales = [Locale('fr'), Locale('ar')];
    const brightnesses = [Brightness.light, Brightness.dark];

    for (final locale in locales) {
      for (final brightness in brightnesses) {
        test(
          'les 15 paliers M3 sont renseignés avec la bonne police '
          '(${locale.languageCode}, $brightness)',
          () {
            final theme = buildTheme(brightness: brightness, locale: locale);
            final textTheme = theme.textTheme;
            final expectedFamily = AppText.familyFor(locale);

            final styles = <String, TextStyle?>{
              'displayLarge': textTheme.displayLarge,
              'displayMedium': textTheme.displayMedium,
              'displaySmall': textTheme.displaySmall,
              'headlineLarge': textTheme.headlineLarge,
              'headlineMedium': textTheme.headlineMedium,
              'headlineSmall': textTheme.headlineSmall,
              'titleLarge': textTheme.titleLarge,
              'titleMedium': textTheme.titleMedium,
              'titleSmall': textTheme.titleSmall,
              'bodyLarge': textTheme.bodyLarge,
              'bodyMedium': textTheme.bodyMedium,
              'bodySmall': textTheme.bodySmall,
              'labelLarge': textTheme.labelLarge,
              'labelMedium': textTheme.labelMedium,
              'labelSmall': textTheme.labelSmall,
            };

            for (final entry in styles.entries) {
              expect(entry.value, isNotNull, reason: '${entry.key} est nul');
              expect(
                entry.value!.fontFamily,
                expectedFamily,
                reason: '${entry.key} ne porte pas $expectedFamily',
              );
            }
          },
        );
      }
    }

    test('titleLarge reprend AppText.subtitle (16/w600)', () {
      final theme = buildTheme(
        brightness: Brightness.light,
        locale: const Locale('fr'),
      );

      expect(theme.textTheme.titleLarge!.fontSize, 16.0);
      expect(theme.textTheme.titleLarge!.fontWeight, FontWeight.w600);
    });
  });

  /// FM-16b — sous-thèmes de composants Material 3 : avant cette tâche,
  /// buildTheme() ne renseignait aucun sous-thème, ce qui avait produit 10
  /// `AppBar(backgroundColor: colors.surface)` recopiés à l'identique sur les
  /// écrans, et des feuilles modales/dialogues qui seraient tombés sur la
  /// dérivation algorithmique de ColorScheme.fromSeed (ex.
  /// surfaceContainerLow) au lieu des tokens AppColors.
  group('FM-16b — sous-thèmes de composants', () {
    late ThemeData theme;
    late AppColors colors;

    setUp(() {
      theme = buildTheme(
        brightness: Brightness.light,
        locale: const Locale('fr'),
      );
      colors = theme.extension<AppColors>()!;
    });

    test('appBarTheme : fond surface, titre h3, élévation 0', () {
      expect(theme.appBarTheme.backgroundColor, colors.surface);
      expect(theme.appBarTheme.elevation, 0);
      expect(theme.appBarTheme.scrolledUnderElevation, 0);
      expect(theme.appBarTheme.titleTextStyle!.fontSize, 18.0);
      expect(theme.appBarTheme.titleTextStyle!.fontWeight, FontWeight.w700);
    });

    test(
      'bottomSheetTheme : fond surface (pas surfaceContainerLow), '
      'coins arrondis en haut',
      () {
        expect(theme.bottomSheetTheme.backgroundColor, colors.surface);
        expect(theme.bottomSheetTheme.modalBackgroundColor, colors.surface);
        expect(
          theme.bottomSheetTheme.backgroundColor,
          isNot(theme.colorScheme.surfaceContainerLow),
        );
        expect(theme.bottomSheetTheme.shape, isA<RoundedRectangleBorder>());
      },
    );

    test('dialogTheme : fond surface', () {
      expect(theme.dialogTheme.backgroundColor, colors.surface);
    });

    test('dividerTheme : couleur border', () {
      expect(theme.dividerTheme.color, colors.border);
    });

    test(
      'chipTheme, snackBarTheme, checkboxTheme, progressIndicatorTheme '
      'sont renseignés',
      () {
        expect(theme.chipTheme.backgroundColor, colors.surfaceRaised);
        expect(theme.snackBarTheme.backgroundColor, colors.textPrimary);
        expect(theme.progressIndicatorTheme.color, colors.accent);
        expect(
          theme.checkboxTheme.checkColor?.resolve({}),
          colors.onAccent,
        );
      },
    );
  });
}
