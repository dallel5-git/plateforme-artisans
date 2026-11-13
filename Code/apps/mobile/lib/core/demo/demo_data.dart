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
        if (gov == null) return false;
        final govId = gov['id'].toString();
        final matches = govId == governorate ||
            govId.contains(governorate) ||
            governorate.contains(govId.replaceFirst('gov-', ''));
        if (!matches) return false;
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
      if (p['slug'] == slug) {
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

    copy['coverageAreas'] = [
      {
        'governorate': {
          'slug': 'sousse',
          'nameFr': 'Sousse',
          'nameAr': 'سوسة',
        },
        'delegation': {
          'slug': 'sousse-ville',
          'nameFr': 'Sousse Ville',
          'nameAr': 'سوسة المدينة',
        },
        'travelFee': 0,
      },
    ];

    copy['gallery'] = [
      {
        'id': 'img-1',
        'url':
            'https://images.unsplash.com/photo-1621905251189-08b45d6a269e'
            '?auto=format&fit=crop&w=800&q=80',
        'width': 800,
        'height': 600,
        'blurhash': 'L6PZfSi_.AyE_3t7t7R**0o#DgR4',
        'caption': 'Tableau électrique aux normes',
        'category': {
          'slug': 'electricite',
          'nameFr': 'Électricité',
          'nameAr': 'كهرباء',
        },
      },
    ];

    copy['reviewAggregate'] = {
      'average': copy['ratingAvg'] ?? 4.9,
      'count': copy['ratingCount'] ?? 32,
      'breakdown': {
        '1': 0,
        '2': 0,
        '3': 1,
        '4': 5,
        '5': 26,
      },
    };

    copy['offerings'] = <dynamic>[];
    return copy;
  }

  static Map<String, dynamic> providerReviews(String slug) {
    return {
      'items': [
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
          'comment':
              'Bon travail dans l’ensemble. Matériel de qualité installé.',
          'isVerifiedContact': true,
          'createdAt': '2026-08-15T09:00:00.000Z',
        },
      ],
      'nextCursor': '',
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
    'nextCursor': '',
  };

  static const contactEvents = <String, dynamic>{
    'items': [
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
    ],
    'nextCursor': '',
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
