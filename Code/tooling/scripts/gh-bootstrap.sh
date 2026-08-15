#!/usr/bin/env bash
# =============================================================================
# Sanaya — Bootstrap GitHub : labels + milestones + Project (Kanban)
#
# Idempotent : relançable autant de fois que nécessaire, il met à jour au lieu
# de dupliquer.
#
# Prérequis :
#   gh --version          (https://cli.github.com)
#   gh auth login         avec les scopes  repo, project, read:org
#
# Usage :
#   ./tooling/scripts/gh-bootstrap.sh                 # applique
#   DRY_RUN=1 ./tooling/scripts/gh-bootstrap.sh       # affiche sans rien créer
# =============================================================================
set -euo pipefail

REPO="${REPO:-dallel5-git/plateforme-artisans}"
PROJECT_TITLE="${PROJECT_TITLE:-Sanaya — MVP}"
DRY_RUN="${DRY_RUN:-0}"

run() {
  if [[ "$DRY_RUN" == "1" ]]; then printf '  [dry-run] %s\n' "$*"; else "$@"; fi
}
say() { printf '\n\033[1;34m▸ %s\033[0m\n' "$*"; }
ok()  { printf '  \033[0;32m✓\033[0m %s\n' "$*"; }

command -v gh >/dev/null || { echo "gh CLI absent — https://cli.github.com"; exit 1; }

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

gh auth status >/dev/null 2>&1 || { echo "Non authentifié — lance : gh auth login"; exit 1; }

# =============================================================================
# 1. LABELS
# =============================================================================
# Convention : <famille>:<valeur>. Une famille = une dimension d'analyse.
# Une issue porte AU PLUS un label par famille (sauf domaine).
#
#   type:*      la nature du travail        (obligatoire)
#   lot:*       où vit le code              (obligatoire — c'est ce qui pilote CODEOWNERS)
#   domaine:*   le module métier concerné   (0 à n)
#   prio:*      P0 / P1 / P2                (obligatoire)
#   size:*      la taille estimée           (obligatoire)
#   sprint:*    le sprint d'affectation     (obligatoire)
#   les autres  transverses / signaux
# -----------------------------------------------------------------------------
say "Labels"

label() { # nom, couleur, description
  if [[ "$DRY_RUN" == "1" ]]; then printf '  [dry-run] label %s\n' "$1"; return; fi
  gh label create "$1" --repo "$REPO" --color "$2" --description "$3" --force >/dev/null
  ok "$1"
}

# --- type (bleu-gris) --------------------------------------------------------
label "type:feat"      "1D76DB" "Nouvelle fonctionnalité utilisateur"
label "type:fix"       "D93F0B" "Correction de bug"
label "type:chore"     "BFD4F2" "Outillage, config, dépendances — sans impact utilisateur"
label "type:refactor"  "C5DEF5" "Restructuration sans changement de comportement"
label "type:test"      "0E8A16" "Tests unitaires, intégration, E2E"
label "type:docs"      "0075CA" "Documentation, ADR, runbook"
label "type:spike"     "D4C5F9" "Exploration timeboxée — produit une décision, pas du code"
label "type:epic"      "5319E7" "Regroupement à décomposer avant le sprint concerné"

# --- lot : où vit le code (pilote CODEOWNERS et le risque de conflit) --------
label "lot:socle"      "FEF2C0" "Monorepo, CI, outillage, tokens"
label "lot:backend"    "1F883D" "apps/api, packages/core, packages/db, packages/auth"
label "lot:mobile"     "7057FF" "apps/mobile — Flutter / Dart"
label "lot:web"        "0969DA" "apps/web — Next.js (S2)"
label "lot:admin"      "8250DF" "apps/admin — back-office (S3)"
label "lot:design"     "F9A8D4" "Design tokens, design system, i18n"

# --- domaine métier ----------------------------------------------------------
label "domaine:auth"       "E4E669" "Authentification, OTP, sessions, RBAC"
label "domaine:catalog"    "E4E669" "Catégories, gouvernorats, délégations"
label "domaine:search"     "E4E669" "Recherche, filtres, ranking"
label "domaine:providers"  "E4E669" "Profil artisan, onboarding, complétude"
label "domaine:contact"    "E4E669" "ContactEvent, révélation du numéro, WhatsApp"
label "domaine:reviews"    "E4E669" "Avis, agrégats, réponses"
label "domaine:billing"    "E4E669" "Plans, abonnements, crédits, boosts, paiements"
label "domaine:moderation" "E4E669" "Vérification CIN, signalements, back-office"
label "domaine:analytics"  "E4E669" "Vues, statistiques, KPI"

