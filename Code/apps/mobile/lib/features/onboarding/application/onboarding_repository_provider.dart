import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sanaya/core/api/api_client_provider.dart';
import 'package:sanaya/features/onboarding/data/onboarding_repository.dart';

/// Provider du repository d'onboarding.
///
/// Séparé dans ce fichier pour éviter la dépendance circulaire entre
/// le notifier et le fichier providers :
/// - le notifier importe ce fichier pour lire le repo via `ref`
/// - `onboarding_providers.dart` importe ce fichier + le notifier
/// → pas de cycle.
///
/// Dans les tests : override via
/// `onboardingRepositoryProvider.overrideWithValue(mockRepo)`.
final Provider<OnboardingRepository> onboardingRepositoryProvider =
    Provider<OnboardingRepository>(
      (ref) => OnboardingRepository(ref.watch(defaultApiProvider)),
    );
