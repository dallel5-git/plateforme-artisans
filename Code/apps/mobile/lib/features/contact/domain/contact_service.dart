import 'package:sanaya/core/api/generated/api.dart';
import 'package:sanaya/features/contact/data/contact_queue.dart';
import 'package:sanaya/features/contact/data/url_launcher.dart';
import 'package:sanaya/features/contact/domain/contact_channel.dart';
import 'package:sanaya/features/contact/domain/pending_contact.dart';

/// Orchestre un contact (P9 : trace AVANT d'ouvrir le lien natif) et son
/// repli hors ligne (P5 : ne jamais bloquer l'utilisateur pour une raison
/// de traçabilité).
///
/// Le numéro n'est jamais connu avant la réponse du serveur (P8) : un
/// premier contact à froid hors ligne n'a donc structurellement rien à
/// composer — seul `fallbackPhone` (un numéro déjà révélé plus tôt dans la
/// session pour ce même prestataire) permet d'ouvrir le composeur hors
/// ligne. `flushQueue()` ne fait que renvoyer la trace : il ne rouvre
/// jamais le composeur, un lead déjà ouvert une fois n'a pas besoin de
/// l'être une seconde.
class ContactService {
  ContactService({
    required this.api,
    required this.queue,
    required this.launcher,
  });

  final ContactEventsApi api;
  final ContactQueue queue;
  final UrlLauncher launcher;

  Future<void> contact({
    required String providerId,
    required ContactChannel channel,
    String? categoryId,
    String? sourceScreen,
    String locale = 'fr',
    String? fallbackPhone,
  }) async {
    final pending = PendingContact(
      providerId: providerId,
      channel: channel,
      at: DateTime.now(),
      categoryId: categoryId,
      sourceScreen: sourceScreen,
      locale: locale,
    );

    try {
      final response = await unwrapDioErrors(
        () => api.v1ContactEventsPost(
          v1ContactEventsPostRequest: _buildRequest(pending),
          headers: {'Accept-Language': locale},
        ),
      );
      final body = response.data!;
      await launcher.launch(
        _urlFor(
          channel: channel,
          phone: body.phone,
          whatsappMessage: body.whatsappMessage,
        ),
      );
    } on SanayaApiException {
      await queue.enqueue(pending);
      if (fallbackPhone != null) {
        await launcher.launch(_urlFor(channel: channel, phone: fallbackPhone));
      }
    }
  }

  /// Renvoie chaque contact en file. Ne rouvre jamais le composeur : un
  /// renvoi réussi confirme juste la trace, il n'y a plus d'action
  /// utilisateur à déclencher.
  Future<void> flushQueue() async {
    for (final pending in await queue.pending()) {
      try {
        await unwrapDioErrors(
          () => api.v1ContactEventsPost(
            v1ContactEventsPostRequest: _buildRequest(pending),
            headers: {'Accept-Language': pending.locale},
          ),
        );
        await queue.remove(pending);
      } on SanayaApiException {
        // Reste en file — retenté au prochain retour réseau.
      }
    }
  }

  V1ContactEventsPostRequest _buildRequest(PendingContact pending) {
    return V1ContactEventsPostRequest((b) {
      b
        ..providerId = pending.providerId
        ..channel = pending.channel == ContactChannel.phone
            ? V1ContactEventsPostRequestChannelEnum.PHONE
            : V1ContactEventsPostRequestChannelEnum.WHATSAPP
        ..categoryId = pending.categoryId;
      if (pending.sourceScreen != null) {
        b.sourceScreen = V1ContactEventsPostRequestSourceScreenEnum.valueOf(
          pending.sourceScreen!,
        );
      }
    });
  }

  String _urlFor({
    required ContactChannel channel,
    required String phone,
    String? whatsappMessage,
  }) {
    if (channel == ContactChannel.phone) return 'tel:$phone';

    final digits = phone.startsWith('+') ? phone.substring(1) : phone;
    if (whatsappMessage == null) return 'https://wa.me/$digits';
    return 'https://wa.me/$digits?text=${Uri.encodeComponent(whatsappMessage)}';
  }
}