# --- priorité (rouge → vert) -------------------------------------------------
label "prio:P0"        "B60205" "Non négociable pour l'objectif du sprint"
label "prio:P1"        "FBCA04" "Amortisseur — premier à couper si le rythme dérape"
label "prio:P2"        "C2E0C6" "Reporté — ne pas commencer"

# --- taille ------------------------------------------------------------------
label "size:S"         "EDEDED" "≤ 2 h"
label "size:M"         "EDEDED" "2 à 4 h"
label "size:L"         "EDEDED" "4 à 8 h — au-delà, découper"

# --- sprint ------------------------------------------------------------------
label "sprint:S1"      "006B75" "17/08 → 23/08 — MVP mobile"
label "sprint:S2"      "006B75" "Web SEO + KYC"
label "sprint:S3+"     "006B75" "Monétisation, vocal/RAG, durcissement"

# --- transverses / signaux ---------------------------------------------------
label "contrat-api"    "FF6B00" "⚠️ Modifie contracts/openapi.json — prévenir l'autre dev AVANT le merge"
label "binome"         "FF6B00" "À faire à deux : l'erreur y coûte trop cher pour être relue après coup"
label "securite"       "B60205" "Données personnelles, INPDP, secrets, anti-fraude"
label "rtl-ar"         "FBCA04" "Nécessite une vérification du rendu en arabe / RTL"
label "gate"           "5319E7" "Porte de sprint — bloquante"
label "blocked"        "000000" "Bloqué : voir le commentaire épinglé"
label "needs-decision" "D876E3" "Attend un arbitrage du lead — ne pas coder"
label "first-dart"     "0E8A16" "Bon point d'entrée pour découvrir Flutter/Dart"

# --- nettoyage des labels GitHub par défaut, inutiles ici --------------------
for l in "bug" "documentation" "duplicate" "enhancement" "good first issue" \
         "help wanted" "invalid" "question" "wontfix"; do
  if [[ "$DRY_RUN" == "1" ]]; then
    printf '  [dry-run] delete label %s\n' "$l"
  else
    gh label delete "$l" --repo "$REPO" --yes >/dev/null 2>&1 && ok "supprimé : $l" || true
  fi
done

# =============================================================================
# 2. MILESTONES
# =============================================================================
# Un milestone = un incrément livrable et démontrable, pas une couche technique.
# Les dates sont des engagements de démo, pas des vœux.
# -----------------------------------------------------------------------------
say "Milestones"

milestone() { # titre, date (YYYY-MM-DD), description
  local title="$1" due="$2" desc="$3"
  if [[ "$DRY_RUN" == "1" ]]; then printf '  [dry-run] milestone %s (%s)\n' "$title" "$due"; return; fi
  local num
  num=$(gh api "repos/$REPO/milestones?state=all&per_page=100" \
        --jq ".[] | select(.title==\"$title\") | .number" 2>/dev/null | head -1)
  if [[ -n "$num" ]]; then
    gh api -X PATCH "repos/$REPO/milestones/$num" \
      -f due_on="${due}T18:00:00Z" -f description="$desc" >/dev/null
    ok "$title (mis à jour)"
  else
    gh api -X POST "repos/$REPO/milestones" \
      -f title="$title" -f due_on="${due}T18:00:00Z" -f description="$desc" >/dev/null
    ok "$title (créé)"
  fi
}

milestone "M0 — Socle & Contrat" "2026-08-17" \
  "J1. Monorepo, CI verte, PostgreSQL+Redis, Fastify qui répond, générateurs de tokens et i18n. Démo : GET /v1/health répond et la CI passe sur une PR blanche."

milestone "M1 — Backend Core API" "2026-08-20" \
  "J2 → J4 matin. Auth OTP, référentiel géo, ranking, recherche, fiche artisan, ContactEvent, avis, contrat OpenAPI publié. Démo : GATE 1 — les 8 appels curl du parcours cœur passent."

