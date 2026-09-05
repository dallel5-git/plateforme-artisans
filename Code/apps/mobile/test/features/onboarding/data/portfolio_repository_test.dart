import 'dart:typed_data';

import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:sanaya/core/api/generated/api.dart';
import 'package:sanaya/features/onboarding/data/portfolio_repository.dart';

// ---------------------------------------------------------------------------
// Mocks et Fakes
// ---------------------------------------------------------------------------

class MockDefaultApi extends Mock implements DefaultApi {}

class MockUploadDio extends Mock implements Dio {}

class _FakePresignRequest extends Fake implements V1MediaPresignPostRequest {}

class _FakePortfolioPostRequest extends Fake
    implements V1ProvidersMePortfolioPostRequest {}

class _FakeOptions extends Fake implements Options {}

RequestOptions _opts([String path = '/']) => RequestOptions(path: path);

void main() {
  setUpAll(() {
    registerFallbackValue(_FakePresignRequest());
    registerFallbackValue(_FakePortfolioPostRequest());
    registerFallbackValue(_FakeOptions());
  });

  late MockDefaultApi mockApi;
  late MockUploadDio mockUploadDio;
  late PortfolioRepository repository;

  setUp(() {
    mockApi = MockDefaultApi();
    mockUploadDio = MockUploadDio();
    repository = PortfolioRepository(mockApi, uploadClient: mockUploadDio);
  });

  // ---------------------------------------------------------------------------
  // presignUpload
  // ---------------------------------------------------------------------------

  group('presignUpload', () {
    test(
      'appelle v1MediaPresignPost avec filename/mimeType/sizeBytes',
      () async {
        final response = V1MediaPresignPost200Response(
          (b) => b
            ..mediaId = 'media-1'
            ..uploadUrl = 'https://r2.example/media-1/original.jpg'
            ..expiresAt = DateTime.utc(2026, 9, 5, 10),
        );

        when(
          () => mockApi.v1MediaPresignPost(
            v1MediaPresignPostRequest: any(named: 'v1MediaPresignPostRequest'),
          ),
        ).thenAnswer(
          (_) async => Response(
            requestOptions: _opts('/v1/media/presign'),
            statusCode: 200,
            data: response,
          ),
        );

        final result = await repository.presignUpload(
          filename: 'photo.jpg',
          mimeType: 'image/jpeg',
          sizeBytes: 1024,
        );

        expect(result.mediaId, 'media-1');
        expect(result.uploadUrl, 'https://r2.example/media-1/original.jpg');

        final captured = verify(
          () => mockApi.v1MediaPresignPost(
            v1MediaPresignPostRequest: captureAny(
              named: 'v1MediaPresignPostRequest',
            ),
          ),
        ).captured;
        final sentRequest = captured.single as V1MediaPresignPostRequest;
        expect(sentRequest.filename, 'photo.jpg');
        expect(sentRequest.mimeType, 'image/jpeg');
        expect(sentRequest.sizeBytes, 1024);
      },
    );

    test(
      'relance le SanayaApiException typé attaché au DioException '
      '(ex. VALIDATION_ERROR taille/type refusés)',
      () async {
        final apiException = ValidationException(
          message: 'Fichier trop volumineux',
          details: const {'maxSizeBytes': 8000000},
        );
        when(
          () => mockApi.v1MediaPresignPost(
            v1MediaPresignPostRequest: any(
              named: 'v1MediaPresignPostRequest',
            ),
          ),
        ).thenThrow(
          DioException(
            requestOptions: _opts('/v1/media/presign'),
            error: apiException,
          ),
        );

        await expectLater(
          repository.presignUpload(
            filename: 'photo.jpg',
            mimeType: 'image/jpeg',
            sizeBytes: 50000000,
          ),
          throwsA(same(apiException)),
        );
      },
    );
  });

  // ---------------------------------------------------------------------------
  // uploadToPresignedUrl
  // ---------------------------------------------------------------------------

  group('uploadToPresignedUrl', () {
    test('PUT les octets vers uploadUrl avec le bon Content-Type', () async {
      final bytes = Uint8List.fromList([1, 2, 3, 4]);

      when(
        () => mockUploadDio.put<void>(
          any(),
          data: any(named: 'data'),
          options: any(named: 'options'),
          onSendProgress: any(named: 'onSendProgress'),
        ),
      ).thenAnswer(
        (_) async => Response<void>(
          requestOptions: _opts('https://r2.example/media-1/original.jpg'),
          statusCode: 200,
        ),
      );

      await repository.uploadToPresignedUrl(
        uploadUrl: 'https://r2.example/media-1/original.jpg',
        bytes: bytes,
        mimeType: 'image/jpeg',
      );

      final captured = verify(
        () => mockUploadDio.put<void>(
          captureAny(),
          data: any(named: 'data'),
          options: captureAny(named: 'options'),
          onSendProgress: any(named: 'onSendProgress'),
        ),
      ).captured;
      expect(captured[0], 'https://r2.example/media-1/original.jpg');
      final options = captured[1] as Options;
      expect(options.contentType, 'image/jpeg');
      expect(options.headers?[Headers.contentLengthHeader], bytes.length);
    });

    test(
      "propage le DioException brut (hôte tiers, pas d'enveloppe Sanaya)",
      () async {
        when(
          () => mockUploadDio.put<void>(
            any(),
            data: any(named: 'data'),
            options: any(named: 'options'),
            onSendProgress: any(named: 'onSendProgress'),
          ),
        ).thenThrow(
          DioException(
            requestOptions: _opts('https://r2.example/media-1/original.jpg'),
            type: DioExceptionType.connectionTimeout,
          ),
        );

        await expectLater(
          repository.uploadToPresignedUrl(
            uploadUrl: 'https://r2.example/media-1/original.jpg',
            bytes: Uint8List.fromList([1]),
            mimeType: 'image/jpeg',
          ),
          throwsA(isA<DioException>()),
        );
      },
    );
  });

  // ---------------------------------------------------------------------------
  // processMedia
  // ---------------------------------------------------------------------------

  group('processMedia', () {
    test("appelle v1MediaIdProcessPost avec l'id fourni", () async {
      final response = V1MediaIdProcessPost200Response(
        (b) => b
          ..id = 'media-1'
          ..publicUrl = 'https://cdn.example/media-1/full.webp'
          ..thumbUrl = 'https://cdn.example/media-1/thumb.webp'
          ..cardUrl = 'https://cdn.example/media-1/card.webp'
          ..fullUrl = 'https://cdn.example/media-1/full.webp'
          ..width = 1600
          ..height = 1200,
      );

      when(
        () => mockApi.v1MediaIdProcessPost(id: 'media-1'),
      ).thenAnswer(
        (_) async => Response(
          requestOptions: _opts('/v1/media/media-1/process'),
          statusCode: 200,
          data: response,
        ),
      );

      final result = await repository.processMedia('media-1');

      expect(result.thumbUrl, 'https://cdn.example/media-1/thumb.webp');
      verify(() => mockApi.v1MediaIdProcessPost(id: 'media-1')).called(1);
    });

    test('relance le SanayaApiException typé (ex. FORBIDDEN)', () async {
      final apiException = ForbiddenException(
        message: "Ce média n'appartient pas à l'utilisateur authentifié",
      );
      when(
        () => mockApi.v1MediaIdProcessPost(id: 'media-1'),
      ).thenThrow(
        DioException(
          requestOptions: _opts('/v1/media/media-1/process'),
          error: apiException,
        ),
      );

      await expectLater(
        repository.processMedia('media-1'),
        throwsA(same(apiException)),
      );
    });
  });

  // ---------------------------------------------------------------------------
  // attachToPortfolio
  // ---------------------------------------------------------------------------

  group('attachToPortfolio', () {
    test('appelle v1ProvidersMePortfolioPost avec le mediaId fourni', () async {
      final response = V1ProvidersMePortfolioPost200Response(
        (b) => b
          ..id = 'item-1'
          ..mediaId = 'media-1'
          ..categoryId = 'cat-1'
          ..caption = 'Salle de bain rénovée'
          ..sortOrder = 0,
      );

      when(
        () => mockApi.v1ProvidersMePortfolioPost(
          v1ProvidersMePortfolioPostRequest: any(
            named: 'v1ProvidersMePortfolioPostRequest',
          ),
        ),
      ).thenAnswer(
        (_) async => Response(
          requestOptions: _opts('/v1/providers/me/portfolio'),
          statusCode: 200,
          data: response,
        ),
      );

      final result = await repository.attachToPortfolio(mediaId: 'media-1');

      expect(result.id, 'item-1');
      final captured = verify(
        () => mockApi.v1ProvidersMePortfolioPost(
          v1ProvidersMePortfolioPostRequest: captureAny(
            named: 'v1ProvidersMePortfolioPostRequest',
          ),
        ),
      ).captured;
      final sentRequest = captured.single as V1ProvidersMePortfolioPostRequest;
      expect(sentRequest.mediaId, 'media-1');
    });

    test(
      'relance le SanayaApiException typé (ex. VALIDATION_ERROR plafond '
      'FREE, details.limit)',
      () async {
        final apiException = ValidationException(
          message: 'Maximum 5 photos en offre gratuite',
          details: const {'limit': 5},
        );
        when(
          () => mockApi.v1ProvidersMePortfolioPost(
            v1ProvidersMePortfolioPostRequest: any(
              named: 'v1ProvidersMePortfolioPostRequest',
            ),
          ),
        ).thenThrow(
          DioException(
            requestOptions: _opts('/v1/providers/me/portfolio'),
            error: apiException,
          ),
        );

        await expectLater(
          repository.attachToPortfolio(mediaId: 'media-1'),
          throwsA(same(apiException)),
        );
      },
    );
  });

  // ---------------------------------------------------------------------------
  // deletePortfolioItem
  // ---------------------------------------------------------------------------

  group('deletePortfolioItem', () {
    test("appelle v1ProvidersMePortfolioIdDelete avec l'id fourni", () async {
      when(
        () => mockApi.v1ProvidersMePortfolioIdDelete(id: 'item-1'),
      ).thenAnswer(
        (_) async => Response<void>(
          requestOptions: _opts('/v1/providers/me/portfolio/item-1'),
          statusCode: 204,
        ),
      );

      await repository.deletePortfolioItem('item-1');

      verify(
        () => mockApi.v1ProvidersMePortfolioIdDelete(id: 'item-1'),
      ).called(1);
    });

    test('relance le SanayaApiException typé (ex. NOT_FOUND)', () async {
      final apiException = NotFoundException(
        message: 'Élément de portfolio introuvable',
      );
      when(
        () => mockApi.v1ProvidersMePortfolioIdDelete(id: 'item-1'),
      ).thenThrow(
        DioException(
          requestOptions: _opts('/v1/providers/me/portfolio/item-1'),
          error: apiException,
        ),
      );

      await expectLater(
        repository.deletePortfolioItem('item-1'),
        throwsA(same(apiException)),
      );
    });
  });
}
