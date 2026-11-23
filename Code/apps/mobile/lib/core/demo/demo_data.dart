// Données brutes et URLs d'exemples longues.
// ignore_for_file: lines_longer_than_80_chars

/// Jeux de données réalistes pour le Mode Démo tunisien.
///
/// Permet d'alimenter l'application complète sans serveur actif
/// tout en respectant fidèlement les contrats d'API OpenAPI.
class DemoData {
  DemoData._();

  static const categories = <String, dynamic>{
    'categories': [
      {
        'id': 'cat-electricite',
        'slug': 'electricite',
        'nameFr': 'Électricité',
        'nameAr': 'كهرباء',
        'descriptionFr':
            'Installation, dépannage électrique, tableaux et éclairage',
        'descriptionAr': 'تركيب وصيانة الكهرباء واللوحات والإنارة',
        'iconKey': 'bolt',
        'colorHex': '#EAB308',
        'sortOrder': 1,
        'children': <dynamic>[],
      },
      {
        'id': 'cat-plomberie',
        'slug': 'plomberie',
        'nameFr': 'Plomberie',
        'nameAr': 'سباكة',
        'descriptionFr':
            'Réparation de fuites, robinetterie, chauffe-eau et sanitaires',
        'descriptionAr': 'إصلاح التسريبات والحنفيات وسخانات المياه',
        'iconKey': 'plumbing',
        'colorHex': '#0284C7',
        'sortOrder': 2,
        'children': <dynamic>[],
      },
      {
        'id': 'cat-peinture',
        'slug': 'peinture',
        'nameFr': 'Peinture',
        'nameAr': 'دهانة',
        'descriptionFr':
            'Peinture intérieure, extérieure, décoration et enduit',
        'descriptionAr': 'دهانة داخلية وخارجية وديكور ومعجون',
        'iconKey': 'format_paint',
        'colorHex': '#EC4899',
        'sortOrder': 3,
        'children': <dynamic>[],
      },
      {
        'id': 'cat-menuiserie',
        'slug': 'menuiserie',
        'nameFr': 'Menuiserie',
        'nameAr': 'نجارة',
        'descriptionFr':
            'Menuiserie bois, aluminium, portes, fenêtres et meubles',
        'descriptionAr': 'نجارة خشب وألمنيوم وأبواب ونوافذ وأثاث',
        'iconKey': 'carpenter',
        'colorHex': '#8B5CF6',
        'sortOrder': 4,
        'children': <dynamic>[],
      },
      {
        'id': 'cat-climatisation',
        'slug': 'climatisation',
        'nameFr': 'Climatisation',
        'nameAr': 'مكيفات',
        'descriptionFr': 'Installation, recharge gaz, entretien et nettoyage',
        'descriptionAr': 'تركيب وشحن غاز وصيانة وتنظيف مكيفات',
        'iconKey': 'ac_unit',
        'colorHex': '#06B6D4',
        'sortOrder': 5,
        'children': <dynamic>[],
      },
      {
        'id': 'cat-serrurerie',
        'slug': 'serrurerie',
        'nameFr': 'Serrurerie',
        'nameAr': 'أقفال',
        'descriptionFr':
            'Ouverture de porte, changement de serrure et blindage',
        'descriptionAr': 'فتح الأبواب وتغيير الأقفال وتأمين الأبواب',
        'iconKey': 'lock',
        'colorHex': '#F97316',
        'sortOrder': 6,
        'children': <dynamic>[],
      },
    ],
  };

  static const governorates = <String, dynamic>{
    'governorates': [
      {
        'id': 'gov-tunis',
        'code': 'TUN',
        'nameFr': 'Tunis',
        'nameAr': 'تونس',
        'slug': 'tunis',
        'latitude': 36.8065,
        'longitude': 10.1815,
        'sortOrder': 1,
        'delegations': [
          {
            'id': 'del-marsa',
            'governorateId': 'gov-tunis',
            'code': 'MAR',
            'nameFr': 'La Marsa',
            'nameAr': 'المرسى',
            'slug': 'la-marsa',
            'postalCode': '2070',
            'latitude': 36.8782,
            'longitude': 10.3247,
          },
          {
            'id': 'del-carthage',
            'governorateId': 'gov-tunis',
            'code': 'CAR',
            'nameFr': 'Carthage',
            'nameAr': 'قرطاج',
            'slug': 'carthage',
            'postalCode': '2016',
            'latitude': 36.8528,
            'longitude': 10.3233,
          },
          {
            'id': 'del-menzah',
            'governorateId': 'gov-tunis',
            'code': 'MEN',
            'nameFr': 'El Menzah',
            'nameAr': 'المنزه',
            'slug': 'el-menzah',
            'postalCode': '1004',
            'latitude': 36.8378,
            'longitude': 10.1789,
          },
        ],
      },
      {
        'id': 'gov-sousse',
        'code': 'SOU',
        'nameFr': 'Sousse',
        'nameAr': 'سوسة',
        'slug': 'sousse',
        'latitude': 35.8256,
        'longitude': 10.6084,
        'sortOrder': 2,
        'delegations': [
          {
            'id': 'del-sousse-v',
            'governorateId': 'gov-sousse',
            'code': 'SOU-V',
            'nameFr': 'Sousse Ville',
            'nameAr': 'سوسة المدينة',
            'slug': 'sousse-ville',
            'postalCode': '4000',
            'latitude': 35.8256,
            'longitude': 10.6084,
          },
          {
            'id': 'del-kantaoui',
            'governorateId': 'gov-sousse',
            'code': 'KAN',
            'nameFr': 'Hammam Sousse',
            'nameAr': 'حمام سوسة',
            'slug': 'hammam-sousse',
            'postalCode': '4011',
            'latitude': 35.8583,
            'longitude': 10.5936,
          },
          {
            'id': 'del-sahloul',
            'governorateId': 'gov-sousse',
            'code': 'SAH',
            'nameFr': 'Sahloul',
            'nameAr': 'سهلول',
            'slug': 'sahloul',
            'postalCode': '4054',
            'latitude': 35.8394,
            'longitude': 10.5989,
          },
        ],
      },
      {
        'id': 'gov-ariana',
        'code': 'ARI',
        'nameFr': 'Ariana',
        'nameAr': 'أريانة',
        'slug': 'ariana',
        'latitude': 36.8625,
        'longitude': 10.1956,
        'sortOrder': 3,
        'delegations': [
          {
            'id': 'del-ariana-v',
            'governorateId': 'gov-ariana',
            'code': 'ARI-V',
            'nameFr': 'Ariana Ville',
            'nameAr': 'أريانة المدينة',
            'slug': 'ariana-ville',
            'postalCode': '2080',
            'latitude': 36.8625,
            'longitude': 10.1956,
          },
          {
            'id': 'del-ennasr',
            'governorateId': 'gov-ariana',
            'code': 'NAS',
            'nameFr': 'Ennasr',
            'nameAr': 'النصر',
            'slug': 'ennasr',
            'postalCode': '2037',
            'latitude': 36.8583,
            'longitude': 10.1583,
          },
          {
            'id': 'del-raoued',
            'governorateId': 'gov-ariana',
            'code': 'RAO',
            'nameFr': 'Raoued',
            'nameAr': 'رواد',
            'slug': 'raoued',
            'postalCode': '2056',
            'latitude': 36.9200,
            'longitude': 10.1800,
          },
        ],
      },
      {
        'id': 'gov-sfax',
        'code': 'SFA',
        'nameFr': 'Sfax',
        'nameAr': 'صفاقس',
        'slug': 'sfax',
        'latitude': 34.7406,
        'longitude': 10.7603,
        'sortOrder': 4,
        'delegations': [
          {
            'id': 'del-sfax-v',
            'governorateId': 'gov-sfax',
            'code': 'SFA-V',
            'nameFr': 'Sfax Ville',
            'nameAr': 'صفاقس المدينة',
            'slug': 'sfax-ville',
            'postalCode': '3000',
            'latitude': 34.7406,
            'longitude': 10.7603,
          },
          {
            'id': 'del-sakiet',
            'governorateId': 'gov-sfax',
            'code': 'SAK',
            'nameFr': 'Sakiet Ezzit',
            'nameAr': 'ساقية الزيت',
            'slug': 'sakiet-ezzit',
            'postalCode': '3021',
            'latitude': 34.7950,
            'longitude': 10.7725,
          },
        ],
      },
      {
        'id': 'gov-ben-arous',
        'code': 'BEN',
        'nameFr': 'Ben Arous',
        'nameAr': 'بن عروس',
        'slug': 'ben-arous',
        'latitude': 36.7531,
        'longitude': 10.2189,
        'sortOrder': 5,
        'delegations': [
          {
            'id': 'del-megrine',
            'governorateId': 'gov-ben-arous',
            'code': 'MEG',
            'nameFr': 'Mégrine',
            'nameAr': 'مقرين',
            'slug': 'megrine',
            'postalCode': '2033',
            'latitude': 36.7681,
            'longitude': 10.2369,
          },
          {
            'id': 'del-rades',
            'governorateId': 'gov-ben-arous',
            'code': 'RAD',
            'nameFr': 'Radès',
            'nameAr': 'رادس',
            'slug': 'rades',
            'postalCode': '2040',
            'latitude': 36.7681,
            'longitude': 10.2750,
          },
        ],
      },
    ],
  };

