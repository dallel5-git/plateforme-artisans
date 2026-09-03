import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:sanaya/core/api/generated/api.dart';
import 'package:sanaya/features/dashboard/data/dashboard_repository.dart';

class MockDefaultApi extends Mock implements DefaultApi {}

/// Crée une [RequestOptions] minimale pour les fakes de [Response].
RequestOptions _opts([String path = '/']) => RequestOptions(path: path);

void main() {
  late MockDefaultApi mockApi;
  late DashboardRepository repository;

  setUp(() {
    mockApi = MockDefaultApi();
    repository = DashboardRepository(mockApi);
  });

  group('fetchStats', () {
    test('appelle v1ProvidersMeStatsGet et retourne les données', () async {
      final stats = ProviderStats(
        (b) => b
          ..totals.profileViews = 120
          ..totals.uniqueProfileViews = 90
          ..totals.contacts = 12
          ..totals.contactsByChannel.phone = 8
          ..totals.contactsByChannel.whatsapp = 4
          ..totals.viewToContactRatio = 0.1,
      );
      final fakeResponse = Response<ProviderStats>(
        requestOptions: _opts('/v1/providers/me/stats'),
        statusCode: 200,
        data: stats,
      );

      when(
        () => mockApi.v1ProvidersMeStatsGet(),
      ).thenAnswer((_) async => fakeResponse);

      final result = await repository.fetchStats();

      expect(result.totals.profileViews, 120);
      expect(result.totals.contacts, 12);
      verify(() => mockApi.v1ProvidersMeStatsGet()).called(1);
    });

    test('propage DioException si l API renvoie une erreur', () async {
      when(() => mockApi.v1ProvidersMeStatsGet()).thenThrow(
        DioException(
          requestOptions: _opts('/v1/providers/me/stats'),
          type: DioExceptionType.badResponse,
        ),
      );

      await expectLater(
        repository.fetchStats(),
        throwsA(isA<DioException>()),
      );
    });
  });
}
