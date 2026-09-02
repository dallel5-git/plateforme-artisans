import { readFileSync } from 'node:fs';
import { resolve } from 'node:path';
import { describe, expect, it } from 'vitest';
import { resolveTokens } from '../../../tooling/scripts/build-tokens.mjs';

const TOKENS_PATH = resolve(import.meta.dirname, '../tokens.json');
const realTokens = () => JSON.parse(readFileSync(TOKENS_PATH, 'utf8'));

describe('Collisions de couleur (régression #214/SO-08)', () => {
  it('dark.border et dark.surface-raised sont visuellement distincts', () => {
    const t = resolveTokens(realTokens());
    expect(t.color.semantic.dark.border).not.toBe(t.color.semantic.dark['surface-raised']);
  });

  it('sponsored et pending sont distincts en clair et en sombre', () => {
    const t = resolveTokens(realTokens());
    expect(t.color.semantic.light.sponsored).not.toBe(t.color.semantic.light.pending);
    expect(t.color.semantic.dark.sponsored).not.toBe(t.color.semantic.dark.pending);
  });
});
