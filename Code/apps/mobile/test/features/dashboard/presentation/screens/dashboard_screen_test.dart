import 'dart:async';

import 'package:built_collection/built_collection.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:sanaya/app/providers.dart';
import 'package:sanaya/app/theme.dart';
import 'package:sanaya/features/dashboard/application/dashboard_providers.dart';
import 'package:sanaya/features/dashboard/data/dashboard_repository.dart';
import 'package:sanaya/features/dashboard/presentation/screens/dashboard_screen.dart';

class _DashboardRepositoryMock extends Mock implements DashboardRepository {}

// 30 points chronologiques (le plus ancien en premier, cf.
// dashboard_comparison.dart) : 15 premiers à 10 vues/2 contacts, 15 derniers
// à 20 vues/4 contacts — permet de vérifier une variation mois-1 positive
// affichée ("+100,0 %").
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

Widget _wrap({
  required DashboardRepository repository,
  Locale locale = const Locale('fr'),
}) {
  return ProviderScope(
    overrides: [
      localeProvider.overrideWith((ref) => locale),
      dashboardRepositoryProvider.overrideWithValue(repository),
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
  group('DashboardScreen', () {
    testWidgets('affiche le skeleton pendant le chargement', (tester) async {
      final repo = _DashboardRepositoryMock();
      final completer = Completer<ProviderStats>();
      when(repo.fetchStats).thenAnswer((_) => completer.future);

      await tester.pumpWidget(_wrap(repository: repo));

      expect(find.byType(DashboardScreen), findsOneWidget);
      expect(find.text('Vues du profil'), findsNothing);
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
      },
    );

    testWidgets('affiche les totaux et la variation mois-1', (tester) async {
      final repo = _DashboardRepositoryMock();
      when(repo.fetchStats).thenAnswer((_) async => _buildStats());

      await tester.pumpWidget(_wrap(repository: repo));
      await tester.pumpAndSettle();

      expect(find.text('450'), findsOneWidget);
      expect(find.text('405'), findsOneWidget);
      expect(find.text('90'), findsOneWidget);
      expect(find.text('20,0%'), findsOneWidget);
      expect(find.text('+100,0%'), findsWidgets);
    });

    testWidgets('affiche "Nouveau" quand la période précédente est à zéro', (
      tester,
    ) async {
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

      expect(find.text('Nouveau'), findsWidgets);
    });

    testWidgets('affiche les libellés traduits en arabe et supporte le RTL', (
      tester,
    ) async {
      final repo = _DashboardRepositoryMock();
      when(repo.fetchStats).thenAnswer((_) async => _buildStats());

      await tester.pumpWidget(
        _wrap(repository: repo, locale: const Locale('ar')),
      );
      await tester.pumpAndSettle();

      expect(find.text('لوحة التحكم'), findsOneWidget);
      expect(find.text('مشاهدات الملف الشخصي'), findsOneWidget);

      final directionality = tester.widget<Directionality>(
        find.byType(Directionality).first,
      );
      expect(directionality.textDirection, TextDirection.rtl);
    });
  });
}
