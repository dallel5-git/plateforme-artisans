import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sanaya/core/api/api_client_provider.dart';
import 'package:sanaya/features/onboarding/data/onboarding_draft_store.dart';
import 'package:sanaya/features/onboarding/data/onboarding_repository.dart';

final onboardingRepositoryProvider = Provider<OnboardingRepository>(
  (ref) => OnboardingRepository(ref.watch(defaultApiProvider)),
);

final onboardingDraftStoreProvider = Provider<OnboardingDraftStore>(
  (ref) => SharedPreferencesOnboardingDraftStore(),
);
