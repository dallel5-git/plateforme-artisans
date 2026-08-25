# DOING — en cours

> ⚠️ **Maximum 2 tâches par développeur.** Si vous en avez 3, vous n'en finissez aucune.
> Mise à jour obligatoire **en fin de chaque journée**.

_Sprint S1 · dernière mise à jour : 2026-08-25_

## DEV-1

| ID | Tâche | Démarré le | Branche | État / blocage |
|---|---|---|---|---|
| `FM-03` | i18n `slang` FR/AR, `Directionality` global, miroir des icônes (#54) | 2026-08-25 | `feat/FM-03a-slang-pipeline` (mergée #154) → `feat/FM-03b-locale-persistence` (mergée #156) → `feat/FM-03c-directional-icons` (mergée #159) → `feat/FM-03d-date-currency-format` | Décomposée en 4 PRs atomiques, chacune branchée depuis `develop` à jour et ciblée sur `develop` directement. `FM-03a`, `FM-03b`, `FM-03c` mergées. `FM-03d` : `lib/core/i18n/format.dart` — `formatCurrency`/`formatDate`, miroir Dart de `packages/i18n/src/format.ts`, via `package:intl` (ajouté en `dependencies` directe). Montant en millimes (jamais un float, CLAUDE.md §4.1) converti en dinars au seul point d'affichage. Chiffres occidentaux en arabe : déjà le comportement par défaut d'`intl` pour `ar` (`ZERO_DIGIT: '0'` dans ses données CLDR, vérifié à l'exécution) — aucun forçage nécessaire, contrairement à ce que redoutait le plan initial. Fuseau Africa/Tunis appliqué par décalage fixe UTC+1 (pas de DST en Tunisie depuis 2009, pas besoin du package `timezone`). `initializeDateFormatting('fr'/'ar')` câblé une fois au bootstrap (`main()`), sans quoi `DateFormat` lève une exception. 7 tests unitaires (`test/core/i18n/format_test.dart`). Pure infra sans écran consommateur avant FM-05+ (même situation que FM-01c avant FM-01d) — **pas de vérification visuelle device nécessaire**, aucun rendu ne change. |

## DEV-2

| ID | Tâche | Démarré le | Branche | État / blocage |
|---|---|---|---|---|

*(QA-01 — 5/5 PRs mergées #138/#140/#139/#141–#143 — déplacée vers `DONE.md`. BE-18 et BE-24 : bookkeeping de retard déjà corrigé précédemment.)*

> _Note process — workflow QA-01, gardée pour mémoire_ : Oussama a mergé #138/#139/#141 en quelques minutes chacune — GitHub supprime la branche tête au merge, ce qui casse l'empilement de PRs prévu au départ (`…a` → `…b` → …). À partir de QA-01c, chaque sous-tâche a branché depuis `develop` à jour et ciblé `develop` directement. Aussi : la 1ʳᵉ tentative de PR #141 a été squash-mergée, ce qui a fait perdre un commit de bookkeeping poussé après coup — les mises à jour de backlog doivent être incluses **dans le même commit** que le travail, pas en suivi séparé.
>
> **BE-27 a subi la même classe de bug, en pire** (voir ci-dessous) : #135 empilée sur #134 (au lieu de cibler `develop`) a fini par ne jamais atteindre `develop` du tout, alors que les deux PRs s'affichent « MERGED » sur GitHub. Confirme qu'il faut bannir l'empilement de PRs sur ce repo, pas seulement le limiter.

## En binôme

| ID | Tâche | Démarré le | Branche | État / blocage |
|---|---|---|---|---|
| `BE-26c` | Prérequis `FM-02` : `tags` OpenAPI (`auth`, `contact-events`) + `contactEventResponseSchema`/`authTokensSchema` enregistrés dans `z.globalRegistry` (même mécanisme que `categoryTreeNodeSchema`) — sans ça le client Dart généré n'a qu'un `DefaultApi` fourre-tout et des modèles anonymes (`V1AuthRefreshPost200Response`…), alors que `contact_flow_test.dart` (groupe FM-02) exige `ContactEventsApi`/`ContactEventResponse` par leur nom | 2026-08-25 | `feat/BE-26c-openapi-tags-schemas-v2` (remplace PR #153, fermée) | Claude, en préparation de `FM-02` avec Oussama (DEV-2). PR #153 (même contenu, ouverte par Chayma/DEV-1) bloquée en CI sur `contrat → client Dart (mobile:client)` : le client Dart committé ne correspondait pas à une régénération fraîche du contrat, alors que le diff écrit à la main (routes, schémas, fix Windows) était sain — reproduit à l'identique en local avec le même toolchain pinné (`openapi-generator-cli` 2.40.1 / générateur 7.14.0), donc pas une nondéterminisme du générateur mais un écart d'environnement au moment où le client avait été committé. Repris depuis `develop` à jour, mêmes changements métier, `pnpm api:contract` + `mobile:client` + `web:client` régénérés proprement dans un environnement où `mobile:client:check` est vérifié stable (deux régénérations consécutives identiques). `typecheck`/`lint` verts. **Non vérifié : `pnpm test` côté `apps/api`** — dépend de `@repo/db#test` (Postgres local), indisponible dans cet environnement (même contrainte que BE-27/GATE 1 avant sa résolution). |

*(`BE-27` — GATE 1 exécutée avec succès le 2026-08-24, les 8 appels + vérifications bonus passent :
voir `DONE.md`. Deux bugs trouvés et corrigés dans le script de recette lui-même au passage —
`tooling/scripts/gate1-recette.sh` lisait `.ratingCount` au lieu de `.reviewAggregate.count`
(mauvais chemin jq, donnait toujours `null`/0) et un crash bash sur comparaison arithmétique avec
`null` non protégée. **Le backend (BE-22, agrégat de notes) était correct** — confirmé par
`apps/api/tests/providers-reviews-create.integration.test.ts`, déjà vert. Lot Flutter débloqué.)*

---

## 🔴 Bloqués

| ID | Bloqué par | Depuis | Qui débloque | Action attendue |
|---|---|---|---|---|
| `BE-33` | Question 2 du cadrage non tranchée (moyens de paiement) | 2026-08-15 | Oussama | Rédiger ADR-003 avant S2 |
| `BE-38` | Question 3 du cadrage non tranchée (annuaire ou marketplace) | 2026-08-15 | Oussama | Rédiger un ADR avant S2 — **numéro à revoir : ADR-004 est pris par le git flow `develop`/`main` (2026-08-19), utiliser ADR-005** |

> Une tâche bloquée depuis **plus de 24 h** remonte automatiquement dans `#a_vue_générale` au daily.
