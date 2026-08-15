# ADR-002 — Le badge « Artisan Vérifié » est gratuit et fondé sur l'identité

- **Statut** : Accepté
- **Date** : 2026-08-15
- **Décideurs** : Oussama Dallel
- **Répond à** : Question 1 du *Document de Cadrage Technique v1.0* (§6)

---

## 1. Contexte

Le cadrage contenait une contradiction commerciale : la vérification de la CIN y est décrite comme
gratuite et ouverte à tous dans la section « Prestataire », alors que le badge certifié apparaît
comme une contrepartie du Pack Pro payant dans le modèle économique. Les deux lectures s'excluent, et
le choix conditionne la modélisation de `ProviderProfile.isVerified` vis-à-vis de `Subscription`.

## 2. Décision

**Option A retenue.** Tout artisan qui soumet une CIN valide obtient le badge « Artisan Vérifié »,
**y compris en offre gratuite**. Le badge atteste de l'**identité**, jamais du niveau d'abonnement.

Le Pack Pro vend la **visibilité** — `Plan.rankingBoostFactor`, quotas de leads, statistiques
avancées, boosts — et non la confiance.

## 3. Justification

L'actif de la plateforme est l'**audience**, et l'audience vient de la confiance du client
particulier. Le document de stratégie identifie « l'angoisse du prix » et la méfiance comme la faille
n°2 du marché. Réserver le badge aux payants produirait mécaniquement une majorité d'artisans non
vérifiés au lancement — c'est-à-dire exactement le signal que les groupes Facebook renvoient déjà, et
donc la disparition du seul différenciateur défendable.

Le raisonnement inverse tient aussi : plus il y a d'artisans vérifiés, plus le client fait confiance,
plus il y a de contacts, plus l'artisan gratuit constate que la plateforme lui apporte des leads —
et c'est *ce constat mesuré* (principe P9) qui vend le Pack Pro, pas un badge retiré en otage.

L'option C (deux niveaux : « Identité vérifiée » gratuit + « Pro Certifié » payant avec patente,
assurance et ancienneté) reste **compatible et ouverte** : elle s'ajoute plus tard sans migration
destructive, puisqu'elle n'enlève rien au badge gratuit.

## 4. Conséquences techniques

- `ProviderProfile.isVerified` reste **strictement indépendant** de `Subscription`. Aucun code ne doit lire `subscription.status` pour décider de l'affichage du badge.
- Aucune logique de retrait automatique du badge à l'expiration d'un abonnement, aucune période de grâce à gérer. C'est une simplification substantielle du module `billing`.
- `VerificationRequest` / `VerificationDocument` sont accessibles à tous les rôles `PROVIDER`, sans contrôle de plan.
- Le back-office traite la file de vérification **sans filtre de plan** (cf. maquette « File de vérification CIN »).
- Le ranking (Annexe A) utilise deux termes distincts et non fusionnés : `w3 · confiance` (badge, gratuit) et `w6 · facteurPlan` (`Plan.rankingBoostFactor`). Ne jamais les confondre : un artisan gratuit vérifié doit pouvoir devancer un artisan Pro non vérifié.
- **Extension future (option C)** : ajouter `ProviderProfile.certificationLevel` (`NONE | IDENTITY | PRO_CERTIFIED`) sans toucher à `isVerified`.

## 5. Garde-fou de test

Un test de non-régression est obligatoire dans `packages/core/tests/ranking.test.ts` :

> *Un artisan gratuit, vérifié, profil complété à 100 %, doit obtenir un score supérieur à un artisan
> Pro non vérifié au profil incomplet, à pertinence géographique et réputation égales.*

Si ce test casse un jour, c'est que quelqu'un a re-lié le badge au plan.
