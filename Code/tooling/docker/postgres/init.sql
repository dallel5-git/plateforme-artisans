-- Extensions requises par le schéma Prisma (Assets/cadrage-technique-plateforme-artisans-tn.md §2.2 :
-- datasource.extensions = [pgcrypto, unaccent, pg_trgm, postgis, citext]).
--
-- L'issue SO-02 n'en liste que 3 (unaccent, pg_trgm, postgis) ; les 5 sont posées ici pour éviter
-- l'échec de migration « obscur » que l'issue elle-même veut prévenir, dès BE-01 (pas seulement BE-02).
--
-- IF NOT EXISTS : idempotent, rejouable par `pnpm db:reset` sans erreur.
CREATE EXTENSION IF NOT EXISTS unaccent;
CREATE EXTENSION IF NOT EXISTS pg_trgm;
CREATE EXTENSION IF NOT EXISTS postgis;
CREATE EXTENSION IF NOT EXISTS pgcrypto;
CREATE EXTENSION IF NOT EXISTS citext;
