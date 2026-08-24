#!/usr/bin/env bash
# =============================================================================
# Sanaya — GATE 1 : recette backend du parcours cœur (issue BE-27)
#
# Rejoue les 8 appels curl de PLAN-MVP-SEMAINE-1.md §6.4, dans l'ordre, sans aucune
# intervention manuelle en base : otp/request → otp/verify → categories → search →
# fiche → contact-events → reviews → me.
#
# Utilise le client de recette seedé par `seedGate1RecetteFixture`
# (packages/db/prisma/seed/dev-fixtures.ts, BE-27a) : sans lui, l'étape 7 (dépôt
# d'avis) échoue systématiquement en 403 REVIEW_REQUIRES_CONTACT — la fenêtre
# d'éligibilité US-C-06 exige un ContactEvent vieux de plus de 12h, et celui créé à
# l'étape 6 est instantané.
#
# Prérequis :
#   - API démarrée et accessible sur $API_BASE_URL (pnpm dev, ou apps/api seul)
#   - Base seedée : pnpm db:migrate && pnpm db:seed:dev
#   - jq, curl
#
# Usage :
#   tooling/scripts/gate1-recette.sh
#   API_BASE_URL=http://localhost:4000/v1 tooling/scripts/gate1-recette.sh
#
#   # Lecture automatique de l'OTP (sinon saisie manuelle demandée) :
#   pnpm --filter api start > /tmp/api.log 2>&1 &
#   API_LOG_FILE=/tmp/api.log tooling/scripts/gate1-recette.sh
# =============================================================================
set -euo pipefail

BASE_URL="${API_BASE_URL:-http://localhost:4000/v1}"
PHONE="${GATE1_CLIENT_PHONE:-+21622123456}" # doit correspondre au client seedé par BE-27a
PROVIDER_BUSINESS_NAME="${GATE1_PROVIDER_NAME:-Jlassi Plomberie}" # Karim Jlassi, cf. BE-27a
API_LOG_FILE="${API_LOG_FILE:-}"

say()  { printf '\n\033[1;34m▸ %s\033[0m\n' "$*"; }
ok()   { printf '  \033[0;32m✓\033[0m %s\n' "$*"; }
fail() { printf '  \033[0;31m✗ %s\033[0m\n' "$*"; exit 1; }

command -v jq   >/dev/null || fail "jq requis — https://jqlang.github.io/jq"
command -v curl >/dev/null || fail "curl requis"

req() {
  local method="$1" path="$2" body="${3:-}" auth="${4:-}"
  local args=(-sS -X "$method" "${BASE_URL}${path}" -H 'Content-Type: application/json')
  [[ -n "$body" ]] && args+=(-d "$body")
  [[ -n "$auth" ]] && args+=(-H "Authorization: Bearer ${auth}")
  curl "${args[@]}" -w $'\n%{http_code}'
}

# Sépare le corps JSON du code HTTP ajouté par `-w`.
split_status() { STATUS="${1##*$'\n'}"; BODY="${1%$'\n'*}"; }

expect_status() {
  local got="$1" want="$2" step="$3"
  [[ "$got" == "$want" ]] || { printf '%s\n' "$BODY"; fail "$step : attendu HTTP $want, obtenu $got"; }
}

read_otp_from_log() {
  local phone="$1" logfile="$2" tries=0 line
  while (( tries < 20 )); do
    if [[ -f "$logfile" ]]; then
      line=$(grep "\[SMS→${phone}\]" "$logfile" | tail -1 || true)
      if [[ -n "$line" ]]; then
        grep -oE '[0-9]{6}' <<<"$line" | tail -1
        return 0
      fi
    fi
    sleep 0.5
    tries=$((tries + 1))
  done
  return 1
}

