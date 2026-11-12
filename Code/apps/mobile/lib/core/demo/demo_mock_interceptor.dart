import 'package:dio/dio.dart';
import 'package:sanaya/core/demo/demo_data.dart';
import 'package:sanaya/core/demo/demo_mode_provider.dart';

/// Intercepteur Dio simulant le serveur Fastify lorsque le Mode Démo
/// est actif. Découplage strict : aucun mock n'est injecté dans les
/// repositories ou modèles de production.
class DemoMockInterceptor extends Interceptor {
  DemoMockInterceptor({
    required this.isDemoMode,
    required this.getDemoRole,
  });

  final bool Function() isDemoMode;
  final DemoRole Function() getDemoRole;

  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    if (!isDemoMode()) {
      handler.next(options);
      return;
    }

    final path = options.path;
    final method = options.method.toUpperCase();

    // 1. Catégories
    if (path.contains('/v1/categories') && method == 'GET') {
      handler.resolve(_ok(options, DemoData.categories));
      return;
    }

    // 2. Gouvernorats
    if (path.contains('/v1/governorates') && method == 'GET') {
      handler.resolve(_ok(options, DemoData.governorates));
      return;
    }

    // 3. Recherche d'artisans
    if (path.contains('/v1/providers/search') && method == 'GET') {
      final category = options.queryParameters['category'] as String?;
      final governorate = options.queryParameters['governorate'] as String?;
      final verified = options.queryParameters['verified'] == 'true';
      final minRating = options.queryParameters['minRating'] != null
          ? num.tryParse(options.queryParameters['minRating'].toString())
          : null;

      final data = DemoData.searchResponse(
        category: category,
        governorate: governorate,
        verified: verified ? true : null,
        minRating: minRating,
      );
      handler.resolve(_ok(options, data));
      return;
    }

    // 4. Liste des avis d'un artisan
    if (path.contains('/reviews') && method == 'GET') {
      final slug = _extractSlug(path);
      handler.resolve(_ok(options, DemoData.providerReviews(slug)));
      return;
    }

    // 5. Dépôt d'avis
    if (path.contains('/reviews') && method == 'POST') {
      handler.resolve(
        Response(
          requestOptions: options,
          statusCode: 201,
          data: {
            'id': 'rev-new-${DateTime.now().millisecondsSinceEpoch}',
            'authorName': 'Vous (Client)',
            'rating': 5,
            'comment': 'Avis publié en mode démo',
            'createdAt': DateTime.now().toIso8601String(),
          },
        ),
      );
      return;
    }

    // 6. Fiche publique artisan
    if (path.contains('/v1/providers/') &&
        !path.contains('/me') &&
        method == 'GET') {
      final slug = _extractSlug(path);
      final detail = DemoData.providerDetail(slug);
      if (detail != null) {
        handler.resolve(_ok(options, detail));
        return;
      }
    }

    // 7. Favoris
    if (path.contains('/v1/favorites') && method == 'GET') {
      handler.resolve(_ok(options, DemoData.favorites));
      return;
    }
    if (path.contains('/v1/favorites') &&
        (method == 'POST' || method == 'PUT')) {
      handler.resolve(Response(requestOptions: options, statusCode: 201));
      return;
    }
    if (path.contains('/v1/favorites') && method == 'DELETE') {
      handler.resolve(Response(requestOptions: options, statusCode: 200));
      return;
    }

    // 8. Événements de contact (historique & envoi)
    if (path.contains('contact-events') && method == 'GET') {
      handler.resolve(_ok(options, DemoData.contactEvents));
      return;
    }
    if (path.contains('contact-events') && method == 'POST') {
      handler.resolve(
        Response(
          requestOptions: options,
          statusCode: 201,
          data: {
            'id': 'evt-new-${DateTime.now().millisecondsSinceEpoch}',
            'channel': options.data is Map
                ? (options.data as Map)['channel'] ?? 'PHONE'
                : 'PHONE',
            'contactedAt': DateTime.now().toIso8601String(),
          },
        ),
      );
      return;
    }

    // 9. Utilisateur authentifié (GET /auth/me)
    if (path.contains('/v1/auth/me') && method == 'GET') {
      final role = getDemoRole();
      if (role == DemoRole.guest) {
        handler.reject(
          DioException(
            requestOptions: options,
            response: Response(
              requestOptions: options,
              statusCode: 401,
              data: {'message': 'Non authentifié en mode invité'},
            ),
            type: DioExceptionType.badResponse,
          ),
        );
        return;
      }
      if (role == DemoRole.provider) {
        handler.resolve(_ok(options, DemoData.userProvider));
      } else {
        handler.resolve(_ok(options, DemoData.userClient));
      }
      return;
    }

    // 10. Profil Pro (/providers/me)
    if (path.contains('/v1/providers/me') &&
        !path.contains('/stats') &&
        method == 'GET') {
      handler.resolve(_ok(options, DemoData.providerMe));
      return;
    }

    // 11. Statistiques Pro (/providers/me/stats)
    if (path.contains('/v1/providers/me/stats') && method == 'GET') {
      handler.resolve(_ok(options, DemoData.providerStats));
      return;
    }

    // 12. Mise à jour disponibilité ou profil Pro
    if (path.contains('/v1/providers/me') &&
        (method == 'PATCH' || method == 'PUT')) {
      handler.resolve(_ok(options, DemoData.providerMe));
      return;
    }

    handler.next(options);
  }

  Response<Map<String, dynamic>> _ok(
    RequestOptions options,
    Map<String, dynamic> data,
  ) {
    return Response<Map<String, dynamic>>(
      requestOptions: options,
      statusCode: 200,
      data: data,
    );
  }

  String _extractSlug(String path) {
    final segments = Uri.parse(path).pathSegments;
    final provIndex = segments.indexOf('providers');
    if (provIndex != -1 && segments.length > provIndex + 1) {
      return segments[provIndex + 1];
    }
    return '';
  }
}
