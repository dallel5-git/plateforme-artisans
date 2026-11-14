# Product Backlog — Application Mobile Sanaya (Flutter)

---

## 1. Vue d'Ensemble & Cadre Méthodologique

Ce document constitue le **Product Backlog officiel et vivant** du lot mobile de l'application **Sanaya**. Il formalise l'intégralité des 26 tâches nécessaires à la stabilisation, à l'accessibilité, à la conformité fonctionnelle et à la préparation de mise en production de l'application sur le marché tunisien.

* **Méthodologie :** Scrum / Agile Mobile.
* **Échelle d'estimation :** Suite de Fibonacci (1, 2, 3, 5, 8, 13 Story Points).
* **Statut initial de toutes les tâches :** `To Do`.
* **Référentiel de branches Git :** `chayma-branche/MOB-XXX`.
* **Branche cible des Pull Requests :** `develop`.

---

## 2. Tableau Récapitulatif du Backlog

| ID | Epic | Tâche | Priorité | Story Points | Statut |
| :---: | :--- | :--- | :---: | :---: | :---: |
| **MOB-001** | EPIC 1 : Correctifs Bloquants | Déblocage de la route d'onboarding pro pour les clients | 🔴 P0 | 3 | To Do |
| **MOB-002** | EPIC 1 : Correctifs Bloquants | Protection du refresh token lors des pannes réseau / offline | 🔴 P0 | 2 | To Do |
| **MOB-003** | EPIC 1 : Correctifs Bloquants | Enregistrement des jetons PROVIDER à l'étape 1 de l'onboarding | 🔴 P0 | 3 | To Do |
| **MOB-004** | EPIC 1 : Correctifs Bloquants | Déclaration des permissions iOS et des intents `<queries>` Android | 🔴 P0 | 2 | To Do |
| **MOB-005** | EPIC 2 : Robustesse & Données | Réassignation automatique de la catégorie principale en onboarding | 🟠 P1 | 2 | To Do |
| **MOB-006** | EPIC 2 : Robustesse & Données | Nettoyage complet des caches et états Riverpod à la déconnexion | 🟠 P1 | 3 | To Do |
| **MOB-007** | EPIC 2 : Robustesse & Données | Gestion de l'authentification requise sur les favoris en mode visiteur | 🟠 P1 | 3 | To Do |
| **MOB-008** | EPIC 2 : Robustesse & Données | Sécurisation défensive du parsing JSON dans le cache Hive | 🟠 P1 | 1 | To Do |
| **MOB-009** | EPIC 2 : Robustesse & Données | Gestion d'erreur et feedback visuel en cas d'échec du service contact | 🟠 P1 | 2 | To Do |
| **MOB-010** | EPIC 3 : Ergonomie & RTL | Élimination du débordement RenderFlex lors de l'ouverture du clavier | 🟠 P1 | 2 | To Do |
| **MOB-011** | EPIC 3 : Ergonomie & RTL | Correction du sens LTR et dimension tactile (48dp) des cases OTP | 🟠 P1 | 3 | To Do |
| **MOB-012** | EPIC 3 : Ergonomie & RTL | Miroitage RTL des boutons et flèches de retour | 🟡 P2 | 1 | To Do |
| **MOB-013** | EPIC 3 : Ergonomie & RTL | Suppression du doublon du bandeau hors-ligne sur les résultats | 🟡 P2 | 1 | To Do |
| **MOB-014** | EPIC 3 : Ergonomie & RTL | Sécurisation de l'affichage des SnackBars sur petits écrans | 🟡 P2 | 1 | To Do |
| **MOB-015** | EPIC 4 : Recherche & Découverte | Prise en compte de la saisie textuelle de recherche d'accueil | 🟡 P2 | 3 | To Do |
| **MOB-016** | EPIC 4 : Recherche & Découverte | Formatage défensif du séparateur de sous-titre de la carte artisan | 🟢 P3 | 1 | To Do |
| **MOB-017** | EPIC 4 : Recherche & Découverte | Intégration de la recherche plein texte multi-critères avec l'API | 🟡 P2 | 5 | To Do |
| **MOB-018** | EPIC 5 : Espace Pro & Gestion | Ajout de l'action "Devenir artisan" dans le profil client | 🟠 P1 | 2 | To Do |
| **MOB-019** | EPIC 5 : Espace Pro & Gestion | Ajout du pull-to-refresh et affichage du statut sur le Dashboard | 🟡 P2 | 2 | To Do |
| **MOB-020** | EPIC 5 : Espace Pro & Gestion | Interface d'édition post-onboarding des catégories et zones pro | 🟡 P2 | 5 | To Do |
| **MOB-021** | EPIC 5 : Espace Pro & Gestion | Interface de gestion post-onboarding du portfolio et galerie | 🟡 P2 | 5 | To Do |
| **MOB-022** | EPIC 5 : Espace Pro & Gestion | Module de consultation et d'édition des tarifs et prestations pro | 🟡 P2 | 5 | To Do |
| **MOB-023** | EPIC 6 : Branding & Production | Création d'un écran Splash immersif avec branding Sanaya | 🟡 P2 | 2 | To Do |
| **MOB-024** | EPIC 6 : Branding & Production | Intégration des icônes de store et des illustrations de catégories | 🟡 P2 | 3 | To Do |
| **MOB-025** | EPIC 6 : Branding & Production | Configuration Cleartext HTTP et règles ProGuard/R8 de release | 🟠 P1 | 2 | To Do |
| **MOB-026** | EPIC 6 : Branding & Production | Automatisation du contrôle anti-fuite de secrets et script release | 🟡 P2 | 3 | To Do |

**Total : 26 Tâches · 68 Story Points**

---

## 3. Détail Exhaustif des User Stories

---

### EPIC 1 : Correctifs Bloquants & Résilience Système

