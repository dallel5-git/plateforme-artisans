import 'package:flutter_test/flutter_test.dart';
import 'package:sanaya/features/onboarding/domain/portfolio_upload_task.dart';

void main() {
  group('PortfolioUploadTask', () {
    test('isInProgress est vrai tant que ni done ni error', () {
      const task = PortfolioUploadTask(
        localId: 'local-1',
        phase: PortfolioUploadPhase.uploading,
      );

      expect(task.isInProgress, isTrue);
      expect(task.isDone, isFalse);
      expect(task.isError, isFalse);
    });

    test('isDone/isError reflètent la phase terminale', () {
      const done = PortfolioUploadTask(
        localId: 'local-1',
        phase: PortfolioUploadPhase.done,
      );
      const error = PortfolioUploadTask(
        localId: 'local-1',
        phase: PortfolioUploadPhase.error,
        errorCode: 'VALIDATION_ERROR',
      );

      expect(done.isDone, isTrue);
      expect(done.isInProgress, isFalse);
      expect(error.isError, isTrue);
      expect(error.isInProgress, isFalse);
    });

    test('copyWith met à jour uniquement les champs fournis', () {
      const initial = PortfolioUploadTask(
        localId: 'local-1',
        phase: PortfolioUploadPhase.compressing,
      );

      final uploading = initial.copyWith(
        phase: PortfolioUploadPhase.uploading,
        uploadProgress: 0.5,
      );

      expect(uploading.localId, 'local-1');
      expect(uploading.phase, PortfolioUploadPhase.uploading);
      expect(uploading.uploadProgress, 0.5);
    });

    test('copyWith(clearError: true) efface errorCode', () {
      const errored = PortfolioUploadTask(
        localId: 'local-1',
        phase: PortfolioUploadPhase.error,
        errorCode: 'NETWORK_ERROR',
      );

      final retried = errored.copyWith(
        phase: PortfolioUploadPhase.uploading,
        clearError: true,
      );

      expect(retried.errorCode, isNull);
      expect(retried.phase, PortfolioUploadPhase.uploading);
    });
  });
}
