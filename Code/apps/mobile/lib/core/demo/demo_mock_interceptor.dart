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

    // 2. Gouvernorats & délégations
    if (path.contains('/v1/governorates') &&
        path.contains('/delegations') &&
        method == 'GET') {
      final segments = options.uri.pathSegments;
      final govId = segments.length >= 2 ? segments[segments.length - 2] : '';
      final govs =
          DemoData.governorates['governorates'] as List<dynamic>? ?? [];
      final match = govs.firstWhere(
        (g) => (g as Map)['id'] == govId,
        orElse: () => govs.isNotEmpty ? govs.first : <String, dynamic>{},
      ) as Map<String, dynamic>;
      final delegations = match['delegations'] as List<dynamic>? ?? [];
      handler.resolve(_ok(options, {'delegations': delegations}));
      return;
    }
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
      final query = (options.queryParameters['query'] ??
              options.extra['query'])
          as String?;

      final data = DemoData.searchResponse(
        category: category,
        governorate: governorate,
        verified: verified ? true : null,
        minRating: minRating,
        query: query,
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
      final reqData = options.data is Map<String, dynamic>
          ? options.data as Map<String, dynamic>
          : <String, dynamic>{};
      final providerIdOrSlug = _extractSlug(path);
      final rating = (reqData['rating'] as num?)?.toInt() ?? 5;
      final comment = reqData['comment'] as String?;
      final createdReview = DemoData.addReview(
        providerIdOrSlug,
        rating: rating,
        comment: comment,
      );
      handler.resolve(
        Response(
          requestOptions: options,
          statusCode: 201,
          data: createdReview,
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
      final segments = options.uri.pathSegments;
      var providerId = '';
      if (segments.isNotEmpty && segments.last != 'favorites') {
        providerId = segments.last;
      } else if (options.data is Map &&
          (options.data as Map)['providerId'] != null) {
        providerId = (options.data as Map)['providerId'].toString();
      }
      if (providerId.isEmpty) providerId = 'prov-1';
      DemoData.addFavorite(providerId);
      handler.resolve(
        Response(
          requestOptions: options,
          statusCode: method == 'POST' ? 201 : 200,
          data: {
            'providerId': providerId,
            'createdAt': DateTime.now().toIso8601String(),
          },
        ),
      );
      return;
    }
    if (path.contains('/v1/favorites') && method == 'DELETE') {
      final segments = options.uri.pathSegments;
      final providerId = segments.isNotEmpty ? segments.last : '';
      if (providerId.isNotEmpty && providerId != 'favorites') {
        DemoData.removeFavorite(providerId);
      }
      handler.resolve(Response(requestOptions: options, statusCode: 200));
      return;
    }

    // 8. Événements de contact (historique & envoi)
    if (path.contains('contact-events') && method == 'GET') {
      handler.resolve(_ok(options, DemoData.contactEvents));
      return;
    }
    if (path.contains('contact-events') && method == 'POST') {
      final reqMap = options.data is Map<String, dynamic>
          ? options.data as Map<String, dynamic>
          : <String, dynamic>{};
      final providerId = (reqMap['providerId'] as String?) ?? 'prov-1';
      final channel = (reqMap['channel'] as String?) ?? 'PHONE';
      handler.resolve(
        Response(
          requestOptions: options,
          statusCode: 201,
          data: {
            'contactEventId':
                'evt-new-${DateTime.now().millisecondsSinceEpoch}',
            'providerId': providerId,
            'channel': channel,
            'phone': '+21698123456',
            'whatsappMessage': 'Bonjour, je vous contacte via Sanaya.',
            'deduplicated': false,
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
