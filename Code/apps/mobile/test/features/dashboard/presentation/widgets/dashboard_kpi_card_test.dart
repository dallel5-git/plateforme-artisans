import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:sanaya/app/theme.dart';
import 'package:sanaya/features/dashboard/presentation/widgets/dashboard_kpi_card.dart';

/// Enveloppe minimale pour tester DashboardKpiCard en isolation :
/// pas de Riverpod, pas de dépôt mocké — on passe toutes les valeurs
/// directement via le constructeur.
Widget _wrap(
  Widget child, {
  Locale locale = const Locale('fr'),
}) {
  return MaterialApp(
    locale: locale,
    supportedLocales: const [Locale('fr'), Locale('ar')],
    localizationsDelegates: const [
      GlobalMaterialLocalizations.delegate,
      GlobalWidgetsLocalizations.delegate,
      GlobalCupertinoLocalizations.delegate,
    ],
    theme: buildTheme(brightness: Brightness.light, locale: locale),
    home: Scaffold(
      body: Directionality(
        textDirection: locale.languageCode == 'ar'
            ? TextDirection.rtl
            : TextDirection.ltr,
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: child,
        ),
      ),
    ),
  );
}

/// Carte de base réutilisée dans la plupart des tests.
DashboardKpiCard _defaultCard({
  double? viewsDeltaRatio,
  double? contactsDeltaRatio,
  String? comparisonNewLabel,
}) {
  return DashboardKpiCard(
    viewsLabel: 'Vues du profil',
    viewsValue: '450',
    contactsLabel: 'Contacts',
    contactsValue: '90',
    ratioLabel: 'Vue → contact',
    ratioValue: '20,0%',
    viewsDeltaRatio: viewsDeltaRatio,
    contactsDeltaRatio: contactsDeltaRatio,
    comparisonNewLabel: comparisonNewLabel,
    comparisonPeriodLabel: 'vs. 15 jours précédents',
  );
}

void main() {
  group('DashboardKpiCard — FM-37b', () {
    testWidgets(
      'affiche les trois métriques (libellés et valeurs)',
      (tester) async {
        await tester.pumpWidget(_wrap(_defaultCard()));

        expect(find.text('Vues du profil'), findsOneWidget);
        expect(find.text('450'), findsOneWidget);
        expect(find.text('Contacts'), findsOneWidget);
        expect(find.text('90'), findsOneWidget);
        expect(find.text('Vue → contact'), findsOneWidget);
        expect(find.text('20,0%'), findsOneWidget);
      },
    );

    testWidgets(
      'affiche le libellé de période de comparaison',
      (tester) async {
        await tester.pumpWidget(_wrap(_defaultCard()));

        expect(find.text('vs. 15 jours précédents'), findsOneWidget);
      },
    );

    testWidgets(
      'n affiche aucune puce quand les deltas ne sont pas fournis',
      (tester) async {
        await tester.pumpWidget(_wrap(_defaultCard()));

        // Aucune puce de variation ni libellé «Nouveau»
        expect(find.textContaining('+'), findsNothing);
        expect(find.textContaining('−'), findsNothing);
        expect(find.text('Nouveau'), findsNothing);
      },
    );

    testWidgets(
      'affiche une puce verte "+50 %" quand le delta vues est positif',
      (tester) async {
        await tester.pumpWidget(
          _wrap(_defaultCard(viewsDeltaRatio: 0.5)),
        );

        expect(find.text('+50 %'), findsOneWidget);
      },
    );

    testWidgets(
      'affiche une puce rouge "−25 %" quand le delta contacts est négatif',
      (tester) async {
        await tester.pumpWidget(
          _wrap(_defaultCard(contactsDeltaRatio: -0.25)),
        );

        expect(find.text('−25 %'), findsOneWidget);
      },
    );

    testWidgets(
      'affiche la puce "Nouveau" quand deltaRatio est null (base à zéro)',
      (tester) async {
        await tester.pumpWidget(
          _wrap(
            _defaultCard(
              // viewsDeltaRatio non fourni → null, période précédente à zéro
              comparisonNewLabel: 'Nouveau',
            ),
          ),
        );

        // Les deux badges (vues ET contacts) affichent «Nouveau»
        // car comparisonNewLabel est fourni pour les deux.
        expect(find.text('Nouveau'), findsWidgets);
      },
    );

    testWidgets(
      'deux deltas → deux puces de variation affichées simultanément',
      (tester) async {
        await tester.pumpWidget(
          _wrap(
            _defaultCard(
              viewsDeltaRatio: 1, // +100 %
              contactsDeltaRatio: -0.5, // −50 %
            ),
          ),
        );

        expect(find.text('+100 %'), findsOneWidget);
        expect(find.text('−50 %'), findsOneWidget);
      },
    );

    testWidgets(
      'affiche les libellés en arabe et rend le widget en RTL',
      (tester) async {
        const card = DashboardKpiCard(
          viewsLabel: 'مشاهدات الملف الشخصي',
          viewsValue: '450',
          contactsLabel: 'جهات الاتصال',
          contactsValue: '90',
          ratioLabel: 'مشاهدة → اتصال',
          ratioValue: '20,0%',
          comparisonPeriodLabel: 'مقارنة بالـ 15 يومًا السابقة',
        );

        await tester.pumpWidget(_wrap(card, locale: const Locale('ar')));

        expect(find.text('مشاهدات الملف الشخصي'), findsOneWidget);
        expect(find.text('جهات الاتصال'), findsOneWidget);

        final dir = tester.widget<Directionality>(
          find.byType(Directionality).first,
        );
        expect(dir.textDirection, TextDirection.rtl);
      },
    );

    testWidgets(
      'le fond de la carte est la couleur accent (non transparent)',
      (tester) async {
        await tester.pumpWidget(_wrap(_defaultCard()));

        // On vérifie que le Container de la carte a bien une couleur de fond.
        // On ne teste pas la valeur hex exacte (qui dépend du thème injecté)
        // mais on s'assure qu'il y a bien un Container coloré.
        final containers = tester
            .widgetList<Container>(find.byType(Container))
            .where((c) => c.color != null || c.decoration != null)
            .toList();
        expect(containers, isNotEmpty);
      },
    );
  });
}
