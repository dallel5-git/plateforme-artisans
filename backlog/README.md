# Backlog Sanaya — mode d'emploi

Trois fichiers, un flux à sens unique :

```
TODO.md  ──►  DOING.md  ──►  DONE.md
   ▲                            │
   └──── (rouvert si régression)┘
```

## Règles

1. **`DOING.md` reflète l'instant présent.** Il ne contient jamais plus de **2 tâches par développeur**. Si vous en avez 3, vous n'en finissez aucune.
2. On déplace la ligne **entière** d'un fichier à l'autre — on ne la duplique pas, on ne la recopie pas.
3. Une tâche entre dans `DOING.md` seulement si sa *Definition of Ready* est remplie (voir `Code/docs/POLITIQUE-PROJET.md` §5).
4. Une tâche passe en `DONE.md` seulement si sa *Definition of Done* est remplie. **Il n'y a pas de « fini à 90 % »** : c'est 0 %.
5. Toute nouvelle idée en cours de sprint va dans `TODO.md`, section **« Backlog non planifié »**. Elle n'est jamais prise dans le sprint courant sans arbitrage explicite du lead.
6. Mise à jour **en fin de journée, tous les jours**. Un backlog obsolète est pire qu'aucun backlog : il donne une fausse confiance.

## Nomenclature des IDs

| Préfixe | Lot |
|---|---|
| `SO-xx` | Socle / infrastructure |
| `BE-xx` | Backend (API, domaine, données, auth) |
| `FW-xx` | Frontend Web (Next.js — `apps/web`, `apps/admin`) |
| `FM-xx` | Frontend Mobile (Flutter — `apps/mobile`) |
| `QA-xx` | Tests, recette, outillage qualité |
| `OPS-xx` | Déploiement, environnements, observabilité |
| `DOC-xx` | Documentation, ADR |

Un ID **ne se réutilise jamais**, même après suppression d'une tâche. Un suffixe lettre marque un
découpage a posteriori : `BE-15b`.

## Priorités

| Marque | Sens |
|---|---|
| 🔴 **P0** | Non négociable pour l'objectif du sprint. Si ça saute, le sprint est raté. |
| 🟠 **P1** | Fait si le rythme le permet. **Premier à couper.** |
| ⚪ **P2** | Reporté au sprint suivant. Ne pas commencer. |

## Colonnes

`ID · Tâche · Lot · Prio · Qui · Est. · Dépend de · US du cadrage`

En `DONE.md`, deux colonnes s'ajoutent : `PR` et `Terminé le`.
