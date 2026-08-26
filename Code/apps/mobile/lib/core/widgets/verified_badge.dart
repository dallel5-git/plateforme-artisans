import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:sanaya/app/providers.dart';
import 'package:sanaya/core/theme/app_colors.dart';
import 'package:sanaya/core/theme/app_spacing.dart';
import 'package:sanaya/core/theme/app_text.dart';

/// Pastille « Vérifié » (design-system.html §5). Atteste l'identité (CIN),
/// jamais le plan payant — ADR-002 : ce widget ne prend et ne lit aucune
/// information de `Subscription`/`Plan`. C'est à l'écran appelant de décider
/// de l'inclure, via `if (provider.isVerified) const VerifiedBadge()`.
class VerifiedBadge extends ConsumerWidget {
  const VerifiedBadge({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final colors = context.colors;
    final locale = Localizations.localeOf(context);
    final t = ref.watch(translationsProvider);

    return Container(
      padding: const EdgeInsetsDirectional.symmetric(
        horizontal: AppSpacing.sm,
        vertical: AppSpacing.xxs,
      ),
      decoration: BoxDecoration(
        color: colors.verifiedSubtle,
        borderRadius: const BorderRadius.all(AppRadius.pill),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.check, size: 12, color: colors.verified),
          const SizedBox(width: AppSpacing.xxs),
          Text(
            t.common.widgets.verifiedBadge,
            style: AppText.caption(
              locale,
            ).copyWith(color: colors.verified, height: 1),
          ),
        ],
      ),
    );
  }
}
