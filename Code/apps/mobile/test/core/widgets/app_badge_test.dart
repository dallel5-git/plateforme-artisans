import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:sanaya/core/theme/app_colors.dart';
import 'package:sanaya/core/widgets/app_badge.dart';

import 'widget_test_helpers.dart';

void main() {
  group('FM-41a — AppBadge', () {
    testWidgets('affiche le libellé', (tester) async {
      await tester.pumpWidget(
        themedApp(
          const Scaffold(
            body: AppBadge(
              label: 'Disponible',
              variant: AppBadgeVariant.verified,
            ),
          ),
        ),
      );

      expect(find.text('Disponible'), findsOneWidget);
    });

    testWidgets("affiche l'icône optionnelle avant le texte", (tester) async {
      await tester.pumpWidget(
        themedApp(
          const Scaffold(
            body: AppBadge(
              label: 'Contact vérifié',
              variant: AppBadgeVariant.verified,
              icon: Icons.check,
            ),
          ),
        ),
      );

      expect(find.byIcon(Icons.check), findsOneWidget);
      expect(find.text('Contact vérifié'), findsOneWidget);
    });

    testWidgets('sans icône, aucune icône affichée', (tester) async {
      await tester.pumpWidget(
        themedApp(
          const Scaffold(
            body: AppBadge(
              label: 'Sousse Ville',
              variant: AppBadgeVariant.neutral,
            ),
          ),
        ),
      );

      expect(find.byType(Icon), findsNothing);
    });

    testWidgets('variant verified : couleurs verified/verifiedSubtle', (
      tester,
    ) async {
      await tester.pumpWidget(
        themedApp(
          const Scaffold(
            body: AppBadge(
              label: 'Disponible',
              variant: AppBadgeVariant.verified,
            ),
          ),
        ),
      );

      final context = tester.element(find.text('Disponible'));
      final colors = context.colors;
      final decoration =
          tester.widget<Container>(find.byType(Container)).decoration!
              as BoxDecoration;
      final textStyle = tester.widget<Text>(find.text('Disponible')).style!;

      expect(decoration.color, colors.verifiedSubtle);
      expect(textStyle.color, colors.verified);
    });

    testWidgets('variant danger : couleurs destructive/destructiveSubtle', (
      tester,
    ) async {
      await tester.pumpWidget(
        themedApp(
          const Scaffold(
            body: AppBadge(label: '-12%', variant: AppBadgeVariant.danger),
          ),
        ),
      );

      final context = tester.element(find.text('-12%'));
      final colors = context.colors;
      final decoration =
          tester.widget<Container>(find.byType(Container)).decoration!
              as BoxDecoration;
      final textStyle = tester.widget<Text>(find.text('-12%')).style!;

      expect(decoration.color, colors.destructiveSubtle);
      expect(textStyle.color, colors.destructive);
    });

    testWidgets('bordered: true ajoute un contour', (tester) async {
      await tester.pumpWidget(
        themedApp(
          const Scaffold(
            body: AppBadge(
              label: 'Sousse Ville',
              variant: AppBadgeVariant.neutral,
              bordered: true,
            ),
          ),
        ),
      );

      final context = tester.element(find.text('Sousse Ville'));
      final colors = context.colors;
      final decoration =
          tester.widget<Container>(find.byType(Container)).decoration!
              as BoxDecoration;

      expect(decoration.border, Border.all(color: colors.border));
    });

    testWidgets("bordered: false (défaut) n'a pas de contour", (tester) async {
      await tester.pumpWidget(
        themedApp(
          const Scaffold(
            body: AppBadge(
              label: 'Sponsorisé',
              variant: AppBadgeVariant.sponsored,
            ),
          ),
        ),
      );

      final decoration =
          tester.widget<Container>(find.byType(Container)).decoration!
              as BoxDecoration;

      expect(decoration.border, isNull);
    });

    testWidgets('RTL (arabe) : rendu sans exception', (tester) async {
      await tester.pumpWidget(
        themedApp(
          const Scaffold(
            body: AppBadge(label: 'متاح', variant: AppBadgeVariant.verified),
          ),
          locale: const Locale('ar'),
        ),
      );

      expect(find.text('متاح'), findsOneWidget);
      expect(
        Directionality.of(tester.element(find.text('متاح'))),
        TextDirection.rtl,
      );
    });
  });
}
