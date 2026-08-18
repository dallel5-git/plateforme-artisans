// BE-04 : jeu de démonstration — 30 artisans du Sahel. Sert de support de recette (GATE 1,
// GATE 2) et de démo terrain — JAMAIS de production (voir seed-dev.ts, point d'entrée séparé
// de index.ts). Données écrites en dur, déterministes (pas de Math.random) : reproductibles et
// review-ables comme le reste du code.
import type { ContactChannel, PriceUnit, PrismaClient } from '@prisma/client';

const GOVERNORATE_SLUG: Record<'TN-51' | 'TN-52' | 'TN-53', string> = {
  'TN-51': 'sousse',
  'TN-52': 'monastir',
  'TN-53': 'mahdia',
};

interface ReviewSeed {
  clientFirstName: string;
  clientLastName: string;
  clientPhone: string;
  rating: 1 | 2 | 3 | 4 | 5;
  comment: string;
  channel: ContactChannel;
}

interface DemoProviderSeed {
  firstName: string;
  lastName: string;
  phone: string;
  categorySlug: string;
  governorateCode: 'TN-51' | 'TN-52' | 'TN-53';
  delegationSlug: string;
  coverageDelegationSlugs: string[];
  isVerified: boolean;
  yearsExperience: number;
  completionScore: number;
  bio: string;
  offering: { titleFr: string; titleAr: string; priceMin: number; priceMax: number; priceUnit: PriceUnit };
  photoCount: number;
  reviews?: ReviewSeed[];
  /** Note du plan (BE-04) : identifie les deux cas piège explicites de l'issue #10. */
  note?: string;
}

function businessName(lastName: string, categoryLabel: string): string {
  return `${lastName} ${categoryLabel}`;
}

function slugify(text: string): string {
  return text
    .normalize('NFD')
    .replace(/[̀-ͯ]/g, '')
    .toLowerCase()
    .replace(/[^a-z0-9]+/g, '-')
    .replace(/(^-|-$)/g, '');
}

const CATEGORY_LABEL: Record<string, string> = {
  plomberie: 'Plomberie',
  electricite: 'Électricité',
  peinture: 'Peinture',
  climatisation: 'Climatisation',
  menuiserie: 'Menuiserie',
  maconnerie: 'Maçonnerie',
  serrurerie: 'Serrurerie',
  jardinage: 'Jardinage',
  nettoyage: 'Nettoyage',
};

// Petits pools de commentaires, réutilisés par plusieurs avis (pas un doublon : des clients
// différents peuvent légitimement écrire des avis similaires).
const COMMENTS_5 = [
  'Travail sérieux et rapide, je recommande.',
  'Très professionnel, ponctuel et soigné.',
  'Service impeccable, artisan de confiance.',
  'Rien à redire, intervention nickel du premier coup.',
  'Excellent rapport qualité-prix, je le rappellerai.',
];
const COMMENTS_4 = [
  'Bon rapport qualité-prix, satisfait du résultat.',
  'Un peu de retard mais travail soigné.',
  'Réactif et efficace, quelques finitions à revoir.',
  'Correct, prix annoncé respecté.',
];
const COMMENTS_3 = ['Correct sans plus, a fait le nécessaire.'];

