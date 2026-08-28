import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:sanaya/app/providers.dart';
import 'package:sanaya/features/settings/presentation/legal_notice_screen.dart';

import '../../../core/widgets/widget_test_helpers.dart';

void main() {
  Widget buildScreen({Locale locale = const Locale('fr')}) {
    return ProviderScope(
      overrides: [
        localeProvider.overrideWith((ref) => locale),
      ],
      child: themedApp(
        const LegalNoticeScreen(),
        locale: locale,
      ),
    );
  }

  group('LegalNoticeScreen', () {
    testWidgets('affiche les 4 sections légales en français', (tester) async {
      await tester.pumpWidget(buildScreen());
      await tester.pumpAndSettle();

      expect(find.text('Mentions légales'), findsOneWidget);
      expect(find.text('Éditeur de la plateforme'), findsOneWidget);
      expect(find.text('Modèle de service'), findsOneWidget);
      expect(
        find.text('Protection des données personnelles (INPDP)'),
        findsOneWidget,
      );
      expect(find.text('Vos droits'), findsOneWidget);
    });

    testWidgets('se rend en arabe sans exception (RTL)', (tester) async {
      await tester.pumpWidget(buildScreen(locale: const Locale('ar')));
      await tester.pumpAndSettle();

      expect(find.text('الإشعارات القانونية'), findsOneWidget);
      expect(find.text('الجهة المشرفة على المنصة'), findsOneWidget);
      expect(find.text('نموذج الخدمة'), findsOneWidget);
      expect(
        find.text('حماية البيانات الشخصية (INPDP)'),
        findsOneWidget,
      );
      expect(find.text('حقوقكم'), findsOneWidget);
    });
  });
}