  static final List<Map<String, dynamic>> providersList = [
    {
      'id': 'prov-1',
      'slug': 'sami-mansour-electricite',
      'businessName': 'Sami Mansour',
      'headline': 'Électricien qualifié BTP & dépannage urgent 24/7',
      'bio':
          'Plus de 12 ans d’expérience dans les installations électriques neuves, rénovations complètes et dépannages urgents sur le grand Sousse. Devis gratuit et intervention rapide.',
      'yearsExperience': 12,
      'spokenLanguages': ['AR', 'FR'],
      'baseGovernorate': {
        'id': 'gov-sousse',
        'code': 'SOU',
        'nameFr': 'Sousse',
        'nameAr': 'سوسة',
      },
      'baseDelegation': {
        'id': 'del-sousse-v',
        'nameFr': 'Sousse Ville',
        'nameAr': 'سوسة المدينة',
      },
      'latitude': 35.8256,
      'longitude': 10.63699,
      'isVerified': true,
      'availabilityStatus': 'AVAILABLE',
      'availableAgainAt': null,
      'acceptsEmergency': true,
      'completionScore': 90,
      'ratingAvg': 4.9,
      'ratingCount': 32,
      'categories': [
        {
          'id': 'cat-electricite',
          'slug': 'electricite',
          'nameFr': 'Électricité',
          'nameAr': 'كهرباء',
          'isPrimary': true,
        },
      ],
      'coverageAreas': [
        {
          'id': 'cov-1',
          'governorateId': 'gov-sousse',
          'governorateNameFr': 'Sousse',
          'governorateNameAr': 'سوسة',
          'delegationId': null,
        },
      ],
      'gallery': [
        {
          'id': 'img-1',
          'url':
              'https://images.unsplash.com/photo-1621905251189-08b45d6a269e?auto=format&fit=crop&w=800&q=80',
          'caption': 'Tableau électrique aux normes',
          'sortOrder': 0,
        },
        {
          'id': 'img-2',
          'url':
              'https://images.unsplash.com/photo-1558494949-ef010cbdcc31?auto=format&fit=crop&w=800&q=80',
          'caption': 'Éclairage LED salon contemporain',
          'sortOrder': 1,
        },
      ],
      'reviewAggregate': {
        'average': 4.9,
        'count': 32,
      },
      'offerings': <dynamic>[],
    },
    {
      'id': 'prov-2',
      'slug': 'hedi-bouazizi-plomberie',
      'businessName': 'Hedi Bouazizi',
      'headline': 'Plombier sanitaire & installation chauffe-eau',
      'bio':
          'Artisan plombier expérimenté intervenant sur Tunis et la banlieue Nord. Spécialiste recherche de fuites d’eau non destructive, débouchage et installation sanitaires.',
      'yearsExperience': 15,
      'spokenLanguages': ['AR', 'FR'],
      'baseGovernorate': {
        'id': 'gov-tunis',
        'code': 'TUN',
        'nameFr': 'Tunis',
        'nameAr': 'تونس',
      },
      'baseDelegation': {
        'id': 'del-marsa',
        'nameFr': 'La Marsa',
        'nameAr': 'المرسى',
      },
      'latitude': 36.8783,
      'longitude': 10.3247,
      'isVerified': true,
      'availabilityStatus': 'AVAILABLE',
      'availableAgainAt': null,
      'acceptsEmergency': true,
      'completionScore': 85,
      'ratingAvg': 4.8,
      'ratingCount': 19,
      'categories': [
        {
          'id': 'cat-plomberie',
          'slug': 'plomberie',
          'nameFr': 'Plomberie',
          'nameAr': 'سباكة',
          'isPrimary': true,
        },
      ],
      'coverageAreas': [
        {
          'id': 'cov-2',
          'governorateId': 'gov-tunis',
          'governorateNameFr': 'Tunis',
          'governorateNameAr': 'تونس',
          'delegationId': null,
        },
      ],
      'gallery': [
        {
          'id': 'img-3',
          'url':
              'https://images.unsplash.com/photo-1584622650111-993a426fbf0a?auto=format&fit=crop&w=800&q=80',
          'caption': 'Rénovation salle de bain moderne',
          'sortOrder': 0,
        },
      ],
      'reviewAggregate': {
        'average': 4.8,
        'count': 19,
      },
      'offerings': <dynamic>[],
    },
    {
      'id': 'prov-3',
      'slug': 'tarek-gharbi-peinture',
      'businessName': 'Tarek Gharbi',
      'headline': 'Peintre en bâtiment & décoration stucco / starlike',
      'bio':
          'Travaux soignés de peinture intérieure et extérieure, pose d’enduit et revêtements muraux décoratifs sur le Sahel tunisien. Finition propre et respect des délais.',
      'yearsExperience': 9,
      'spokenLanguages': ['AR', 'FR'],
      'baseGovernorate': {
        'id': 'gov-sousse',
        'code': 'SOU',
        'nameFr': 'Sousse',
        'nameAr': 'سوسة',
      },
      'baseDelegation': {
        'id': 'del-kantaoui',
        'nameFr': 'Hammam Sousse',
        'nameAr': 'حمام سوسة',
      },
      'latitude': 35.8599,
      'longitude': 10.5987,
      'isVerified': true,
      'availabilityStatus': 'AVAILABLE',
      'availableAgainAt': null,
      'acceptsEmergency': false,
      'completionScore': 80,
      'ratingAvg': 4.9,
      'ratingCount': 27,
      'categories': [
        {
          'id': 'cat-peinture',
          'slug': 'peinture',
          'nameFr': 'Peinture',
          'nameAr': 'دهانة',
          'isPrimary': true,
        },
      ],
      'coverageAreas': [
        {
          'id': 'cov-3',
          'governorateId': 'gov-sousse',
          'governorateNameFr': 'Sousse',
          'governorateNameAr': 'سوسة',
          'delegationId': null,
        },
      ],
      'gallery': <dynamic>[],
      'reviewAggregate': {
        'average': 4.9,
        'count': 27,
      },
      'offerings': <dynamic>[],
    },
    {
      'id': 'prov-4',
      'slug': 'kamel-ben-salah-menuiserie',
      'businessName': 'Kamel Ben Salah',
      'headline': 'Menuiserie aluminium & PVC, stores et dressings',
      'bio':
          'Atelier artisanal de menuiserie aluminium et agencement intérieur à l’Ariana. Réalisation sur mesure de portes, fenêtres double vitrage et volets roulants.',
      'yearsExperience': 20,
      'spokenLanguages': ['AR', 'FR'],
      'baseGovernorate': {
        'id': 'gov-ariana',
        'code': 'ARI',
        'nameFr': 'Ariana',
        'nameAr': 'أريانة',
      },
      'baseDelegation': {
        'id': 'del-ennasr',
        'nameFr': 'Ennasr',
        'nameAr': 'النصر',
      },
      'latitude': 36.8665,
      'longitude': 10.1647,
      'isVerified': false,
      'availabilityStatus': 'BUSY',
      'availableAgainAt': null,
      'acceptsEmergency': false,
      'completionScore': 75,
      'ratingAvg': 4.7,
      'ratingCount': 14,
      'categories': [
        {
          'id': 'cat-menuiserie',
          'slug': 'menuiserie',
          'nameFr': 'Menuiserie',
          'nameAr': 'نجارة',
          'isPrimary': true,
        },
      ],
      'coverageAreas': [
        {
          'id': 'cov-4',
          'governorateId': 'gov-ariana',
          'governorateNameFr': 'Ariana',
          'governorateNameAr': 'أريانة',
          'delegationId': null,
        },
      ],
      'gallery': <dynamic>[],
      'reviewAggregate': {
        'average': 4.7,
        'count': 14,
      },
      'offerings': <dynamic>[],
    },
    {
      'id': 'prov-5',
      'slug': 'nabil-dridi-climatisation',
      'businessName': 'Nabil Dridi',
      'headline': 'Technicien frigoriste & entretien climatiseurs',
      'bio':
          'Installation toutes marques de climatiseurs split et multi-split. Recharge fréon R410/R32, détection de fuite et désinfection complète.',
      'yearsExperience': 8,
      'spokenLanguages': ['AR', 'FR'],
      'baseGovernorate': {
        'id': 'gov-sfax',
        'code': 'SFA',
        'nameFr': 'Sfax',
        'nameAr': 'صفاقس',
      },
      'baseDelegation': {
        'id': 'del-sfax-v',
        'nameFr': 'Sfax Ville',
        'nameAr': 'صفاقس المدينة',
      },
      'latitude': 34.7406,
      'longitude': 10.7603,
      'isVerified': false,
      'availabilityStatus': 'AVAILABLE',
      'availableAgainAt': null,
      'acceptsEmergency': true,
      'completionScore': 70,
      'ratingAvg': 4.6,
      'ratingCount': 11,
      'categories': [
        {
          'id': 'cat-climatisation',
          'slug': 'climatisation',
          'nameFr': 'Climatisation',
          'nameAr': 'مكيفات',
          'isPrimary': true,
        },
      ],
      'coverageAreas': [
        {
          'id': 'cov-5',
          'governorateId': 'gov-sfax',
          'governorateNameFr': 'Sfax',
          'governorateNameAr': 'صفاقس',
          'delegationId': null,
        },
      ],
      'gallery': <dynamic>[],
      'reviewAggregate': {
        'average': 4.6,
        'count': 11,
      },
      'offerings': <dynamic>[],
    },
    {
      'id': 'prov-6',
      'slug': 'yassine-riahi-serrurerie',
      'businessName': 'Yassine Riahi',
      'headline': 'Serrurier dépanneur express 24h/24 & blindage',
      'bio':
          'Dépannage d’urgence serrure bloquée, clé cassée et blindage de porte sur Ben Arous et Grand Tunis. Arrivée sur place en 30 minutes garanti.',
      'yearsExperience': 11,
      'spokenLanguages': ['AR', 'FR'],
      'baseGovernorate': {
        'id': 'gov-ben-arous',
        'code': 'BEN',
        'nameFr': 'Ben Arous',
        'nameAr': 'بن عروس',
      },
      'baseDelegation': {
        'id': 'del-rades',
        'nameFr': 'Radès',
        'nameAr': 'رادس',
      },
      'latitude': 36.7681,
      'longitude': 10.2753,
      'isVerified': true,
      'availabilityStatus': 'AVAILABLE',
      'availableAgainAt': null,
      'acceptsEmergency': true,
      'completionScore': 88,
      'ratingAvg': 5.0,
      'ratingCount': 8,
      'categories': [
        {
          'id': 'cat-serrurerie',
          'slug': 'serrurerie',
          'nameFr': 'Serrurerie',
          'nameAr': 'أقفال',
          'isPrimary': true,
        },
      ],
      'coverageAreas': [
        {
          'id': 'cov-6',
          'governorateId': 'gov-ben-arous',
          'governorateNameFr': 'Ben Arous',
          'governorateNameAr': 'بن عروس',
          'delegationId': null,
        },
      ],
      'gallery': <dynamic>[],
      'reviewAggregate': {
        'average': 5.0,
        'count': 8,
      },
      'offerings': <dynamic>[],
    },
    // === Électricité (prov-7 à prov-10) ===
    {
      'id': 'prov-7',
      'slug': 'karim-ben-amor-electricite',
      'businessName': 'Karim Ben Amor',
      'headline': 'Artisan électricien villa & domotique',
      'bio':
          'Installation électrique générale, tableaux de distribution, éclairage d’ambiance LED et domotique pour villas et appartements sur le Grand Tunis. Devis sous 24h et garantie décennale.',
      'yearsExperience': 10,
      'spokenLanguages': ['AR', 'FR'],
      'baseGovernorate': {
        'id': 'gov-tunis',
        'code': 'TUN',
        'nameFr': 'Tunis',
        'nameAr': 'تونس',
      },
      'baseDelegation': {
        'id': 'del-marsa',
        'nameFr': 'La Marsa',
        'nameAr': 'المرسى',
      },
      'latitude': 36.8782,
      'longitude': 10.3247,
      'isVerified': true,
      'availabilityStatus': 'AVAILABLE',
      'availableAgainAt': null,
      'acceptsEmergency': true,
      'completionScore': 92,
      'ratingAvg': 4.8,
      'ratingCount': 27,
      'categories': [
        {
          'id': 'cat-electricite',
          'slug': 'electricite',
          'nameFr': 'Électricité',
          'nameAr': 'كهرباء',
          'isPrimary': true,
        },
      ],
      'coverageAreas': [
        {
          'id': 'cov-7',
          'governorateId': 'gov-tunis',
          'governorateNameFr': 'Tunis',
          'governorateNameAr': 'تونس',
          'delegationId': null,
        },
      ],
      'gallery': [
        {
          'id': 'img-7a',
          'url':
              'https://images.unsplash.com/photo-1544725176-7c40e5a71c5e?auto=format&fit=crop&w=800&q=80',
          'caption': 'Éclairage architectural villa',
          'sortOrder': 0,
        },
      ],
      'reviewAggregate': {'average': 4.8, 'count': 27},
      'offerings': <dynamic>[],
    },
    {
      'id': 'prov-8',
      'slug': 'walid-chaabane-electricite',
      'businessName': 'Walid Chaabane',
      'headline': 'Électricité générale & automatismes de portail',
      'bio':
          'Spécialiste de la rénovation électrique, pose de tableaux modulaires, motorisation de portails et interphones à l’Ariana. Travail soigné et dépannage rapide.',
      'yearsExperience': 8,
      'spokenLanguages': ['AR', 'FR'],
      'baseGovernorate': {
        'id': 'gov-ariana',
        'code': 'ARI',
        'nameFr': 'Ariana',
        'nameAr': 'أريانة',
      },
      'baseDelegation': {
        'id': 'del-ennasr',
        'nameFr': 'Ennasr',
        'nameAr': 'النصر',
      },
      'latitude': 36.8665,
      'longitude': 10.1647,
      'isVerified': true,
      'availabilityStatus': 'AVAILABLE',
      'availableAgainAt': null,
      'acceptsEmergency': false,
      'completionScore': 85,
      'ratingAvg': 4.7,
      'ratingCount': 18,
      'categories': [
        {
          'id': 'cat-electricite',
          'slug': 'electricite',
          'nameFr': 'Électricité',
          'nameAr': 'كهرباء',
          'isPrimary': true,
        },
      ],
      'coverageAreas': [
        {
          'id': 'cov-8',
          'governorateId': 'gov-ariana',
          'governorateNameFr': 'Ariana',
          'governorateNameAr': 'أريانة',
          'delegationId': null,
        },
      ],
      'gallery': <dynamic>[],
      'reviewAggregate': {'average': 4.7, 'count': 18},
      'offerings': <dynamic>[],
    },
    {
      'id': 'prov-9',
      'slug': 'bilel-rekik-electricite',
      'businessName': 'Bilel Rekik',
      'headline': 'Expert installations solaires & réseaux BTP',
      'bio':
          'Ingénieur-technicien en génie électrique, 16 ans d’expérience à Sfax. Étude et installation de panneaux photovoltaïques, groupes électrogènes et mise en conformité.',
      'yearsExperience': 16,
      'spokenLanguages': ['AR', 'FR'],
      'baseGovernorate': {
        'id': 'gov-sfax',
        'code': 'SFA',
        'nameFr': 'Sfax',
        'nameAr': 'صفاقس',
      },
      'baseDelegation': {
        'id': 'del-sakiet-ezzit',
        'nameFr': 'Sakiet Ezzit',
        'nameAr': 'ساقية الزيت',
      },
      'latitude': 34.7950,
      'longitude': 10.7710,
      'isVerified': true,
      'availabilityStatus': 'AVAILABLE',
      'availableAgainAt': null,
      'acceptsEmergency': true,
      'completionScore': 95,
      'ratingAvg': 4.9,
      'ratingCount': 41,
      'categories': [
        {
          'id': 'cat-electricite',
          'slug': 'electricite',
          'nameFr': 'Électricité',
          'nameAr': 'كهرباء',
          'isPrimary': true,
        },
      ],
      'coverageAreas': [
        {
          'id': 'cov-9',
          'governorateId': 'gov-sfax',
          'governorateNameFr': 'Sfax',
          'governorateNameAr': 'صفاقس',
          'delegationId': null,
        },
      ],
      'gallery': <dynamic>[],
      'reviewAggregate': {'average': 4.9, 'count': 41},
      'offerings': <dynamic>[],
    },
    {
      'id': 'prov-10',
      'slug': 'chokri-ghrab-electricite',
      'businessName': 'Chokri Ghrab',
      'headline': 'Électricien bâtiment & câblage réseau',
      'bio':
          'Interventions rapides sur le gouvernorat de Monastir. Câblage électrique neuf, coffrets de protection, luminaires LED et détection incendie.',
      'yearsExperience': 7,
      'spokenLanguages': ['AR', 'FR'],
      'baseGovernorate': {
        'id': 'gov-monastir',
        'code': 'MON',
        'nameFr': 'Monastir',
        'nameAr': 'المنستير',
      },
      'baseDelegation': {
        'id': 'del-ksar-hellal',
        'nameFr': 'Ksar Hellal',
        'nameAr': 'قصر هلال',
      },
      'latitude': 35.6480,
      'longitude': 10.8920,
      'isVerified': false,
      'availabilityStatus': 'AVAILABLE',
      'availableAgainAt': null,
      'acceptsEmergency': false,
      'completionScore': 78,
      'ratingAvg': 4.6,
      'ratingCount': 15,
      'categories': [
        {
          'id': 'cat-electricite',
          'slug': 'electricite',
          'nameFr': 'Électricité',
          'nameAr': 'كهرباء',
          'isPrimary': true,
        },
      ],
      'coverageAreas': [
        {
          'id': 'cov-10',
          'governorateId': 'gov-monastir',
          'governorateNameFr': 'Monastir',
          'governorateNameAr': 'المنستير',
          'delegationId': null,
        },
      ],
      'gallery': <dynamic>[],
      'reviewAggregate': {'average': 4.6, 'count': 15},
      'offerings': <dynamic>[],
    },
    // === Plomberie (prov-11 à prov-14) ===
    {
      'id': 'prov-11',
      'slug': 'mohamed-trabelsi-plomberie',
      'businessName': 'Mohamed Trabelsi',
      'headline': 'Maître artisan plombier & détection fuites par caméra',
      'bio':
          'Plus de 14 ans de métier dans le Sahel. Recherche de fuite d’eau sans destruction, débouchage haute pression et rénovation de plomberie sanitaire.',
      'yearsExperience': 14,
      'spokenLanguages': ['AR', 'FR'],
      'baseGovernorate': {
        'id': 'gov-sousse',
        'code': 'SOU',
        'nameFr': 'Sousse',
        'nameAr': 'سوسة',
      },
      'baseDelegation': {
        'id': 'del-kantaoui',
        'nameFr': 'Hammam Sousse',
        'nameAr': 'حمام سوسة',
      },
      'latitude': 35.8583,
      'longitude': 10.5936,
      'isVerified': true,
      'availabilityStatus': 'AVAILABLE',
      'availableAgainAt': null,
      'acceptsEmergency': true,
      'completionScore': 94,
      'ratingAvg': 4.9,
      'ratingCount': 38,
      'categories': [
        {
          'id': 'cat-plomberie',
          'slug': 'plomberie',
          'nameFr': 'Plomberie',
          'nameAr': 'سباكة',
          'isPrimary': true,
        },
      ],
      'coverageAreas': [
        {
          'id': 'cov-11',
          'governorateId': 'gov-sousse',
          'governorateNameFr': 'Sousse',
          'governorateNameAr': 'سوسة',
          'delegationId': null,
        },
      ],
      'gallery': [
        {
          'id': 'img-11a',
          'url':
              'https://images.unsplash.com/photo-1584622650111-993a426fbf0a?auto=format&fit=crop&w=800&q=80',
          'caption': 'Rénovation tuyauterie et sanitaires',
          'sortOrder': 0,
        },
      ],
      'reviewAggregate': {'average': 4.9, 'count': 38},
      'offerings': <dynamic>[],
    },
    {
      'id': 'prov-12',
      'slug': 'zied-hamdi-plomberie',
      'businessName': 'Zied Hamdi',
      'headline': 'Plombier chauffagiste & adoucisseurs d’eau',
      'bio':
          'Installation de chauffe-eau gaz et solaires, traitement calcaire, adoucisseurs et robinetterie moderne à La Soukra et banlieue nord de Tunis.',
      'yearsExperience': 9,
      'spokenLanguages': ['AR', 'FR'],
      'baseGovernorate': {
        'id': 'gov-ariana',
        'code': 'ARI',
        'nameFr': 'Ariana',
        'nameAr': 'أريانة',
      },
      'baseDelegation': {
        'id': 'del-soukra',
        'nameFr': 'La Soukra',
        'nameAr': 'سكرة',
      },
      'latitude': 36.8850,
      'longitude': 10.2550,
      'isVerified': true,
      'availabilityStatus': 'AVAILABLE',
      'availableAgainAt': null,
      'acceptsEmergency': false,
      'completionScore': 86,
      'ratingAvg': 4.7,
      'ratingCount': 22,
      'categories': [
        {
          'id': 'cat-plomberie',
          'slug': 'plomberie',
          'nameFr': 'Plomberie',
          'nameAr': 'سباكة',
          'isPrimary': true,
        },
      ],
      'coverageAreas': [
        {
          'id': 'cov-12',
          'governorateId': 'gov-ariana',
          'governorateNameFr': 'Ariana',
          'governorateNameAr': 'أريانة',
          'delegationId': null,
        },
      ],
      'gallery': <dynamic>[],
      'reviewAggregate': {'average': 4.7, 'count': 22},
      'offerings': <dynamic>[],
    },
    {
      'id': 'prov-13',
      'slug': 'anis-ben-romdhane-plomberie',
      'businessName': 'Anis Ben Romdhane',
      'headline': 'Dépannage plomberie express 24/7 & sanitaires',
      'bio':
          'Dépannage d’urgence fuite d’eau, siphon bouché, remplacement de chauffe-eau électrique et robinetterie sur Ben Arous et banlieue sud.',
      'yearsExperience': 11,
      'spokenLanguages': ['AR', 'FR'],
      'baseGovernorate': {
        'id': 'gov-ben-arous',
        'code': 'BEN',
        'nameFr': 'Ben Arous',
        'nameAr': 'بن عروس',
      },
      'baseDelegation': {
        'id': 'del-megrine',
        'nameFr': 'Mégrine',
        'nameAr': 'مقرين',
      },
      'latitude': 36.7681,
      'longitude': 10.2369,
      'isVerified': true,
      'availabilityStatus': 'AVAILABLE',
      'availableAgainAt': null,
      'acceptsEmergency': true,
      'completionScore': 89,
      'ratingAvg': 4.8,
      'ratingCount': 16,
      'categories': [
        {
          'id': 'cat-plomberie',
          'slug': 'plomberie',
          'nameFr': 'Plomberie',
          'nameAr': 'سباكة',
          'isPrimary': true,
        },
      ],
      'coverageAreas': [
        {
          'id': 'cov-13',
          'governorateId': 'gov-ben-arous',
          'governorateNameFr': 'Ben Arous',
          'governorateNameAr': 'بن عروس',
          'delegationId': null,
        },
      ],
      'gallery': <dynamic>[],
      'reviewAggregate': {'average': 4.8, 'count': 16},
      'offerings': <dynamic>[],
    },
    {
      'id': 'prov-14',
      'slug': 'lotfi-karray-plomberie',
      'businessName': 'Lotfi Karray',
      'headline': 'Plombier assainissement & réseaux sous-sol',
      'bio':
          'Artisan de confiance à Sfax avec 18 ans de métier. Raccordement tout-à-l’égout, fosses septiques, pompes de relevage et tuyauterie cuivre et multicouche.',
      'yearsExperience': 18,
      'spokenLanguages': ['AR', 'FR'],
      'baseGovernorate': {
        'id': 'gov-sfax',
        'code': 'SFA',
        'nameFr': 'Sfax',
        'nameAr': 'صفاقس',
      },
      'baseDelegation': {
        'id': 'del-sfax-v',
        'nameFr': 'Sfax Ville',
        'nameAr': 'صفاقس المدينة',
      },
      'latitude': 34.7406,
      'longitude': 10.7603,
      'isVerified': false,
      'availabilityStatus': 'AVAILABLE',
      'availableAgainAt': null,
      'acceptsEmergency': true,
      'completionScore': 82,
      'ratingAvg': 4.6,
      'ratingCount': 29,
      'categories': [
        {
          'id': 'cat-plomberie',
          'slug': 'plomberie',
          'nameFr': 'Plomberie',
          'nameAr': 'سباكة',
          'isPrimary': true,
        },
      ],
      'coverageAreas': [
        {
          'id': 'cov-14',
          'governorateId': 'gov-sfax',
          'governorateNameFr': 'Sfax',
          'governorateNameAr': 'صفاقس',
          'delegationId': null,
        },
      ],
      'gallery': <dynamic>[],
      'reviewAggregate': {'average': 4.6, 'count': 29},
      'offerings': <dynamic>[],
    },
    // === Peinture (prov-15 à prov-18) ===
    {
      'id': 'prov-15',
      'slug': 'kais-driss-peinture',
      'businessName': 'Kais Driss',
      'headline': 'Peintre décorateur intérieur & finitions haute qualité',
      'bio':
          'Décoration intérieure d’exception : stuc vénitien, tadelakt, papier peint panoramique et peinture soignée sans bavure. 13 ans d’expérience sur Tunis.',
      'yearsExperience': 13,
      'spokenLanguages': ['AR', 'FR'],
      'baseGovernorate': {
        'id': 'gov-tunis',
        'code': 'TUN',
        'nameFr': 'Tunis',
        'nameAr': 'تونس',
      },
      'baseDelegation': {
        'id': 'del-menzah',
        'nameFr': 'El Menzah',
        'nameAr': 'المنزه',
      },
      'latitude': 36.8378,
      'longitude': 10.1789,
      'isVerified': true,
      'availabilityStatus': 'AVAILABLE',
      'availableAgainAt': null,
      'acceptsEmergency': false,
      'completionScore': 96,
      'ratingAvg': 4.9,
      'ratingCount': 35,
      'categories': [
        {
          'id': 'cat-peinture',
          'slug': 'peinture',
          'nameFr': 'Peinture',
          'nameAr': 'دهانة',
          'isPrimary': true,
        },
      ],
      'coverageAreas': [
        {
          'id': 'cov-15',
          'governorateId': 'gov-tunis',
          'governorateNameFr': 'Tunis',
          'governorateNameAr': 'تونس',
          'delegationId': null,
        },
      ],
      'gallery': [
        {
          'id': 'img-15a',
          'url':
              'https://images.unsplash.com/photo-1589939705384-5185137a7f0f?auto=format&fit=crop&w=800&q=80',
          'caption': 'Finition peinture mate et boiseries',
          'sortOrder': 0,
        },
      ],
      'reviewAggregate': {'average': 4.9, 'count': 35},
      'offerings': <dynamic>[],
    },
    {
      'id': 'prov-16',
      'slug': 'mehdi-zouari-peinture',
      'businessName': 'Mehdi Zouari',
      'headline': 'Spécialiste façade extérieure & étanchéité',
      'bio':
          'Ravalement de façade, traitement anti-salpêtre, imperméabilisation et résines de sol pour maisons et immeubles sur la région de Sfax.',
      'yearsExperience': 8,
      'spokenLanguages': ['AR', 'FR'],
      'baseGovernorate': {
        'id': 'gov-sfax',
        'code': 'SFA',
        'nameFr': 'Sfax',
        'nameAr': 'صفاقس',
      },
      'baseDelegation': {
        'id': 'del-sakiet-eddaier',
        'nameFr': 'Sakiet Eddaïer',
        'nameAr': 'ساقية الدائر',
      },
      'latitude': 34.7800,
      'longitude': 10.7900,
      'isVerified': true,
      'availabilityStatus': 'AVAILABLE',
      'availableAgainAt': null,
      'acceptsEmergency': false,
      'completionScore': 84,
      'ratingAvg': 4.7,
      'ratingCount': 14,
      'categories': [
        {
          'id': 'cat-peinture',
          'slug': 'peinture',
          'nameFr': 'Peinture',
          'nameAr': 'دهانة',
          'isPrimary': true,
        },
      ],
      'coverageAreas': [
        {
          'id': 'cov-16',
          'governorateId': 'gov-sfax',
          'governorateNameFr': 'Sfax',
          'governorateNameAr': 'صفاقس',
          'delegationId': null,
        },
      ],
      'gallery': <dynamic>[],
      'reviewAggregate': {'average': 4.7, 'count': 14},
      'offerings': <dynamic>[],
    },
    {
      'id': 'prov-17',
      'slug': 'sofiene-cherif-peinture',
      'businessName': 'Sofiene Cherif',
      'headline': 'Peinture bâtiment & rénovation boiseries',
      'bio':
          'Peinture intérieure moderne, laquage portes et fenêtres, traitement du bois et vernissage de protection à Monastir et Sousse.',
      'yearsExperience': 10,
      'spokenLanguages': ['AR', 'FR'],
      'baseGovernorate': {
        'id': 'gov-monastir',
        'code': 'MON',
        'nameFr': 'Monastir',
        'nameAr': 'المنستير',
      },
      'baseDelegation': {
        'id': 'del-monastir-v',
        'nameFr': 'Monastir Ville',
        'nameAr': 'المنستير المدينة',
      },
      'latitude': 35.7780,
      'longitude': 10.8262,
      'isVerified': true,
      'availabilityStatus': 'AVAILABLE',
      'availableAgainAt': null,
      'acceptsEmergency': false,
      'completionScore': 88,
      'ratingAvg': 4.8,
      'ratingCount': 19,
      'categories': [
        {
          'id': 'cat-peinture',
          'slug': 'peinture',
          'nameFr': 'Peinture',
          'nameAr': 'دهانة',
          'isPrimary': true,
        },
      ],
      'coverageAreas': [
        {
          'id': 'cov-17',
          'governorateId': 'gov-monastir',
          'governorateNameFr': 'Monastir',
          'governorateNameAr': 'المنستير',
          'delegationId': null,
        },
      ],
      'gallery': <dynamic>[],
      'reviewAggregate': {'average': 4.8, 'count': 19},
      'offerings': <dynamic>[],
    },
    {
      'id': 'prov-18',
      'slug': 'ridha-ben-amor-peinture',
      'businessName': 'Ridha Ben Amor',
      'headline': 'Travaux de peinture rapide appartements & bureaux',
      'bio':
          'Rafraîchissement express avant emménagement ou location. Enduit de lissage, peinture acrylique mate et satinée, chantier propre et rapide.',
      'yearsExperience': 6,
      'spokenLanguages': ['AR', 'FR'],
      'baseGovernorate': {
        'id': 'gov-ariana',
        'code': 'ARI',
        'nameFr': 'Ariana',
        'nameAr': 'أريانة',
      },
      'baseDelegation': {
        'id': 'del-ennasr',
        'nameFr': 'Ennasr',
        'nameAr': 'النصر',
      },
      'latitude': 36.8665,
      'longitude': 10.1647,
      'isVerified': false,
      'availabilityStatus': 'AVAILABLE',
      'availableAgainAt': null,
      'acceptsEmergency': false,
      'completionScore': 76,
      'ratingAvg': 4.5,
      'ratingCount': 12,
      'categories': [
        {
          'id': 'cat-peinture',
          'slug': 'peinture',
          'nameFr': 'Peinture',
          'nameAr': 'دهانة',
          'isPrimary': true,
        },
      ],
      'coverageAreas': [
        {
          'id': 'cov-18',
          'governorateId': 'gov-ariana',
          'governorateNameFr': 'Ariana',
          'governorateNameAr': 'أريانة',
          'delegationId': null,
        },
      ],
      'gallery': <dynamic>[],
      'reviewAggregate': {'average': 4.5, 'count': 12},
      'offerings': <dynamic>[],
    },
    // === Menuiserie (prov-19 à prov-22) ===
    {
      'id': 'prov-19',
      'slug': 'hamdi-ayadi-menuiserie',
      'businessName': 'Hamdi Ayadi',
      'headline': 'Maître ébéniste & menuiserie bois massif sur mesure',
      'bio':
          'Fabrication artisanale de cuisines en bois massif, portes d’entrée sculptées, dressings et escaliers design. 20 ans de savoir-faire sfaxien.',
      'yearsExperience': 20,
      'spokenLanguages': ['AR', 'FR'],
      'baseGovernorate': {
        'id': 'gov-sfax',
        'code': 'SFA',
        'nameFr': 'Sfax',
        'nameAr': 'صفاقس',
      },
      'baseDelegation': {
        'id': 'del-sfax-v',
        'nameFr': 'Sfax Ville',
        'nameAr': 'صفاقس المدينة',
      },
      'latitude': 34.7406,
      'longitude': 10.7603,
      'isVerified': true,
      'availabilityStatus': 'AVAILABLE',
      'availableAgainAt': null,
      'acceptsEmergency': false,
      'completionScore': 97,
      'ratingAvg': 4.9,
      'ratingCount': 45,
      'categories': [
        {
          'id': 'cat-menuiserie',
          'slug': 'menuiserie',
          'nameFr': 'Menuiserie',
          'nameAr': 'نجارة',
          'isPrimary': true,
        },
      ],
      'coverageAreas': [
        {
          'id': 'cov-19',
          'governorateId': 'gov-sfax',
          'governorateNameFr': 'Sfax',
          'governorateNameAr': 'صفاقس',
          'delegationId': null,
        },
      ],
      'gallery': [
        {
          'id': 'img-19a',
          'url':
              'https://images.unsplash.com/photo-1538688525198-9b88f6f53126?auto=format&fit=crop&w=800&q=80',
          'caption': 'Atelier ébénisterie et création bois noble',
          'sortOrder': 0,
        },
      ],
      'reviewAggregate': {'average': 4.9, 'count': 45},
      'offerings': <dynamic>[],
    },
    {
      'id': 'prov-20',
      'slug': 'fakhri-mathlouthi-menuiserie',
      'businessName': 'Fakhri Mathlouthi',
      'headline': 'Menuiserie aluminium & PVC thermo-isolante',
      'bio':
          'Pose de profilés aluminium haut de gamme (TPR), double vitrage isolant, vérandas et baies vitrées sur Sousse et le Sahel.',
      'yearsExperience': 12,
      'spokenLanguages': ['AR', 'FR'],
      'baseGovernorate': {
        'id': 'gov-sousse',
        'code': 'SOU',
        'nameFr': 'Sousse',
        'nameAr': 'سوسة',
      },
      'baseDelegation': {
        'id': 'del-sahloul',
        'nameFr': 'Sahloul',
        'nameAr': 'سهلول',
      },
      'latitude': 35.8394,
      'longitude': 10.5989,
      'isVerified': true,
      'availabilityStatus': 'AVAILABLE',
      'availableAgainAt': null,
      'acceptsEmergency': false,
      'completionScore': 91,
      'ratingAvg': 4.8,
      'ratingCount': 26,
      'categories': [
        {
          'id': 'cat-menuiserie',
          'slug': 'menuiserie',
          'nameFr': 'Menuiserie',
          'nameAr': 'نجارة',
          'isPrimary': true,
        },
      ],
      'coverageAreas': [
        {
          'id': 'cov-20',
          'governorateId': 'gov-sousse',
          'governorateNameFr': 'Sousse',
          'governorateNameAr': 'سوسة',
          'delegationId': null,
        },
      ],
      'gallery': <dynamic>[],
      'reviewAggregate': {'average': 4.8, 'count': 26},
      'offerings': <dynamic>[],
    },
    {
      'id': 'prov-21',
      'slug': 'nizar-chebbi-menuiserie',
      'businessName': 'Nizar Chebbi',
      'headline': 'Agencement intérieur moderne & mobilier sur mesure',
      'bio':
          'Création de dressings encastrés, bibliothèques contemporaines, meubles TV et cloisons ajourées (claustras) sur Carthage et banlieue nord.',
      'yearsExperience': 15,
      'spokenLanguages': ['AR', 'FR'],
      'baseGovernorate': {
        'id': 'gov-tunis',
        'code': 'TUN',
        'nameFr': 'Tunis',
        'nameAr': 'تونس',
      },
      'baseDelegation': {
        'id': 'del-carthage',
        'nameFr': 'Carthage',
        'nameAr': 'قرطاج',
      },
      'latitude': 36.8528,
      'longitude': 10.3233,
      'isVerified': true,
      'availabilityStatus': 'AVAILABLE',
      'availableAgainAt': null,
      'acceptsEmergency': false,
      'completionScore': 93,
      'ratingAvg': 4.9,
      'ratingCount': 30,
      'categories': [
        {
          'id': 'cat-menuiserie',
          'slug': 'menuiserie',
          'nameFr': 'Menuiserie',
          'nameAr': 'نجارة',
          'isPrimary': true,
        },
      ],
      'coverageAreas': [
        {
          'id': 'cov-21',
          'governorateId': 'gov-tunis',
          'governorateNameFr': 'Tunis',
          'governorateNameAr': 'تونس',
          'delegationId': null,
        },
      ],
      'gallery': <dynamic>[],
      'reviewAggregate': {'average': 4.9, 'count': 30},
      'offerings': <dynamic>[],
    },
    {
      'id': 'prov-22',
      'slug': 'adel-ben-salah-menuiserie',
      'businessName': 'Adel Ben Salah',
      'headline': 'Menuiserie bois, portes intérieures & placards',
      'bio':
          'Atelier de fabrication et pose de portes d’intérieur, meubles de salle de bain et réparations diverses à Monastir et Sahline.',
      'yearsExperience': 9,
      'spokenLanguages': ['AR', 'FR'],
      'baseGovernorate': {
        'id': 'gov-monastir',
        'code': 'MON',
        'nameFr': 'Monastir',
        'nameAr': 'المنستير',
      },
      'baseDelegation': {
        'id': 'del-sahline',
        'nameFr': 'Sahline',
        'nameAr': 'الساحلين',
      },
      'latitude': 35.7500,
      'longitude': 10.7100,
      'isVerified': false,
      'availabilityStatus': 'AVAILABLE',
      'availableAgainAt': null,
      'acceptsEmergency': false,
      'completionScore': 80,
      'ratingAvg': 4.6,
      'ratingCount': 17,
      'categories': [
        {
          'id': 'cat-menuiserie',
          'slug': 'menuiserie',
          'nameFr': 'Menuiserie',
          'nameAr': 'نجارة',
          'isPrimary': true,
        },
      ],
      'coverageAreas': [
        {
          'id': 'cov-22',
          'governorateId': 'gov-monastir',
          'governorateNameFr': 'Monastir',
          'governorateNameAr': 'المنستير',
          'delegationId': null,
        },
      ],
      'gallery': <dynamic>[],
      'reviewAggregate': {'average': 4.6, 'count': 17},
      'offerings': <dynamic>[],
    },
    // === Climatisation (prov-23 à prov-26) ===
    {
      'id': 'prov-23',
      'slug': 'bassem-khelifi-climatisation',
      'businessName': 'Bassem Khelifi',
      'headline': 'Génie climatique & climatisation centrale VRV',
      'bio':
          'Installateur frigoriste agréé toutes marques (LG, Samsung, Carrier). Bilans thermiques, installation soignée et contrats d’entretien annuel.',
      'yearsExperience': 14,
      'spokenLanguages': ['AR', 'FR'],
      'baseGovernorate': {
        'id': 'gov-tunis',
        'code': 'TUN',
        'nameFr': 'Tunis',
        'nameAr': 'تونس',
      },
      'baseDelegation': {
        'id': 'del-marsa',
        'nameFr': 'La Marsa',
        'nameAr': 'المرسى',
      },
      'latitude': 36.8782,
      'longitude': 10.3247,
      'isVerified': true,
      'availabilityStatus': 'AVAILABLE',
      'availableAgainAt': null,
      'acceptsEmergency': true,
      'completionScore': 95,
      'ratingAvg': 4.9,
      'ratingCount': 48,
      'categories': [
        {
          'id': 'cat-climatisation',
          'slug': 'climatisation',
          'nameFr': 'Climatisation',
          'nameAr': 'مكيفات',
          'isPrimary': true,
        },
      ],
      'coverageAreas': [
        {
          'id': 'cov-23',
          'governorateId': 'gov-tunis',
          'governorateNameFr': 'Tunis',
          'governorateNameAr': 'تونس',
          'delegationId': null,
        },
      ],
      'gallery': [
        {
          'id': 'img-23a',
          'url':
              'https://images.unsplash.com/photo-1621905252507-b35492cc74b4?auto=format&fit=crop&w=800&q=80',
          'caption': 'Unité extérieure split moderne',
          'sortOrder': 0,
        },
      ],
      'reviewAggregate': {'average': 4.9, 'count': 48},
      'offerings': <dynamic>[],
    },
    {
      'id': 'prov-24',
      'slug': 'ramzi-ben-youssef-climatisation',
      'businessName': 'Ramzi Ben Youssef',
      'headline': 'Frigoriste certifié & recharge gaz express',
      'bio':
          'Dépannage rapide climatiseurs split à Sousse. Recherche de fuite fréon, recharge R32 / R410, nettoyage complet antibactérien et révision.',
      'yearsExperience': 11,
      'spokenLanguages': ['AR', 'FR'],
      'baseGovernorate': {
        'id': 'gov-sousse',
        'code': 'SOU',
        'nameFr': 'Sousse',
        'nameAr': 'سوسة',
      },
      'baseDelegation': {
        'id': 'del-sousse-v',
        'nameFr': 'Sousse Ville',
        'nameAr': 'سوسة المدينة',
      },
      'latitude': 35.8256,
      'longitude': 10.6084,
      'isVerified': true,
      'availabilityStatus': 'AVAILABLE',
      'availableAgainAt': null,
      'acceptsEmergency': true,
      'completionScore': 90,
      'ratingAvg': 4.8,
      'ratingCount': 33,
      'categories': [
        {
          'id': 'cat-climatisation',
          'slug': 'climatisation',
          'nameFr': 'Climatisation',
          'nameAr': 'مكيفات',
          'isPrimary': true,
        },
      ],
      'coverageAreas': [
        {
          'id': 'cov-24',
          'governorateId': 'gov-sousse',
          'governorateNameFr': 'Sousse',
          'governorateNameAr': 'سوسة',
          'delegationId': null,
        },
      ],
      'gallery': <dynamic>[],
      'reviewAggregate': {'average': 4.8, 'count': 33},
      'offerings': <dynamic>[],
    },
    {
      'id': 'prov-25',
      'slug': 'mourad-jaziri-climatisation',
      'businessName': 'Mourad Jaziri',
      'headline': 'Installation climatiseurs split & pompes à chaleur',
      'bio':
          'Pose soignée sans poussière, câblage et goulottes esthétiques, évacuation condensats aux normes sur Ben Arous et Radès.',
      'yearsExperience': 7,
      'spokenLanguages': ['AR', 'FR'],
      'baseGovernorate': {
        'id': 'gov-ben-arous',
        'code': 'BEN',
        'nameFr': 'Ben Arous',
        'nameAr': 'بن عروس',
      },
      'baseDelegation': {
        'id': 'del-rades',
        'nameFr': 'Radès',
        'nameAr': 'رادس',
      },
      'latitude': 36.7681,
      'longitude': 10.2750,
      'isVerified': true,
      'availabilityStatus': 'AVAILABLE',
      'availableAgainAt': null,
      'acceptsEmergency': false,
      'completionScore': 86,
      'ratingAvg': 4.7,
      'ratingCount': 20,
      'categories': [
        {
          'id': 'cat-climatisation',
          'slug': 'climatisation',
          'nameFr': 'Climatisation',
          'nameAr': 'مكيفات',
          'isPrimary': true,
        },
      ],
      'coverageAreas': [
        {
          'id': 'cov-25',
          'governorateId': 'gov-ben-arous',
          'governorateNameFr': 'Ben Arous',
          'governorateNameAr': 'بن عروس',
          'delegationId': null,
        },
      ],
      'gallery': <dynamic>[],
      'reviewAggregate': {'average': 4.7, 'count': 20},
      'offerings': <dynamic>[],
    },
    {
      'id': 'prov-26',
      'slug': 'faouzi-belhadj-climatisation',
      'businessName': 'Faouzi Belhadj',
      'headline': 'Climatisation tertiaire & résidentielle Monastir',
      'bio':
          '13 ans d’expertise dans le froid commercial et domestique. Dépannage électronique compresseur, cartes mères inverter et détendeurs.',
      'yearsExperience': 13,
      'spokenLanguages': ['AR', 'FR'],
      'baseGovernorate': {
        'id': 'gov-monastir',
        'code': 'MON',
        'nameFr': 'Monastir',
        'nameAr': 'المنستير',
      },
      'baseDelegation': {
        'id': 'del-ksar-hellal',
        'nameFr': 'Ksar Hellal',
        'nameAr': 'قصر هلال',
      },
      'latitude': 35.6480,
      'longitude': 10.8920,
      'isVerified': true,
      'availabilityStatus': 'AVAILABLE',
      'availableAgainAt': null,
      'acceptsEmergency': true,
      'completionScore': 89,
      'ratingAvg': 4.8,
      'ratingCount': 25,
      'categories': [
        {
          'id': 'cat-climatisation',
          'slug': 'climatisation',
          'nameFr': 'Climatisation',
          'nameAr': 'مكيفات',
          'isPrimary': true,
        },
      ],
      'coverageAreas': [
        {
          'id': 'cov-26',
          'governorateId': 'gov-monastir',
          'governorateNameFr': 'Monastir',
          'governorateNameAr': 'المنستير',
          'delegationId': null,
        },
      ],
      'gallery': <dynamic>[],
      'reviewAggregate': {'average': 4.8, 'count': 25},
      'offerings': <dynamic>[],
    },
    // === Serrurerie (prov-27 à prov-30) ===
    {
      'id': 'prov-27',
      'slug': 'aymen-sellami-serrurerie',
      'businessName': 'Aymen Sellami',
      'headline': 'Serrurier métallier d’art & portes blindées',
      'bio':
          'Fabrication et pose de grilles de défense forgées, portes blindées de haute sécurité, serrures multipoints Fichet et blindage de pavillon à Sfax.',
      'yearsExperience': 15,
      'spokenLanguages': ['AR', 'FR'],
      'baseGovernorate': {
        'id': 'gov-sfax',
        'code': 'SFA',
        'nameFr': 'Sfax',
        'nameAr': 'صفاقس',
      },
      'baseDelegation': {
        'id': 'del-sfax-v',
        'nameFr': 'Sfax Ville',
        'nameAr': 'صفاقس المدينة',
      },
      'latitude': 34.7406,
      'longitude': 10.7603,
      'isVerified': true,
      'availabilityStatus': 'AVAILABLE',
      'availableAgainAt': null,
      'acceptsEmergency': true,
      'completionScore': 94,
      'ratingAvg': 4.9,
      'ratingCount': 37,
      'categories': [
        {
          'id': 'cat-serrurerie',
          'slug': 'serrurerie',
          'nameFr': 'Serrurerie',
          'nameAr': 'أقفال',
          'isPrimary': true,
        },
      ],
      'coverageAreas': [
        {
          'id': 'cov-27',
          'governorateId': 'gov-sfax',
          'governorateNameFr': 'Sfax',
          'governorateNameAr': 'صفاقس',
          'delegationId': null,
        },
      ],
      'gallery': [
        {
          'id': 'img-27a',
          'url':
              'https://images.unsplash.com/photo-1558002038-1055907df827?auto=format&fit=crop&w=800&q=80',
          'caption': 'Porte blindée et serrure haute sécurité',
          'sortOrder': 0,
        },
      ],
      'reviewAggregate': {'average': 4.9, 'count': 37},
      'offerings': <dynamic>[],
    },
    {
      'id': 'prov-28',
      'slug': 'slimane-meftah-serrurerie',
      'businessName': 'Slimane Meftah',
      'headline': 'Serrurier dépanneur urgent 24/7 Grand Tunis',
      'bio':
          'Ouverture de porte claquée sans trace ni perçage en moins de 30 minutes. Remplacement de barillet et cylindre de sécurité après perte de clés.',
      'yearsExperience': 12,
      'spokenLanguages': ['AR', 'FR'],
      'baseGovernorate': {
        'id': 'gov-tunis',
        'code': 'TUN',
        'nameFr': 'Tunis',
        'nameAr': 'تونس',
      },
      'baseDelegation': {
        'id': 'del-menzah',
        'nameFr': 'El Menzah',
        'nameAr': 'المنزه',
      },
      'latitude': 36.8378,
      'longitude': 10.1789,
      'isVerified': true,
      'availabilityStatus': 'AVAILABLE',
      'availableAgainAt': null,
      'acceptsEmergency': true,
      'completionScore': 92,
      'ratingAvg': 4.8,
      'ratingCount': 29,
      'categories': [
        {
          'id': 'cat-serrurerie',
          'slug': 'serrurerie',
          'nameFr': 'Serrurerie',
          'nameAr': 'أقفال',
          'isPrimary': true,
        },
      ],
      'coverageAreas': [
        {
          'id': 'cov-28',
          'governorateId': 'gov-tunis',
          'governorateNameFr': 'Tunis',
          'governorateNameAr': 'تونس',
          'delegationId': null,
        },
      ],
      'gallery': <dynamic>[],
      'reviewAggregate': {'average': 4.8, 'count': 29},
      'offerings': <dynamic>[],
    },
    {
      'id': 'prov-29',
      'slug': 'houssem-baccouche-serrurerie',
      'businessName': 'Houssem Baccouche',
      'headline': 'Changement serrures multipoints & serrures connectées',
      'bio':
          'Installation de serrures intelligentes (empreinte, code), renforts anti-effraction et dépannage volets roulants métalliques sur Sousse et Hammam Sousse.',
      'yearsExperience': 8,
      'spokenLanguages': ['AR', 'FR'],
      'baseGovernorate': {
        'id': 'gov-sousse',
        'code': 'SOU',
        'nameFr': 'Sousse',
        'nameAr': 'سوسة',
      },
      'baseDelegation': {
        'id': 'del-kantaoui',
        'nameFr': 'Hammam Sousse',
        'nameAr': 'حمام سوسة',
      },
      'latitude': 35.8583,
      'longitude': 10.5936,
      'isVerified': true,
      'availabilityStatus': 'AVAILABLE',
      'availableAgainAt': null,
      'acceptsEmergency': true,
      'completionScore': 87,
      'ratingAvg': 4.7,
      'ratingCount': 19,
      'categories': [
        {
          'id': 'cat-serrurerie',
          'slug': 'serrurerie',
          'nameFr': 'Serrurerie',
          'nameAr': 'أقفال',
          'isPrimary': true,
        },
      ],
      'coverageAreas': [
        {
          'id': 'cov-29',
          'governorateId': 'gov-sousse',
          'governorateNameFr': 'Sousse',
          'governorateNameAr': 'سوسة',
          'delegationId': null,
        },
      ],
      'gallery': <dynamic>[],
      'reviewAggregate': {'average': 4.7, 'count': 19},
      'offerings': <dynamic>[],
    },
    {
      'id': 'prov-30',
      'slug': 'nader-louati-serrurerie',
      'businessName': 'Nader Louati',
      'headline': 'Blindage de porte & reproduction clés sécurisées',
      'bio':
          'Spécialiste de la sécurisation des accès pour résidences et commerces à l’Ariana. Blindage fourreau, cornières anti-pinces et serrures carénées.',
      'yearsExperience': 10,
      'spokenLanguages': ['AR', 'FR'],
      'baseGovernorate': {
        'id': 'gov-ariana',
        'code': 'ARI',
        'nameFr': 'Ariana',
        'nameAr': 'أريانة',
      },
      'baseDelegation': {
        'id': 'del-ariana-v',
        'nameFr': 'Ariana Ville',
        'nameAr': 'أريانة المدينة',
      },
      'latitude': 36.8625,
      'longitude': 10.1956,
      'isVerified': true,
      'availabilityStatus': 'AVAILABLE',
      'availableAgainAt': null,
      'acceptsEmergency': false,
      'completionScore': 88,
      'ratingAvg': 4.8,
      'ratingCount': 21,
      'categories': [
        {
          'id': 'cat-serrurerie',
          'slug': 'serrurerie',
          'nameFr': 'Serrurerie',
          'nameAr': 'أقفال',
          'isPrimary': true,
        },
      ],
      'coverageAreas': [
        {
          'id': 'cov-30',
          'governorateId': 'gov-ariana',
          'governorateNameFr': 'Ariana',
          'governorateNameAr': 'أريانة',
          'delegationId': null,
        },
      ],
      'gallery': <dynamic>[],
      'reviewAggregate': {'average': 4.8, 'count': 21},
      'offerings': <dynamic>[],
    },
  ];

