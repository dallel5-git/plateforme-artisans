export interface Category {
  id: string;
  slug: string;
  nameFr: string;
  nameAr: string;
  descriptionFr: string;
  descriptionAr: string;
  icon: string;
  sortOrder: number;
}

export interface Delegation {
  id: string;
  governorateId: string;
  code: string;
  nameFr: string;
  nameAr: string;
  slug: string;
  postalCode: string;
  latitude: number;
  longitude: number;
}

export interface Governorate {
  id: string;
  code: string;
  nameFr: string;
  nameAr: string;
  slug: string;
  latitude: number;
  longitude: number;
  sortOrder: number;
  delegations: Delegation[];
}

export interface ReviewItem {
  id: string;
  authorName: string;
  rating: number;
  comment: string;
  isVerifiedContact: boolean;
  createdAt: string;
}

export interface OfferingItem {
  id: string;
  titleFr: string;
  titleAr: string;
  descriptionFr: string;
  descriptionAr: string;
  priceStartingAt: number;
  priceUnit: string;
}

export interface PortfolioItem {
  id: string;
  url: string;
  caption: string;
}

export interface ProviderDetail {
  id: string;
  slug: string;
  businessName: string;
  headline: string;
  bio: string;
  yearsExperience: number;
  ratingAvg: number;
  ratingCount: number;
  isVerified: boolean;
  verifiedAt?: string;
  acceptsEmergency: boolean;
  availabilityStatus: 'AVAILABLE' | 'BUSY' | 'ON_HOLIDAY';
  spokenLanguages: ('FR' | 'AR' | 'EN')[];
  baseGovernorateId: string;
  baseGovernorateSlug: string;
  baseGovernorateNameFr: string;
  baseGovernorateNameAr: string;
  baseDelegationId: string;
  baseDelegationNameFr: string;
  baseDelegationNameAr: string;
  primaryCategorySlug: string;
  primaryCategoryNameFr: string;
  primaryCategoryNameAr: string;
  avatarUrl: string;
  coverUrl: string;
  phone: string;
  whatsappPhone: string;
  categories: Category[];
  coverageAreas: string[];
  offerings: OfferingItem[];
  portfolio: PortfolioItem[];
  reviews: ReviewItem[];
  completionScore: number;
}

export const DEMO_CATEGORIES: Category[] = [
  {
    id: 'cat-plomberie',
    slug: 'plomberie',
    nameFr: 'Plomberie',
    nameAr: 'سباكة',
    descriptionFr: 'Dépannage de fuite, installation sanitaire, débouchage et chauffe-eau.',
    descriptionAr: 'إصلاح التسربات، تركيب الأدوات الصحية، تسريح المجاري وسخانات المياه.',
    icon: 'Wrench',
    sortOrder: 1,
  },
  {
    id: 'cat-electricite',
    slug: 'electricite',
    nameFr: 'Électricité',
    nameAr: 'كهرباء',
    descriptionFr: 'Installation électrique, mise aux normes, tableau électrique et pannes.',
    descriptionAr: 'تركيب الشبكات الكهربائية، صيانة اللوحات وإصلاح الأعطال الطارئة.',
    icon: 'Zap',
    sortOrder: 2,
  },
  {
    id: 'cat-climatisation',
    slug: 'climatisation',
    nameFr: 'Climatisation',
    nameAr: 'تكييف وتبريد',
    descriptionFr: 'Installation climatiseur, recharge gaz, entretien et dépannage.',
    descriptionAr: 'تركيب المكيفات، شحن الغاز، الصيانة الدورية وإصلاح الأعطال.',
    icon: 'Wind',
    sortOrder: 3,
  },
  {
    id: 'cat-peinture',
    slug: 'peinture',
    nameFr: 'Peinture & Déco',
    nameAr: 'دهان وديكور',
    descriptionFr: 'Peinture intérieure, ravalement de façade et pose de papier peint.',
    descriptionAr: 'دهان المنازل الداخلي والخارجي، معالجة الرطوبة والديكور العصري.',
    icon: 'Paintbrush',
    sortOrder: 4,
  },
  {
    id: 'cat-menuiserie',
    slug: 'menuiserie',
    nameFr: 'Menuiserie & Alu',
    nameAr: 'نجارة وألومنيوم',
    descriptionFr: 'Portes, fenêtres aluminium, dressings sur mesure et volets roulants.',
    descriptionAr: 'أبواب ونوافذ ألومنيوم وخشب، خزائن مخصصة ومصبعات أوتوماتيكية.',
    icon: 'Hammer',
    sortOrder: 5,
  },
  {
    id: 'cat-serrurerie',
    slug: 'serrurerie',
    nameFr: 'Serrurerie 24/7',
    nameAr: 'أقفال ومفاتيح',
    descriptionFr: 'Ouverture de porte claquée, blindage et changement de serrure urgent.',
    descriptionAr: 'فتح الأبواب المغلقة، تغيير الأقفال وتركيب الحماية الأمنية المستعجلة.',
    icon: 'Key',
    sortOrder: 6,
  },
  {
    id: 'cat-maconnerie',
    slug: 'maconnerie',
    nameFr: 'Maçonnerie & Carrelage',
    nameAr: 'بناء وبلاط',
    descriptionFr: 'Pose de faïence, grès dans la masse, cloisons et petites rénovations.',
    descriptionAr: 'تركيب البلاط والخزف، بناء الجدران وأشغال التهيئة والترميم.',
    icon: 'BrickWall',
    sortOrder: 7,
  },
  {
    id: 'cat-etancheite',
    slug: 'etancheite',
    nameFr: 'Étanchéité',
    nameAr: 'عزل الرطوبة',
    descriptionFr: 'Traitement anti-humidité, étanchéité toitures terrasses et isolation.',
    descriptionAr: 'عزل الأسطح من مياه الأمطار ومعالجة الرطوبة المزمنة في الجدران.',
    icon: 'Shield',
    sortOrder: 8,
  },
];

