#!/usr/bin/env bash
# Réinitialise l'environnement Docker de développement (Postgres + Redis) : supprime les volumes
# nommés puis relance jusqu'à ce que les deux services soient healthy, applique les migrations
# et charge le référentiel + les 30 artisans de démonstration (BE-01, BE-03, BE-04).
#
# Ce script est explicitement local/dev — `db:seed:dev` charge des données FICTIVES et ne doit
# jamais être pointé vers une base partagée (staging/prod utilisent `db:seed`, référentiel seul).
set -euo pipefail

cd "$(dirname "$0")/../.." # -> Code/

COMPOSE=(docker compose -f tooling/docker/docker-compose.dev.yml --env-file ../.env)

echo "→ Suppression des volumes existants..."
"${COMPOSE[@]}" down -v

echo "→ Redémarrage propre (attente des healthchecks)..."
"${COMPOSE[@]}" up -d --wait

echo "→ Application des migrations..."
pnpm --filter @repo/db migrate:deploy

echo "→ Chargement du référentiel + des artisans de démonstration..."
pnpm db:seed:dev

echo "✓ Base de données réinitialisée, migrée et seedée (référentiel + démo)."
