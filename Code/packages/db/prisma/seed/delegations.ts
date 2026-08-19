// BE-03 : délégations du Sahel uniquement (Sousse, Monastir, Mahdia) — cible de lancement
// (CLAUDE.md §0). Les autres gouvernorats restent sans délégation jusqu'à l'expansion
// nationale (hors périmètre, volontairement — issue #9). Libellés AR vérifiés (sources
// croisées Wikipédia FR/AR), pas de copie du français.
import type { PrismaClient } from '@prisma/client';

export interface DelegationSeed {
  governorateCode: string;
  slug: string;
  nameFr: string;
  nameAr: string;
}

export const delegations: DelegationSeed[] = [
  // --- Sousse (TN-51) — 17 délégations ------------------------------------------------
  {
    governorateCode: 'TN-51',
    slug: 'sousse-medina',
    nameFr: 'Sousse Médina',
    nameAr: 'سوسة المدينة',
  },
  { governorateCode: 'TN-51', slug: 'sousse-riadh', nameFr: 'Sousse Riadh', nameAr: 'سوسة الرياض' },
  {
    governorateCode: 'TN-51',
    slug: 'sousse-jawhara',
    nameFr: 'Sousse Jawhara',
    nameAr: 'سوسة جوهرة',
  },
  {
    governorateCode: 'TN-51',
    slug: 'sousse-sidi-abdelhamid',
    nameFr: 'Sousse Sidi Abdelhamid',
    nameAr: 'سوسة سيدي عبد الحميد',
  },
  { governorateCode: 'TN-51', slug: 'hammam-sousse', nameFr: 'Hammam Sousse', nameAr: 'حمام سوسة' },
  { governorateCode: 'TN-51', slug: 'akouda', nameFr: 'Akouda', nameAr: 'أكودة' },
  {
    governorateCode: 'TN-51',
    slug: 'kalaa-kebira',
    nameFr: 'Kalâa Kebira',
    nameAr: 'القلعة الكبرى',
  },
  {
    governorateCode: 'TN-51',
    slug: 'kalaa-seghira',
    nameFr: 'Kalâa Seghira',
    nameAr: 'القلعة الصغرى',
  },
  { governorateCode: 'TN-51', slug: 'msaken', nameFr: "M'saken", nameAr: 'مساكن' },
  { governorateCode: 'TN-51', slug: 'sidi-bou-ali', nameFr: 'Sidi Bou Ali', nameAr: 'سيدي بوعلي' },
  { governorateCode: 'TN-51', slug: 'bouficha', nameFr: 'Bouficha', nameAr: 'بوفيشة' },
  { governorateCode: 'TN-51', slug: 'enfida', nameFr: 'Enfida', nameAr: 'النفيضة' },
  { governorateCode: 'TN-51', slug: 'hergla', nameFr: 'Hergla', nameAr: 'هرقلة' },
  { governorateCode: 'TN-51', slug: 'kondar', nameFr: 'Kondar', nameAr: 'كندار' },
  { governorateCode: 'TN-51', slug: 'sidi-el-hani', nameFr: 'Sidi El Hani', nameAr: 'سيدي الهاني' },
  {
    governorateCode: 'TN-51',
    slug: 'zaouiet-ksibet-thrayet',
    nameFr: 'Zaouiet Ksibet Thrayet',
    nameAr: 'الزاوية القصيبة الثريات',
  },
  { governorateCode: 'TN-51', slug: 'chatt-meriem', nameFr: 'Chatt Meriem', nameAr: 'شط مريم' },

  // --- Monastir (TN-52) — 13 délégations ----------------------------------------------
  { governorateCode: 'TN-52', slug: 'monastir', nameFr: 'Monastir', nameAr: 'المنستير' },
  { governorateCode: 'TN-52', slug: 'bekalta', nameFr: 'Bekalta', nameAr: 'البقالطة' },
  { governorateCode: 'TN-52', slug: 'bembla', nameFr: 'Bembla', nameAr: 'بنبلة' },
  { governorateCode: 'TN-52', slug: 'beni-hassen', nameFr: 'Beni Hassen', nameAr: 'بني حسان' },
  { governorateCode: 'TN-52', slug: 'jemmal', nameFr: 'Jemmal', nameAr: 'جمال' },
  { governorateCode: 'TN-52', slug: 'ksar-hellal', nameFr: 'Ksar Hellal', nameAr: 'قصر هلال' },
  {
    governorateCode: 'TN-52',
    slug: 'ksibet-el-mediouni',
    nameFr: 'Ksibet el-Médiouni',
    nameAr: 'قصيبة المديوني',
  },
  { governorateCode: 'TN-52', slug: 'moknine', nameFr: 'Moknine', nameAr: 'المكنين' },
  { governorateCode: 'TN-52', slug: 'ouerdanine', nameFr: 'Ouerdanine', nameAr: 'الوردانين' },
  { governorateCode: 'TN-52', slug: 'sahline', nameFr: 'Sahline', nameAr: 'الساحلين' },
  {
    governorateCode: 'TN-52',
    slug: 'sayada-lamta-bou-hajar',
    nameFr: 'Sayada-Lamta-Bou Hajar',
    nameAr: 'صيادة لمطة بوحجر',
  },
  { governorateCode: 'TN-52', slug: 'teboulba', nameFr: 'Téboulba', nameAr: 'طبلبة' },
  { governorateCode: 'TN-52', slug: 'zeramdine', nameFr: 'Zéramdine', nameAr: 'زرمدين' },

  // --- Mahdia (TN-53) — 13 délégations ------------------------------------------------
  { governorateCode: 'TN-53', slug: 'mahdia', nameFr: 'Mahdia', nameAr: 'المهدية' },
  { governorateCode: 'TN-53', slug: 'bou-merdes', nameFr: 'Bou Merdes', nameAr: 'بومرداس' },
  { governorateCode: 'TN-53', slug: 'chebba', nameFr: 'Chebba', nameAr: 'الشابة' },
  { governorateCode: 'TN-53', slug: 'chorbane', nameFr: 'Chorbane', nameAr: 'شربان' },
  { governorateCode: 'TN-53', slug: 'el-bradaa', nameFr: 'El Bradâa', nameAr: 'البرادعة' },
  { governorateCode: 'TN-53', slug: 'el-jem', nameFr: 'El Jem', nameAr: 'الجم' },
  { governorateCode: 'TN-53', slug: 'essouassi', nameFr: 'Essouassi', nameAr: 'السواسي' },
  { governorateCode: 'TN-53', slug: 'hebira', nameFr: 'Hebira', nameAr: 'هبيرة' },
  { governorateCode: 'TN-53', slug: 'ksour-essef', nameFr: 'Ksour Essef', nameAr: 'قصور الساف' },
  { governorateCode: 'TN-53', slug: 'melloulech', nameFr: 'Melloulèche', nameAr: 'ملولش' },
  {
    governorateCode: 'TN-53',
    slug: 'ouled-chamekh',
    nameFr: 'Ouled Chamekh',
    nameAr: 'أولاد شامخ',
  },
  { governorateCode: 'TN-53', slug: 'rejiche', nameFr: 'Rejiche', nameAr: 'الرجيش' },
  { governorateCode: 'TN-53', slug: 'sidi-alouane', nameFr: 'Sidi Alouane', nameAr: 'سيدي علوان' },
];

export async function seedDelegations(
  prisma: PrismaClient,
  governorateIdByCode: Map<string, string>,
): Promise<void> {
  for (const del of delegations) {
    const governorateId = governorateIdByCode.get(del.governorateCode);
    if (!governorateId) {
      throw new Error(
        `Gouvernorat introuvable pour la délégation ${del.slug}: ${del.governorateCode}`,
      );
    }

    await prisma.delegation.upsert({
      where: { governorateId_slug: { governorateId, slug: del.slug } },
      create: { governorateId, slug: del.slug, nameFr: del.nameFr, nameAr: del.nameAr },
      update: { nameFr: del.nameFr, nameAr: del.nameAr },
    });
  }
}
