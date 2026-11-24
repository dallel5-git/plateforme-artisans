import 'package:shared_preferences/shared_preferences.dart';

const _hasPublishedProfileKey = 'sanaya.has_published_profile';

/// Statut de publication mémorisé lors d'un lancement précédent — repli
/// documenté (FM-24) tant que `GET /v1/providers/me` (BE-44) n'existe pas :
/// seule façon de savoir, après un vrai relancement de l'app, si l'artisan a
/// déjà publié son profil (cf. la garde `/pro/*` dans lib/app/router.dart).
/// Limite acceptée : ne survit pas à une réinstallation ni à un changement
/// de device — résolu plus tard par BE-44.
Future<bool> readInitialPublicationStatus() async {
  final prefs = await SharedPreferences.getInstance();
  return prefs.getBool(_hasPublishedProfileKey) ?? false;
}

/// Persiste le statut de publication — appelé à chaque changement de
/// `hasPublishedProfileProvider` (cf. lib/main.dart).
Future<void> persistPublicationStatus({
  required bool hasPublishedProfile,
}) async {
  final prefs = await SharedPreferences.getInstance();
  await prefs.setBool(_hasPublishedProfileKey, hasPublishedProfile);
}

/// Supprime le statut de publication persisté — appelé lors de la
/// déconnexion (`signOut`, MOB-006).
Future<void> clearPublicationStatus() async {
  final prefs = await SharedPreferences.getInstance();
  await prefs.remove(_hasPublishedProfileKey);
}