export const demoProviders: DemoProviderSeed[] = [
  // === Plomberie — 6 à Sousse (critère recherche « plombier · Sousse ») + 1 à Monastir =====
  {
    firstName: 'Mohamed',
    lastName: 'Trabelsi',
    phone: '+21650000001',
    categorySlug: 'plomberie',
    governorateCode: 'TN-51',
    delegationSlug: 'sousse-medina',
    coverageDelegationSlugs: ['sousse-medina', 'sousse-riadh', 'hammam-sousse'],
    isVerified: true,
    yearsExperience: 12,
    completionScore: 100,
    bio: "Plombier à Sousse depuis 12 ans, spécialiste dépannage d'urgence et installation sanitaire complète.",
    offering: { titleFr: 'Dépannage plomberie', titleAr: 'إصلاح سباكة', priceMin: 25, priceMax: 80, priceUnit: 'FIXED' },
    photoCount: 3,
    note: 'CAS PIÈGE 1/2 — vérifié, gratuit, complet (face à Fares Belhaj #14)',
    reviews: [
      { clientFirstName: 'Sonia', clientLastName: 'Ben Ammar', clientPhone: '+21690000001', rating: 5, comment: COMMENTS_5[0]!, channel: 'PHONE_CALL' },
      { clientFirstName: 'Hedi', clientLastName: 'Larbi', clientPhone: '+21690000002', rating: 5, comment: COMMENTS_5[1]!, channel: 'WHATSAPP' },
      { clientFirstName: 'Mouna', clientLastName: 'Zaidi', clientPhone: '+21690000003', rating: 4, comment: COMMENTS_4[0]!, channel: 'PHONE_CALL' },
      { clientFirstName: 'Riadh', clientLastName: 'Sfar', clientPhone: '+21690000004', rating: 5, comment: COMMENTS_5[2]!, channel: 'WHATSAPP' },
      { clientFirstName: 'Ines', clientLastName: 'Ouerghi', clientPhone: '+21690000005', rating: 5, comment: COMMENTS_5[3]!, channel: 'PHONE_CALL' },
    ],
  },
  {
    firstName: 'Ahmed',
    lastName: 'Gharbi',
    phone: '+21650000002',
    categorySlug: 'plomberie',
    governorateCode: 'TN-51',
    delegationSlug: 'hammam-sousse',
    coverageDelegationSlugs: ['hammam-sousse', 'akouda'],
    isVerified: true,
    yearsExperience: 8,
    completionScore: 85,
    bio: 'Plombier chauffagiste à Hammam Sousse, intervention rapide sur fuites et chauffe-eaux.',
    offering: { titleFr: 'Installation sanitaire', titleAr: 'تركيب صحي', priceMin: 30, priceMax: 120, priceUnit: 'ON_QUOTE' },
    photoCount: 2,
    note: 'CAS PIÈGE bayésien — 18 avis, moyenne brute ~4,67 (face à Nabil Hamdi #6)',
    reviews: Array.from({ length: 18 }, (_, i) => {
      const rating = (i % 3 === 2 ? 4 : 5) as 4 | 5; // 12×5 + 6×4 ≈ 4.67 de moyenne
      return {
        clientFirstName: `Client${i + 1}`,
        clientLastName: 'Demo',
        clientPhone: `+2169000${(100 + i).toString().padStart(3, '0')}`,
        rating,
        comment: rating === 5 ? COMMENTS_5[i % COMMENTS_5.length]! : COMMENTS_4[i % COMMENTS_4.length]!,
        channel: (i % 2 === 0 ? 'PHONE_CALL' : 'WHATSAPP') as ContactChannel,
      };
    }),
  },
  {
    firstName: 'Karim',
    lastName: 'Jlassi',
    phone: '+21650000003',
    categorySlug: 'plomberie',
    governorateCode: 'TN-51',
    delegationSlug: 'msaken',
    coverageDelegationSlugs: ['msaken'],
    isVerified: true,
    yearsExperience: 5,
    completionScore: 70,
    bio: "Plombier indépendant à M'saken, débouchage et petite installation.",
    offering: { titleFr: 'Débouchage canalisations', titleAr: 'تسليك القنوات', priceMin: 20, priceMax: 50, priceUnit: 'FIXED' },
    photoCount: 2,
    reviews: [
      { clientFirstName: 'Amel', clientLastName: 'Kacem', clientPhone: '+21690000010', rating: 5, comment: COMMENTS_5[0]!, channel: 'PHONE_CALL' },
      { clientFirstName: 'Foued', clientLastName: 'Mansour', clientPhone: '+21690000011', rating: 4, comment: COMMENTS_4[1]!, channel: 'WHATSAPP' },
      { clientFirstName: 'Leila', clientLastName: 'Hadj Ali', clientPhone: '+21690000012', rating: 4, comment: COMMENTS_4[2]!, channel: 'PHONE_CALL' },
    ],
  },
  {
    firstName: 'Sami',
    lastName: 'Mejri',
    phone: '+21650000004',
    categorySlug: 'plomberie',
    governorateCode: 'TN-51',
    delegationSlug: 'akouda',
    coverageDelegationSlugs: ['akouda'],
    isVerified: false,
    yearsExperience: 3,
    completionScore: 40,
    bio: 'Plombier à Akouda, petits travaux et dépannage.',
    offering: { titleFr: 'Réparation de fuites', titleAr: 'إصلاح التسربات', priceMin: 15, priceMax: 45, priceUnit: 'FIXED' },
    photoCount: 1,
  },
  {
    firstName: 'Walid',
    lastName: 'Ben Salah',
    phone: '+21650000005',
    categorySlug: 'plomberie',
    governorateCode: 'TN-51',
    delegationSlug: 'kalaa-kebira',
    coverageDelegationSlugs: ['kalaa-kebira', 'kalaa-seghira'],
    isVerified: true,
    yearsExperience: 10,
    completionScore: 90,
    bio: 'Plombier à Kalâa Kebira, sanitaire et chauffage central.',
    offering: { titleFr: 'Installation chauffe-eau', titleAr: 'تركيب سخان الماء', priceMin: 40, priceMax: 150, priceUnit: 'ON_QUOTE' },
    photoCount: 2,
  },
  {
    firstName: 'Nabil',
    lastName: 'Hamdi',
    phone: '+21650000006',
    categorySlug: 'plomberie',
    governorateCode: 'TN-51',
    delegationSlug: 'enfida',
    coverageDelegationSlugs: ['enfida', 'bouficha'],
    isVerified: true,
    yearsExperience: 6,
    completionScore: 65,
    bio: 'Plombier à Enfida, interventions rapides sur la zone.',
    offering: { titleFr: 'Dépannage plomberie', titleAr: 'إصلاح سباكة', priceMin: 20, priceMax: 60, priceUnit: 'FIXED' },
    photoCount: 1,
    note: 'CAS PIÈGE bayésien — 1 seul avis 5★, score brut trompeur (face à Ahmed Gharbi #2)',
    reviews: [
      { clientFirstName: 'Nizar', clientLastName: 'Trabelsi', clientPhone: '+21690000020', rating: 5, comment: COMMENTS_5[0]!, channel: 'PHONE_CALL' },
    ],
  },
  {
    firstName: 'Hichem',
    lastName: 'Khelifi',
    phone: '+21650000007',
    categorySlug: 'plomberie',
    governorateCode: 'TN-52',
    delegationSlug: 'monastir',
    coverageDelegationSlugs: ['monastir', 'sahline'],
    isVerified: true,
    yearsExperience: 15,
    completionScore: 95,
    bio: 'Plombier chevronné à Monastir, toutes interventions sanitaires.',
    offering: { titleFr: 'Rénovation salle de bain', titleAr: 'تجديد الحمام', priceMin: 200, priceMax: 800, priceUnit: 'ON_QUOTE' },
    photoCount: 3,
  },

  // === Électricité — 4 ==================================================================
  {
    firstName: 'Anouar',
    lastName: 'Sassi',
    phone: '+21650000008',
    categorySlug: 'electricite',
    governorateCode: 'TN-51',
    delegationSlug: 'sousse-riadh',
    coverageDelegationSlugs: ['sousse-riadh', 'sousse-jawhara'],
    isVerified: true,
    yearsExperience: 9,
    completionScore: 80,
    bio: 'Électricien agréé à Sousse Riadh, installation et mise aux normes.',
    offering: { titleFr: 'Installation électrique', titleAr: 'تركيبات كهربائية', priceMin: 35, priceMax: 200, priceUnit: 'ON_QUOTE' },
    photoCount: 2,
    reviews: [
      { clientFirstName: 'Yosra', clientLastName: 'Naceur', clientPhone: '+21690000030', rating: 5, comment: COMMENTS_5[0]!, channel: 'PHONE_CALL' },
      { clientFirstName: 'Adel', clientLastName: 'Rezgui', clientPhone: '+21690000031', rating: 4, comment: COMMENTS_4[0]!, channel: 'WHATSAPP' },
      { clientFirstName: 'Chiraz', clientLastName: 'Bousetta', clientPhone: '+21690000032', rating: 3, comment: COMMENTS_3[0]!, channel: 'PHONE_CALL' },
      { clientFirstName: 'Firas', clientLastName: 'Ellouze', clientPhone: '+21690000033', rating: 5, comment: COMMENTS_5[1]!, channel: 'WHATSAPP' },
    ],
  },
  {
    firstName: 'Ramzi',
    lastName: 'Guesmi',
    phone: '+21650000009',
    categorySlug: 'electricite',
    governorateCode: 'TN-52',
    delegationSlug: 'ksar-hellal',
    coverageDelegationSlugs: ['ksar-hellal'],
    isVerified: false,
    yearsExperience: 7,
    completionScore: 75,
    bio: 'Électricien à Ksar Hellal, dépannage tous types de pannes.',
    offering: { titleFr: 'Dépannage électrique', titleAr: 'إصلاحات كهربائية', priceMin: 25, priceMax: 90, priceUnit: 'FIXED' },
    photoCount: 2,
  },
  {
    firstName: 'Slim',
    lastName: 'Fendri',
    phone: '+21650000010',
    categorySlug: 'electricite',
    governorateCode: 'TN-53',
    delegationSlug: 'mahdia',
    coverageDelegationSlugs: ['mahdia'],
    isVerified: false,
    yearsExperience: 4,
    completionScore: 35,
    bio: 'Électricien à Mahdia, petites installations.',
    offering: { titleFr: 'Tableaux électriques', titleAr: 'لوحات كهربائية', priceMin: 50, priceMax: 250, priceUnit: 'ON_QUOTE' },
    photoCount: 1,
  },
  {
    firstName: 'Bilel',
    lastName: 'Toumi',
    phone: '+21650000011',
    categorySlug: 'electricite',
    governorateCode: 'TN-51',
    delegationSlug: 'bouficha',
    coverageDelegationSlugs: ['bouficha', 'enfida'],
    isVerified: true,
    yearsExperience: 11,
    completionScore: 88,
    bio: 'Électricien à Bouficha, installation neuve et rénovation.',
    offering: { titleFr: 'Installation électrique', titleAr: 'تركيبات كهربائية', priceMin: 40, priceMax: 300, priceUnit: 'ON_QUOTE' },
    photoCount: 2,
  },

  // === Peinture — 3 ======================================================================
  {
    firstName: 'Youssef',
    lastName: 'Rekik',
    phone: '+21650000012',
    categorySlug: 'peinture',
    governorateCode: 'TN-51',
    delegationSlug: 'sidi-bou-ali',
    coverageDelegationSlugs: ['sidi-bou-ali'],
    isVerified: true,
    yearsExperience: 6,
    completionScore: 60,
    bio: 'Peintre en bâtiment à Sidi Bou Ali, intérieur et extérieur.',
    offering: { titleFr: 'Peinture intérieure', titleAr: 'دهان داخلي', priceMin: 5, priceMax: 15, priceUnit: 'SQUARE_METER' },
    photoCount: 2,
    reviews: [
      { clientFirstName: 'Mariem', clientLastName: 'Jendoubi', clientPhone: '+21690000040', rating: 4, comment: COMMENTS_4[0]!, channel: 'PHONE_CALL' },
      { clientFirstName: 'Oussama', clientLastName: 'Chtioui', clientPhone: '+21690000041', rating: 5, comment: COMMENTS_5[2]!, channel: 'WHATSAPP' },
    ],
  },
  {
    firstName: 'Amira',
    lastName: 'Ayari',
    phone: '+21650000013',
    categorySlug: 'peinture',
    governorateCode: 'TN-52',
    delegationSlug: 'jemmal',
    coverageDelegationSlugs: ['jemmal'],
    isVerified: true,
    yearsExperience: 8,
    completionScore: 78,
    bio: 'Peintre décoratrice à Jemmal, finitions et décoration murale.',
    offering: { titleFr: 'Décoration murale', titleAr: 'زخرفة الجدران', priceMin: 8, priceMax: 25, priceUnit: 'SQUARE_METER' },
    photoCount: 3,
  },
  {
    firstName: 'Fares',
    lastName: 'Belhaj',
    phone: '+21650000014',
    categorySlug: 'peinture',
    governorateCode: 'TN-53',
    delegationSlug: 'el-jem',
    coverageDelegationSlugs: ['el-jem'],
    isVerified: false,
    yearsExperience: 2,
    completionScore: 25,
    bio: 'Peintre à El Jem.',
    offering: { titleFr: 'Peinture intérieure', titleAr: 'دهان داخلي', priceMin: 4, priceMax: 10, priceUnit: 'SQUARE_METER' },
    photoCount: 1,
    note: 'CAS PIÈGE 2/2 — non vérifié, profil minimal (face à Mohamed Trabelsi #1)',
  },

  // === Climatisation — 3 =================================================================
  {
    firstName: 'Tarek',
    lastName: 'Marzouki',
    phone: '+21650000015',
    categorySlug: 'climatisation',
    governorateCode: 'TN-51',
    delegationSlug: 'hergla',
    coverageDelegationSlugs: ['hergla', 'kondar'],
    isVerified: true,
    yearsExperience: 10,
    completionScore: 82,
    bio: 'Technicien climatisation à Hergla, installation et entretien.',
    offering: { titleFr: 'Installation climatiseur', titleAr: 'تركيب المكيفات', priceMin: 60, priceMax: 250, priceUnit: 'FIXED' },
    photoCount: 2,
  },
  {
    firstName: 'Aymen',
    lastName: 'Chaabane',
    phone: '+21650000016',
    categorySlug: 'climatisation',
    governorateCode: 'TN-52',
    delegationSlug: 'moknine',
    coverageDelegationSlugs: ['moknine'],
    isVerified: false,
    yearsExperience: 5,
    completionScore: 55,
    bio: 'Frigoriste à Moknine, entretien et réparation.',
    offering: { titleFr: 'Entretien et réparation', titleAr: 'صيانة وإصلاح', priceMin: 30, priceMax: 80, priceUnit: 'FIXED' },
    photoCount: 1,
  },
  {
    firstName: 'Chokri',
    lastName: 'Neji',
    phone: '+21650000017',
    categorySlug: 'climatisation',
    governorateCode: 'TN-53',
    delegationSlug: 'ksour-essef',
    coverageDelegationSlugs: ['ksour-essef'],
    isVerified: true,
    yearsExperience: 9,
    completionScore: 90,
    bio: 'Climatisation résidentielle et commerciale, Ksour Essef.',
    offering: { titleFr: 'Froid commercial', titleAr: 'التبريد التجاري', priceMin: 100, priceMax: 500, priceUnit: 'ON_QUOTE' },
    photoCount: 2,
  },

  // === Menuiserie — 3 ====================================================================
  {
    firstName: 'Mounir',
    lastName: 'Zribi',
    phone: '+21650000018',
    categorySlug: 'menuiserie',
    governorateCode: 'TN-51',
    delegationSlug: 'kondar',
    coverageDelegationSlugs: ['kondar'],
    isVerified: false,
    yearsExperience: 3,
    completionScore: 30,
    bio: 'Menuisier à Kondar.',
    offering: { titleFr: 'Menuiserie bois', titleAr: 'نجارة خشبية', priceMin: 50, priceMax: 300, priceUnit: 'ON_QUOTE' },
    photoCount: 1,
  },
  {
    firstName: 'Radhouane',
    lastName: 'Ben Romdhane',
    phone: '+21650000019',
    categorySlug: 'menuiserie',
    governorateCode: 'TN-52',
    delegationSlug: 'teboulba',
    coverageDelegationSlugs: ['teboulba', 'moknine'],
    isVerified: true,
    yearsExperience: 14,
    completionScore: 92,
    bio: 'Menuisier ébéniste à Téboulba, cuisines sur mesure.',
    offering: { titleFr: 'Cuisine sur mesure', titleAr: 'مطابخ حسب الطلب', priceMin: 800, priceMax: 4000, priceUnit: 'ON_QUOTE' },
    photoCount: 3,
    reviews: [
      { clientFirstName: 'Khaled', clientLastName: 'Abidi', clientPhone: '+21690000050', rating: 5, comment: COMMENTS_5[3]!, channel: 'WHATSAPP' },
      { clientFirstName: 'Dorra', clientLastName: 'Msadek', clientPhone: '+21690000051', rating: 5, comment: COMMENTS_5[4]!, channel: 'PHONE_CALL' },
      { clientFirstName: 'Imed', clientLastName: 'Saidi', clientPhone: '+21690000052', rating: 4, comment: COMMENTS_4[1]!, channel: 'WHATSAPP' },
    ],
  },
  {
    firstName: 'Zied',
    lastName: 'Ghariani',
    phone: '+21650000020',
    categorySlug: 'menuiserie',
    governorateCode: 'TN-53',
    delegationSlug: 'chebba',
    coverageDelegationSlugs: ['chebba'],
    isVerified: true,
    yearsExperience: 7,
    completionScore: 68,
    bio: 'Menuisier aluminium à Chebba, fenêtres et vérandas.',
    offering: { titleFr: 'Menuiserie aluminium', titleAr: 'نجارة الألمنيوم', priceMin: 150, priceMax: 900, priceUnit: 'ON_QUOTE' },
    photoCount: 2,
  },

  // === Maçonnerie — 3 ====================================================================
  {
    firstName: 'Nizar',
    lastName: 'Souissi',
    phone: '+21650000021',
    categorySlug: 'maconnerie',
    governorateCode: 'TN-51',
    delegationSlug: 'sidi-el-hani',
    coverageDelegationSlugs: ['sidi-el-hani'],
    isVerified: false,
    yearsExperience: 12,
    completionScore: 85,
    bio: 'Maçon à Sidi El Hani, gros œuvre et carrelage.',
    offering: { titleFr: 'Carrelage', titleAr: 'تبليط', priceMin: 8, priceMax: 20, priceUnit: 'SQUARE_METER' },
    photoCount: 2,
  },
  {
    firstName: 'Skander',
    lastName: 'Kammoun',
    phone: '+21650000022',
    categorySlug: 'maconnerie',
    governorateCode: 'TN-52',
    delegationSlug: 'sahline',
    coverageDelegationSlugs: ['sahline'],
    isVerified: false,
    yearsExperience: 4,
    completionScore: 38,
    bio: 'Maçon à Sahline, petits travaux.',
    offering: { titleFr: 'Étanchéité', titleAr: 'عزل المياه', priceMin: 15, priceMax: 40, priceUnit: 'SQUARE_METER' },
    photoCount: 1,
  },
  {
    firstName: 'Marouane',
    lastName: 'Amri',
    phone: '+21650000023',
    categorySlug: 'maconnerie',
    governorateCode: 'TN-53',
    delegationSlug: 'bou-merdes',
    coverageDelegationSlugs: ['bou-merdes'],
    isVerified: true,
    yearsExperience: 6,
    completionScore: 60,
    bio: 'Maçon à Bou Merdes, gros œuvre.',
    offering: { titleFr: 'Gros œuvre', titleAr: 'الأشغال الكبرى', priceMin: 100, priceMax: 1000, priceUnit: 'ON_QUOTE' },
    photoCount: 1,
  },

  // === Serrurerie — 3 ====================================================================
  {
    firstName: 'Bassem',
    lastName: 'Jaziri',
    phone: '+21650000024',
    categorySlug: 'serrurerie',
    governorateCode: 'TN-51',
    delegationSlug: 'chatt-meriem',
    coverageDelegationSlugs: ['chatt-meriem'],
    isVerified: true,
    yearsExperience: 8,
    completionScore: 72,
    bio: 'Serrurier à Chatt Meriem, ouverture de porte et dépannage.',
    offering: { titleFr: 'Ouverture de porte', titleAr: 'فتح الأبواب', priceMin: 15, priceMax: 40, priceUnit: 'FIXED' },
    photoCount: 2,
    reviews: [
      { clientFirstName: 'Sana', clientLastName: 'Gharsalli', clientPhone: '+21690000060', rating: 5, comment: COMMENTS_5[0]!, channel: 'PHONE_CALL' },
      { clientFirstName: 'Aymen', clientLastName: 'Bahri', clientPhone: '+21690000061', rating: 4, comment: COMMENTS_4[0]!, channel: 'WHATSAPP' },
    ],
  },
  {
    firstName: 'Hatem',
    lastName: 'Dridi',
    phone: '+21650000025',
    categorySlug: 'serrurerie',
    governorateCode: 'TN-52',
    delegationSlug: 'zeramdine',
    coverageDelegationSlugs: ['zeramdine'],
    isVerified: false,
    yearsExperience: 5,
    completionScore: 58,
    bio: 'Serrurier à Zéramdine, installation de serrures.',
    offering: { titleFr: 'Installation de serrures', titleAr: 'تركيب الأقفال', priceMin: 20, priceMax: 60, priceUnit: 'FIXED' },
    photoCount: 1,
  },
  {
    firstName: 'Rim',
    lastName: 'Chatti',
    phone: '+21650000026',
    categorySlug: 'serrurerie',
    governorateCode: 'TN-53',
    delegationSlug: 'chorbane',
    coverageDelegationSlugs: ['chorbane'],
    isVerified: false,
    yearsExperience: 2,
    completionScore: 20,
    bio: 'Serrurière à Chorbane.',
    offering: { titleFr: 'Ouverture de porte', titleAr: 'فتح الأبواب', priceMin: 15, priceMax: 35, priceUnit: 'FIXED' },
    photoCount: 1,
  },

  // === Jardinage — 2 =====================================================================
  {
    firstName: 'Nadia',
    lastName: 'Bel Haj Yahia',
    phone: '+21650000027',
    categorySlug: 'jardinage',
    governorateCode: 'TN-51',
    delegationSlug: 'kalaa-seghira',
    coverageDelegationSlugs: ['kalaa-seghira', 'kalaa-kebira'],
    isVerified: true,
    yearsExperience: 6,
    completionScore: 65,
    bio: 'Jardinière paysagiste à Kalâa Seghira.',
    offering: { titleFr: 'Entretien de jardin', titleAr: 'صيانة الحدائق', priceMin: 20, priceMax: 60, priceUnit: 'HOUR' },
    photoCount: 2,
  },
  {
    firstName: 'Sabrine',
    lastName: 'Ferjani',
    phone: '+21650000028',
    categorySlug: 'jardinage',
    governorateCode: 'TN-52',
    delegationSlug: 'bekalta',
    coverageDelegationSlugs: ['bekalta'],
    isVerified: true,
    yearsExperience: 9,
    completionScore: 80,
    bio: 'Aménagement paysager à Bekalta.',
    offering: { titleFr: 'Aménagement paysager', titleAr: 'تهيئة المساحات الخضراء', priceMin: 100, priceMax: 600, priceUnit: 'ON_QUOTE' },
    photoCount: 2,
  },

  // === Nettoyage — 2 =====================================================================
  {
    firstName: 'Emna',
    lastName: 'Trabelsi',
    phone: '+21650000029',
    categorySlug: 'nettoyage',
    governorateCode: 'TN-51',
    delegationSlug: 'sousse-sidi-abdelhamid',
    coverageDelegationSlugs: ['sousse-sidi-abdelhamid', 'sousse-medina'],
    isVerified: true,
    yearsExperience: 4,
    completionScore: 50,
    bio: 'Nettoyage à domicile, Sousse Sidi Abdelhamid.',
    offering: { titleFr: 'Nettoyage à domicile', titleAr: 'تنظيف المنازل', priceMin: 15, priceMax: 40, priceUnit: 'HOUR' },
    photoCount: 1,
  },
  {
    firstName: 'Wafa',
    lastName: 'Cherni',
    phone: '+21650000030',
    categorySlug: 'nettoyage',
    governorateCode: 'TN-53',
    delegationSlug: 'hebira',
    coverageDelegationSlugs: ['hebira'],
    isVerified: true,
    yearsExperience: 7,
    completionScore: 70,
    bio: 'Nettoyage après travaux, Hebira.',
    offering: { titleFr: 'Nettoyage après travaux', titleAr: 'تنظيف بعد الأشغال', priceMin: 50, priceMax: 200, priceUnit: 'FIXED' },
    photoCount: 2,
  },
];

