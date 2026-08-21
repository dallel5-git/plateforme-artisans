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

// Référentiel géo figé (BE-03/BE-05) : mêmes deux libellés que les catégories.
export const governorateSchema = z.object({
  id: z.uuid(),
  code: z.string(),
  nameFr: z.string(),
  nameAr: z.string(),
  slug: z.string(),
  latitude: z.number().nullable(),
  longitude: z.number().nullable(),
  sortOrder: z.number().int(),
});

export const governoratesResponseSchema = z.object({
  governorates: z.array(governorateSchema),
});

export const delegationSchema = z.object({
  id: z.uuid(),
  governorateId: z.uuid(),
  code: z.string().nullable(),
  nameFr: z.string(),
  nameAr: z.string(),
  slug: z.string(),
  postalCode: z.string().nullable(),
  latitude: z.number().nullable(),
  longitude: z.number().nullable(),
});

export const delegationsResponseSchema = z.object({
  delegations: z.array(delegationSchema),
});

export const governorateIdParamsSchema = z.object({
  id: z.uuid(),
});
