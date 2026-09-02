import 'dart:ui' show Tristate;

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:sanaya/core/widgets/app_bottom_nav.dart';

import 'widget_test_helpers.dart';

const _items = [
  AppBottomNavItem(icon: Icons.search, label: 'Rechercher'),
  AppBottomNavItem(icon: Icons.favorite_border, label: 'Favoris'),
  AppBottomNavItem(icon: Icons.history, label: 'Historique'),
  AppBottomNavItem(icon: Icons.person_outline, label: 'Profil'),
];

const _itemsAr = [
  AppBottomNavItem(icon: Icons.search, label: 'بحث'),
  AppBottomNavItem(icon: Icons.favorite_border, label: 'المفضلة'),
  AppBottomNavItem(icon: Icons.history, label: 'السجل'),
  AppBottomNavItem(icon: Icons.person_outline, label: 'الملف الشخصي'),
];

void main() {
  group('FM-22 — AppBottomNav', () {
    testWidgets('affiche les 4 onglets et déclenche onTap avec le bon index', (
      tester,
    ) async {
      final tappedIndexes = <int>[];
      await tester.pumpWidget(
        themedApp(
          AppBottomNav(
            items: _items,
            currentIndex: 0,
            onTap: tappedIndexes.add,
          ),
        ),
      );

      expect(find.text('Rechercher'), findsOneWidget);
      expect(find.text('Favoris'), findsOneWidget);
      expect(find.text('Historique'), findsOneWidget);
      expect(find.text('Profil'), findsOneWidget);

      await tester.tap(find.text('Historique'));
      expect(tappedIndexes, [2]);
    });

    testWidgets(
      "Semantics porte le libellé et l'état sélectionné de chaque onglet",
      (tester) async {
        final handle = tester.ensureSemantics();
        await tester.pumpWidget(
          themedApp(
            AppBottomNav(items: _items, currentIndex: 1, onTap: (_) {}),
          ),
        );

        final selectedNode = tester.getSemantics(find.text('Favoris'));
        expect(selectedNode.label, 'Favoris');
        expect(selectedNode.flagsCollection.isButton, isTrue);
        expect(selectedNode.flagsCollection.isSelected, Tristate.isTrue);

        final unselectedNode = tester.getSemantics(find.text('Rechercher'));
        expect(unselectedNode.label, 'Rechercher');
        expect(unselectedNode.flagsCollection.isButton, isTrue);
        expect(unselectedNode.flagsCollection.isSelected, Tristate.isFalse);

        handle.dispose();
      },
    );

    testWidgets('chaque onglet respecte la cible tactile minimale ≥ 48 px', (
      tester,
    ) async {
      await tester.pumpWidget(
        themedApp(AppBottomNav(items: _items, currentIndex: 0, onTap: (_) {})),
      );

      final tileSize = tester.getSize(
        find
            .ancestor(
              of: find.text('Rechercher'),
              matching: find.byType(InkWell),
            )
            .first,
      );
      expect(tileSize.height, greaterThanOrEqualTo(48.0));
    });

    testWidgets(
      '🔒 la barre est inversée en arabe — miroir RTL automatique',
      (
        tester,
      ) async {
        await tester.pumpWidget(
          themedApp(
            AppBottomNav(items: _items, currentIndex: 0, onTap: (_) {}),
          ),
        );
        final ltrFirstX = tester.getTopLeft(find.text('Rechercher')).dx;
        final ltrLastX = tester.getTopLeft(find.text('Profil')).dx;

        await tester.pumpWidget(
          themedApp(
            AppBottomNav(items: _itemsAr, currentIndex: 0, onTap: (_) {}),
            locale: const Locale('ar'),
          ),
        );
        final rtlFirstX = tester.getTopLeft(find.text('بحث')).dx;
        final rtlLastX = tester.getTopLeft(find.text('الملف الشخصي')).dx;

        expect(
          ltrFirstX < ltrLastX,
          isTrue,
          reason: 'en LTR, le premier onglet doit être à gauche',
        );
        expect(
          rtlFirstX > rtlLastX,
          isTrue,
          reason: 'en RTL, le premier onglet doit être à droite',
        );
      },
    );
  });
}
