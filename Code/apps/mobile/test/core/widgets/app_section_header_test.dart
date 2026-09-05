import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:sanaya/core/widgets/app_section_header.dart';

import 'widget_test_helpers.dart';

void main() {
  group('FM-41a — AppSectionHeader', () {
    testWidgets('affiche le titre', (tester) async {
      await tester.pumpWidget(
        themedApp(const Scaffold(body: AppSectionHeader(title: 'Langue'))),
      );

      expect(find.text('Langue'), findsOneWidget);
    });
  });

  group('FM-41a — AppDivider', () {
    testWidgets('rendu sans exception', (tester) async {
      await tester.pumpWidget(themedApp(const Scaffold(body: AppDivider())));

      expect(find.byType(Divider), findsOneWidget);
    });
  });
}
