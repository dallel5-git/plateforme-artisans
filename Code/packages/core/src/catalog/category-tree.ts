import type { Category } from '@repo/db';

export interface CategoryTreeNode extends Category {
  children: CategoryTreeNode[];
}

function byId<T extends { id: string }>(rows: T[]): Map<string, T> {
  return new Map(rows.map((row) => [row.id, row]));
}

function sortBySortOrder(nodes: CategoryTreeNode[]): CategoryTreeNode[] {
  return [...nodes].sort((a, b) => a.sortOrder - b.sortOrder);
}

/**
 * Assemble l'arbre à partir d'un tableau plat (`listAllActiveCategories`, une seule requête —
 * AC anti-N+1). Une catégorie dont le `parentId` ne correspond à aucune ligne du tableau (parent
 * désactivé indépendamment, alors que `onDelete: Restrict` empêche sa suppression) est promue à
 * la racine plutôt que silencieusement exclue de l'arbre : « arbre complet » de l'AC prime sur un
 * arbre visuellement plus propre.
 */
export function buildCategoryTree(categories: Category[]): CategoryTreeNode[] {
  const rowsById = byId(categories);
  const nodesById = new Map<string, CategoryTreeNode>(
    categories.map((row) => [row.id, { ...row, children: [] }]),
  );

  const roots: CategoryTreeNode[] = [];
  for (const row of categories) {
    const node = nodesById.get(row.id)!;
    const parent = row.parentId ? nodesById.get(row.parentId) : undefined;
    const hasKnownParent = row.parentId !== null && rowsById.has(row.parentId);
    if (hasKnownParent && parent) {
      parent.children.push(node);
    } else {
      roots.push(node);
    }
  }

  for (const node of nodesById.values()) {
    node.children = sortBySortOrder(node.children);
  }

  return sortBySortOrder(roots);
}
