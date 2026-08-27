import 'package:url_launcher/url_launcher.dart' as url_launcher_plugin;

/// Fine couche testable au-dessus de `url_launcher` — les deep links
/// natifs (`tel:`, `https://wa.me/…`) sont LA valeur du mobile (« Deep
/// links natifs », `apps/mobile/CLAUDE.md`).
///
/// Volontairement une classe à une seule méthode plutôt qu'une fonction
/// top-level : `ContactService` (FM-09b) l'injecte et un test mocktail a
/// besoin d'un type à substituer (`class _LauncherMock extends Mock
/// implements UrlLauncher`), pas d'une fonction globale.
// ignore: one_member_abstracts
abstract class UrlLauncher {
  Future<bool> launch(String url);
}

class UrlLauncherImpl implements UrlLauncher {
  @override
  Future<bool> launch(String url) {
    return url_launcher_plugin.launchUrl(
      Uri.parse(url),
      mode: url_launcher_plugin.LaunchMode.externalApplication,
    );
  }
}
