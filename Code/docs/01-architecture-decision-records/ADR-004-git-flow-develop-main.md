# ADR-004 — Git flow `develop` / `main` : staging avant production

| Champ | Valeur |
|---|---|
| **ID** | ADR-004 |
| **Date** | 2026-08-17 |
| **Statut** | Accepté |
| **Décideur** | Oussama Dallel |
| **Contexte** | SO-07 — Protection de `main`, CODEOWNERS, organisation GitHub |

---

## Contexte

Pendant le sprint S1, toutes les branches de feature ont ciblé `main` directement. Bien qu'une branche
`develop` existe dans le dépôt depuis la mise en place initiale (SO-00), elle n'était pas utilisée
comme cible d'intégration. Cela crée un risque : une régression peut atteindre la production sans
passer par une phase de staging intermédiaire.

Oussama a décidé d'activer le git flow `develop`/`main` dès maintenant, avant le premier déploiement
réel, plutôt que d'essayer de le retrofitter sur un projet en production.

---

## Décision

**`develop` devient la branche d'intégration (staging). `main` devient la branche de production.**

```
main          ← production · alimentée depuis develop uniquement · par Oussama
└── develop   ← staging · cible de toutes les features
    ├── feat/BE-xx-…
    ├── fix/…
    └── chore/…
```

### Règles opérationnelles

| Branche | Rôle | Qui merge |
|---|---|---|
| `develop` | Intégration / staging | Tout collaborateur avec droit d'écriture (sauf Claude) |
| `main` | Production | Oussama Dallel uniquement |

1. **Toute PR de feature cible `develop`**, jamais `main` directement — sans exception.
2. **Rebase sur `develop`** (non `main`) avant d'ouvrir une PR.
3. **`develop → main`** : PR de release créée par Oussama. Elle résume les changements depuis la
   dernière release. Pas de PR de feature ciblant `main`.
4. La CI tourne sur `develop` à chaque push. Un `develop` rouge = priorité n°1.
5. `main` ne reçoit que du code déjà validé en staging sur `develop`.

---

## Conséquences

### Positives

- Une régression détectée sur `develop` (staging) ne touche jamais la production.
- `main` = historique de releases propre, chaque entrée correspond à une mise en production.
- Oussama garde le contrôle explicite des mises en production sans avoir à bloquer les merges
  quotidiens des features.
- Modèle familier pour les équipes qui rejoindront le projet.

### Négatives / contraintes

- Toutes les branches de feature ouvertes et futures doivent cibler `develop`. Les PRs ouvertes
  ciblant `main` doivent être retargetées.
- La protection de branche GitHub doit être configurée sur `develop` (pas seulement sur `main`).
- `develop` doit être synchronisé sur `main` après chaque release (ou `main` rebased sur `develop`).

---

## Alternatives écartées

| Alternative | Pourquoi écartée |
|---|---|
| Continuer à merger sur `main` | Pas de phase de staging distincte. Une régression va directement en production. |
| Git flow complet (release, hotfix, support branches) | Trop lourd pour 2 développeurs en sprint d'1 semaine. |
| Feature flags sans branche staging | Plus complexe à mettre en œuvre et ne protège pas la production d'un déploiement accidentel. |

---

## Migration (situation au 2026-08-17)

`develop` est en retard sur `main` de tous les commits SO-01→SO-07. La PR #67 (`main → develop`)
ouverte par GitHub synchronise `develop` avec `main`. **Elle doit être mergée par Oussama avant
d'appliquer les nouvelles règles de ciblage.**

Commande de vérification post-sync :

```bash
git fetch origin
git log --oneline origin/develop..origin/main   # doit être vide après sync
```

---

## Références

- `POLITIQUE-PROJET.md` §3.1 et §3.3 — mis à jour pour refléter cette décision
- `CLAUDE.md` §3.5 — mis à jour
- `Code/docs/07-organisation-github.md` §4.4 — mis à jour
- PR #67 — sync `main → develop`
