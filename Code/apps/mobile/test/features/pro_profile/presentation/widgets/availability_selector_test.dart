import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:sanaya/core/api/generated/api.dart';
import 'package:sanaya/features/pro_profile/presentation/widgets/availability_selector.dart';

import '../../../../core/widgets/widget_test_helpers.dart';

/// FM-38 (issue #235) : badge de disponibilité commutable. Typé contre
/// l'enum propre à `GET`/`PATCH /providers/me` — distinct de celui de la
/// fiche publique utilisé par `AvailabilityChip` (voir doc du widget).
void main() {
  Widget buildSelector({
    required V1ProvidersMePost200ResponseProviderAvailabilityStatusEnum status,
    required ValueChanged<V1ProvidersMePatchRequestAvailabilityStatusEnum>
    onSelect,
  }) {
    return ProviderScope(
      child: themedApp(
        Scaffold(
          body: AvailabilitySelector(status: status, onSelect: onSelect),
        ),
      ),
    );
  }

  group('FM-38 — AvailabilitySelector', () {
    testWidgets('affiche le libellé correspondant au statut courant', (
      tester,
    ) async {
      await tester.pumpWidget(
        buildSelector(
          status:
              V1ProvidersMePost200ResponseProviderAvailabilityStatusEnum.BUSY,
          onSelect: (_) {},
        ),
      );
      await tester.pumpAndSettle();

      expect(find.text('Occupé'), findsOneWidget);
    });

    testWidgets(
      'ouvre une feuille modale listant les 3 statuts au tap',
      (tester) async {
        await tester.pumpWidget(
          buildSelector(
            status: V1ProvidersMePost200ResponseProviderAvailabilityStatusEnum
                .AVAILABLE,
            onSelect: (_) {},
          ),
        );
        await tester.pumpAndSettle();

        await tester.tap(find.text('Disponibilité'));
        await tester.pumpAndSettle();

        // « Disponible » apparaît 2 fois : la puce d'en-tête (statut actuel,
        // toujours affichée derrière la feuille modale) + l'option de la
        // feuille elle-même.
        expect(find.text('Disponible'), findsNWidgets(2));
        expect(find.text('Occupé'), findsOneWidget);
        expect(find.text('En congé'), findsOneWidget);
      },
    );

    testWidgets(
      'sélectionner un nouveau statut appelle onSelect avec le bon enum et '
      'ferme la feuille',
      (tester) async {
        V1ProvidersMePatchRequestAvailabilityStatusEnum? selected;
        await tester.pumpWidget(
          buildSelector(
            status: V1ProvidersMePost200ResponseProviderAvailabilityStatusEnum
                .AVAILABLE,
            onSelect: (value) => selected = value,
          ),
        );
        await tester.pumpAndSettle();

        await tester.tap(find.text('Disponibilité'));
        await tester.pumpAndSettle();
        await tester.tap(find.text('Occupé'));
        await tester.pumpAndSettle();

        expect(
          selected,
          V1ProvidersMePatchRequestAvailabilityStatusEnum.BUSY,
        );
        // La feuille est fermée : un seul « Disponible » restant, celui de
        // la puce d'en-tête (le statut affiché ne change que si l'appelant
        // reconstruit le widget avec le nouveau `status` — non simulé ici).
        expect(find.text('Disponible'), findsOneWidget);
      },
    );

    testWidgets(
      "sélectionner le statut déjà actif n'appelle pas onSelect",
      (tester) async {
        var called = false;
        await tester.pumpWidget(
          buildSelector(
            status: V1ProvidersMePost200ResponseProviderAvailabilityStatusEnum
                .AVAILABLE,
            onSelect: (_) => called = true,
          ),
        );
        await tester.pumpAndSettle();

        await tester.tap(find.text('Disponibilité'));
        await tester.pumpAndSettle();
        // « Disponible » apparaît 2 fois (en-tête + feuille) : ne cible que
        // l'option de la feuille, seule enveloppée dans un `ListTile`.
        await tester.tap(find.widgetWithText(ListTile, 'Disponible'));
        await tester.pumpAndSettle();

        expect(called, isFalse);
      },
    );
  });
}
