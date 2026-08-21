// BE-05 : agrégat géographique (Governorate + Delegation). Référentiel figé, écrit uniquement
// par le seed (BE-03) — ce repository est volontairement lecture seule.
import type { Prisma } from '@prisma/client';
import { prisma } from '../client.js';
import type { DbClient } from '../types.js';

const governorateSelect = {
  id: true,
  code: true,
  nameFr: true,
  nameAr: true,
  slug: true,
  latitude: true,
  longitude: true,
  isActive: true,
  sortOrder: true,
} as const;

const delegationSelect = {
  id: true,
  governorateId: true,
  code: true,
  nameFr: true,
  nameAr: true,
  slug: true,
  postalCode: true,
  latitude: true,
  longitude: true,
  isActive: true,
} as const;

export interface Governorate {
  id: string;
  code: string;
  nameFr: string;
  nameAr: string;
  slug: string;
  latitude: number | null;
  longitude: number | null;
  isActive: boolean;
  sortOrder: number;
}

export interface Delegation {
  id: string;
  governorateId: string;
  code: string | null;
  nameFr: string;
  nameAr: string;
  slug: string;
  postalCode: string | null;
  latitude: number | null;
  longitude: number | null;
  isActive: boolean;
}

type RawGovernorate = Prisma.GovernorateGetPayload<{ select: typeof governorateSelect }>;
type RawDelegation = Prisma.DelegationGetPayload<{ select: typeof delegationSelect }>;

function toGovernorate(row: RawGovernorate): Governorate {
  return {
    ...row,
    latitude: row.latitude ? row.latitude.toNumber() : null,
    longitude: row.longitude ? row.longitude.toNumber() : null,
  };
}

function toDelegation(row: RawDelegation): Delegation {
  return {
    ...row,
    latitude: row.latitude ? row.latitude.toNumber() : null,
    longitude: row.longitude ? row.longitude.toNumber() : null,
  };
}

export async function listActiveGovernorates(db: DbClient = prisma): Promise<Governorate[]> {
  const rows = await db.governorate.findMany({
    where: { isActive: true },
    select: governorateSelect,
    orderBy: { sortOrder: 'asc' },
  });
  return rows.map(toGovernorate);
}

export async function findGovernorateBySlug(
  slug: string,
  db: DbClient = prisma,
): Promise<Governorate | null> {
  const row = await db.governorate.findFirst({
    where: { slug, isActive: true },
    select: governorateSelect,
  });
  return row ? toGovernorate(row) : null;
}

// BE-14 : existence check pour `GET /governorates/:id/delegations` — `listActiveDelegationsByGovernorate`
// seul ne distingue pas un gouvernorat inconnu d'un gouvernorat réel sans délégation active.
export async function findGovernorateById(
  id: string,
  db: DbClient = prisma,
): Promise<Governorate | null> {
  const row = await db.governorate.findFirst({
    where: { id, isActive: true },
    select: governorateSelect,
  });
  return row ? toGovernorate(row) : null;
}

export async function listActiveDelegationsByGovernorate(
  governorateId: string,
  db: DbClient = prisma,
): Promise<Delegation[]> {
  const rows = await db.delegation.findMany({
    where: { governorateId, isActive: true },
    select: delegationSelect,
    orderBy: { nameFr: 'asc' },
  });
  return rows.map(toDelegation);
}

export async function findDelegationBySlug(
  governorateId: string,
  slug: string,
  db: DbClient = prisma,
): Promise<Delegation | null> {
  const row = await db.delegation.findFirst({
    where: { governorateId, slug, isActive: true },
    select: delegationSelect,
  });
  return row ? toDelegation(row) : null;
}
