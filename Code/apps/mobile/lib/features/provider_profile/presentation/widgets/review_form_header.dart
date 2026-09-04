import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:sanaya/app/providers.dart';
import 'package:sanaya/core/theme/app_colors.dart';
import 'package:sanaya/core/theme/app_spacing.dart';
import 'package:sanaya/core/theme/app_text.dart';
import 'package:sanaya/core/widgets/provider_avatar.dart';

const double _kAvatarSize = 48;

/// En-tête d'identité du formulaire d'avis (FM-30) : rappelle qui l'on
/// note avant la première étoile — vignette (repli FM-29 si aucune photo),
/// raison sociale, badge « Contact vérifié ». Pas de « il y a N jours » :
/// aucun champ de date de contact n'est exposé par le contrat de fiche
/// public (P3, la fraîcheur n'est pas recalculée côté Dart) — voir issue.
class ReviewFormHeader extends ConsumerWidget {
  const ReviewFormHeader({
    required this.businessName,
    super.key,
    this.avatarUrl,
  });

  final String businessName;
  final String? avatarUrl;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final colors = context.colors;
    final locale = Localizations.localeOf(context);
    final t = ref.watch(translationsProvider);

    return Row(
      children: [
        ProviderAvatar(url: avatarUrl, size: _kAvatarSize),
        const SizedBox(width: AppSpacing.md),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                businessName,
                style: AppText.bodyStrong(
                  locale,
                ).copyWith(color: colors.textPrimary),
                overflow: TextOverflow.ellipsis,
              ),
              const SizedBox(height: AppSpacing.xxs),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: AppSpacing.xs,
                  vertical: AppSpacing.xxs,
                ),
                decoration: BoxDecoration(
                  color: colors.verifiedSubtle,
                  borderRadius: const BorderRadius.all(AppRadius.pill),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(Icons.check, size: 10, color: colors.verified),
                    const SizedBox(width: 2),
                    Text(
                      t.provider.profile.verifiedContact,
                      style: AppText.caption(locale).copyWith(
                        color: colors.verified,
                        height: 1.1,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
