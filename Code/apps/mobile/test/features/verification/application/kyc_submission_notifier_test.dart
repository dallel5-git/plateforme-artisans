import 'dart:io';
import 'dart:typed_data';

import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:sanaya/core/api/generated/api.dart';
import 'package:sanaya/features/verification/application/kyc_submission_notifier.dart';
import 'package:sanaya/features/verification/data/kyc_repository.dart';

class MockKycRepository extends Mock implements KycRepository {}

class _FakeDocumentType extends Fake
    implements V1ProvidersMeVerificationPresignPostRequestDocumentTypeEnum {}

class _FakeMimeType extends Fake
    implements V1ProvidersMeVerificationPresignPostRequestMimeTypeEnum {}

void main() {
  setUpAll(() {
    registerFallbackValue(_FakeDocumentType());
    registerFallbackValue(_FakeMimeType());
    registerFallbackValue(Uint8List(0));
  });

  late MockKycRepository mockRepository;
  late KycSubmissionNotifier notifier;

  setUp(() {
    mockRepository = MockKycRepository();
    notifier = KycSubmissionNotifier(
      mockRepository,
      compressImage: (file) async => Uint8List.fromList([1, 2, 3, 4]),
    );
  });

  group('KycSubmissionNotifier — Champs et validation de surface', () {
    test('setFullName met à jour le nom et évalue isValidFullName', () {
      expect(notifier.state.isValidFullName, isFalse);

      notifier.setFullName('Ab');
      expect(notifier.state.fullNameOnId, 'Ab');
      expect(notifier.state.isValidFullName, isFalse);

      notifier.setFullName('Ahmed Ben Salah');
      expect(notifier.state.fullNameOnId, 'Ahmed Ben Salah');
      expect(notifier.state.isValidFullName, isTrue);
    });

    test('setCinNumber valide strictement 8 chiffres numériques', () {
      expect(notifier.state.isValidCin, isFalse);

      notifier.setCinNumber('1234567'); // 7 chiffres
      expect(notifier.state.isValidCin, isFalse);

      notifier.setCinNumber('123456789'); // 9 chiffres
      expect(notifier.state.isValidCin, isFalse);

      notifier.setCinNumber('1234567a'); // caractères alphabétiques
      expect(notifier.state.isValidCin, isFalse);

      notifier.setCinNumber('08123456'); // 8 chiffres
      expect(notifier.state.isValidCin, isTrue);
    });

    test('setConsent met à jour le consentement légal', () {
      expect(notifier.state.consentGiven, isFalse);
      notifier.setConsent(consent: true);
      expect(notifier.state.consentGiven, isTrue);
      notifier.setConsent(consent: false);
      expect(notifier.state.consentGiven, isFalse);
    });

    test('canSubmit vérifie la conjonction des 5 conditions', () {
      expect(notifier.state.canSubmit, isFalse);

      notifier
        ..setFullName('Sami Mansour')
        ..setCinNumber('12345678')
        ..setConsent(consent: true);
      // Toujours faux car les pièces jointes ne sont pas encore téléversées
      expect(notifier.state.canSubmit, isFalse);
    });
  });

  group('KycSubmissionNotifier — Upload et suppression de documents', () {
    test(
      'processAndUploadFile compresse, pré-signe et téléverse vers R2',
      () async {
        final fakePresign = V1ProvidersMeVerificationPresignPost200Response(
          (b) => b
            ..uploadUrl = 'https://r2.example/private-kyc/cin-front.jpg'
            ..mediaId = 'media-front-123'
            ..expiresAt = DateTime.utc(2026, 9, 7),
        );

        when(
          () => mockRepository.presignUpload(
            documentType: any(named: 'documentType'),
            mimeType: any(named: 'mimeType'),
            sizeBytes: any(named: 'sizeBytes'),
          ),
        ).thenAnswer((_) async => fakePresign);

        when(
          () => mockRepository.uploadToPresignedUrl(
            uploadUrl: any(named: 'uploadUrl'),
            bytes: any(named: 'bytes'),
            mimeType: any(named: 'mimeType'),
            onSendProgress: any(named: 'onSendProgress'),
          ),
        ).thenAnswer((_) async {});

        final fakeFile = File('/tmp/fake_front.jpg');
        await notifier.processAndUploadFile(isFront: true, file: fakeFile);

        expect(notifier.state.front.isUploaded, isTrue);
        expect(notifier.state.front.mediaId, 'media-front-123');
        expect(notifier.state.front.file, fakeFile);
        expect(notifier.state.front.isUploading, isFalse);
      },
    );

    test(
      "removeDocument réinitialise l'état de la face sélectionnée",
      () async {
        final fakePresign = V1ProvidersMeVerificationPresignPost200Response(
          (b) => b
            ..uploadUrl = 'https://r2.example/private-kyc/cin-front.jpg'
            ..mediaId = 'media-front-123'
            ..expiresAt = DateTime.utc(2026, 9, 7),
        );

        when(
          () => mockRepository.presignUpload(
            documentType: any(named: 'documentType'),
            mimeType: any(named: 'mimeType'),
            sizeBytes: any(named: 'sizeBytes'),
          ),
        ).thenAnswer((_) async => fakePresign);

        when(
          () => mockRepository.uploadToPresignedUrl(
            uploadUrl: any(named: 'uploadUrl'),
            bytes: any(named: 'bytes'),
            mimeType: any(named: 'mimeType'),
            onSendProgress: any(named: 'onSendProgress'),
          ),
        ).thenAnswer((_) async {});

        await notifier.processAndUploadFile(
          isFront: true,
          file: File('/tmp/fake_front.jpg'),
        );
        expect(notifier.state.front.isUploaded, isTrue);

        notifier.removeDocument(isFront: true);
        expect(notifier.state.front.isUploaded, isFalse);
        expect(notifier.state.front.file, isNull);
        expect(notifier.state.front.mediaId, isNull);
      },
    );
  });

  group('KycSubmissionNotifier — Soumission finale', () {
    test('submit soumet les pièces et passe à isSuccess: true', () async {
      final fakePresignFront = V1ProvidersMeVerificationPresignPost200Response(
        (b) => b
          ..uploadUrl = 'https://r2.example/private-kyc/cin-front.jpg'
          ..mediaId = 'media-front-123'
          ..expiresAt = DateTime.utc(2026, 9, 7),
      );
      final fakePresignBack = V1ProvidersMeVerificationPresignPost200Response(
        (b) => b
          ..uploadUrl = 'https://r2.example/private-kyc/cin-back.jpg'
          ..mediaId = 'media-back-456'
          ..expiresAt = DateTime.utc(2026, 9, 7),
      );

      when(
        () => mockRepository.presignUpload(
          documentType:
              V1ProvidersMeVerificationPresignPostRequestDocumentTypeEnum
                  .CIN_FRONT,
          mimeType: any(named: 'mimeType'),
          sizeBytes: any(named: 'sizeBytes'),
        ),
      ).thenAnswer((_) async => fakePresignFront);

      when(
        () => mockRepository.presignUpload(
          documentType:
              V1ProvidersMeVerificationPresignPostRequestDocumentTypeEnum
                  .CIN_BACK,
          mimeType: any(named: 'mimeType'),
          sizeBytes: any(named: 'sizeBytes'),
        ),
      ).thenAnswer((_) async => fakePresignBack);

      when(
        () => mockRepository.uploadToPresignedUrl(
          uploadUrl: any(named: 'uploadUrl'),
          bytes: any(named: 'bytes'),
          mimeType: any(named: 'mimeType'),
          onSendProgress: any(named: 'onSendProgress'),
        ),
      ).thenAnswer((_) async {});

      final fakeSubmitResponse = V1ProvidersMeVerificationSubmitPost200Response(
        (b) => b
          ..requestId = 'req-1'
          ..status =
              V1ProvidersMeVerificationSubmitPost200ResponseStatusEnum.PENDING
          ..submittedAt = DateTime.utc(2026, 9, 7),
      );

      when(
        () => mockRepository.submitVerification(
          cinNumber: any(named: 'cinNumber'),
          fullNameOnId: any(named: 'fullNameOnId'),
          cinFrontMediaId: any(named: 'cinFrontMediaId'),
          cinBackMediaId: any(named: 'cinBackMediaId'),
        ),
      ).thenAnswer((_) async => fakeSubmitResponse);

      notifier
        ..setFullName('Ahmed Mansour')
        ..setCinNumber('12345678')
        ..setConsent(consent: true);

      await notifier.processAndUploadFile(
        isFront: true,
        file: File('/tmp/fake_front.jpg'),
      );
      await notifier.processAndUploadFile(
        isFront: false,
        file: File('/tmp/fake_back.jpg'),
      );

      expect(notifier.state.canSubmit, isTrue);

      final success = await notifier.submit();
      expect(success, isTrue);
      expect(notifier.state.isSuccess, isTrue);
      expect(notifier.state.isSubmitting, isFalse);

      verify(
        () => mockRepository.submitVerification(
          cinNumber: '12345678',
          fullNameOnId: 'Ahmed Mansour',
          cinFrontMediaId: 'media-front-123',
          cinBackMediaId: 'media-back-456',
        ),
      ).called(1);
    });
  });
}
