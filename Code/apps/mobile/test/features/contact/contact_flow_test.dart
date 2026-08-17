/// FM-09 / FM-02 — Contact et file hors ligne
///
/// À placer dans : Code/apps/mobile/test/features/contact/contact_flow_test.dart
///
/// ⚠️ Ces tests ÉCHOUENT tant que la feature n'existe pas. C'est voulu.
///
/// FM-09 est LA FONCTIONNALITÉ LA PLUS CRITIQUE DE L'APP :
///   1. l'événement part AVANT l'ouverture du lien natif (P9)
///   2. si l'API échoue, le composeur s'ouvre QUAND MÊME — on ne bloque
///      jamais l'utilisateur pour une raison de traçabilité
///   3. l'événement est mis en file locale et renvoyé au retour du réseau
///
/// Ces trois règles se contredisent en apparence. C'est exactement pour ça
/// qu'elles doivent être testées : sous pression, on en sacrifie une.

import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import 'package:sanaya/features/contact/domain/contact_service.dart';
import 'package:sanaya/features/contact/data/contact_queue.dart';
import 'package:sanaya/core/api/generated/api.dart';

class _ApiMock extends Mock implements ContactEventsApi {}

class _QueueMock extends Mock implements ContactQueue {}

class _LauncherMock extends Mock implements UrlLauncher {}

