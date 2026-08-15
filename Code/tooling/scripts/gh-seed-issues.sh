#!/usr/bin/env bash
# =============================================================================
# Sanaya — Création des issues GitHub depuis github-issues.json
#
# Idempotent : une issue dont le titre existe déjà est mise à jour, pas dupliquée.
# Les dépendances (`Dépend de`) sont converties en liens `#N` une fois tous les
# numéros connus, puis les issues bloquées reçoivent le label `blocked`.
#
# Prérequis :
#   ./tooling/scripts/gh-bootstrap.sh   (labels + milestones doivent exister)
#   gh auth login
#   jq
#
# Usage :
#   ./tooling/scripts/gh-seed-issues.sh                    # tout
#   ONLY=sprint:S1 ./tooling/scripts/gh-seed-issues.sh     # filtre par label
#   DRY_RUN=1 ./tooling/scripts/gh-seed-issues.sh          # affiche sans créer
#
# Identifiants GitHub (à renseigner) :
#   GH_OUSSAMA=dallel5-git GH_CHAYMA=<handle> ./tooling/scripts/gh-seed-issues.sh
# =============================================================================
set -euo pipefail

REPO="${REPO:-dallel5-git/plateforme-artisans}"
DATA="${DATA:-tooling/scripts/github-issues.json}"
DRY_RUN="${DRY_RUN:-0}"
ONLY="${ONLY:-}"
GH_OUSSAMA="${GH_OUSSAMA:-dallel5-git}"
GH_CHAYMA="${GH_CHAYMA:-}"      # ⚠️ à renseigner, sinon pas d'assignation
GH_PAUSE="${GH_PAUSE:-0.5}"     # pause entre écritures (limites secondaires GitHub)
PROJECT_NUMBER="${PROJECT_NUMBER:-$(cat .github/.project-number 2>/dev/null || echo '')}"

say() { printf '\n\033[1;34m▸ %s\033[0m\n' "$*"; }
ok()  { printf '  \033[0;32m✓\033[0m %s\n' "$*"; }
warn(){ printf '  \033[0;33m!\033[0m %s\n' "$*"; }

[[ "${BASH_VERSINFO[0]}" -lt 4 ]] && warn "bash ${BASH_VERSION} détecté (macOS) — si le script échoue, lance-le avec : brew install bash && /opt/homebrew/bin/bash tooling/scripts/gh-seed-issues.sh"
command -v gh >/dev/null || { echo "gh CLI absent"; exit 1; }

# -----------------------------------------------------------------------------
# Reprise automatique sur incident réseau.
# `gh` est redéfini en fonction shell : tous les appels existants en bénéficient
# sans modification. Seules les erreurs réseau transitoires sont réessayées —
# une vraie erreur (404, permission refusée, label invalide) remonte immédiatement.
# -----------------------------------------------------------------------------
GH_MAX_TRIES="${GH_MAX_TRIES:-6}"
gh() {
  local i=1 delay=3 rc out err
  err=$(mktemp)
  while :; do
    # ⚠️ Le statut DOIT être capturé sur la ligne de l'appel.
    # Après `if cmd; then ... fi` dont la condition échoue, $? vaut 0 — pas
    # le code d'erreur. Ce piège faisait passer tous les échecs pour des succès.
    rc=0
    out=$(command gh "$@" 2>"$err") || rc=$?
    if (( rc == 0 )); then
      rm -f "$err"; printf '%s' "$out"; return 0
    fi
    if (( i >= GH_MAX_TRIES )) || ! grep -qiE \
        'timeout|TLS handshake|connection reset|unexpected EOF|temporary failure|dial tcp|no such host|i/o timeout|502|503|504|EOF' "$err"; then
      cat "$err" >&2; rm -f "$err"; return $rc
    fi
    printf '\033[0;33m  ↻ réseau instable — tentative %d/%d dans %ds\033[0m\n' \
           "$i" "$GH_MAX_TRIES" "$delay" >&2
    sleep "$delay"; delay=$(( delay * 2 )); i=$(( i + 1 ))
  done
}