# --- 1. POST /auth/otp/request --------------------------------------------------------------
say "1/8 POST /auth/otp/request"
RESP=$(req POST /auth/otp/request "{\"phone\":\"$PHONE\"}")
split_status "$RESP"
expect_status "$STATUS" 200 "otp/request"
ok "200 — OTP émis (ConsoleSmsProvider : ligne [SMS→$PHONE] ... dans les logs API, dev uniquement)"

if [[ -n "$API_LOG_FILE" ]]; then
  OTP_CODE=$(read_otp_from_log "$PHONE" "$API_LOG_FILE") || fail "OTP introuvable dans $API_LOG_FILE après 10 s"
  ok "OTP lu automatiquement dans $API_LOG_FILE"
else
  printf '  Code OTP (voir stdout de l’API) : '
  read -r OTP_CODE
fi
[[ "$OTP_CODE" =~ ^[0-9]{6}$ ]] || fail "code OTP invalide : \"$OTP_CODE\""

# --- 2. POST /auth/otp/verify -----------------------------------------------------------------
say "2/8 POST /auth/otp/verify"
RESP=$(req POST /auth/otp/verify "{\"phone\":\"$PHONE\",\"code\":\"$OTP_CODE\"}")
split_status "$RESP"
expect_status "$STATUS" 200 "otp/verify"
ACCESS_TOKEN=$(jq -r '.accessToken' <<<"$BODY")
[[ -n "$ACCESS_TOKEN" && "$ACCESS_TOKEN" != "null" ]] || fail "accessToken manquant dans la réponse"
jq -e '.refreshToken | length > 0' <<<"$BODY" >/dev/null || fail "refreshToken manquant dans la réponse"
ok "200 — access + refresh reçus"

# --- 3. GET /categories -------------------------------------------------------------------------
say "3/8 GET /categories"
RESP=$(req GET /categories)
split_status "$RESP"
expect_status "$STATUS" 200 "categories"
jq -e '.categories[0] | has("nameFr") and has("nameAr")' <<<"$BODY" | grep -q true \
  || fail "arbre de catégories FR/AR incomplet"
ok "200 — arbre FR/AR reçu ($(jq '.categories | length' <<<"$BODY") catégories racine)"

# --- 4. GET /providers/search --------------------------------------------------------------------
say "4/8 GET /providers/search?category=plomberie&governorate=sousse"
RESP=$(req GET "/providers/search?category=plomberie&governorate=sousse")
split_status "$RESP"
expect_status "$STATUS" 200 "providers/search"
COUNT=$(jq '.items | length' <<<"$BODY")
(( COUNT >= 5 )) || fail "attendu ≥5 items, obtenu $COUNT"
jq -e 'has("nextCursor")' <<<"$BODY" >/dev/null || fail "nextCursor absent de la réponse"
SLUG=$(jq -r --arg name "$PROVIDER_BUSINESS_NAME" '.items[] | select(.businessName == $name) | .slug' <<<"$BODY")
[[ -n "$SLUG" ]] || fail "artisan de recette (\"$PROVIDER_BUSINESS_NAME\") absent des résultats de recherche"
ok "200 — $COUNT items, nextCursor présent, slug de recette : $SLUG"

# --- 5. GET /providers/:slug ----------------------------------------------------------------------
say "5/8 GET /providers/$SLUG"
RESP=$(req GET "/providers/$SLUG")
split_status "$RESP"
expect_status "$STATUS" 200 "providers/:slug"
if jq -e 'has("phone") or has("publicPhone") or has("whatsappPhone")' <<<"$BODY" | grep -q true; then
  fail "un champ téléphone est présent dans la fiche publique (P8)"
fi
PROVIDER_ID=$(jq -r '.id' <<<"$BODY")
RATING_COUNT_BEFORE=$(jq -r '.reviewAggregate.count // 0' <<<"$BODY")
ok "200 — fiche reçue, aucun champ téléphone, id=$PROVIDER_ID, ratingCount=$RATING_COUNT_BEFORE"