#### MOB-001 : Déblocage de la route d'onboarding pro pour les clients
* **ID :** `MOB-001`
* **Epic :** EPIC 1 : Correctifs Bloquants & Résilience Système
* **Titre :** Autoriser l'accès à l'onboarding pour les utilisateurs connectés ayant le rôle Client
* **Description :** Actuellement, la garde de redirection dans `router.dart` intercepte toute route sous `/pro/*` pour les utilisateurs n'ayant pas le rôle `PROVIDER` et les renvoie vers `/client`. Or, à l'inscription par OTP, tout nouvel utilisateur reçoit par défaut le rôle `CLIENT`. Il est donc impossible pour un utilisateur régulier d'accéder à l'onboarding pour créer son profil artisan. La route `/pro/onboarding` doit être autorisée pour tout utilisateur authentifié.
* **User Story :** En tant qu'utilisateur particulier connecté, je veux pouvoir accéder au formulaire d'onboarding artisan, afin de créer mon profil professionnel et proposer mes prestations sur Sanaya.
* **Problème identifié :** Réf. Audit PB-01. Blocage structurel du routeur empêchant la création de nouveaux artisans.
* **Fichiers concernés :** `Code/apps/mobile/lib/app/router.dart`
* **Priorité :** 🔴 P0 – Critical
* **Estimation :** 3 Story Points
* **Dépendances :** Aucune
* **Critères d'acceptation :**
  1. Si un utilisateur connecté avec `roles: ['CLIENT']` navigue vers `/pro/onboarding`, il accède à l'écran sans être redirigé vers `/client`.
  2. L'accès anonyme (non connecté) vers `/pro/onboarding` redirige bien vers `/auth`.
  3. L'accès aux autres sous-routes `/pro/*` (ex: `/pro/dashboard`) reste strictement réservé aux sessions disposant déjà du rôle `PROVIDER`.
  4. Les tests unitaires du routeur dans `Code/apps/mobile/test/app/router_redirect_test.dart` sont complétés et passent avec succès.
* **Résultat attendu :** L'onboarding artisan devient accessible à tous les utilisateurs enregistrés de la plateforme.
* **Statut :** To Do

---

#### MOB-002 : Protection du refresh token lors des pannes réseau / offline
* **ID :** `MOB-002`
* **Epic :** EPIC 1 : Correctifs Bloquants & Résilience Système
* **Titre :** Conditionner la purge du stockage sécurisé aux seules erreurs HTTP 401/403
* **Description :** Dans `AuthTokenStore._doRefresh()`, la clause `catch (DioException)` invoque systématiquement `await clear()`. Si l'utilisateur lance l'application en zone sans réseau (mode avion, zone blanche ou instabilité 3G), l'échec de la connexion est traité comme une invalidité du jeton et supprime le refresh token du Keystore/Keychain. L'utilisateur est alors déconnecté de force.
* **User Story :** En tant qu'utilisateur ouvrant l'application dans une zone avec une mauvaise connexion 3G ou sans réseau, je veux rester connecté à mon compte, afin de ne pas avoir à ressaisir mon numéro et mon code OTP à chaque coupure.
* **Problème identifié :** Réf. Audit PB-02. Déconnexion destructrice et violation de l'invariant P5 (low-bandwidth-first).
* **Fichiers concernés :** `Code/apps/mobile/lib/core/api/auth_token_store.dart`
* **Priorité :** 🔴 P0 – Critical
* **Estimation :** 2 Story Points
* **Dépendances :** Aucune
* **Critères d'acceptation :**
  1. Une erreur de type `DioExceptionType.connectionTimeout`, `sendTimeout`, `receiveTimeout` ou `connectionError` ne déclenche aucun appel à `clear()`.
  2. La purge des identifiants n'est exécutée que si la réponse du serveur porte un statut HTTP 401 ou 403.
  3. La méthode `restoreSession()` retourne `false` en cas d'erreur réseau sans altérer le refresh token stocké.
  4. Le test unitaire `Code/apps/mobile/test/core/api/auth_token_store_test.dart` confirme la rétention du jeton sur coupure réseau simulée.
* **Résultat attendu :** Persistance robuste de la session même en cas d'indisponibilité passagère de l'API.
* **Statut :** To Do

---

#### MOB-003 : Enregistrement des jetons PROVIDER à l'étape 1 de l'onboarding
* **ID :** `MOB-003`
* **Epic :** EPIC 1 : Correctifs Bloquants & Résilience Système
* **Titre :** Mettre à jour `AuthTokenStore` et l'état Riverpod avec la réponse de `POST /providers/me`
* **Description :** Lorsque l'artisan valide l'étape 1 de son profil, l'API `POST /v1/providers/me` lui attribue le rôle `PROVIDER` et renvoie une nouvelle paire `accessToken` et `refreshToken`. Actuellement, `OnboardingNotifier.saveProfile` ne stocke pas ces jetons. Le client Dio continue d'envoyer l'ancien token (portant uniquement le rôle `CLIENT`). Lorsque l'étape 2 appelle `PUT /providers/me/categories`, le serveur exige `PROVIDER` et renvoie un 403 Forbidden bloquant.
* **User Story :** En tant qu'artisan finalisant la première étape de mon profil, je veux que mes nouveaux droits professionnels soient enregistrés immédiatement, afin de pouvoir configurer mes catégories et zones d'intervention sans être bloqué.
* **Problème identifié :** Réf. Audit PB-03. Blocage de l'onboarding à l'étape 2 par erreur 403 Forbidden.
* **Fichiers concernés :**
  * `Code/apps/mobile/lib/features/onboarding/application/onboarding_notifier.dart`
  * `Code/apps/mobile/lib/features/onboarding/data/onboarding_repository.dart`
* **Priorité :** 🔴 P0 – Critical
* **Estimation :** 3 Story Points
* **Dépendances :** MOB-001
* **Critères d'acceptation :**
  1. Après succès de `_repo.createProfile(body)`, les nouveaux jetons reçus sont persistés via `AuthTokenStore.saveSession`.
  2. `AuthStateNotifier.setAuthenticated` est appelé pour propager le nouveau rôle `PROVIDER`.
  3. L'étape 2 (`setCategories`) émet sa requête avec le jeton actualisé et reçoit un code 200 OK.
  4. Aucun écran de blocage 403 n'interrompt le parcours d'inscription.
* **Résultat attendu :** Enchaînement fluide de l'ensemble des 5 étapes d'onboarding artisan.
* **Statut :** To Do

---