  static Map<String, dynamic> searchResponse({
    String? category,
    String? governorate,
    bool? verified,
    num? minRating,
    String? query,
  }) {
    final filtered = providersList.where((p) {
      if (query != null && query.trim().isNotEmpty) {
        final q = query.trim().toLowerCase();
        final bName = (p['businessName'] ?? '').toString().toLowerCase();
        final headline = (p['headline'] ?? '').toString().toLowerCase();
        final bio = (p['bio'] ?? '').toString().toLowerCase();
        final cats = (p['categories'] as List<dynamic>?) ?? const <dynamic>[];
        final matchCat = cats.any((c) {
          if (c is! Map<String, dynamic>) return false;
          final cSlug = (c['slug'] ?? '').toString().toLowerCase();
          final cFr = (c['nameFr'] ?? '').toString().toLowerCase();
          final cAr = (c['nameAr'] ?? '').toString().toLowerCase();
          return cSlug.contains(q) || cFr.contains(q) || cAr.contains(q);
        });

        if (!bName.contains(q) &&
            !headline.contains(q) &&
            !bio.contains(q) &&
            !matchCat) {
          return false;
        }
      }
      if (category != null && category.isNotEmpty) {
        final cats = (p['categories'] as List<dynamic>?) ?? const <dynamic>[];
        final matchCat = cats.any((c) {
          if (c is! Map<String, dynamic>) return false;
          return c['slug'] == category;
        });
        if (!matchCat) return false;
      }
      if (governorate != null && governorate.isNotEmpty) {
        final gov = p['baseGovernorate'] as Map<String, dynamic>?;
        final govId = gov?['id']?.toString() ?? '';
        final covAreas =
            (p['coverageAreas'] as List<dynamic>?) ?? const <dynamic>[];

        final matchesBase =
            govId == governorate ||
            govId.contains(governorate) ||
            governorate.contains(govId.replaceFirst('gov-', ''));

        final matchesCoverage = covAreas.any((c) {
          if (c is! Map<String, dynamic>) return false;
          final cId = (c['governorateId'] ?? '').toString();
          return cId == governorate ||
              cId.contains(governorate) ||
              governorate.contains(cId.replaceFirst('gov-', ''));
        });

        // Régions urbaines interconnectées (Grand Tunis & Sahel)
        final isGrandTunisTarget =
            governorate.contains('tunis') ||
            governorate.contains('ariana') ||
            governorate.contains('ben-arous');
        final isGrandTunisProvider =
            govId.contains('tunis') ||
            govId.contains('ariana') ||
            govId.contains('ben-arous');

        final isSahelTarget =
            governorate.contains('sousse') || governorate.contains('monastir');
        final isSahelProvider =
            govId.contains('sousse') || govId.contains('monastir');

        final matchesRegion =
            (isGrandTunisTarget && isGrandTunisProvider) ||
            (isSahelTarget && isSahelProvider);

        if (!matchesBase && !matchesCoverage && !matchesRegion) return false;
      }
      if (verified == true && p['isVerified'] != true) return false;
      if (minRating != null && ((p['ratingAvg'] as num?) ?? 0) < minRating) {
        return false;
      }
      return true;
    }).toList();

    final items = filtered.map((p) {
      return {
        'id': p['id'],
        'slug': p['slug'],
        'businessName': p['businessName'],
        'headline': p['headline'],
        'isVerified': p['isVerified'],
        'ratingAvg': p['ratingAvg'],
        'ratingCount': p['ratingCount'],
        'completionScore': p['completionScore'],
        'availabilityStatus': p['availabilityStatus'],
        'categories': p['categories'],
        'score': 1.0,
      };
    }).toList();

    return {
      'items': items,
      'nextCursor': '',
    };
  }

