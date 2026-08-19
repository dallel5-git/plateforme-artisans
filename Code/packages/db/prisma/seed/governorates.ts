// BE-03 : les 24 gouvernorats de Tunisie (référentiel figé). Codes ISO 3166-2:TN, libellés
// FR/AR réels. On les charge tous — pas seulement le Sahel — pour ne pas bloquer une
// expansion nationale plus tard (cf. issue #9). Seules les délégations sont limitées au Sahel.
import type { PrismaClient } from '@prisma/client';

export interface GovernorateSeed {
  code: string;
  nameFr: string;
  nameAr: string;
  slug: string;
  sortOrder: number;
}

export const governorates: GovernorateSeed[] = [
  { code: 'TN-11', nameFr: 'Tunis', nameAr: 'تونس', slug: 'tunis', sortOrder: 1 },
  { code: 'TN-12', nameFr: 'Ariana', nameAr: 'أريانة', slug: 'ariana', sortOrder: 2 },
  { code: 'TN-13', nameFr: 'Ben Arous', nameAr: 'بن عروس', slug: 'ben-arous', sortOrder: 3 },
  { code: 'TN-14', nameFr: 'Manouba', nameAr: 'منوبة', slug: 'manouba', sortOrder: 4 },
  { code: 'TN-21', nameFr: 'Nabeul', nameAr: 'نابل', slug: 'nabeul', sortOrder: 5 },
  { code: 'TN-22', nameFr: 'Zaghouan', nameAr: 'زغوان', slug: 'zaghouan', sortOrder: 6 },
  { code: 'TN-23', nameFr: 'Bizerte', nameAr: 'بنزرت', slug: 'bizerte', sortOrder: 7 },
  { code: 'TN-31', nameFr: 'Béja', nameAr: 'باجة', slug: 'beja', sortOrder: 8 },
  { code: 'TN-32', nameFr: 'Jendouba', nameAr: 'جندوبة', slug: 'jendouba', sortOrder: 9 },
  { code: 'TN-33', nameFr: 'Le Kef', nameAr: 'الكاف', slug: 'le-kef', sortOrder: 10 },
  { code: 'TN-34', nameFr: 'Siliana', nameAr: 'سليانة', slug: 'siliana', sortOrder: 11 },
  { code: 'TN-41', nameFr: 'Kairouan', nameAr: 'القيروان', slug: 'kairouan', sortOrder: 12 },
  { code: 'TN-42', nameFr: 'Kasserine', nameAr: 'القصرين', slug: 'kasserine', sortOrder: 13 },
  {
    code: 'TN-43',
    nameFr: 'Sidi Bouzid',
    nameAr: 'سيدي بوزيد',
    slug: 'sidi-bouzid',
    sortOrder: 14,
  },
  // --- Sahel : cible de lancement (CLAUDE.md §0) --------------------------------------
  { code: 'TN-51', nameFr: 'Sousse', nameAr: 'سوسة', slug: 'sousse', sortOrder: 15 },
  { code: 'TN-52', nameFr: 'Monastir', nameAr: 'المنستير', slug: 'monastir', sortOrder: 16 },
  { code: 'TN-53', nameFr: 'Mahdia', nameAr: 'المهدية', slug: 'mahdia', sortOrder: 17 },
  // -------------------------------------------------------------------------------------
  { code: 'TN-61', nameFr: 'Sfax', nameAr: 'صفاقس', slug: 'sfax', sortOrder: 18 },
  { code: 'TN-71', nameFr: 'Gafsa', nameAr: 'قفصة', slug: 'gafsa', sortOrder: 19 },
  { code: 'TN-72', nameFr: 'Tozeur', nameAr: 'توزر', slug: 'tozeur', sortOrder: 20 },
  { code: 'TN-73', nameFr: 'Kébili', nameAr: 'قبلي', slug: 'kebili', sortOrder: 21 },
  { code: 'TN-81', nameFr: 'Gabès', nameAr: 'قابس', slug: 'gabes', sortOrder: 22 },
  { code: 'TN-82', nameFr: 'Médenine', nameAr: 'مدنين', slug: 'medenine', sortOrder: 23 },
  { code: 'TN-83', nameFr: 'Tataouine', nameAr: 'تطاوين', slug: 'tataouine', sortOrder: 24 },
];

export async function seedGovernorates(prisma: PrismaClient): Promise<Map<string, string>> {
  const idByCode = new Map<string, string>();

  for (const gov of governorates) {
    const row = await prisma.governorate.upsert({
      where: { code: gov.code },
      create: gov,
      update: gov,
    });
    idByCode.set(gov.code, row.id);
  }

  return idByCode;
}
