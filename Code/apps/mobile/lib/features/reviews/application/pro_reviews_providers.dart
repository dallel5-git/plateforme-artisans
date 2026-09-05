import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sanaya/features/onboarding/application/onboarding_repository_provider.dart';
import 'package:sanaya/features/onboarding/data/onboarding_repository.dart';

/// Charge le profil artisan de l'utilisateur connecté via GET /v1/providers/me
/// (BE-44).
///
/// Utilisé par les écrans de l'Espace Pro (FM-37, FM-38, FM-39) pour accéder
/// aux informations propres à l'artisan (slug, notes, nom commercial, statut).
/// Renvoie `null` si aucun profil artisan n'a encore été créé.
final AutoDisposeFutureProvider<ProviderMe?> myProviderProfileProvider =
    FutureProvider.autoDispose<ProviderMe?>((ref) async {
      final repo = ref.watch(onboardingRepositoryProvider);
      return repo.getMyProfile();
    });

/// Extrait le slug de l'artisan connecté à partir de
/// [myProviderProfileProvider].
///
/// Permet à l'écran des avis reçus (FM-39) d'interroger
/// `providerReviewsProvider(slug)` sans dupliquer la résolution du profil.
final AutoDisposeFutureProvider<String?> myProviderSlugProvider =
    FutureProvider.autoDispose<String?>((ref) async {
      final profile = await ref.watch(myProviderProfileProvider.future);
      return profile?.slug;
    });