  static Map<String, dynamic>? providerDetail(String slug) {
    Map<String, dynamic>? raw;
    for (final p in providersList) {
      if (p['slug'] == slug || p['id'] == slug) {
        raw = p;
        break;
      }
    }
    raw ??= providersList.isNotEmpty ? providersList.first : null;
    if (raw == null) return null;

    final copy = Map<String, dynamic>.from(raw);
    copy['availableAgainAt'] = '2026-05-01T08:00:00.000Z';

    final gov = copy['baseGovernorate'] as Map<String, dynamic>?;
    if (gov != null) {
      copy['baseGovernorate'] = {
        'slug': (gov['slug'] ?? gov['nameFr'] ?? 'sousse')
            .toString()
            .toLowerCase(),
        'nameFr': gov['nameFr'] ?? 'Sousse',
        'nameAr': gov['nameAr'] ?? 'سوسة',
      };
    }

    final del = copy['baseDelegation'] as Map<String, dynamic>?;
    if (del != null) {
      copy['baseDelegation'] = {
        'slug': (del['slug'] ?? del['nameFr'] ?? 'sousse-ville')
            .toString()
            .toLowerCase()
            .replaceAll(' ', '-'),
        'nameFr': del['nameFr'] ?? 'Sousse Ville',
        'nameAr': del['nameAr'] ?? 'سوسة المدينة',
      };
    }

    final cats = copy['categories'] as List<dynamic>?;
    if (cats != null) {
      copy['categories'] = cats.map((c) {
        final cm = c as Map<String, dynamic>;
        return {
          'slug': cm['slug'] ?? 'electricite',
          'nameFr': cm['nameFr'] ?? 'Électricité',
          'nameAr': cm['nameAr'] ?? 'كهرباء',
          'isPrimary': cm['isPrimary'] ?? true,
          'yearsExperience': copy['yearsExperience'] ?? 10,
        };
      }).toList();
    }

    final baseGov = copy['baseGovernorate'] as Map<String, dynamic>?;
    final baseDel = copy['baseDelegation'] as Map<String, dynamic>?;
    copy['coverageAreas'] = [
      {
        'governorate': {
          'slug': baseGov?['slug'] ?? 'sousse',
          'nameFr': baseGov?['nameFr'] ?? 'Sousse',
          'nameAr': baseGov?['nameAr'] ?? 'سوسة',
        },
        'delegation': {
          'slug': baseDel?['slug'] ?? 'sousse-ville',
          'nameFr': baseDel?['nameFr'] ?? 'Sousse Ville',
          'nameAr': baseDel?['nameAr'] ?? 'سوسة المدينة',
        },
        'travelFee': 0,
      },
    ];

    Map<String, dynamic>? primaryCat;
    if (cats != null && cats.isNotEmpty) {
      for (final c in cats) {
        if (c is Map<String, dynamic> && c['isPrimary'] == true) {
          primaryCat = c;
          break;
        }
      }
      primaryCat ??= cats.first as Map<String, dynamic>;
    } else {
      primaryCat = const <String, dynamic>{
        'slug': 'electricite',
        'nameFr': 'Électricité',
        'nameAr': 'كهرباء',
      };
    }

    final existingGallery = raw['gallery'] as List<dynamic>?;
    if (existingGallery != null && existingGallery.isNotEmpty) {
      copy['gallery'] = existingGallery.map((img) {
        final imgMap = img as Map<String, dynamic>;
        return {
          'id': imgMap['id'] ?? 'img-1',
          'url':
              imgMap['url'] ??
              'https://images.unsplash.com/photo-1621905251189-08b45d6a269e?auto=format&fit=crop&w=800&q=80',
          'width': 800,
          'height': 600,
          'blurhash': 'L6PZfSi_.AyE_3t7t7R**0o#DgR4',
          'caption': imgMap['caption'] ?? 'Chantier professionnel',
          'category': {
            'slug': primaryCat?['slug'] ?? 'electricite',
            'nameFr': primaryCat?['nameFr'] ?? 'Électricité',
            'nameAr': primaryCat?['nameAr'] ?? 'كهرباء',
          },
        };
      }).toList();
    } else {
      copy['gallery'] = [
        {
          'id': 'img-default',
          'url':
              'https://images.unsplash.com/photo-1581092160607-ee22621dd758?auto=format&fit=crop&w=800&q=80',
          'width': 800,
          'height': 600,
          'blurhash': 'L6PZfSi_.AyE_3t7t7R**0o#DgR4',
          'caption': 'Intervention soignée et matériel professionnel',
          'category': {
            'slug': primaryCat['slug'] ?? 'electricite',
            'nameFr': primaryCat['nameFr'] ?? 'Électricité',
            'nameAr': primaryCat['nameAr'] ?? 'كهرباء',
          },
        },
      ];
    }

    final totalCount = (copy['ratingCount'] as num?)?.toInt() ?? 20;
    final avgRating = (copy['ratingAvg'] as num?)?.toDouble() ?? 4.8;
    copy['reviewAggregate'] = {
      'average': avgRating,
      'count': totalCount,
      'breakdown': {
        '1': 0,
        '2': 0,
        '3': 1,
        '4': (totalCount * 0.2).round(),
        '5': totalCount - (totalCount * 0.2).round() - 1,
      },
    };

    copy['offerings'] = <dynamic>[];
    return copy;
  }

