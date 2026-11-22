import 'dart:async';

import 'package:built_collection/built_collection.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:sanaya/app/providers.dart';
import 'package:sanaya/app/theme.dart';
import 'package:sanaya/core/widgets/app_bar_chart.dart';
import 'package:sanaya/core/widgets/empty_state.dart';
import 'package:sanaya/features/dashboard/application/dashboard_providers.dart';
import 'package:sanaya/features/dashboard/data/dashboard_repository.dart';
import 'package:sanaya/features/dashboard/presentation/screens/dashboard_screen.dart';
import 'package:sanaya/features/dashboard/presentation/widgets/dashboard_kpi_card.dart';
import 'package:sanaya/features/reviews/application/pro_reviews_providers.dart';

class _DashboardRepositoryMock extends Mock implements DashboardRepository {}

// 30 points chronologiques (le plus ancien en premier, cf.
// dashboard_comparison.dart) : 15 premiers à 10 vues/2 contacts, 15 derniers
// à 20 vues/4 contacts — variation mois-1 positive (+100 %).
ProviderStats _buildStats() {
  final points = List.generate(30, (i) {
    final isCurrentHalf = i >= 15;
    return ProviderStatsSeriesPoint(
      (b) => b
        ..date = DateTime.utc(2026, 8, i + 1)
        ..profileViews = isCurrentHalf ? 20 : 10
        ..uniqueProfileViews = isCurrentHalf ? 18 : 9
        ..contacts = isCurrentHalf ? 4 : 2,
    );
  });

  return ProviderStats(
    (b) => b
      ..totals.profileViews = 450
      ..totals.uniqueProfileViews = 405
      ..totals.contacts = 90
      ..totals.contactsByChannel.phone = 60
      ..totals.contactsByChannel.whatsapp = 30
      ..totals.viewToContactRatio = 0.2
      ..series = ListBuilder<ProviderStatsSeriesPoint>(
        points,
      ),
  );
}

/// Stats où profileViews == 0 : déclenche l'état vide (FM-37c).
ProviderStats _buildZeroStats() {
  final points = List.generate(
    30,
    (i) => ProviderStatsSeriesPoint(
      (b) => b
        ..date = DateTime.utc(2026, 8, i + 1)
        ..profileViews = 0
        ..uniqueProfileViews = 0
        ..contacts = 0,
    ),
  );
  return ProviderStats(
    (b) => b
      ..totals.profileViews = 0
      ..totals.uniqueProfileViews = 0
      ..totals.contacts = 0
      ..totals.contactsByChannel.phone = 0
      ..totals.contactsByChannel.whatsapp = 0
      ..totals.viewToContactRatio = 0
      ..series = ListBuilder<ProviderStatsSeriesPoint>(points),
  );
}

