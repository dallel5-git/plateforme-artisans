// BE-23 : la clé de déduplication journalière (`ProfileView.viewDate`, `@db.Date`) doit être
// calculée sur un jour calendaire UTC — jamais Africa/Tunis (CLAUDE.md §4.1 : tout est stocké et
// transporté en UTC ISO-8601, le fuseau local n'est appliqué qu'à l'affichage).
export function resolveViewDate(now: Date): Date {
  return new Date(Date.UTC(now.getUTCFullYear(), now.getUTCMonth(), now.getUTCDate()));
}
