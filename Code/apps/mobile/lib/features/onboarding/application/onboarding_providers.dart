import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sanaya/features/onboarding/application/onboarding_notifier.dart';
import 'package:sanaya/features/onboarding/application/onboarding_state.dart';

export 'onboarding_notifier.dart';
export 'onboarding_repository_provider.dart';
export 'onboarding_state.dart';

/// Notifier de l'assistant d'onboarding.
/// `autoDispose` : état de session, libéré à la sortie de l'écran.
final AutoDisposeNotifierProvider<OnboardingNotifier, OnboardingState>
onboardingProvider =
    NotifierProvider.autoDispose<OnboardingNotifier, OnboardingState>(
      OnboardingNotifier.new,
    );
