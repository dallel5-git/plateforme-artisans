# ADR-006 — Aucun changement de comportement sans test, aucun bug sans test de non-régression

- **Statut** : Accepté
- **Date** : 2026-08-15
- **Décideurs** : Oussama Dallel (product / tech lead)
- **Impacte** : `.github/workflows/`, `POLITIQUE-PROJET.md` §6, `.github/pull_request_template.md`, la protection de `main` et de `develop`, toute PR à partir du sprint S1
- **Numérotation** : ADR-004 (moyens de paiement) et ADR-005 (annuaire ou place de marché) sont **réservés** aux deux questions ouvertes du cadrage. Cet ADR prend donc le numéro 006.

---

## 1. Contexte

`POLITIQUE-PROJET.md` §6 décrit déjà **quoi** tester : Vitest sur `packages/core`, tests
d'intégration sur toute route qui écrit, `flutter_test` sur les écrans de conversion, Playwright et
Maestro en E2E. Cette stratégie est bonne. Elle a un défaut : **rien ne l'impose.**

Aujourd'hui, une PR sans un seul test neuf peut être mergée. Personne ne le remarquera, parce que la
CI sera verte — elle exécute les tests existants, elle ne demande pas qu'il y en ait de nouveaux. À
deux développeurs, sous une contrainte de 109 h pour 112 h disponibles, c'est exactement le genre de
règle qui saute le mercredi soir. Et une règle qui saute sous pression n'est pas une règle : c'est
une intention.

Le problème réel n'est pas la couverture, c'est la **régression**. Sur ce projet, trois zones
cassent silencieusement et coûtent cher :

| Zone | Ce qui casse | Comment on s'en aperçoit sans test |
|---|---|---|
| **Ranking** (`packages/core/search`) | Quelqu'un fusionne `w3` (confiance) et `w6` (facteurPlan) → le badge redevient payant | Jamais. L'ordre des artisans change, personne ne le remarque avant un mois. |
| **`ContactEvent`** | La déduplication 30 min saute, ou l'agrégat sort de la transaction | Jamais — jusqu'au jour où on présente des chiffres faux à un artisan qui paie. |
| **Auth** | La rotation du refresh cesse de révoquer la famille de sessions | Jamais, jusqu'à l'incident de sécurité. |

Ces trois zones n'ont **aucun symptôme visible** en cas de régression. C'est ce qui les distingue
d'un écran cassé, qu'on voit en ouvrant l'app.

## 2. Décision

**Trois règles, opposables en revue, vérifiées par la CI.**

### Règle 1 — Tout changement de comportement s'accompagne d'un test

Une PR qui modifie un comportement observable **ajoute ou modifie au moins un test**. Le test doit
couvrir le **cas passant** *et* **au moins un cas d'erreur**.

Sont explicitement **exemptés** (aucun test exigé) :

- documentation, commentaires, ADR, backlog
- fichiers **générés** (`openapi.json`, `*.g.dart`, `*.freezed.dart`, tokens générés, client Prisma)
- renommage pur, formatage, montée de version de dépendance sans changement d'appel
- configuration d'outillage (CI, lint, Docker) — son test, c'est qu'elle tourne

L'exemption se **déclare** dans la PR, en cochant la case correspondante. Elle ne se suppose pas.

### Règle 2 — Toute correction de bug commence par un test qui reproduit le bug

Dans cet ordre, sans exception :

```
1. Écrire le test qui échoue          →  il PROUVE le bug
2. Le voir échouer                    →  il prouve qu'il teste bien quelque chose
3. Corriger                           →  le test passe
4. Committer les deux ensemble        →  le bug ne peut plus revenir
```

Un test écrit **après** la correction ne prouve rien : on ne l'a jamais vu échouer. Il peut très
bien passer avec ou sans le correctif.

Le test porte le numéro de l'issue de bug en commentaire : `// régression #123`. C'est ce qui permet,
trois mois plus tard, de comprendre pourquoi cette assertion bizarre existe — et de ne pas la
supprimer parce qu'elle « ne sert à rien ».

### Règle 3 — Les tests de non-régression protégés ne se suppriment pas

Certains tests encodent une **décision**, pas un détail d'implémentation. Ils sont marqués :

```ts
// 🔒 NON-RÉGRESSION — ADR-002 : ne jamais supprimer sans un nouvel ADR qui l'annule
```

Trois existent dès le sprint S1 (voir §4). Les supprimer ou les désactiver exige un ADR qui annule
explicitement la décision d'origine. Une PR qui touche à un test marqué `🔒` est automatiquement
signalée par la CI et exige la revue **des deux** développeurs.

### Ce que la décision N'inclut PAS

- ❌ **Aucun seuil de couverture chiffré.** `POLITIQUE-PROJET.md` §6 avait raison : un pourcentage
  se triche. On atteint 80 % en testant les getters, et le ranking reste à découvert. On exige des
  tests *sur ce qui change*, pas un ratio global.
- ❌ **Pas de tests de mutation** en S1. C'est le bon outil pour vérifier que les tests détectent
  vraiment les bugs, et `packages/core/search/ranking.ts` en est le candidat idéal. Coût en temps de
  CI trop élevé pour un sprint sans marge. **À reconsidérer en S2** sur `packages/core` uniquement.
