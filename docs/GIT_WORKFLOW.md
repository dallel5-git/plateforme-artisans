# 🌿 GIT WORKFLOW — SANAYA MOBILE

> **Projet :** Sanaya — Application Mobile Artisans  
> **Dépôt GitHub :** `https://github.com/dallel5-git/plateforme-artisans`  
> **Branche par défaut :** `develop`  
> **Version :** 1.0.0  
> **Dernière mise à jour :** 2026-11-14

---

## 1. Architecture des branches

```
main
 └── develop  ◄── branche de référence (défaut)
       ├── chayma-branche/docs-product-backlog
       ├── chayma-branche/MOB-001
       ├── chayma-branche/MOB-002
       ├── chayma-branche/MOB-003
       │   ...
       └── chayma-branche/MOB-026
```

### Règle absolue

> **⛔ AUCUNE MODIFICATION DIRECTE SUR `develop` OU `main`.**  
> Toute modification passe obligatoirement par une branche de travail dédiée et une Pull Request validée.

| Branche | Usage | Accès direct |
|---------|-------|--------------|
| `main` | Production uniquement | ❌ Interdit |
| `develop` | Référence de développement | ❌ Interdit |
| `chayma-branche/*` | Travail par tâche | ✅ Autorisé |

---

## 2. Convention de nommage des branches

### Format obligatoire

```
chayma-branche/<TYPE>-<IDENTIFIANT>
```

### Exemples

| Type de tâche | Format | Exemple |
|---------------|--------|---------|
| Tâche Product Backlog | `chayma-branche/MOB-XXX` | `chayma-branche/MOB-001` |
| Documentation | `chayma-branche/docs-<nom>` | `chayma-branche/docs-product-backlog` |
| Hotfix urgent | `chayma-branche/hotfix-<description>` | `chayma-branche/hotfix-crash-login` |

### Règles de nommage

- ✅ Utiliser uniquement des lettres minuscules, des chiffres et des tirets (`-`)
- ✅ Toujours préfixer par `chayma-branche/`
- ✅ Respecter exactement l'ID de la tâche (ex : `MOB-001`, pas `mob-1` ni `MOB1`)
- ❌ Ne jamais utiliser d'espaces, d'underscores ou de caractères spéciaux
- ❌ Ne jamais créer une branche sans ID de tâche associé
- ❌ Ne jamais regrouper plusieurs tâches dans une même branche

---

## 3. Règles de création des branches

### Création d'une branche de tâche

Chaque branche doit être créée **depuis `develop` à jour** :

```bash
# 1. Se positionner sur develop
git checkout develop

# 2. Mettre develop à jour depuis le remote
git pull origin develop

# 3. Créer la branche de travail
git checkout -b chayma-branche/MOB-XXX

# 4. Vérifier qu'on est bien sur la bonne branche
git branch --show-current
```

### Vérifications avant création

- [ ] `develop` est à jour avec `origin/develop`
- [ ] Les tâches dont MOB-XXX dépend sont complétées et mergées dans `develop`
- [ ] Aucune branche `chayma-branche/MOB-XXX` n'existe déjà en local ou sur le remote

---

## 4. Convention de nommage des commits

### Format Conventional Commits

```
<type>(MOB-XXX): <description courte en français>

[corps optionnel]

[footer optionnel]
```

### Types de commits autorisés

| Type | Usage |
|------|-------|
| `fix` | Correction d'un bug |
| `feat` | Nouvelle fonctionnalité |
| `ui` | Modification d'interface utilisateur |
| `refactor` | Refactoring sans changement de comportement |
| `perf` | Optimisation des performances |
| `test` | Ajout ou modification de tests |
| `docs` | Documentation uniquement |
| `chore` | Tâches de maintenance (config, dépendances) |
| `security` | Correction de faille de sécurité |

### Exemples de commits valides

