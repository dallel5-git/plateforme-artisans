/// FM-09b — Contact et file hors ligne
///
/// FM-09 est LA FONCTIONNALITÉ LA PLUS CRITIQUE DE L'APP :
///   1. l'événement part AVANT l'ouverture du lien natif (P9)
///   2. si l'API échoue, le composeur s'ouvre QUAND MÊME avec un numéro
///      déjà révélé plus tôt dans la session — on ne bloque jamais
///      l'utilisateur pour une raison de traçabilité (P5)
///   3. l'événement est mis en file locale et renvoyé au retour du réseau,
///      sans jamais rouvrir le composeur une deuxième fois
///
/// Ces règles se contredisent en apparence. C'est exactement pour ça
/// qu'elles doivent être testées : sous pression, on en sacrifie une.
library;

import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import 'package:sanaya/core/api/generated/api.dart';
import 'package:sanaya/features/contact/data/contact_queue.dart';
import 'package:sanaya/features/contact/data/url_launcher.dart';
import 'package:sanaya/features/contact/domain/contact_channel.dart';
import 'package:sanaya/features/contact/domain/contact_service.dart';
import 'package:sanaya/features/contact/domain/pending_contact.dart';

class _ApiMock extends Mock implements ContactEventsApi {}

class _QueueMock extends Mock implements ContactQueue {}

class _LauncherMock extends Mock implements UrlLauncher {}

Response<ContactEventResponse> _okResponse(ContactEventResponse body) {
  return Response(
    requestOptions: RequestOptions(path: '/v1/contact-events'),
    data: body,
  );
}

