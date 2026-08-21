import { z } from 'zod';

// Référentiel figé (BE-03) : chaque catégorie porte ses deux libellés, le client choisit selon
// sa locale — jamais de traduction à la volée côté API (P7).
const baseCategorySchema = z.object({
  id: z.uuid(),
  slug: z.string(),
  nameFr: z.string(),
  nameAr: z.string(),
  descriptionFr: z.string().nullable(),
  descriptionAr: z.string().nullable(),
  iconKey: z.string().nullable(),
  colorHex: z.string().nullable(),
  sortOrder: z.number().int(),
});

export type CategoryTreeNode = z.infer<typeof baseCategorySchema> & {
  children: CategoryTreeNode[];
};

// Premier schéma récursif du repo (`z.lazy` + `z.ZodType<T>` explicite, requis pour que
// TypeScript infère un type non circulaire) — arbre à profondeur libre, même si le seed actuel
// ne va que jusqu'aux petits-enfants.
export const categoryTreeNodeSchema: z.ZodType<CategoryTreeNode> = baseCategorySchema.extend({
  children: z.lazy(() => z.array(categoryTreeNodeSchema)),
});

// Requis pour qu'un schéma récursif se résolve en `$ref` vers `components.schemas` dans le
// contrat OpenAPI généré (voir `apps/api/src/plugins/swagger.ts`, `jsonSchemaTransformObject`) —
// sans cet enregistrement, `$ref: '#/components/schemas/schema0'` pointe dans le vide.
z.globalRegistry.add(categoryTreeNodeSchema, { id: 'CategoryTreeNode' });

export const categoriesResponseSchema = z.object({
  categories: z.array(categoryTreeNodeSchema),
});