export async function seedDevFixtures(
  prisma: PrismaClient,
  governorateIdByCode: Map<string, string>,
): Promise<void> {
  // Résout délégation (gouvernorat, slug) -> id une seule fois.
  const delegationRows = await prisma.delegation.findMany({ select: { id: true, slug: true, governorateId: true } });
  const delegationIdByGovSlug = new Map(delegationRows.map((d) => [`${d.governorateId}:${d.slug}`, d.id]));

  const categoryRows = await prisma.category.findMany({ select: { id: true, slug: true } });
  const categoryIdBySlug = new Map(categoryRows.map((c) => [c.slug, c.id]));

  let verifiedCount = 0;

  for (const p of demoProviders) {
    const governorateId = governorateIdByCode.get(p.governorateCode);
    if (!governorateId) throw new Error(`Gouvernorat inconnu: ${p.governorateCode}`);

    const delegationId = delegationIdByGovSlug.get(`${governorateId}:${p.delegationSlug}`);
    if (!delegationId) throw new Error(`Délégation inconnue: ${p.delegationSlug} (${p.governorateCode})`);

    const categoryId = categoryIdBySlug.get(p.categorySlug);
    if (!categoryId) throw new Error(`Catégorie inconnue: ${p.categorySlug}`);

    const name = businessName(p.lastName, CATEGORY_LABEL[p.categorySlug]!);
    const slug = `${slugify(name)}-${GOVERNORATE_SLUG[p.governorateCode]}`;

    if (p.isVerified) verifiedCount += 1;

    const user = await prisma.user.upsert({
      where: { phone: p.phone },
      create: {
        phone: p.phone,
        phoneVerifiedAt: new Date(),
        firstName: p.firstName,
        lastName: p.lastName,
        roles: ['PROVIDER'],
        status: 'ACTIVE',
      },
      update: { firstName: p.firstName, lastName: p.lastName },
    });

    const ratingCount = p.reviews?.length ?? 0;
    const ratingAvg = ratingCount > 0 ? p.reviews!.reduce((sum, r) => sum + r.rating, 0) / ratingCount : 0;

    const provider = await prisma.providerProfile.upsert({
      where: { slug },
      create: {
        userId: user.id,
        slug,
        businessName: name,
        headline: p.offering.titleFr,
        bio: p.bio,
        yearsExperience: p.yearsExperience,
        whatsappPhone: p.phone,
        publicPhone: p.phone,
        baseGovernorateId: governorateId,
        baseDelegationId: delegationId,
        publicationStatus: 'PUBLISHED',
        verificationStatus: p.isVerified ? 'APPROVED' : 'NOT_SUBMITTED',
        isVerified: p.isVerified,
        verifiedAt: p.isVerified ? new Date() : null,
        completionScore: p.completionScore,
        ratingAvg,
        ratingCount,
        totalContacts: ratingCount,
        totalProfileViews: ratingCount * 4,
      },
      update: {
        businessName: name,
        headline: p.offering.titleFr,
        bio: p.bio,
        yearsExperience: p.yearsExperience,
        baseGovernorateId: governorateId,
        baseDelegationId: delegationId,
        isVerified: p.isVerified,
        verificationStatus: p.isVerified ? 'APPROVED' : 'NOT_SUBMITTED',
        completionScore: p.completionScore,
        ratingAvg,
        ratingCount,
        totalContacts: ratingCount,
        totalProfileViews: ratingCount * 4,
      },
    });

    // --- Catégorie principale (idempotent : upsert sur la clé composite) -----------------
    await prisma.providerCategory.upsert({
      where: { providerId_categoryId: { providerId: provider.id, categoryId } },
      create: { providerId: provider.id, categoryId, isPrimary: true, yearsExperience: p.yearsExperience },
      update: { isPrimary: true, yearsExperience: p.yearsExperience },
    });

    // --- Offre, zones, galerie, avis : pas de clé naturelle -> on recrée à chaque run ----
    await prisma.serviceOffering.deleteMany({ where: { providerId: provider.id } });
    await prisma.serviceOffering.create({
      data: {
        providerId: provider.id,
        categoryId,
        titleFr: p.offering.titleFr,
        titleAr: p.offering.titleAr,
        priceMin: p.offering.priceMin,
        priceMax: p.offering.priceMax,
        priceUnit: p.offering.priceUnit,
      },
    });

    await prisma.coverageArea.deleteMany({ where: { providerId: provider.id } });
    for (const covSlug of p.coverageDelegationSlugs) {
      const covId = delegationIdByGovSlug.get(`${governorateId}:${covSlug}`);
      if (!covId) throw new Error(`Zone de couverture inconnue: ${covSlug}`);
      await prisma.coverageArea.create({
        data: { providerId: provider.id, governorateId, delegationId: covId },
      });
    }

    await prisma.portfolioItem.deleteMany({ where: { providerId: provider.id } });
    for (let i = 0; i < p.photoCount; i += 1) {
      const storageKey = `demo/${slug}/${i + 1}.jpg`;
      const media = await prisma.mediaAsset.upsert({
        where: { storageKey },
        create: {
          uploadedById: user.id,
          bucket: 'public-media',
          storageKey,
          publicUrl: `https://picsum.photos/seed/${slug}-${i + 1}/800/600`,
          type: 'IMAGE',
          mimeType: 'image/jpeg',
          sizeBytes: 120_000,
          width: 800,
          height: 600,
          moderationStatus: 'APPROVED',
        },
        update: {},
      });
      await prisma.portfolioItem.create({
        data: { providerId: provider.id, mediaId: media.id, categoryId, sortOrder: i, status: 'APPROVED' },
      });
    }

    await prisma.review.deleteMany({ where: { providerId: provider.id } });
    await prisma.contactEvent.deleteMany({ where: { providerId: provider.id } });
    if (p.reviews) {
      for (const r of p.reviews) {
        const client = await prisma.user.upsert({
          where: { phone: r.clientPhone },
          create: {
            phone: r.clientPhone,
            firstName: r.clientFirstName,
            lastName: r.clientLastName,
            roles: ['CLIENT'],
            status: 'ACTIVE',
          },
          update: {},
        });

        const contactEvent = await prisma.contactEvent.create({
          data: {
            providerId: provider.id,
            clientId: client.id,
            categoryId,
            channel: r.channel,
            sourceScreen: 'profile',
          },
        });

        await prisma.review.create({
          data: {
            providerId: provider.id,
            clientId: client.id,
            contactEventId: contactEvent.id,
            rating: r.rating,
            comment: r.comment,
            status: 'PUBLISHED',
            isVerifiedContact: true,
          },
        });
      }
    }
  }

  if (verifiedCount !== 20) {
    throw new Error(`Attendu 20 artisans vérifiés sur 30, obtenu ${verifiedCount} — corriger dev-fixtures.ts`);
  }
}
