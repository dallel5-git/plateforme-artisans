import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:sanaya/app/providers.dart';
import 'package:sanaya/core/i18n/translations.g.dart';
import 'package:sanaya/features/auth/presentation/widgets/phone_entry_step.dart';
import 'package:sanaya/features/settings/presentation/legal_notice_screen.dart';

import '../../../../core/widgets/widget_test_helpers.dart';

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
  });
}
