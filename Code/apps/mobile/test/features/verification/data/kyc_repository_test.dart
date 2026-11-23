import 'dart:typed_data';

import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:sanaya/core/api/generated/api.dart';
import 'package:sanaya/features/verification/data/kyc_repository.dart';

class MockDefaultApi extends Mock implements DefaultApi {}

class MockUploadDio extends Mock implements Dio {}

class _FakePresignRequest extends Fake
    implements V1ProvidersMeVerificationPresignPostRequest {}

class _FakeSubmitRequest extends Fake
    implements V1ProvidersMeVerificationSubmitPostRequest {}

class _FakeOptions extends Fake implements Options {}

RequestOptions _opts([String path = '/']) => RequestOptions(path: path);

void main() {
  setUpAll(() {
    registerFallbackValue(_FakePresignRequest());
    registerFallbackValue(_FakeSubmitRequest());
    registerFallbackValue(_FakeOptions());
  });

  late MockDefaultApi mockApi;
  late MockUploadDio mockUploadDio;
  late KycRepository repository;

  setUp(() {
    mockApi = MockDefaultApi();
    mockUploadDio = MockUploadDio();
    repository = KycRepository(mockApi, uploadClient: mockUploadDio);
  });

  group('KycRepository — presignUpload', () {
    test(
      'appelle v1ProvidersMeVerificationPresignPost avec documentType et mimeType',
      () async {
        final responseData = V1ProvidersMeVerificationPresignPost200Response(
          (b) => b
            ..uploadUrl = 'https://r2.example/private-kyc/doc-1.jpg'
            ..mediaId = '11111111-1111-4111-8111-111111111111'
            ..expiresAt = DateTime.utc(2026, 9, 7, 12),
        );

        when(
          () => mockApi.v1ProvidersMeVerificationPresignPost(
            v1ProvidersMeVerificationPresignPostRequest: any(
              named: 'v1ProvidersMeVerificationPresignPostRequest',
            ),
          ),
        ).thenAnswer(
          (_) async => Response(
            requestOptions: _opts(),
            data: responseData,
            statusCode: 200,
          ),
        );

        final result = await repository.presignUpload(
          documentType:
              V1ProvidersMeVerificationPresignPostRequestDocumentTypeEnum
                  .CIN_FRONT,
          mimeType: V1ProvidersMeVerificationPresignPostRequestMimeTypeEnum
              .imageSlashJpeg,
          sizeBytes: 1024,
        );

        expect(result.uploadUrl, 'https://r2.example/private-kyc/doc-1.jpg');
        expect(result.mediaId, '11111111-1111-4111-8111-111111111111');

        verify(
          () => mockApi.v1ProvidersMeVerificationPresignPost(
            v1ProvidersMeVerificationPresignPostRequest: any(
              named: 'v1ProvidersMeVerificationPresignPostRequest',
              that: isA<V1ProvidersMeVerificationPresignPostRequest>().having(
                (r) => r.documentType,
                'documentType',
                V1ProvidersMeVerificationPresignPostRequestDocumentTypeEnum
                    .CIN_FRONT,
              ),
            ),
          ),
        ).called(1);
      },
    );
  });

  group('KycRepository — uploadToPresignedUrl', () {
    test(
      'PUT les octets directement vers uploadUrl avec contentType et contentLength',
      () async {
        when(
          () => mockUploadDio.put<void>(
            any(),
            data: any(named: 'data'),
            options: any(named: 'options'),
            onSendProgress: any(named: 'onSendProgress'),
          ),
        ).thenAnswer(
          (_) async => Response(requestOptions: _opts(), statusCode: 200),
        );

        final bytes = Uint8List.fromList([1, 2, 3, 4, 5]);
        await repository.uploadToPresignedUrl(
          uploadUrl: 'https://r2.example/private-kyc/doc-1.jpg',
          bytes: bytes,
          mimeType: 'image/jpeg',
        );

        verify(
          () => mockUploadDio.put<void>(
            'https://r2.example/private-kyc/doc-1.jpg',
            data: any(named: 'data'),
            options: any(
              named: 'options',
              that: isA<Options>()
                  .having((o) => o.contentType, 'contentType', 'image/jpeg')
                  .having(
                    (o) => o.headers?[Headers.contentLengthHeader],
                    'contentLength',
                    5,
                  ),
            ),
            onSendProgress: any(named: 'onSendProgress'),
          ),
        ).called(1);
      },
    );
  });

  group('KycRepository — submitVerification', () {
    test(
      'appelle v1ProvidersMeVerificationSubmitPost avec les paramètres requis',
      () async {
        final submittedAt = DateTime.utc(2026, 9, 7, 12);
        final responseData = V1ProvidersMeVerificationSubmitPost200Response(
          (b) => b
            ..requestId = '33333333-3333-4333-8333-333333333333'
            ..status =
                V1ProvidersMeVerificationSubmitPost200ResponseStatusEnum.PENDING
            ..submittedAt = submittedAt,
        );

        when(
          () => mockApi.v1ProvidersMeVerificationSubmitPost(
            v1ProvidersMeVerificationSubmitPostRequest: any(
              named: 'v1ProvidersMeVerificationSubmitPostRequest',
            ),
          ),
        ).thenAnswer(
          (_) async => Response(
            requestOptions: _opts(),
            data: responseData,
            statusCode: 200,
          ),
        );

        final result = await repository.submitVerification(
          cinNumber: '12345678',
          fullNameOnId: 'Sami Mansour',
          cinFrontMediaId: 'media-front',
          cinBackMediaId: 'media-back',
        );

        expect(result.requestId, '33333333-3333-4333-8333-333333333333');
        expect(
          result.status,
          V1ProvidersMeVerificationSubmitPost200ResponseStatusEnum.PENDING,
        );

        verify(
          () => mockApi.v1ProvidersMeVerificationSubmitPost(
            v1ProvidersMeVerificationSubmitPostRequest: any(
              named: 'v1ProvidersMeVerificationSubmitPostRequest',
              that: isA<V1ProvidersMeVerificationSubmitPostRequest>()
                  .having((r) => r.cinNumber, 'cinNumber', '12345678')
                  .having((r) => r.fullNameOnId, 'fullNameOnId', 'Sami Mansour')
                  .having(
                    (r) => r.cinFrontMediaId,
                    'cinFrontMediaId',
                    'media-front',
                  )
                  .having(
                    (r) => r.cinBackMediaId,
                    'cinBackMediaId',
                    'media-back',
                  ),
            ),
          ),
        ).called(1);
      },
    );
  });

  group('KycRepository — getVerificationStatus', () {
    test('appelle v1ProvidersMeVerificationGet et renvoie le statut', () async {
      final responseData = V1ProvidersMeVerificationGet200Response(
        (b) => b
          ..verificationStatus =
              V1ProvidersMeVerificationGet200ResponseVerificationStatusEnum
                  .NOT_SUBMITTED
          ..isVerified = false
          ..currentRequest.id = 'req-1'
          ..currentRequest.status =
              V1ProvidersMeVerificationGet200ResponseCurrentRequestStatusEnum
                  .NOT_SUBMITTED
          ..currentRequest.submittedAt = DateTime.utc(2026, 9, 7)
          ..currentRequest.reviewedAt = DateTime.utc(2026, 9, 7)
          ..currentRequest.rejectionReason = ''
          ..currentRequest.fullNameOnId = 'Sami Mansour'
          ..currentRequest.documents.replace([]),
      );

      when(
        () => mockApi.v1ProvidersMeVerificationGet(),
      ).thenAnswer(
        (_) async => Response(
          requestOptions: _opts(),
          data: responseData,
          statusCode: 200,
        ),
      );

      final result = await repository.getVerificationStatus();
      expect(
        result.verificationStatus,
        V1ProvidersMeVerificationGet200ResponseVerificationStatusEnum
            .NOT_SUBMITTED,
      );
      expect(result.isVerified, isFalse);

      verify(() => mockApi.v1ProvidersMeVerificationGet()).called(1);
    });
  });
}
