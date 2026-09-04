/// Miroir d'affichage des plafonds du plan FREE (issue #231/FM-34).
///
/// Source de vérité unique : `packages/core/src/billing/plan-limits.ts`. Ces
/// constantes ne pilotent qu'une désactivation d'UI proactive (éviter qu'un
/// artisan sélectionne une 4ᵉ catégorie sans comprendre pourquoi) — l'API
/// reste seule autorité : toute divergence retombe sur le message d'erreur
/// serveur (`VALIDATION_ERROR`, `details.limit`), jamais sur un blocage
/// silencieux côté client (P3 — pas de règle métier dupliquée en Dart, ceci
/// n'en est pas une : juste l'affichage d'un nombre déjà appliqué serveur).
const freePlanMaxCategories = 3;
const freePlanMaxGovernorates = 1;
