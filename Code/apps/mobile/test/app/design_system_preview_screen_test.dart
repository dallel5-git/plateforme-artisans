import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:sanaya/app/design_system_preview_screen.dart';
import 'package:sanaya/app/providers.dart';
import 'package:sanaya/app/theme.dart';

Widget _wrap(Locale locale) {
  return ProviderScope(
    overrides: [localeProvider.overrideWith((ref) => locale)],
    child: MaterialApp(
      locale: locale,
      supportedLocales: const [Locale('fr'), Locale('ar')],
      localizationsDelegates: const [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      theme: buildTheme(brightness: Brightness.light, locale: locale),
      home: const DesignSystemPreviewScreen(),
    ),
  );
}

void main() {
  group('FM-18c — DesignSystemPreviewScreen, aucune chaîne en dur', () {
    testWidgets('affiche les libellés traduits en français', (tester) async {
      // Surface haute : le ListView de la vitrine dépasse largement le
      // viewport de test par défaut (800×600), et un `ListView(children:)`
      // ne construit que les enfants proches du viewport — les sections plus
      // bas (ProviderCard, EmptyState…) resteraient absentes de l'arbre.
      await tester.binding.setSurfaceSize(const Size(800, 4000));
      addTearDown(() => tester.binding.setSurfaceSize(null));

      await tester.pumpWidget(_wrap(const Locale('fr')));
      await tester.pump();

      expect(find.text('AppButton'), findsOneWidget);
      expect(find.text('Primary'), findsOneWidget);
      expect(find.text('Karim Ben Salah'), findsOneWidget);
      expect(find.text('Aucun artisan trouvé'), findsOneWidget);
      expect(find.text('Connexion perdue'), findsOneWidget);
    });

    testWidgets('affiche les libellés traduits en arabe (pas de repli FR)', (
      tester,
    ) async {
      await tester.binding.setSurfaceSize(const Size(800, 4000));
      addTearDown(() => tester.binding.setSurfaceSize(null));

      await tester.pumpWidget(_wrap(const Locale('ar')));
      await tester.pump();

      // Les identifiants de classe (AppButton…) restent inchangés dans les
      // deux locales (comme t.common.appName = « Sanaya ») — seul le
      // contenu traduisible doit différer du français.
      expect(find.text('AppButton'), findsOneWidget);
      expect(find.text('أساسي'), findsOneWidget);
      expect(find.text('كريم بن صالح'), findsOneWidget);
      expect(find.text('لم يتم العثور على أي حرفي'), findsOneWidget);
      expect(find.text('انقطع الاتصال'), findsOneWidget);

      // Non-régression : si un libellé retombe sur un littéral français
      // codé en dur, ce texte français apparaîtrait aussi en arabe.
      expect(find.text('Primary'), findsNothing);
      expect(find.text('Karim Ben Salah'), findsNothing);
    });
  });
}