#### MOB-004 : Déclaration des permissions iOS et des intents `<queries>` Android
* **ID :** `MOB-004`
* **Epic :** EPIC 1 : Correctifs Bloquants & Résilience Système
* **Titre :** Renseigner les schémas d'intent Android et les déclarations d'usage média iOS
* **Description :** Sur Android 11+ (API 30+), la visibilité des paquets est restreinte : sans déclarer les schémas `tel:` et `https:` dans `<queries>`, `url_launcher` ne peut pas ouvrir le composeur téléphonique ni WhatsApp. Sur iOS, l'absence de `NSPhotoLibraryUsageDescription` et `NSCameraUsageDescription` fait planter l'application immédiatement dès qu'un utilisateur tente d'ajouter une photo de portfolio.
* **User Story :** En tant qu'utilisateur mobile, je veux pouvoir appeler un artisan, lui écrire sur WhatsApp et ajouter des photos depuis ma caméra ou galerie sans crash ni blocage système.
* **Problème identifié :** Réf. Audit PB-04. Crash garanti sur iOS et blocage des deep links sur Android 11+.
* **Fichiers concernés :**
  * `Code/apps/mobile/android/app/src/main/AndroidManifest.xml`
  * `Code/apps/mobile/ios/Runner/Info.plist`
* **Priorité :** 🔴 P0 – Critical
* **Estimation :** 2 Story Points
* **Dépendances :** Aucune
* **Critères d'acceptation :**
  1. `AndroidManifest.xml` contient les déclarations `<queries>` pour `tel`, `https` et le package `com.whatsapp`.
  2. `Info.plist` contient les clés descriptives d'accès à la caméra et à la bibliothèque d'images en français et arabe.
  3. `LSApplicationQueriesSchemes` inclut `tel`, `https` et `whatsapp` sur iOS.
  4. La sélection d'images dans l'onboarding fonctionne sans crash sur simulateur et appareil iOS.
* **Résultat attendu :** Intégration système 100 % conforme aux exigences de sécurité d'Apple et de Google.
* **Statut :** To Do

---

### EPIC 2 : Robustesse Fonctionnelle & Gestion des Données

#### MOB-005 : Réassignation automatique de la catégorie principale en onboarding
* **ID :** `MOB-005`
* **Epic :** EPIC 2 : Robustesse Fonctionnelle & Gestion des Données
* **Titre :** Garantir la présence d'exactement une catégorie `isPrimary: true` lors de la désélection
* **Description :** Dans `OnboardingCategoriesStep`, si un artisan désélectionne la catégorie qu'il avait marquée comme principale (`isPrimary: true`), la liste transmise ne comporte plus aucune catégorie principale. L'API backend Fastify exige rigoureusement qu'exactement une catégorie soit marquée principale, déclenchant une erreur de validation `VALIDATION_ERROR` (HTTP 422).
* **User Story :** En tant qu'artisan modifiant mes choix de spécialités, je veux pouvoir désélectionner une catégorie sans bloquer mon inscription par une erreur technique.
* **Problème identifié :** Réf. Audit PB-05. Rejet serveur lors de la désélection de la catégorie principale.
* **Fichiers concernés :** `Code/apps/mobile/lib/features/onboarding/presentation/widgets/onboarding_categories_step.dart`
* **Priorité :** 🟠 P1 – High
* **Estimation :** 2 Story Points
* **Dépendances :** MOB-003
* **Critères d'acceptation :**
  1. Si la catégorie retirée était `isPrimary == true` et qu'il reste d'autres catégories cochées, la première restante hérite automatiquement du statut `isPrimary = true`.
  2. Le tableau final envoyé à `PUT /providers/me/categories` contient obligatoirement un et un seul `isPrimary: true`.
  3. Aucune erreur 422 n'est générée côté API suite à une modification de sélection.
* **Résultat attendu :** Gestion saine et sans accroc des choix de catégories artisanales.
* **Statut :** To Do

---

#### MOB-006 : Nettoyage complet des caches et états Riverpod à la déconnexion
* **ID :** `MOB-006`
* **Epic :** EPIC 2 : Robustesse Fonctionnelle & Gestion des Données
* **Titre :** Purger les états privés, les préférences et les caches lors de `signOut()`
* **Description :** L'action de déconnexion actuelle se contente d'effacer les jetons et d'appeler l'API de logout. L'état `hasPublishedProfileProvider` reste à `true`, les favoris, l'historique de contact et les données de l'artisan restent en cache mémoire dans Riverpod et dans la base Hive locale.
* **User Story :** En tant qu'utilisateur se déconnectant de l'application, je veux que mes données personnelles et mes fiches privées ne soient plus accessibles sur l'appareil.
* **Problème identifié :** Réf. Audit PB-08. Fuite d'état et persistance stale post-déconnexion.
* **Fichiers concernés :**
  * `Code/apps/mobile/lib/features/auth/application/auth_state_provider.dart`
  * `Code/apps/mobile/lib/features/onboarding/data/publication_status_persistence.dart`
* **Priorité :** 🟠 P1 – High
* **Estimation :** 3 Story Points
* **Dépendances :** MOB-002
* **Critères d'acceptation :**
  1. `signOut()` réinitialise `hasPublishedProfileProvider` et supprime la valeur de SharedPreferences.
  2. Invalidation explicite de `currentUserProvider`, `favoritesListProvider`, `contactHistoryProvider`, `dashboardStatsProvider` et `myProviderProfileProvider`.
  3. Reconnexion sur un autre compte : aucune donnée de la session précédente n'apparaît.
* **Résultat attendu :** Conformité aux règles de confidentialité (INPDP) et étanchéité absolue entre sessions.
* **Statut :** To Do

---