  static final Map<String, List<Map<String, dynamic>>> _providerReviews = {};

  static List<Map<String, dynamic>> _defaultReviews() => [
    {
      'id': 'rev-1',
      'authorDisplayName': 'Karim M.',
      'rating': 5,
      'comment':
          'Excellent travail ! Très ponctuel, travail soigné et tarif honnête.',
      'isVerifiedContact': true,
      'createdAt': '2026-09-01T10:30:00.000Z',
    },
    {
      'id': 'rev-2',
      'authorDisplayName': 'Fatma B.',
      'rating': 5,
      'comment':
          'Intervention rapide un dimanche matin pour un dépannage urgent.',
      'isVerifiedContact': true,
      'createdAt': '2026-08-28T14:15:00.000Z',
    },
    {
      'id': 'rev-3',
      'authorDisplayName': 'Moncef T.',
      'rating': 4,
      'comment': 'Bon travail dans l’ensemble. Matériel de qualité installé.',
      'isVerifiedContact': true,
      'createdAt': '2026-08-15T09:00:00.000Z',
    },
  ];

  static List<Map<String, dynamic>> _getReviewsForProvider(String idOrSlug) {
    final provider = providersList.firstWhere(
      (p) => p['id'] == idOrSlug || p['slug'] == idOrSlug,
      orElse: () => <String, dynamic>{},
    );
    final key = (provider['slug'] as String?) ?? idOrSlug;
    return _providerReviews.putIfAbsent(key, _defaultReviews);
  }