export const DEMO_GOVERNORATES: Governorate[] = [
  {
    id: 'gov-sousse',
    code: 'SOU',
    nameFr: 'Sousse',
    nameAr: 'سوسة',
    slug: 'sousse',
    latitude: 35.8256,
    longitude: 10.6369,
    sortOrder: 1,
    delegations: [
      {
        id: 'del-sousse-v',
        governorateId: 'gov-sousse',
        code: 'SOU-V',
        nameFr: 'Sousse Ville',
        nameAr: 'سوسة المدينة',
        slug: 'sousse-ville',
        postalCode: '4000',
        latitude: 35.8256,
        longitude: 10.6369,
      },
      {
        id: 'del-sahloul',
        governorateId: 'gov-sousse',
        code: 'SAH',
        nameFr: 'Sahloul',
        nameAr: 'سهلول',
        slug: 'sahloul',
        postalCode: '4054',
        latitude: 35.8394,
        longitude: 10.5989,
      },
      {
        id: 'del-kantaoui',
        governorateId: 'gov-sousse',
        code: 'KAN',
        nameFr: 'Port El Kantaoui',
        nameAr: 'القنطاوي',
        slug: 'kantaoui',
        postalCode: '4089',
        latitude: 35.8942,
        longitude: 10.5975,
      },
      {
        id: 'del-hammam-sousse',
        governorateId: 'gov-sousse',
        code: 'HAM',
        nameFr: 'Hammam Sousse',
        nameAr: 'حمام سوسة',
        slug: 'hammam-sousse',
        postalCode: '4011',
        latitude: 35.8583,
        longitude: 10.5936,
      },
      {
        id: 'del-jawhara',
        governorateId: 'gov-sousse',
        code: 'JAW',
        nameFr: 'Sousse Jawhara',
        nameAr: 'سوسة جوهرة',
        slug: 'sousse-jawhara',
        postalCode: '4002',
        latitude: 35.828,
        longitude: 10.615,
      },
      {
        id: 'del-msaken',
        governorateId: 'gov-sousse',
        code: 'MSA',
        nameFr: 'M’saken',
        nameAr: 'مساكن',
        slug: 'msaken',
        postalCode: '4070',
        latitude: 35.7333,
        longitude: 10.5833,
      },
      {
        id: 'del-kalaa-kebira',
        governorateId: 'gov-sousse',
        code: 'KEB',
        nameFr: 'Kalâa Kebira',
        nameAr: 'القلعة الكبيرة',
        slug: 'kalaa-kebira',
        postalCode: '4060',
        latitude: 35.8667,
        longitude: 10.5333,
      },
    ],
  },
  {
    id: 'gov-monastir',
    code: 'MON',
    nameFr: 'Monastir',
    nameAr: 'المنستير',
    slug: 'monastir',
    latitude: 35.7779,
    longitude: 10.8261,
    sortOrder: 2,
    delegations: [
      {
        id: 'del-monastir-v',
        governorateId: 'gov-monastir',
        code: 'MON-V',
        nameFr: 'Monastir Ville',
        nameAr: 'المنستير المدينة',
        slug: 'monastir-ville',
        postalCode: '5000',
        latitude: 35.7779,
        longitude: 10.8261,
      },
      {
        id: 'del-sahline',
        governorateId: 'gov-monastir',
        code: 'SAH-M',
        nameFr: 'Sahline',
        nameAr: 'الساحلين',
        slug: 'sahline',
        postalCode: '5012',
        latitude: 35.75,
        longitude: 10.7167,
      },
      {
        id: 'del-ksar-hellal',
        governorateId: 'gov-monastir',
        code: 'KSA',
        nameFr: 'Ksar Hellal',
        nameAr: 'قصر هلال',
        slug: 'ksar-hellal',
        postalCode: '5016',
        latitude: 35.65,
        longitude: 10.8833,
      },
      {
        id: 'del-moknine',
        governorateId: 'gov-monastir',
        code: 'MOK',
        nameFr: 'Moknine',
        nameAr: 'مكنين',
        slug: 'moknine',
        postalCode: '5050',
        latitude: 35.6333,
        longitude: 10.9,
      },
    ],
  },
  {
    id: 'gov-mahdia',
    code: 'MAH',
    nameFr: 'Mahdia',
    nameAr: 'المهدية',
    slug: 'mahdia',
    latitude: 35.5047,
    longitude: 11.0622,
    sortOrder: 3,
    delegations: [
      {
        id: 'del-mahdia-v',
        governorateId: 'gov-mahdia',
        code: 'MAH-V',
        nameFr: 'Mahdia Ville',
        nameAr: 'المهدية المدينة',
        slug: 'mahdia-ville',
        postalCode: '5100',
        latitude: 35.5047,
        longitude: 11.0622,
      },
      {
        id: 'del-rejiche',
        governorateId: 'gov-mahdia',
        code: 'REJ',
        nameFr: 'Rejiche',
        nameAr: 'رجيش',
        slug: 'rejiche',
        postalCode: '5118',
        latitude: 35.4667,
        longitude: 11.05,
      },
      {
        id: 'del-el-djem',
        governorateId: 'gov-mahdia',
        code: 'DJEM',
        nameFr: 'El Djem',
        nameAr: 'الجم',
        slug: 'el-djem',
        postalCode: '5160',
        latitude: 35.3,
        longitude: 10.7167,
      },
    ],
  },
  {
    id: 'gov-tunis',
    code: 'TUN',
    nameFr: 'Tunis',
    nameAr: 'تونس',
    slug: 'tunis',
    latitude: 36.8065,
    longitude: 10.1815,
    sortOrder: 4,
    delegations: [
      {
        id: 'del-tunis-v',
        governorateId: 'gov-tunis',
        code: 'TUN-V',
        nameFr: 'Tunis Centre',
        nameAr: 'تونس المركز',
        slug: 'tunis-centre',
        postalCode: '1000',
        latitude: 36.8065,
        longitude: 10.1815,
      },
      {
        id: 'del-marsa',
        governorateId: 'gov-tunis',
        code: 'MAR',
        nameFr: 'La Marsa',
        nameAr: 'المرسى',
        slug: 'la-marsa',
        postalCode: '2070',
        latitude: 36.8764,
        longitude: 10.3253,
      },
      {
        id: 'del-carthage',
        governorateId: 'gov-tunis',
        code: 'CAR',
        nameFr: 'Carthage',
        nameAr: 'قرطاج',
        slug: 'carthage',
        postalCode: '2016',
        latitude: 36.8528,
        longitude: 10.3233,
      },
    ],
  },
  {
    id: 'gov-ariana',
    code: 'ARI',
    nameFr: 'Ariana',
    nameAr: 'أريانة',
    slug: 'ariana',
    latitude: 36.8625,
    longitude: 10.1956,
    sortOrder: 5,
    delegations: [
      {
        id: 'del-ariana-v',
        governorateId: 'gov-ariana',
        code: 'ARI-V',
        nameFr: 'Ariana Ville',
        nameAr: 'أريانة المدينة',
        slug: 'ariana-ville',
        postalCode: '2080',
        latitude: 36.8625,
        longitude: 10.1956,
      },
      {
        id: 'del-ennasr',
        governorateId: 'gov-ariana',
        code: 'NAS',
        nameFr: 'Ennasr',
        nameAr: 'النصر',
        slug: 'ennasr',
        postalCode: '2037',
        latitude: 36.8583,
        longitude: 10.1583,
      },
    ],
  },
  {
    id: 'gov-sfax',
    code: 'SFA',
    nameFr: 'Sfax',
    nameAr: 'صفاقس',
    slug: 'sfax',
    latitude: 34.7406,
    longitude: 10.7603,
    sortOrder: 6,
    delegations: [
      {
        id: 'del-sfax-v',
        governorateId: 'gov-sfax',
        code: 'SFA-V',
        nameFr: 'Sfax Ville',
        nameAr: 'صفاقس المدينة',
        slug: 'sfax-ville',
        postalCode: '3000',
        latitude: 34.7406,
        longitude: 10.7603,
      },
    ],
  },
];