- ❌ **Pas de E2E bloquant** en S1. Maestro démarre en S2 (`POLITIQUE-PROJET.md` §6). Un E2E rouge
  pour une raison d'environnement bloquerait tout le monde, et on n'a pas la marge pour le stabiliser.

## 3. Application par la CI

Un merge est **bloqué** si l'un de ces contrôles échoue, sur `main` comme sur `develop` :

| Contrôle | Ce qu'il attrape |
|---|---|
| `pnpm lint` | dont `no-restricted-imports` : un module qui en importe un autre en profondeur (P1) |
| `pnpm typecheck` | `tsc --noEmit` sur tout le workspace |
| `pnpm test` | Vitest — unitaires + intégration sur une **vraie** PostgreSQL jetable |
| `pnpm api:contract --check` | le contrat commité est périmé par rapport aux schémas Zod (P2) |
| `pnpm i18n:check` | une clé existe en FR et pas en AR (P7) |
| `pnpm tokens:check` | les tokens générés (TS et Dart) sont périmés par rapport à `tokens.json` |
| `flutter analyze` | **zéro warning toléré** |
| `flutter test` | tests de widgets et de mappers |
| **garde-fous** | un secret commité · un `.skip` sans `TODO(<ID>)` · un test `🔒` supprimé · un `console.log` dans `apps/api` |

**Cible : < 5 min** grâce au cache Turborepo. Au-delà de 10 min, la CI cesse d'être un filet et
devient un péage : on la contournera. C'est un budget, pas un souhait.

**Si `main` ou `develop` est rouge, c'est la priorité n°1 de toute l'équipe**, avant toute autre
tâche (`POLITIQUE-PROJET.md` §1.3). Astreinte en rotation quotidienne.

## 4. Les trois tests protégés du sprint S1

| Test | Fichier | Ce qu'il protège |
|---|---|---|
| **Garde-fou ADR-002** | `packages/core/tests/ranking.test.ts` | Un artisan **gratuit, vérifié, complété à 100 %** doit devancer un artisan **Pro non vérifié, incomplet**, à géo et réputation égales. Si ce test casse, quelqu'un a re-lié le badge au plan. |
| **Dédup du contact** | `packages/core/tests/contacts.test.ts` | Deux clics en 5 minutes = **un seul** `ContactEvent`. Si ce test casse, les statistiques vendues aux artisans deviennent fausses. |
| **Rejeu du refresh** | `packages/core/tests/auth-session.test.ts` | Rejouer un ancien refresh token révoque **toute la famille** de sessions. Si ce test casse, un token volé reste utilisable. |

Ces trois-là ne sont pas « des tests parmi d'autres » : ce sont les trois endroits où une régression
est **invisible** et **coûteuse**.

## 5. Conséquences

### 5.1 Positives

- Les trois zones à régression silencieuse sont verrouillées **avant** d'être écrites.
- Le rituel bug → test → correctif transforme chaque bug en garantie permanente. Le même bug ne
  revient jamais deux fois, et c'est mesurable : un bug rouvert est un test manquant.
- La revue de code gagne une question objective — « où est le test ? » — au lieu d'un débat de goût.
- L'exemption étant **déclarée** et non supposée, on sait toujours pourquoi une PR n'a pas de test.

### 5.2 Négatives — assumées

- **Le coût est réel** : ~15 à 20 % de temps en plus par tâche, sur un sprint qui a 3 % de marge.
  C'est assumé, et l'amortisseur 🟠 P1 est là pour ça — on coupe des fonctionnalités, **pas les
  tests**. Une fonctionnalité coupée se rattrape en S2 ; une régression silencieuse sur le
  `ContactEvent` se paie en crédibilité auprès du premier artisan qui a payé.
- La règle 2 (test d'abord) est **contre-intuitive sous pression** : on veut corriger tout de suite.
  C'est précisément pour ça qu'elle est écrite ici plutôt que laissée à la discipline.
- Deux écosystèmes de test (Vitest, `flutter_test`) → deux jobs de CI, deux caches, deux
  configurations à maintenir. C'est la conséquence directe de l'ADR-001, pas une surprise.

### 5.3 Le point à surveiller

Le risque principal n'est pas qu'on n'écrive pas de tests : c'est qu'on écrive des **tests qui ne
prouvent rien** pour cocher la case — assertions tautologiques, mocks qui se testent eux-mêmes,
`expect(true).toBe(true)` déguisé. La règle 2 (voir le test échouer d'abord) est le meilleur
antidote connu. En revue, la question n'est pas « y a-t-il un test ? » mais **« si je casse cette
ligne, est-ce que ce test devient rouge ? »**

## 6. Références

- `POLITIQUE-PROJET.md` §6 — stratégie de test (quoi tester, avec quoi)
- `POLITIQUE-PROJET.md` §5 — *Definition of Done*
- ADR-002 §5 — garde-fou de test du badge « Vérifié »
- `HISTORIQUE.md` §12.2 et §12.3
- `.github/workflows/ci.yml` — l'application concrète de cet ADR