  static Map<String, dynamic> providerReviews(String slug) {
    final list = _getReviewsForProvider(slug);
    return {
      'items': list.map(Map<String, dynamic>.from).toList(),
      'nextCursor': '',
    };
  }

  static Map<String, dynamic> addReview(
    String providerIdOrSlug, {
    required int rating,
    String? comment,
  }) {
    final provider = providersList.firstWhere(
      (p) => p['id'] == providerIdOrSlug || p['slug'] == providerIdOrSlug,
      orElse: () => <String, dynamic>{},
    );
    final key = (provider['slug'] as String?) ?? providerIdOrSlug;
    final reviews = _getReviewsForProvider(key);

    final newReview = <String, dynamic>{
      'id': 'rev-${DateTime.now().millisecondsSinceEpoch}',
      'authorDisplayName': 'Vous (Client)',
      'rating': rating,
      'comment': (comment != null && comment.trim().isNotEmpty)
          ? comment.trim()
          : 'Avis publié en mode démo',
      'isVerifiedContact': true,
      'createdAt': DateTime.now().toIso8601String(),
    };

    reviews.insert(0, newReview);

    // Mettre à jour les statistiques de l'artisan dans providersList
    if (provider.isNotEmpty) {
      final oldAvg = (provider['ratingAvg'] as num?)?.toDouble() ?? 5.0;
      final oldCount = (provider['ratingCount'] as num?)?.toInt() ?? 0;
      final newCount = oldCount + 1;
      final newAvg = double.parse(
        ((oldAvg * oldCount + rating) / newCount).toStringAsFixed(1),
      );
      provider['ratingAvg'] = newAvg;
      provider['ratingCount'] = newCount;
      provider['reviewAggregate'] = {
        'average': newAvg,
        'count': newCount,
      };
    }

    // Mettre à jour hasReview dans contactEvents
    final targetId = provider['id'] as String? ?? providerIdOrSlug;
    final targetSlug = provider['slug'] as String? ?? providerIdOrSlug;
    for (final event in _demoContactEvents) {
      if (event['providerId'] == targetId || event['slug'] == targetSlug) {
        event['hasReview'] = true;
      }
    }

    return newReview;
  }

