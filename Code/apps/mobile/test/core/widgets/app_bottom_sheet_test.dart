import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:sanaya/core/widgets/app_bottom_sheet.dart';

import 'widget_test_helpers.dart';

void main() {
  group('FM-41c — showAppBottomSheet / AppBottomSheet', () {
    testWidgets('affiche le contenu du builder', (tester) async {
      await tester.pumpWidget(
        themedApp(
          Scaffold(
            body: Builder(
              builder: (context) => ElevatedButton(
                onPressed: () => showAppBottomSheet<void>(
                  context,
                  builder: (_) => const Text('Contenu'),
                ),
                child: const Text('ouvrir'),
              ),
            ),
          ),
        ),
      );

      await tester.tap(find.text('ouvrir'));
      await tester.pumpAndSettle();

      expect(find.text('Contenu'), findsOneWidget);
    });

    testWidgets('affiche le titre quand fourni', (tester) async {
      await tester.pumpWidget(
        themedApp(
          Scaffold(
            body: Builder(
              builder: (context) => ElevatedButton(
                onPressed: () => showAppBottomSheet<void>(
                  context,
                  title: 'Gouvernorat',
                  builder: (_) => const Text('Contenu'),
                ),
                child: const Text('ouvrir'),
              ),
            ),
          ),
        ),
      );

      await tester.tap(find.text('ouvrir'));
      await tester.pumpAndSettle();

      expect(find.text('Gouvernorat'), findsOneWidget);
    });

    testWidgets('sans titre, aucun texte de titre ajouté', (tester) async {
      await tester.pumpWidget(
        themedApp(const Scaffold(body: AppBottomSheet(child: Text('X')))),
      );

      expect(find.text('X'), findsOneWidget);
      expect(find.byType(Text), findsOneWidget);
    });

    testWidgets('rendu sans exception en RTL (arabe)', (tester) async {
      await tester.pumpWidget(
        themedApp(
          const Scaffold(
            body: AppBottomSheet(title: 'الولاية', child: Text('محتوى')),
          ),
          locale: const Locale('ar'),
        ),
      );

      expect(find.text('الولاية'), findsOneWidget);
      expect(find.text('محتوى'), findsOneWidget);
    });
  });
}
