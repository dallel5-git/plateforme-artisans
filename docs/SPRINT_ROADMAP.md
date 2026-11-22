# 🗓️ SPRINT ROADMAP — SANAYA MOBILE

> **Projet :** Sanaya — Application Mobile Artisans  
> **Branche de référence :** `develop`  
> **Total :** 26 tâches · 68 Story Points · 5 Sprints  
> **Version :** 1.0.0 — Initial Release  
> **Dernière mise à jour :** 2026-11-14

---

## Vue d'ensemble

| Sprint | Objectif principal | Tâches | Story Points | Priorité |
|--------|--------------------|--------|--------------|----------|
| Sprint 1 | Stabilité critique & fondations | MOB-002, MOB-001, MOB-003, MOB-004, MOB-005 | 12 SP | P0 |
| Sprint 2 | Stabilité fonctionnelle & UX de base | MOB-010, MOB-011, MOB-006, MOB-007, MOB-008, MOB-009, MOB-014 | 15 SP | P1 |
| Sprint 3 | Recherche, conversion & catalogue | MOB-018, MOB-015, MOB-016, MOB-013, MOB-012, MOB-019, MOB-017 | 13 SP | P1–P2 |
| Sprint 4 | Expérience professionnelle post-onboarding | MOB-020, MOB-021, MOB-022 | 15 SP | P1–P2 |
| Sprint 5 | Branding, polish & préparation production | MOB-025, MOB-024, MOB-023, MOB-026 | 13 SP | P2–P3 |

---

## 🚀 SPRINT 1 — Stabilité Critique & Fondations

**Objectif :** Éliminer tous les crashs et bugs bloquants. Rendre l'application stable et navigable sans erreurs critiques.

**Story Points :** 12 SP  
**Priorité dominante :** P0 (Critical)  
**Dépendances entrantes :** Aucune — sprint indépendant  

### Tâches dans l'ordre d'exécution

| Ordre | ID | Titre | SP | Priorité | Dépendances |
|-------|----|-------|----|----------|-------------|
| 1 | MOB-002 | Correction du crash au démarrage | 3 | P0 | Aucune |
| 2 | MOB-001 | Correction des erreurs d'authentification | 5 | P0 | MOB-002 |
| 3 | MOB-003 | Correction de la navigation cassée | 3 | P0 | MOB-001 |
| 4 | MOB-004 | Correction des erreurs API critiques | 5 | P0 | MOB-003 |
| 5 | MOB-005 | Mise en place de la gestion globale des erreurs | 3 | P0 | MOB-004 |

### Ordre d'exécution détaillé

```
MOB-002 (crash démarrage)
   └─► MOB-001 (auth errors — nécessite app stable)
         └─► MOB-003 (navigation cassée — nécessite auth fonctionnelle)
               └─► MOB-004 (erreurs API — nécessite navigation)
                     └─► MOB-005 (gestion globale erreurs — dernière couche)
```

### Résultats attendus à la fin du Sprint 1

- ✅ L'application démarre sans crash
- ✅ L'authentification (connexion/inscription) fonctionne sans erreur
- ✅ La navigation entre les écrans est fluide et sans crash
- ✅ Les appels API critiques ne provoquent plus d'erreurs non gérées
- ✅ Un système global de gestion des erreurs est en place

### Critères de validation du Sprint 1

- [ ] L'application peut être lancée 10 fois consécutives sans crash
- [ ] Un utilisateur peut s'inscrire, se connecter et se déconnecter sans erreur
- [ ] Tous les écrans principaux sont accessibles via la navigation
- [ ] Les erreurs réseau affichent un message utilisateur approprié (pas un crash)
- [ ] Les logs ne contiennent aucune exception non gérée critique

---

## 🔧 SPRINT 2 — Stabilité Fonctionnelle & UX de Base

**Objectif :** Compléter les fonctionnalités essentielles, corriger les écrans incomplets, et améliorer l'expérience utilisateur de base.

**Story Points :** 15 SP  
**Priorité dominante :** P1 (High)  
**Dépendances entrantes :** Sprint 1 complété ✅  

### Tâches dans l'ordre d'exécution

| Ordre | ID | Titre | SP | Priorité | Dépendances |
|-------|----|-------|----|----------|-------------|
| 1 | MOB-010 | Refactoring de l'architecture des services | 5 | P1 | MOB-005 |
| 2 | MOB-011 | Mise en place d'un système de state management | 5 | P1 | MOB-010 |
| 3 | MOB-006 | Completion de l'écran de profil artisan | 3 | P1 | MOB-003 |
| 4 | MOB-007 | Completion de l'écran de tableau de bord | 3 | P1 | MOB-011 |
| 5 | MOB-008 | Validation des formulaires | 2 | P1 | MOB-006 |
| 6 | MOB-009 | Ajout des états vides et de chargement | 2 | P1 | MOB-007 |
| 7 | MOB-014 | Sécurisation du stockage des tokens | 3 | P1 | MOB-001 |

