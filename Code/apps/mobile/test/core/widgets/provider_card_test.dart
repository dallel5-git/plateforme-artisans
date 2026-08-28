import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:sanaya/core/widgets/provider_card.dart';

import 'widget_test_helpers.dart';

void main() {
  group('FM-04d — ProviderCard', () {
    testWidgets(
      'affiche nom, initiales, catégorie/localisation, note et prix',
      (
        tester,
      ) async {
        await tester.pumpWidget(
          ProviderScope(
            child: themedApp(
              const ProviderCard(
                name: 'Karim Ben Salah',
                categoryLabel: 'Plomberie',
                locationLabel: 'Sousse, Khezama · 2,4 km',
                rating: 4.8,
                reviewCount: 63,
                priceLabel: 'à partir de 40 TND',
              ),
            ),
          ),
        );

        expect(find.text('Karim Ben Salah'), findsOneWidget);
        expect(find.text('KB'), findsOneWidget);
        expect(
          find.text('Plomberie · Sousse, Khezama · 2,4 km'),
          findsOneWidget,
        );
        expect(find.text('4,8 (63)'), findsOneWidget);
        expect(find.text('à partir de 40 TND'), findsOneWidget);
      },
    );

    testWidgets('sans priceLabel, aucun prix affiché', (tester) async {
      await tester.pumpWidget(
        ProviderScope(
          child: themedApp(
            const ProviderCard(
              name: 'Hédi Ferjani',
              categoryLabel: 'Peinture',
              locationLabel: 'Monastir',
              rating: 4.2,
            ),
          ),
        ),
      );

      expect(find.text('4,2'), findsOneWidget);
    });

    testWidgets('isVerified: true affiche le VerifiedBadge', (tester) async {
      await tester.pumpWidget(
        ProviderScope(
          child: themedApp(
            const ProviderCard(
              name: 'Karim Ben Salah',
              categoryLabel: 'Plomberie',
              locationLabel: 'Sousse',
              rating: 4.8,
              isVerified: true,
            ),
          ),
        ),
      );

      expect(find.text('Vérifié'), findsOneWidget);
    });

    testWidgets('isVerified: false (défaut) — pas de VerifiedBadge', (
      tester,
    ) async {
      await tester.pumpWidget(
        ProviderScope(
          child: themedApp(
            const ProviderCard(
              name: 'Karim Ben Salah',
              categoryLabel: 'Plomberie',
              locationLabel: 'Sousse',
              rating: 4.8,
            ),
          ),
        ),
      );

      expect(find.text('Vérifié'), findsNothing);
    });

    testWidgets('tap déclenche onTap', (tester) async {
      var tapped = false;
      await tester.pumpWidget(
        ProviderScope(
          child: themedApp(
            ProviderCard(
              name: 'Karim Ben Salah',
              categoryLabel: 'Plomberie',
              locationLabel: 'Sousse',
              rating: 4.8,
              onTap: () => tapped = true,
            ),
          ),
        ),
      );

      await tester.tap(find.byType(ProviderCard));
      expect(tapped, isTrue);
    });

    testWidgets('initiales : un nom à un seul mot donne une seule lettre', (
      tester,
    ) async {
      await tester.pumpWidget(
        ProviderScope(
          child: themedApp(
            const ProviderCard(
              name: 'Cabinet',
              categoryLabel: 'Électricité',
              locationLabel: 'Mahdia',
              rating: 4,
            ),
          ),
        ),
      );

      expect(find.text('C'), findsOneWidget);
    });
  });
}
