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
        'descriptionFr':
            'Installation, recharge gaz, entretien et nettoyage',
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
        'sortOrder': 1,
        'delegations': [
          {'id': 'del-marsa', 'nameFr': 'La Marsa', 'nameAr': 'المرسى'},
          {'id': 'del-carthage', 'nameFr': 'Carthage', 'nameAr': 'قرطاج'},
          {'id': 'del-menzah', 'nameFr': 'El Menzah', 'nameAr': 'المنزه'},
        ],
      },
      {
        'id': 'gov-sousse',
        'code': 'SOU',
        'nameFr': 'Sousse',
        'nameAr': 'سوسة',
        'sortOrder': 2,
        'delegations': [
          {
            'id': 'del-sousse-v',
            'nameFr': 'Sousse Ville',
            'nameAr': 'سوسة المدينة',
          },
          {
            'id': 'del-kantaoui',
            'nameFr': 'Hammam Sousse',
            'nameAr': 'حمام سوسة',
          },
          {'id': 'del-sahloul', 'nameFr': 'Sahloul', 'nameAr': 'سهلول'},
        ],
      },
      {
        'id': 'gov-ariana',
        'code': 'ARI',
        'nameFr': 'Ariana',
        'nameAr': 'أريانة',
        'sortOrder': 3,
        'delegations': [
          {
            'id': 'del-ariana-v',
            'nameFr': 'Ariana Ville',
            'nameAr': 'أريانة المدينة',
          },
          {'id': 'del-ennasr', 'nameFr': 'Ennasr', 'nameAr': 'النصر'},
          {'id': 'del-raoued', 'nameFr': 'Raoued', 'nameAr': 'رواد'},
        ],
      },
      {
        'id': 'gov-sfax',
        'code': 'SFA',
        'nameFr': 'Sfax',
        'nameAr': 'صفاقس',
        'sortOrder': 4,
        'delegations': [
          {
            'id': 'del-sfax-v',
            'nameFr': 'Sfax Ville',
            'nameAr': 'صفاقس المدينة',
          },
          {
            'id': 'del-sakiet',
            'nameFr': 'Sakiet Ezzit',
            'nameAr': 'ساقية الزيت',
          },
        ],
      },
      {
        'id': 'gov-ben-arous',
        'code': 'BEN',
        'nameFr': 'Ben Arous',
        'nameAr': 'بن عروس',
        'sortOrder': 5,
        'delegations': [
          {'id': 'del-megrine', 'nameFr': 'Mégrine', 'nameAr': 'مقرين'},
          {'id': 'del-rades', 'nameFr': 'Radès', 'nameAr': 'رادس'},
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
      'spokenLanguages': ['ar', 'fr'],
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
      'spokenLanguages': ['ar', 'fr'],
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
      'spokenLanguages': ['ar', 'fr'],
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
      'spokenLanguages': ['ar', 'fr'],
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
      'spokenLanguages': ['ar', 'fr'],
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
      'spokenLanguages': ['ar', 'fr'],
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
  ];

  static Map<String, dynamic> searchResponse({
    String? category,
    String? governorate,
    bool? verified,
    num? minRating,
  }) {
    final filtered = providersList.where((p) {
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
        if (gov == null || gov['id'] != governorate) return false;
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
      'nextCursor': null,
    };
  }

  static Map<String, dynamic>? providerDetail(String slug) {
    for (final p in providersList) {
      if (p['slug'] == slug) return p;
    }
    return providersList.isNotEmpty ? providersList.first : null;
  }

  static Map<String, dynamic> providerReviews(String slug) {
    return {
      'items': [
        {
          'id': 'rev-1',
          'authorName': 'Karim M.',
          'rating': 5,
          'comment':
              'Excellent travail ! Très ponctuel, travail soigné et tarif honnête. Je recommande vivement pour vos travaux.',
          'createdAt': '2026-09-01T10:30:00.000Z',
          'reply': null,
        },
        {
          'id': 'rev-2',
          'authorName': 'Fatma B.',
          'rating': 5,
          'comment':
              'Intervention rapide un dimanche matin pour un dépannage urgent. Artisan très poli et professionnel.',
          'createdAt': '2026-08-28T14:15:00.000Z',
          'reply': null,
        },
        {
          'id': 'rev-3',
          'authorName': 'Moncef T.',
          'rating': 4,
          'comment':
              'Bon travail dans l’ensemble. Matériel de qualité installé proprement.',
          'createdAt': '2026-08-15T09:00:00.000Z',
          'reply': null,
        },
      ],
      'nextCursor': null,
    };
  }

  static const favorites = <String, dynamic>{
    'items': [
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
    ],
    'nextCursor': null,
  };

  static const contactEvents = <String, dynamic>{
    'items': [
      {
        'id': 'evt-1',
        'providerId': 'prov-1',
        'providerSlug': 'sami-mansour-electricite',
        'providerName': 'Sami Mansour',
        'channel': 'PHONE',
        'categoryName': 'Électricité',
        'hasReview': true,
        'contactedAt': '2026-09-01T10:00:00.000Z',
      },
      {
        'id': 'evt-2',
        'providerId': 'prov-2',
        'providerSlug': 'hedi-bouazizi-plomberie',
        'providerName': 'Hedi Bouazizi',
        'channel': 'WHATSAPP',
        'categoryName': 'Plomberie',
        'hasReview': false,
        'contactedAt': '2026-09-04T16:20:00.000Z',
      },
      {
        'id': 'evt-3',
        'providerId': 'prov-6',
        'providerSlug': 'yassine-riahi-serrurerie',
        'providerName': 'Yassine Riahi',
        'channel': 'PHONE',
        'categoryName': 'Serrurerie',
        'hasReview': false,
        'contactedAt': '2026-09-05T20:10:00.000Z',
      },
    ],
    'nextCursor': null,
  };

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
        'Plus de 12 ans d’expérience dans les installations électriques neuves et dépannages sur Sousse.',
    'yearsExperience': 12,
    'spokenLanguages': ['ar', 'fr'],
    'status': 'PUBLISHED',
    'completionScore': 85,
    'availabilityStatus': 'AVAILABLE',
    'acceptsEmergency': true,
  };

  static const providerStats = <String, dynamic>{
    'totals': {
      'profileViews': 142,
      'contactsTotal': 42,
      'contactsByChannel': {
        'phone': 24,
        'whatsapp': 18,
      },
    },
    'series': [
      {'date': '2026-09-01', 'views': 18, 'contacts': 5},
      {'date': '2026-09-02', 'views': 24, 'contacts': 7},
      {'date': '2026-09-03', 'views': 19, 'contacts': 6},
      {'date': '2026-09-04', 'views': 31, 'contacts': 10},
      {'date': '2026-09-05', 'views': 22, 'contacts': 6},
      {'date': '2026-09-06', 'views': 15, 'contacts': 4},
      {'date': '2026-09-07', 'views': 13, 'contacts': 4},
    ],
  };
}
