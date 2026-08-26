import 'package:sanaya/core/api/generated/api.dart';

/// Alias de lisibilité — même type que celui généré par openapi-generator,
/// pas de redéclaration d'un type de domaine (cf. CLAUDE.md racine, P4).
typedef Governorate = V1GovernoratesGet200ResponseGovernoratesInner;

/// Accès BE-14 : arbre de catégories et référentiel des gouvernorats.
/// Aucune règle métier ici (P3) — un simple passage par le client généré.
class CatalogRepository {
  CatalogRepository(this._api);

  final DefaultApi _api;

  /// Arbre complet des catégories (FR/AR), jamais une liste codée en dur —
  /// critère d'acceptation FM-06.
  Future<List<CategoryTreeNode>> fetchCategories() async {
    final response = await _api.v1CategoriesGet();
    return response.data!.categories.toList();
  }

  /// Référentiel des gouvernorats, trié par `sortOrder` (ordre d'affichage
  /// déjà décidé côté API, pas recalculé ici).
  Future<List<Governorate>> fetchGovernorates() async {
    final response = await _api.v1GovernoratesGet();
    final governorates = response.data!.governorates.toList()
      ..sort((a, b) => a.sortOrder.compareTo(b.sortOrder));
    return governorates;
  }
}
