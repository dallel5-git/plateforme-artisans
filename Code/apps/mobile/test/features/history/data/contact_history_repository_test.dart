import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:sanaya/core/api/generated/api.dart';
import 'package:sanaya/features/history/data/contact_history_repository.dart';

class _ContactEventsApiMock extends Mock implements ContactEventsApi {}

Response<T> _okResponse<T>(String path, T data) => Response<T>(
  requestOptions: RequestOptions(path: path),
  statusCode: 200,
  data: data,
);

void main() {
  late _ContactEventsApiMock api;
  late ContactHistoryRepository repository;

  setUp(() {
    api = _ContactEventsApiMock();
    repository = ContactHistoryRepository(api);
  });

  group('ContactHistoryRepository.fetchHistory', () {
    test(
      "renvoie l'historique de contacts paginé depuis /v1/contact-events",
      () async {
        final item = ContactHistoryItem(
          (b) => b
            ..id = 'evt-1'
            ..providerId = 'prov-1'
            ..slug = 'sami-plombier'
            ..businessName = 'Sami Plomberie'
            ..categoryName = 'Plombier'
            ..channel = V1ContactEventsGet200ResponseItemsInnerChannelEnum.PHONE
            ..contactedAt = DateTime.utc(2026, 9)
            ..hasReview = false,
        );

        final responseDto = ContactHistoryPage(
          (b) => b
            ..items.add(item)
            ..nextCursor = 'cursor-next-123',
        );

        when(
          () => api.v1ContactEventsGet(
            cursor: any(named: 'cursor'),
            limit: any(named: 'limit'),
          ),
        ).thenAnswer(
          (_) async => _okResponse('/v1/contact-events', responseDto),
        );

        final result = await repository.fetchHistory(cursor: 'cursor-1');

        expect(result.items.length, 1);
        expect(result.items.first.providerId, 'prov-1');
        expect(result.items.first.hasReview, false);
        expect(result.nextCursor, 'cursor-next-123');
        verify(() => api.v1ContactEventsGet(cursor: 'cursor-1')).called(1);
      },
    );

    test("propage l'exception en cas d'échec réseau", () async {
      when(
        () => api.v1ContactEventsGet(
          cursor: any(named: 'cursor'),
          limit: any(named: 'limit'),
        ),
      ).thenThrow(
        DioException(
          requestOptions: RequestOptions(path: '/v1/contact-events'),
        ),
      );

      expect(() => repository.fetchHistory(), throwsA(isA<DioException>()));
    });
  });
}