#### MOB-007 : Gestion de l'authentification requise sur les favoris en mode visiteur
* **ID :** `MOB-007`
* **Epic :** EPIC 2 : Robustesse Fonctionnelle & Gestion des Données
* **Titre :** Intercepter les favoris non authentifiés et bloquer les appels réseau inutiles
* **Description :** Sur les cartes d'artisans (`ProviderCard`), le bouton favori déclenche `favoritesListProvider` même pour un utilisateur non connecté, ce qui engendre un appel `GET /v1/favorites` voué à l'échec (401 Unauthorized). De plus, cliquer sur le cœur en invité affiche une SnackBar d'erreur rouge agressive sans expliquer qu'il faut se connecter.
* **User Story :** En tant que visiteur non connecté consultant les artisans, je veux être informé qu'un compte est nécessaire lorsque je clique sur le cœur, afin de pouvoir me connecter en un clic.
* **Problème identifié :** Réf. Audit PB-09. Trafic 401 intempestif et expérience visiteur dégradée.
* **Fichiers concernés :**
  * `Code/apps/mobile/lib/core/widgets/provider_card.dart`
  * `Code/apps/mobile/lib/features/favorites/application/favorites_providers.dart`
* **Priorité :** 🟠 P1 – High
* **Estimation :** 3 Story Points
* **Dépendances :** Aucune
* **Critères d'acceptation :**
  1. `FavoritesListNotifier.build()` renvoie une liste vide immédiate si la session est non authentifiée, sans appel réseau.
  2. Cliquer sur le favori en mode anonyme affiche une SnackBar informative avec un bouton d'action "Se connecter".
  3. Le bouton d'action ouvre la route `/auth`.
* **Résultat attendu :** Optimisation des requêtes réseau et amélioration du taux de conversion visiteur -> utilisateur.
* **Statut :** To Do

---

#### MOB-008 : Sécurisation défensive du parsing JSON dans le cache Hive
* **ID :** `MOB-008`
* **Epic :** EPIC 2 : Robustesse Fonctionnelle & Gestion des Données
* **Titre :** Intercepter les `TypeError` lors de la lecture du cache disque
* **Description :** `DiskCache.read` n'intercepte que `FormatException`. Si la donnée stockée dans la boîte Hive retourne un type inattendu (ex: `List` ou primitif), le cast explicite `as Map<String, dynamic>` lève une `TypeError` non interceptée qui fait planter les écrans hors-ligne.
* **User Story :** En tant qu'utilisateur consultant l'application en mode hors-ligne, je veux que l'application reste stable même si des données en cache local sont altérées.
* **Problème identifié :** Réf. Audit section 4. Vulnérabilité au crash lors de la lecture du cache Hive.
* **Fichiers concernés :** `Code/apps/mobile/lib/core/cache/disk_cache.dart`
* **Priorité :** 🟠 P1 – High
* **Estimation :** 1 Story Point
* **Dépendances :** Aucune
* **Critères d'acceptation :**
  1. La méthode vérifie `if (decoded is Map<String, dynamic>)` de manière défensive.
  2. Tout type divergent ou corrompu retourne `null` de manière transparente et sécurisée.
* **Résultat attendu :** Résilience totale du cache local face aux corruptions potentielles.
* **Statut :** To Do

---

#### MOB-009 : Gestion d'erreur et feedback visuel en cas d'échec du service contact
* **ID :** `MOB-009`
* **Epic :** EPIC 2 : Robustesse Fonctionnelle & Gestion des Données
* **Titre :** Notifier clairement l'utilisateur si un premier contact hors-ligne est impossible
* **Description :** Dans `ContactService`, si un utilisateur tente pour la première fois d'appeler un artisan hors-ligne, le numéro complet n'a jamais été révélé par l'API (conformité P8/INPDP). `fallbackPhone` étant nul, le lien ne peut pas s'ouvrir, mais aucun message n'est présenté à l'utilisateur, donnant l'impression que le bouton est cassé.
* **User Story :** En tant qu'utilisateur sans réseau cliquant sur "Appeler", je veux être prévenu par un message explicite si le numéro de l'artisan ne peut pas être récupéré.
* **Problème identifié :** Réf. Audit section 4. Manque de feedback utilisateur en situation de réseau déconnecté.
* **Fichiers concernés :**
  * `Code/apps/mobile/lib/features/contact/domain/contact_service.dart`
  * `Code/apps/mobile/lib/features/contact/presentation/contact_buttons.dart`
* **Priorité :** 🟠 P1 – High
* **Estimation :** 2 Story Points
* **Dépendances :** MOB-004
* **Critères d'acceptation :**
  1. Une alerte ou SnackBar bilingue informe l'utilisateur qu'une connexion initiale est requise pour contacter ce nouvel artisan.
  2. L'événement reste correctement mis en file d'attente locale (`ContactQueue`) pour garantir la traçabilité P9.
* **Résultat attendu :** Expérience utilisateur fluide et compréhensible en réseau dégradé.
* **Statut :** To Do

---

### EPIC 3 : Ergonomie Mobile, Accessibilité Chantier & RTL

#### MOB-010 : Élimination du débordement RenderFlex sur la saisie téléphone
* **ID :** `MOB-010`
* **Epic :** EPIC 3 : Ergonomie Mobile, Accessibilité Chantier & RTL
* **Titre :** Envelopper `PhoneEntryStep` dans une vue défilable adaptative
* **Description :** L'écran de saisie du numéro de téléphone utilise une `Column` rigide avec un `Spacer()`. Lorsque le clavier virtuel s'ouvre sur un smartphone à écran compact (360x640 ou 360x800 dp), l'espace restant est insuffisant et déclenche une erreur visuelle Flutter `RenderFlex overflowed by X pixels`.
* **User Story :** En tant qu'utilisateur sur un smartphone d'entrée de gamme, je veux saisir mon numéro de téléphone confortablement sans que le clavier masque les boutons ou produise une erreur visuelle.
* **Problème identifié :** Réf. Audit PB-06. Débordement d'interface sous clavier ouvert.
* **Fichiers concernés :** `Code/apps/mobile/lib/features/auth/presentation/widgets/phone_entry_step.dart`
* **Priorité :** 🟠 P1 – High
* **Estimation :** 2 Story Points
* **Dépendances :** Aucune
* **Critères d'acceptation :**
  1. `PhoneEntryStep` est encapsulé dans un `LayoutBuilder` et `SingleChildScrollView` avec contrainte de hauteur minimale.
  2. Aucun avertissement ni overflow n'apparaît sous clavier ouvert sur viewport 360x640 dp.
  3. Le bouton de validation et les mentions légales restent consultables par défilement naturel.
