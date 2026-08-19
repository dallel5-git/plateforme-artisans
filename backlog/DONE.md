# DONE — terminé

> Une tâche n'arrive ici que si **toute** la *Definition of Done* est remplie
> (`Code/docs/POLITIQUE-PROJET.md` §5). Pas de « fini à 90 % ».

## Sprint S0 — Cadrage (avant le 2026-08-15)

| ID | Tâche | Qui | PR | Terminé le |
|---|---|---|---|---|
| `DOC-00` | Document de cadrage technique v1.0 (user stories, schéma Prisma complet, index SQL, arborescence) | Oussama | — | 2026-08-12 |
| `DOC-00b` | Étude de marché & stratégie (concurrence, failles, go-to-market Sahel, modèle économique) | Oussama | — | 2026-08-12 |
| `SO-00` | Squelette d'arborescence du monorepo + workflows CI (fichiers vides) | Oussama | — | 2026-08-12 |
| `DES-00` | Maquettes Sanaya — web, mobile, back-office, thèmes clair et sombre | Oussama / Claude Design | — | 2026-08-12 |
| `DOC-01` | **ADR-001** — Mobile en Flutter, contrat d'API REST/OpenAPI | Oussama / Claude | — | 2026-08-15 |
| `DOC-02` | **ADR-002** — Badge « Vérifié » gratuit, fondé sur l'identité | Oussama / Claude | — | 2026-08-15 |
| `DOC-02b` | **ADR-003** — Périmètre S1 mobile-first, `apps/web` reporté en S2 | Oussama / Claude | — | 2026-08-15 |
| `DOC-03` | Politique de projet v1.0 | Claude | — | 2026-08-15 |
| `DOC-04` | Mémoire projet + guard-rails (`CLAUDE.md` racine et par lot) | Claude | — | 2026-08-15 |
| `DOC-05` | Plan MVP semaine 1 découpé en lots et en tâches | Claude | — | 2026-08-15 |
| `DOC-06` | Mise en place des backlogs TODO / DOING / DONE | Claude | — | 2026-08-15 |
| `SO-04a` | Design tokens extraits de la maquette (`tokens.json` → TS + Dart) | Claude | — | 2026-08-15 |

## Sprint S1 — MVP (17/08 → 23/08)

| ID | Tâche | Qui | PR | Terminé le |
|---|---|---|---|---|
| `SO-01` | Monorepo pnpm + Turborepo | Oussama | #59 | 2026-08-17 |
| `SO-02` | Docker Compose : PostgreSQL 16 + Redis 7 | Oussama | #60 | 2026-08-17 |
| `SO-03` | Bootstrap `apps/api` : Fastify 5 + Zod + OpenAPI | Oussama | #61 | 2026-08-17 |
| `SO-04` | Générateur de design tokens : `tokens.json` → TS et Dart | Chayma | #62 | 2026-08-17 |
| `SO-06` | CI GitHub Actions : lint, typecheck, test, contrat, tokens | Oussama | #65 | 2026-08-17 |
| `BE-01` | Schéma Prisma — sous-ensemble MVP (19 modèles) | Oussama | #68 | 2026-08-18 |
| `BE-06` | `phone-tn.ts` — normalisation `+216XXXXXXXX` | Claude | #73 | 2026-08-19 |
| `SO-07` | CODEOWNERS + docs git flow develop/main (ADR-004) + protection des branches | Oussama / Claude | #74 | 2026-08-19 |
| `BE-07` | OTP : génération, hachage argon2, TTL et tentatives (+ logique pure de session, portion BE-09) | Claude | #76 | 2026-08-19 |
| `BE-08` | Adaptateur SMS derrière une interface `SmsProvider` | Claude | #77 | 2026-08-19 |
| `BE-02` | Migration SQL manuelle : contraintes et index essentiels | Oussama | #69 (revue) → atterrit sur `develop` via la PR de réconciliation BE-05 | 2026-08-19 |
| `BE-03` | Seed du référentiel : gouvernorats, délégations du Sahel, catégories FR/AR | Oussama | #70 (revue) → idem | 2026-08-19 |
| `BE-04` | Seed de démonstration : 30 artisans du Sahel | Oussama | #71 (revue) → idem | 2026-08-19 |
| `BE-05` | Repositories — la seule couche qui parle à Prisma, curseur générique | Oussama | #72 (revue) → idem | 2026-08-19 |

---

## Compteur du sprint S1

| Métrique | Valeur |
|---|---|
| Tâches 🔴 P0 planifiées | 43 |
| Tâches 🔴 P0 terminées | 5 |
| Tâches 🟠 P1 terminées | 0 / 7 *(l'amortisseur : 18 h)* |
| Heures-homme 🔴 P0 estimées / consommées | 109 h / 0 h *(capacité 112 h)* |

> Mettre à jour ce compteur **au daily**. C'est le seul indicateur qui dira mercredi si le périmètre
> tient — et mercredi est le dernier jour où couper coûte encore peu.
