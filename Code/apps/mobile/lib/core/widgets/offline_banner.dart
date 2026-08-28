import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:sanaya/app/providers.dart';
import 'package:sanaya/core/theme/app_colors.dart';
import 'package:sanaya/core/theme/app_spacing.dart';
import 'package:sanaya/core/theme/app_text.dart';
import 'package:sanaya/core/widgets/empty_state.dart';
import 'package:sanaya/core/widgets/error_state.dart';
import 'package:sanaya/core/widgets/verified_badge.dart';

/// Bandeau « Hors ligne » global, non bloquant (`apps/mobile/CLAUDE.md` —
/// réseau dégradé P5) : une bande fine en tête d'écran, pas une reprise en
/// pleine page comme [EmptyState]/[ErrorState] — l'utilisateur continue de
/// consulter les résultats mis en cache pendant que le bandeau reste visible
/// au-dessus. Texte fixe et déjà traduit en interne (comme [VerifiedBadge],
/// ADR-002) : c'est un concept unique app-wide, pas un message par écran.
/// C'est à l'écran appelant de décider de l'afficher (état de connectivité)
/// et, via [onDismiss], de le masquer.
class OfflineBanner extends ConsumerWidget {
  const OfflineBanner({super.key, this.onDismiss});

  final VoidCallback? onDismiss;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final colors = context.colors;
    final locale = Localizations.localeOf(context);
    final t = ref.watch(translationsProvider);

    return Container(
      padding: const EdgeInsetsDirectional.symmetric(
        horizontal: AppSpacing.md,
        vertical: AppSpacing.sm,
      ),
      decoration: BoxDecoration(
        color: colors.pendingSubtle,
        borderRadius: const BorderRadius.all(AppRadius.md),
      ),
      child: Row(
        children: [
          Text(
            '📡',
            style: AppText.body(locale).copyWith(color: colors.pending),
          ),
          const SizedBox(width: AppSpacing.sm),
          Expanded(
            child: Text(
              t.common.widgets.offlineBanner.message,
              style: AppText.small(locale).copyWith(color: colors.textPrimary),
            ),
          ),
          if (onDismiss != null) ...[
            const SizedBox(width: AppSpacing.sm),
            GestureDetector(
              // GestureDetector plutôt qu'InkWell : pas de ripple nécessaire
              // pour ce lien texte discret, et pas de Material ambiant sur
              // ce widget (même contrainte que ProviderCard) — inutile
              // d'en introduire un juste pour un effet visuel qu'on ne veut
              // pas ici.
              onTap: onDismiss,
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: AppSpacing.xs,
                  vertical: AppSpacing.xxs,
                ),
                child: Text(
                  t.common.widgets.offlineBanner.dismiss,
                  style: AppText.small(
                    locale,
                  ).copyWith(color: colors.accent, fontWeight: FontWeight.w600),
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }
}