* **Résultat attendu :** Affichage stable et ergonomique sur l'ensemble du parc mobile Android/iOS.
* **Statut :** To Do

---

#### MOB-011 : Correction du sens LTR et dimension tactile (48dp) des cases OTP
* **ID :** `MOB-011`
* **Epic :** EPIC 3 : Ergonomie Mobile, Accessibilité Chantier & RTL
* **Titre :** Forcer la direction LTR et la taille réglementaire de 48dp sur `OtpCodeField`
* **User Story :** En tant qu'utilisateur configuré en langue arabe, je veux saisir mon code SMS de gauche à droite sur des cases faciles à toucher, afin de valider mon compte rapidement sans erreur de frappe.
* **Problème identifié :** Réf. Audit PB-07. Disposition inversée de droite à gauche en arabe et largeur de case insuffisante (44dp).
* **Fichiers concernés :** `Code/apps/mobile/lib/features/auth/presentation/widgets/otp_code_field.dart`
* **Priorité :** 🟠 P1 – High
* **Estimation :** 3 Story Points
* **Dépendances :** Aucune
* **Critères d'acceptation :**
  1. Le composant `OtpCodeField` est forcé en `TextDirection.ltr` pour respecter la lecture numérique standard des codes SMS en Tunisie.
  2. La zone tactile de chaque case respecte la cible minimale de 48dp fixée par la règle FM-43.
  3. L'effacement (backspace), la saisie séquentielle et le collage d'un code entier à 6 chiffres fonctionnent parfaitement.
* **Résultat attendu :** Saisie OTP intuitive et accessible, utilisable sur le terrain même avec des gants.
* **Statut :** To Do

---

#### MOB-012 : Miroitage RTL des boutons et flèches de retour
* **ID :** `MOB-012`
* **Epic :** EPIC 3 : Ergonomie Mobile, Accessibilité Chantier & RTL
* **Titre :** Adapter dynamiquement les icônes directionnelles en fonction de la langue
* **User Story :** En tant qu'utilisateur naviguant en arabe, je veux que les flèches de retour pointent dans le sens naturel de lecture (vers la droite).
* **Problème identifié :** Réf. Audit section 5. Utilisation de `Icons.arrow_back` statique ne se miroitant pas en arabe.
* **Fichiers concernés :**
  * `Code/apps/mobile/lib/features/auth/presentation/auth_screen.dart`
  * `Code/apps/mobile/lib/features/onboarding/presentation/onboarding_screen.dart`
* **Priorité :** 🟡 P2 – Medium
* **Estimation :** 1 Story Point
* **Dépendances :** Aucune
* **Critères d'acceptation :**
  1. Les flèches de retour utilisent `Icons.adaptive.arrow_back` ou un composant tenant compte de la locale active.
  2. L'icône pointe vers la gauche en français et vers la droite en arabe.
* **Résultat attendu :** Respect rigoureux des standards de conception bi-directionnels (RTL).
* **Statut :** To Do

---

#### MOB-013 : Suppression du doublon du bandeau hors-ligne sur les résultats
* **ID :** `MOB-013`
* **Epic :** EPIC 3 : Ergonomie Mobile, Accessibilité Chantier & RTL
* **Titre :** Retirer `ConnectivityBanner` de `SearchResultsScreen`
* **User Story :** En tant qu'utilisateur consultant la liste des artisans hors-ligne, je veux voir une seule bannière claire en haut de mon écran.
* **Problème identifié :** Réf. Audit PB-12. Le shell client et l'écran de résultats affichent simultanément deux bandeaux identiques superposés.
* **Fichiers concernés :** `Code/apps/mobile/lib/features/search/presentation/search_results_screen.dart`
* **Priorité :** 🟡 P2 – Medium
* **Estimation :** 1 Story Point
* **Dépendances :** Aucune
* **Critères d'acceptation :**
  1. Le composant `ConnectivityBanner` est retiré de `SearchResultsScreen`.
  2. La bannière unique présente dans `ClientShellScreen` assure seule l'avertissement réseau.
* **Résultat attendu :** Interface allégée et suppression du parasite visuel en mode déconnecté.
* **Statut :** To Do

---

#### MOB-014 : Sécurisation de l'affichage des SnackBars sur petits écrans
* **ID :** `MOB-014`
* **Epic :** EPIC 3 : Ergonomie Mobile, Accessibilité Chantier & RTL
* **Titre :** Harmoniser `snackBarTheme` en mode `fixed`
* **User Story :** En tant qu'utilisateur, je veux que les messages de confirmation s'affichent correctement sans être tronqués au-dessus de la barre de navigation.
* **Problème identifié :** Réf. Audit section 5. Conflit entre `SnackBarBehavior.floating` par défaut et la présence de la barre de navigation basse.
* **Fichiers concernés :** `Code/apps/mobile/lib/app/theme.dart`
* **Priorité :** 🟡 P2 – Medium
* **Estimation :** 1 Story Point
* **Dépendances :** Aucune
* **Critères d'acceptation :**
  1. `SnackBarThemeData` configure globalement `behavior: SnackBarBehavior.fixed`.
  2. Aucun plantage d'assertion "Floating SnackBar presented off screen" n'intervient lors de l'apparition d'un message.
* **Résultat attendu :** Présentation stable et homogène des retours utilisateurs.
* **Statut :** To Do

---

### EPIC 4 : Recherche & Découverte des Prestataires

#### MOB-015 : Prise en compte de la saisie textuelle de recherche d'accueil
* **ID :** `MOB-015`
* **Epic :** EPIC 4 : Recherche & Découverte des Prestataires
* **Titre :** Exploiter la chaîne saisie dans la barre de recherche pour cibler les résultats
* **Description :** Sur `SearchHomeScreen`, lorsque l'utilisateur valide une recherche (ex: "électricien"), la chaîne saisie est contrôlée puis ignorée dans le callback `onQuerySubmitted`. L'utilisateur arrive sur l'écran de résultats sans aucun filtre textuel ou de catégorie appliqué.
* **User Story :** En tant que particulier cherchant une aide d'urgence, je veux taper "Plombier" ou le nom d'un artisan dans la barre d'accueil, afin d'arriver directement sur les résultats correspondants.
* **Problème identifié :** Réf. Audit PB-10. Saisie utilisateur ignorée sur le formulaire d'accueil.
* **Fichiers concernés :**
  * `Code/apps/mobile/lib/features/search/presentation/search_home_screen.dart`
  * `Code/apps/mobile/lib/features/search/data/search_filters.dart`
