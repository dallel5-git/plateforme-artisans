#!/usr/bin/env bash
# =============================================================================
# Sanaya — Mise en place complète de GitHub, en une commande.
#
#   ./Code/tooling/scripts/setup-github.sh                    # tout
#   ./Code/tooling/scripts/setup-github.sh --dry-run          # simulation
#   GH_CHAYMA=son-handle ./Code/tooling/scripts/setup-github.sh
#
# Enchaîne : vérifications → labels + milestones + Project → génération des
# issues → création des 56 issues → récapitulatif.
# Tout est idempotent : relançable sans créer de doublon.
# =============================================================================
set -euo pipefail

cd "$(dirname "${BASH_SOURCE[0]}")/../../.."   # racine du dépôt
ROOT="$PWD"

DRY=""; [[ "${1:-}" == "--dry-run" ]] && DRY=1
export DRY_RUN="${DRY:-0}"
export REPO="${REPO:-dallel5-git/plateforme-artisans}"
export GH_OUSSAMA="${GH_OUSSAMA:-dallel5-git}"
export GH_CHAYMA="${GH_CHAYMA:-}"

bold() { printf '\n\033[1;36m━━━ %s ━━━\033[0m\n' "$*"; }

# RELANCE : en cas d'échec, rappeler que tout est idempotent
on_fail() {
  printf '\n\033[0;33m━━━ Interrompu ━━━\033[0m\n'
  cat <<'MSG'

  Rien n'est perdu : les trois scripts sont idempotents.
  Relance exactement la même commande — ce qui existe déjà sera mis à jour,
  pas dupliqué, et la reprise partira d'où ça s'est arrêté.

  Si le réseau est vraiment instable, augmente le nombre de tentatives
  et la pause entre écritures :

      GH_MAX_TRIES=10 GH_PAUSE=1.5 ./Code/tooling/scripts/setup-github.sh

MSG
}
trap 'on_fail' ERR
die()  { printf '\n\033[0;31m✗ %s\033[0m\n\n' "$*" >&2; exit 1; }
ok()   { printf '  \033[0;32m✓\033[0m %s\n' "$*"; }

# -----------------------------------------------------------------------------
bold "Vérifications"

command -v gh >/dev/null || die "gh absent.
   macOS  : brew install gh
   Debian : sudo apt install gh
   autre  : https://cli.github.com"
ok "gh $(gh --version | head -1 | awk '{print $3}')"

command -v jq >/dev/null || die "jq absent — brew install jq  /  sudo apt install jq"
ok "jq"

command -v python3 >/dev/null || die "python3 absent"
ok "python3"

gh auth status >/dev/null 2>&1 || die "Non authentifié — lance : gh auth login
   Scopes nécessaires : repo, project, read:org"
ok "authentifié : $(gh api user --jq .login 2>/dev/null || echo '?')"

gh repo view "$REPO" >/dev/null 2>&1 || die "Dépôt $REPO inaccessible.
   Vérifie le nom, ou que ton compte y a accès en écriture."
ok "dépôt $REPO accessible"

if [[ "${BASH_VERSINFO[0]}" -lt 4 ]]; then
  printf '  \033[0;33m!\033[0m bash %s (macOS). En cas d échec : brew install bash puis relancer avec /opt/homebrew/bin/bash\n' "$BASH_VERSION"
fi

if [[ -z "$GH_CHAYMA" ]]; then
  printf '  \033[0;33m!\033[0m GH_CHAYMA non renseigné — ses 20 issues resteront non assignées.\n'
  printf '    Relance plus tard avec : GH_CHAYMA=son-handle %s\n' "$0"
else
  gh api "users/$GH_CHAYMA" >/dev/null 2>&1 \
    && ok "Chayma : @$GH_CHAYMA" \
    || die "Utilisateur GitHub @$GH_CHAYMA introuvable."
fi

[[ -n "$DRY" ]] && printf '\n\033[0;33m  MODE SIMULATION — rien ne sera créé.\033[0m\n'

# -----------------------------------------------------------------------------
bold "1/3 · Labels, milestones et Project"
bash "$ROOT/Code/tooling/scripts/gh-bootstrap.sh"

# -----------------------------------------------------------------------------
bold "2/3 · Génération du fichier d'issues"
python3 "$ROOT/Code/tooling/scripts/issues-data.py" \
  > "$ROOT/Code/tooling/scripts/github-issues.json"
ok "$(jq 'length' "$ROOT/Code/tooling/scripts/github-issues.json") issues préparées"

# -----------------------------------------------------------------------------
bold "3/3 · Création des issues"
DATA="$ROOT/Code/tooling/scripts/github-issues.json" \
  bash "$ROOT/Code/tooling/scripts/gh-seed-issues.sh"

# -----------------------------------------------------------------------------
[[ -n "$DRY" ]] && { bold "Simulation terminée"; exit 0; }

bold "Terminé"
cat <<EOF

  → https://github.com/$REPO/issues
  → https://github.com/$REPO/milestones

  Il reste 3 actions manuelles, une seule fois :

    1. Inviter Chayma en écriture, puis remplacer @CHAYMA-HANDLE
       dans .github/CODEOWNERS
       https://github.com/$REPO/settings/access

    2. Protéger main : 1 approbation · CI verte · squash-merge
       https://github.com/$REPO/settings/branches

    3. Créer les colonnes et champs du Project
       (Backlog → Ready → In progress → In review → Blocked → Done)

  Puis commiter la structure :
    git add -A && git commit -m "chore: organisation GitHub, backlog et guard-rails" && git push

EOF
