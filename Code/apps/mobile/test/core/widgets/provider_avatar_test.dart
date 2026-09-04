import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:sanaya/core/widgets/provider_avatar.dart';

import 'widget_test_helpers.dart';

void main() {
  group('FM-30 — ProviderAvatar (extrait de FM-29)', () {
    testWidgets('sans url : repli sur une icône neutre', (tester) async {
      await tester.pumpWidget(themedApp(const ProviderAvatar(url: null)));

      expect(find.byIcon(Icons.person), findsOneWidget);
    });

    testWidgets('la taille demandée est appliquée', (tester) async {
      // `Center` donne des contraintes lâches — sans lui, `home:` impose des
      // contraintes tendues plein écran qui écraseraient le `width`/`height`
      // fixe du `Container` interne (`BoxConstraints.enforce`).
      await tester.pumpWidget(
        themedApp(
          const Center(child: ProviderAvatar(url: null, size: 48)),
        ),
      );

      final size = tester.getSize(find.byType(ProviderAvatar));
      expect(size.width, 48);
      expect(size.height, 48);
    });
  });
}
