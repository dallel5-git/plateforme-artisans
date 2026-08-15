# Document de Cadrage Technique — Plateforme de mise en relation Clients ⇄ Artisans (Tunisie)

> **Nom de code projet** : `Sanaya` (à ajuster) — Marketplace de mise en relation (lead generation), **sans intermédiation de paiement de la prestation**.
> **Version** : 1.0 — Cadrage pré-développement
> **Portée** : Web (Client / Vitrine SEO / Back-Office Admin) + Mobile (Client / Prestataire)
> **Statut** : Aucun code applicatif produit à ce stade. Ce document est le contrat technique de référence.

---

## Sommaire

0. [Principes directeurs d'architecture](#0-principes-directeurs-darchitecture)
1. [User Stories complètes & critères d'acceptation](#1-user-stories-complètes--critères-dacceptation)
2. [Architecture de la base de données](#2-architecture-de-la-base-de-données)
3. [Stack technique & stratégie de partage de code](#3-stack-technique--stratégie-de-partage-de-code-max-code-sharing)
4. [Arborescence du monorepo](#4-arborescence-du-monorepo)
5. [Annexes techniques](#5-annexes-techniques)
6. [Questions de clarification](#6-questions-de-clarification)

---

## 0. Principes directeurs d'architecture

Avant toute décision technique, on fixe les invariants. Toute décision ultérieure devra être justifiable par rapport à ces principes.

| # | Principe | Implication concrète |
|---|---|---|
| P1 | **Modular Monolith first, pas de microservices** | Un seul déploiement serveur, mais découpé en **modules métier étanches** (`auth`, `catalog`, `providers`, `reviews`, `billing`, `ads`, `moderation`, `analytics`). Chaque module expose une API publique (`index.ts`) ; l'import de fichiers internes d'un autre module est interdit par lint. Extraction ultérieure en service possible sans refonte. |
| P2 | **Le contrat d'API est du TypeScript, pas de la doc** | tRPC + Zod : le typage traverse la frontière réseau. Web, Mobile et Admin consomment **le même routeur typé**. Zéro dérive de contrat, zéro client HTTP écrit à la main. |
| P3 | **La logique métier ne connaît ni React ni HTTP** | Les règles (calcul de ranking, éligibilité d'un boost, expiration d'abonnement, droit de laisser un avis) vivent dans `packages/core`, testables en isolation avec Vitest, sans base ni serveur. |
| P4 | **Une seule source de vérité pour les données** | Prisma schema = source unique. Types, validateurs Zod et migrations en découlent. Pas de types dupliqués à la main. |
| P5 | **Mobile-first, low-bandwidth-first** | Le marché cible utilise majoritairement du 3G/4G sur mobile Android d'entrée de gamme. Images en WebP/AVIF servies par CDN avec variantes, pagination par curseur, cache offline (TanStack Query persister). |
| P6 | **Le SEO est un canal d'acquisition critique** | Le Web n'est pas un simple miroir du mobile : pages `/[gouvernorat]/[service]` en SSG/ISR, données structurées Schema.org `LocalBusiness`, sitemap dynamique. C'est ce qui remplace les groupes Facebook dans Google. |
| P7 | **Bilingue FR/AR + RTL dès le jour 1** | L'i18n n'est jamais rétrofittable proprement. Clés de traduction, formatage des nombres/dates, et gestion RTL intégrés dès le socle UI. |
| P8 | **Conformité INPDP dès la conception** | La CIN est une donnée personnelle sensible (loi organique n°2004-63). Stockage chiffré, bucket privé, URLs signées à durée courte, purge automatique après validation, journal d'accès. |
| P9 | **Tout événement de valeur est traçable** | Vue de profil, clic téléphone, clic WhatsApp, impression en recherche : ce sont les KPI qui justifient l'abonnement Pro auprès de l'artisan. Sans mesure fiable, pas de monétisation défendable. |
| P10 | **Anti-fraude structurel** | Le modèle freemium se fait attaquer par : faux avis, faux comptes artisans, gonflage artificiel de vues. Déduplication par empreinte de session, avis liés à un contact réel, rate limiting, modération a posteriori. |

### Architecture logique (vue macro)

```
┌───────────────┐   ┌───────────────┐   ┌───────────────┐
│  apps/web     │   │ apps/mobile   │   │  apps/admin   │
│  Next.js      │   │ Expo RN       │   │  Next.js      │
│ (Client+SEO)  │   │(Client+Artisan│   │ (Back-office) │
└───────┬───────┘   └───────┬───────┘   └───────┬───────┘
        │                   │                   │
        └────────── tRPC (HTTP/JSON, typé E2E) ─┘
                            │
                ┌───────────▼────────────┐
                │  packages/api          │  Couche transport
                │  routers + middlewares │  (auth, rbac, rate-limit, logs)
                └───────────┬────────────┘
                            │
                ┌───────────▼────────────┐
                │  packages/core         │  Domaine métier pur
                │  services + policies   │  (règles, ranking, éligibilité)
                └───────────┬────────────┘
                            │
     ┌──────────────┬───────┴───────┬──────────────┬─────────────┐
     │ packages/db  │ packages/     │ packages/    │ packages/   │
     │ Prisma       │ storage (S3)  │ notifications│ payments    │
     │ PostgreSQL   │ images/CIN    │ SMS/Push/WA  │ Konnect/... │
     └──────────────┴───────────────┴──────────────┴─────────────┘
                            │
                ┌───────────▼────────────┐
                │  apps/worker           │  Jobs asynchrones
                │  BullMQ + Redis        │  (agrégats, expirations, mails)
                └────────────────────────┘
```

---

## 1. User Stories complètes & critères d'acceptation

**Convention de nommage** : `US-<RÔLE>-<n>` — `C` = Client, `P` = Prestataire, `A` = Admin, `T` = Transverse.
**Priorisation MoSCoW** : `M` = Must (MVP), `S` = Should (V1.1), `C` = Could (V2), `W` = Won't (hors périmètre initial).

---

### 1.1 Épiques transverses

| Épique | Code | Description |
|---|---|---|
| Authentification & Compte | `EP-AUTH` | Inscription, OTP SMS, sessions, rôles |
| Découverte & Recherche | `EP-SEARCH` | Recherche géolocalisée, filtres, tri, SEO |
| Profil Prestataire | `EP-PROFILE` | Vitrine artisan, galerie, tarifs |
| Mise en relation | `EP-CONTACT` | Appel, WhatsApp, traçabilité |
| Confiance & Réputation | `EP-TRUST` | Avis, vérification CIN, badges, signalements |
| Monétisation | `EP-BILLING` | Abonnements, boosts, paiements |
| Régie publicitaire | `EP-ADS` | Bannières B2B ciblées |
| Back-Office | `EP-ADMIN` | Modération, validation, pilotage |
| Analytics & Notifications | `EP-INSIGHT` | Statistiques artisan, push, alertes |

---

### 1.2 👤 Utilisateur / Client

#### `US-C-01` — Recherche géolocalisée par service et localisation `[M]`
> **En tant que** client particulier, **je veux** rechercher des artisans par catégorie de service et par gouvernorat/délégation, **afin de** trouver rapidement un professionnel disponible près de chez moi.

**Critères d'acceptation**
- Le formulaire de recherche expose : `catégorie de service` (obligatoire ou "toutes"), `gouvernorat` (obligatoire), `délégation` (optionnelle).
- La liste des 24 gouvernorats et de leurs délégations est chargée depuis un référentiel serveur (pas de saisie libre).
- Si la géolocalisation navigateur/appareil est autorisée, le gouvernorat et la délégation sont pré-remplis automatiquement ; en cas de refus, l'expérience reste 100 % fonctionnelle en saisie manuelle.
- Les résultats affichent : photo, nom, badge « Artisan Vérifié » le cas échéant, note moyenne + nombre d'avis, catégories principales, fourchette de tarifs indicative, zone d'intervention.
- Résultats paginés par curseur, 20 par page, temps de réponse P95 < 500 ms.
- Un état vide explicite est affiché s'il n'y a aucun résultat, avec suggestion d'élargir à la délégation voisine ou au gouvernorat entier.
- La recherche fonctionne en français et en arabe (recherche insensible aux accents et à la casse).

#### `US-C-02` — Filtrer et trier les résultats `[M]`
> **En tant que** client, **je veux** filtrer et trier les résultats, **afin de** cibler l'artisan qui correspond le mieux à mon besoin et à mon budget.

**Critères d'acceptation**
- Filtres : `Artisan Vérifié uniquement`, `note ≥ X`, `fourchette de prix`, `disponible aujourd'hui`, `intervention en urgence`, `sous-catégorie`.
- Tris : `Pertinence` (défaut), `Mieux notés`, `Plus proches`, `Plus récents`.
- Les filtres actifs sont reflétés dans l'URL sur le Web (partageable, indexable) et persistés en state sur mobile.
- Le tri « Pertinence » applique l'algorithme de ranking défini en [Annexe A](#annexe-a--algorithme-de-ranking) ; les emplacements sponsorisés (boosts) sont **visuellement identifiés** par une mention « Sponsorisé ».
- Un bouton « Réinitialiser les filtres » est toujours accessible.

#### `US-C-03` — Consulter un profil détaillé d'artisan `[M]`
> **En tant que** client, **je veux** consulter le profil complet d'un artisan, **afin d'**évaluer sa fiabilité avant de le contacter.

**Critères d'acceptation**
- Le profil affiche : identité professionnelle, bio, années d'expérience, badge de vérification, catégories et prestations avec tarifs indicatifs (unité : forfait / heure / m² / à négocier), zones d'intervention, galerie de réalisations, note moyenne + distribution des étoiles, liste des avis, horaires de disponibilité, langues parlées.
- La galerie supporte le plein écran, le swipe, le lazy-loading et un placeholder en cas d'échec réseau.
- Le numéro de téléphone n'est pas affiché en texte brut dans le HTML source (protection anti-scraping) ; il est révélé au clic via un appel API tracé.
- Chaque affichage de profil incrémente le compteur de vues **dédupliqué** (voir `US-P-08`).
- Le profil est accessible sans compte (consultation anonyme autorisée).
- Page web accessible via une URL canonique lisible : `/artisans/[slug]-[id-court]`, avec balises Open Graph et JSON-LD `LocalBusiness`.

#### `US-C-04` — Contacter directement l'artisan (appel / WhatsApp) `[M]`
> **En tant que** client, **je veux** appeler l'artisan ou lui écrire sur WhatsApp en un clic, **afin d'**entrer en relation immédiatement sans intermédiaire.

**Critères d'acceptation**
- Deux CTA distincts : « Appeler » (`tel:`) et « WhatsApp » (`https://wa.me/216XXXXXXXX?text=...`).
- Le message WhatsApp est pré-rempli et localisé : nom du service, gouvernorat, mention de la provenance (nom de la plateforme).
- Chaque clic crée un enregistrement `ContactEvent` (prestataire, canal, catégorie, horodatage, client si connecté) **avant** l'ouverture du lien externe, en mode « fire-and-forget » non bloquant pour l'UX.
- Sur mobile, si WhatsApp n'est pas installé, un fallback vers le web WhatsApp ou vers l'appel est proposé.
- Un rate limit anti-abus est appliqué (max N contacts / heure / appareil).
- 24 h après le contact, le client reçoit une notification l'invitant à laisser un avis (voir `US-C-06`).

#### `US-C-05` — Créer un compte et se connecter par numéro de téléphone `[M]`
> **En tant que** client, **je veux** créer un compte via mon numéro de téléphone et un code OTP, **afin de** pouvoir laisser des avis et retrouver mes favoris.

**Critères d'acceptation**
- Inscription par numéro tunisien au format `+216 XX XXX XXX`, validé côté client et serveur.
- Code OTP à 6 chiffres envoyé par SMS, valide 5 minutes, 3 tentatives maximum, renvoi possible après 60 s.
- Le compte est créé au premier OTP validé (pas de formulaire long) ; nom et photo sont demandés ensuite, de façon optionnelle.
- Email et mot de passe restent optionnels pour le client, obligatoires pour le prestataire.
- Session persistante via refresh token stocké en `SecureStore` (mobile) / cookie `httpOnly` `SameSite=Lax` (web).
- La consultation et la recherche restent accessibles **sans** compte ; seules les actions à effet (avis, favoris, signalement) exigent l'authentification.

#### `US-C-06` — Laisser un avis certifié `[M]`
> **En tant que** client, **je veux** noter et commenter un artisan après une intervention, **afin d'**aider la communauté et récompenser le travail de qualité.

**Critères d'acceptation**
- L'avis n'est possible que si un `ContactEvent` existe entre ce client et cet artisan, datant de plus de 12 h et de moins de 60 jours → mention « Avis certifié » affichée.
- Note obligatoire de 1 à 5 étoiles ; commentaire optionnel (max 1000 caractères) ; sous-notes optionnelles : ponctualité, qualité, rapport qualité/prix.
- Un seul avis par `ContactEvent` (contrainte d'unicité en base).
- L'avis passe en statut `PENDING` puis est publié automatiquement après filtrage anti-spam ; il est mis en `FLAGGED` si détection de coordonnées téléphoniques, d'insultes ou d'URLs.
- La note moyenne et le compteur d'avis de l'artisan sont recalculés de façon transactionnelle.
- Le client peut modifier son avis dans les 48 h, puis plus du tout ; il peut le supprimer à tout moment (recalcul des agrégats).
- L'artisan reçoit une notification push à la publication.

#### `US-C-07` — Consulter et signaler des avis `[M]`
> **En tant que** client, **je veux** lire les avis d'autres clients et pouvoir signaler un contenu abusif, **afin de** me fier à une information fiable.

**Critères d'acceptation**
- Avis triés par date décroissante ; filtres par note ; affichage de la réponse de l'artisan sous l'avis concerné.
- Bouton « Signaler » sur chaque avis, avec choix d'un motif (faux avis, contenu injurieux, hors sujet, spam, autre) et commentaire libre.
- Un même utilisateur ne peut signaler qu'une seule fois le même contenu.
- Confirmation visuelle immédiate ; le signalement entre dans la file de modération admin.

#### `US-C-08` — Enregistrer des artisans en favoris `[S]`
> **En tant que** client, **je veux** enregistrer des artisans en favoris, **afin de** les retrouver rapidement lors d'un besoin futur.

**Critères d'acceptation**
- Icône cœur sur la carte et sur le profil, avec état optimiste et synchronisation serveur.
- Écran/page « Mes favoris » listant les artisans sauvegardés avec accès direct aux CTA de contact.
- Nécessite un compte : si non connecté, ouverture du flux de connexion puis reprise de l'action.

#### `US-C-09` — Historique de mes contacts `[S]`
> **En tant que** client, **je veux** consulter la liste des artisans que j'ai contactés, **afin de** relancer un professionnel ou laisser un avis en attente.

**Critères d'acceptation**
- Liste chronologique : artisan, catégorie, canal utilisé, date.
- Badge « Avis en attente » avec CTA direct vers le formulaire d'avis quand l'avis est possible et non encore déposé.
- Possibilité de supprimer un élément de son historique (masquage côté client, conservation anonymisée pour les statistiques de l'artisan).

#### `US-C-10` — Publier une demande d'intervention (« Besoin urgent ») `[C]`
> **En tant que** client, **je veux** décrire mon besoin une seule fois et être rappelé par des artisans disponibles, **afin d'**éviter d'appeler dix personnes une par une.

**Critères d'acceptation**
- Formulaire : catégorie, description, gouvernorat/délégation, photos optionnelles, créneau souhaité, budget indicatif.
- La demande est notifiée aux artisans **Pack Pro** de la catégorie et de la zone (les comptes gratuits la reçoivent avec 30 min de décalage — levier de conversion mesurable).
- Le client voit la liste des artisans ayant manifesté leur intérêt et choisit qui contacter.
- La demande expire automatiquement après 48 h.
- Le numéro du client n'est révélé qu'aux artisans qu'il sélectionne.

#### `US-C-11` — Naviguer en français ou en arabe `[M]`
> **En tant que** client, **je veux** utiliser l'application dans ma langue, **afin de** comprendre parfaitement l'offre.

**Critères d'acceptation**
- Sélecteur de langue FR/AR accessible depuis les paramètres ; détection automatique à la première ouverture selon la locale de l'appareil.
- Bascule complète en RTL pour l'arabe (mise en page, icônes directionnelles, alignements).
- Les noms de gouvernorats, délégations et catégories sont stockés en base dans les deux langues.
- Formatage des dates, nombres et montants (TND, 3 décimales / millimes) localisé.

#### `US-C-12` — Consulter la vitrine et les pages SEO locales `[M]`
> **En tant que** client arrivant depuis Google, **je veux** atterrir sur une page listant les artisans de mon métier et de ma ville, **afin de** trouver une solution sans installer d'application.

**Critères d'acceptation**
- Routes statiques/ISR : `/plombier/tunis`, `/climatisation/sfax`, etc., générées pour chaque couple (catégorie × gouvernorat) pertinent.
- Contenu unique par page : intro localisée, top artisans, FAQ, tarifs moyens observés.
- `sitemap.xml` et `robots.txt` générés dynamiquement ; balises canoniques et hreflang FR/AR.
- Score Lighthouse ≥ 90 en Performance / SEO / Accessibilité sur mobile.
- Bandeau d'installation de l'app (smart banner) non intrusif.

#### `US-C-13` — Gérer mes données personnelles `[S]`
> **En tant que** client, **je veux** exporter ou supprimer mon compte et mes données, **afin de** garder le contrôle sur ma vie privée.

**Critères d'acceptation**
- Écran « Confidentialité » : export JSON de mes données, suppression de compte avec double confirmation.
- La suppression anonymise les avis (conservés pour l'intégrité de la note) et efface les données identifiantes sous 30 jours.
- Consentement explicite et horodaté aux CGU et à la politique de confidentialité à l'inscription, avec versionnage du texte accepté.

---

### 1.3 🔧 Prestataire / Artisan

#### `US-P-01` — S'inscrire en tant qu'artisan `[M]`
> **En tant qu'**artisan, **je veux** créer un compte professionnel guidé, **afin d'**être visible auprès des clients de ma région.

**Critères d'acceptation**
- Parcours d'onboarding en étapes courtes avec barre de progression et sauvegarde d'un brouillon à chaque étape : (1) téléphone + OTP, (2) identité et photo, (3) métiers, (4) zones d'intervention, (5) tarifs, (6) galerie, (7) vérification CIN.
- Le profil n'est publié qu'une fois un score de complétude minimal atteint (téléphone vérifié + ≥ 1 catégorie + ≥ 1 zone + bio ≥ 50 caractères).
- Un indicateur « Profil complété à X % » avec les actions restantes est affiché en permanence sur le tableau de bord.
- Un utilisateur existant en tant que client peut devenir prestataire sans créer un second compte (ajout du rôle).
- Le numéro WhatsApp peut différer du numéro de connexion.

#### `US-P-02` — Renseigner mes métiers et prestations `[M]`
> **En tant qu'**artisan, **je veux** déclarer mes compétences et prestations, **afin d'**apparaître dans les bonnes recherches.

**Critères d'acceptation**
- Sélection multiple de catégories/sous-catégories dans un référentiel fermé (climatisation, plomberie, électricité, réparation d'électroménager, peinture, petits travaux, déménagement, + sous-catégories).
- Une catégorie principale doit être désignée.
- Limite : 3 catégories en offre gratuite, 8 en Pack Pro (règle centralisée dans `packages/core/policies`).
- Chaque prestation peut porter un intitulé, une description, un prix min/max et une unité (`FORFAIT`, `HEURE`, `JOUR`, `M2`, `SUR_DEVIS`).
- Les tarifs sont explicitement présentés comme **indicatifs** côté client.

#### `US-P-03` — Définir mes zones d'intervention `[M]`
> **En tant qu'**artisan, **je veux** définir précisément où je me déplace, **afin de** ne recevoir que des demandes pertinentes.

**Critères d'acceptation**
- Sélection d'un ou plusieurs gouvernorats, avec possibilité d'affiner par délégations.
- Option « tout le gouvernorat » en un clic.
- Limite : 1 gouvernorat en offre gratuite, illimité en Pack Pro.
- Frais de déplacement optionnels par zone.
- Aperçu instantané : « Vous apparaîtrez dans X délégations ».

#### `US-P-04` — Publier une galerie de réalisations `[M]`
> **En tant qu'**artisan, **je veux** publier des photos de mes chantiers, **afin de** prouver la qualité de mon travail.

**Critères d'acceptation**
- Upload depuis la galerie ou l'appareil photo, compression client avant envoi (max 2 Mo par image après compression), formats JPG/PNG/HEIC/WebP.
- Limite : 5 photos en gratuit, 30 en Pack Pro.
- Réordonnancement par glisser-déposer, légende et catégorie rattachée optionnelles.
- Les images passent par une modération automatique (détection de contenu inapproprié) puis sont publiées ; l'admin peut les retirer a posteriori.
- Génération serveur de variantes (thumbnail 200 px, card 600 px, full 1600 px) en WebP, servies via CDN.
- Barre de progression et reprise d'upload en cas de coupure réseau.

#### `US-P-05` — Soumettre ma CIN pour obtenir le badge « Artisan Vérifié » `[M]`
> **En tant qu'**artisan, **je veux** faire vérifier mon identité, **afin d'**obtenir le badge de confiance et d'être davantage contacté.

**Critères d'acceptation**
- Upload de la CIN recto + verso, plus un selfie tenant la pièce ; documents optionnels : patente, diplôme, attestation d'assurance.
- Une notice claire précise la finalité, la durée de conservation et le droit d'accès (conformité INPDP).
- Les fichiers sont stockés dans un bucket **privé et chiffré** ; l'accès admin se fait via URL signée expirant en 5 minutes, chaque accès étant journalisé.
- Statuts visibles par l'artisan : `NON_SOUMIS` → `EN_ATTENTE` → `VÉRIFIÉ` | `REJETÉ` (avec motif lisible et possibilité de resoumettre).
- SLA affiché : traitement sous 48 h ouvrées ; notification push et SMS à chaque changement de statut.
- Le badge « Artisan Vérifié » apparaît sur la carte de résultat, le profil et les avis.
- Après validation, les images de CIN sont purgées automatiquement à J+X (paramétrable), seuls le hash du numéro et la trace d'audit sont conservés.

#### `US-P-06` — Gérer ma disponibilité `[S]`
> **En tant qu'**artisan, **je veux** indiquer si je suis disponible, **afin de** ne pas recevoir d'appels quand je suis en chantier ou en congé.

**Critères d'acceptation**
- Interrupteur « Disponible / Occupé » en un geste depuis le tableau de bord, avec retour en disponible automatique à la date choisie.
- Horaires d'ouverture hebdomadaires + interventions d'urgence 24/7 (oui/non).
- Les artisans « Occupés » sont rétrogradés dans le classement mais restent visibles avec un badge d'état explicite.
- Mode « Vacances » masquant temporairement le profil sans suspendre l'abonnement (la durée d'abonnement est prolongée d'autant, dans une limite de 30 jours par an).

#### `US-P-07` — Accéder à mon tableau de bord de performance `[M]`
> **En tant qu'**artisan, **je veux** voir combien de personnes consultent mon profil et me contactent, **afin de** mesurer le retour sur mon abonnement.

**Critères d'acceptation**
- KPI sur 7 / 30 / 90 jours : vues de profil, vues uniques, impressions en recherche, clics « Appeler », clics « WhatsApp », taux de conversion vue → contact, position moyenne en recherche.
- Graphique d'évolution quotidienne et comparaison avec la période précédente (± %).
- Répartition des contacts par catégorie et par délégation.
- Encart de comparaison anonymisée : « Les artisans Pack Pro de votre catégorie reçoivent en moyenne N contacts / mois » (levier de conversion).
- Données issues d'agrégats précalculés (`DailyProviderStat`) — temps de chargement < 300 ms, fraîcheur ≤ 1 h.

#### `US-P-08` — Fiabilité des statistiques `[M]`
> **En tant qu'**artisan, **je veux** que les statistiques soient honnêtes, **afin de** pouvoir faire confiance à la plateforme.

**Critères d'acceptation**
- Une vue est comptée une fois par empreinte de session et par jour ; les vues de l'artisan sur son propre profil sont exclues.
- Les bots et crawlers connus sont exclus (filtrage user-agent + heuristiques de fréquence).
- Une mention explicite décrit la méthode de comptage dans l'écran de statistiques.
- Les compteurs bruts et dédupliqués sont conservés séparément pour audit interne.

#### `US-P-09` — Souscrire au Pack Pro `[M]`
> **En tant qu'**artisan, **je veux** m'abonner au Pack Pro, **afin d'**être mis en avant et d'accéder aux fonctionnalités avancées.

**Critères d'acceptation**
- Page de comparaison Gratuit vs Pack Pro : limites de catégories, zones, photos, badge, priorité de classement, accès aux demandes urgentes en temps réel, statistiques avancées.
- Tarification mensuelle de 35 à 60 TND selon la formule (mensuel / trimestriel / annuel avec remise), montants stockés en `Decimal(10,3)` (millimes).
- Moyens de paiement : **en ligne** (Konnect / Paymee / Flouci / ClicToPay — voir Q2), **virement bancaire** avec upload du justificatif, **espèces** via agent commercial avec code de collecte.
- Après paiement en ligne validé, l'abonnement est actif immédiatement ; pour les paiements manuels, il est en `EN_ATTENTE_VALIDATION` jusqu'à confirmation admin.
- Facture PDF téléchargeable, numérotée séquentiellement.
- Rappels automatiques à J-7, J-3 et J-1 avant expiration ; passage automatique en offre gratuite à l'échéance, avec conservation (non affichage) des données au-delà des quotas gratuits pendant 90 jours.
- Un seul abonnement actif par artisan (contrainte d'unicité partielle en base).

#### `US-P-10` — Acheter et activer des « Boosts » de visibilité `[M]`
> **En tant qu'**artisan, **je veux** acheter des crédits pour apparaître en tête de liste pendant les pics de demande, **afin de** capter davantage de clients au bon moment.

**Critères d'acceptation**
- Packs de crédits à l'unité (ex. 10 / 25 / 60 crédits) avec dégressivité tarifaire.
- Activation d'un boost ciblé : catégorie + gouvernorat (+ délégation optionnelle) + durée (24 h / 7 j / 30 j) ; coût en crédits affiché avant confirmation.
- L'artisan boosté apparaît dans un bloc en tête de liste, **explicitement libellé « Sponsorisé »**.
- Nombre maximal d'emplacements sponsorisés simultanés par couple (catégorie × zone) : plafonné (ex. 3) ; si complet, l'artisan voit la prochaine fenêtre disponible et peut réserver.
- Débit des crédits transactionnel et idempotent, avec historique complet du portefeuille (`CreditTransaction`).
- Statistiques dédiées par boost : impressions, clics, contacts générés, coût par contact.

#### `US-P-11` — Répondre publiquement aux avis `[S]`
> **En tant qu'**artisan, **je veux** répondre à un avis, **afin de** défendre ma réputation ou remercier un client.

**Critères d'acceptation**
- Une seule réponse par avis, éditable pendant 24 h, limitée à 500 caractères.
- La réponse est soumise à la même modération anti-spam que les avis.
- Notification push à l'artisan lors de la réception d'un nouvel avis, avec accès direct.

#### `US-P-12` — Contester un avis `[S]`
> **En tant qu'**artisan, **je veux** signaler un avis que j'estime frauduleux, **afin qu'**il soit examiné par la plateforme.

**Critères d'acceptation**
- Formulaire de contestation avec motif et pièces justificatives optionnelles.
- Pendant l'examen, l'avis reste visible mais l'artisan voit son statut « En cours d'examen ».
- Décision admin notifiée avec motivation ; en cas de retrait, recalcul immédiat de la note moyenne.
- Limite anti-abus : maximum 3 contestations en cours simultanément.

#### `US-P-13` — Recevoir des notifications utiles `[M]`
> **En tant qu'**artisan, **je veux** être alerté des événements importants, **afin de** ne pas rater d'opportunités.

**Critères d'acceptation**
- Événements notifiés : nouvel avis, changement de statut de vérification, expiration d'abonnement imminente, fin de boost, nouvelle demande urgente dans ma zone, résumé hebdomadaire de performance.
- Canaux : push (Expo Notifications), SMS pour les événements critiques (paiement, vérification), email si renseigné.
- Écran de préférences par type et par canal ; désactivation possible sauf notifications transactionnelles.
- Idempotence de l'envoi : aucun doublon en cas de retry du job.

#### `US-P-14` — Consulter mon historique de facturation `[S]`
> **En tant qu'**artisan, **je veux** retrouver mes paiements et factures, **afin de** tenir ma comptabilité.

**Critères d'acceptation**
- Liste : date, objet (abonnement / crédits), montant TND, moyen de paiement, statut, lien PDF.
- Filtrage par période et export CSV.

#### `US-P-15` — Mode double rôle Client/Artisan `[S]`
> **En tant qu'**artisan, **je veux** aussi utiliser l'application comme client, **afin de** trouver moi-même d'autres corps de métier.

**Critères d'acceptation**
- Bascule de contexte dans l'application mobile (« Espace Client » / « Espace Pro ») sans reconnexion.
- Aucune duplication de compte ; le rôle est une propriété du même utilisateur.
- Un artisan ne peut pas laisser d'avis sur lui-même ni sur un compte lié (même numéro/appareil) — règle anti-fraude.

---

### 1.4 🛡️ Administrateur (Back-Office)

#### `US-A-01` — Valider les demandes de vérification CIN `[M]`
> **En tant qu'**administrateur, **je veux** examiner les pièces d'identité soumises, **afin d'**attribuer le badge « Artisan Vérifié » de façon fiable.

**Critères d'acceptation**
- File d'attente triée par ancienneté, avec compteur de demandes en attente et filtre par statut.
- Écran d'examen : documents en visionneuse zoomable (URL signée 5 min), informations du profil en regard, historique des soumissions précédentes.
- Actions : `Approuver`, `Rejeter` (motif obligatoire choisi dans une liste + commentaire), `Demander un complément`.
- Toute action est journalisée dans `AuditLog` (admin, horodatage, avant/après) et notifiée à l'artisan.
- Le badge est attribué automatiquement à l'approbation ; il est retiré automatiquement en cas de suspension du compte.
- Accès à cet écran restreint au rôle `ADMIN`/`MODERATOR` avec 2FA obligatoire.

#### `US-A-02` — Modérer les avis et les signalements `[M]`
> **En tant qu'**administrateur, **je veux** traiter les avis signalés, **afin de** garantir la fiabilité de la réputation affichée.

**Critères d'acceptation**
- File unifiée des signalements (avis, réponses, photos, profils) avec motif, auteur du signalement, contenu incriminé et contexte.
- Actions : `Conserver`, `Masquer`, `Supprimer`, `Avertir l'auteur`, `Suspendre le compte`.
- Détection assistée : mise en évidence des avis suspects (rafale d'avis, même appareil, texte dupliqué, note extrême sans contact tracé).
- Recalcul automatique des agrégats de note après toute action modifiant la visibilité d'un avis.
- Journalisation exhaustive et notification motivée aux parties concernées.

#### `US-A-03` — Gérer les comptes et profils artisans `[M]`
> **En tant qu'**administrateur, **je veux** rechercher et administrer les comptes, **afin de** répondre au support et sanctionner les abus.

**Critères d'acceptation**
- Recherche par nom, téléphone, email, ID, statut, gouvernorat, catégorie.
- Fiche 360° : profil, statut de vérification, abonnement, paiements, statistiques, avis, signalements, journal d'activité.
- Actions : éditer le profil, suspendre / réactiver, forcer un statut de vérification, ajouter une note interne, se connecter en tant que (impersonation **lecture seule**, journalisée et limitée dans le temps).
- Toute donnée sensible (CIN, hash) est masquée par défaut, révélable via une action explicite tracée.

#### `US-A-04` — Gérer les abonnements et les paiements `[M]`
> **En tant qu'**administrateur, **je veux** enregistrer et valider les paiements, **afin de** suivre le chiffre d'affaires et activer les abonnements manuels.

**Critères d'acceptation**
- Liste des paiements filtrable par statut, moyen, période, agent collecteur.
- Saisie d'un paiement manuel : artisan, offre, montant, moyen (espèces / virement), date, référence, justificatif joint.
- Validation d'un paiement → activation ou prolongation automatique de l'abonnement avec date de fin recalculée.
- Actions : rembourser, annuler, prolonger à titre commercial (motif obligatoire).
- Tableau de bord financier : MRR, nouveaux abonnés, taux de churn, revenus par gouvernorat, revenus crédits vs abonnements vs publicité.
- Rapprochement automatique des paiements en ligne via webhook du prestataire de paiement, avec gestion de l'idempotence.

#### `US-A-05` — Gérer le référentiel (catégories, gouvernorats, délégations) `[M]`
> **En tant qu'**administrateur, **je veux** administrer les catégories de service et le découpage géographique, **afin d'**adapter la plateforme sans redéploiement.

**Critères d'acceptation**
- CRUD des catégories et sous-catégories : nom FR/AR, slug, icône, description, ordre d'affichage, activation.
- Consultation et activation/désactivation des gouvernorats et délégations (référentiel initialisé par seed).
- Impossible de supprimer une catégorie rattachée à des prestataires : proposition de désactivation ou de fusion vers une autre catégorie.
- Invalidation automatique du cache et régénération des pages SEO concernées.

#### `US-A-06` — Gérer les emplacements publicitaires B2B `[M]`
> **En tant qu'**administrateur, **je veux** vendre et diffuser des bannières ciblées, **afin de** monétiser l'audience auprès des quincailleries et marques.

**Critères d'acceptation**
- CRUD annonceurs (raison sociale, contact, secteur) et campagnes (période, budget, statut, montant facturé).
- Créations publicitaires : image (formats imposés par emplacement), titre, URL de destination, emplacement (`HOME_BANNER`, `SEARCH_INLINE`, `PROFILE_FOOTER`, `CATEGORY_HEADER`, `SPLASH_INTERSTITIEL`).
- Ciblage par gouvernorat(s) et catégorie(s) de service ; pondération/rotation entre créations éligibles.
- Comptage des impressions et des clics, dédupliqué par session ; rapport téléchargeable par campagne pour l'annonceur.
- Une campagne s'arrête automatiquement à sa date de fin ou à l'atteinte du plafond d'impressions.
- Les emplacements publicitaires sont visuellement distincts du contenu éditorial (mention « Publicité »).

#### `US-A-07` — Piloter l'activité (dashboard global) `[S]`
> **En tant qu'**administrateur, **je veux** un tableau de bord global, **afin de** suivre la santé de la plateforme.

**Critères d'acceptation**
- KPI : inscriptions clients/artisans, artisans vérifiés, contacts générés, avis publiés, note moyenne globale, taux de complétude des profils, MRR, top catégories, top gouvernorats.
- Filtres par période et export CSV.
- Alertes visuelles sur anomalies (chute de contacts, pic de signalements).

#### `US-A-08` — Gérer les rôles et les accès internes `[S]`
> **En tant qu'**administrateur, **je veux** attribuer des rôles à mon équipe, **afin de** limiter les accès selon les responsabilités.

**Critères d'acceptation**
- Rôles : `SUPER_ADMIN`, `ADMIN`, `MODERATOR`, `SUPPORT`, `SALES`, `FINANCE`.
- Matrice de permissions par module, appliquée **côté serveur** (les contrôles UI ne sont qu'un confort).
- 2FA obligatoire pour tout compte interne ; sessions expirant après inactivité.
- Journal d'audit consultable et filtrable, non modifiable.

#### `US-A-09` — Piloter la configuration métier sans redéploiement `[S]`
> **En tant qu'**administrateur, **je veux** modifier les paramètres clés depuis le back-office, **afin d'**ajuster l'économie du produit rapidement.

**Critères d'acceptation**
- Paramétrage : quotas gratuits/Pro, prix des offres et packs de crédits, poids de l'algorithme de ranking, nombre d'emplacements sponsorisés, délais SLA, feature flags.
- Chaque modification est versionnée, journalisée et applicable sans redémarrage.
- Environnement de préproduction permettant de tester un changement de ranking avant mise en production.

#### `US-A-10` — Communiquer avec les utilisateurs `[C]`
> **En tant qu'**administrateur, **je veux** envoyer des campagnes ciblées, **afin d'**animer la base et de convertir vers le Pack Pro.

**Critères d'acceptation**
- Composition d'un message push/SMS/email avec segmentation (rôle, gouvernorat, catégorie, statut d'abonnement, ancienneté).
- Prévisualisation, envoi de test, planification, respect des préférences de notification et des désinscriptions.
- Rapport d'envoi : délivrés, ouverts, clics.

---

### 1.5 ⚙️ Stories techniques transverses (à ne pas oublier au backlog)

| ID | Story | Prio |
|---|---|---|
| `US-T-01` | Mettre en place le monorepo, la CI/CD et les environnements (dev/staging/prod) | M |
| `US-T-02` | Seed du référentiel : 24 gouvernorats, ~264 délégations, catégories FR/AR | M |
| `US-T-03` | Pipeline d'upload et de traitement d'images (compression, variantes, CDN) | M |
| `US-T-04` | Intégration passerelle SMS tunisienne pour OTP + tolérance aux pannes (fallback fournisseur) | M |
| `US-T-05` | Observabilité : Sentry, logs structurés, traces, alerting | M |
| `US-T-06` | Jobs planifiés : agrégats quotidiens, expiration abonnements/boosts, purge CIN, rappels | M |
| `US-T-07` | Rate limiting et protection anti-abus (OTP, contacts, avis, uploads) | M |
| `US-T-08` | Sauvegardes automatisées PostgreSQL + procédure de restauration testée | M |
| `US-T-09` | Mises à jour OTA mobile (Expo Updates) et gestion des versions minimales requises | S |
| `US-T-10` | Suite de tests : unitaires (core), intégration (API), E2E (Playwright/Maestro) | S |
| `US-T-11` | Mode dégradé/offline mobile : cache des dernières recherches et favoris | S |
| `US-T-12` | Pages légales versionnées : CGU, CGV, politique de confidentialité, mentions INPDP | M |

---

## 2. Architecture de la base de données

### 2.1 Choix technologique : **PostgreSQL 16 (relationnel)** — décision ferme

| Critère | Analyse | Verdict |
|---|---|---|
| **Nature des données** | Le domaine est intrinsèquement relationnel et fortement contraint : un artisan a un profil, N catégories, N zones, N avis, 1 abonnement actif, N paiements. Les jointures sont la norme, pas l'exception. | ✅ SQL |
| **Intégrité transactionnelle** | Débit de crédits + activation de boost, validation de paiement + prolongation d'abonnement, publication d'avis + recalcul d'agrégat : autant d'opérations qui **doivent** être ACID. Une incohérence ici est un litige commercial. | ✅ SQL |
| **Requêtes de recherche** | Filtrage multi-critères (catégorie × zone × note × vérifié × disponible) avec tri pondéré : c'est exactement ce pour quoi le planificateur de requêtes SQL et les index composites/GIN sont conçus. En NoSQL documentaire, il faudrait dupliquer/dénormaliser massivement. | ✅ SQL |
| **Géospatial** | Extension **PostGIS** (ou `cube`/`earthdistance` pour un besoin plus léger) : recherche par rayon, tri par distance, index GiST. | ✅ SQL |
| **Recherche plein texte FR/AR** | `pg_trgm` + `unaccent` + `tsvector` couvrent le besoin sans moteur externe au démarrage ; migration vers Meilisearch/Typesense possible plus tard si le volume l'exige. | ✅ SQL |
| **Analytique** | Statistiques par artisan, MRR, cohortes : agrégations SQL + tables d'agrégats précalculées + vues matérialisées. | ✅ SQL |
| **Écosystème TypeScript** | Prisma offre un typage de bout en bout, des migrations versionnées et un excellent DX. C'est le socle du principe P4. | ✅ SQL |
| **Argument NoSQL** | Le seul avantage réel serait la flexibilité de schéma et le scaling horizontal en écriture. Or le schéma est stable et connu, et le volume attendu (quelques dizaines de milliers d'artisans, quelques millions d'événements/an) est **très loin** des limites d'un PostgreSQL managé mono-instance. | ❌ Rejeté |

**Décision** : **PostgreSQL 16** géré par **Prisma ORM**, hébergé sur Neon / Supabase / RDS (voir Q3).
**Compléments** :
- **Redis** (Upstash) : cache, rate limiting, files BullMQ, verrous distribués.
- **Champs `Json`** utilisés de façon ciblée et assumée pour les données à schéma variable : `Plan.features`, `AppSetting.value`, `AuditLog.before/after`, `Notification.data`. Ce n'est pas un fourre-tout.
- **Object storage S3-compatible** (Cloudflare R2 / Scaleway) : deux buckets, `public-media` (CDN) et `private-kyc` (chiffré, non public).

### 2.2 Schéma Prisma complet

```prisma
// =====================================================================
//  schema.prisma — Plateforme de mise en relation Clients ⇄ Artisans
//  Base : PostgreSQL 16 | ORM : Prisma
//  Convention : modèles PascalCase, tables snake_case via @@map
// =====================================================================

generator client {
  provider        = "prisma-client-js"
  previewFeatures = ["postgresqlExtensions", "fullTextSearchPostgres", "relationJoins"]
}

datasource db {
  provider   = "postgresql"
  url        = env("DATABASE_URL")
  directUrl  = env("DIRECT_DATABASE_URL")
  extensions = [pgcrypto, unaccent, pg_trgm, postgis, citext]
}

// =====================================================================
//  ENUMS
// =====================================================================

enum UserRole {
  CLIENT
  PROVIDER
  MODERATOR
  SUPPORT
  SALES
  FINANCE
  ADMIN
  SUPER_ADMIN
}

enum UserStatus {
  PENDING_VERIFICATION
  ACTIVE
  SUSPENDED
  DELETED
}

enum Locale {
  FR
  AR
  EN
}

enum ProviderPublicationStatus {
  DRAFT
  PUBLISHED
  HIDDEN        // masqué par l'artisan (mode vacances)
  SUSPENDED     // masqué par l'admin
}

enum AvailabilityStatus {
  AVAILABLE
  BUSY
  ON_HOLIDAY
}

enum VerificationStatus {
  NOT_SUBMITTED
  PENDING
  MORE_INFO_REQUIRED
  APPROVED
  REJECTED
}

enum VerificationDocumentType {
  CIN_FRONT
  CIN_BACK
  SELFIE_WITH_ID
  PATENTE
  DIPLOMA
  INSURANCE
  OTHER
}

enum MediaType {
  IMAGE
  VIDEO
  DOCUMENT
}

enum ModerationStatus {
  PENDING
  APPROVED
  REJECTED
  HIDDEN
}

enum PriceUnit {
  FIXED         // forfait
  HOUR
  DAY
  SQUARE_METER
  LINEAR_METER
  ON_QUOTE      // sur devis
}

enum ContactChannel {
  PHONE_CALL
  WHATSAPP
  IN_APP_MESSAGE
}

enum ReviewStatus {
  PENDING
  PUBLISHED
  FLAGGED
  HIDDEN
  REMOVED
}

enum ReportTargetType {
  REVIEW
  REVIEW_REPLY
  PROVIDER_PROFILE
  PORTFOLIO_ITEM
  SERVICE_REQUEST
}

enum ReportStatus {
  OPEN
  UNDER_REVIEW
  RESOLVED_ACTION_TAKEN
  RESOLVED_NO_ACTION
  DISMISSED
}

enum SubscriptionStatus {
  PENDING_PAYMENT
  ACTIVE
  GRACE_PERIOD
  EXPIRED
  CANCELED
}

enum PaymentMethod {
  CASH
  BANK_TRANSFER
  ONLINE_CARD
  ONLINE_WALLET  // e-DINAR, Flouci...
  FREE_GRANT     // geste commercial
}

enum PaymentStatus {
  PENDING
  AWAITING_VALIDATION
  PAID
  FAILED
  REFUNDED
  CANCELED
}

enum PaymentPurpose {
  SUBSCRIPTION
  CREDIT_PACK
  AD_CAMPAIGN
}

enum CreditTransactionReason {
  PURCHASE
  BOOST_SPEND
  BOOST_REFUND
  ADMIN_ADJUSTMENT
  WELCOME_BONUS
  EXPIRATION
}

enum BoostStatus {
  SCHEDULED
  ACTIVE
  COMPLETED
  CANCELED
}

enum AdPlacement {
  HOME_BANNER
  SEARCH_INLINE
  CATEGORY_HEADER
  PROFILE_FOOTER
  SPLASH_INTERSTITIAL
}

enum AdCampaignStatus {
  DRAFT
  SCHEDULED
  RUNNING
  PAUSED
  COMPLETED
  CANCELED
}

enum ServiceRequestStatus {
  OPEN
  MATCHED
  CLOSED
  EXPIRED
  CANCELED
}

enum NotificationChannel {
  PUSH
  SMS
  EMAIL
  IN_APP
}

enum NotificationType {
  NEW_REVIEW
  VERIFICATION_STATUS
  SUBSCRIPTION_EXPIRING
  SUBSCRIPTION_ACTIVATED
  BOOST_ENDED
  NEW_SERVICE_REQUEST
  WEEKLY_DIGEST
  REVIEW_REMINDER
  MODERATION_DECISION
  MARKETING
}

enum OtpPurpose {
  SIGNUP
  LOGIN
  PHONE_CHANGE
  PASSWORD_RESET
}

// =====================================================================
//  IDENTITÉ & AUTHENTIFICATION
// =====================================================================

model User {
  id             String     @id @default(uuid()) @db.Uuid
  phone          String     @unique @db.VarChar(20)   // format E.164 : +216XXXXXXXX
  phoneVerifiedAt DateTime?
  email          String?    @unique @db.Citext
  emailVerifiedAt DateTime?
  passwordHash   String?    @db.VarChar(255)          // Argon2id — optionnel (auth OTP)
  firstName      String?    @db.VarChar(80)
  lastName       String?    @db.VarChar(80)
  avatarMediaId  String?    @db.Uuid
  roles          UserRole[] @default([CLIENT])
  status         UserStatus @default(PENDING_VERIFICATION)
  locale         Locale     @default(FR)
  twoFactorSecret String?   @db.VarChar(255)
  lastLoginAt    DateTime?
  acceptedTermsVersion String? @db.VarChar(20)
  acceptedTermsAt      DateTime?
  marketingOptIn Boolean    @default(false)
  deletedAt      DateTime?
  createdAt      DateTime   @default(now())
  updatedAt      DateTime   @updatedAt

  avatar             MediaAsset?          @relation("UserAvatar", fields: [avatarMediaId], references: [id], onDelete: SetNull)
  providerProfile    ProviderProfile?
  sessions           Session[]
  otpCodes           OtpCode[]
  devices            DeviceToken[]
  notifications      Notification[]
  notificationPrefs  NotificationPreference[]
  favorites          Favorite[]
  reviewsWritten     Review[]             @relation("ClientReviews")
  contactEvents      ContactEvent[]       @relation("ClientContacts")
  profileViews       ProfileView[]        @relation("ViewerViews")
  serviceRequests    ServiceRequest[]     @relation("ClientRequests")
  reportsFiled       Report[]             @relation("ReportAuthor")
  searchLogs         SearchLog[]
  uploadedMedia      MediaAsset[]         @relation("MediaUploader")

  // --- Relations d'administration (acteur = compte interne) ---
  auditLogs             AuditLog[]             @relation("AuditActor")
  verificationsReviewed VerificationRequest[]  @relation("VerificationReviewer")
  reviewsModerated      Review[]               @relation("ReviewModerator")
  reportsHandled        Report[]               @relation("ReportHandler")
  paymentsValidated     Payment[]              @relation("PaymentValidator")
  creditAdjustments     CreditTransaction[]    @relation("CreditAdjuster")
  internalNotesWritten  AdminNote[]            @relation("NoteAuthor")

  @@index([status])
  @@index([createdAt])
  @@index([deletedAt])
  @@map("users")
}

model Session {
  id             String   @id @default(uuid()) @db.Uuid
  userId         String   @db.Uuid
  refreshTokenHash String @unique @db.VarChar(255)
  userAgent      String?  @db.VarChar(400)
  ipHash         String?  @db.VarChar(64)
  deviceLabel    String?  @db.VarChar(120)
  expiresAt      DateTime
  revokedAt      DateTime?
  createdAt      DateTime @default(now())

  user User @relation(fields: [userId], references: [id], onDelete: Cascade)

  @@index([userId, revokedAt])
  @@index([expiresAt])
  @@map("sessions")
}

model OtpCode {
  id         String     @id @default(uuid()) @db.Uuid
  userId     String?    @db.Uuid
  phone      String     @db.VarChar(20)
  codeHash   String     @db.VarChar(255)
  purpose    OtpPurpose
  attempts   Int        @default(0)
  maxAttempts Int       @default(3)
  expiresAt  DateTime
  consumedAt DateTime?
  ipHash     String?    @db.VarChar(64)
  createdAt  DateTime   @default(now())

  user User? @relation(fields: [userId], references: [id], onDelete: Cascade)

  @@index([phone, purpose, createdAt])
  @@index([expiresAt])
  @@map("otp_codes")
}

model DeviceToken {
  id         String   @id @default(uuid()) @db.Uuid
  userId     String   @db.Uuid
  token      String   @unique @db.VarChar(255)
  platform   String   @db.VarChar(20)          // ios | android | web
  appVersion String?  @db.VarChar(20)
  locale     Locale   @default(FR)
  lastSeenAt DateTime @default(now())
  disabledAt DateTime?
  createdAt  DateTime @default(now())

  user User @relation(fields: [userId], references: [id], onDelete: Cascade)

  @@index([userId, disabledAt])
  @@map("device_tokens")
}

// =====================================================================
//  RÉFÉRENTIELS : GÉOGRAPHIE & CATÉGORIES
// =====================================================================

model Governorate {
  id        String   @id @default(uuid()) @db.Uuid
  code      String   @unique @db.VarChar(10)   // ex: TN-11
  nameFr    String   @db.VarChar(80)
  nameAr    String   @db.VarChar(80)
  slug      String   @unique @db.VarChar(80)
  latitude  Decimal? @db.Decimal(9, 6)
  longitude Decimal? @db.Decimal(9, 6)
  isActive  Boolean  @default(true)
  sortOrder Int      @default(0)

  delegations      Delegation[]
  providers        ProviderProfile[]   @relation("ProviderBaseGovernorate")
  coverageAreas    CoverageArea[]
  boosts           Boost[]
  serviceRequests  ServiceRequest[]
  adTargets        AdCampaignGovernorate[]

  @@index([isActive])
  @@map("governorates")
}

model Delegation {
  id            String   @id @default(uuid()) @db.Uuid
  governorateId String   @db.Uuid
  code          String?  @db.VarChar(20)
  nameFr        String   @db.VarChar(120)
  nameAr        String   @db.VarChar(120)
  slug          String   @db.VarChar(120)
  postalCode    String?  @db.VarChar(10)
  latitude      Decimal? @db.Decimal(9, 6)
  longitude     Decimal? @db.Decimal(9, 6)
  isActive      Boolean  @default(true)

  governorate     Governorate       @relation(fields: [governorateId], references: [id], onDelete: Restrict)
  providers       ProviderProfile[] @relation("ProviderBaseDelegation")
  coverageAreas   CoverageArea[]
  boosts          Boost[]
  serviceRequests ServiceRequest[]

  @@unique([governorateId, slug])
  @@index([governorateId, isActive])
  @@map("delegations")
}

model Category {
  id          String    @id @default(uuid()) @db.Uuid
  parentId    String?   @db.Uuid
  slug        String    @unique @db.VarChar(80)
  nameFr      String    @db.VarChar(120)
  nameAr      String    @db.VarChar(120)
  descriptionFr String? @db.Text
  descriptionAr String? @db.Text
  iconKey     String?   @db.VarChar(60)
  colorHex    String?   @db.VarChar(7)
  isActive    Boolean   @default(true)
  sortOrder   Int       @default(0)
  seoTitleFr  String?   @db.VarChar(180)
  seoTitleAr  String?   @db.VarChar(180)
  createdAt   DateTime  @default(now())
  updatedAt   DateTime  @updatedAt

  parent           Category?           @relation("CategoryTree", fields: [parentId], references: [id], onDelete: Restrict)
  children         Category[]          @relation("CategoryTree")
  providerLinks    ProviderCategory[]
  serviceOfferings ServiceOffering[]
  portfolioItems   PortfolioItem[]
  contactEvents    ContactEvent[]
  boosts           Boost[]
  serviceRequests  ServiceRequest[]
  adTargets        AdCampaignCategory[]
  searchLogs       SearchLog[]

  @@index([parentId, isActive, sortOrder])
  @@map("categories")
}

// =====================================================================
//  PROFIL PRESTATAIRE
// =====================================================================

model ProviderProfile {
  id                 String   @id @default(uuid()) @db.Uuid
  userId             String   @unique @db.Uuid
  slug               String   @unique @db.VarChar(140)
  businessName       String   @db.VarChar(140)
  headline           String?  @db.VarChar(160)
  bio                String?  @db.Text
  yearsExperience    Int?
  whatsappPhone      String?  @db.VarChar(20)
  publicPhone        String?  @db.VarChar(20)
  spokenLanguages    Locale[] @default([FR, AR])

  baseGovernorateId  String   @db.Uuid
  baseDelegationId   String?  @db.Uuid
  latitude           Decimal? @db.Decimal(9, 6)
  longitude          Decimal? @db.Decimal(9, 6)

  publicationStatus  ProviderPublicationStatus @default(DRAFT)
  availabilityStatus AvailabilityStatus        @default(AVAILABLE)
  availableAgainAt   DateTime?
  acceptsEmergency   Boolean  @default(false)
  workingHours       Json?    // { mon: [{from:"08:00",to:"18:00"}], ... }

  verificationStatus VerificationStatus @default(NOT_SUBMITTED)
  isVerified         Boolean  @default(false)
  verifiedAt         DateTime?

  // --- Agrégats dénormalisés (maintenus par transaction/trigger) ---
  ratingAvg          Decimal  @default(0) @db.Decimal(3, 2)
  ratingCount        Int      @default(0)
  reviewCountByStar  Json?    // { "1": 0, "2": 1, ... }
  totalProfileViews  Int      @default(0)
  totalContacts      Int      @default(0)
  completionScore    Int      @default(0)   // 0-100
  rankingScore       Decimal  @default(0) @db.Decimal(10, 4)
  lastActiveAt       DateTime?

  createdAt          DateTime @default(now())
  updatedAt          DateTime @updatedAt

  user              User                  @relation(fields: [userId], references: [id], onDelete: Cascade)
  baseGovernorate   Governorate           @relation("ProviderBaseGovernorate", fields: [baseGovernorateId], references: [id], onDelete: Restrict)
  baseDelegation    Delegation?           @relation("ProviderBaseDelegation", fields: [baseDelegationId], references: [id], onDelete: SetNull)

  categories        ProviderCategory[]
  offerings         ServiceOffering[]
  coverageAreas     CoverageArea[]
  portfolio         PortfolioItem[]
  verifications     VerificationRequest[]
  reviews           Review[]
  reviewReplies     ReviewReply[]
  contactEvents     ContactEvent[]
  profileViews      ProfileView[]
  dailyStats        DailyProviderStat[]
  subscriptions     Subscription[]
  payments          Payment[]
  wallet            CreditWallet?
  boosts            Boost[]
  favoritedBy       Favorite[]
  requestMatches    ServiceRequestMatch[]
  adminNotes        AdminNote[]

  @@index([publicationStatus, verificationStatus])
  @@index([baseGovernorateId, publicationStatus])
  @@index([baseDelegationId])
  @@index([rankingScore(sort: Desc)])
  @@index([ratingAvg(sort: Desc), ratingCount(sort: Desc)])
  @@map("provider_profiles")
}

model ProviderCategory {
  providerId      String   @db.Uuid
  categoryId      String   @db.Uuid
  isPrimary       Boolean  @default(false)
  yearsExperience Int?
  createdAt       DateTime @default(now())

  provider ProviderProfile @relation(fields: [providerId], references: [id], onDelete: Cascade)
  category Category        @relation(fields: [categoryId], references: [id], onDelete: Restrict)

  @@id([providerId, categoryId])
  @@index([categoryId])
  @@map("provider_categories")
}

model ServiceOffering {
  id           String    @id @default(uuid()) @db.Uuid
  providerId   String    @db.Uuid
  categoryId   String    @db.Uuid
  titleFr      String    @db.VarChar(160)
  titleAr      String?   @db.VarChar(160)
  description  String?   @db.Text
  priceMin     Decimal?  @db.Decimal(10, 3)   // TND, 3 décimales (millimes)
  priceMax     Decimal?  @db.Decimal(10, 3)
  priceUnit    PriceUnit @default(FIXED)
  isNegotiable Boolean   @default(true)
  sortOrder    Int       @default(0)
  isActive     Boolean   @default(true)
  createdAt    DateTime  @default(now())
  updatedAt    DateTime  @updatedAt

  provider ProviderProfile @relation(fields: [providerId], references: [id], onDelete: Cascade)
  category Category        @relation(fields: [categoryId], references: [id], onDelete: Restrict)

  @@index([providerId, isActive])
  @@index([categoryId, priceMin])
  @@map("service_offerings")
}

model CoverageArea {
  id            String   @id @default(uuid()) @db.Uuid
  providerId    String   @db.Uuid
  governorateId String   @db.Uuid
  delegationId  String?  @db.Uuid          // null = tout le gouvernorat
  travelFee     Decimal? @db.Decimal(10, 3)
  createdAt     DateTime @default(now())

  provider    ProviderProfile @relation(fields: [providerId], references: [id], onDelete: Cascade)
  governorate Governorate     @relation(fields: [governorateId], references: [id], onDelete: Restrict)
  delegation  Delegation?     @relation(fields: [delegationId], references: [id], onDelete: Cascade)

  @@unique([providerId, governorateId, delegationId])
  @@index([governorateId, delegationId])
  @@map("coverage_areas")
}

// =====================================================================
//  MÉDIAS & GALERIE
// =====================================================================

model MediaAsset {
  id               String           @id @default(uuid()) @db.Uuid
  uploadedById     String?          @db.Uuid
  bucket           String           @db.VarChar(60)      // public-media | private-kyc
  storageKey       String           @unique @db.VarChar(400)
  publicUrl        String?          @db.VarChar(600)
  type             MediaType        @default(IMAGE)
  mimeType         String           @db.VarChar(80)
  sizeBytes        Int
  width            Int?
  height           Int?
  blurhash         String?          @db.VarChar(64)
  checksumSha256   String?          @db.VarChar(64)
  isPrivate        Boolean          @default(false)
  moderationStatus ModerationStatus @default(PENDING)
  purgeAfter       DateTime?        // rétention automatique (CIN)
  createdAt        DateTime         @default(now())

  uploadedBy            User?                  @relation("MediaUploader", fields: [uploadedById], references: [id], onDelete: SetNull)
  userAvatars           User[]                 @relation("UserAvatar")
  portfolioItems        PortfolioItem[]
  verificationDocuments VerificationDocument[]
  adCreatives           AdCreative[]
  paymentProofs         Payment[]              @relation("PaymentProof")
  serviceRequestPhotos  ServiceRequestPhoto[]

  @@index([moderationStatus])
  @@index([purgeAfter])
  @@map("media_assets")
}

model PortfolioItem {
  id          String           @id @default(uuid()) @db.Uuid
  providerId  String           @db.Uuid
  mediaId     String           @db.Uuid
  categoryId  String?          @db.Uuid
  caption     String?          @db.VarChar(300)
  sortOrder   Int              @default(0)
  status      ModerationStatus @default(APPROVED)
  createdAt   DateTime         @default(now())

  provider ProviderProfile @relation(fields: [providerId], references: [id], onDelete: Cascade)
  media    MediaAsset      @relation(fields: [mediaId], references: [id], onDelete: Cascade)
  category Category?       @relation(fields: [categoryId], references: [id], onDelete: SetNull)
  reports  Report[]

  @@index([providerId, status, sortOrder])
  @@map("portfolio_items")
}

// =====================================================================
//  VÉRIFICATION D'IDENTITÉ (KYC)
// =====================================================================

model VerificationRequest {
  id              String             @id @default(uuid()) @db.Uuid
  providerId      String             @db.Uuid
  status          VerificationStatus @default(PENDING)
  cinNumberHash   String?            @db.VarChar(64)   // SHA-256 salé, jamais en clair
  cinNumberCipher String?            @db.Text          // chiffré AES-256-GCM si conservation requise
  fullNameOnId    String?            @db.VarChar(160)
  submittedAt     DateTime           @default(now())
  reviewedAt      DateTime?
  reviewedById    String?            @db.Uuid
  rejectionReason String?            @db.VarChar(400)
  internalNote    String?            @db.Text
  expiresAt       DateTime?

  provider   ProviderProfile        @relation(fields: [providerId], references: [id], onDelete: Cascade)
  reviewedBy User?                  @relation("VerificationReviewer", fields: [reviewedById], references: [id], onDelete: SetNull)
  documents  VerificationDocument[]

  @@index([status, submittedAt])
  @@index([providerId, status])
  @@map("verification_requests")
}

model VerificationDocument {
  id        String                   @id @default(uuid()) @db.Uuid
  requestId String                   @db.Uuid
  mediaId   String                   @db.Uuid
  type      VerificationDocumentType
  createdAt DateTime                 @default(now())

  request VerificationRequest @relation(fields: [requestId], references: [id], onDelete: Cascade)
  media   MediaAsset          @relation(fields: [mediaId], references: [id], onDelete: Restrict)

  @@unique([requestId, type])
  @@map("verification_documents")
}

// =====================================================================
//  MISE EN RELATION & TRAÇABILITÉ
// =====================================================================

model ContactEvent {
  id           String         @id @default(uuid()) @db.Uuid
  providerId   String         @db.Uuid
  clientId     String?        @db.Uuid          // null si visiteur anonyme
  categoryId   String?        @db.Uuid
  channel      ContactChannel
  sourceScreen String?        @db.VarChar(60)   // search | profile | boost | ad | seo_page
  boostId      String?        @db.Uuid
  sessionHash  String?        @db.VarChar(64)
  ipHash       String?        @db.VarChar(64)
  isSuspicious Boolean        @default(false)
  createdAt    DateTime       @default(now())

  provider ProviderProfile @relation(fields: [providerId], references: [id], onDelete: Cascade)
  client   User?           @relation("ClientContacts", fields: [clientId], references: [id], onDelete: SetNull)
  category Category?       @relation(fields: [categoryId], references: [id], onDelete: SetNull)
  boost    Boost?          @relation(fields: [boostId], references: [id], onDelete: SetNull)
  review   Review?

  @@index([providerId, createdAt(sort: Desc)])
  @@index([clientId, createdAt(sort: Desc)])
  @@index([createdAt])
  @@map("contact_events")
}

model ProfileView {
  id          String   @id @default(uuid()) @db.Uuid
  providerId  String   @db.Uuid
  viewerId    String?  @db.Uuid
  sessionHash String   @db.VarChar(64)
  viewDate    DateTime @db.Date          // clé de déduplication journalière
  source      String?  @db.VarChar(60)
  isBot       Boolean  @default(false)
  createdAt   DateTime @default(now())

  provider ProviderProfile @relation(fields: [providerId], references: [id], onDelete: Cascade)
  viewer   User?           @relation("ViewerViews", fields: [viewerId], references: [id], onDelete: SetNull)

  @@unique([providerId, sessionHash, viewDate])
  @@index([providerId, viewDate])
  @@map("profile_views")
}

model DailyProviderStat {
  id                 String   @id @default(uuid()) @db.Uuid
  providerId         String   @db.Uuid
  date               DateTime @db.Date
  searchImpressions  Int      @default(0)
  profileViews       Int      @default(0)
  uniqueProfileViews Int      @default(0)
  phoneClicks        Int      @default(0)
  whatsappClicks     Int      @default(0)
  newReviews         Int      @default(0)
  avgSearchPosition  Decimal? @db.Decimal(6, 2)
  computedAt         DateTime @default(now())

  provider ProviderProfile @relation(fields: [providerId], references: [id], onDelete: Cascade)

  @@unique([providerId, date])
  @@index([date])
  @@map("daily_provider_stats")
}

model SearchLog {
  id            String   @id @default(uuid()) @db.Uuid
  userId        String?  @db.Uuid
  term          String?  @db.VarChar(200)
  categoryId    String?  @db.Uuid
  governorateId String?  @db.Uuid
  delegationId  String?  @db.Uuid
  filtersJson   Json?
  resultCount   Int      @default(0)
  createdAt     DateTime @default(now())

  user     User?     @relation(fields: [userId], references: [id], onDelete: SetNull)
  category Category? @relation(fields: [categoryId], references: [id], onDelete: SetNull)

  @@index([createdAt])
  @@index([categoryId, governorateId])
  @@map("search_logs")
}

// =====================================================================
//  RÉPUTATION : AVIS, RÉPONSES, SIGNALEMENTS
// =====================================================================

model Review {
  id              String       @id @default(uuid()) @db.Uuid
  providerId      String       @db.Uuid
  clientId        String       @db.Uuid
  contactEventId  String?      @unique @db.Uuid     // présent => "Avis certifié"
  rating          Int                                // 1..5, contrainte CHECK
  ratingPunctuality Int?
  ratingQuality     Int?
  ratingValue       Int?
  comment         String?      @db.VarChar(1000)
  status          ReviewStatus @default(PENDING)
  isVerifiedContact Boolean    @default(false)
  moderatedById   String?      @db.Uuid
  moderatedAt     DateTime?
  moderationReason String?     @db.VarChar(400)
  editableUntil   DateTime?
  createdAt       DateTime     @default(now())
  updatedAt       DateTime     @updatedAt

  provider     ProviderProfile @relation(fields: [providerId], references: [id], onDelete: Cascade)
  client       User            @relation("ClientReviews", fields: [clientId], references: [id], onDelete: Cascade)
  contactEvent ContactEvent?   @relation(fields: [contactEventId], references: [id], onDelete: SetNull)
  moderatedBy  User?           @relation("ReviewModerator", fields: [moderatedById], references: [id], onDelete: SetNull)
  reply        ReviewReply?
  reports      Report[]

  @@index([providerId, status, createdAt(sort: Desc)])
  @@index([clientId, createdAt(sort: Desc)])
  @@index([status, createdAt])
  @@map("reviews")
}

model ReviewReply {
  id         String           @id @default(uuid()) @db.Uuid
  reviewId   String           @unique @db.Uuid
  providerId String           @db.Uuid
  body       String           @db.VarChar(500)
  status     ModerationStatus @default(APPROVED)
  editableUntil DateTime?
  createdAt  DateTime         @default(now())
  updatedAt  DateTime         @updatedAt

  review   Review          @relation(fields: [reviewId], references: [id], onDelete: Cascade)
  provider ProviderProfile @relation(fields: [providerId], references: [id], onDelete: Cascade)
  reports  Report[]

  @@index([providerId])
  @@map("review_replies")
}

model Report {
  id              String           @id @default(uuid()) @db.Uuid
  reporterId      String?          @db.Uuid
  targetType      ReportTargetType
  reviewId        String?          @db.Uuid
  reviewReplyId   String?          @db.Uuid
  providerId      String?          @db.Uuid
  portfolioItemId String?          @db.Uuid
  serviceRequestId String?         @db.Uuid
  reasonCode      String           @db.VarChar(60)
  details         String?          @db.VarChar(1000)
  status          ReportStatus     @default(OPEN)
  handledById     String?          @db.Uuid
  handledAt       DateTime?
  resolutionNote  String?          @db.VarChar(600)
  createdAt       DateTime         @default(now())

  reporter       User?           @relation("ReportAuthor", fields: [reporterId], references: [id], onDelete: SetNull)
  handledBy      User?           @relation("ReportHandler", fields: [handledById], references: [id], onDelete: SetNull)
  review         Review?         @relation(fields: [reviewId], references: [id], onDelete: Cascade)
  reviewReply    ReviewReply?    @relation(fields: [reviewReplyId], references: [id], onDelete: Cascade)
  portfolioItem  PortfolioItem?  @relation(fields: [portfolioItemId], references: [id], onDelete: Cascade)
  serviceRequest ServiceRequest? @relation(fields: [serviceRequestId], references: [id], onDelete: Cascade)

  @@unique([reporterId, targetType, reviewId, reviewReplyId, providerId, portfolioItemId])
  @@index([status, createdAt])
  @@index([targetType, status])
  @@map("reports")
}

// =====================================================================
//  MONÉTISATION : OFFRES, ABONNEMENTS, CRÉDITS, BOOSTS, PAIEMENTS
// =====================================================================

model Plan {
  id               String   @id @default(uuid()) @db.Uuid
  code             String   @unique @db.VarChar(40)      // FREE | PRO_MONTHLY | PRO_QUARTERLY | PRO_YEARLY
  nameFr           String   @db.VarChar(80)
  nameAr           String   @db.VarChar(80)
  descriptionFr    String?  @db.Text
  price            Decimal  @db.Decimal(10, 3)           // TND
  billingPeriodDays Int
  maxCategories    Int      @default(3)
  maxCoverageAreas Int      @default(1)
  maxPortfolioItems Int     @default(5)
  grantsVerifiedBadge Boolean @default(false)
  rankingBoostFactor Decimal @default(1.0) @db.Decimal(4, 2)
  instantLeadAccess Boolean  @default(false)
  advancedStats    Boolean   @default(false)
  welcomeCredits   Int       @default(0)
  features         Json?
  isActive         Boolean   @default(true)
  sortOrder        Int       @default(0)
  createdAt        DateTime  @default(now())
  updatedAt        DateTime  @updatedAt

  subscriptions Subscription[]

  @@index([isActive, sortOrder])
  @@map("plans")
}

model Subscription {
  id            String             @id @default(uuid()) @db.Uuid
  providerId    String             @db.Uuid
  planId        String             @db.Uuid
  status        SubscriptionStatus @default(PENDING_PAYMENT)
  startsAt      DateTime
  endsAt        DateTime
  autoRenew     Boolean            @default(false)
  canceledAt    DateTime?
  cancelReason  String?            @db.VarChar(300)
  pausedDays    Int                @default(0)   // mode vacances
  createdAt     DateTime           @default(now())
  updatedAt     DateTime           @updatedAt

  provider ProviderProfile @relation(fields: [providerId], references: [id], onDelete: Cascade)
  plan     Plan            @relation(fields: [planId], references: [id], onDelete: Restrict)
  payments Payment[]

  @@index([providerId, status])
  @@index([status, endsAt])
  @@map("subscriptions")
}

model CreditPack {
  id        String   @id @default(uuid()) @db.Uuid
  code      String   @unique @db.VarChar(40)
  nameFr    String   @db.VarChar(80)
  nameAr    String   @db.VarChar(80)
  credits   Int
  price     Decimal  @db.Decimal(10, 3)
  isActive  Boolean  @default(true)
  sortOrder Int      @default(0)

  payments Payment[]

  @@map("credit_packs")
}

model CreditWallet {
  id         String   @id @default(uuid()) @db.Uuid
  providerId String   @unique @db.Uuid
  balance    Int      @default(0)
  updatedAt  DateTime @updatedAt
  createdAt  DateTime @default(now())

  provider     ProviderProfile     @relation(fields: [providerId], references: [id], onDelete: Cascade)
  transactions CreditTransaction[]

  @@map("credit_wallets")
}

model CreditTransaction {
  id             String                  @id @default(uuid()) @db.Uuid
  walletId       String                  @db.Uuid
  delta          Int                                          // + crédit, - débit
  balanceAfter   Int
  reason         CreditTransactionReason
  referenceType  String?                 @db.VarChar(40)      // payment | boost
  referenceId    String?                 @db.Uuid
  idempotencyKey String?                 @unique @db.VarChar(80)
  adjustedById   String?                 @db.Uuid
  note           String?                 @db.VarChar(300)
  createdAt      DateTime                @default(now())

  wallet     CreditWallet @relation(fields: [walletId], references: [id], onDelete: Cascade)
  adjustedBy User?        @relation("CreditAdjuster", fields: [adjustedById], references: [id], onDelete: SetNull)

  @@index([walletId, createdAt(sort: Desc)])
  @@map("credit_transactions")
}

model Boost {
  id            String      @id @default(uuid()) @db.Uuid
  providerId    String      @db.Uuid
  categoryId    String?     @db.Uuid     // null = toutes catégories du profil
  governorateId String?     @db.Uuid
  delegationId  String?     @db.Uuid
  startsAt      DateTime
  endsAt        DateTime
  weight        Int         @default(100)
  creditsSpent  Int
  status        BoostStatus @default(SCHEDULED)
  impressions   Int         @default(0)
  clicks        Int         @default(0)
  contacts      Int         @default(0)
  createdAt     DateTime    @default(now())
  updatedAt     DateTime    @updatedAt

  provider      ProviderProfile @relation(fields: [providerId], references: [id], onDelete: Cascade)
  category      Category?       @relation(fields: [categoryId], references: [id], onDelete: SetNull)
  governorate   Governorate?    @relation(fields: [governorateId], references: [id], onDelete: SetNull)
  delegation    Delegation?     @relation(fields: [delegationId], references: [id], onDelete: SetNull)
  contactEvents ContactEvent[]

  @@index([status, startsAt, endsAt])
  @@index([categoryId, governorateId, status])
  @@index([providerId, createdAt(sort: Desc)])
  @@map("boosts")
}

model Payment {
  id             String         @id @default(uuid()) @db.Uuid
  providerId     String         @db.Uuid
  purpose        PaymentPurpose
  subscriptionId String?        @db.Uuid
  creditPackId   String?        @db.Uuid
  amount         Decimal        @db.Decimal(10, 3)
  currency       String         @default("TND") @db.VarChar(3)
  method         PaymentMethod
  status         PaymentStatus  @default(PENDING)
  gatewayName    String?        @db.VarChar(40)
  gatewayRef     String?        @db.VarChar(120)
  idempotencyKey String?        @unique @db.VarChar(80)
  proofMediaId   String?        @db.Uuid
  collectedBy    String?        @db.VarChar(120)   // agent terrain
  validatedById  String?        @db.Uuid
  validatedAt    DateTime?
  paidAt         DateTime?
  invoiceNumber  String?        @unique @db.VarChar(30)
  notes          String?        @db.VarChar(500)
  createdAt      DateTime       @default(now())
  updatedAt      DateTime       @updatedAt

  provider     ProviderProfile @relation(fields: [providerId], references: [id], onDelete: Restrict)
  subscription Subscription?   @relation(fields: [subscriptionId], references: [id], onDelete: SetNull)
  creditPack   CreditPack?     @relation(fields: [creditPackId], references: [id], onDelete: SetNull)
  proofMedia   MediaAsset?     @relation("PaymentProof", fields: [proofMediaId], references: [id], onDelete: SetNull)
  validatedBy  User?           @relation("PaymentValidator", fields: [validatedById], references: [id], onDelete: SetNull)

  @@index([providerId, createdAt(sort: Desc)])
  @@index([status, method])
  @@index([gatewayRef])
  @@map("payments")
}

// =====================================================================
//  RÉGIE PUBLICITAIRE B2B
// =====================================================================

model Advertiser {
  id           String   @id @default(uuid()) @db.Uuid
  companyName  String   @db.VarChar(160)
  contactName  String?  @db.VarChar(120)
  phone        String?  @db.VarChar(20)
  email        String?  @db.VarChar(160)
  sector       String?  @db.VarChar(80)
  taxId        String?  @db.VarChar(40)
  isActive     Boolean  @default(true)
  createdAt    DateTime @default(now())
  updatedAt    DateTime @updatedAt

  campaigns AdCampaign[]

  @@map("advertisers")
}

model AdCampaign {
  id           String           @id @default(uuid()) @db.Uuid
  advertiserId String           @db.Uuid
  name         String           @db.VarChar(160)
  status       AdCampaignStatus @default(DRAFT)
  startsAt     DateTime
  endsAt       DateTime
  totalPrice   Decimal?         @db.Decimal(10, 3)
  impressionCap Int?
  priority     Int              @default(100)
  createdAt    DateTime         @default(now())
  updatedAt    DateTime         @updatedAt

  advertiser   Advertiser              @relation(fields: [advertiserId], references: [id], onDelete: Cascade)
  creatives    AdCreative[]
  governorates AdCampaignGovernorate[]
  categories   AdCampaignCategory[]

  @@index([status, startsAt, endsAt])
  @@map("ad_campaigns")
}

model AdCreative {
  id         String      @id @default(uuid()) @db.Uuid
  campaignId String      @db.Uuid
  mediaId    String      @db.Uuid
  placement  AdPlacement
  title      String?     @db.VarChar(120)
  subtitle   String?     @db.VarChar(160)
  ctaLabel   String?     @db.VarChar(40)
  targetUrl  String      @db.VarChar(600)
  locale     Locale      @default(FR)
  isActive   Boolean     @default(true)
  createdAt  DateTime    @default(now())

  campaign  AdCampaign   @relation(fields: [campaignId], references: [id], onDelete: Cascade)
  media     MediaAsset   @relation(fields: [mediaId], references: [id], onDelete: Restrict)
  dailyStats AdDailyStat[]

  @@index([campaignId, placement, isActive])
  @@map("ad_creatives")
}

model AdCampaignGovernorate {
  campaignId    String @db.Uuid
  governorateId String @db.Uuid

  campaign    AdCampaign  @relation(fields: [campaignId], references: [id], onDelete: Cascade)
  governorate Governorate @relation(fields: [governorateId], references: [id], onDelete: Cascade)

  @@id([campaignId, governorateId])
  @@map("ad_campaign_governorates")
}

model AdCampaignCategory {
  campaignId String @db.Uuid
  categoryId String @db.Uuid

  campaign AdCampaign @relation(fields: [campaignId], references: [id], onDelete: Cascade)
  category Category   @relation(fields: [categoryId], references: [id], onDelete: Cascade)

  @@id([campaignId, categoryId])
  @@map("ad_campaign_categories")
}

model AdDailyStat {
  id          String   @id @default(uuid()) @db.Uuid
  creativeId  String   @db.Uuid
  date        DateTime @db.Date
  impressions Int      @default(0)
  clicks      Int      @default(0)

  creative AdCreative @relation(fields: [creativeId], references: [id], onDelete: Cascade)

  @@unique([creativeId, date])
  @@index([date])
  @@map("ad_daily_stats")
}

// =====================================================================
//  DEMANDES D'INTERVENTION (backlog V2, modélisé dès maintenant)
// =====================================================================

model ServiceRequest {
  id            String               @id @default(uuid()) @db.Uuid
  clientId      String               @db.Uuid
  categoryId    String               @db.Uuid
  governorateId String               @db.Uuid
  delegationId  String?              @db.Uuid
  title         String               @db.VarChar(160)
  description   String               @db.Text
  budgetMin     Decimal?             @db.Decimal(10, 3)
  budgetMax     Decimal?             @db.Decimal(10, 3)
  preferredDate DateTime?
  isUrgent      Boolean              @default(false)
  status        ServiceRequestStatus @default(OPEN)
  expiresAt     DateTime
  createdAt     DateTime             @default(now())
  updatedAt     DateTime             @updatedAt

  client      User                  @relation("ClientRequests", fields: [clientId], references: [id], onDelete: Cascade)
  category    Category              @relation(fields: [categoryId], references: [id], onDelete: Restrict)
  governorate Governorate           @relation(fields: [governorateId], references: [id], onDelete: Restrict)
  delegation  Delegation?           @relation(fields: [delegationId], references: [id], onDelete: SetNull)
  photos      ServiceRequestPhoto[]
  matches     ServiceRequestMatch[]
  reports     Report[]

  @@index([status, categoryId, governorateId])
  @@index([expiresAt])
  @@map("service_requests")
}

model ServiceRequestPhoto {
  id        String @id @default(uuid()) @db.Uuid
  requestId String @db.Uuid
  mediaId   String @db.Uuid

  request ServiceRequest @relation(fields: [requestId], references: [id], onDelete: Cascade)
  media   MediaAsset     @relation(fields: [mediaId], references: [id], onDelete: Cascade)

  @@unique([requestId, mediaId])
  @@map("service_request_photos")
}

model ServiceRequestMatch {
  id           String    @id @default(uuid()) @db.Uuid
  requestId    String    @db.Uuid
  providerId   String    @db.Uuid
  notifiedAt   DateTime?
  interestedAt DateTime?
  selectedAt   DateTime?
  declinedAt   DateTime?
  createdAt    DateTime  @default(now())

  request  ServiceRequest  @relation(fields: [requestId], references: [id], onDelete: Cascade)
  provider ProviderProfile @relation(fields: [providerId], references: [id], onDelete: Cascade)

  @@unique([requestId, providerId])
  @@index([providerId, createdAt(sort: Desc)])
  @@map("service_request_matches")
}

// =====================================================================
//  ENGAGEMENT : FAVORIS & NOTIFICATIONS
// =====================================================================

model Favorite {
  userId     String   @db.Uuid
  providerId String   @db.Uuid
  createdAt  DateTime @default(now())

  user     User            @relation(fields: [userId], references: [id], onDelete: Cascade)
  provider ProviderProfile @relation(fields: [providerId], references: [id], onDelete: Cascade)

  @@id([userId, providerId])
  @@index([providerId])
  @@map("favorites")
}

model Notification {
  id        String              @id @default(uuid()) @db.Uuid
  userId    String              @db.Uuid
  type      NotificationType
  channel   NotificationChannel @default(PUSH)
  title     String              @db.VarChar(160)
  body      String              @db.VarChar(500)
  data      Json?
  deepLink  String?             @db.VarChar(300)
  readAt    DateTime?
  sentAt    DateTime?
  failedAt  DateTime?
  dedupeKey String?             @unique @db.VarChar(120)
  createdAt DateTime            @default(now())

  user User @relation(fields: [userId], references: [id], onDelete: Cascade)

  @@index([userId, readAt, createdAt(sort: Desc)])
  @@map("notifications")
}

model NotificationPreference {
  userId  String              @db.Uuid
  type    NotificationType
  channel NotificationChannel
  enabled Boolean             @default(true)

  user User @relation(fields: [userId], references: [id], onDelete: Cascade)

  @@id([userId, type, channel])
  @@map("notification_preferences")
}

// =====================================================================
//  ADMINISTRATION : AUDIT, PARAMÈTRES, NOTES INTERNES
// =====================================================================

model AuditLog {
  id         String   @id @default(uuid()) @db.Uuid
  actorId    String?  @db.Uuid
  action     String   @db.VarChar(80)      // provider.verify.approve, payment.validate...
  entityType String   @db.VarChar(60)
  entityId   String?  @db.Uuid
  before     Json?
  after      Json?
  ipHash     String?  @db.VarChar(64)
  userAgent  String?  @db.VarChar(400)
  createdAt  DateTime @default(now())

  actor User? @relation("AuditActor", fields: [actorId], references: [id], onDelete: SetNull)

  @@index([entityType, entityId, createdAt(sort: Desc)])
  @@index([actorId, createdAt(sort: Desc)])
  @@map("audit_logs")
}

model AdminNote {
  id         String   @id @default(uuid()) @db.Uuid
  providerId String   @db.Uuid
  authorId   String?  @db.Uuid
  body       String   @db.Text
  createdAt  DateTime @default(now())

  provider ProviderProfile @relation(fields: [providerId], references: [id], onDelete: Cascade)
  author   User?           @relation("NoteAuthor", fields: [authorId], references: [id], onDelete: SetNull)

  @@index([providerId, createdAt(sort: Desc)])
  @@map("admin_notes")
}

model AppSetting {
  key         String   @id @db.VarChar(80)
  value       Json
  description String?  @db.VarChar(300)
  updatedById String?  @db.Uuid
  updatedAt   DateTime @updatedAt

  @@map("app_settings")
}

model FeatureFlag {
  key            String   @id @db.VarChar(80)
  isEnabled      Boolean  @default(false)
  rolloutPercent Int      @default(0)
  audienceJson   Json?
  updatedAt      DateTime @updatedAt

  @@map("feature_flags")
}
```

### 2.3 Contraintes et index avancés (migration SQL manuelle complémentaire)

Prisma ne couvre pas nativement les contraintes `CHECK`, les index partiels et les index GIN. À ajouter dans une migration dédiée :

```sql
-- 1. Bornes de notation
ALTER TABLE reviews ADD CONSTRAINT chk_reviews_rating CHECK (rating BETWEEN 1 AND 5);
ALTER TABLE reviews ADD CONSTRAINT chk_reviews_sub_ratings CHECK (
  (rating_punctuality IS NULL OR rating_punctuality BETWEEN 1 AND 5) AND
  (rating_quality     IS NULL OR rating_quality     BETWEEN 1 AND 5) AND
  (rating_value       IS NULL OR rating_value       BETWEEN 1 AND 5)
);

-- 2. Cohérence des tarifs
ALTER TABLE service_offerings ADD CONSTRAINT chk_price_range
  CHECK (price_min IS NULL OR price_max IS NULL OR price_min <= price_max);

-- 3. Cohérence temporelle
ALTER TABLE subscriptions ADD CONSTRAINT chk_subscription_period CHECK (starts_at < ends_at);
ALTER TABLE boosts        ADD CONSTRAINT chk_boost_period        CHECK (starts_at < ends_at);
ALTER TABLE ad_campaigns  ADD CONSTRAINT chk_campaign_period     CHECK (starts_at < ends_at);

-- 4. Un seul abonnement ACTIF par prestataire (index unique partiel)
CREATE UNIQUE INDEX uniq_active_subscription_per_provider
  ON subscriptions (provider_id) WHERE status = 'ACTIVE';

-- 5. Une seule catégorie principale par prestataire
CREATE UNIQUE INDEX uniq_primary_category_per_provider
  ON provider_categories (provider_id) WHERE is_primary = true;

-- 6. Solde de portefeuille jamais négatif
ALTER TABLE credit_wallets ADD CONSTRAINT chk_wallet_balance_positive CHECK (balance >= 0);

-- 7. Un artisan ne peut pas s'auto-évaluer
--    (contrôle applicatif + garde-fou par trigger)
CREATE OR REPLACE FUNCTION prevent_self_review() RETURNS trigger AS $$
BEGIN
  IF EXISTS (
    SELECT 1 FROM provider_profiles p
    WHERE p.id = NEW.provider_id AND p.user_id = NEW.client_id
  ) THEN
    RAISE EXCEPTION 'Un prestataire ne peut pas evaluer son propre profil';
  END IF;
  RETURN NEW;
END; $$ LANGUAGE plpgsql;

CREATE TRIGGER trg_prevent_self_review
  BEFORE INSERT OR UPDATE ON reviews
  FOR EACH ROW EXECUTE FUNCTION prevent_self_review();

-- 8. Recherche plein texte FR/AR insensible aux accents
CREATE INDEX idx_provider_search_trgm
  ON provider_profiles USING gin (
    (unaccent(lower(business_name)) || ' ' || unaccent(lower(coalesce(headline, '')))) gin_trgm_ops
  );

-- 9. Index géospatial (si PostGIS activé)
ALTER TABLE provider_profiles ADD COLUMN geom geography(Point, 4326)
  GENERATED ALWAYS AS (ST_SetSRID(ST_MakePoint(longitude::float8, latitude::float8), 4326)::geography) STORED;
CREATE INDEX idx_provider_geom ON provider_profiles USING gist (geom);

-- 10. Index partiel sur les profils réellement affichables (le cas 95 % du temps)
CREATE INDEX idx_provider_published_ranking
  ON provider_profiles (ranking_score DESC)
  WHERE publication_status = 'PUBLISHED';

-- 11. Purge automatisable des médias KYC
CREATE INDEX idx_media_purge ON media_assets (purge_after) WHERE purge_after IS NOT NULL;
```

**Vue matérialisée de recherche** (optionnelle, si les jointures deviennent coûteuses) :

```sql
CREATE MATERIALIZED VIEW mv_provider_search AS
SELECT
  p.id, p.slug, p.business_name, p.is_verified, p.rating_avg, p.rating_count,
  p.availability_status, p.ranking_score, p.base_governorate_id,
  array_agg(DISTINCT pc.category_id) AS category_ids,
  array_agg(DISTINCT ca.governorate_id) AS governorate_ids,
  array_agg(DISTINCT ca.delegation_id) FILTER (WHERE ca.delegation_id IS NOT NULL) AS delegation_ids,
  min(so.price_min) AS price_from
FROM provider_profiles p
LEFT JOIN provider_categories pc ON pc.provider_id = p.id
LEFT JOIN coverage_areas    ca ON ca.provider_id = p.id
LEFT JOIN service_offerings so ON so.provider_id = p.id AND so.is_active
WHERE p.publication_status = 'PUBLISHED'
GROUP BY p.id;

CREATE UNIQUE INDEX ON mv_provider_search (id);
CREATE INDEX ON mv_provider_search USING gin (category_ids);
CREATE INDEX ON mv_provider_search USING gin (governorate_ids);
-- Rafraîchissement : REFRESH MATERIALIZED VIEW CONCURRENTLY mv_provider_search;
```

### 2.4 Cartographie des relations

| Relation | Cardinalité | Notes |
|---|---|---|
| `User` ⇄ `ProviderProfile` | **1-1** (optionnelle) | Un utilisateur peut devenir artisan sans second compte |
| `ProviderProfile` → `ServiceOffering` | **1-N** | Prestations tarifées |
| `ProviderProfile` ⇄ `Category` | **N-N** via `ProviderCategory` | Attribut porté : `isPrimary` |
| `ProviderProfile` ⇄ `Delegation` | **N-N** via `CoverageArea` | `delegationId = null` ⇒ gouvernorat entier |
| `Governorate` → `Delegation` | **1-N** | Référentiel géographique |
| `Category` → `Category` | **1-N** auto-référencée | Arbre catégories/sous-catégories |
| `ProviderProfile` → `Review` | **1-N** | Agrégats dénormalisés sur le profil |
| `User` (client) → `Review` | **1-N** | Un avis appartient à un client |
| `Review` ⇄ `ContactEvent` | **1-1** (optionnelle, unique) | Fondement de l'« avis certifié » |
| `Review` ⇄ `ReviewReply` | **1-1** | Une seule réponse artisan |
| `ProviderProfile` → `Subscription` | **1-N** (1 seule `ACTIVE`) | Index unique partiel |
| `Plan` → `Subscription` | **1-N** | Offres paramétrables |
| `ProviderProfile` ⇄ `CreditWallet` | **1-1** | Portefeuille de crédits |
| `CreditWallet` → `CreditTransaction` | **1-N** | Journal immuable, `balanceAfter` conservé |
| `ProviderProfile` → `Boost` | **1-N** | Ciblage catégorie × zone × période |
| `ProviderProfile` → `Payment` | **1-N** | Abonnements et packs de crédits |
| `Advertiser` → `AdCampaign` → `AdCreative` | **1-N → 1-N** | Régie publicitaire |
| `AdCampaign` ⇄ `Governorate` / `Category` | **N-N** | Ciblage publicitaire |
| `User` ⇄ `ProviderProfile` (favoris) | **N-N** via `Favorite` | Clé primaire composite |
| `ServiceRequest` ⇄ `ProviderProfile` | **N-N** via `ServiceRequestMatch` | Diffusion de leads |

### 2.5 Stratégie de suppression

| Politique | Application |
|---|---|
| `Cascade` | Données strictement dépendantes : sessions, avis d'un profil supprimé, zones, prestations, galerie |
| `Restrict` | Référentiels et données financières : `Category`, `Governorate`, `Plan`, `Payment.provider` — on n'efface jamais une donnée comptable par effet de bord |
| `SetNull` | Traçabilité conservée avec acteur anonymisé : `moderatedBy`, `validatedBy`, `clientId` d'un `ContactEvent` |
| **Soft delete** | `User.deletedAt` + anonymisation (téléphone haché, nom → « Utilisateur supprimé ») ; les avis restent publiés de façon anonyme pour préserver l'intégrité des notes |

---

## 3. Stack technique & stratégie de partage de code (Max Code Sharing)

### 3.1 Stack recommandée — validée

| Couche | Technologie | Justification |
|---|---|---|
| **Monorepo** | **Turborepo + pnpm workspaces** | Cache distant et local, exécution parallèle des tâches, graphe de dépendances explicite. `pnpm` gère les dépendances hoistées de façon stricte, ce qui évite les conflits classiques Metro/Next. Alternative Nx écartée : plus puissante mais plus lourde à opérer pour une équipe réduite. |
| **Web** | **Next.js 15 (App Router) + React 19** | SSG/ISR indispensable pour le SEO local (P6), Server Components pour alléger le bundle, Route Handlers pour héberger le endpoint tRPC. Un seul déploiement Vercel/Docker sert la vitrine, l'app client et l'API. |
| **Mobile** | **Expo SDK 53+ (React Native) + Expo Router** | Une seule base pour iOS/Android, EAS Build/Submit, mises à jour OTA (correctifs sans passer par les stores), accès natif nécessaire (caméra, contacts, notifications, deep links WhatsApp/tel). Expo Router aligne le modèle de navigation sur celui du Web (routing par fichiers), ce qui augmente mécaniquement le code partageable. |
| **Back-Office** | **Next.js (app séparée `apps/admin`)** | Séparation nette des surfaces d'attaque et des builds : le back-office n'a pas besoin d'être indexé, n'a pas les mêmes exigences de performance, et son bundle ne doit jamais partir chez les clients. Il consomme la même API tRPC via des routeurs `adminRouter` protégés. |
| **API** | **tRPC v11 + TanStack Query v5** | Le pilier du partage de code (P2). Typage bout-en-bout sans génération de code, sans OpenAPI, sans client HTTP manuel. Les hooks de données sont **identiques** entre Web et Mobile. Un plugin `trpc-openapi` peut exposer une API REST documentée pour d'éventuels partenaires. |
| **Validation** | **Zod** | Un schéma = validation serveur + validation formulaire + inférence de types. Aucune duplication. |
| **ORM / BDD** | **Prisma 6 + PostgreSQL 16** | Voir §2.1. Migrations versionnées, client typé, seed reproductible. |
| **Auth** | **Auth maison OTP SMS + JWT (access court / refresh rotatif)**, ou **Better Auth** | Le marché est *phone-first* : l'email est rare, les mots de passe sont un frein. Aucun fournisseur clé-en-main ne gère nativement l'OTP SMS tunisien : une implémentation maîtrisée dans `packages/auth` est préférable et reste testable. |
| **Cache / files** | **Redis (Upstash) + BullMQ** | Rate limiting, sessions révocables, verrous, jobs différés (agrégats, expirations, notifications). |
| **Stockage fichiers** | **Cloudflare R2 / Scaleway Object Storage** | Compatible S3, pas de frais d'egress (R2), CDN intégré. Deux buckets : public (médias) et privé chiffré (KYC). |
| **Traitement d'images** | **sharp** (serveur) + `expo-image-manipulator` (client) | Compression avant upload côté client (économie de data), variantes WebP côté serveur. |
| **UI Web** | **Tailwind CSS v4 + shadcn/ui (Radix)** | Accessibilité, composants non opinionnés, thématisation par tokens, support RTL. |
| **UI Mobile** | **NativeWind v4 + composants maison** | Même grammaire Tailwind que le Web ⇒ les développeurs écrivent le même type de classes des deux côtés, et les tokens de design sont partagés. |
| **State** | **TanStack Query (serveur) + Zustand (UI locale)** | Séparation nette état serveur / état d'interface. Zustand est isomorphe Web/Mobile. |
| **Formulaires** | **React Hook Form + `@hookform/resolvers/zod`** | Fonctionne à l'identique sur RN et sur le Web ; seul le rendu des champs diffère. |
| **i18n** | **i18next / `react-i18next` + `expo-localization`** | Catalogues FR/AR partagés dans `packages/i18n`, gestion RTL. |
| **Paiement** | **Konnect / Paymee / Flouci / ClicToPay** (voir Q2) | Adaptateurs derrière une interface `PaymentGateway` unique dans `packages/payments` — le choix du fournisseur devient une variable d'environnement. |
| **SMS** | Agrégateur local + **Twilio en secours** | La délivrabilité OTP est critique : deux fournisseurs, bascule automatique. |
| **Notifications** | **Expo Push Notifications** | Un seul service pour iOS et Android. |
| **Observabilité** | **Sentry** (web + mobile + serveur), **Axiom/Better Stack** (logs), **PostHog** (produit) | Détection de régression et analyse d'entonnoir de conversion. |
| **Tests** | **Vitest** (unitaires/intégration), **Playwright** (E2E web), **Maestro** (E2E mobile) | Pyramide de tests réaliste pour une équipe réduite. |
| **CI/CD** | **GitHub Actions + Turborepo Remote Cache + EAS** | Lint, typecheck, test, migrations, déploiement web ; builds mobiles sur tag. |

### 3.2 Matrice de partage : ce qui est mutualisé, ce qui ne l'est pas

#### ✅ Partagé à 100 % (`packages/*`)

| Élément | Package | Détail |
|---|---|---|
| **Schéma & client BDD** | `@repo/db` | Prisma schema, migrations, seed, singleton client. Utilisé uniquement côté serveur, mais les **types générés** sont réexportés partout. |
| **Types du domaine** | `@repo/db` + `@repo/core` | `Provider`, `Review`, `Subscription`… Une seule définition. |
| **Schémas de validation** | `@repo/validators` | Schémas Zod (`searchProvidersInput`, `createReviewInput`, `providerOnboardingStep2`…) : utilisés par le serveur pour valider les entrées **et** par les formulaires Web/Mobile pour valider la saisie. Une règle changée = un seul fichier modifié. |
| **Logique métier** | `@repo/core` | Calcul du ranking, du score de complétude, éligibilité au boost, dates d'expiration d'abonnement, droit de laisser un avis, formatage TND, quotas par plan. Zéro dépendance React/HTTP ⇒ 100 % testable. |
| **Contrat d'API + hooks** | `@repo/api` | Routeurs tRPC et leur type `AppRouter`. Web et Mobile importent le **même** type et obtiennent le même client typé : `trpc.providers.search.useQuery(...)` fonctionne à l'identique des deux côtés. |
| **i18n** | `@repo/i18n` | Catalogues FR/AR, helpers de pluralisation, formatage dates/devises, direction RTL. |
| **Tokens de design** | `@repo/design-tokens` | Couleurs, espacements, rayons, typographies, ombres. Consommés par Tailwind (web) et NativeWind (mobile) via un preset commun. |
| **Utilitaires** | `@repo/utils` | Normalisation des numéros tunisiens (+216), génération de slugs (translittération AR→latin), construction de liens `wa.me`, calcul de distance, helpers de date, hachage d'empreinte de session. |
| **Constantes** | `@repo/constants` | Clés de catégories, codes de gouvernorats, motifs de signalement, plafonds, codes d'erreur, noms d'événements analytics. |
| **Analytics** | `@repo/analytics` | Interface unique `track(event, props)` avec adaptateurs PostHog web/natif : la nomenclature des événements ne peut pas diverger. |
| **Config partagée** | `@repo/tsconfig`, `@repo/eslint-config`, `@repo/tailwind-config` | Cohérence de la qualité de code sur tout le dépôt. |

#### 🔀 Partiellement partagé

| Élément | Approche |
|---|---|
| **Composants UI** | La *logique* du composant est extraite dans un **hook headless** partagé (`useProviderCard`, `useSearchFilters`, `useReviewForm`) ; le *rendu* est implémenté deux fois (`packages/ui` pour le Web, `packages/ui-native` pour le Mobile). C'est le compromis pragmatique : ~70 % de la complexité (état, dérivations, appels API) est mutualisée, ~30 % (le JSX de présentation) est spécifique. |
| **Feuille de styles** | Les mêmes tokens et la même grammaire Tailwind, mais deux moteurs (Tailwind CSS / NativeWind). |
| **Gestion des fichiers** | Interface commune `uploadMedia()` dans `@repo/storage-client`, implémentée avec `File`/`FormData` sur le Web et `expo-file-system` sur le Mobile. |
| **Stockage sécurisé** | Interface `secureStorage.get/set` : cookie `httpOnly` côté Web, `expo-secure-store` côté Mobile. |

#### ❌ Spécifique à chaque plateforme (`apps/*`)

| Web (Next.js) | Mobile (Expo) |
|---|---|
| Routing App Router, layouts, métadonnées SEO | Expo Router, navigation par onglets/pile, deep links |
| Server Components, ISR, `generateStaticParams` | Écrans natifs, gestes, animations Reanimated |
| `sitemap.xml`, `robots.txt`, JSON-LD | Notifications push, permissions natives |
| Rendu HTML/CSS/DOM | Caméra, galerie, `Linking` (tel:/whatsapp:) |
| Cookies, middleware Next | `SecureStore`, gestion du mode hors-ligne |
| Bundle analyzer, Core Web Vitals | EAS Build, Expo Updates OTA, versions minimales |

**Estimation réaliste du partage** : **65 à 75 %** du code (hors UI de présentation) est mutualisé. Il faut se méfier des promesses de « 95 % de code partagé » : l'UI de présentation reste, à raison, spécifique — c'est là que se joue la qualité perçue sur chaque plateforme.

### 3.3 Décisions structurantes justifiées

1. **Une seule app mobile, deux espaces** (Client / Pro), plutôt que deux applications distinctes.
   *Pourquoi* : un artisan est aussi un client ; deux apps signifient deux fiches store, deux processus de review, deux bases d'installation à faire croître, et un doublon de composants. Le basculement de contexte se fait au niveau du groupe de routes Expo Router (`(client)` / `(pro)`) selon les rôles portés par le compte.
   *Réévaluation* : si l'espace Pro devient très riche (planning, devis, facturation), une extraction en app dédiée reste possible sans réécriture, puisque toute la logique vit dans `packages/*`.

2. **tRPC plutôt que REST ou GraphQL.**
   REST impose d'écrire et de maintenir des types clients à la main (dérive garantie). GraphQL ajoute une couche de complexité (schéma, résolveurs, codegen, N+1) sans bénéfice ici, car un seul client contrôlé consomme l'API. tRPC donne le typage de bout en bout pour un coût quasi nul. Une façade REST via `trpc-openapi` reste possible pour des intégrations externes.

3. **Le serveur tRPC est hébergé dans `apps/web`** (Route Handler `app/api/trpc/[trpc]/route.ts`).
   *Pourquoi* : un déploiement de moins à opérer, une seule surface à surveiller.
   *Point de vigilance* : si les jobs lourds ou le trafic mobile venaient à peser sur le rendu web, l'extraction vers un `apps/api` (Fastify + tRPC) se fait en déplaçant un fichier d'entrée, puisque tous les routeurs vivent déjà dans `packages/api`.

4. **Modules métier étanches, appliqués par le linter.**
   Règle ESLint `no-restricted-imports` interdisant `@repo/api/src/modules/*/internal/*` et les imports croisés profonds entre modules. Sans contrainte automatisée, la modularité se dégrade en trois mois.

5. **Aucune intermédiation de paiement sur la prestation.**
   Cela simplifie considérablement la conformité (pas d'agrément d'établissement de paiement, pas de séquestre, pas de gestion de litiges financiers). En contrepartie, **la valeur perçue repose entièrement sur la qualité des leads et la fiabilité des statistiques** — d'où l'importance des principes P9 et P10.

---

## 4. Arborescence du monorepo

```
plateforme-artisans/
├── .github/
│   └── workflows/
│       ├── ci.yml                        # lint + typecheck + tests sur PR
│       ├── deploy-web.yml                # déploiement web + admin
│       ├── deploy-worker.yml
│       ├── mobile-preview.yml            # EAS build preview sur PR
│       └── mobile-release.yml            # EAS build + submit sur tag
│
├── apps/
│   ├── web/                              # Client + Vitrine SEO + host tRPC
│   │   ├── src/
│   │   │   ├── app/
│   │   │   │   ├── [locale]/
│   │   │   │   │   ├── (marketing)/      # vitrine publique
│   │   │   │   │   │   ├── page.tsx                       # accueil
│   │   │   │   │   │   ├── comment-ca-marche/page.tsx
│   │   │   │   │   │   ├── devenir-artisan/page.tsx
│   │   │   │   │   │   ├── tarifs/page.tsx
│   │   │   │   │   │   └── legal/[slug]/page.tsx          # CGU, CGV, confidentialité
│   │   │   │   │   ├── (search)/
│   │   │   │   │   │   ├── recherche/page.tsx
│   │   │   │   │   │   └── [categorySlug]/
│   │   │   │   │   │       └── [governorateSlug]/page.tsx # pages SEO locales (ISR)
│   │   │   │   │   ├── artisans/[slug]/
│   │   │   │   │   │   ├── page.tsx
│   │   │   │   │   │   ├── avis/page.tsx
│   │   │   │   │   │   └── opengraph-image.tsx
│   │   │   │   │   ├── (auth)/
│   │   │   │   │   │   ├── connexion/page.tsx
│   │   │   │   │   │   └── verification-otp/page.tsx
│   │   │   │   │   ├── (account)/
│   │   │   │   │   │   ├── favoris/page.tsx
│   │   │   │   │   │   ├── mes-contacts/page.tsx
│   │   │   │   │   │   ├── mes-avis/page.tsx
│   │   │   │   │   │   └── parametres/page.tsx
│   │   │   │   │   └── layout.tsx
│   │   │   │   ├── api/
│   │   │   │   │   ├── trpc/[trpc]/route.ts               # point d'entrée API unique
│   │   │   │   │   ├── webhooks/payments/[gateway]/route.ts
│   │   │   │   │   ├── uploads/presign/route.ts
│   │   │   │   │   └── cron/[job]/route.ts                # déclencheurs planifiés
│   │   │   │   ├── sitemap.ts
│   │   │   │   ├── robots.ts
│   │   │   │   └── globals.css
│   │   │   ├── components/               # composants propres au web
│   │   │   │   ├── search/
│   │   │   │   ├── provider/
│   │   │   │   ├── seo/                  # JsonLd, Breadcrumbs
│   │   │   │   └── ads/                  # AdSlot renderer
│   │   │   ├── lib/
│   │   │   │   ├── trpc/{client.ts,server.ts}
│   │   │   │   ├── seo/{metadata.ts,jsonld.ts}
│   │   │   │   └── analytics.ts
│   │   │   └── middleware.ts             # i18n, redirections, sécurité
│   │   ├── public/
│   │   ├── next.config.ts
│   │   ├── tailwind.config.ts
│   │   └── package.json
│   │
│   ├── admin/                            # Back-office (Next.js, non indexé)
│   │   ├── src/
│   │   │   ├── app/
│   │   │   │   ├── (auth)/login/page.tsx                   # 2FA obligatoire
│   │   │   │   └── (dashboard)/
│   │   │   │       ├── page.tsx                            # KPI globaux
│   │   │   │       ├── verifications/{page.tsx,[id]/page.tsx}
│   │   │   │       ├── moderation/{avis,signalements}/page.tsx
│   │   │   │       ├── artisans/{page.tsx,[id]/page.tsx}
│   │   │   │       ├── clients/page.tsx
│   │   │   │       ├── abonnements/page.tsx
│   │   │   │       ├── paiements/page.tsx
│   │   │   │       ├── boosts/page.tsx
│   │   │   │       ├── publicite/{annonceurs,campagnes}/page.tsx
│   │   │   │       ├── referentiel/{categories,geographie}/page.tsx
│   │   │   │       ├── parametres/{offres,ranking,feature-flags}/page.tsx
│   │   │   │       ├── equipe/page.tsx
│   │   │   │       └── audit/page.tsx
│   │   │   ├── components/{data-table,filters,charts,media-viewer}/
│   │   │   └── lib/{trpc,rbac,export-csv}.ts
│   │   └── package.json
│   │
│   ├── mobile/                           # Expo — Client + Prestataire
│   │   ├── app/                          # Expo Router (routing par fichiers)
│   │   │   ├── _layout.tsx               # providers : trpc, i18n, theme, auth
│   │   │   ├── index.tsx                 # splash / redirection selon rôle
│   │   │   ├── (auth)/
│   │   │   │   ├── login.tsx
│   │   │   │   ├── otp.tsx
│   │   │   │   └── role-select.tsx
│   │   │   ├── (client)/
│   │   │   │   ├── _layout.tsx           # onglets client
│   │   │   │   ├── home.tsx
│   │   │   │   ├── search/{index.tsx,results.tsx,filters.tsx}
│   │   │   │   ├── provider/[id]/{index.tsx,gallery.tsx,reviews.tsx}
│   │   │   │   ├── favorites.tsx
│   │   │   │   ├── contacts.tsx
│   │   │   │   ├── review/new/[contactId].tsx
│   │   │   │   └── requests/{index.tsx,new.tsx}
│   │   │   ├── (pro)/
│   │   │   │   ├── _layout.tsx           # onglets prestataire
│   │   │   │   ├── dashboard.tsx
│   │   │   │   ├── onboarding/[step].tsx
│   │   │   │   ├── profile/{edit.tsx,categories.tsx,areas.tsx,pricing.tsx,gallery.tsx,hours.tsx}
│   │   │   │   ├── verification/{index.tsx,upload.tsx,status.tsx}
│   │   │   │   ├── stats/{index.tsx,details.tsx}
│   │   │   │   ├── reviews/{index.tsx,reply/[id].tsx}
│   │   │   │   ├── billing/{plans.tsx,checkout.tsx,history.tsx}
│   │   │   │   ├── boosts/{index.tsx,new.tsx,credits.tsx}
│   │   │   │   └── leads/index.tsx
│   │   │   └── (shared)/{settings.tsx,notifications.tsx,language.tsx,legal/[slug].tsx}
│   │   ├── src/
│   │   │   ├── components/               # composants natifs propres à l'app
│   │   │   ├── hooks/
│   │   │   ├── lib/{trpc.ts,secure-store.ts,push.ts,linking.ts,image-picker.ts}
│   │   │   └── theme/
│   │   ├── assets/{images,fonts,icons}/
│   │   ├── app.config.ts
│   │   ├── eas.json
│   │   ├── metro.config.js               # résolution des packages du monorepo
│   │   └── package.json
│   │
│   └── worker/                           # Jobs asynchrones (Node + BullMQ)
│       ├── src/
│       │   ├── index.ts
│       │   ├── queues/{notifications,stats,billing,media,search-index}.ts
│       │   ├── jobs/
│       │   │   ├── aggregate-daily-stats.job.ts
│       │   │   ├── expire-subscriptions.job.ts
│       │   │   ├── expire-boosts.job.ts
│       │   │   ├── purge-kyc-media.job.ts
│       │   │   ├── send-review-reminder.job.ts
│       │   │   ├── send-weekly-digest.job.ts
│       │   │   ├── recompute-ranking.job.ts
│       │   │   └── refresh-search-view.job.ts
│       │   └── schedulers/cron.ts
│       ├── Dockerfile
│       └── package.json
│
├── packages/
│   ├── db/                               # Prisma : source de vérité des données
│   │   ├── prisma/
│   │   │   ├── schema.prisma
│   │   │   ├── migrations/
│   │   │   └── seed/
│   │   │       ├── index.ts
│   │   │       ├── governorates.ts       # 24 gouvernorats
│   │   │       ├── delegations.ts        # ~264 délégations
│   │   │       ├── categories.ts         # métiers FR/AR
│   │   │       ├── plans.ts
│   │   │       └── dev-fixtures.ts
│   │   ├── src/{client.ts,index.ts,types.ts,transaction.ts}
│   │   └── package.json
│   │
│   ├── core/                             # 🧠 Domaine métier pur (0 dépendance UI)
│   │   ├── src/
│   │   │   ├── providers/{ranking.ts,completion-score.ts,availability.ts,slug.ts}
│   │   │   ├── reviews/{eligibility.ts,aggregate.ts,spam-detection.ts}
│   │   │   ├── billing/{plan-limits.ts,subscription-period.ts,invoice-number.ts,pricing.ts}
│   │   │   ├── boosts/{cost.ts,slot-availability.ts,scheduling.ts}
│   │   │   ├── ads/{targeting.ts,rotation.ts}
│   │   │   ├── search/{query-builder.ts,scoring.ts}
│   │   │   ├── moderation/{rules.ts,severity.ts}
│   │   │   ├── geo/{distance.ts,coverage.ts}
│   │   │   ├── policies/{rbac.ts,quotas.ts}
│   │   │   └── errors/{domain-error.ts,codes.ts}
│   │   ├── tests/                        # Vitest — sans base, sans réseau
│   │   └── package.json
│   │
│   ├── api/                              # 🔌 Couche transport tRPC
│   │   ├── src/
│   │   │   ├── trpc.ts                   # initTRPC, context, procédures de base
│   │   │   ├── root.ts                   # export type AppRouter
│   │   │   ├── middlewares/{auth.ts,rbac.ts,rate-limit.ts,logging.ts,audit.ts}
│   │   │   └── modules/
│   │   │       ├── auth/{router.ts,service.ts,index.ts}
│   │   │       ├── users/
│   │   │       ├── providers/            # profil, catégories, zones, galerie
│   │   │       ├── catalog/              # catégories, géographie
│   │   │       ├── search/
│   │   │       ├── contacts/             # ContactEvent, tracking
│   │   │       ├── reviews/
│   │   │       ├── verification/
│   │   │       ├── billing/              # plans, abonnements, paiements
│   │   │       ├── credits/              # portefeuille, boosts
│   │   │       ├── ads/
│   │   │       ├── requests/             # demandes d'intervention
│   │   │       ├── notifications/
│   │   │       ├── analytics/            # stats artisan
│   │   │       ├── media/
│   │   │       └── admin/                # routeurs réservés au back-office
│   │   └── package.json
│   │
│   ├── validators/                       # Schémas Zod partagés
│   │   ├── src/{auth,provider,search,review,billing,boost,ad,media,admin,common}.ts
│   │   └── package.json
│   │
│   ├── auth/                             # Sessions, JWT, OTP, hachage, RBAC
│   │   ├── src/{jwt.ts,otp.ts,password.ts,session.ts,permissions.ts,two-factor.ts}
│   │   └── package.json
│   │
│   ├── ui/                               # 🖥️ Composants Web (React DOM + Tailwind)
│   │   ├── src/
│   │   │   ├── primitives/               # shadcn/ui : button, dialog, select...
│   │   │   ├── patterns/{ProviderCard,SearchBar,RatingStars,VerifiedBadge,PriceRange,Gallery,ReviewItem,EmptyState,AdBanner}/
│   │   │   └── styles/globals.css
│   │   └── package.json
│   │
│   ├── ui-native/                        # 📱 Composants Mobile (RN + NativeWind)
│   │   ├── src/
│   │   │   ├── primitives/{Button,Input,Sheet,Select,Skeleton}/
│   │   │   └── patterns/{ProviderCard,SearchBar,RatingStars,VerifiedBadge,Gallery,ReviewItem,EmptyState,AdBanner}/
│   │   └── package.json
│   │
│   ├── ui-logic/                         # 🔁 Hooks headless partagés Web ⇄ Mobile
│   │   ├── src/{useProviderSearch.ts,useProviderCard.ts,useReviewForm.ts,useOnboardingWizard.ts,useContactActions.ts,useBoostSimulator.ts,useMediaUpload.ts}
│   │   └── package.json
│   │
│   ├── design-tokens/                    # Couleurs, typo, espacements, radius
│   │   ├── src/{colors.ts,spacing.ts,typography.ts,radii.ts,index.ts}
│   │   ├── tailwind-preset.js            # consommé par Tailwind ET NativeWind
│   │   └── package.json
│   │
│   ├── i18n/
│   │   ├── src/
│   │   │   ├── locales/
│   │   │   │   ├── fr/{common,search,provider,billing,errors,legal}.json
│   │   │   │   └── ar/{common,search,provider,billing,errors,legal}.json
│   │   │   ├── config.ts
│   │   │   ├── format.ts                 # TND, dates, nombres
│   │   │   └── rtl.ts
│   │   └── package.json
│   │
│   ├── storage/                          # S3/R2 : presign, variantes, purge
│   │   ├── src/{client.ts,presign.ts,image-pipeline.ts,kyc-vault.ts}
│   │   └── package.json
│   │
│   ├── notifications/                    # Push, SMS, Email
│   │   ├── src/
│   │   │   ├── channels/{expo-push.ts,sms/{provider-a.ts,twilio.ts,index.ts},email.ts}
│   │   │   ├── templates/{fr,ar}/
│   │   │   └── dispatcher.ts             # idempotence + préférences utilisateur
│   │   └── package.json
│   │
│   ├── payments/                         # Adaptateurs passerelles
│   │   ├── src/
│   │   │   ├── gateway.interface.ts
│   │   │   ├── adapters/{konnect.ts,paymee.ts,flouci.ts,clictopay.ts,manual.ts}
│   │   │   ├── webhooks/verify.ts
│   │   │   └── invoice/pdf.ts
│   │   └── package.json
│   │
│   ├── analytics/                        # Événements produit unifiés
│   │   ├── src/{events.ts,client.web.ts,client.native.ts,index.ts}
│   │   └── package.json
│   │
│   ├── utils/                            # Utilitaires purs
│   │   ├── src/{phone-tn.ts,whatsapp-link.ts,slugify.ts,date.ts,currency.ts,hash.ts,pagination.ts,result.ts}
│   │   └── package.json
│   │
│   ├── constants/
│   │   ├── src/{categories.ts,governorates.ts,report-reasons.ts,limits.ts,error-codes.ts,routes.ts}
│   │   └── package.json
│   │
│   ├── config/
│   │   ├── src/env.ts                    # validation Zod des variables d'env
│   │   └── package.json
│   │
│   ├── tsconfig/{base.json,nextjs.json,react-native.json,node.json,package.json}
│   ├── eslint-config/{base.js,next.js,react-native.js,package.json}
│   └── testing/                          # helpers de test, factories, BDD de test
│       ├── src/{factories,db-test-utils.ts,msw-handlers.ts}
│       └── package.json
│
├── docs/
│   ├── 00-cadrage.md                     # ce document
│   ├── 01-architecture-decision-records/  # ADR numérotés
│   ├── 02-api-conventions.md
│   ├── 03-ranking-algorithm.md
│   ├── 04-security-and-privacy.md        # INPDP, gestion CIN
│   ├── 05-runbook.md                     # incidents, restauration, astreinte
│   └── 06-release-process.md
│
├── tooling/
│   ├── scripts/{setup.sh,reset-db.sh,generate-module.ts}
│   └── docker/{docker-compose.dev.yml,postgres/init.sql}
│
├── .env.example
├── .gitignore
├── .npmrc
├── package.json
├── pnpm-workspace.yaml
├── turbo.json
└── README.md
```

### 4.1 Fichiers de configuration clés

**`pnpm-workspace.yaml`**
```yaml
packages:
  - "apps/*"
  - "packages/*"
  - "packages/tsconfig"
  - "packages/eslint-config"
```

**`turbo.json`** (extrait)
```jsonc
{
  "$schema": "https://turbo.build/schema.json",
  "globalDependencies": [".env"],
  "tasks": {
    "build":     { "dependsOn": ["^build"], "outputs": [".next/**", "dist/**"] },
    "dev":       { "cache": false, "persistent": true },
    "lint":      { "dependsOn": ["^build"] },
    "typecheck": { "dependsOn": ["^build"] },
    "test":      { "dependsOn": ["^build"], "outputs": ["coverage/**"] },
    "db:generate": { "cache": false },
    "db:migrate":  { "cache": false, "persistent": true }
  }
}
```

**Convention de nommage des packages** : préfixe `@repo/` (`@repo/db`, `@repo/api`, `@repo/ui`…), dépendances internes déclarées en `"workspace:*"`.

**Point de vigilance Metro** : `metro.config.js` doit activer `watchFolders` sur la racine du monorepo et `disableHierarchicalLookup: false`, sans quoi Expo ne résoudra pas les packages internes. C'est le piège classique numéro un d'un monorepo RN — à traiter dès le premier jour.

---

## 5. Annexes techniques

### Annexe A — Algorithme de ranking

Le classement conditionne directement le chiffre d'affaires : il doit être **explicable, paramétrable et auditable**. Les poids sont stockés dans `AppSetting` et modifiables depuis le back-office (`US-A-09`).

```
score = w1 · pertinenceGeo        // 1.0 délégation exacte, 0.6 gouvernorat, 0.3 limitrophe
      + w2 · qualiteReputation    // note bayésienne lissée (voir ci-dessous)
      + w3 · confiance            // badge vérifié = 1, sinon 0
      + w4 · completudeProfil     // completionScore / 100
      + w5 · reactivite           // basée sur lastActiveAt et availabilityStatus
      + w6 · facteurPlan          // Plan.rankingBoostFactor (1.0 gratuit, 1.3 Pro)
      − w7 · penaliteSignalements

// Les boosts actifs ne modifient PAS ce score : ils occupent des emplacements
// distincts en tête de liste, explicitement étiquetés « Sponsorisé ».
```

**Note bayésienne** (évite qu'un artisan avec un seul avis 5★ devance un artisan avec 80 avis à 4,7★) :

```
noteLissee = (C · m + Σ notes) / (C + n)
   où m = note moyenne de la plateforme, C ≈ 8 (avis « virtuels » de référence)
```

Une **rotation équitable** est appliquée à score égal (± 2 %) afin d'éviter qu'un même artisan monopolise la première position et de donner leur chance aux nouveaux inscrits.

### Annexe B — Sécurité & conformité (loi organique n°2004-63, INPDP)

| Domaine | Mesures |
|---|---|
| **Données KYC** | Bucket privé, chiffrement au repos (SSE), numéro de CIN jamais en clair (hash + chiffrement AES-256-GCM si conservation nécessaire), URL signée 5 min, journalisation de chaque accès, purge automatique des images à J+X après décision |
| **Authentification** | OTP haché (jamais stocké en clair), 3 tentatives max, rate limiting par téléphone et par IP, refresh tokens rotatifs et révocables, 2FA obligatoire pour les comptes internes |
| **Autorisation** | RBAC centralisé dans `packages/core/policies`, appliqué par middleware tRPC ; **aucun contrôle uniquement côté client** |
| **Données personnelles** | Consentement horodaté et versionné, droit d'accès/export/suppression (`US-C-13`), minimisation, durées de conservation documentées, déclaration INPDP à effectuer avant la mise en production |
| **Anti-abus** | Rate limiting (OTP, contacts, avis, uploads), détection de comptes multiples par appareil, avis liés à un contact réel, modération assistée |
| **Infrastructure** | Secrets en coffre (jamais dans le dépôt), HTTPS strict + HSTS, CSP, dépendances auditées, sauvegardes PITR quotidiennes avec restauration **testée trimestriellement** |
| **Scraping** | Numéros non exposés en HTML brut, révélation via appel API tracé et limité, détection de comportements automatisés |

### Annexe C — Feuille de route indicative

| Phase | Périmètre | Durée estimée |
|---|---|---|
| **Phase 0 — Socle** | Monorepo, CI/CD, schéma BDD, seed géographique, auth OTP, design system, i18n | 3–4 semaines |
| **Phase 1 — MVP Client** | Recherche, filtres, profil artisan, contact tel/WhatsApp + tracking, avis, pages SEO | 4–5 semaines |
| **Phase 2 — MVP Artisan** | Onboarding, profil, catégories, zones, tarifs, galerie, KYC, tableau de bord statistiques | 4–5 semaines |
| **Phase 3 — Back-office** | Vérifications, modération, gestion des comptes, référentiel, dashboard | 3 semaines |
| **Phase 4 — Monétisation** | Plans, abonnements, paiements (en ligne + manuel), crédits, boosts, facturation | 3–4 semaines |
| **Phase 5 — Régie & croissance** | Publicité B2B, notifications, digest hebdomadaire, demandes d'intervention | 3 semaines |
| **Phase 6 — Durcissement** | Performance, tests E2E, observabilité, conformité INPDP, préparation au lancement | 2 semaines |

### Annexe D — Indicateurs de succès à instrumenter dès le jour 1

| Catégorie | Indicateurs |
|---|---|
| **Acquisition** | Installations, visiteurs SEO, inscriptions client/artisan, coût par artisan inscrit |
| **Activation** | Taux de complétion de l'onboarding artisan, % de profils publiés, % de profils vérifiés |
| **Engagement** | Recherches par utilisateur, taux vue → contact, contacts par artisan et par mois |
| **Rétention** | Artisans actifs à 30/60/90 jours, clients revenant après 90 jours |
| **Revenu** | Taux de conversion Gratuit → Pro, MRR, ARPU, churn, revenus crédits, revenus publicitaires |
| **Qualité** | Note moyenne, taux d'avis par contact, taux de signalement, délai moyen de vérification KYC |

---

## 6. Questions de clarification

Trois zones d'ombre bloquent des décisions structurantes. Les réponses conditionnent des choix qu'il sera coûteux de revoir après le début du développement.

### ❓ Question 1 — Quelle est la véritable nature du badge « Artisan Vérifié » ?

Le cadrage contient une ambiguïté commerciale importante : la vérification de la CIN est décrite comme **gratuite et accessible à tous** dans la section « Prestataire », mais le badge certifié apparaît comme une **contrepartie du Pack Pro payant** dans le modèle économique. Ces deux lectures s'excluent.

- **Option A — Badge gratuit fondé sur l'identité** : tout artisan soumettant une CIN valide obtient le badge, y compris en offre gratuite. Le Pack Pro vend alors la *visibilité* (classement, quotas, leads instantanés), pas la confiance. C'est l'option que je recommande : elle maximise le volume d'artisans vérifiés, donc la valeur perçue par le client, donc l'audience — le vrai actif de la plateforme.
- **Option B — Badge réservé au Pack Pro** : monétisation plus directe, mais elle crée une majorité d'artisans non vérifiés, ce qui affaiblit précisément la promesse de confiance qui vous différencie des groupes Facebook.
- **Option C — Deux niveaux** : « Identité vérifiée » (gratuit, CIN) et « Artisan Pro Certifié » (payant : CIN + patente + assurance + ancienneté + note minimale).

**Impact technique** : la modélisation actuelle (`isVerified` sur le profil, indépendant de `Subscription`) implémente l'option A ou C. L'option B exigerait de lier le badge au cycle de vie de l'abonnement, avec toutes les conséquences en cascade (retrait automatique à l'expiration, ré-attribution au renouvellement, gestion de la période de grâce).

---

### ❓ Question 2 — Quels moyens de paiement pour les artisans, et à quelle échéance ?

Le cadrage mentionne « encaissement manuel/espèces, virement ou en ligne » sans arbitrage. Or l'expérience du marché tunisien montre qu'une part importante des artisans indépendants n'utilise pas de carte bancaire en ligne.

- Quelle **répartition cible** envisagez-vous entre espèces, virement et paiement en ligne au lancement ?
- Disposez-vous d'une **équipe terrain** (agents commerciaux) pour l'encaissement en espèces ? Si oui, il faut prévoir dès le MVP : rôle `SALES`, application ou écran de collecte, codes de collecte, réconciliation, commissions — ce qui n'est pas trivial.
- Souhaitez-vous intégrer une passerelle en ligne dès la V1, et laquelle (**Konnect**, **Paymee**, **Flouci**, **ClicToPay/SMT**) ? Le choix dépend de vos accords existants, des frais et de la disponibilité d'un compte marchand.
- Le **prélèvement automatique récurrent** est-il envisagé, ou chaque renouvellement sera-t-il une action manuelle de l'artisan ? Cela change radicalement la modélisation du renouvellement et vos hypothèses de churn.

**Impact technique** : l'architecture prévoit une interface `PaymentGateway` avec adaptateurs, ce qui rend le fournisseur interchangeable. En revanche, l'encaissement terrain à grande échelle est un module à part entière (réconciliation, traçabilité, anti-fraude interne) qu'il faut budgéter explicitement s'il est stratégique.

---

### ❓ Question 3 — La plateforme reste-t-elle un annuaire, ou évolue-t-elle vers une place de marché transactionnelle ?

Vous excluez explicitement l'intermédiation de paiement de la prestation. C'est un choix défendable et prudent, mais il détermine la trajectoire du produit et son architecture.

- **Risque de désintermédiation** : une fois le numéro obtenu, le client peut rappeler l'artisan directement — la plateforme n'est alors plus dans la boucle et ne perçoit rien. Comment comptez-vous maintenir la valeur dans le temps : par les avis, par l'historique, par la garantie, par les demandes d'intervention (`US-C-10`) ?
- **Mesure du succès** : sans transaction observée, vous ne savez pas si le contact a débouché sur une intervention. Or c'est exactement l'argument que l'artisan attend pour renouveler son abonnement. Faut-il prévoir dès la V1 une confirmation légère (« Cette intervention a-t-elle eu lieu ? ») envoyée aux deux parties, qui alimenterait à la fois les statistiques et la certification des avis ?
- **Horizon 12–24 mois** : envisagez-vous à terme une messagerie interne, des devis, une réservation de créneau, une commission sur transaction, ou une garantie plateforme ? Si oui, même à l'état d'hypothèse, il faut préserver les points d'extension dès maintenant (les entités `ServiceRequest` / `ServiceRequestMatch` sont déjà modélisées à cet effet) plutôt que d'y revenir par une migration lourde.

**Impact technique** : la réponse détermine si `ContactEvent` reste un simple événement de tracking ou devient l'amorce d'un cycle de vie de mission (`Lead → Devis → Intervention → Paiement → Avis`), ce qui est une décision de modélisation majeure.

---

> **Prochaine étape recommandée** : valider ce document, trancher les trois questions ci-dessus, puis produire les ADR correspondants dans `docs/01-architecture-decision-records/` avant l'initialisation du monorepo (`US-T-01`).