export const DEMO_PROVIDERS: ProviderDetail[] = [
  {
    id: 'prov-1',
    slug: 'sami-mansour-electricite',
    businessName: 'Sami Mansour Électricité',
    headline: 'Électricien BTP & dépannage urgent 24/7 sur Sousse et environs',
    bio: 'Artisan diplômé avec plus de 12 ans d’expérience dans les installations électriques neuves, rénovations, tableaux différentiels et dépannages urgents. Intervention rapide, travail soigné et respect strict des normes de sécurité.',
    yearsExperience: 12,
    ratingAvg: 4.9,
    ratingCount: 28,
    isVerified: true,
    verifiedAt: '2026-01-15T10:00:00.000Z',
    acceptsEmergency: true,
    availabilityStatus: 'AVAILABLE',
    spokenLanguages: ['AR', 'FR'],
    baseGovernorateId: 'gov-sousse',
    baseGovernorateSlug: 'sousse',
    baseGovernorateNameFr: 'Sousse',
    baseGovernorateNameAr: 'سوسة',
    baseDelegationId: 'del-sousse-v',
    baseDelegationNameFr: 'Sousse Ville',
    baseDelegationNameAr: 'سوسة المدينة',
    primaryCategorySlug: 'electricite',
    primaryCategoryNameFr: 'Électricité',
    primaryCategoryNameAr: 'كهرباء',
    avatarUrl:
      'https://images.unsplash.com/photo-1540569014015-19a7be504e3a?auto=format&fit=crop&q=80&w=300',
    coverUrl:
      'https://images.unsplash.com/photo-1621905251189-08b45d6a269e?auto=format&fit=crop&q=80&w=1200',
    phone: '+21620654321',
    whatsappPhone: '+21620654321',
    categories: [DEMO_CATEGORIES[1]!],
    coverageAreas: ['Sousse Ville', 'Sahloul', 'Hammam Sousse', 'Port El Kantaoui', 'Kalaa Kebira'],
    offerings: [
      {
        id: 'off-1',
        titleFr: 'Dépannage panne de courant',
        titleAr: 'إصلاح عطل كهربائي طارئ',
        descriptionFr: 'Diagnostic complet et remise en service immédiate',
        descriptionAr: 'تشخيص فوري وإصلاح قواطع التيار',
        priceStartingAt: 35000,
        priceUnit: 'intervention',
      },
      {
        id: 'off-2',
        titleFr: 'Installation tableau électrique',
        titleAr: 'تركيب لوحة قواطع جديدة',
        descriptionFr: 'Pose tableau modulaire aux normes avec disjoncteurs',
        descriptionAr: 'تركيب صندوق حماية ومفاتيح تفاضلية',
        priceStartingAt: 120000,
        priceUnit: 'forfait',
      },
      {
        id: 'off-3',
        titleFr: 'Pose prises et luminaires',
        titleAr: 'تركيب مآخذ وإنارة LED',
        descriptionFr: 'Pose soignée pour maison ou local commercial',
        descriptionAr: 'تركيب سبوتات وثريات ومفاتيح إضاءة',
        priceStartingAt: 20000,
        priceUnit: 'point',
      },
    ],
    portfolio: [
      {
        id: 'img-1',
        url: 'https://images.unsplash.com/photo-1558494949-ef010cbdcc31?auto=format&fit=crop&q=80&w=800',
        caption: 'Rénovation tableau électrique villa Kantaoui',
      },
      {
        id: 'img-2',
        url: 'https://images.unsplash.com/photo-1563245372-f21724e3856d?auto=format&fit=crop&q=80&w=800',
        caption: 'Installation éclairage architectural Sousse',
      },
      {
        id: 'img-3',
        url: 'https://images.unsplash.com/photo-1581092160607-ee22621dd758?auto=format&fit=crop&q=80&w=800',
        caption: 'Câblage neuf appartement Sahloul',
      },
    ],
    reviews: [
      {
        id: 'rev-1',
        authorName: 'Mourad K.',
        rating: 5,
        comment:
          'Intervention un dimanche soir pour une panne générale à Sahloul. Arrivé en 30 minutes, problème résolu proprement. Très pro !',
        isVerifiedContact: true,
        createdAt: '2026-09-02T18:30:00.000Z',
      },
      {
        id: 'rev-2',
        authorName: 'Salma B.',
        rating: 5,
        comment:
          'A refait toute l’électricité de notre salon et cuisine. Travail irréprochable et conseils précieux pour économiser l’énergie.',
        isVerifiedContact: true,
        createdAt: '2026-08-25T11:15:00.000Z',
      },
      {
        id: 'rev-3',
        authorName: 'Karim F.',
        rating: 4,
        comment: 'Très bon artisan, ponctuel et honnête sur les tarifs. Je recommande vivement.',
        isVerifiedContact: true,
        createdAt: '2026-08-10T14:40:00.000Z',
      },
    ],
    completionScore: 95,
  },
  {
    id: 'prov-2',
    slug: 'hedi-bouazizi-plomberie',
    businessName: 'Hedi Bouazizi — Plomberie Express',
    headline: 'Spécialiste fuites, sanitaires et chauffe-eau sur tout le Sahel',
    bio: '15 ans d’expérience en plomberie générale, sanitaire et canalisation. Équipé d’une caméra thermique pour détection de fuite sans destruction. Disponibilité 7j/7 pour toutes urgences.',
    yearsExperience: 15,
    ratingAvg: 4.8,
    ratingCount: 34,
    isVerified: true,
    verifiedAt: '2026-02-01T09:00:00.000Z',
    acceptsEmergency: true,
    availabilityStatus: 'AVAILABLE',
    spokenLanguages: ['AR', 'FR'],
    baseGovernorateId: 'gov-sousse',
    baseGovernorateSlug: 'sousse',
    baseGovernorateNameFr: 'Sousse',
    baseGovernorateNameAr: 'سوسة',
    baseDelegationId: 'del-sahloul',
    baseDelegationNameFr: 'Sahloul',
    baseDelegationNameAr: 'سهلول',
    primaryCategorySlug: 'plomberie',
    primaryCategoryNameFr: 'Plomberie',
    primaryCategoryNameAr: 'سباكة',
    avatarUrl:
      'https://images.unsplash.com/photo-1507003211169-0a1dd7228f2d?auto=format&fit=crop&q=80&w=300',
    coverUrl:
      'https://images.unsplash.com/photo-1585704032915-c3400ca199e7?auto=format&fit=crop&q=80&w=1200',
    phone: '+21698765432',
    whatsappPhone: '+21698765432',
    categories: [DEMO_CATEGORIES[0]!],
    coverageAreas: ['Sahloul', 'Sousse Ville', 'Hammam Sousse', 'Akouda', 'Kantaoui', 'Monastir'],
    offerings: [
      {
        id: 'off-201',
        titleFr: 'Détection et réparation fuite d’eau',
        titleAr: 'كشف وإصلاح تسرب المياه',
        descriptionFr: 'Localisation précise et réparation garantie',
        descriptionAr: 'كشف دون تكسير وإصلاح فوري',
        priceStartingAt: 40000,
        priceUnit: 'intervention',
      },
      {
        id: 'off-202',
        titleFr: 'Débouchage canalisation express',
        titleAr: 'تسريح المجاري والمغاسل',
        descriptionFr: 'Furet mécanique et haute pression',
        descriptionAr: 'تسريح احترافي فعال وسريع',
        priceStartingAt: 45000,
        priceUnit: 'intervention',
      },
      {
        id: 'off-203',
        titleFr: 'Remplacement chauffe-eau',
        titleAr: 'تركيب وصيانة سخان الماء',
        descriptionFr: 'Installation et raccordement sécurisé',
        descriptionAr: 'تركيب سخان غاز أو كهرباء مع الضمان',
        priceStartingAt: 60000,
        priceUnit: 'forfait',
      },
    ],
    portfolio: [
      {
        id: 'img-201',
        url: 'https://images.unsplash.com/photo-1584622650111-993a426fbf0a?auto=format&fit=crop&q=80&w=800',
        caption: 'Rénovation salle d’eau moderne Sahloul',
      },
      {
        id: 'img-202',
        url: 'https://images.unsplash.com/photo-1607472586893-edb57bdc0e39?auto=format&fit=crop&q=80&w=800',
        caption: 'Réseau multicouche et collecteurs',
      },
    ],
    reviews: [
      {
        id: 'rev-201',
        authorName: 'Anis G.',
        rating: 5,
        comment:
          'Fuite sous carrelage détectée et réparée en 2 heures sans casser tout le salon. Chapeau l’artiste !',
        isVerifiedContact: true,
        createdAt: '2026-09-01T15:20:00.000Z',
      },
      {
        id: 'rev-202',
        authorName: 'Nadia M.',
        rating: 5,
        comment: 'Très professionnel et serviable, prix très honnête.',
        isVerifiedContact: true,
        createdAt: '2026-08-18T10:00:00.000Z',
      },
    ],
    completionScore: 90,
  },
  {
    id: 'prov-3',
    slug: 'karim-trabelsi-climatisation',
    businessName: 'Karim Trabelsi — Froid & Clim',
    headline: 'Installation, recharge et entretien climatiseurs réversibles',
    bio: 'Technicien frigoriste certifié. Vente, montage soigné et entretien préventif de climatiseurs split pour particuliers et bureaux à Monastir et Sousse.',
    yearsExperience: 8,
    ratingAvg: 4.7,
    ratingCount: 19,
    isVerified: true,
    verifiedAt: '2026-03-10T14:00:00.000Z',
    acceptsEmergency: false,
    availabilityStatus: 'AVAILABLE',
    spokenLanguages: ['AR', 'FR'],
    baseGovernorateId: 'gov-monastir',
    baseGovernorateSlug: 'monastir',
    baseGovernorateNameFr: 'Monastir',
    baseGovernorateNameAr: 'المنستير',
    baseDelegationId: 'del-monastir-v',
    baseDelegationNameFr: 'Monastir Ville',
    baseDelegationNameAr: 'المنستير المدينة',
    primaryCategorySlug: 'climatisation',
    primaryCategoryNameFr: 'Climatisation',
    primaryCategoryNameAr: 'تكييف وتبريد',
    avatarUrl:
      'https://images.unsplash.com/photo-1500648767791-00dcc994a43e?auto=format&fit=crop&q=80&w=300',
    coverUrl:
      'https://images.unsplash.com/photo-1621905252507-b35492cc74b4?auto=format&fit=crop&q=80&w=1200',
    phone: '+21622334455',
    whatsappPhone: '+21622334455',
    categories: [DEMO_CATEGORIES[2]!],
    coverageAreas: ['Monastir Ville', 'Sahline', 'Ksar Hellal', 'Sousse Ville'],
    offerings: [
      {
        id: 'off-301',
        titleFr: 'Installation climatiseur split',
        titleAr: 'تركيب مكيف سبليت',
        descriptionFr: 'Pose unité intérieure + extérieure et tirage au vide',
        descriptionAr: 'تركيب وتثبيت مع اختبار الضغط والغاز',
        priceStartingAt: 80000,
        priceUnit: 'unité',
      },
      {
        id: 'off-302',
        titleFr: 'Nettoyage et recharge gaz R410/R32',
        titleAr: 'تنظيف وشحن الغاز',
        descriptionFr: 'Désinfection filtres et appoint gaz frigorifique',
        descriptionAr: 'تنظيف شامل للوحدات وشحن الغاز',
        priceStartingAt: 55000,
        priceUnit: 'forfait',
      },
    ],
    portfolio: [
      {
        id: 'img-301',
        url: 'https://images.unsplash.com/photo-1599818499218-b36496e20779?auto=format&fit=crop&q=80&w=800',
        caption: 'Installation multi-split villa Monastir',
      },
    ],
    reviews: [
      {
        id: 'rev-301',
        authorName: 'Youssef B.',
        rating: 5,
        comment:
          'Deux climatiseurs installés chez moi, travail très propre, pas un grain de poussière laissé.',
        isVerifiedContact: true,
        createdAt: '2026-08-20T16:00:00.000Z',
      },
    ],
    completionScore: 85,
  },
  {
    id: 'prov-4',
    slug: 'yassine-riahi-serrurerie',
    businessName: 'Yassine Riahi — Serrurerie 24/7',
    headline: 'Dépannage serrurier express, ouverture porte et blindage',
    bio: 'Serrurier agréé intervenant en urgence jour et nuit sur le Grand Sousse. Portes claquées, serrures bloquées, clés cassées ou installation de serrures de haute sécurité multipoints.',
    yearsExperience: 14,
    ratingAvg: 5.0,
    ratingCount: 41,
    isVerified: true,
    verifiedAt: '2025-11-20T10:00:00.000Z',
    acceptsEmergency: true,
    availabilityStatus: 'AVAILABLE',
    spokenLanguages: ['AR', 'FR'],
    baseGovernorateId: 'gov-sousse',
    baseGovernorateSlug: 'sousse',
    baseGovernorateNameFr: 'Sousse',
    baseGovernorateNameAr: 'سوسة',
    baseDelegationId: 'del-sousse-v',
    baseDelegationNameFr: 'Sousse Ville',
    baseDelegationNameAr: 'سوسة المدينة',
    primaryCategorySlug: 'serrurerie',
    primaryCategoryNameFr: 'Serrurerie 24/7',
    primaryCategoryNameAr: 'أقفال ومفاتيح',
    avatarUrl:
      'https://images.unsplash.com/photo-1472099645785-5658abf4ff4e?auto=format&fit=crop&q=80&w=300',
    coverUrl:
      'https://images.unsplash.com/photo-1558002038-1055907df827?auto=format&fit=crop&q=80&w=1200',
    phone: '+21699887766',
    whatsappPhone: '+21699887766',
    categories: [DEMO_CATEGORIES[5]!],
    coverageAreas: [
      'Sousse Ville',
      'Sahloul',
      'Hammam Sousse',
      'Kantaoui',
      'Kalaa Kebira',
      'Msaken',
    ],
    offerings: [
      {
        id: 'off-401',
        titleFr: 'Ouverture de porte claquée',
        titleAr: 'فتح باب مغلق دون تكسير',
        descriptionFr: 'Ouverture fine sans dégât sur la serrure',
        descriptionAr: 'فتح سريع وآمن للباب دون إتلاف القفل',
        priceStartingAt: 50000,
        priceUnit: 'intervention',
      },
      {
        id: 'off-402',
        titleFr: 'Changement serrure de sécurité',
        titleAr: 'تغيير قلب القفل والأمان',
        descriptionFr: 'Cylindre haute sécurité avec 5 clés protégées',
        descriptionAr: 'تركيب قفل أمان جديد عالي الجودة',
        priceStartingAt: 75000,
        priceUnit: 'forfait',
      },
    ],
    portfolio: [
      {
        id: 'img-401',
        url: 'https://images.unsplash.com/photo-1558002038-1055907df827?auto=format&fit=crop&q=80&w=800',
        caption: 'Pose serrure 5 points certifiée',
      },
    ],
    reviews: [
      {
        id: 'rev-401',
        authorName: 'Tarek S.',
        rating: 5,
        comment:
          'Arrivé à 23h en 20 min à Hammam Sousse pour m’ouvrir la porte. Prix annoncé respecté. Sauveur !',
        isVerifiedContact: true,
        createdAt: '2026-09-03T23:45:00.000Z',
      },
    ],
    completionScore: 92,
  },
  {
    id: 'prov-5',
    slug: 'nader-ben-salah-peinture',
    businessName: 'Nader Déco & Peinture',
    headline: 'Travaux de peinture moderne, stucco et décoration d’intérieur',
    bio: 'Artisan peintre d’expérience. Travaux soignés pour appartements neufs et rénovation complète. Peinture mate, velours, stucco vénitien et papier peint haut de gamme.',
    yearsExperience: 10,
    ratingAvg: 4.9,
    ratingCount: 22,
    isVerified: true,
    verifiedAt: '2026-01-20T08:00:00.000Z',
    acceptsEmergency: false,
    availabilityStatus: 'AVAILABLE',
    spokenLanguages: ['AR', 'FR'],
    baseGovernorateId: 'gov-sousse',
    baseGovernorateSlug: 'sousse',
    baseGovernorateNameFr: 'Sousse',
    baseGovernorateNameAr: 'سوسة',
    baseDelegationId: 'del-hammam-sousse',
    baseDelegationNameFr: 'Hammam Sousse',
    baseDelegationNameAr: 'حمام سوسة',
    primaryCategorySlug: 'peinture',
    primaryCategoryNameFr: 'Peinture & Déco',
    primaryCategoryNameAr: 'دهان وديكور',
    avatarUrl:
      'https://images.unsplash.com/photo-1519085360753-af0119f7cbe7?auto=format&fit=crop&q=80&w=300',
    coverUrl:
      'https://images.unsplash.com/photo-1589939705384-5185137a7f0f?auto=format&fit=crop&q=80&w=1200',
    phone: '+21625441122',
    whatsappPhone: '+21625441122',
    categories: [DEMO_CATEGORIES[3]!],
    coverageAreas: ['Hammam Sousse', 'Kantaoui', 'Sousse Ville', 'Sahloul'],
    offerings: [
      {
        id: 'off-501',
        titleFr: 'Peinture chambre complète',
        titleAr: 'دهان غرفة كاملة بالألوان العصرية',
        descriptionFr: 'Enduit, ponçage et 2 couches peinture lessivable',
        descriptionAr: 'تهيئة الجدران والدهان بطبقتين فاخرتين',
        priceStartingAt: 150000,
        priceUnit: 'forfait',
      },
    ],
    portfolio: [
      {
        id: 'img-501',
        url: 'https://images.unsplash.com/photo-1589939705384-5185137a7f0f?auto=format&fit=crop&q=80&w=800',
        caption: 'Finition salon moderne Hammam Sousse',
      },
    ],
    reviews: [
      {
        id: 'rev-501',
        authorName: 'Leila D.',
        rating: 5,
        comment:
          'Chantier toujours propre et rendu magnifique ! Je recommande Nader les yeux fermés.',
        isVerifiedContact: true,
        createdAt: '2026-08-30T10:00:00.000Z',
      },
    ],
    completionScore: 88,
  },
  {
    id: 'prov-6',
    slug: 'mehdi-dridi-menuiserie',
    businessName: 'Atelier Dridi Aluminium & Bois',
    headline: 'Menuiserie aluminium, volets roulants et vitrerie sur Mahdia',
    bio: 'Fabrication et pose de fenêtres TPR, portes aluminium, vérandas et volets roulants motorisés. Conception sur mesure et devis rapide.',
    yearsExperience: 7,
    ratingAvg: 4.6,
    ratingCount: 14,
    isVerified: false,
    acceptsEmergency: false,
    availabilityStatus: 'AVAILABLE',
    spokenLanguages: ['AR', 'FR'],
    baseGovernorateId: 'gov-mahdia',
    baseGovernorateSlug: 'mahdia',
    baseGovernorateNameFr: 'Mahdia',
    baseGovernorateNameAr: 'المهدية',
    baseDelegationId: 'del-mahdia-v',
    baseDelegationNameFr: 'Mahdia Ville',
    baseDelegationNameAr: 'المهدية المدينة',
    primaryCategorySlug: 'menuiserie',
    primaryCategoryNameFr: 'Menuiserie & Alu',
    primaryCategoryNameAr: 'نجارة وألومنيوم',
    avatarUrl:
      'https://images.unsplash.com/photo-1506794778202-cad84cf45f1d?auto=format&fit=crop&q=80&w=300',
    coverUrl:
      'https://images.unsplash.com/photo-1533090161767-e6ffed986c88?auto=format&fit=crop&q=80&w=1200',
    phone: '+21694556677',
    whatsappPhone: '+21694556677',
    categories: [DEMO_CATEGORIES[4]!],
    coverageAreas: ['Mahdia Ville', 'Rejiche', 'Ksour Essef', 'El Djem'],
    offerings: [
      {
        id: 'off-601',
        titleFr: 'Fenêtre aluminium sur mesure',
        titleAr: 'نافذة ألومنيوم حسب المقاس',
        descriptionFr: 'Profilé TPR double vitrage avec pose',
        descriptionAr: 'ألومنيوم عازل للصوت والحرارة',
        priceStartingAt: 180000,
        priceUnit: 'm²',
      },
    ],
    portfolio: [
      {
        id: 'img-601',
        url: 'https://images.unsplash.com/photo-1533090161767-e6ffed986c88?auto=format&fit=crop&q=80&w=800',
        caption: 'Baie vitrée villa bord de mer Rejiche',
      },
    ],
    reviews: [
      {
        id: 'rev-601',
        authorName: 'Hassen T.',
        rating: 5,
        comment: 'Très bonne qualité d’aluminium et délais respectés.',
        isVerifiedContact: true,
        createdAt: '2026-08-15T12:00:00.000Z',
      },
    ],
    completionScore: 80,
  },
];
