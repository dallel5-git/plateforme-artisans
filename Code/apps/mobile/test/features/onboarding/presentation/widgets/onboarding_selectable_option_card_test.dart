import 'dart:ui' show SemanticsAction, Tristate;

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:sanaya/core/theme/app_spacing.dart';
import 'package:sanaya/features/onboarding/presentation/widgets/onboarding_selectable_option_card.dart';

import '../../../../core/widgets/widget_test_helpers.dart';

void main() {
  group('FM-43 — OnboardingSelectableOptionCard', () {
    testWidgets(
      'annonce button:true, selected: et le libellé — sans doublon du '
      'texte affiché',
      (tester) async {
        final handle = tester.ensureSemantics();
        await tester.pumpWidget(
          themedApp(
            Scaffold(
              body: OnboardingSelectableOptionCard(
                label: 'Plomberie',
                selected: true,
                enabled: true,
                onTap: () {},
              ),
            ),
          ),
        );

        final semantics = tester.getSemantics(find.byType(InkWell).first);
        expect(semantics.flagsCollection.isButton, isTrue);
        expect(semantics.flagsCollection.isSelected, Tristate.isTrue);
        expect(semantics.label, 'Plomberie');

        handle.dispose();
      },
    );

    testWidgets(
      'le badge « principal » imbriqué est un nœud Semantics distinct de '
      'la carte, avec sa propre cible tactile ≥48dp',
      (tester) async {
        final handle = tester.ensureSemantics();
        var badgeTapped = false;
        await tester.pumpWidget(
          themedApp(
            Scaffold(
              body: OnboardingSelectableOptionCard(
                label: 'Plomberie',
                selected: true,
                enabled: true,
                onTap: () {},
                primaryBadgeLabel: 'Principal',
                onTapPrimaryBadge: () => badgeTapped = true,
              ),
            ),
          ),
        );

        // 2 InkWell distincts : la carte, et le badge — pas fusionnés en un
        // seul nœud Semantics (sinon le tap « marquer principal » serait
        // injoignable au lecteur d'écran, cf. commentaire du widget).
        expect(find.byType(InkWell), findsNWidgets(2));

        // `ancestor()` remonte tous les InkWell englobants (le badge, puis
        // la carte) — le premier (le plus proche de `Text('Principal')`)
        // est celui du badge.
        final badgeInkWell = find
            .ancestor(
              of: find.text('Principal'),
              matching: find.byType(InkWell),
            )
            .first;

        final badgeSemantics = tester.getSemantics(badgeInkWell);
        expect(badgeSemantics.flagsCollection.isButton, isTrue);
        expect(badgeSemantics.label, 'Principal');
        // FM-43 : garde-fou de non-régression — un `ExcludeSemantics` trop
        // large sur ce sous-arbre avait déjà fait disparaître l'action
        // `tap` elle-même (badge réduit à une étiquette statique,
        // injoignable au lecteur d'écran malgré son `label`).
        expect(
          badgeSemantics.getSemanticsData().hasAction(SemanticsAction.tap),
          isTrue,
        );

        final badgeSize = tester.getSize(badgeInkWell);
        expect(badgeSize.height, greaterThanOrEqualTo(AppLayout.touchTarget));

        await tester.tap(find.text('Principal'));
        expect(badgeTapped, isTrue);

        handle.dispose();
      },
    );
  });
}
