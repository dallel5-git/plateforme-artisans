#!/usr/bin/env bash
# Réinitialise l'environnement Docker de développement (Postgres + Redis) : supprime les volumes
# nommés puis relance jusqu'à ce que les deux services soient healthy.
#
# TODO(BE-01): chaîner `prisma migrate reset` une fois le schéma Prisma disponible.
# TODO(BE-03, BE-04): chaîner le seed (référentiel géo + démo) une fois les scripts disponibles.
set -euo pipefail

cd "$(dirname "$0")/../.." # -> Code/

COMPOSE=(docker compose -f tooling/docker/docker-compose.dev.yml --env-file ../.env)

echo "→ Suppression des volumes existants..."
"${COMPOSE[@]}" down -v

echo "→ Redémarrage propre (attente des healthchecks)..."
"${COMPOSE[@]}" up -d --wait

echo "✓ Base de données réinitialisée (Postgres + Redis prêts)."