void main() {
  late _ApiMock api;
  late _QueueMock queue;
  late _LauncherMock launcher;
  late ContactService service;

  setUp(() {
    api = _ApiMock();
    queue = _QueueMock();
    launcher = _LauncherMock();
    service = ContactService(api: api, queue: queue, launcher: launcher);
  });

  group('FM-09 — ordre des opérations (P9)', () {
    test("🔒 l'événement est posté AVANT l'ouverture du lien", () async {
      // 🔒 NON-RÉGRESSION — P9 : ne jamais supprimer sans ADR.
      //
      // Si on ouvre le composeur d'abord, l'app passe en arrière-plan et
      // Android peut suspendre la requête. On perd le lead — donc la preuve
      // qu'on vend à l'artisan.
      final ordre = <String>[];

      when(() => api.create(any())).thenAnswer((_) async {
        ordre.add('api');
        return ContactEventResponse(revealedPhone: '+21622123456');
      });
      when(() => launcher.launch(any())).thenAnswer((_) async {
        ordre.add('launch');
        return true;
      });

      await service.contact(providerId: 'p1', channel: ContactChannel.phone);

      expect(ordre, ['api', 'launch']);
    });

    test('le numéro utilisé est celui révélé par l\'API, pas un cache local', () async {
      // La fiche publique ne contient PAS le numéro (P8). S'il apparaît
      // localement, c'est qu'il a fuité quelque part.
      when(() => api.create(any())).thenAnswer(
        (_) async => ContactEventResponse(revealedPhone: '+21698765432'),
      );
      when(() => launcher.launch(any())).thenAnswer((_) async => true);

      await service.contact(providerId: 'p1', channel: ContactChannel.phone);

      verify(() => launcher.launch('tel:+21698765432')).called(1);
    });
  });

  group('FM-09 — 🔒 réseau dégradé : on n\'empêche JAMAIS l\'appel', () {
    test('🔒 si l\'API échoue, le composeur s\'ouvre quand même', () async {
      // 🔒 NON-RÉGRESSION — P5 : ne jamais supprimer sans ADR.
      //
      // Un utilisateur qui ne peut pas appeler parce que NOTRE traçage a
      // échoué désinstalle l'app. La trace est notre problème, pas le sien.
      when(() => api.create(any())).thenThrow(NetworkException('hors ligne'));
      when(() => queue.enqueue(any())).thenAnswer((_) async {});
      when(() => launcher.launch(any())).thenAnswer((_) async => true);

      await service.contact(
        providerId: 'p1',
        channel: ContactChannel.phone,
        fallbackPhone: '+21622123456',
      );

      verify(() => launcher.launch('tel:+21622123456')).called(1);
    });

    test('🔒 l\'événement échoué part en file locale', () async {
      // 🔒 NON-RÉGRESSION — P9 : sans la file, on perd le lead pour de bon.
      when(() => api.create(any())).thenThrow(NetworkException('hors ligne'));
      when(() => queue.enqueue(any())).thenAnswer((_) async {});
      when(() => launcher.launch(any())).thenAnswer((_) async => true);

      await service.contact(
        providerId: 'p1',
        channel: ContactChannel.phone,
        fallbackPhone: '+21622123456',
      );

      verify(() => queue.enqueue(any())).called(1);
    });

    test('la file est vidée au retour du réseau', () async {
      when(() => queue.pending()).thenAnswer(
        (_) async => [
          PendingContact(providerId: 'p1', channel: ContactChannel.phone, at: DateTime(2026, 8, 20)),
          PendingContact(providerId: 'p2', channel: ContactChannel.whatsapp, at: DateTime(2026, 8, 20)),
        ],
      );
      when(() => api.create(any())).thenAnswer(
        (_) async => ContactEventResponse(revealedPhone: '+21622123456'),
      );
      when(() => queue.remove(any())).thenAnswer((_) async {});

      await service.flushQueue();

      verify(() => api.create(any())).called(2);
      verify(() => queue.remove(any())).called(2);
    });

    test('un événement en file qui échoue encore reste en file', () async {
      // Sinon on perd le lead au premier renvoi raté.
      when(() => queue.pending()).thenAnswer(
        (_) async => [PendingContact(providerId: 'p1', channel: ContactChannel.phone, at: DateTime(2026, 8, 20))],
      );
      when(() => api.create(any())).thenThrow(NetworkException('toujours hors ligne'));

      await service.flushQueue();

      verifyNever(() => queue.remove(any()));
    });
  });

  group('FM-09 — WhatsApp bilingue', () {
    test('le message est pré-rempli dans la langue active', () async {
      when(() => api.create(any())).thenAnswer(
        (_) async => ContactEventResponse(revealedPhone: '+21622123456'),
      );
      when(() => launcher.launch(any())).thenAnswer((_) async => true);

      await service.contact(
        providerId: 'p1',
        channel: ContactChannel.whatsapp,
        locale: 'ar',
      );

      final captured = verify(() => launcher.launch(captureAny())).captured.single as String;
      expect(captured, startsWith('https://wa.me/21622123456'));
      expect(captured, contains('text='));
    });
  });

  group('FM-02 — client réseau généré', () {
    test('le refresh token n\'est jamais lu depuis SharedPreferences', () async {
      // 🔒 NON-RÉGRESSION — sécurité : le refresh vit dans le Keystore Android
      // (flutter_secure_storage), jamais dans un stockage en clair.
      final source = await tokenStorageSourceForTest();
      expect(source, 'flutter_secure_storage');
    });

    test('un 401 déclenche UN SEUL refresh, pas une boucle', () async {
      // Un refresh en boucle sur un token définitivement invalide vide la
      // batterie et fait 300 requêtes en 10 secondes.
      when(() => api.create(any())).thenThrow(UnauthorizedException());

      var refreshCount = 0;
      service.onRefresh = () async {
        refreshCount++;
        throw UnauthorizedException();
      };

      await expectLater(
        service.contact(providerId: 'p1', channel: ContactChannel.phone),
        throwsA(isA<UnauthorizedException>()),
      );
      expect(refreshCount, 1);
    });

    test('le retry ne s\'applique qu\'aux GET idempotents', () async {
      // Rejouer un POST /contact-events créerait des faux leads facturables.
      expect(shouldRetryForTest(method: 'GET'), isTrue);
      expect(shouldRetryForTest(method: 'POST'), isFalse);
    });
  });
}
