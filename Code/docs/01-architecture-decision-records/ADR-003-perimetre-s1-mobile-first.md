# ADR-003 — Le sprint S1 livre le mobile, pas le web

- **Statut** : Accepté
- **Date** : 2026-08-15
- **Décideurs** : Oussama Dallel
- **Impacte** : `PLAN-MVP-SEMAINE-1.md` (v2.0), `backlog/TODO.md`, l'allocation des deux développeurs à partir de J4

---

## 1. Contexte

La première version du plan S1 répartissait les deux développeurs sur deux surfaces en parallèle à
partir de J4 : DEV-1 sur `apps/web` (Next.js), DEV-2 sur `apps/mobile` (Flutter).

Le recomptage de la charge a invalidé ce découpage :

| | Heures-homme |
|---|---|
| Capacité réelle (2 devs × 7 j × 8 h) | **112 h** |
| Charge 🔴 P0 planifiée en v1 | **~159 h** *(dont ~20 h en binôme, comptées double)* |
| Dépassement | **+42 %** |

L'erreur d'origine est double : les tâches en binôme n'étaient comptées qu'une fois, et surtout
**deux surfaces développées en parallèle coûtent la somme de leurs deux charges**, sans aucune
mutualisation possible côté présentation (c'est précisément ce que l'ADR-001 §4.2 avait acté : le
partage de code chute à ~40 % avec Flutter).

## 2. Décision

**Le sprint S1 livre le socle, le backend et l'application mobile Flutter. `apps/web` est reporté au
sprint S2.**

À partir de J4 après-midi, **les deux développeurs travaillent sur Flutter**.

| | Heures-homme |
|---|---|
| Socle | ~11,5 h |
| Backend (après réduction du périmètre) | ~53 h |
| Mobile Flutter | ~43 h |
| Qualité | ~4 h |
| **Total 🔴 P0** | **~109 h** |
| Marge sur 112 h | **~3 %** |

## 3. Justification

**Le mobile est le produit.** C'est ce qu'on installe sur le téléphone d'un artisan pendant la tournée
des quincailleries, et ce que les beta-testeurs du Sahel peuvent essayer. Une URL de préproduction ne
se distribue pas de la même façon à 7h du matin devant une quincaillerie de Sahloul.

**Le web n'est pas perdu, il est décalé.** Son délai propre n'est pas le développement mais
l'indexation Google, qui prend des semaines. Décaler la mise en ligne d'une semaine coûte une semaine
d'indexation. Livrer deux surfaces à moitié finies coûte le sprint entier — et la confiance dans le
plan.

**Le backend ne change pas.** Il expose déjà tout ce dont le web aura besoin. Le lot web de S2 n'est
que de la consommation d'API : ~35 h, soit un sprint confortable pour deux développeurs, avec de la
place pour le KYC et le back-office.

**Effet secondaire souhaitable** : mettre les deux développeurs sur Flutter tue le risque de *bus
factor* identifié dans l'ADR-001 §4.2 (« un seul portera le mobile après la semaine 1 »). Ils
apprennent Dart ensemble, sur la couche la plus structurante (`FM-02`, le client réseau généré).

## 4. Ce qui a été réduit dans le backend pour rentrer

| Tâche | Réduction |
|---|---|
| `BE-02` migration SQL | Essentiel seulement : `CHECK` notes, index unique partiel, index `PUBLISHED`, trigger anti-auto-avis. Index GIN trigram reporté. |
| `BE-03` seed géographique | Délégations du **Sahel** seulement (les 24 gouvernorats restent, sans leurs délégations) |
| `BE-08` SMS | Adaptateur `console` seul ; l'interface `SmsProvider` reste prête pour Twilio |
| `BE-11` rate limiting | OTP et contacts seulement |
| `BE-13` erreurs | Sentry reporté en S2 |
| `BE-19` onboarding artisan | Réduit (profil + catégories + zones) **et passé en 🟠 P1** — l'écran mobile qui le consomme (`FM-11`) est lui aussi P1 |
| `BE-20` médias / presign | **Reporté S2** — les photos de la seed suffisent |
| `BE-24` stats Pro | **Reporté S2** — `BE-23` reste, pour ne pas perdre la donnée entre-temps |

## 5. Conséquences

- Aucun livrable web au soir du J7. Le seul livrable utilisateur est **un APK Android signé**.
- Le principe **P6** (le SEO est un canal d'acquisition critique) n'est pas abandonné : il est
  simplement daté de S2. À réévaluer si l'acquisition SEO devient urgente avant.
- La marge de 3 % rend le sprint **sans filet**. Le véritable amortisseur est la liste 🟠 P1
  (espace Pro mobile, stats, favoris, médias) : **on y coupe au premier jalon manqué, pas au
  troisième.**
- Si `apps/web` devenait prioritaire en cours de S1 (par exemple pour une démo investisseur), c'est
  le mobile qui glisse — pas les deux. Un seul lot à la fois.

## 6. Leçon à retenir pour les sprints suivants

Deux règles de planification issues de cette erreur, à appliquer désormais :

1. **Une tâche en binôme compte double** en heures-homme.
2. **Deux surfaces développées en parallèle coûtent la somme de leurs charges.** Il n'y a pas de
   mutualisation magique côté présentation — l'ADR-001 l'avait déjà écrit noir sur blanc.
