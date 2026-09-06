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

import '../../../../support/overflow_guard.dart';

class _DashboardRepositoryMock extends Mock implements DashboardRepository {}

// Même patron que dashboard_screen_test.dart : 15 points bas, 15 hauts.
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
      ..series = ListBuilder<ProviderStatsSeriesPoint>(points),
  );
}

Widget _wrap({
  required DashboardRepository repository,
  required Locale locale,
  required TextScaler textScaler,
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
      builder: (context, child) => MediaQuery(
        data: MediaQuery.of(context).copyWith(textScaler: textScaler),
        child: child!,
      ),
      home: Directionality(
        textDirection: locale.languageCode == 'ar'
            ? TextDirection.rtl
            : TextDirection.ltr,
        child: const DashboardScreen(),
      ),
    ),
  );
}

/// FM-43 — étend le patron `TextScaler` 1.3 (FM-17b) à `DashboardScreen`,
/// jusqu'ici non couvert (l'écran le plus dense de l'Espace Pro : carte KPI,
/// puces de variation, histogramme 7 barres, tous porteurs de texte).
void main() {
  group('FM-43 — DashboardScreen, TextScaler 1.3 (accessibilité)', () {
    testWidgets('aucun débordement à 130% avec des stats denses, en français', (
      tester,
    ) async {
      await tester.binding.setSurfaceSize(const Size(360, 800));
      addTearDown(() => tester.binding.setSurfaceSize(null));

      final repo = _DashboardRepositoryMock();
      when(repo.fetchStats).thenAnswer((_) async => _buildStats());

      final errors = await captureFlutterErrors(() async {
        await tester.pumpWidget(
          _wrap(
            repository: repo,
            locale: const Locale('fr'),
            textScaler: const TextScaler.linear(1.3),
          ),
        );
        await tester.pumpAndSettle();
      });

      expect(
        errors,
        isEmpty,
        reason: errors.map((e) => e.exceptionAsString()).join('\n'),
      );
    });

    testWidgets(
      'aucun débordement à 130% avec des stats denses, en arabe (RTL)',
      (tester) async {
        await tester.binding.setSurfaceSize(const Size(360, 800));
        addTearDown(() => tester.binding.setSurfaceSize(null));

        final repo = _DashboardRepositoryMock();
        when(repo.fetchStats).thenAnswer((_) async => _buildStats());

        final errors = await captureFlutterErrors(() async {
          await tester.pumpWidget(
            _wrap(
              repository: repo,
              locale: const Locale('ar'),
              textScaler: const TextScaler.linear(1.3),
            ),
          );
          await tester.pumpAndSettle();
        });

        expect(
          errors,
          isEmpty,
          reason: errors.map((e) => e.exceptionAsString()).join('\n'),
        );
      },
    );
  });
}