```bash
fix(MOB-002): corriger le crash au démarrage de l'application
feat(MOB-012): implémenter le système de messagerie client-artisan
ui(MOB-006): compléter l'écran de profil artisan avec les spécialités
refactor(MOB-010): restructurer l'architecture des services API
security(MOB-014): sécuriser le stockage des tokens avec SecureStorage
docs: ajouter le Product Backlog, Sprint Roadmap et Git Workflow
```

### Règles des messages de commit

- ✅ Description en français, courte et explicite (< 72 caractères)
- ✅ Toujours inclure l'ID de la tâche entre parenthèses (sauf `docs:` global)
- ✅ Utiliser le présent de l'impératif ("corriger", "implémenter", pas "corrigé")
- ❌ Ne jamais committer du code non testé sur une branche partagée
- ❌ Ne jamais inclure de secrets, clés API ou mots de passe dans un commit

---

## 5. Processus de Pull Request

### Titre de la PR

```
[MOB-XXX] Titre court et explicite de la tâche
```

Exemple : `[MOB-001] Correction des erreurs d'authentification`

### Template de description de PR

```markdown
## 📋 Référence
- **ID Tâche :** MOB-XXX
- **Epic :** EPIC X — Nom de l'Epic
- **Sprint :** Sprint X
- **Priorité :** P0 / P1 / P2 / P3

## 🔍 Problème identifié
Description du problème issu de l'audit technique.

## ✅ Solution implémentée
Description détaillée de ce qui a été fait.

## 📁 Fichiers modifiés
- `chemin/vers/fichier1.dart`
- `chemin/vers/fichier2.dart`

## 🧪 Tests réalisés
- [ ] Test manuel sur émulateur Android
- [ ] Test manuel sur émulateur iOS
- [ ] Tests unitaires passants
- [ ] Aucune régression détectée

## 📸 Captures d'écran (si applicable)
<!-- Ajouter des captures avant/après si modification UI -->

## ✔️ Critères d'acceptation
- [ ] Critère 1
- [ ] Critère 2
- [ ] Critère 3

## 🔗 Dépendances
- Dépend de : MOB-XXX (si applicable)
- Bloque : MOB-XXX (si applicable)
```

---

## 6. Règles de fusion (merge)

### Règles strictes

- ✅ La PR doit être **validée explicitement** avant tout merge
- ✅ La cible du merge est **toujours `develop`** (jamais `main` directement)
- ✅ Résoudre tous les conflits **dans la branche source** avant la PR
- ✅ La branche source doit être à jour avec `develop` au moment du merge
- ❌ **Ne jamais auto-merger** une PR
- ❌ **Ne jamais merger** `develop` vers `main` sans validation de release complète
- ❌ **Ne jamais supprimer** une branche sans autorisation explicite

### Processus de merge vers develop

```bash
# Dans la branche source, avant de pousser la PR
git checkout develop
git pull origin develop
git checkout chayma-branche/MOB-XXX
git merge develop  # Résoudre les conflits si nécessaire
git push origin chayma-branche/MOB-XXX
# → Ouvrir la PR sur GitHub
```

### Merge develop → main (release uniquement)

Ce merge est **réservé aux releases de production**. Il requiert :
1. Tous les sprints du périmètre de release complétés
2. Tests E2E passants (MOB-025)
3. Configuration de production prête (MOB-026)
4. Validation explicite de la responsable du projet

---

## 7. Workflow complet pour chaque tâche (14 étapes)

```
ÉTAPE 1  → Vérifier que develop est à jour
           git checkout develop && git pull origin develop

ÉTAPE 2  → Vérifier les dépendances de la tâche dans PRODUCT_BACKLOG.md

ÉTAPE 3  → Créer ou récupérer la branche dédiée depuis develop
           git checkout -b chayma-branche/MOB-XXX

ÉTAPE 4  → Vérifier qu'on est bien sur la bonne branche
           git branch --show-current

ÉTAPE 5  → Analyser les fichiers concernés (lecture uniquement d'abord)

ÉTAPE 6  → Implémenter uniquement les modifications de cette tâche
           (ne pas toucher aux fonctionnalités hors scope)

ÉTAPE 7  → Vérifier les changements
           git diff

ÉTAPE 8  → Exécuter les tests nécessaires
           (unitaires, intégration, tests manuels)

ÉTAPE 9  → Vérifier qu'aucune régression n'est introduite

ÉTAPE 10 → Créer un commit clair et descriptif
           git add <fichiers>
           git commit -m "fix(MOB-XXX): description"

ÉTAPE 11 → Pousser la branche sur GitHub
           git push -u origin chayma-branche/MOB-XXX

ÉTAPE 12 → Créer la Pull Request sur GitHub
           Titre : [MOB-XXX] Titre de la tâche
           Cible : develop

ÉTAPE 13 → Présenter le récapitulatif à la responsable du projet
           (fichiers modifiés, tests passants, critères d'acceptation)

ÉTAPE 14 → Attendre la validation explicite avant tout merge ou nouvelle tâche
```

