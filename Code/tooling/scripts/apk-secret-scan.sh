#!/usr/bin/env bash
# =============================================================================
# Sanaya — vérification d'un APK release avant remise aux beta-testeurs (FM-14c)
#
# Transforme en contrôle automatique deux critères d'acceptation de l'issue
# FM-14 (#42) :
#   - "Aucun secret n'est présent dans l'APK (vérifié par `strings`)"
#   - implicitement : l'APK n'est pas signé avec la clé de debug (le mode de
#     défaillance que FM-14b élimine côté Gradle — ce script le RE-vérifie côté
#     artefact final, indépendamment de la configuration qui l'a produit).
#
# Usage :
#   tooling/scripts/apk-secret-scan.sh <chemin-vers-app-release.apk>
#   tooling/scripts/apk-secret-scan.sh --self-test
#
# --self-test ne prend aucun APK : il vérifie que la détection de motifs elle-
# même fonctionne (fixture "sale" → doit échouer, fixture "propre" → doit
# passer). Précédent du dépôt (tooling/scripts/gate1-recette.sh) : un script de
# recette non testé a caché deux bugs pendant plusieurs jours — un script qui
# donne un feu vert imaginaire est pire que pas de script.
#
# Variables d'environnement optionnelles (scan d'un vrai APK) :
#   MOBILE_APK_CERT_SHA256            empreinte SHA-256 attendue du certificat
#                                      de signature (Code/docs/05-runbook.md
#                                      §1.5). Absente → le contrôle de
#                                      signature est sauté avec un avertissement
#                                      (utile en local avec un keystore jetable).
#   SANAYA_ANDROID_KEYSTORE_PASSWORD  si définie, recherchée aussi littéralement
#                                      dans l'APK (défense en profondeur — ne
#                                      devrait jamais être définie en CI au
#                                      moment de ce scan, l'étape de build l'a
#                                      déjà consommée et n'écrit rien sur disque
#                                      hors $RUNNER_TEMP).
#   ANDROID_HOME / ANDROID_SDK_ROOT   pour localiser aapt2/apksigner
#                                      (build-tools). Sans eux, les contrôles de
#                                      permission et de signature sont sautés
#                                      avec un avertissement en local ; en CI
#                                      (runner Ubuntu GitHub-hosted), le SDK est
#                                      préinstallé et ces contrôles sont donc
#                                      actifs par défaut.
#
# Prérequis pour le scan d'un vrai APK : unzip, strings (repli grep -a sinon).
# =============================================================================
set -euo pipefail

say()  { printf '\n\033[1;34m▸ %s\033[0m\n' "$*"; }
ok()   { printf '  \033[0;32m✓\033[0m %s\n' "$*"; }
warn() { printf '  \033[0;33m⚠\033[0m %s\n' "$*"; }
err()  { printf '  \033[0;31m✗\033[0m %s\n' "$*"; }

# --- Motifs de secrets : jamais dans un artefact distribué -------------------
SECRET_PATTERNS=(
  '-----BEGIN [A-Z ]*PRIVATE KEY-----'
  'eyJhbGciOi'                          # en-tête JWT base64 (alg/typ)
  'postgresql://[^ ]*:[^ ]*@'
  'redis://[^ ]*:[^ ]*@'
  'sanaya_dev_password'
  'AKIA[0-9A-Z]{16}'                    # clé d'accès AWS/R2
  'sk_live_'
)

# Extrait le texte imprimable d'un fichier, binaire ou non — `strings` s'il est
# disponible, repli `grep -a` sinon (ex. Git Bash sur Windows sans binutils).
extract_text() {
  if command -v strings >/dev/null 2>&1; then
    strings -a "$1" 2>/dev/null || true
  else
    grep -a . "$1" 2>/dev/null || true
  fi
}

# Retourne (par écriture sur stdout) la liste des motifs trouvés dans un
# fichier. Ne fait AUCUNE hypothèse sur le code de sortie de grep (pas de
# match = code 1, normal, ne doit pas interrompre le script sous `set -e`).
find_secret_matches() {
  local target="$1" text pattern
  text="$(extract_text "$target")"
  for pattern in "${SECRET_PATTERNS[@]}"; do
    # `--` est indispensable : le motif "-----BEGIN...PRIVATE KEY-----" commence
    # par un tiret, que grep interpréterait sinon comme une option inconnue —
    # échec silencieux (grep quitte en erreur, `if` le traite comme "pas de
    # match") plutôt qu'une vraie absence de motif. Découvert par le self-test
    # lui-même en écrivant ce script — précisément le genre de bug que
    # gate1-recette.sh avait laissé passer faute de test.
    if grep -qE -- "$pattern" <<<"$text"; then
      printf '%s\n' "$pattern"
    fi
  done
  if [[ -n "${SANAYA_ANDROID_KEYSTORE_PASSWORD:-}" ]] && grep -qF -- "$SANAYA_ANDROID_KEYSTORE_PASSWORD" <<<"$text"; then
    printf '%s\n' "(mot de passe du keystore, en clair)"
  fi
}

