import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sanaya/app/providers.dart';
import 'package:sanaya/core/theme/app_colors.dart';
import 'package:sanaya/core/theme/app_spacing.dart';
import 'package:sanaya/core/theme/app_text.dart';
import 'package:sanaya/core/widgets/app_button.dart';
import 'package:sanaya/core/widgets/app_card.dart';

/// Carte de solde de crédits de l'artisan (maquettes A6 / C3 — issue #237 / FM-40).
///
/// Affiche le solde actuel (fixé à 0 tant que `BE-34` n'existe pas) et un
/// bouton « Acheter » qui ouvre un dialogue informatif « Bientôt disponible »,
/// sans aucun appel réseau de paiement (dépendance EP-BILLING / ADR-004).
class CreditBalanceCard extends ConsumerWidget {
  const CreditBalanceCard({
    this.creditsCount = 0,
    this.onBuyPressed,
    super.key,
  });

  final int creditsCount;
  final VoidCallback? onBuyPressed;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final colors = context.colors;
    final locale = Localizations.localeOf(context);
    final t = ref.watch(translationsProvider);

    return AppCard(
      padding: const EdgeInsets.all(AppSpacing.lg),
      child: Row(
        children: [
          Container(
            width: AppLayout.touchTarget,
            height: AppLayout.touchTarget,
            decoration: BoxDecoration(
              color: colors.accentSubtle,
              shape: BoxShape.circle,
            ),
            child: Icon(
              Icons.bolt_rounded,
              color: colors.accent,
              size: AppIconSize.lg,
            ),
          ),
          const SizedBox(width: AppSpacing.md),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  t.billing.creditsBalance,
                  style: AppText.small(locale).copyWith(
                    color: colors.textSecondary,
                  ),
                ),
                const SizedBox(height: AppSpacing.xxs),
                Text(
                  t.billing.creditsCount(count: creditsCount),
                  style: AppText.h2(locale).copyWith(
                    color: colors.textPrimary,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: AppSpacing.sm),
          AppButton(
            label: t.billing.buyCredits,
            variant: AppButtonVariant.secondary,
            size: AppButtonSize.small,
            onPressed: onBuyPressed ??
                () => showUpcomingFeatureDialog(context, ref),
          ),
        ],
      ),
    );
  }
}

/// Affiche un dialogue d'information standard pour les fonctionnalités
/// monétisation en cours de cadrage (coquille visuelle FM-40).
Future<void> showUpcomingFeatureDialog(
  BuildContext context,
  WidgetRef ref,
) async {
  final colors = context.colors;
  final locale = Localizations.localeOf(context);
  final t = ref.read(translationsProvider);

  await showDialog<void>(
    context: context,
    builder: (dialogContext) => AlertDialog(
      backgroundColor: colors.surfaceRaised,
      title: Text(
        t.billing.featureUpcomingTitle,
        style: AppText.h3(locale).copyWith(color: colors.textPrimary),
      ),
      content: Text(
        t.billing.featureUpcomingMessage,
        style: AppText.body(locale).copyWith(color: colors.textSecondary),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(dialogContext).pop(),
          child: Text(
            t.billing.dialogDismiss,
            style: AppText.bodyStrong(locale).copyWith(color: colors.accent),
          ),
        ),
      ],
    ),
  );
}
