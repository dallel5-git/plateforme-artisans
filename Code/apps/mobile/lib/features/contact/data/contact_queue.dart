import 'dart:convert';

import 'package:sanaya/features/contact/domain/contact_channel.dart';
import 'package:sanaya/features/contact/domain/pending_contact.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// File locale des `ContactEvent` dont le POST a échoué — persistée pour
/// survivre à un redémarrage de l'app avant le retour du réseau (P9 :
/// aucun lead perdu, même si l'app est tuée entre-temps).
abstract class ContactQueue {
  Future<void> enqueue(PendingContact contact);
  Future<List<PendingContact>> pending();
  Future<void> remove(PendingContact contact);
}

const _storageKey = 'sanaya.contact_queue';

class SharedPreferencesContactQueue implements ContactQueue {
  @override
  Future<void> enqueue(PendingContact contact) async {
    final prefs = await SharedPreferences.getInstance();
    final current = await _read(prefs);
    await prefs.setStringList(_storageKey, [
      ...current.map(_encode),
      _encode(contact),
    ]);
  }

  @override
  Future<List<PendingContact>> pending() async {
    final prefs = await SharedPreferences.getInstance();
    return _read(prefs);
  }

  @override
  Future<void> remove(PendingContact contact) async {
    final prefs = await SharedPreferences.getInstance();
    final current = await _read(prefs);
    final remaining = current.where((c) => c != contact).toList();
    await prefs.setStringList(_storageKey, remaining.map(_encode).toList());
  }

  Future<List<PendingContact>> _read(SharedPreferences prefs) async {
    final raw = prefs.getStringList(_storageKey) ?? const [];
    return raw.map(_decode).toList();
  }

  String _encode(PendingContact contact) => jsonEncode({
    'providerId': contact.providerId,
    'channel': contact.channel.name,
    'at': contact.at.toIso8601String(),
    'categoryId': contact.categoryId,
    'sourceScreen': contact.sourceScreen,
    'locale': contact.locale,
  });

  PendingContact _decode(String raw) {
    final json = jsonDecode(raw) as Map<String, dynamic>;
    return PendingContact(
      providerId: json['providerId'] as String,
      channel: ContactChannel.values.byName(json['channel'] as String),
      at: DateTime.parse(json['at'] as String),
      categoryId: json['categoryId'] as String?,
      sourceScreen: json['sourceScreen'] as String?,
      locale: json['locale'] as String? ?? 'fr',
    );
  }
}
