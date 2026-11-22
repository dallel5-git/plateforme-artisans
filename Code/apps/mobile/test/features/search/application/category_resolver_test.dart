import 'package:flutter_test/flutter_test.dart';
import 'package:sanaya/core/api/generated/api.dart';
import 'package:sanaya/features/search/application/category_resolver.dart';

CategoryTreeNode _node({
  required String slug,
  required String nameFr,
  required String nameAr,
}) => CategoryTreeNode(
  (b) => b
    ..id = 'cat-$slug'
    ..slug = slug
    ..nameFr = nameFr
    ..nameAr = nameAr
    ..descriptionFr = ''
    ..descriptionAr = ''
    ..iconKey = slug
    ..colorHex = '#3B6FE0'
    ..sortOrder = 1,
);

void main() {
  final categories = [
    _node(slug: 'plomberie', nameFr: 'Plomberie', nameAr: 'سباكة'),
    _node(slug: 'electricite', nameFr: 'Électricité', nameAr: 'كهرباء'),
    _node(slug: 'peinture', nameFr: 'Peinture', nameAr: 'دهانة'),
    _node(slug: 'menuiserie', nameFr: 'Menuiserie', nameAr: 'نجارة'),
    _node(slug: 'climatisation', nameFr: 'Climatisation', nameAr: 'مكيفات'),
    _node(slug: 'serrurerie', nameFr: 'Serrurerie', nameAr: 'أقفال'),
  ];

  group('CategoryResolver.normalize', () {
    test('supprime accents et minusculise le français', () {
      expect(CategoryResolver.normalize('Électricité'), 'electricite');
      expect(CategoryResolver.normalize('  PLOMBIER  '), 'plombier');
      expect(CategoryResolver.normalize('Chauffe-eau'), 'chauffe-eau');
    });

    test('normalise les lettres arabes', () {
      expect(CategoryResolver.normalize('أقفال'), 'اقفال');
      expect(CategoryResolver.normalize('سباكة'), 'سباكه');
    });
  });

  group('CategoryResolver.resolveCategory', () {
    test('résout par nom FR exact ou avec accent', () {
      final res1 = CategoryResolver.resolveCategory('plomberie', categories);
      expect(res1?.slug, 'plomberie');

      final res2 = CategoryResolver.resolveCategory('électricité', categories);
      expect(res2?.slug, 'electricite');
    });

    test('résout par nom arabe', () {
      final res1 = CategoryResolver.resolveCategory('سباكة', categories);
      expect(res1?.slug, 'plomberie');

      final res2 = CategoryResolver.resolveCategory('كهرباء', categories);
      expect(res2?.slug, 'electricite');
    });

    test('résout par synonymes et termes métier (FR)', () {
      expect(
        CategoryResolver.resolveCategory('plombier', categories)?.slug,
        'plomberie',
      );
      expect(
        CategoryResolver.resolveCategory('fuite', categories)?.slug,
        'plomberie',
      );
      expect(
        CategoryResolver.resolveCategory('robinet', categories)?.slug,
        'plomberie',
      );
      expect(
        CategoryResolver.resolveCategory('electricien', categories)?.slug,
        'electricite',
      );
      expect(
        CategoryResolver.resolveCategory('prise', categories)?.slug,
        'electricite',
      );
      expect(
        CategoryResolver.resolveCategory('peintre', categories)?.slug,
        'peinture',
      );
      expect(
        CategoryResolver.resolveCategory('clim', categories)?.slug,
        'climatisation',
      );
      expect(
        CategoryResolver.resolveCategory('serrurier', categories)?.slug,
        'serrurerie',
      );
      expect(
        CategoryResolver.resolveCategory('cle', categories)?.slug,
        'serrurerie',
      );
    });

    test('résout par synonymes et termes métier (AR)', () {
      expect(
        CategoryResolver.resolveCategory('سباك', categories)?.slug,
        'plomberie',
      );
      expect(
        CategoryResolver.resolveCategory('كهربائي', categories)?.slug,
        'electricite',
      );
      expect(
        CategoryResolver.resolveCategory('دهان', categories)?.slug,
        'peinture',
      );
      expect(
        CategoryResolver.resolveCategory('نجار', categories)?.slug,
        'menuiserie',
      );
    });

    test('résout une phrase ou requête multi-mots', () {
      expect(
        CategoryResolver.resolveCategory(
          'recherche un bon plombier',
          categories,
        )?.slug,
        'plomberie',
      );
      expect(
        CategoryResolver.resolveCategory('panne electricite', categories)?.slug,
        'electricite',
      );
    });

    test('renvoie null si aucune catégorie ne correspond', () {
      expect(
        CategoryResolver.resolveCategory('inconnu xyz', categories),
        isNull,
      );
      expect(CategoryResolver.resolveCategory('', categories), isNull);
    });
  });

  group('CategoryResolver.getSuggestions', () {
    test('suggère les catégories commençant par le préfixe', () {
      final suggestions = CategoryResolver.getSuggestions('plo', categories);
      expect(suggestions.map((c) => c.slug), contains('plomberie'));
    });

    test('suggère selon les synonymes', () {
      final suggestions = CategoryResolver.getSuggestions('fuit', categories);
      expect(suggestions.map((c) => c.slug), contains('plomberie'));
    });

    test('renvoie une liste vide pour une saisie trop courte', () {
      expect(CategoryResolver.getSuggestions('p', categories), isEmpty);
    });
  });
}