* **Priorité :** 🟡 P2 – Medium
* **Estimation :** 3 Story Points
* **Dépendances :** Aucune
* **Critères d'acceptation :**
  1. La saisie textuelle est comparée aux catégories disponibles : si une catégorie correspond (ex: "plomberie"), son slug est appliqué.
  2. Si aucune catégorie directe ne correspond, le texte est transmis en paramètre dans `SearchFilters`.
  3. L'écran de résultats affiche le filtre actif dans son en-tête.
* **Résultat attendu :** Pertinence immédiate de la recherche depuis la page d'accueil de l'application.
* **Statut :** To Do

---

#### MOB-016 : Formatage défensif du séparateur de sous-titre de la carte artisan
* **ID :** `MOB-016`
* **Epic :** EPIC 4 : Recherche & Découverte des Prestataires
* **Titre :** Nettoyer l'affichage de `ProviderCard` lorsque le slogan ou la localisation est vide
* **Description :** Dans les cartes de résultats, le sous-titre concatène en dur `$categoryLabel · $locationLabel`. Si l'artisan n'a pas de slogan ou de délégation renseignée, l'affichage produit `Plomberie · ` avec un point médian orphelin peu professionnel.
* **User Story :** En tant qu'utilisateur parcourant les résultats, je veux voir des cartes d'artisans avec une mise en page soignée, sans séparateur orphelin "·".
* **Problème identifié :** Réf. Audit PB-15. Formatage textuel incomplet sur la liste d'artisans.
* **Fichiers concernés :**
  * `Code/apps/mobile/lib/core/widgets/provider_card.dart`
  * `Code/apps/mobile/lib/features/search/presentation/search_results_screen.dart`
* **Priorité :** 🟢 P3 – Low
* **Estimation :** 1 Story Point
* **Dépendances :** Aucune
* **Critères d'acceptation :**
  1. Le séparateur "·" n'est affiché que si la catégorie ET le second libellé sont présents et non vides.
  2. Si un seul des deux champs existe, seul ce champ est rendu sans point médian.
* **Résultat attendu :** Typographie mobile soignée et conforme au design system.
* **Statut :** To Do

---

#### MOB-017 : Intégration de la recherche plein texte multi-critères avec l'API
* **ID :** `MOB-017`
* **Epic :** EPIC 4 : Recherche & Découverte des Prestataires
* **Titre :** Étendre `SearchFilters` et le client de recherche avec le paramètre plein texte `q`
* **Description :** Permettre aux utilisateurs de rechercher directement un artisan par son nom commercial (`businessName`), sa bio ou ses compétences spécifiques via un paramètre de requête texte dédié.
* **User Story :** En tant que particulier, je veux pouvoir chercher un artisan par son nom d'entreprise ou ses compétences spécifiques, afin de retrouver rapidement un contact recommandé.
* **Problème identifié :** Réf. Audit section 6.1. Absence de recherche plein texte de bout en bout.
* **Fichiers concernés :**
  * `Code/apps/mobile/lib/features/search/data/search_filters.dart`
  * `Code/apps/mobile/lib/features/search/data/search_repository.dart`
  * `Code/apps/mobile/lib/features/search/presentation/search_results_screen.dart`
* **Priorité :** 🟡 P2 – Medium
* **Estimation :** 5 Story Points
* **Dépendances :** MOB-015
* **Critères d'acceptation :**
  1. `SearchFilters` supporte le paramètre optionnel `query` (inclus dans la clé de cache `cacheKey`).
  2. La requête d'API `v1ProvidersSearchGet` relaie le mot-clé vers le backend.
  3. En cas de résultat vide, un écran vide explicite propose de réinitialiser la recherche en un clic.
* **Résultat attendu :** Expérience de recherche complète et moderne pour le client.
* **Statut :** To Do

---

### EPIC 5 : Espace Pro & Gestion Artisan Post-Onboarding

#### MOB-018 : Ajout de l'action "Devenir artisan" dans le profil client
* **ID :** `MOB-018`
* **Epic :** EPIC 5 : Espace Pro & Gestion Artisan Post-Onboarding
* **Titre :** Intégrer un point d'accès visible vers l'onboarding dans `ClientProfileScreen`
* **Description :** Dans l'écran de profil client actuel, la liste des actions de compte n'affiche le bouton d'accès à l'Espace Pro que si le compte possède déjà le rôle `PROVIDER`. Il n'existe aucun appel à l'action invitant un particulier à créer son profil professionnel.
* **User Story :** En tant que client souhaitant proposer mes services, je veux voir un bouton "Devenir artisan" dans mon profil, afin de lancer la création de ma vitrine professionnelle.
* **Problème identifié :** Réf. Audit section 4 & 6.2. Absence d'entonnoir d'acquisition artisan dans l'espace client.
* **Fichiers concernés :** `Code/apps/mobile/lib/features/profile/presentation/client_profile_screen.dart`
* **Priorité :** 🟠 P1 – High
* **Estimation :** 2 Story Points
* **Dépendances :** MOB-001
* **Critères d'acceptation :**
  1. Si l'utilisateur n'est pas encore artisan (`isProvider == false`), une tuile dédiée "Devenir artisan Sanaya" apparaît dans son profil.
  2. Un tap sur ce bouton redirige directement vers `/pro/onboarding` (si connecté) ou `/auth` (si visiteur).
  3. L'affichage s'adapte élégamment en français et en arabe.
* **Résultat attendu :** Conversion continue et croissance naturelle de la base d'artisans.
* **Statut :** To Do

---

