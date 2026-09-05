import 'dart:ui' show Tristate;

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:sanaya/core/widgets/app_segmented_control.dart';

import 'widget_test_helpers.dart';

enum _TestTab { client, pro }

void main() {
  group('FM-40a — AppSegmentedControl', () {
    testWidgets(
      'affiche les libellés et icônes de tous les segments',
      (tester) async {
        await tester.pumpWidget(
          ProviderScope(
            child: themedApp(
              AppSegmentedControl<_TestTab>(
                selectedValue: _TestTab.pro,
                onValueChanged: (_) {},
                segments: const [
                  AppSegment(
                    value: _TestTab.client,
                    label: 'Client',
                    icon: Icons.person_outline,
                  ),
                  AppSegment(
                    value: _TestTab.pro,
                    label: 'Pro',
                    icon: Icons.work_outline,
                  ),
                ],
              ),
            ),
          ),
        );

        expect(find.text('Client'), findsOneWidget);
        expect(find.text('Pro'), findsOneWidget);
        expect(find.byIcon(Icons.person_outline), findsOneWidget);
        expect(find.byIcon(Icons.work_outline), findsOneWidget);
      },
    );

    testWidgets(
      'le tap sur un segment inactif déclenche onValueChanged',
      (tester) async {
        _TestTab? selected;

        await tester.pumpWidget(
          ProviderScope(
            child: themedApp(
              StatefulBuilder(
                builder: (context, setState) => AppSegmentedControl<_TestTab>(
                  selectedValue: selected ?? _TestTab.pro,
                  onValueChanged: (val) {
                    selected = val;
                    setState(() {});
                  },
                  segments: const [
                    AppSegment(
                      value: _TestTab.client,
                      label: 'Client',
                    ),
                    AppSegment(
                      value: _TestTab.pro,
                      label: 'Pro',
                    ),
                  ],
                ),
              ),
            ),
          ),
        );

        expect(selected, isNull);
        await tester.tap(find.text('Client'));
        await tester.pumpAndSettle();

        expect(selected, equals(_TestTab.client));
      },
    );

    testWidgets(
      'accessibilité : vérifie les drapeaux sémantiques de sélection',
      (tester) async {
        final handle = tester.ensureSemantics();
        await tester.pumpWidget(
          ProviderScope(
            child: themedApp(
              AppSegmentedControl<_TestTab>(
                selectedValue: _TestTab.pro,
                onValueChanged: (_) {},
                segments: const [
                  AppSegment(
                    value: _TestTab.client,
                    label: 'Client',
                  ),
                  AppSegment(
                    value: _TestTab.pro,
                    label: 'Pro',
                  ),
                ],
              ),
            ),
          ),
        );

        final proNode = tester.getSemantics(find.text('Pro'));
        expect(proNode.flagsCollection.isSelected, Tristate.isTrue);
        expect(proNode.flagsCollection.isButton, isTrue);

        final clientNode = tester.getSemantics(find.text('Client'));
        expect(clientNode.flagsCollection.isSelected, Tristate.isFalse);
        expect(clientNode.flagsCollection.isButton, isTrue);

        handle.dispose();
      },
    );

    testWidgets('rendu RTL arabe sans débordement', (tester) async {
      await tester.pumpWidget(
        ProviderScope(
          child: themedApp(
            AppSegmentedControl<_TestTab>(
              selectedValue: _TestTab.client,
              onValueChanged: (_) {},
              segments: const [
                AppSegment(
                  value: _TestTab.client,
                  label: 'حريف',
                ),
                AppSegment(
                  value: _TestTab.pro,
                  label: 'حرفي',
                ),
              ],
            ),
            locale: const Locale('ar'),
          ),
        ),
      );

      expect(find.text('حريف'), findsOneWidget);
      expect(find.text('حرفي'), findsOneWidget);
      expect(tester.takeException(), isNull);
    });
  });
}
