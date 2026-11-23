import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:sanaya/app/theme.dart';
import 'package:sanaya/features/verification/presentation/widgets/inpdp_consent_checkbox.dart';

Widget _wrap(Widget child) {
  return MaterialApp(
    theme: buildTheme(
      brightness: Brightness.light,
      locale: const Locale('fr'),
    ),
    locale: const Locale('fr'),
    home: Scaffold(
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: child,
        ),
      ),
    ),
  );
}

void main() {
  group('InpdpConsentCheckbox — Rendu et interactions', () {
    testWidgets(
      'affiche le label de consentement et bascule la valeur au clic',
      (
        tester,
      ) async {
        var changedValue = false;
        await tester.pumpWidget(
          _wrap(
            InpdpConsentCheckbox(
              value: false,
              onChanged: (val) => changedValue = val,
            ),
          ),
        );

        expect(
          find.textContaining('loi n° 2004-63'),
          findsOneWidget,
        );

        // Clic sur la case à cocher
        await tester.tap(find.byType(Checkbox));
        expect(changedValue, isTrue);

        // Clic sur le texte
        await tester.tap(find.textContaining('loi n° 2004-63'));
        expect(changedValue, isTrue);
      },
    );

    testWidgets(
      'affiche la boîte de dialogue explicative INPDP au clic sur le lien',
      (
        tester,
      ) async {
        await tester.pumpWidget(
          _wrap(
            InpdpConsentCheckbox(
              value: true,
              onChanged: (_) {},
            ),
          ),
        );

        final linkFinder = find.textContaining('protection de vos données');
        expect(linkFinder, findsOneWidget);

        await tester.tap(linkFinder);
        await tester.pumpAndSettle();

        // Dialogue affiché
        expect(find.byType(AlertDialog), findsOneWidget);
        expect(find.textContaining('AES-256-GCM'), findsOneWidget);

        // Fermeture du dialogue
        await tester.tap(find.text('Compris'));
        await tester.pumpAndSettle();

        expect(find.byType(AlertDialog), findsNothing);
      },
    );
  });
}
