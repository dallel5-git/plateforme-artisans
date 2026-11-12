import 'dart:typed_data';

import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:sanaya/core/demo/demo_mock_interceptor.dart';
import 'package:sanaya/core/demo/demo_mode_provider.dart';

class _PassthroughAdapter implements HttpClientAdapter {
  int fetchCallCount = 0;

  @override
  Future<ResponseBody> fetch(
    RequestOptions options,
    Stream<Uint8List>? requestStream,
    Future<void>? cancelFuture,
  ) async {
    fetchCallCount++;
    return ResponseBody.fromString(
      '{"passthrough": true}',
      200,
      headers: {
        Headers.contentTypeHeader: [Headers.jsonContentType],
      },
    );
  }

  @override
  void close({bool force = false}) {}
}

void main() {
  group('DemoMockInterceptor', () {
    test('passes through to network adapter when demoMode is false', () async {
      final dio = Dio();
      final adapter = _PassthroughAdapter();
      dio.httpClientAdapter = adapter;
      dio.interceptors.add(
        DemoMockInterceptor(
          isDemoMode: () => false,
          getDemoRole: () => DemoRole.client,
        ),
      );

      final response = await dio.get<Map<String, dynamic>>('/v1/categories');
      expect(response.statusCode, 200);
      expect(response.data?['passthrough'], isTrue);
      expect(adapter.fetchCallCount, 1);
    });

    test('intercepts /v1/categories with mock data', () async {
      final dio = Dio();
      final adapter = _PassthroughAdapter();
      dio.httpClientAdapter = adapter;
      dio.interceptors.add(
        DemoMockInterceptor(
          isDemoMode: () => true,
          getDemoRole: () => DemoRole.client,
        ),
      );

      final response = await dio.get<Map<String, dynamic>>('/v1/categories');
      expect(response.statusCode, 200);
      expect(response.data?['categories'], isNotEmpty);
      expect(adapter.fetchCallCount, 0);
    });

    test('intercepts /v1/providers/search with filters', () async {
      final dio = Dio();
      final adapter = _PassthroughAdapter();
      dio.httpClientAdapter = adapter;
      dio.interceptors.add(
        DemoMockInterceptor(
          isDemoMode: () => true,
          getDemoRole: () => DemoRole.client,
        ),
      );

      final response = await dio.get<Map<String, dynamic>>(
        '/v1/providers/search',
        queryParameters: {'query': 'plombier'},
      );
      expect(response.statusCode, 200);
      expect(response.data?['items'], isA<List<dynamic>>());
      expect(adapter.fetchCallCount, 0);
    });

    test('intercepts /v1/providers/:slug detail and reviews', () async {
      final dio = Dio();
      final adapter = _PassthroughAdapter();
      dio.httpClientAdapter = adapter;
      dio.interceptors.add(
        DemoMockInterceptor(
          isDemoMode: () => true,
          getDemoRole: () => DemoRole.client,
        ),
      );

      final detail = await dio.get<Map<String, dynamic>>(
        '/v1/providers/sami-mansour-electricite',
      );
      expect(detail.statusCode, 200);
      expect(detail.data?['slug'], 'sami-mansour-electricite');

      final reviews = await dio.get<Map<String, dynamic>>(
        '/v1/providers/sami-mansour-electricite/reviews',
      );
      expect(reviews.statusCode, 200);
      expect(reviews.data?['items'], isA<List<dynamic>>());

      final postReview = await dio.post<Map<String, dynamic>>(
        '/v1/providers/sami-mansour-electricite/reviews',
        data: {'rating': 5, 'comment': 'Top !'},
      );
      expect(postReview.statusCode, 201);
    });

    test('intercepts /v1/auth/me for client, provider, and guest', () async {
      // Client
      final clientDio = Dio()
        ..interceptors.add(
          DemoMockInterceptor(
            isDemoMode: () => true,
            getDemoRole: () => DemoRole.client,
          ),
        );
      final clientRes =
          await clientDio.get<Map<String, dynamic>>('/v1/auth/me');
      expect(clientRes.statusCode, 200);
      expect(clientRes.data?['role'], 'CLIENT');

      // Provider
      final proDio = Dio()
        ..interceptors.add(
          DemoMockInterceptor(
            isDemoMode: () => true,
            getDemoRole: () => DemoRole.provider,
          ),
        );
      final proRes = await proDio.get<Map<String, dynamic>>('/v1/auth/me');
      expect(proRes.statusCode, 200);
      expect(proRes.data?['role'], 'PROVIDER');

      // Guest -> 401
      final guestDio = Dio()
        ..interceptors.add(
          DemoMockInterceptor(
            isDemoMode: () => true,
            getDemoRole: () => DemoRole.guest,
          ),
        );
      expect(
        () => guestDio.get<Map<String, dynamic>>('/v1/auth/me'),
        throwsA(
          isA<DioException>().having(
            (e) => e.response?.statusCode,
            'statusCode',
            401,
          ),
        ),
      );
    });

    test('intercepts favorites and contact-events', () async {
      final dio = Dio()
        ..interceptors.add(
          DemoMockInterceptor(
            isDemoMode: () => true,
            getDemoRole: () => DemoRole.client,
          ),
        );

      final favs = await dio.get<Map<String, dynamic>>('/v1/favorites');
      expect(favs.statusCode, 200);
      expect(favs.data?['items'], isA<List<dynamic>>());

      final addFav = await dio.post<Map<String, dynamic>>(
        '/v1/favorites',
        data: {'providerId': 'prov-1'},
      );
      expect(addFav.statusCode, 201);

      final delFav = await dio.delete<Map<String, dynamic>>(
        '/v1/favorites/prov-1',
      );
      expect(delFav.statusCode, 200);

      final contact = await dio.post<Map<String, dynamic>>(
        '/v1/providers/sami-mansour-electricite/contact-events',
        data: {'channel': 'PHONE'},
      );
      expect(contact.statusCode, 201);
    });

    test('intercepts /v1/providers/me/stats', () async {
      final dio = Dio()
        ..interceptors.add(
          DemoMockInterceptor(
            isDemoMode: () => true,
            getDemoRole: () => DemoRole.provider,
          ),
        );

      final stats =
          await dio.get<Map<String, dynamic>>('/v1/providers/me/stats');
      expect(stats.statusCode, 200);
      expect(stats.data?['totals'], isNotNull);
      expect(stats.data?['series'], isA<List<dynamic>>());
    });
  });
}