#### MOB-019 : Ajout du pull-to-refresh et affichage du statut sur le Dashboard
* **ID :** `MOB-019`
* **Epic :** EPIC 5 : Espace Pro & Gestion Artisan Post-Onboarding
* **Titre :** Intégrer `RefreshIndicator` et câbler le badge de disponibilité sur le tableau de bord
* **Description :** Le tableau de bord pro ne propose aucun moyen de rafraîchir manuellement les statistiques (vues, contacts, conversion). De plus, `DashboardHeader` est appelé sans paramètre de disponibilité, masquant le badge de statut de l'artisan.
* **User Story :** En tant qu'artisan, je veux tirer mon écran vers le bas pour actualiser mes vues et contacts en direct, et vérifier mon statut de disponibilité en un coup d'œil.
* **Problème identifié :** Réf. Audit PB-13. Dashboard statique sans gesture d'actualisation et statut indisponible.
* **Fichiers concernés :**
  * `Code/apps/mobile/lib/features/dashboard/presentation/screens/dashboard_screen.dart`
  * `Code/apps/mobile/lib/features/dashboard/presentation/widgets/dashboard_header.dart`
* **Priorité :** 🟡 P2 – Medium
* **Estimation :** 2 Story Points
* **Dépendances :** Aucune
* **Critères d'acceptation :**
  1. Le corps du Dashboard est enveloppé dans un `RefreshIndicator` ré-invoquant `dashboardStatsProvider`.
  2. Le badge de disponibilité réel de l'artisan est transmis à `DashboardHeader` et s'affiche à côté de son nom.
* **Résultat attendu :** Suivi d'activité pro dynamique et engageant pour l'artisan.
* **Statut :** To Do

---

#### MOB-020 : Interface d'édition post-onboarding des catégories et zones pro
* **ID :** `MOB-020`
* **Epic :** EPIC 5 : Espace Pro & Gestion Artisan Post-Onboarding
* **Titre :** Permettre la mise à jour des spécialités et zones d'intervention depuis le profil pro
* **Description :** Une fois l'onboarding achevé, l'écran `ProProfileScreen` ne permet de modifier que la bio et les téléphones. L'artisan ne peut plus ajuster ses spécialités ni ses zones d'intervention, alors que l'API supporte ces modifications via `PUT /v1/providers/me/categories` et `PUT /v1/providers/me/coverage-areas`.
* **User Story :** En tant qu'artisan établi, je veux modifier mes zones d'intervention et mes métiers depuis mon profil, afin d'adapter mon activité aux demandes de chantier.
* **Problème identifié :** Réf. Audit PB-11. Verrouillage fonctionnel post-onboarding sur les zones et métiers.
* **Fichiers concernés :**
  * `Code/apps/mobile/lib/features/pro_profile/presentation/pro_profile_screen.dart`
  * `Code/apps/mobile/lib/features/pro_profile/application/pro_profile_providers.dart`
* **Priorité :** 🟡 P2 – Medium
* **Estimation :** 5 Story Points
* **Dépendances :** MOB-003
* **Critères d'acceptation :**
  1. Deux nouvelles sections "Mes Métiers" et "Zones couvertes" sont ajoutées dans `ProProfileScreen`.
  2. L'artisan peut ouvrir une vue de sélection pour mettre à jour ses choix dans le respect des plafonds de son abonnement.
  3. Les modifications sont répercutées en temps réel sur la fiche publique de l'artisan.
* **Résultat attendu :** Flexibilité opérationnelle indispensable pour les artisans mobiles du Sahel.
* **Statut :** To Do

---

#### MOB-021 : Interface de gestion post-onboarding du portfolio et galerie
* **ID :** `MOB-021`
* **Epic :** EPIC 5 : Espace Pro & Gestion Artisan Post-Onboarding
* **Titre :** Intégrer l'ajout et la suppression de photos de réalisations dans le profil pro
* **User Story :** En tant qu'artisan, je veux ajouter des photos de mes chantiers récents sur ma fiche, afin d'attirer davantage de clients.
* **Problème identifié :** Réf. Audit PB-11. Absence de gestion de portfolio en dehors de la session initiale d'inscription.
* **Fichiers concernés :**
  * `Code/apps/mobile/lib/features/pro_profile/presentation/pro_profile_screen.dart`
  * `Code/apps/mobile/lib/features/onboarding/data/portfolio_repository.dart`
* **Priorité :** 🟡 P2 – Medium
* **Estimation :** 5 Story Points
* **Dépendances :** MOB-004, MOB-020
* **Critères d'acceptation :**
  1. Une section "Galerie de Réalisations" affiche les photos actives de l'artisan dans son profil pro.
  2. L'artisan peut téléverser de nouvelles photos (compression automatique + upload direct Cloudflare R2).
  3. L'artisan peut supprimer une photo existante avec confirmation (`DELETE /providers/me/portfolio/:id`).
  4. Le plafond de 5 photos pour le plan gratuit est scrupuleusement respecté dans l'UI.
* **Résultat attendu :** Vitrine professionnelle attrayante, continuellement enrichie par l'artisan.
* **Statut :** To Do

---

#### MOB-022 : Module de consultation et d'édition des tarifs et prestations pro
* **ID :** `MOB-022`
* **Epic :** EPIC 5 : Espace Pro & Gestion Artisan Post-Onboarding
* **Titre :** Développer l'interface de gestion des prestations et grilles tarifaires de l'artisan
* **User Story :** En tant qu'artisan, je veux détailler mes tarifs indicatifs (ex: dépannage fuite d'eau à partir de 40 DT), afin de rassurer mes prospects et qualifier mes contacts.
* **Problème identifié :** Réf. Audit section 6.2. Les tarifs s'affichent sur la fiche mais ne peuvent être créés ni édités sur mobile.
* **Fichiers concernés :**
  * `Code/apps/mobile/lib/features/pro_profile/presentation/pro_profile_screen.dart`
  * `Code/apps/mobile/lib/features/provider_profile/presentation/widgets/offering_card.dart`
* **Priorité :** 🟡 P2 – Medium
* **Estimation :** 5 Story Points
* **Dépendances :** MOB-020
* **Critères d'acceptation :**
  1. Module de gestion des offres avec liste des prestations existantes.
  2. Formulaire modal de création / modification : titre de la prestation, choix de la catégorie, tarif indicatif en TND.
  3. Branchement sur les endpoints API existants (`POST`/`PATCH`/`DELETE /v1/providers/me/offerings`).