# --- Mode --self-test : prouve que la détection elle-même fonctionne --------
self_test() {
  say "Self-test — la détection doit échouer sur une fixture sale et passer sur une propre"
  local tmp dirty clean matches
  tmp="$(mktemp -d)"
  trap 'rm -rf "$tmp"' RETURN

  dirty="$tmp/dirty.txt"
  clean="$tmp/clean.txt"

  cat >"$dirty" <<'FIXTURE'
some binary-ish noise before the payload
-----BEGIN RSA PRIVATE KEY-----
MIIEow...fixture-only-not-a-real-key...
-----END RSA PRIVATE KEY-----
DATABASE_URL=postgresql://sanaya:s3cret@db.internal:5432/sanaya
a jwt looking string: eyJhbGciOiJIUzI1NiJ9.fake.fake
FIXTURE

  cat >"$clean" <<'FIXTURE'
Sanaya - mise en relation particuliers/artisans
tn.sanaya.sanaya
API_BASE_URL configured at build time via --dart-define, not a secret
FIXTURE

  matches="$(find_secret_matches "$dirty")"
  local match_count
  match_count="$(grep -c . <<<"$matches" || true)"
  # Exactement 3, pas juste ">0" : la fixture embarque une clé privée, une URL
  # Postgres et un JWT — un compte partiel (ex. 2/3) doit faire échouer le
  # self-test, pas passer silencieusement. C'est la classe de bug trouvée en
  # écrivant ce script (le motif "-----BEGIN..." mal échappé pour grep).
  if [[ "$match_count" -ne 3 ]]; then
    err "fixture SALE : $match_count motif(s) détecté(s), 3 attendus — le self-test échoue"
    [[ -n "$matches" ]] && printf '%s\n' "$matches"
    return 1
  fi
  ok "fixture sale détectée comme attendu (3/3 motifs)"

  matches="$(find_secret_matches "$clean")"
  if [[ -n "$matches" ]]; then
    err "fixture PROPRE signalée à tort : $matches"
    return 1
  fi
  ok "fixture propre passe comme attendu"

  say "Self-test réussi — la fonction de détection est fiable"
  return 0
}

# --- Mode scan réel ----------------------------------------------------------
find_build_tool() {
  local name="$1" sdk_root hit
  sdk_root="${ANDROID_HOME:-${ANDROID_SDK_ROOT:-}}"
  [[ -n "$sdk_root" && -d "$sdk_root/build-tools" ]] || return 1
  hit="$(find "$sdk_root/build-tools" -maxdepth 2 -type f \( -name "$name" -o -name "$name.bat" -o -name "$name.exe" \) 2>/dev/null | sort -V | tail -1)"
  [[ -n "$hit" ]] || return 1
  printf '%s\n' "$hit"
}

