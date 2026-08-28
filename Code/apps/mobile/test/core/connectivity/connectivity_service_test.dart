import 'dart:async';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import 'package:sanaya/core/connectivity/connectivity_service.dart';

class _MockConnectivity extends Mock implements Connectivity {}

Future<void> _flush() => Future<void>.delayed(Duration.zero);

void main() {
  group('FM-02f — isOnlineFromResults', () {
    test('true si au moins un résultat autre que none', () {
      expect(isOnlineFromResults([ConnectivityResult.wifi]), isTrue);
      expect(isOnlineFromResults([ConnectivityResult.mobile]), isTrue);
      expect(
        isOnlineFromResults([ConnectivityResult.none, ConnectivityResult.wifi]),
        isTrue,
      );
    });

    test('false si liste vide ou uniquement none', () {
      expect(isOnlineFromResults([]), isFalse);
      expect(isOnlineFromResults([ConnectivityResult.none]), isFalse);
    });
  });

  group('FM-02f — ConnectivityService', () {
    late _MockConnectivity connectivity;
    late StreamController<List<ConnectivityResult>> controller;

    setUp(() {
      connectivity = _MockConnectivity();
      controller = StreamController<List<ConnectivityResult>>.broadcast();
      when(
        () => connectivity.onConnectivityChanged,
      ).thenAnswer((_) => controller.stream);
    });

    tearDown(() async {
      await controller.close();
    });

    test(
      'isOnline reflète le résultat de checkConnectivity() dès start()',
      () async {
        when(
          () => connectivity.checkConnectivity(),
        ).thenAnswer((_) async => [ConnectivityResult.wifi]);
        final service = ConnectivityService(connectivity: connectivity);

        await service.start();

        expect(service.isOnline.value, isTrue);
        service.dispose();
      },
    );

    test('isOnline part à false si checkConnectivity() renvoie none', () async {
      when(
        () => connectivity.checkConnectivity(),
      ).thenAnswer((_) async => [ConnectivityResult.none]);
      final service = ConnectivityService(connectivity: connectivity);

      await service.start();

      expect(service.isOnline.value, isFalse);
      service.dispose();
    });

    test('isOnline passe à false quand le flux signale none', () async {
      when(
        () => connectivity.checkConnectivity(),
      ).thenAnswer((_) async => [ConnectivityResult.wifi]);
      final service = ConnectivityService(connectivity: connectivity);
      await service.start();

      controller.add([ConnectivityResult.none]);
      await _flush();

      expect(service.isOnline.value, isFalse);
      service.dispose();
    });

    test(
      'isOnline repasse à true quand le flux retrouve une connexion',
      () async {
        when(
          () => connectivity.checkConnectivity(),
        ).thenAnswer((_) async => [ConnectivityResult.none]);
        final service = ConnectivityService(connectivity: connectivity);
        await service.start();
        expect(service.isOnline.value, isFalse);

        controller.add([ConnectivityResult.wifi]);
        await _flush();

        expect(service.isOnline.value, isTrue);
        service.dispose();
      },
    );

    test('dispose() coupe l’abonnement au flux', () async {
      when(
        () => connectivity.checkConnectivity(),
      ).thenAnswer((_) async => [ConnectivityResult.wifi]);
      final service = ConnectivityService(connectivity: connectivity);
      await service.start();

      service.dispose();
      expect(controller.hasListener, isFalse);
    });
  });
}