  static final List<Map<String, dynamic>> _initialFavorites = [
    {
      'providerId': 'prov-1',
      'slug': 'sami-mansour-electricite',
      'businessName': 'Sami Mansour',
      'headline': 'Électricien qualifié BTP & dépannage urgent 24/7',
      'isVerified': true,
      'ratingAvg': 4.9,
      'ratingCount': 32,
      'availabilityStatus': 'AVAILABLE',
      'favoritedAt': '2026-09-02T12:00:00.000Z',
    },
    {
      'providerId': 'prov-2',
      'slug': 'hedi-bouazizi-plomberie',
      'businessName': 'Hedi Bouazizi',
      'headline': 'Plombier sanitaire & installation chauffe-eau',
      'isVerified': true,
      'ratingAvg': 4.8,
      'ratingCount': 19,
      'availabilityStatus': 'AVAILABLE',
      'favoritedAt': '2026-09-03T15:30:00.000Z',
    },
  ];

  static List<Map<String, dynamic>> _demoFavorites = _initialFavorites
      .map(Map<String, dynamic>.from)
      .toList();

  static Map<String, dynamic> get favorites => {
    'items': _demoFavorites.map(Map<String, dynamic>.from).toList(),
    'nextCursor': '',
  };

  static void addFavorite(String providerIdOrSlug) {
    if (_demoFavorites.any(
      (f) =>
          f['providerId'] == providerIdOrSlug || f['slug'] == providerIdOrSlug,
    )) {
      return;
    }

    final provider = providersList.firstWhere(
      (p) => p['id'] == providerIdOrSlug || p['slug'] == providerIdOrSlug,
      orElse: () => <String, dynamic>{},
    );

    if (provider.isNotEmpty) {
      _demoFavorites.insert(0, {
        'providerId': provider['id'] ?? providerIdOrSlug,
        'slug': provider['slug'] ?? '',
        'businessName': provider['businessName'] ?? '',
        'headline': provider['headline'] ?? '',
        'isVerified': provider['isVerified'] ?? false,
        'ratingAvg': provider['ratingAvg'] ?? 5.0,
        'ratingCount': provider['ratingCount'] ?? 1,
        'availabilityStatus': provider['availabilityStatus'] ?? 'AVAILABLE',
        'favoritedAt': DateTime.now().toIso8601String(),
      });
    } else {
      _demoFavorites.insert(0, {
        'providerId': providerIdOrSlug,
        'slug': providerIdOrSlug,
        'businessName': 'Artisan',
        'headline': '',
        'isVerified': false,
        'ratingAvg': 5.0,
        'ratingCount': 1,
        'availabilityStatus': 'AVAILABLE',
        'favoritedAt': DateTime.now().toIso8601String(),
      });
    }
  }