* **Résultat attendu :** Amélioration décisive de la transparence tarifaire et de la conversion client.
* **Statut :** To Do

---

### EPIC 6 : Branding, Sécurité & Préparation Production

#### MOB-023 : Création d'un écran Splash immersif avec branding Sanaya
* **ID :** `MOB-023`
* **Epic :** EPIC 6 : Branding, Sécurité & Préparation Production
* **Titre :** Remplacer le spinner brut par un écran de démarrage animé aux couleurs de la marque
* **User Story :** En tant qu'utilisateur lançant l'application, je veux être accueilli par une animation élégante avec le logo Sanaya, afin de reconnaître immédiatement ma plateforme de confiance.
* **Problème identifié :** Réf. Audit PB-14. Simple indicateur de progression circulaire sans aucune identité visuelle.
* **Fichiers concernés :** `Code/apps/mobile/lib/app/splash_screen.dart`
* **Priorité :** 🟡 P2 – Medium
* **Estimation :** 2 Story Points
* **Dépendances :** MOB-024
* **Critères d'acceptation :**
  1. Logo officiel vectoriel Sanaya centré avec typographie officielle Manrope / Noto Kufi Arabic.
  2. Transition fluide et sans à-coup vers l'accueil dès la résolution de l'état de session.
  3. Adaptation parfaite aux thèmes clair et sombre.
* **Résultat attendu :** Sentiment de qualité et de finition dès la première seconde d'utilisation.
* **Statut :** To Do

---

#### MOB-024 : Intégration des icônes de store et des illustrations de catégories
* **ID :** `MOB-024`
* **Epic :** EPIC 6 : Branding, Sécurité & Préparation Production
* **Titre :** Intégrer les icônes d'application (ic_launcher) et pack vectoriel de spécialités
* **User Story :** En tant qu'utilisateur, je veux repérer facilement l'icône de l'application sur l'écran d'accueil de mon téléphone et distinguer visuellement les métiers par des icônes professionnelles.
* **Problème identifié :** Réf. Audit section 6.3. Icône par défaut Flutter et dossier `assets/` dépourvu d'images.
* **Fichiers concernés :**
  * `Code/apps/mobile/assets/`
  * `Code/apps/mobile/pubspec.yaml`
  * `Code/apps/mobile/android/app/src/main/res/`
  * `Code/apps/mobile/ios/Runner/Assets.xcassets/`
* **Priorité :** 🟡 P2 – Medium
* **Estimation :** 3 Story Points
* **Dépendances :** Aucune
* **Critères d'acceptation :**
  1. Icônes d'application adaptatives configurées pour Android (mipmap) et iOS (AppIcon).
  2. Remplacement des emojis de spécialités par des icônes vectorielles SVG aux couleurs du Design System.
  3. Configuration rigoureuse du bloc `assets` dans `pubspec.yaml`.
* **Résultat attendu :** Conformité graphique exigée pour la soumission sur le Play Store et l'App Store.
* **Statut :** To Do

---

#### MOB-025 : Configuration Cleartext HTTP et règles ProGuard/R8 de release
* **ID :** `MOB-025`
* **Epic :** EPIC 6 : Branding, Sécurité & Préparation Production
* **Titre :** Sécuriser la configuration réseau Android et durcir les règles ProGuard pour les builds release
* **Description :** Sur Android 9+, tout flux HTTP non chiffré est bloqué par défaut. Une configuration de sécurité réseau explicite doit autoriser le développement local sans exposer la version release. De plus, les règles ProGuard/R8 doivent préserver les classes JNI et sérialiseurs tiers (`built_value`, `flutter_secure_storage`).
* **User Story :** En tant qu'administrateur système, je veux m'assurer que l'APK release compilé ne plante pas lors de l'exécution avec R8 minifié et qu'il gère les environnements de staging.
* **Problème identifié :** Réf. Audit section 7.1. Risques de blocage réseau et de crash sous R8 minifié.
* **Fichiers concernés :**
  * `Code/apps/mobile/android/app/build.gradle.kts`
  * `Code/apps/mobile/android/app/proguard-rules.pro`
  * `Code/apps/mobile/android/app/src/main/res/xml/network_security_config.xml`
* **Priorité :** 🟠 P1 – High
* **Estimation :** 2 Story Points
* **Dépendances :** Aucune
* **Critères d'acceptation :**
  1. `network_security_config.xml` configuré pour autoriser les domaines locaux de dev tout en imposant HTTPS strict en production.
  2. Règles ProGuard `-keep` renseignées pour prévenir toute suppression de classe requise par la sérialisation.
  3. L'APK release se lance et fonctionne sans crash sur un device Android physique.
* **Résultat attendu :** Binaire de production stable, sécurisé et optimisé en taille.
* **Statut :** To Do

---

#### MOB-026 : Automatisation du contrôle anti-fuite de secrets et script release
* **ID :** `MOB-026`
* **Epic :** EPIC 6 : Branding, Sécurité & Préparation Production
* **Titre :** Intégrer la validation automatique de l'APK via `apk-secret-scan.sh` en CI/CD
* **User Story :** En tant que responsable sécurité, je veux avoir la certitude mathématique qu'aucun secret, mot de passe de base de données ou clé privée n'est inclus dans l'APK distribué.
* **Problème identifié :** Réf. Audit section 7.1 & Script `apk-secret-scan.sh`.
* **Fichiers concernés :**
  * `Code/tooling/scripts/apk-secret-scan.sh`
  * `.github/workflows/`
* **Priorité :** 🟡 P2 – Medium
* **Estimation :** 3 Story Points
* **Dépendances :** MOB-025
* **Critères d'acceptation :**
  1. Le scan d'artefact s'exécute automatiquement après la génération de l'APK ou du bundle AAB.
  2. Toute clé privée, chaîne de connexion ou token de développement bloque le déploiement avec un code d'erreur explicite.
  3. L'artefact final est signé et certifié exempt de fuites de données.
* **Résultat attendu :** Garantie absolue de sécurité et respect des directives INPDP avant diffusion.
* **Statut :** To Do