Widget _wrap({
  required DashboardRepository repository,
  Locale locale = const Locale('fr'),
}) {
  return ProviderScope(
    overrides: [
      localeProvider.overrideWith((ref) => locale),
      dashboardRepositoryProvider.overrideWithValue(repository),
      myProviderProfileProvider.overrideWith((ref) async => null),
    ],
    child: MaterialApp(
      locale: locale,
      supportedLocales: const [Locale('fr'), Locale('ar')],
      localizationsDelegates: const [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      theme: buildTheme(brightness: Brightness.light, locale: locale),
      home: Directionality(
        textDirection: locale.languageCode == 'ar'
            ? TextDirection.rtl
            : TextDirection.ltr,
        child: const DashboardScreen(),
      ),
    ),
  );
}

void main() {
  group('DashboardScreen — FM-37b & FM-37c', () {
    testWidgets('affiche le skeleton pendant le chargement', (tester) async {
      final repo = _DashboardRepositoryMock();
      final completer = Completer<ProviderStats>();
      when(repo.fetchStats).thenAnswer((_) => completer.future);

      await tester.pumpWidget(_wrap(repository: repo));

      // DashboardKpiCard n'est pas encore rendu — seul le skeleton l'est.
      expect(find.byType(DashboardKpiCard), findsNothing);
      expect(find.byType(DashboardScreen), findsOneWidget);
    });

    testWidgets(
      'affiche un état d erreur avec bouton Réessayer en cas d échec',
      (tester) async {
        final repo = _DashboardRepositoryMock();
        when(repo.fetchStats).thenThrow(Exception('network'));

        await tester.pumpWidget(_wrap(repository: repo));
        await tester.pumpAndSettle();

        expect(
          find.text('Impossible de charger le tableau de bord'),
          findsOneWidget,
        );
        expect(find.text('Réessayer'), findsOneWidget);
        expect(find.byType(DashboardKpiCard), findsNothing);
      },
    );

    testWidgets(
      'affiche DashboardKpiCard avec les valeurs Vues / Contacts / Ratio',
      (tester) async {
        final repo = _DashboardRepositoryMock();
        when(repo.fetchStats).thenAnswer((_) async => _buildStats());

        await tester.pumpWidget(_wrap(repository: repo));
        await tester.pumpAndSettle();

        // Une seule carte KPI doit être présente (remplace la grille 2×2).
        expect(find.byType(DashboardKpiCard), findsOneWidget);

        // Valeurs numériques clés
        expect(find.text('450'), findsOneWidget); // profileViews
        expect(find.text('90'), findsOneWidget); // contacts
        expect(find.text('20,0%'), findsOneWidget); // ratio

        // Les visiteurs uniques (405) ne sont plus affichés dans la carte.
        expect(find.text('405'), findsNothing);
      },
    );

    testWidgets(
      'affiche les puces de variation mois-1 (+100 %) dans la carte KPI',
      (tester) async {
        final repo = _DashboardRepositoryMock();
        when(repo.fetchStats).thenAnswer((_) async => _buildStats());

        await tester.pumpWidget(_wrap(repository: repo));
        await tester.pumpAndSettle();

        // La variation vues (+100 %) et contacts (+100 %) doivent apparaître.
        // Le format est «+100 %» (chiffre entier, signe, espace avant %).
        expect(find.textContaining('+100'), findsWidgets);
      },
    );

    testWidgets(
      'affiche "Nouveau" quand la période précédente est à zéro',
      (tester) async {
        final repo = _DashboardRepositoryMock();
        final points = List.generate(
          30,
          (i) => ProviderStatsSeriesPoint(
            (b) => b
              ..date = DateTime.utc(2026, 8, i + 1)
              ..profileViews = i >= 15 ? 5 : 0
              ..uniqueProfileViews = i >= 15 ? 5 : 0
              ..contacts = i >= 15 ? 1 : 0,
          ),
        );
        final stats = ProviderStats(
          (b) => b
            ..totals.profileViews = 5
            ..totals.uniqueProfileViews = 5
            ..totals.contacts = 1
            ..totals.contactsByChannel.phone = 1
            ..totals.contactsByChannel.whatsapp = 0
            ..totals.viewToContactRatio = 0.2
            ..series = ListBuilder<ProviderStatsSeriesPoint>(
              points,
            ),
        );
        when(repo.fetchStats).thenAnswer((_) async => stats);

        await tester.pumpWidget(_wrap(repository: repo));
        await tester.pumpAndSettle();

        // Quand le delta est nul (base à zéro), la puce affiche «Nouveau».
        expect(find.text('Nouveau'), findsWidgets);
      },
    );

    // FM-37c — histogramme 7 barres
    testWidgets(
      'affiche AppBarChart quand profileViews > 0',
      (tester) async {
        final repo = _DashboardRepositoryMock();
        when(repo.fetchStats).thenAnswer((_) async => _buildStats());

        await tester.pumpWidget(_wrap(repository: repo));
        await tester.pumpAndSettle();

        expect(find.byType(AppBarChart), findsOneWidget);
        // Titre 7 jours
        expect(find.text('Vues sur 7 jours'), findsOneWidget);
        // Libellés J-6 … J
        expect(find.text('J-6'), findsOneWidget);
        expect(find.text('J'), findsOneWidget);
      },
    );

    testWidgets(
      'affiche EmptyState quand profileViews == 0 (FM-37c)',
      (tester) async {
        final repo = _DashboardRepositoryMock();
        when(repo.fetchStats).thenAnswer((_) async => _buildZeroStats());

        await tester.pumpWidget(_wrap(repository: repo));
        await tester.pumpAndSettle();

        expect(find.byType(EmptyState), findsOneWidget);
        expect(
          find.text("Aucune vue pour l'instant"),
          findsOneWidget,
        );
        // Le graphique ne doit PAS être affiché quand profileViews == 0.
        expect(find.byType(AppBarChart), findsNothing);
      },
    );

    testWidgets(
      'affiche les libellés traduits en arabe et supporte le RTL',
      (tester) async {
        final repo = _DashboardRepositoryMock();
        when(repo.fetchStats).thenAnswer((_) async => _buildStats());

        await tester.pumpWidget(
          _wrap(repository: repo, locale: const Locale('ar')),
        );
        await tester.pumpAndSettle();

        // Titre de l'en-tête / carte KPI
        expect(find.text('مشاهدات الملف الشخصي'), findsOneWidget);

        final directionality = tester.widget<Directionality>(
          find.byType(Directionality).first,
        );
        expect(directionality.textDirection, TextDirection.rtl);
      },
    );

    testWidgets(
      'affiche les sections enrichies : actions rapides, canaux, activité, '
      'réputation et conseils pro',
      (tester) async {
        final repo = _DashboardRepositoryMock();
        when(repo.fetchStats).thenAnswer((_) async => _buildStats());

        await tester.pumpWidget(_wrap(repository: repo));
        await tester.pumpAndSettle();

        // 1. Actions rapides
        expect(find.text('Actions rapides'), findsOneWidget);
        expect(find.text('Partager'), findsOneWidget);
        expect(find.text('Ma vitrine'), findsOneWidget);
        expect(find.text('Booster'), findsOneWidget);
        expect(find.text('Mon profil'), findsOneWidget);

        // 2. Canaux de contact
        expect(find.text('Répartition des contacts'), findsOneWidget);
        expect(find.text('Appels directs'), findsOneWidget);
        expect(find.text('Messages WhatsApp'), findsOneWidget);
        expect(find.text('60 (67%)'), findsOneWidget);
        expect(find.text('30 (33%)'), findsOneWidget);

        // 3. Activité récente
        expect(find.text('Activité récente & demandes'), findsOneWidget);
        expect(find.text('Demande WhatsApp reçue'), findsOneWidget);
        expect(find.text('Appel direct reçu'), findsOneWidget);

        // 4. Réputation
        expect(find.text('Avis & Réputation'), findsOneWidget);
        expect(find.text('Consulter tous les avis'), findsOneWidget);

        // 5. Conseils et bannière Boost
        expect(find.text('Multipliez vos demandes par 3'), findsOneWidget);
        expect(find.text('Conseils pour votre activité'), findsOneWidget);
      },
    );

    testWidgets(
      'affiche les sections enrichies traduites en arabe',
      (tester) async {
        final repo = _DashboardRepositoryMock();
        when(repo.fetchStats).thenAnswer((_) async => _buildStats());

        await tester.pumpWidget(
          _wrap(repository: repo, locale: const Locale('ar')),
        );
        await tester.pumpAndSettle();

        expect(find.text('إجراءات سريعة'), findsOneWidget);
        expect(find.text('توزيع الاتصالات'), findsOneWidget);
        expect(find.text('النشاط الأخير والطلبات'), findsOneWidget);
        expect(find.text('التقييمات والسمعة'), findsOneWidget);
        expect(find.text('نصائح لتطوير نشاطك'), findsOneWidget);
      },
    );
  });
}