---

## 8. Gestion des dépendances entre tâches

### Vérification avant démarrage

Avant de créer une branche `chayma-branche/MOB-XXX`, vérifier que :

1. Les PRs des tâches dont MOB-XXX dépend sont **mergées dans `develop`**
2. `develop` est à jour localement (`git pull origin develop`)

### Tableau des dépendances clés

| Tâche | Dépend de | Bloque |
|-------|-----------|--------|
| MOB-001 | MOB-002 | MOB-003, MOB-014 |
| MOB-002 | — | MOB-001 |
| MOB-003 | MOB-001 | MOB-004, MOB-006 |
| MOB-004 | MOB-003 | MOB-005, MOB-013 |
| MOB-005 | MOB-004 | MOB-010 |
| MOB-006 | MOB-003 | MOB-008, MOB-021 |
| MOB-007 | MOB-011 | MOB-009, MOB-022 |
| MOB-008 | MOB-006 | — |
| MOB-009 | MOB-007 | — |
| MOB-010 | MOB-005 | MOB-011 |
| MOB-011 | MOB-010 | MOB-007, MOB-012, MOB-015, MOB-018 |
| MOB-012 | MOB-011 | — |
| MOB-013 | MOB-004 | — |
| MOB-014 | MOB-001 | — |
| MOB-015 | MOB-011 | MOB-016 |
| MOB-016 | MOB-015 | MOB-017, MOB-019, MOB-020 |
| MOB-017 | MOB-016 | — |
| MOB-018 | MOB-011 | — |
| MOB-019 | MOB-016 | — |
| MOB-020 | MOB-016 | MOB-022 |
| MOB-021 | MOB-006 | — |
| MOB-022 | MOB-007, MOB-020 | MOB-023, MOB-024, MOB-025 |
| MOB-023 | MOB-022 | MOB-026 |
| MOB-024 | MOB-022 | MOB-026 |
| MOB-025 | MOB-022 | MOB-026 |
| MOB-026 | MOB-025, MOB-024 | — |

---

## 9. Workflow develop → main

```
chayma-branche/MOB-XXX
         │
         │  (PR validée)
         ▼
      develop  ◄──────────────── branche de travail quotidien
         │
         │  (Release validée — tous sprints complétés)
         ▼
        main  ◄─────────────────── production uniquement
```

**Fréquence des merges vers main :** À la fin d'un ensemble de sprints formant une release stable. Pas de release partielle.

---

## 10. Commandes Git de référence rapide

```bash
# Vérifier l'état actuel
git status
git branch --show-current
git log --oneline -5

# Mettre develop à jour
git checkout develop
git pull origin develop

# Créer une nouvelle branche de tâche
git checkout -b chayma-branche/MOB-XXX

# Voir les différences avant commit
git diff
git diff --staged

# Ajouter et committer
git add chemin/vers/fichier.dart
git commit -m "fix(MOB-XXX): description"

# Pousser la branche
git push -u origin chayma-branche/MOB-XXX

# Vérifier les branches locales et distantes
git branch -a

# Lister les fichiers modifiés par rapport à develop
git diff develop --name-only
```

---

*Document maintenu dans la branche `chayma-branche/docs-product-backlog` — Ne pas modifier directement sur `develop` ou `main`.*
