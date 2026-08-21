/**
 * BE-14b — `buildCategoryTree` (P3) · `packages/core/src/catalog/category-tree.ts`
 *
 * Logique pure : assemble un arbre à partir du résultat plat de `listAllActiveCategories`
 * (@repo/db). Ne doit pas dépendre de l'ordre du tableau d'entrée — seul l'ordre de sortie
 * (`sortOrder`, à chaque niveau) compte.
 */
import { describe, expect, it } from 'vitest';
import type { Category } from '@repo/db';
import { buildCategoryTree } from '../src/catalog/category-tree.js';

function category(overrides: Partial<Category> & Pick<Category, 'id' | 'slug'>): Category {
  return {
    parentId: null,
    nameFr: overrides.slug,
    nameAr: overrides.slug,
    descriptionFr: null,
    descriptionAr: null,
    iconKey: null,
    colorHex: null,
    isActive: true,
    sortOrder: 0,
    ...overrides,
  };
}

describe('BE-14b — buildCategoryTree', () => {
  it('assemble un arbre à 3 niveaux, indépendamment de l’ordre du tableau d’entrée', () => {
    const grandchild = category({ id: 'gc1', slug: 'gc1', parentId: 'c1', sortOrder: 0 });
    const child = category({ id: 'c1', slug: 'c1', parentId: 'root1', sortOrder: 0 });
    const root = category({ id: 'root1', slug: 'root1', parentId: null, sortOrder: 0 });

    // Volontairement mélangé : petit-enfant avant parent avant grand-parent.
    const tree = buildCategoryTree([grandchild, child, root]);

    expect(tree).toHaveLength(1);
    const [rootNode] = tree;
    expect(rootNode?.id).toBe('root1');
    expect(rootNode?.children).toHaveLength(1);
    const [childNode] = rootNode?.children ?? [];
    expect(childNode?.id).toBe('c1');
    expect(childNode?.children).toHaveLength(1);
    const [grandchildNode] = childNode?.children ?? [];
    expect(grandchildNode?.id).toBe('gc1');
    expect(grandchildNode?.children).toEqual([]);
  });

  it('trie chaque niveau par sortOrder', () => {
    const rootB = category({ id: 'b', slug: 'b', sortOrder: 2 });
    const rootA = category({ id: 'a', slug: 'a', sortOrder: 1 });
    const childB = category({ id: 'a-b', slug: 'a-b', parentId: 'a', sortOrder: 2 });
    const childA = category({ id: 'a-a', slug: 'a-a', parentId: 'a', sortOrder: 1 });

    const tree = buildCategoryTree([rootB, childB, rootA, childA]);

    expect(tree.map((node) => node.id)).toEqual(['a', 'b']);
    const [firstRoot] = tree;
    expect(firstRoot?.children.map((node) => node.id)).toEqual(['a-a', 'a-b']);
  });

  it('un tableau vide donne un arbre vide', () => {
    expect(buildCategoryTree([])).toEqual([]);
  });

  it('promeut à la racine une catégorie dont le parent est absent (désactivé) — ne disparaît jamais silencieusement de l’arbre', () => {
    const orphan = category({ id: 'orphan', slug: 'orphan', parentId: 'deactivated-parent' });

    const tree = buildCategoryTree([orphan]);

    expect(tree).toHaveLength(1);
    expect(tree[0]?.id).toBe('orphan');
  });
});
