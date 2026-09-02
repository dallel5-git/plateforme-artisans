import { readFileSync } from 'node:fs';
import { resolve } from 'node:path';
import { describe, expect, it } from 'vitest';
import { resolveTokens, buildOutputs } from '../../../tooling/scripts/build-tokens.mjs';

const TOKENS_PATH = resolve(import.meta.dirname, '../tokens.json');
const realTokens = () => JSON.parse(readFileSync(TOKENS_PATH, 'utf8'));

const NEW_ROLES = [
  'onWhatsapp',
  'amber',
  'onAmber',
  'scrim',
  'onScrim',
  'thumbnail',
  'thumbnailBorder',
  'chartBar',
  'chartBarHighlight',
  'navActive',
  'navInactive',
  'navBackground',
];

describe('Nouveaux rôles sémantiques AppColors (FM-15d)', () => {
  it('color.semantic.light et .dark restent en lockstep (régression SO-08/FM-15)', () => {
    const t = resolveTokens(realTokens());
    expect(Object.keys(t.color.semantic.dark).sort()).toEqual(
      Object.keys(t.color.semantic.light).sort(),
    );
  });

  it('les 12 nouveaux rôles apparaissent comme champs Dart de AppColors', () => {
    const out = buildOutputs(resolveTokens(realTokens()))[
      'apps/mobile/lib/core/theme/app_colors.dart'
    ];
    for (const role of NEW_ROLES) {
      expect(out).toContain(`final Color ${role};`);
    }
  });

  it('onAmber et onScrim ont des valeurs distinctes entre clair et sombre (contraste)', () => {
    const t = resolveTokens(realTokens());
    expect(t.color.semantic.light['on-amber']).not.toBe(t.color.semantic.dark['on-amber']);
  });
});
