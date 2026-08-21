// BE-16 : test pur (aucune base) sur la construction du `where` Prisma de
// `searchProviderProfiles` — même esprit que `pagination.test.ts` dans ce paquet : c'est une pure
// transformation de données, testable indépendamment du harnais Vitest+Postgres différé (BE-02b).
// Le comportement réel de la requête (jointures, résultats) est vérifié manuellement contre le
// seed de démo (voir la description de la PR de la route, BE-16c).
import { describe, expect, it } from 'vitest';
import { buildSearchWhereClause } from '../src/repositories/provider-profile.repository.js';

describe('buildSearchWhereClause', () => {
  it('filtre toujours sur publicationStatus PUBLISHED et la couverture du gouvernorat demandé', () => {
    expect(buildSearchWhereClause({ governorateId: 'g1' })).toEqual({
      publicationStatus: 'PUBLISHED',
      coverageAreas: { some: { governorateId: 'g1' } },
    });
  });

  it('une délégation demandée élargit la couverture à « tout le gouvernorat » (delegationId null) OU la délégation exacte', () => {
    const where = buildSearchWhereClause({ governorateId: 'g1', delegationId: 'd1' });
    expect(where.coverageAreas).toEqual({
      some: {
        governorateId: 'g1',
        OR: [{ delegationId: null }, { delegationId: 'd1' }],
      },
    });
  });

  it('ajoute le filtre catégorie uniquement si demandé', () => {
    const withCategory = buildSearchWhereClause({ governorateId: 'g1', categoryId: 'c1' });
    expect(withCategory.categories).toEqual({ some: { categoryId: 'c1' } });

    const withoutCategory = buildSearchWhereClause({ governorateId: 'g1' });
    expect(withoutCategory.categories).toBeUndefined();
  });

  it('verified: false ne filtre PAS sur isVerified — seul true doit restreindre', () => {
    expect(
      buildSearchWhereClause({ governorateId: 'g1', verified: false }).isVerified,
    ).toBeUndefined();
    expect(buildSearchWhereClause({ governorateId: 'g1', verified: true }).isVerified).toBe(true);
  });

  it('minRating: 0 est un filtre valide (distinct de « non demandé »)', () => {
    const where = buildSearchWhereClause({ governorateId: 'g1', minRating: 0 });
    expect(where.ratingAvg).toEqual({ gte: 0 });

    const withoutFilter = buildSearchWhereClause({ governorateId: 'g1' });
    expect(withoutFilter.ratingAvg).toBeUndefined();
  });

  it('ajoute le filtre de disponibilité uniquement si demandé', () => {
    const where = buildSearchWhereClause({ governorateId: 'g1', availabilityStatus: 'AVAILABLE' });
    expect(where.availabilityStatus).toBe('AVAILABLE');

    expect(buildSearchWhereClause({ governorateId: 'g1' }).availabilityStatus).toBeUndefined();
  });

  it('combine tous les filtres sans en écraser aucun', () => {
    const where = buildSearchWhereClause({
      governorateId: 'g1',
      delegationId: 'd1',
      categoryId: 'c1',
      verified: true,
      minRating: 4,
      availabilityStatus: 'BUSY',
    });

    expect(where).toEqual({
      publicationStatus: 'PUBLISHED',
      categories: { some: { categoryId: 'c1' } },
      isVerified: true,
      ratingAvg: { gte: 4 },
      availabilityStatus: 'BUSY',
      coverageAreas: {
        some: { governorateId: 'g1', OR: [{ delegationId: null }, { delegationId: 'd1' }] },
      },
    });
  });
});
