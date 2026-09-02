import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:sanaya/app/theme.dart';
import 'package:sanaya/core/theme/app_colors.dart';

/// FM-16b — sous-thèmes de composants Material 3 : avant cette tâche,
/// buildTheme() ne renseignait aucun sous-thème, ce qui avait produit 10
/// `AppBar(backgroundColor: colors.surface)` recopiés à l'identique sur les
/// écrans, et des feuilles modales/dialogues qui seraient tombés sur la
/// dérivation algorithmique de ColorScheme.fromSeed (ex.
/// surfaceContainerLow) au lieu des tokens AppColors.
void main() {
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