### Ordre d'exécution détaillé

```
MOB-010 (architecture services — refactoring fondamental)
   └─► MOB-011 (state management — dépend de l'architecture)
         ├─► MOB-007 (dashboard — dépend du state)
         │     └─► MOB-009 (empty states — dépend des écrans)
         └─► MOB-006 (profil artisan — dépend de navigation Sprint 1)
               └─► MOB-008 (validation formulaires — dépend des écrans)

MOB-014 (sécurité tokens — peut être parallélisé après MOB-001)
```

### Résultats attendus à la fin du Sprint 2

- ✅ Architecture services propre et maintenable
- ✅ State management centralisé et cohérent
- ✅ Écran de profil artisan complet et fonctionnel
- ✅ Dashboard avec données réelles
- ✅ Formulaires avec validations côté client
- ✅ États vides et loaders sur tous les écrans principaux
- ✅ Tokens stockés de manière sécurisée

### Critères de validation du Sprint 2

- [ ] L'architecture des services respecte le pattern défini (Repository/Service)
- [ ] Le state management centralise toutes les données partagées
- [ ] Le profil artisan affiche toutes les informations requises
- [ ] Le tableau de bord affiche les statistiques correctes
- [ ] Tous les formulaires valident les champs obligatoires avant soumission
- [ ] Chaque écran affiche un loader pendant le chargement
- [ ] Chaque écran affiche un état vide lorsqu'aucune donnée n'est disponible
- [ ] Les tokens ne sont plus stockés en plain text

---

## 🔍 SPRINT 3 — Recherche, Conversion & Catalogue

**Objectif :** Implémenter les fonctionnalités de découverte des artisans, améliorer le catalogue et le processus de conversion client.

**Story Points :** 13 SP  
**Priorité dominante :** P1–P2  
**Dépendances entrantes :** Sprint 2 complété ✅  

### Tâches dans l'ordre d'exécution

| Ordre | ID | Titre | SP | Priorité | Dépendances |
|-------|----|-------|----|----------|-------------|
| 1 | MOB-018 | Implémentation de la recherche avancée | 5 | P1 | MOB-011 |
| 2 | MOB-015 | Amélioration du catalogue des services | 3 | P1 | MOB-011 |
| 3 | MOB-016 | Complétion du flux de réservation | 5 | P1 | MOB-015 |
| 4 | MOB-013 | Ajout des notifications push | 3 | P2 | MOB-004 |
| 5 | MOB-012 | Implémentation du système de messagerie | 5 | P2 | MOB-011 |
| 6 | MOB-019 | Ajout du système de notation et avis | 3 | P2 | MOB-016 |
| 7 | MOB-017 | Implémentation du suivi des commandes | 3 | P2 | MOB-016 |

### Ordre d'exécution détaillé

```
MOB-018 (recherche avancée — dépend du state management)
   └─► MOB-015 (catalogue services — enrichi par la recherche)
         └─► MOB-016 (flux réservation — dépend du catalogue)
               ├─► MOB-019 (notation/avis — après réservation complète)
               └─► MOB-017 (suivi commandes — après réservation complète)

MOB-013 (notifications push — peut être parallélisé dès MOB-004)
MOB-012 (messagerie — dépend du state management)
```

### Résultats attendus à la fin du Sprint 3

- ✅ Recherche par nom, catégorie, localisation fonctionnelle
- ✅ Catalogue des services enrichi avec filtres et tri
- ✅ Processus de réservation complet de bout en bout
- ✅ Notifications push pour les événements clés
- ✅ Messagerie entre client et artisan opérationnelle
- ✅ Système de notation et avis après prestation
- ✅ Suivi de l'état des commandes en temps réel

### Critères de validation du Sprint 3

- [ ] La recherche retourne des résultats pertinents en moins de 2 secondes
- [ ] Le catalogue affiche au minimum : photo, nom, spécialité, note, prix indicatif
- [ ] Un client peut réserver un service en moins de 5 étapes
- [ ] Les notifications push arrivent dans un délai raisonnable
- [ ] Un message envoyé par le client est reçu par l'artisan (et vice versa)
- [ ] Un avis posté par un client est visible sur le profil de l'artisan
- [ ] L'état d'une commande se met à jour en temps réel

---

## 👑 SPRINT 4 — Expérience Professionnelle Post-Onboarding

**Objectif :** Améliorer l'expérience des artisans professionnels avec la gestion des disponibilités, le portfolio et les statistiques avancées.

