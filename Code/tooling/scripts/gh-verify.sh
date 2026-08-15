#!/usr/bin/env bash
# =============================================================================
# Sanaya — Vérification : que manque-t-il sur GitHub par rapport au backlog ?
#
#   ./Code/tooling/scripts/gh-verify.sh
#
# Compare les IDs présents dans github-issues.json avec ceux réellement créés,
# et affiche précisément ce qui manque, ce qui est en double, et ce qui n'a pas
# d'assigné.
# =============================================================================
set -uo pipefail

REPO="${REPO:-dallel5-git/plateforme-artisans}"
cd "$(dirname "${BASH_SOURCE[0]}")/../../.."
DATA="${DATA:-Code/tooling/scripts/github-issues.json}"

say() { printf '\n\033[1;34m▸ %s\033[0m\n' "$*"; }
ok()  { printf '  \033[0;32m✓\033[0m %s\n' "$*"; }
bad() { printf '  \033[0;31m✗\033[0m %s\n' "$*"; }
warn(){ printf '  \033[0;33m!\033[0m %s\n' "$*"; }

[[ -f "$DATA" ]] || { echo "Fichier introuvable : $DATA"; exit 1; }

TMP=$(mktemp -d); trap 'rm -rf "$TMP"' EXIT

say "Lecture de GitHub"
gh issue list --repo "$REPO" --state all --limit 400 \
   --json number,title,assignees,labels > "$TMP/remote.json" || {
     echo "Impossible de lire les issues. Vérifie gh auth status."; exit 1; }
echo "  $(jq 'length' "$TMP/remote.json") issues trouvées sur le dépôt"

# IDs attendus (depuis le JSON) et IDs présents (extraits des titres)
jq -r '.[].id' "$DATA" | sort > "$TMP/attendus.txt"
jq -r '.[].title' "$TMP/remote.json" \
  | sed -n 's/^\[\(ÉPIQUE \)\?\([A-Z]\{2,3\}-[0-9A-Za-z-]\+\)\].*/\2/p' \
  | sort > "$TMP/presents.txt"

say "Manquantes"
MISSING=$(comm -23 "$TMP/attendus.txt" <(sort -u "$TMP/presents.txt"))
if [[ -z "$MISSING" ]]; then
  ok "aucune — les $(wc -l < "$TMP/attendus.txt" | tr -d ' ') issues sont créées"
else
  echo "$MISSING" | while read -r id; do
    [[ -z "$id" ]] && continue
    T=$(jq -r --arg i "$id" '.[] | select(.id==$i) | .title' "$DATA")
    A=$(jq -r --arg i "$id" '.[] | select(.id==$i) | .assignee // "—"' "$DATA")
    bad "$id  ($A)  $T"
  done
  printf '\n  \033[1;33m→ Relance pour les créer (idempotent) :\033[0m\n'
  printf '    GH_CHAYMA=<handle> ./Code/tooling/scripts/setup-github.sh\n'
fi

say "Doublons"
DUP=$(sort "$TMP/presents.txt" | uniq -d)
[[ -z "$DUP" ]] && ok "aucun" || echo "$DUP" | while read -r d; do bad "$d créé plusieurs fois"; done

say "Assignations"
NOASSIGN=$(jq -r '.[] | select((.assignees|length)==0) | .title' "$TMP/remote.json" | head -20)
if [[ -z "$NOASSIGN" ]]; then
  ok "toutes les issues ont un assigné"
else
  N=$(jq -r '[.[] | select((.assignees|length)==0)] | length' "$TMP/remote.json")
  warn "$N issues sans assigné :"
  echo "$NOASSIGN" | sed 's/^/      /'
  printf '\n  \033[1;33m→ Cause la plus fréquente : la personne n%s est pas encore collaboratrice du dépôt.\033[0m\n' "'"
  printf '    GitHub refuse d%sassigner un non-collaborateur.\n' "'"
  printf '    1. Invite-la : https://github.com/%s/settings/access\n' "$REPO"
  printf '    2. Une fois l%sinvitation ACCEPTÉE, relance setup-github.sh\n' "'"
fi

say "Répartition"
jq -r '[.[] | .labels[] | select(.name|startswith("sprint:")) | .name]
       | group_by(.) | .[] | "  \(.[0]) : \(length)"' "$TMP/remote.json"
jq -r '[.[] | .labels[] | select(.name|startswith("prio:")) | .name]
       | group_by(.) | .[] | "  \(.[0]) : \(length)"' "$TMP/remote.json"

say "Milestones"
gh api "repos/$REPO/milestones?state=all&per_page=100" \
  --jq '.[] | "  \(.title) — \(.open_issues) ouvertes / \(.closed_issues) fermées"' 2>/dev/null \
  || warn "lecture des milestones impossible"

echo
