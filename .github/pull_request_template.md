<!--
  Titre de la PR = message de commit final (squash-merge).
  Format Conventional Commits : feat(auth): ajouter la vérification OTP avec TTL de 5 minutes
-->

## Tâche

Closes #

<!-- Un « Closes #N » ferme l'issue et la passe en Done sur le Project automatiquement. -->

## Ce que fait cette PR

<!-- 2 à 4 phrases, orientées comportement observable. Pas la liste des fichiers : le diff la donne déjà. -->

## Ce qu'elle ne fait pas (volontairement)

<!-- Le périmètre exclu. Évite le débat en revue et le « tant qu'on y est ». -->

## Contrat d'API

- [ ] Aucun changement
- [ ] `contracts/openapi.json` régénéré (`pnpm api:contract`) — **routes ajoutées/modifiées :**
- [ ] Clients régénérés : `pnpm mobile:client` / `pnpm web:client`
- [ ] ⚠️ **Breaking change** — prévenu dans `#développement-du-backend` avant ce merge

## Tests

<!-- Combien, de quel niveau, et surtout : quel cas d'erreur est couvert ? -->

- Unitaires (`packages/core`) :
- Intégration (`apps/api`) :
- Flutter (`flutter test`) :

## Comment vérifier

<!-- Les étapes exactes pour que le relecteur reproduise. Pas « lancer l'app ». -->

1.
2.

---

## ✅ Checklist auteur

**Qualité**
- [ ] `pnpm typecheck && pnpm lint && pnpm test` verts
- [ ] `flutter analyze` : zéro warning · `dart format` appliqué *(si mobile)*
- [ ] Diff < 400 lignes hors fichiers générés — sinon j'explique pourquoi ci-dessous
- [ ] Aucun test désactivé sans `// TODO(<ID>)` + ligne dans le backlog

**Guard-rails** *(voir `CLAUDE.md` §3)*
- [ ] Aucune donnée sensible loggée : téléphone, OTP, CIN, token, mot de passe
- [ ] Aucun secret, clé ou `.env` commité
- [ ] Aucune règle métier hors de `packages/core` — une route valide, appelle, sérialise
- [ ] Pagination par curseur sur toute nouvelle liste
- [ ] Aucune migration déjà mergée modifiée
- [ ] `select` Prisma explicites — aucune entité complète renvoyée au client
- [ ] Le badge `isVerified` ne dépend d'aucun `subscription.status` (ADR-002)

**Bilingue** *(si UI)*
- [ ] Aucune chaîne en dur — clés ajoutées en **`fr.json` ET `ar.json`**
- [ ] Rendu vérifié en **arabe / RTL** (capture ci-dessous si l'écran est nouveau)
- [ ] Aucune propriété directionnelle : `ms-/me-` et `EdgeInsetsDirectional`, jamais `ml-` ni `EdgeInsets.only(left:)`
- [ ] États `loading` (skeleton) / `empty` / `error` implémentés — pas seulement le cas passant

**Traçabilité** *(P9)*
- [ ] Tout clic « Appeler » / « WhatsApp » poste un `ContactEvent` **avant** d'ouvrir le lien natif

## 📸 Captures

<!-- Si l'écran est nouveau ou modifié : FR et AR côte à côte. -->

| Français | العربية |
|---|---|
|  |  |

---

## 🔍 Pour le relecteur

Préfixe tes commentaires :
- `[bloquant]` — doit être corrigé avant merge
- `[suggestion]` — à considérer, l'auteur tranche
- `[question]` — demande de compréhension, pas un reproche

Délai cible : **4 h ouvrées**. Une PR en attente bloque un développeur sur deux.
