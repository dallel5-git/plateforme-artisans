import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:sanaya/app/providers.dart';
import 'package:sanaya/core/theme/app_colors.dart';
import 'package:sanaya/core/theme/app_spacing.dart';
import 'package:sanaya/core/theme/app_text.dart';
import 'package:sanaya/core/widgets/app_button.dart';
import 'package:sanaya/core/widgets/app_card.dart';
import 'package:sanaya/core/widgets/verified_badge.dart';

/// Écran de célébration post-publication (MOB-029).
///
/// Remplace la redirection abrupte vers le tableau de bord par un écran de
/// félicitations chaleureux confirmant la mise en ligne du profil et
/// introduisant la démarche de vérification d'identité (ADR-002, MOB-030).
class OnboardingCelebrationScreen extends ConsumerWidget {
  const OnboardingCelebrationScreen({
    super.key,
    this.onVerifyNow,
    this.onGoToDashboard,
  });

  /// Callback optionnel pour la vérification immédiate (tests).
  final VoidCallback? onVerifyNow;

  /// Callback optionnel pour accéder au tableau de bord (tests).
  final VoidCallback? onGoToDashboard;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final t = ref.watch(translationsProvider);
    final locale = Localizations.localeOf(context);
    final colors = context.colors;

    return Scaffold(
      backgroundColor: colors.background,
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.symmetric(
            horizontal: AppSpacing.lg,
            vertical: AppSpacing.xl,
          ),
          children: [
            const SizedBox(height: AppSpacing.lg),
            Center(
              child: Container(
                width: 88,
                height: 88,
                decoration: BoxDecoration(
                  color: colors.verifiedSubtle,
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  Icons.celebration_rounded,
                  size: 48,
                  color: colors.verified,
                ),
              ),
            ),
            const SizedBox(height: AppSpacing.xl),
            Text(
              t.onboarding.celebrationTitle,
              textAlign: TextAlign.center,
              style: AppText.h2(locale).copyWith(
                color: colors.textPrimary,
              ),
            ),
            const SizedBox(height: AppSpacing.sm),
            Text(
              t.onboarding.celebrationSubtitle,
              textAlign: TextAlign.center,
              style: AppText.body(locale).copyWith(
                color: colors.textMuted,
              ),
            ),
            const SizedBox(height: AppSpacing.s2xl),
            AppCard(
              padding: const EdgeInsets.all(AppSpacing.lg),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      const VerifiedBadge(),
                      const Spacer(),
                      Icon(
                        Icons.shield_outlined,
                        color: colors.verified,
                        size: 20,
                      ),
                    ],
                  ),
                  const SizedBox(height: AppSpacing.md),
                  Text(
                    t.onboarding.celebrationKycCardTitle,
                    style: AppText.bodyStrong(locale).copyWith(
                      color: colors.textPrimary,
                    ),
                  ),
                  const SizedBox(height: AppSpacing.xs),
                  Text(
                    t.onboarding.celebrationKycCardDescription,
                    style: AppText.small(locale).copyWith(
                      color: colors.textMuted,
                    ),
                  ),
                  const SizedBox(height: AppSpacing.md),
                  _BenefitItem(
                    icon: Icons.verified_user_outlined,
                    label: t.onboarding.celebrationKycBenefitBadge,
                  ),
                  const SizedBox(height: AppSpacing.sm),
                  _BenefitItem(
                    icon: Icons.trending_up_rounded,
                    label: t.onboarding.celebrationKycBenefitRank,
                  ),
                  const SizedBox(height: AppSpacing.sm),
                  _BenefitItem(
                    icon: Icons.bolt_rounded,
                    label: t.onboarding.celebrationKycBenefitFast,
                  ),
                ],
              ),
            ),
            const SizedBox(height: AppSpacing.s2xl),
            AppButton(
              label: t.onboarding.celebrationCtaVerify,
              icon: const Icon(Icons.shield_outlined, size: 20),
              onPressed: () {
                if (onVerifyNow != null) {
                  onVerifyNow!();
                } else {
                  context.go('/pro/verification');
                }
              },
            ),
            const SizedBox(height: AppSpacing.md),
            AppButton(
              label: t.onboarding.celebrationCtaDashboard,
              variant: AppButtonVariant.secondary,
              onPressed: () {
                if (onGoToDashboard != null) {
                  onGoToDashboard!();
                } else {
                  context.go('/pro/dashboard');
                }
              },
            ),
            const SizedBox(height: AppSpacing.lg),
          ],
        ),
      ),
    );
  }
}

class _BenefitItem extends StatelessWidget {
  const _BenefitItem({
    required this.icon,
    required this.label,
  });

  final IconData icon;
  final String label;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final locale = Localizations.localeOf(context);

    return Row(
      children: [
        Icon(
          icon,
          size: 18,
          color: colors.verified,
        ),
        const SizedBox(width: AppSpacing.sm),
        Expanded(
          child: Text(
            label,
            style: AppText.small(locale).copyWith(
              color: colors.textPrimary,
            ),
          ),
        ),
      ],
    );
  }
}
