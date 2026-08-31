# Plan — Refonte design complète de l'application mobile

> Rédigé le 2026-08-31 (Claude), à la demande d'Oussama. Source : audit exhaustif de
> `apps/mobile` confronté aux 4 planches de maquette fournies (A. thème sombre, B. espace
> client clair + 1 écran arabe/RTL, C. espace artisan clair, D. back-office web — hors
> périmètre mobile) et au lien Canva `Sanaya Mobile App (FR)` (rendu inaccessible en
> lecture automatisée — page SPA sans contenu statique — traité comme équivalent aux
> planches déjà transmises).
>
> Les issues GitHub correspondantes sont générées depuis `Code/tooling/scripts/
> issues-data.py` (IDs `FM-15`→`FM-19`, `FM-22`→`FM-43`, `BE-44`→`BE-47`) et créées sur le
> dépôt `dallel5-git/plateforme-artisans`, milestone **M7 — Refonte design mobile
> complète**. Ce document explique le POURQUOI du découpage ; le détail exécutable
> (contexte, périmètre, critères d'acceptation) vit dans chaque issue.

---

## 1. Ce qu'il faut savoir en 30 secondes

- Le design system existe (tokens, thème clair **et** sombre, RTL piloté au niveau
  `MaterialApp`, parité i18n FR/AR sur 12 namespaces) mais **n'est presque pas consommé** :
  4 des 10 widgets `core/widgets/` livrés par FM-04 (`ProviderCard`, `EmptyState`,
  `OfflineBanner`, `AppSkeleton`) ne sont montés sur AUCUN écran de production, seulement
  sur la vitrine `/_ds-preview`.
- Sur les 14 écrans mobiles des 3 planches (A/B/C) : **5 existent avec un écart de
  direction artistique documenté**, **2 existent sous une forme à refondre** (tableau de
  bord), **7 n'existent pas du tout** (résultats de recherche, boosts, historique, profil
  client, avis reçus pro, profil pro — l'écran de résultats étant le plus critique).
- **3 écrans complets et testés sont aujourd'hui inatteignables** depuis l'interface
  (Favoris, Réglages, et deux points d'entrée morts vers la fiche artisan) : c'est le gain
  le plus rapide de toute la refonte, avant même d'écrire un seul nouveau widget.
- **Aucune barre de navigation n'existe** — ni le widget, ni la structure de routage
  (`StatefulShellRoute`). C'est le composant qui débloque presque tout le reste.
- Deux dépendances backend bloquent une poignée d'écrans pro (`GET /v1/providers/me` —
  la plus structurante, `GET /v1/contact-events`) ; tout le reste est réalisable
  aujourd'hui, sans négociation backend.
- Boosts/crédits/Pack Pro (planches A6/C3, partie de A2/C2) dépendent d'EP-BILLING,
  bloquée par l'ADR-004 non tranchée (moyens de paiement) — designable en coquille
  uniquement (`FM-40`).

---

## 2. Méthode

Audit mené par 8 agents en parallèle (fondations design system, navigation, parcours
client, parcours pro, bibliothèque de widgets partagés, i18n/RTL, accessibilité,
cohérence backlog↔code↔GitHub), chacun tenu de citer un fichier et une ligne pour toute
affirmation d'absence. Les manques déclarés ont ensuite été vérifiés de façon
adversariale (recherche active d'une preuve du contraire) avant d'être retenus. 3 des 8
audits (i18n-rtl, a11y-motion, backlog-coherence) et les phases finales de synthèse ont
été interrompus par une limite d'usage de session ; ce document et le découpage en
issues ont été complétés à la main à partir des résultats déjà produits (5 audits
complets + 30 vérifications adversariales, soit l'essentiel des manques structurants) et
d'une relecture manuelle des zones non couvertes.

---

## 3. Arbitrages retenus par défaut

Cinq questions n'ont pas de réponse univoque dans le code, le backlog ou les maquettes.
Faute d'un point de synchronisation dédié, ce plan tranche avec la lecture la plus
défendable et **le signale dans l'issue concernée** — à corriger en commentaire sur
l'issue si le choix ne convient pas, avant de démarrer le travail.

| # | Question | Tranché en faveur de | Pourquoi | Issue |
|---|---|---|---|---|
| 1 | Étape « choix du rôle » à l'authentification (code : 3 étapes) — absente d'A3/B1 | **Suppression** | Le rôle réel est déterminé côté serveur (`GET /auth/me`), pas par un choix client ; les 2 maquettes ouvrent directement sur le numéro | `FM-33` |
| 2 | Nombre d'étapes de l'onboarding (4 en code · 5 dans l'issue FM-11 d'origine · 3 selon l'ADR-003 · « sur 7 » en maquette C1) | **5 étapes réelles** (profil/catégories/zones/photos/récapitulatif), le « 7 » de C1 lu comme les 7 critères de `completionScore`, **pas** comme un compte d'étapes | C'est la lecture la plus cohérente avec le code existant (`completion-score.ts` a exactement 7 critères) et évite d'inventer 3 étapes sans contenu | `FM-34` |
| 3 | Barre de recherche de l'écran résultats : deux champs (A1, sombre) ou une seule barre arrondie (B3, clair) | **Deux champs (A1)**, retenue comme référence unique pour les deux thèmes | C'est déjà la direction du code existant (`SearchHomeBar`) ; la variante B3 est notée comme un différé possible, pas perdue | `FM-27` |
| 4 | Ordre des boutons Appeler/WhatsApp (A4 semble montrer WhatsApp en premier, le code a Appeler en premier) | **Garder Appeler en premier** (primary), miroir RTL automatique via `Row`+`Directionality` | Un `Row` dont le premier enfant est « Appeler » place déjà Appeler à droite en arabe (B4) sans code spécifique par locale — c'est l'ordre qui obtient B4 gratuitement ; l'inversion apparente en A4 est traitée comme une incohérence mineure entre planches, pas une exigence produit | `FM-30` |
| 5 | Où la fiche artisan s'empile-t-elle une fois le shell à onglets en place (dans l'onglet Rechercher ou par-dessus, plein écran) | **Dans l'onglet Rechercher** (push classique, barre masquée par la barre de contact fixe qui prend son rôle) | Patron habituel des apps d'annuaire, compatible avec `StatefulShellRoute.indexedStack` sans changement d'architecture | `FM-23`, `FM-28` |

---

## 4. Séquencement

```
FM-15 (tokens)
   │
   ├─► FM-16 (ThemeData) ─┬─► FM-17 (persistance thème + a11y)
   │                      │
   │                      └─► FM-18 (garde-fou CI + vitrine)
   │
   ├─► FM-19 (i18n nav) ──► FM-22 (widget AppBottomNav)
   │                              │
   │                              ├─► FM-23 (shell CLIENT) ─┬─► FM-25 (déconnexion + bascule)
   │                              │                          ├─► FM-26 (câblage orphelins)
   │                              │                          ├─► FM-31 (Historique) ⛔ BE-45
   │                              │                          └─► FM-32 (Profil client)
   │                              │
   │                              └─► FM-24 (shell PRO) ─────┬─► FM-34 (onboarding) ─┬─► FM-35 (photos)
   │                                                          │                        └─► FM-36 (reprise) ⛔ BE-44
   │                                                          ├─► FM-37 (dashboard)
   │                                                          ├─► FM-38 (profil pro) ⛔ BE-44
   │                                                          ├─► FM-39 (avis reçus) ⛔ BE-44
   │                                                          └─► FM-40 (boosts, coquille) ⛔ EP-BILLING
   │
   ├─► FM-27 (widgets recherche) ──► FM-28 (écran résultats)
   ├─► FM-29 (fiche artisan) ──► FM-30 (contact + avis)
   ├─► FM-33 (auth)
   └─► FM-41 (composants transverses) ──► FM-42 (adoption états) ──► FM-43 (a11y)

BE-44 (GET /providers/me) ─── débloque FM-36, FM-37 (partiel), FM-38, FM-39
BE-45 (GET /contact-events) ── débloque FM-31
BE-46 (ventilation canaux) ─── enrichit FM-37 (sans le bloquer)
BE-47 (offerings) ──────────── débloque une future étape « Tarifs » (hors périmètre v1)
```

**Ordre d'attaque recommandé** : `FM-15` → `FM-16` → `FM-19`+`FM-22` en parallèle des
deux premiers → `FM-23`/`FM-24` (les deux shells peuvent avancer en parallèle une fois
`FM-22` mergée) → `FM-26` (gain immédiat, quelques lignes) → `FM-27`/`FM-28` (le plus
gros morceau, cœur du produit) → le reste peut s'ordonner librement selon la
disponibilité. `BE-44` est à ouvrir tôt côté backend : elle débloque 4 issues mobiles
d'un coup.

---

## 5. Tableau des issues

| ID | Titre | Est. | Dépend de | Bloquée par (externe) |
|---|---|---|---|---|
| `FM-15` | Générateur de tokens : élévation, motion, tracking, icônes, nouveaux rôles | 4 h | — | — |
| `FM-16` | ThemeData complet : TextTheme M3 et sous-thèmes de composants | 3 h | FM-15 | — |
| `FM-17` | Persistance du thème et accessibilité (contraste AA, TextScaler) | 2 h | FM-15 | — |
| `FM-18` | Garde-fou CI anti-valeurs-en-dur et vitrine `/_ds-preview` enrichie | 3 h | FM-15, FM-16 | — |
| `FM-19` | Clés i18n de navigation FR/AR | 1 h | — | — |
| `FM-22` | Widget partagé `AppBottomNav` | 2 h | FM-15, FM-19 | — |
| `FM-23` | Shell client : navigation à 4 onglets + suppression du hub de dev | 5 h | FM-22 | — |
| `FM-24` | Shell pro : navigation à 4 onglets, dashboard comme racine | 4 h | FM-22 | — |
| `FM-25` | Corriger la déconnexion + bascule Client ↔ Pro | 2 h | FM-23, FM-24 | — |
| `FM-26` | Câbler les écrans déjà construits mais orphelins | 2 h | FM-23 | — |
| `FM-27` | Widgets partagés de recherche : chip de filtre, carte artisan, barre | 3 h | FM-15, FM-16 | — |
| `FM-28` | Écran de résultats de recherche : pagination, filtres, cache disque | 5 h | FM-27, FM-23 | — |
| `FM-29` | Refonte fiche artisan : couverture plein-écran et avatar (RTL) | 3 h | FM-15 | — |
| `FM-30` | Refonte contact et avis : bouton contour, en-tête d'identité | 2 h | FM-15, FM-29 | — |
| `FM-31` | Onglet Historique client | 3 h | FM-23 | ⛔ `BE-45` |
| `FM-32` | Onglet Profil client | 2 h | FM-23, FM-25 | — |
| `FM-33` | Refonte authentification : marque, mention légale, bouton Confirmer | 3 h | FM-15, FM-16 | — |
| `FM-34` | Refonte onboarding pro : étapes, catégories, plafonds | 4 h | FM-15, FM-16, FM-24 | — |
| `FM-35` | Étape photos/portfolio de l'onboarding | 3 h | FM-34 | — |
| `FM-36` | Reprise de l'onboarding après fermeture | 2 h | FM-34 | ⛔ `BE-44` |
| `FM-37` | Refonte tableau de bord pro : salutation, KPI, histogramme | 4 h | FM-15, FM-16, FM-24 | `BE-44`/`BE-46` partiels |
| `FM-38` | Écran Profil pro : édition et disponibilité commutable | 3 h | FM-24 | ⛔ `BE-44` |
| `FM-39` | Écran Avis reçus (pro) | 2 h | FM-24 | ⛔ `BE-44` |
| `FM-40` | Écran Boosts/crédits — coquille visuelle | 3 h | FM-15, FM-16, FM-24 | ⛔ EP-BILLING/ADR-004 |
| `FM-41` | Composants partagés transverses : Badge, carte sélectionnable, bottom sheet | 3 h | FM-15, FM-16 | — |
| `FM-42` | Adoption systématique des états + bandeau hors ligne | 3 h | FM-23, FM-24, FM-41 | — |
| `FM-43` | Passe accessibilité : Semantics, TextScaler, contraste | 3 h | FM-22, FM-27, FM-29, FM-33, FM-34, FM-37 | — |
| `BE-44` | `GET /v1/providers/me` — lire son propre profil | 3 h | — | — |
| `BE-45` | `GET /v1/contact-events` — historique de lecture | 3 h | — | — |
| `BE-46` | Ventilation des contacts par canal dans les stats | 2 h | — | — |
| `BE-47` | Écriture des `offerings` (tarifs) sous `/providers/me/*` | 3 h | — | — |

**Total : 31 issues, ~93 h.** À comparer aux ~53 h du lot mobile de S1 (FM-01→FM-14) :
cette refonte est un effort du même ordre de grandeur, ce qui confirme le diagnostic de
l'audit — compléter le design de l'app est un second sprint, pas une session de
polish.

---

## 6. Ce qui reste explicitement hors périmètre de ce plan

- **Le tunnel de paiement réel** (achat de crédits, activation de boost, renouvellement
  Pack Pro) — dépend d'EP-BILLING, bloquée par l'ADR-004 (question 2 du cadrage, moyens
  de paiement). `FM-40` ne couvre que la coquille visuelle.
- **La réponse de l'artisan à un avis** — `BE-22b`, backlog non planifié, aucun modèle
  Prisma. Notée comme point d'extension désactivé dans `FM-39`.
- **L'étape « Tarifs » de l'onboarding** — dépend de `BE-47`, elle-même nouvelle. Une
  fois `BE-47` livrée, ouvrir une issue mobile dédiée (non créée ici pour ne pas designer
  contre un contrat encore hypothétique).
- **Les notes par critère du formulaire d'avis** (Ponctualité, Qualité du travail —
  maquette B5) — nécessitent une évolution du contrat `POST /providers/{id}/reviews`.
  Non incluses : à arbitrer avec le lead avant d'ouvrir une issue backend, le gain
  produit n'étant pas évident face au coût de migration.
- **Le deep-linking entrant** (Android App Links / Universal Links) — décision produit et
  infrastructure (domaine, `assetlinks.json`) hors du périmètre design.
- **La refonte du back-office admin** (planche D) — c'est `apps/admin`, hors périmètre
  mobile par définition, déjà couvert par `EP-ADMIN`.
- **L'asset de logo/marque** — aucun fichier n'existe dans `assets/` ; `FM-33` prévoit un
  espace réservé neutre en son absence plutôt que de bloquer sur cet actif.

---

## 7. Notes pour la suite

- Les décisions du §3 sont des **hypothèses de travail**, pas des arbitrages du lead.
  Si l'une d'elles est fausse, corriger l'issue concernée avant de commencer — le coût
  d'une mauvaise lecture de maquette découverte après coup est bien plus élevé que 5
  minutes de relecture avant de démarrer.
- `FM-15` conditionne presque tout : c'est la priorité absolue de ce plan.
- Deux vraies anomalies fonctionnelles ont été trouvées en chemin, hors périmètre
  strictement « design » mais à corriger dans les mêmes PR que les issues qui les
  touchent (documenté dans chaque issue concernée) : une erreur de chargement des avis
  affichée comme une absence d'avis (`FM-42`), et une déconnexion qui ne déconnecte
  jamais réellement (`FM-25`).
- Comme pour FM-02/FM-11/FM-12 en S1, chaque issue de ce plan est dimensionnée pour être
  découpée en sous-PRs atomiques (`<ID>a`, `<ID>b`…) au moment de l'exécution plutôt que
  pré-découpée ici — c'est le patron déjà établi et documenté dans `backlog/DOING.md`.
