import 'package:flutter/foundation.dart';
import 'package:sanaya/features/contact/domain/contact_channel.dart';

/// Un contact dont le `ContactEvent` (P9) n'a pas encore atteint le
/// serveur — mis en file par `ContactQueue` quand le POST échoue, renvoyé
/// au retour du réseau. Ne porte jamais de numéro de téléphone (P8) : au
/// renvoi, le serveur le révèle à nouveau.
@immutable
class PendingContact {
  const PendingContact({
    required this.providerId,
    required this.channel,
    required this.at,
    this.categoryId,
    this.sourceScreen,
    this.locale = 'fr',
  });

  final String providerId;
  final ContactChannel channel;
  final DateTime at;
  final String? categoryId;

  /// Valeur brute de `V1ContactEventsPostRequestSourceScreenEnum` (ex.
  /// `'profile'`) — gardée en `String` plutôt qu'en type généré pour que
  /// le format persisté (SharedPreferences) ne dépende pas d'une
  /// régénération du client.
  final String? sourceScreen;
  final String locale;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is PendingContact &&
          other.providerId == providerId &&
          other.channel == channel &&
          other.at == at &&
          other.categoryId == categoryId &&
          other.sourceScreen == sourceScreen &&
          other.locale == locale);

  @override
  int get hashCode =>
      Object.hash(providerId, channel, at, categoryId, sourceScreen, locale);
}