command -v jq >/dev/null || { echo "jq absent"; exit 1; }
[[ -f "$DATA" ]] || { echo "Fichier introuvable : $DATA — lance d'abord : python3 tooling/scripts/issues-data.py > $DATA"; exit 1; }

[[ -z "$GH_CHAYMA" ]] && warn "GH_CHAYMA non renseigné : les issues de Chayma resteront non assignées."

FAILED=()
NOASSIGN=0
MAP_FILE="$(mktemp)"   # "ID<TAB>numéro d'issue"
trap 'rm -f "$MAP_FILE"' EXIT

# -----------------------------------------------------------------------------
# Passe 1 — créer / mettre à jour chaque issue
# -----------------------------------------------------------------------------
say "Création des issues"

TOTAL=$(jq 'length' "$DATA")
for i in $(seq 0 $((TOTAL - 1))); do
  ID=$(jq -r ".[$i].id"        "$DATA")
  TITLE=$(jq -r ".[$i].title"  "$DATA")
  MS=$(jq -r ".[$i].milestone" "$DATA")
  BODY=$(jq -r ".[$i].body"    "$DATA")
  ASSIGNEE=$(jq -r ".[$i].assignee // empty" "$DATA")
  LABELS=$(jq -r ".[$i].labels | join(\",\")" "$DATA")

  if [[ -n "$ONLY" ]] && ! grep -q "$ONLY" <<<"$LABELS"; then continue; fi

  # L'issue existe-t-elle déjà ? (recherche par ID entre crochets dans le titre)
  EXISTING=$(gh issue list --repo "$REPO" --state all --limit 300 --json number,title \
             --jq ".[] | select(.title | startswith(\"[$ID]\") or startswith(\"[ÉPIQUE $ID]\")) | .number" 2>/dev/null | head -1)
  # Filet : ne garder que si c'est bien un entier
  [[ "$EXISTING" =~ ^[0-9]+$ ]] || EXISTING=""

  # Assignation
  ASSIGN_ARGS=()
  case "$ASSIGNEE" in
    oussama) ASSIGN_ARGS=(--add-assignee "$GH_OUSSAMA") ;;
    chayma)  [[ -n "$GH_CHAYMA" ]] && ASSIGN_ARGS=(--add-assignee "$GH_CHAYMA") ;;
    binome)  ASSIGN_ARGS=(--add-assignee "$GH_OUSSAMA")
             [[ -n "$GH_CHAYMA" ]] && ASSIGN_ARGS+=(--add-assignee "$GH_CHAYMA") ;;
  esac

  if [[ "$DRY_RUN" == "1" ]]; then
    printf '  [dry-run] %-14s %s\n' "$ID" "$TITLE"
    continue
  fi

  if [[ -n "$EXISTING" ]]; then
    gh issue edit "$EXISTING" --repo "$REPO" \
      --body "$BODY" --milestone "$MS" \
      --add-label "$LABELS" >/dev/null
    NUM="$EXISTING"
    ok "#$NUM  $ID (mis à jour)"
  else
    # L'issue est créée SANS assigné : GitHub refuse d'assigner un non-collaborateur
    # et ferait échouer toute la création. L'assignation se fait juste après, et
    # son échec n'empêche pas l'issue d'exister.
    if ! URL=$(gh issue create --repo "$REPO" \
          --title "$TITLE" --body "$BODY" \
          --milestone "$MS" --label "$LABELS"); then
      warn "ÉCHEC de création pour $ID — passe au suivant"
      FAILED+=("$ID"); continue
    fi
    NUM="${URL##*/}"
    if ! [[ "$NUM" =~ ^[0-9]+$ ]]; then
      warn "Réponse inattendue de gh pour $ID : $URL"; FAILED+=("$ID"); continue
    fi
    if (( ${#ASSIGN_ARGS[@]} )); then
      if gh issue edit "$NUM" --repo "$REPO" \
           ${ASSIGN_ARGS[@]+"${ASSIGN_ARGS[@]}"} >/dev/null 2>&1; then
        ok "#$NUM  $ID"
      else
        ok "#$NUM  $ID"
        warn "   assignation impossible — la personne n'est probablement pas collaboratrice du dépôt"
        NOASSIGN=$(( NOASSIGN + 1 ))
      fi
    else
      ok "#$NUM  $ID"
    fi
  fi

  printf '%s\t%s\n' "$ID" "$NUM" >> "$MAP_FILE"
  sleep "$GH_PAUSE"

  # Ajout au Project
  if [[ -n "$PROJECT_NUMBER" ]]; then
    gh project item-add "$PROJECT_NUMBER" --owner "${REPO%%/*}" \
      --url "https://github.com/$REPO/issues/$NUM" >/dev/null 2>&1 || true
  fi
done

[[ "$DRY_RUN" == "1" ]] && { say "Fin (dry-run)"; exit 0; }

# -----------------------------------------------------------------------------
# Passe 2 — résoudre les dépendances en liens #N, marquer les bloquées
# -----------------------------------------------------------------------------
say "Dépendances"

for i in $(seq 0 $((TOTAL - 1))); do
  ID=$(jq -r ".[$i].id" "$DATA")
  DEPS=$(jq -r ".[$i].deps[]?" "$DATA")
  [[ -z "$DEPS" ]] && continue

  NUM=$(awk -F'\t' -v id="$ID" '$1==id{print $2}' "$MAP_FILE" | head -1)
  [[ -z "$NUM" ]] && continue

  LINKS=""
  for d in $DEPS; do
    DNUM=$(awk -F'\t' -v id="$d" '$1==id{print $2}' "$MAP_FILE" | head -1)
    [[ -n "$DNUM" ]] && LINKS+="#$DNUM ($d) · " || LINKS+="\`$d\` · "
  done
  LINKS="${LINKS% · }"

  gh issue comment "$NUM" --repo "$REPO" --body \
"⛓️ **Bloquée par** : $LINKS

Ne pas démarrer tant que ces issues ne sont pas fermées (*Definition of Ready*, \`POLITIQUE-PROJET.md\` §5).
Retirer le label \`blocked\` quand elles le sont." >/dev/null
  gh issue edit "$NUM" --repo "$REPO" --add-label "blocked" >/dev/null
  ok "#$NUM $ID ← $LINKS"
done

# -----------------------------------------------------------------------------
if (( ${#FAILED[@]} )); then
  printf '\n\033[0;31m  ✗ %d issue(s) non créée(s) : %s\033[0m\n' "${#FAILED[@]}" "${FAILED[*]}"
  printf '    Relance la même commande — les autres ne seront pas dupliquées.\n'
fi
if (( NOASSIGN > 0 )); then
  printf '\n\033[0;33m  ! %d issue(s) créée(s) sans assigné.\033[0m\n' "$NOASSIGN"
  printf '    Invite la personne au dépôt, puis relance : elle sera assignée.\n'
  printf '    https://github.com/%s/settings/access\n' "$REPO"
fi

say "Récapitulatif"
gh issue list --repo "$REPO" --limit 300 --json number,title,labels \
  --jq 'group_by(.labels[] | select(.name|startswith("sprint:")) | .name)
        | .[] | "\(.[0].labels[] | select(.name|startswith("sprint:")) | .name) : \(length) issues"' 2>/dev/null || true

cat <<EOF

  Étapes suivantes, à faire à la main une seule fois :
    1. Inviter Chayma au dépôt en écriture, puis remplacer @CHAYMA-HANDLE
       dans .github/CODEOWNERS
    2. Protéger la branche main (Settings → Branches) :
       1 approbation · CI verte · squash-merge · pas de push direct
    3. Créer les vues et les champs du Project (voir la sortie de gh-bootstrap.sh)

EOF
