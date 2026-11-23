import 'dart:convert';

import 'package:hive/hive.dart';

/// Store clé→JSON générique sur disque (FM-28), au-dessus d'une [Box<String>]
/// Hive nommée. Ne connaît rien de la forme des valeurs ni d'une éventuelle
/// péremption (TTL) — décision de l'appelant (P3 : aucune règle ici, juste
/// un passage disque).
class DiskCache {
  DiskCache(this.boxName);

  final String boxName;

  Future<Box<String>> _box() async => Hive.isBoxOpen(boxName)
      ? Hive.box<String>(boxName)
      : Hive.openBox<String>(boxName);

  /// `null` si la clé est absente ou si la valeur stockée n'est pas un JSON
  /// exploitable (jamais une exception qui casserait l'affichage hors ligne
  /// — ceci ne couvre que la corruption locale, pas les erreurs réseau, qui
  /// restent propagées ailleurs, cf. `SearchRepository`).
  Future<Map<String, dynamic>?> read(String key) async {
    final raw = (await _box()).get(key);
    if (raw == null) return null;
    try {
      final decoded = jsonDecode(raw);
      if (decoded is Map<String, dynamic>) {
        return decoded;
      }
      return null;
    } on FormatException {
      return null;
    }
  }

  Future<void> write(String key, Map<String, dynamic> value) async =>
      (await _box()).put(key, jsonEncode(value));

  Future<void> delete(String key) async => (await _box()).delete(key);
}