milestone "M2 — App Mobile MVP" "2026-08-23" \
  "J4 pm → J7. Flutter : auth, recherche, fiche, contact tracé, avis, FR/AR + RTL. Démo : GATE 2 — APK signé installé sur un Android réel, parcours complet en 3G bridé."

milestone "M3 — Web SEO & Acquisition" "2026-08-30" \
  "S2. apps/web Next.js : pages /[gouvernorat]/[service] en SSG/ISR, JSON-LD LocalBusiness, sitemap, Lighthouse ≥ 90. C'est ce qui remplace les groupes Facebook dans Google."

milestone "M4 — Confiance & Back-office" "2026-09-06" \
  "S3. KYC complet (bucket privé chiffré, URL signées, purge, journal d'accès), file de vérification, modération, signalements, apps/admin."

milestone "M5 — Monétisation" "2026-09-13" \
  "S4. Plans, abonnements, crédits, boosts, première passerelle de paiement. Bloqué tant que l'ADR-004 (moyens de paiement) n'est pas tranché."

milestone "M6 — Différenciation & Lancement" "2026-09-27" \
  "S5-S6. Recherche vocale en derja + RAG, notifications push, worker BullMQ, E2E Maestro, observabilité, déclaration INPDP. Jalon bloquant : INPDP avant toute mise en production."

# =============================================================================
# 3. PROJECT (Kanban)
# =============================================================================
say "Project"

OWNER="${REPO%%/*}"

# Le Project est un CONFORT, pas un prérequis : les issues, milestones et labels
# valent bien plus. `gh project` exige le scope `project`, que `gh auth login`
# n'accorde pas par défaut — on ne bloque donc jamais la suite là-dessus.
project_setup() {
  local num
  num=$(gh project list --owner "$OWNER" --format json \
        --jq ".projects[] | select(.title==\"$PROJECT_TITLE\") | .number" 2>/dev/null | head -1) || return 1
  if [[ -z "${num:-}" ]]; then
    num=$(gh project create --owner "$OWNER" --title "$PROJECT_TITLE" --format json --jq '.number') || return 1
    [[ "$num" =~ ^[0-9]+$ ]] || return 1
    ok "Project #$num créé"
  else
    ok "Project #$num déjà présent"
  fi
  mkdir -p "$(dirname "${BASH_SOURCE[0]}")/../../.github" 2>/dev/null || true
  echo "$num" > .github/.project-number 2>/dev/null \
    && ok "numéro écrit dans .github/.project-number" || true
  return 0
}

if [[ "$DRY_RUN" == "1" ]]; then
  printf '  [dry-run] project "%s" pour %s\n' "$PROJECT_TITLE" "$OWNER"
elif project_setup; then
  :
else
  printf '\033[0;33m  ! Project non créé — ce n%s est PAS bloquant.\033[0m\n' "'"
  cat <<'PMSG'
    Cause quasi certaine : le jeton gh n'a pas le scope `project`
    (gh auth login ne l'accorde pas par défaut).

    Pour l'ajouter :
        gh auth refresh -s project,read:org

    Puis relance setup-github.sh — le Project sera créé et les issues
    y seront rattachées. En attendant, labels, milestones et issues
    fonctionnent parfaitement sans lui.
PMSG
fi

cat <<'EOF'

  ⚠️ Les colonnes et champs personnalisés d'un Project v2 ne sont pas
     entièrement scriptables via gh CLI. À finir à la main, une fois :

     Colonnes (champ « Status ») :
       Backlog → Ready → In progress → In review → Blocked → Done

     Champs personnalisés à ajouter :
       • Dev          (single select) : Oussama · Chayma · binôme
       • Estimation   (number)        : en heures
       • Gate         (single select) : GATE 1 · GATE 2
       • Sprint       (iteration)     : 1 semaine, démarrage lundi

     Vues à créer :
       • « Sprint courant » — filtre label:sprint:S1, groupé par Status
       • « Par dev »        — groupé par Dev, filtre -status:Done
       • « Chemin critique »— filtre label:binome,label:contrat-api
       • « Bloqués »        — filtre label:blocked,label:needs-decision

     Règles d'automatisation (onglet Workflows du Project) :
       • Item ajouté             → Status = Backlog
       • PR liée ouverte         → Status = In review
       • Issue fermée            → Status = Done
EOF

say "Terminé. Étape suivante : ./tooling/scripts/gh-seed-issues.sh"