# --- 6. POST /contact-events ------------------------------------------------------------------
say "6/8 POST /contact-events"
RESP=$(req POST /contact-events "{\"providerId\":\"$PROVIDER_ID\",\"channel\":\"PHONE\"}" "$ACCESS_TOKEN")
split_status "$RESP"
expect_status "$STATUS" 200 "contact-events"
REVEALED_PHONE=$(jq -r '.phone' <<<"$BODY")
[[ -n "$REVEALED_PHONE" && "$REVEALED_PHONE" != "null" ]] || fail "téléphone non révélé dans la réponse"
ok "200 — téléphone révélé dans la réponse HTTP (jamais affiché ici, jamais loggé — P8)"

# --- 7. POST /providers/:id/reviews -------------------------------------------------------------
say "7/8 POST /providers/$PROVIDER_ID/reviews"
RESP=$(req POST "/providers/$PROVIDER_ID/reviews" \
  '{"rating":5,"comment":"Recette GATE 1 automatisée (BE-27)."}' "$ACCESS_TOKEN")
split_status "$RESP"
expect_status "$STATUS" 200 "providers/:id/reviews"
jq -e '.id and .rating == 5' <<<"$BODY" >/dev/null || fail "réponse d'avis inattendue"
ok "200 — avis créé"

# Vérification bonus (hors des 8 appels du parcours) : l'agrégat a bien été recalculé.
RECHECK=$(req GET "/providers/$SLUG")
split_status "$RECHECK"
RATING_COUNT_AFTER=$(jq -r '.reviewAggregate.count // 0' <<<"$BODY")
(( RATING_COUNT_AFTER == RATING_COUNT_BEFORE + 1 )) \
  || fail "ratingAvg/ratingCount non recalculé (avant=$RATING_COUNT_BEFORE, après=$RATING_COUNT_AFTER)"
ok "vérifié — ratingCount recalculé ($RATING_COUNT_BEFORE → $RATING_COUNT_AFTER)"

# --- 8. GET /auth/me -------------------------------------------------------------------------------
say "8/8 GET /auth/me"
RESP=$(req GET /auth/me "" "$ACCESS_TOKEN")
split_status "$RESP"
expect_status "$STATUS" 200 "auth/me"
jq -e '.roles | length > 0' <<<"$BODY" >/dev/null || fail "rôles absents de la réponse"
ok "200 — profil + rôles reçus"

# --- Logs : aucune donnée sensible --------------------------------------------------------------
say "Vérification : aucune donnée sensible dans les logs API"
if [[ -n "$API_LOG_FILE" ]]; then
  # La ligne [SMS→...] du ConsoleSmsProvider (dev uniquement) contient volontairement le
  # téléphone et l'OTP — c'est le critère d'acceptation #1, pas une fuite. On l'exclut avant
  # de chercher un numéro +216, un JWT/refresh token, ou un OTP à 6 chiffres ailleurs.
  # Heuristique : à relire à l'œil en cas de détection, tous les nombres à 6 chiffres ne sont
  # pas des OTP.
  LEAKS=$(grep -vE '^\[SMS→' "$API_LOG_FILE" \
    | grep -oE '\+216[0-9]{8}|"accessToken":"[^"]+"|"refreshToken":"[^"]+"|\b[0-9]{6}\b' \
    || true)
  if [[ -n "$LEAKS" ]]; then
    printf '%s\n' "$LEAKS"
    fail "donnée potentiellement sensible trouvée dans $API_LOG_FILE (hors ligne [SMS→...]) — à relire"
  fi
  ok "aucune fuite détectée dans $API_LOG_FILE (hors ligne [SMS→...] de dev)"
else
  printf '  API_LOG_FILE non fourni : vérifier manuellement la sortie de l’API pendant cette\n'
  printf '  exécution — aucun numéro +216, aucun token, aucun OTP en dehors de la ligne\n'
  printf '  [SMS→...] du ConsoleSmsProvider.\n'
fi

say "GATE 1 : les 8 appels du parcours cœur sont passés."