  static void removeFavorite(String providerIdOrSlug) {
    _demoFavorites.removeWhere(
      (f) =>
          f['providerId'] == providerIdOrSlug || f['slug'] == providerIdOrSlug,
    );
  }

  static final List<Map<String, dynamic>> _initialContactEvents = [
    {
      'id': 'evt-1',
      'providerId': 'prov-1',
      'slug': 'sami-mansour-electricite',
      'businessName': 'Sami Mansour',
      'channel': 'PHONE',
      'categoryName': 'Électricité',
      'hasReview': true,
      'contactedAt': '2026-09-01T10:00:00.000Z',
    },
    {
      'id': 'evt-2',
      'providerId': 'prov-2',
      'slug': 'hedi-bouazizi-plomberie',
      'businessName': 'Hedi Bouazizi',
      'channel': 'WHATSAPP',
      'categoryName': 'Plomberie',
      'hasReview': false,
      'contactedAt': '2026-09-04T16:20:00.000Z',
    },
    {
      'id': 'evt-3',
      'providerId': 'prov-6',
      'slug': 'yassine-riahi-serrurerie',
      'businessName': 'Yassine Riahi',
      'channel': 'PHONE',
      'categoryName': 'Serrurerie',
      'hasReview': false,
      'contactedAt': '2026-09-05T20:10:00.000Z',
    },
  ];

  static List<Map<String, dynamic>> _demoContactEvents = _initialContactEvents
      .map(Map<String, dynamic>.from)
      .toList();

  static Map<String, dynamic> get contactEvents => {
    'items': _demoContactEvents.map(Map<String, dynamic>.from).toList(),
    'nextCursor': '',
  };

  static Map<String, dynamic> addContactEvent({
    required String providerIdOrSlug,
    required String channel,
  }) {
    final provider = providersList.firstWhere(
      (p) => p['id'] == providerIdOrSlug || p['slug'] == providerIdOrSlug,
      orElse: () => <String, dynamic>{},
    );

    final providerId = (provider['id'] as String?) ?? providerIdOrSlug;
    final slug = (provider['slug'] as String?) ?? providerIdOrSlug;
    final businessName = (provider['businessName'] as String?) ?? 'Artisan';

    var categoryName = 'Artisanat';
    final categories = provider['categories'] as List<dynamic>?;
    if (categories != null && categories.isNotEmpty) {
      final firstCat = categories.first as Map<String, dynamic>;
      categoryName = (firstCat['nameFr'] as String?) ?? 'Artisanat';
    }

    final newEvent = <String, dynamic>{
      'id': 'evt-${DateTime.now().millisecondsSinceEpoch}',
      'providerId': providerId,
      'slug': slug,
      'businessName': businessName,
      'channel': channel.toUpperCase(),
      'categoryName': categoryName,
      'hasReview': false,
      'contactedAt': DateTime.now().toIso8601String(),
    };

    _demoContactEvents
      ..removeWhere(
        (e) =>
            (e['providerId'] == providerId || e['slug'] == slug) &&
            e['channel'] == channel.toUpperCase(),
      )
      ..insert(0, newEvent);

    return newEvent;
  }

  static void reset() {
    _demoFavorites = _initialFavorites.map(Map<String, dynamic>.from).toList();
    _providerReviews.clear();
    _demoContactEvents = _initialContactEvents
        .map(Map<String, dynamic>.from)
        .toList();
  }

  static const userClient = <String, dynamic>{
    'id': 'usr-demo-client',
    'phone': '+21698123456',
    'role': 'CLIENT',
    'name': 'Ahmed Ben Ali',
  };

  static const userProvider = <String, dynamic>{
    'id': 'usr-demo-pro',
    'phone': '+21620654321',
    'role': 'PROVIDER',
    'name': 'Sami Mansour',
  };

  static const providerMe = <String, dynamic>{
    'id': 'prov-1',
    'slug': 'sami-mansour-electricite',
    'businessName': 'Sami Mansour Électricité',
    'headline': 'Électricien qualifié BTP & dépannage urgent 24/7',
    'bio':
        'Plus de 12 ans d’expérience dans les installations '
        'électriques neuves et dépannages sur Sousse.',
    'yearsExperience': 12,
    'whatsappPhone': '+21620654321',
    'publicPhone': '+21620654321',
    'spokenLanguages': ['AR', 'FR'],
    'baseGovernorateId': 'gov-sousse',
    'baseDelegationId': 'del-sousse-v',
    'latitude': 35.8256,
    'longitude': 10.6369,
    'publicationStatus': 'PUBLISHED',
    'availabilityStatus': 'AVAILABLE',
    'availableAgainAt': '2026-09-08T08:00:00.000Z',
    'acceptsEmergency': true,
    'workingHours': <String, dynamic>{},
    'isVerified': true,
    'verifiedAt': '2026-01-15T10:00:00.000Z',
    'ratingAvg': 4.9,
    'ratingCount': 28,
    'totalProfileViews': 142,
    'totalContacts': 42,
    'completionScore': 95,
    'rankingScore': 9.2,
    'lastActiveAt': '2026-09-07T14:30:00.000Z',
    'createdAt': '2025-06-10T09:00:00.000Z',
    'updatedAt': '2026-09-07T14:30:00.000Z',
  };

  static const providerStats = <String, dynamic>{
    'totals': {
      'profileViews': 142,
      'uniqueProfileViews': 98,
      'contacts': 42,
      'contactsByChannel': {
        'phone': 24,
        'whatsapp': 18,
      },
      'viewToContactRatio': 0.29,
    },
    'series': [
      {
        'date': '2026-09-01T00:00:00.000Z',
        'profileViews': 18,
        'uniqueProfileViews': 12,
        'contacts': 5,
      },
      {
        'date': '2026-09-02T00:00:00.000Z',
        'profileViews': 24,
        'uniqueProfileViews': 16,
        'contacts': 7,
      },
      {
        'date': '2026-09-03T00:00:00.000Z',
        'profileViews': 19,
        'uniqueProfileViews': 14,
        'contacts': 6,
      },
      {
        'date': '2026-09-04T00:00:00.000Z',
        'profileViews': 31,
        'uniqueProfileViews': 22,
        'contacts': 10,
      },
      {
        'date': '2026-09-05T00:00:00.000Z',
        'profileViews': 22,
        'uniqueProfileViews': 15,
        'contacts': 6,
      },
      {
        'date': '2026-09-06T00:00:00.000Z',
        'profileViews': 15,
        'uniqueProfileViews': 10,
        'contacts': 4,
      },
      {
        'date': '2026-09-07T00:00:00.000Z',
        'profileViews': 13,
        'uniqueProfileViews': 9,
        'contacts': 4,
      },
    ],
  };
}
