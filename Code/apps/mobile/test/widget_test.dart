import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:sanaya/core/theme/app_text.dart';
import 'package:sanaya/main.dart';

void main() {
  testWidgets('SanayaApp démarre sans exception', (tester) async {
    await tester.pumpWidget(const ProviderScope(child: SanayaApp()));

    expect(find.text('Sanaya'), findsOneWidget);
  });

  group('FM-01c — polices Manrope + Noto Kufi Arabic', () {
    testWidgets('les 4 poids Manrope (FR) se chargent sans exception', (
      tester,
    ) async {
      const locale = Locale('fr');
      await tester.pumpWidget(
        MaterialApp(
          home: Column(
            children: [
              Text('Aa', style: AppText.body(locale)),
              Text('Aa', style: AppText.bodyStrong(locale)),
              Text('Aa', style: AppText.h2(locale)),
              Text('Aa', style: AppText.display(locale)),
            ],
          ),
        ),
      );

      expect(tester.takeException(), isNull);
    });

    testWidgets(
      'les 4 poids Noto Kufi Arabic (AR) se chargent sans exception',
      (
        tester,
      ) async {
        const locale = Locale('ar');
        await tester.pumpWidget(
          MaterialApp(
            home: Directionality(
              textDirection: TextDirection.rtl,
              child: Column(
                children: [
                  Text('أب', style: AppText.body(locale)),
                  Text('أب', style: AppText.bodyStrong(locale)),
                  Text('أب', style: AppText.h2(locale)),
                  Text('أب', style: AppText.display(locale)),
                ],
              ),
            ),
          ),
        );

        expect(tester.takeException(), isNull);
      },
    );
  });
}