scan_apk() {
  local apk="$1" issues=0
  [[ -f "$apk" ]] || { err "fichier introuvable : $apk"; exit 1; }
  command -v unzip >/dev/null 2>&1 || { err "unzip requis pour scanner un APK"; exit 1; }

  say "1/4 — Aucun fichier de secret embarqué (unzip -l)"
  local forbidden_entries
  forbidden_entries="$(unzip -l "$apk" | grep -iE '\.(jks|keystore|p12|pem|key)$|\.env(\.|$)' || true)"
  if [[ -n "$forbidden_entries" ]]; then
    err "entrées suspectes dans l'archive :"
    printf '%s\n' "$forbidden_entries"
    issues=$((issues + 1))
  else
    ok "aucune entrée .jks/.keystore/.p12/.pem/.key/.env dans l'archive"
  fi

  say "2/4 — Aucun motif de secret dans le contenu (dex, .so, assets)"
  local tmp entries entry matches any_match=0
  tmp="$(mktemp -d)"
  entries="$(unzip -l "$apk" | grep -E '\.dex$|\.so$' | awk '{print $NF}' || true)"
  # + tout ce qui est sous assets/ (dart-defines finissent dans le snapshot AOT,
  # pas dans un fichier texte séparé, mais un asset embarqué à la main pourrait
  # en contenir).
  entries+=$'\n'"$(unzip -l "$apk" | grep -E ' assets/' | awk '{print $NF}' || true)"
  while IFS= read -r entry; do
    [[ -n "$entry" ]] || continue
    unzip -p "$apk" "$entry" >"$tmp/current" 2>/dev/null || continue
    matches="$(find_secret_matches "$tmp/current")"
    if [[ -n "$matches" ]]; then
      err "motif(s) suspect(s) dans $entry :"
      printf '  - %s\n' $matches
      any_match=1
    fi
  done <<<"$entries"
  rm -rf "$tmp"
  if [[ "$any_match" -eq 1 ]]; then
    issues=$((issues + 1))
  else
    ok "aucun motif de secret trouvé dans dex/so/assets"
  fi

  say "3/4 — Permissions et debuggable (aapt2)"
  local aapt2
  if aapt2="$(find_build_tool aapt2)"; then
    local badging
    badging="$("$aapt2" dump badging "$apk" 2>/dev/null || true)"
    if grep -q 'uses-permission: name=.android.permission.INTERNET' <<<"$badging"; then
      ok "permission INTERNET présente"
    else
      err "permission INTERNET absente — l'APK n'aura aucun accès réseau (voir FM-14b)"
      issues=$((issues + 1))
    fi
    if grep -q "application-debuggable" <<<"$badging"; then
      err "l'APK est marqué debuggable — ne doit jamais être le cas pour un build release"
      issues=$((issues + 1))
    else
      ok "l'APK n'est pas debuggable"
    fi
  else
    warn "aapt2 introuvable (ANDROID_HOME/ANDROID_SDK_ROOT non configuré) — contrôle sauté"
  fi

  say "4/4 — Signature (apksigner) — confirme que ce n'est PAS la clé de debug"
  local apksigner
  if apksigner="$(find_build_tool apksigner)"; then
    local certs sha256
    certs="$("$apksigner" verify --print-certs "$apk" 2>&1 || true)"
    # `:?` rend le séparateur optionnel : les versions récentes de build-tools
    # impriment l'empreinte en hex continu ("SHA-256 digest: 847b49e5..."),
    # les plus anciennes avec des ":" ("84:7b:49:...") — les deux formats
    # observés en pratique sur ce poste (build-tools 36.0.0 vs 37.0.0). Sans
    # le `|| true` final, un APK dont la sortie ne matche aucun des deux (donc
    # `grep` sans résultat, code de sortie 1) tue silencieusement tout le
    # script sous `set -e`/`pipefail` — trouvé en testant sur un vrai APK,
    # pas seulement les fixtures synthétiques du --self-test (même classe de
    # bug que le motif "-----BEGIN..." documenté plus haut).
    sha256="$(grep -oE '[0-9A-Fa-f]{2}(:?[0-9A-Fa-f]{2}){31}' <<<"$certs" | head -1 | tr -d ':' | tr 'A-F' 'a-f' || true)"
    if [[ -z "$sha256" ]]; then
      err "apksigner n'a pas pu vérifier la signature de l'APK :"
      printf '%s\n' "$certs"
      issues=$((issues + 1))
    elif [[ -n "${MOBILE_APK_CERT_SHA256:-}" ]]; then
      local expected
      expected="$(tr -d ':' <<<"${MOBILE_APK_CERT_SHA256}" | tr 'A-F' 'a-f')"
      if [[ "$sha256" == "$expected" ]]; then
        ok "empreinte du certificat conforme à MOBILE_APK_CERT_SHA256"
      else
        err "empreinte du certificat inattendue — probable signature debug ou mauvaise clé"
        err "  attendue : $expected"
        err "  obtenue  : $sha256"
        issues=$((issues + 1))
      fi
    else
      warn "MOBILE_APK_CERT_SHA256 non définie — empreinte obtenue mais non comparée : $sha256"
    fi
  else
    warn "apksigner introuvable (ANDROID_HOME/ANDROID_SDK_ROOT non configuré) — contrôle sauté"
  fi

  if [[ "$issues" -gt 0 ]]; then
    say "ÉCHEC — $issues contrôle(s) en échec, voir le détail ci-dessus"
    exit 1
  fi
  say "OK — tous les contrôles disponibles sont verts"
}

# --- Point d'entrée -----------------------------------------------------------
case "${1:-}" in
  --self-test)
    self_test
    ;;
  "" )
    err "usage : $0 <chemin-vers-app-release.apk> | --self-test"
    exit 1
    ;;
  *)
    scan_apk "$1"
    ;;
esac
