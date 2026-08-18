#!/usr/bin/env bash
# Réinitialise l'environnement Docker de développement (Postgres + Redis) : supprime les volumes
# nommés puis relance jusqu'à ce que les deux services soient healthy, applique les migrations
# et charge le référentiel (BE-01, BE-03).
#
# TODO(BE-04): chaîner le seed de démo (30 artisans du Sahel) une fois dev-fixtures.ts écrit.
set -euo pipefail

cd "$(dirname "$0")/../.." # -> Code/

COMPOSE=(docker compose -f tooling/docker/docker-compose.dev.yml --env-file ../.env)

echo "→ Suppression des volumes existants..."
"${COMPOSE[@]}" down -v

echo "→ Redémarrage propre (attente des healthchecks)..."
"${COMPOSE[@]}" up -d --wait

echo "→ Application des migrations..."
pnpm --filter @repo/db migrate:deploy

echo "→ Chargement du référentiel (géographie, catégories, plan, poids de ranking)..."
pnpm db:seed

echo "✓ Base de données réinitialisée, migrée et seedée."