void main() {
  late _ApiMock api;
  late _QueueMock queue;
  late _LauncherMock launcher;
  late ContactService service;

  setUpAll(() {
    registerFallbackValue(
      V1ContactEventsPostRequest(
        (b) => b
          ..providerId = 'fallback'
          ..channel = V1ContactEventsPostRequestChannelEnum.PHONE,
      ),
    );
    registerFallbackValue(
      PendingContact(
        providerId: 'fallback',
        channel: ContactChannel.phone,
        at: DateTime(2026),
      ),
    );
  });

  setUp(() {
    api = _ApiMock();
    queue = _QueueMock();
    launcher = _LauncherMock();
    service = ContactService(api: api, queue: queue, launcher: launcher);
  });

  group('FM-09b — ordre des opérations (P9)', () {
    test("🔒 l'événement est posté AVANT l'ouverture du lien", () async {
      // 🔒 NON-RÉGRESSION — P9 : ne jamais supprimer sans ADR.
      //
      // Si on ouvre le composeur d'abord, l'app passe en arrière-plan et
      // Android peut suspendre la requête. On perd le lead — donc la preuve
      // qu'on vend à l'artisan.
      final ordre = <String>[];

      when(
        () => api.v1ContactEventsPost(
          v1ContactEventsPostRequest: any(named: 'v1ContactEventsPostRequest'),
          headers: any(named: 'headers'),
        ),
      ).thenAnswer((_) async {
        ordre.add('api');
        return _okResponse(
          ContactEventResponse(
            (b) => b
              ..contactEventId = 'evt-1'
              ..providerId = 'p1'
              ..channel = ContactEventResponseChannelEnum.PHONE
              ..phone = '+21622123456'
              ..deduplicated = false,
          ),
        );
      });
      when(() => launcher.launch(any())).thenAnswer((_) async {
        ordre.add('launch');
        return true;
      });

      await service.contact(providerId: 'p1', channel: ContactChannel.phone);

      expect(ordre, ['api', 'launch']);
    });

    test(
      "le numéro utilisé est celui révélé par l'API, pas un cache local",
      () async {
        // La fiche publique ne contient PAS le numéro (P8). S'il apparaît
        // localement, c'est qu'il a fuité quelque part.
        when(
          () => api.v1ContactEventsPost(
            v1ContactEventsPostRequest: any(
              named: 'v1ContactEventsPostRequest',
            ),
            headers: any(named: 'headers'),
          ),
        ).thenAnswer(
          (_) async => _okResponse(
            ContactEventResponse(
              (b) => b
                ..contactEventId = 'evt-1'
                ..providerId = 'p1'
                ..channel = ContactEventResponseChannelEnum.PHONE
                ..phone = '+21698765432'
                ..deduplicated = false,
            ),
          ),
        );
        when(() => launcher.launch(any())).thenAnswer((_) async => true);

        await service.contact(providerId: 'p1', channel: ContactChannel.phone);

        verify(() => launcher.launch('tel:+21698765432')).called(1);
      },
    );

    test(
      "l'en-tête Accept-Language transmet la langue active au serveur",
      () async {
        // whatsappMessage est localisé côté serveur (packages/validators/src/
        // contact.ts) — le client ne fait qu'encoder ce que le serveur
        // renvoie, il ne construit jamais le texte lui-même.
        when(
          () => api.v1ContactEventsPost(
            v1ContactEventsPostRequest: any(
              named: 'v1ContactEventsPostRequest',
            ),
            headers: any(named: 'headers'),
          ),
        ).thenAnswer(
          (_) async => _okResponse(
            ContactEventResponse(
              (b) => b
                ..contactEventId = 'evt-1'
                ..providerId = 'p1'
                ..channel = ContactEventResponseChannelEnum.WHATSAPP
                ..phone = '+21622123456'
                ..whatsappMessage = 'مرحبا'
                ..deduplicated = false,
            ),
          ),
        );
        when(() => launcher.launch(any())).thenAnswer((_) async => true);

        await service.contact(
          providerId: 'p1',
          channel: ContactChannel.whatsapp,
          locale: 'ar',
        );

        final captured = verify(
          () => api.v1ContactEventsPost(
            v1ContactEventsPostRequest: captureAny(
              named: 'v1ContactEventsPostRequest',
            ),
            headers: captureAny(named: 'headers'),
          ),
        ).captured;
        final headers = captured[1] as Map<String, dynamic>;
        expect(headers['Accept-Language'], 'ar');
      },
    );
  });

  group("FM-09b — 🔒 réseau dégradé : on n'empêche JAMAIS l'appel", () {
    test("🔒 si l'API échoue, le composeur s'ouvre quand même", () async {
      // 🔒 NON-RÉGRESSION — P5 : ne jamais supprimer sans ADR.
      //
      // Un utilisateur qui ne peut pas appeler parce que NOTRE traçage a
      // échoué désinstalle l'app. La trace est notre problème, pas le sien.
      // Hors ligne, aucun numéro n'est structurellement connu (P8) — seul
      // un numéro déjà révélé plus tôt dans la session (fallbackPhone)
      // permet d'ouvrir le composeur.
      when(
        () => api.v1ContactEventsPost(
          v1ContactEventsPostRequest: any(named: 'v1ContactEventsPostRequest'),
          headers: any(named: 'headers'),
        ),
      ).thenThrow(NetworkException('hors ligne'));
      when(() => queue.enqueue(any())).thenAnswer((_) async {});
      when(() => launcher.launch(any())).thenAnswer((_) async => true);

      await service.contact(
        providerId: 'p1',
        channel: ContactChannel.phone,
        fallbackPhone: '+21622123456',
      );

      verify(() => launcher.launch('tel:+21622123456')).called(1);
    });

    test(
      "sans numéro déjà révélé, l'échec réseau n'ouvre rien",
      () async {
        when(
          () => api.v1ContactEventsPost(
            v1ContactEventsPostRequest: any(
              named: 'v1ContactEventsPostRequest',
            ),
            headers: any(named: 'headers'),
          ),
        ).thenThrow(NetworkException('hors ligne'));
        when(() => queue.enqueue(any())).thenAnswer((_) async {});

        await service.contact(providerId: 'p1', channel: ContactChannel.phone);

        verifyNever(() => launcher.launch(any()));
      },
    );

    test("🔒 l'événement échoué part en file locale", () async {
      // 🔒 NON-RÉGRESSION — P9 : sans la file, on perd le lead pour de bon.
      when(
        () => api.v1ContactEventsPost(
          v1ContactEventsPostRequest: any(named: 'v1ContactEventsPostRequest'),
          headers: any(named: 'headers'),
        ),
      ).thenThrow(NetworkException('hors ligne'));
      when(() => queue.enqueue(any())).thenAnswer((_) async {});
      when(() => launcher.launch(any())).thenAnswer((_) async => true);

      await service.contact(
        providerId: 'p1',
        channel: ContactChannel.phone,
        fallbackPhone: '+21622123456',
      );

      verify(() => queue.enqueue(any())).called(1);
    });

    test(
      'la file est vidée au retour du réseau, sans rouvrir le composeur',
      () async {
        when(() => queue.pending()).thenAnswer(
          (_) async => [
            PendingContact(
              providerId: 'p1',
              channel: ContactChannel.phone,
              at: DateTime(2026, 8, 20),
            ),
            PendingContact(
              providerId: 'p2',
              channel: ContactChannel.whatsapp,
              at: DateTime(2026, 8, 20),
            ),
          ],
        );
        when(
          () => api.v1ContactEventsPost(
            v1ContactEventsPostRequest: any(
              named: 'v1ContactEventsPostRequest',
            ),
            headers: any(named: 'headers'),
          ),
        ).thenAnswer(
          (_) async => _okResponse(
            ContactEventResponse(
              (b) => b
                ..contactEventId = 'evt-1'
                ..providerId = 'p1'
                ..channel = ContactEventResponseChannelEnum.PHONE
                ..phone = '+21622123456'
                ..deduplicated = false,
            ),
          ),
        );
        when(() => queue.remove(any())).thenAnswer((_) async {});

        await service.flushQueue();

        verify(
          () => api.v1ContactEventsPost(
            v1ContactEventsPostRequest: any(
              named: 'v1ContactEventsPostRequest',
            ),
            headers: any(named: 'headers'),
          ),
        ).called(2);
        verify(() => queue.remove(any())).called(2);
        verifyNever(() => launcher.launch(any()));
      },
    );

    test('un événement en file qui échoue encore reste en file', () async {
      // Sinon on perd le lead au premier renvoi raté.
      when(() => queue.pending()).thenAnswer(
        (_) async => [
          PendingContact(
            providerId: 'p1',
            channel: ContactChannel.phone,
            at: DateTime(2026, 8, 20),
          ),
        ],
      );
      when(
        () => api.v1ContactEventsPost(
          v1ContactEventsPostRequest: any(named: 'v1ContactEventsPostRequest'),
          headers: any(named: 'headers'),
        ),
      ).thenThrow(NetworkException('toujours hors ligne'));

      await service.flushQueue();

      verifyNever(() => queue.remove(any()));
    });
  });

  group('FM-09b — WhatsApp bilingue', () {
    test(
      'le lien wa.me encode le message déjà localisé par le serveur',
      () async {
        when(
          () => api.v1ContactEventsPost(
            v1ContactEventsPostRequest: any(
              named: 'v1ContactEventsPostRequest',
            ),
            headers: any(named: 'headers'),
          ),
        ).thenAnswer(
          (_) async => _okResponse(
            ContactEventResponse(
              (b) => b
                ..contactEventId = 'evt-1'
                ..providerId = 'p1'
                ..channel = ContactEventResponseChannelEnum.WHATSAPP
                ..phone = '+21622123456'
                ..whatsappMessage = 'Bonjour, je vous contacte via Sanaya'
                ..deduplicated = false,
            ),
          ),
        );
        when(() => launcher.launch(any())).thenAnswer((_) async => true);

        await service.contact(
          providerId: 'p1',
          channel: ContactChannel.whatsapp,
        );

        final captured =
            verify(() => launcher.launch(captureAny())).captured.single
                as String;
        expect(captured, startsWith('https://wa.me/21622123456'));
        expect(captured, contains('text='));
      },
    );
  });
}
