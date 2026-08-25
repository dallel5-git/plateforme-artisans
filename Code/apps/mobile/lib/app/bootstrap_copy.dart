/// FM-01 : chaînes provisoires du shell bootstrap. Le catalogue slang FR/AR
/// (`lib/core/i18n/`) n'est pas dans le périmètre de cette issue — centralisé
/// ici plutôt que dispersé dans les widgets, pour qu'une tâche i18n
/// ultérieure supprime ce fichier en un seul diff. Exemption déclarée dans
/// la description de la PR FM-01d.
abstract final class BootstrapCopy {
  static const appName = 'Sanaya';
  static const authLabel = 'Espace authentification — à venir (FM-05)';
  static const clientLabel = 'Espace client — à venir (FM-06)';
  static const proLabel = 'Espace pro — à venir (FM-08)';
  static const toggleThemeTooltip = 'Basculer thème clair/sombre';
  static const toggleLocaleTooltip = 'Basculer FR/AR';
}
