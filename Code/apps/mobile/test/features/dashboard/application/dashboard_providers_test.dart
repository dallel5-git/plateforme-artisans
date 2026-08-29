import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:sanaya/features/dashboard/application/dashboard_providers.dart';
import 'package:sanaya/features/dashboard/data/dashboard_repository.dart';

class _DashboardRepositoryMock extends Mock implements DashboardRepository {}

void main() {
  late _DashboardRepositoryMock repository;
  late ProviderStats sampleStats;

  setUp(() {
    repository = _DashboardRepositoryMock();
    sampleStats = ProviderStats(
      (b) => b
        ..totals.profileViews = 120
        ..totals.uniqueProfileViews = 90
        ..totals.contacts = 12
        ..totals.viewToContactRatio = 0.1,
    );
  });

  ProviderContainer createContainer() {
    final container = ProviderContainer(
      overrides: [dashboardRepositoryProvider.overrideWithValue(repository)],
    );
    addTearDown(container.dispose);
    return container;
  }

  group('dashboardStatsProvider', () {
    test('charge les statistiques avec succès', () async {
      when(() => repository.fetchStats()).thenAnswer((_) async => sampleStats);

      final container = createContainer();

      final stats = await container.read(dashboardStatsProvider.future);

      expect(stats.totals.profileViews, 120);
      expect(stats.totals.contacts, 12);
      verify(() => repository.fetchStats()).called(1);
    });

    test('propage l’erreur en état AsyncError', () async {
      when(() => repository.fetchStats()).thenThrow(Exception('Erreur réseau'));

      final container = createContainer();

      await expectLater(
        container.read(dashboardStatsProvider.future),
        throwsA(isA<Exception>()),
      );
      expect(container.read(dashboardStatsProvider).hasError, isTrue);
    });

    test('ref.invalidate recharge les données', () async {
      var callCount = 0;
      when(() => repository.fetchStats()).thenAnswer((_) async {
        callCount++;
        return sampleStats;
      });

      final container = createContainer();
      await container.read(dashboardStatsProvider.future);
      container.invalidate(dashboardStatsProvider);
      await container.read(dashboardStatsProvider.future);

      expect(callCount, 2);
    });
  });
}
