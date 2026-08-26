/// Configuration d'environnement du client réseau.
class ApiEnv {
  const ApiEnv._();

  /// URL de base de l'API, `/v1` inclus. Surchargée au build via
  /// `--dart-define=API_BASE_URL=https://...`. La valeur par défaut vise
  /// l'émulateur Android (`10.0.2.2` redirige vers `localhost` de la machine
  /// hôte) contre l'API locale (`API_PORT=4000`, voir `.env.example`) — pour
  /// un device physique ou iOS, passer explicitement `--dart-define`.
  static const String baseUrl = String.fromEnvironment(
    'API_BASE_URL',
    defaultValue: 'http://10.0.2.2:4000/v1',
  );

  /// P5 (réseau dégradé) / `apps/mobile/CLAUDE.md` : 10 s pour établir la
  /// connexion.
  static const Duration connectTimeout = Duration(seconds: 10);

  /// P5 : 20 s pour recevoir la réponse une fois la connexion établie.
  static const Duration receiveTimeout = Duration(seconds: 20);
}
