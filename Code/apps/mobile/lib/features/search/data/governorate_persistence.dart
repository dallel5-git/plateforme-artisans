import 'package:shared_preferences/shared_preferences.dart';

const _governorateIdKey = 'sanaya.governorate_id';

/// Gouvernorat mémorisé lors d'un lancement précédent, ou `null` si le
/// client n'en a encore choisi aucun. La géolocalisation GPS précise est
/// hors périmètre S1 (ADR-003) : la seule « détection » possible ici est de
/// relire le dernier choix mémorisé.
Future<String?> readInitialGovernorateId() async {
  final prefs = await SharedPreferences.getInstance();
  return prefs.getString(_governorateIdKey);
}

/// Persiste le choix de gouvernorat — appelé à chaque changement de
/// `selectedGovernorateIdProvider` (cf. lib/main.dart).
Future<void> persistGovernorateId(String governorateId) async {
  final prefs = await SharedPreferences.getInstance();
  await prefs.setString(_governorateIdKey, governorateId);
}
