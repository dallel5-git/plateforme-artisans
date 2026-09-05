import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:sanaya/app/providers.dart';
import 'package:sanaya/core/widgets/verified_badge.dart';

import 'widget_test_helpers.dart';

void main() {
  group('FM-04c — VerifiedBadge', () {
    testWidgets('affiche le libellé traduit (FR)', (tester) async {
      await tester.pumpWidget(
        ProviderScope(child: themedApp(const VerifiedBadge())),
      );

      expect(find.text('Vérifié'), findsOneWidget);
      expect(find.byIcon(Icons.check), findsOneWidget);
    });

    testWidgets('affiche le libellé traduit (AR)', (tester) async {
      // `translationsProvider` lit `localeProvider` (état Riverpod), pas
      // `MaterialApp.locale` — les deux doivent être alignés explicitement
      // ici (cf. lib/app/providers.dart).
      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            localeProvider.overrideWith((ref) => const Locale('ar')),
          ],
          child: themedApp(const VerifiedBadge(), locale: const Locale('ar')),
        ),
      );

      expect(find.text('موثّق'), findsOneWidget);
    });

    testWidgets(
      'FM-43 — un seul nœud Semantics porte le libellé (icône + texte '
      'fusionnés, pas une icône muette suivie d’un texte séparé)',
      (tester) async {
        final handle = tester.ensureSemantics();
        await tester.pumpWidget(
          ProviderScope(child: themedApp(const VerifiedBadge())),
        );

        final semantics = tester.getSemantics(find.byType(VerifiedBadge));
        expect(semantics.label, 'Vérifié');

        handle.dispose();
      },
    );

    // 🔒 NON-RÉGRESSION — ADR-002 : le badge « Vérifié » atteste l'identité,
    // jamais le plan payant. Miroir Dart du garde-fou
    // packages/core/tests/ranking.test.ts : si ce test casse, quelqu'un a
    // relié le badge à un abonnement ou lui a fait porter la décision
    // isVerified lui-même (elle doit rester l'affaire de l'écran appelant,
    // via `if (provider.isVerified) const VerifiedBadge()`).
    test(
      '🔒 NON-RÉGRESSION ADR-002 — VerifiedBadge ne référence ni '
      'Subscription/Plan ni isVerified dans son code (hors commentaires)',
      () {
        final codeLines = File('lib/core/widgets/verified_badge.dart')
            .readAsLinesSync()
            .where((line) => !line.trim().startsWith('///'))
            .join('\n');

        expect(codeLines, isNot(contains('Subscription')));
        expect(codeLines, isNot(contains('subscription')));
        expect(codeLines, isNot(contains('Plan')));
        expect(codeLines, isNot(contains('isVerified')));
      },
    );
  });
}
