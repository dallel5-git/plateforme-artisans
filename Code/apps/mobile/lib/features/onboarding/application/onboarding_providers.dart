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

/// Statut de publication de l'artisan connecté — utilisé par la garde de
/// route `/pro/*` (FM-24, lib/app/router.dart) pour décider dashboard vs
/// onboarding. Volontairement PAS `autoDispose` : doit survivre à la sortie
/// de l'écran d'onboarding, contrairement à `onboardingProvider` ci-dessus.
/// Valeur initiale réelle injectée via overrideWith dans main() (préférence
/// persistée, cf. lib/features/onboarding/data/publication_status_persistence.dart) ;
/// ce défaut ne sert qu'aux contextes sans override (tests unitaires isolés).
final hasPublishedProfileProvider = StateProvider<bool>((ref) => false);
