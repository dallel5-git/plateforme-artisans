// BE-03 : arbre de catégories (2 niveaux), FR/AR réels — pas de copie du français en arabe.
// `iconKey` = slug de la catégorie : aucune convention d'icônes n'existe encore dans le repo
// (design-tokens/FM-04 la définiront) ; c'est un placeholder résolu plus tard, pas une
// convention figée par BE-03.
import type { PrismaClient } from '@prisma/client';

export interface CategorySeed {
  slug: string;
  nameFr: string;
  nameAr: string;
  sortOrder: number;
  children: Array<{ slug: string; nameFr: string; nameAr: string; sortOrder: number }>;
}

export const categories: CategorySeed[] = [
  {
    slug: 'plomberie',
    nameFr: 'Plomberie',
    nameAr: 'سباكة',
    sortOrder: 1,
    children: [
      { slug: 'reparation-fuites', nameFr: 'Réparation de fuites', nameAr: 'إصلاح التسربات', sortOrder: 1 },
      {
        slug: 'installation-sanitaire',
        nameFr: 'Installation sanitaire',
        nameAr: 'تركيب الأدوات الصحية',
        sortOrder: 2,
      },
      {
        slug: 'debouchage-canalisations',
        nameFr: 'Débouchage de canalisations',
        nameAr: 'تسليك القنوات',
        sortOrder: 3,
      },
    ],
  },
  {
    slug: 'electricite',
    nameFr: 'Électricité',
    nameAr: 'كهرباء',
    sortOrder: 2,
    children: [
      {
        slug: 'installation-electrique',
        nameFr: 'Installation électrique',
        nameAr: 'تركيبات كهربائية',
        sortOrder: 1,
      },
      {
        slug: 'depannage-electrique',
        nameFr: 'Dépannage électrique',
        nameAr: 'إصلاحات كهربائية',
        sortOrder: 2,
      },
      { slug: 'tableaux-electriques', nameFr: 'Tableaux électriques', nameAr: 'لوحات كهربائية', sortOrder: 3 },
    ],
  },
  {
    slug: 'peinture',
    nameFr: 'Peinture',
    nameAr: 'دهان',
    sortOrder: 3,
    children: [
      { slug: 'peinture-interieure', nameFr: 'Peinture intérieure', nameAr: 'دهان داخلي', sortOrder: 1 },
      { slug: 'peinture-exterieure', nameFr: 'Peinture extérieure', nameAr: 'دهان خارجي', sortOrder: 2 },
      { slug: 'decoration-murale', nameFr: 'Décoration murale', nameAr: 'زخرفة الجدران', sortOrder: 3 },
    ],
  },
  {
    slug: 'climatisation',
    nameFr: 'Climatisation',
    nameAr: 'تكييف الهواء',
    sortOrder: 4,
    children: [
      {
        slug: 'installation-climatiseur',
        nameFr: 'Installation de climatiseur',
        nameAr: 'تركيب المكيفات',
        sortOrder: 1,
      },
      {
        slug: 'entretien-reparation-clim',
        nameFr: 'Entretien et réparation',
        nameAr: 'صيانة وإصلاح',
        sortOrder: 2,
      },
      { slug: 'froid-commercial', nameFr: 'Froid commercial', nameAr: 'التبريد التجاري', sortOrder: 3 },
    ],
  },
  {
    slug: 'menuiserie',
    nameFr: 'Menuiserie',
    nameAr: 'نجارة',
    sortOrder: 5,
    children: [
      { slug: 'menuiserie-bois', nameFr: 'Menuiserie bois', nameAr: 'نجارة خشبية', sortOrder: 1 },
      {
        slug: 'menuiserie-aluminium',
        nameFr: 'Menuiserie aluminium',
        nameAr: 'نجارة الألمنيوم',
        sortOrder: 2,
      },
      { slug: 'cuisine-sur-mesure', nameFr: 'Cuisine sur mesure', nameAr: 'مطابخ حسب الطلب', sortOrder: 3 },
    ],
  },
  {
    slug: 'maconnerie',
    nameFr: 'Maçonnerie',
    nameAr: 'بناء',
    sortOrder: 6,
    children: [
      { slug: 'gros-oeuvre', nameFr: 'Gros œuvre', nameAr: 'الأشغال الكبرى', sortOrder: 1 },
      { slug: 'carrelage', nameFr: 'Carrelage', nameAr: 'تبليط', sortOrder: 2 },
      { slug: 'etancheite', nameFr: 'Étanchéité', nameAr: 'عزل المياه', sortOrder: 3 },
    ],
  },
  {
    slug: 'serrurerie',
    nameFr: 'Serrurerie',
    nameAr: 'أقفال ومفاتيح',
    sortOrder: 7,
    children: [
      { slug: 'ouverture-porte', nameFr: 'Ouverture de porte', nameAr: 'فتح الأبواب', sortOrder: 1 },
      {
        slug: 'installation-serrures',
        nameFr: 'Installation de serrures',
        nameAr: 'تركيب الأقفال',
        sortOrder: 2,
      },
      { slug: 'coffres-forts', nameFr: 'Coffres-forts', nameAr: 'خزائن حديدية', sortOrder: 3 },
    ],
  },
  {
    slug: 'jardinage',
    nameFr: 'Jardinage',
    nameAr: 'بستنة',
    sortOrder: 8,
    children: [
      { slug: 'entretien-jardin', nameFr: 'Entretien de jardin', nameAr: 'صيانة الحدائق', sortOrder: 1 },
      { slug: 'elagage', nameFr: 'Élagage', nameAr: 'تقليم الأشجار', sortOrder: 2 },
      {
        slug: 'amenagement-paysager',
        nameFr: 'Aménagement paysager',
        nameAr: 'تهيئة المساحات الخضراء',
        sortOrder: 3,
      },
    ],
  },
  {
    slug: 'nettoyage',
    nameFr: 'Nettoyage',
    nameAr: 'تنظيف',
    sortOrder: 9,
    children: [
      { slug: 'nettoyage-domicile', nameFr: 'Nettoyage à domicile', nameAr: 'تنظيف المنازل', sortOrder: 1 },
      {
        slug: 'nettoyage-apres-travaux',
        nameFr: 'Nettoyage après travaux',
        nameAr: 'تنظيف بعد الأشغال',
        sortOrder: 2,
      },
      {
        slug: 'nettoyage-tapis-moquettes',
        nameFr: 'Nettoyage de tapis et moquettes',
        nameAr: 'تنظيف السجاد والموكيت',
        sortOrder: 3,
      },
    ],
  },
];

export async function seedCategories(prisma: PrismaClient): Promise<void> {
  for (const parent of categories) {
    const parentRow = await prisma.category.upsert({
      where: { slug: parent.slug },
      create: {
        slug: parent.slug,
        nameFr: parent.nameFr,
        nameAr: parent.nameAr,
        iconKey: parent.slug,
        sortOrder: parent.sortOrder,
      },
      update: {
        nameFr: parent.nameFr,
        nameAr: parent.nameAr,
        iconKey: parent.slug,
        sortOrder: parent.sortOrder,
      },
    });

    for (const child of parent.children) {
      await prisma.category.upsert({
        where: { slug: child.slug },
        create: {
          slug: child.slug,
          nameFr: child.nameFr,
          nameAr: child.nameAr,
          iconKey: child.slug,
          sortOrder: child.sortOrder,
          parentId: parentRow.id,
        },
        update: {
          nameFr: child.nameFr,
          nameAr: child.nameAr,
          iconKey: child.slug,
          sortOrder: child.sortOrder,
          parentId: parentRow.id,
        },
      });
    }
  }
}
