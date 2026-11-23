// Utilitaire d'export CSV pour les listes de modération et d'audit
export function exportToCsv(filename: string, rows: Record<string, unknown>[]): void {
  const firstRow = rows[0];
  if (!firstRow) return;
  const headers = Object.keys(firstRow);
  const csvContent = [
    headers.join(','),
    ...rows.map((row) =>
      headers
        .map((header) => {
          const val = row[header];
          return typeof val === 'string' ? `"${val.replace(/"/g, '""')}"` : String(val ?? '');
        })
        .join(','),
    ),
  ].join('\n');

  const blob = new Blob([csvContent], { type: 'text/csv;charset=utf-8;' });
  const url = URL.createObjectURL(blob);
  const link = document.createElement('a');
  link.setAttribute('href', url);
  link.setAttribute('download', `${filename}.csv`);
  document.body.appendChild(link);
  link.click();
  document.body.removeChild(link);
}