**Story Points :** 15 SP  
**Priorité dominante :** P1–P2  
**Dépendances entrantes :** Sprint 3 complété ✅  

### Tâches dans l'ordre d'exécution

| Ordre | ID | Titre | SP | Priorité | Dépendances |
|-------|----|-------|----|----------|-------------|
| 1 | MOB-020 | Gestion des disponibilités artisan | 5 | P1 | MOB-016 |
| 2 | MOB-021 | Implémentation du portfolio artisan | 5 | P2 | MOB-006 |
| 3 | MOB-022 | Tableau de bord statistiques avancées | 5 | P2 | MOB-007, MOB-020 |

### Ordre d'exécution détaillé

```
MOB-020 (disponibilités — dépend du flux réservation)
   └─► MOB-022 (stats avancées — intègre les données de réservation)

MOB-021 (portfolio — dépend du profil artisan, peut être parallèle à MOB-020)
```

### Résultats attendus à la fin du Sprint 4

- ✅ Les artisans peuvent définir leurs créneaux de disponibilité
- ✅ Les clients voient uniquement les créneaux disponibles lors de la réservation
- ✅ Les artisans peuvent présenter leurs réalisations via un portfolio
- ✅ Le dashboard artisan affiche des statistiques complètes (revenus, réservations, notes moyennes)

### Critères de validation du Sprint 4

- [ ] Un artisan peut ajouter, modifier et supprimer des créneaux de disponibilité
- [ ] Les créneaux réservés ne sont plus proposables à d'autres clients
- [ ] Un artisan peut ajouter des photos/descriptions à son portfolio
- [ ] Le dashboard affiche : revenus du mois, nombre de réservations, note moyenne, taux de complétion

---

## 🎨 SPRINT 5 — Branding, Polish & Préparation Production

**Objectif :** Finaliser l'identité visuelle, optimiser les performances, sécuriser l'application et préparer le déploiement en production.

**Story Points :** 13 SP  
**Priorité dominante :** P2–P3  
**Dépendances entrantes :** Sprint 4 complété ✅  

### Tâches dans l'ordre d'exécution

| Ordre | ID | Titre | SP | Priorité | Dépendances |
|-------|----|-------|----|----------|-------------|
| 1 | MOB-025 | Tests d'intégration et end-to-end | 5 | P2 | MOB-022 |
| 2 | MOB-024 | Optimisation des performances | 3 | P2 | MOB-022 |
| 3 | MOB-023 | Internationalisation (i18n) | 3 | P2 | MOB-022 |
| 4 | MOB-026 | Préparation et configuration production | 2 | P2 | MOB-025, MOB-024 |

### Ordre d'exécution détaillé

```
MOB-025 (tests E2E — validation complète de l'app)
   └─► MOB-026 (préparation prod — après validation des tests)

MOB-024 (performances — peut être parallélisé avec MOB-025)
MOB-023 (i18n — peut être parallélisé avec MOB-025)
```

### Résultats attendus à la fin du Sprint 5

- ✅ Suite de tests d'intégration couvrant les parcours utilisateurs principaux
- ✅ Application optimisée (temps de chargement réduit, animations fluides)
- ✅ Support multilingue (Français / Arabe minimum)
- ✅ Configuration de production prête (variables d'environnement, signing, CI/CD)

### Critères de validation du Sprint 5

- [ ] Les tests E2E couvrent au minimum : inscription → connexion → recherche → réservation → paiement
- [ ] Le temps de démarrage de l'application est inférieur à 3 secondes
- [ ] L'application fonctionne en Français et en Arabe (RTL correct)
- [ ] La configuration de production est documentée et prête pour le store
- [ ] Aucune clé secrète n'est présente dans le code source

---

## 📊 Résumé des dépendances inter-sprints

```
Sprint 1 ──────────────────────────────────────────────────────────────────► Sprint 5
   │                                                                              ▲
   ▼                                                                              │
Sprint 2 ──────────────────────────────────────────────────────────────► Sprint 4 ─┘
   │                                                                              ▲
   ▼                                                                              │
Sprint 3 ─────────────────────────────────────────────────────────────────────────┘
```

**Règle stricte :** Chaque sprint doit être entièrement validé avant de démarrer le suivant.

---

## 🚦 Suivi de progression

| Sprint | Status | Début | Fin | Blocages |
|--------|--------|-------|-----|---------|
| Sprint 1 | 🔲 À faire | — | — | — |
| Sprint 2 | 🔲 À faire | — | — | — |
| Sprint 3 | 🔲 À faire | — | — | — |
| Sprint 4 | 🔲 À faire | — | — | — |
| Sprint 5 | 🔲 À faire | — | — | — |

---

*Document maintenu dans la branche `chayma-branche/docs-product-backlog` — Ne pas modifier directement sur `develop` ou `main`.*
