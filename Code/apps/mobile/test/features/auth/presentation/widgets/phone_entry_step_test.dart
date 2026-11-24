import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:sanaya/app/providers.dart';
import 'package:sanaya/core/i18n/translations.g.dart';
import 'package:sanaya/features/auth/presentation/widgets/phone_entry_step.dart';
import 'package:sanaya/features/settings/presentation/legal_notice_screen.dart';

import '../../../../core/widgets/widget_test_helpers.dart';
import '../../../../support/overflow_guard.dart';

void main() {
  final t = AppLocale.fr.buildSync();

  Widget buildStep({ValueChanged<String>? onSubmit}) {
    return ProviderScope(
      overrides: [localeProvider.overrideWith((ref) => const Locale('fr'))],
      child: themedApp(
        PhoneEntryStep(
          translations: t,
          isSubmitting: false,
          errorMessage: null,
          onSubmit: onSubmit ?? (_) {},
        ),
      ),
    );
  }

  group('FM-33b — PhoneEntryStep', () {
    testWidgets('affiche le titre, le sous-titre et le préfixe +216', (
      tester,
    ) async {
      await tester.pumpWidget(buildStep());

      expect(find.text(t.auth.phoneTitle), findsOneWidget);
      expect(find.text(t.auth.phoneSubtitle), findsOneWidget);
      expect(find.text('+216'), findsOneWidget);
    });

    testWidgets(
      'la mention légale ouvre LegalNoticeScreen sans passer par le routeur',
      (tester) async {
        await tester.pumpWidget(buildStep());

        await tester.tap(find.text(t.auth.legalConsent));
        await tester.pumpAndSettle();

        expect(find.byType(LegalNoticeScreen), findsOneWidget);
      },
    );

    testWidgets(
      'MOB-010 — aucun débordement RenderFlex sur écran compact ou clavier '
      'ouvert // régression #MOB-010',
      (tester) async {
        tester.view.physicalSize = const Size(360, 300);
        tester.view.devicePixelRatio = 1.0;
        addTearDown(() {
          tester.view.resetPhysicalSize();
          tester.view.resetDevicePixelRatio();
        });

        final errors = await captureFlutterErrors(() async {
          await tester.pumpWidget(buildStep());
          await tester.pumpAndSettle();
        });

        expect(
          errors.where((e) => e.toString().contains('overflowed')),
          isEmpty,
          reason: 'Doit ne générer aucun overflow RenderFlex',
        );
        expect(find.byType(SingleChildScrollView), findsOneWidget);

        await tester.scrollUntilVisible(
          find.text(t.auth.legalConsent),
          50,
          scrollable: find.byType(Scrollable).first,
        );
        expect(find.text(t.auth.legalConsent), findsOneWidget);
      },
    );
  });
}
