import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sanaya/app/providers.dart';
import 'package:sanaya/core/api/generated/api.dart';
import 'package:sanaya/core/theme/app_colors.dart';
import 'package:sanaya/core/theme/app_spacing.dart';
import 'package:sanaya/core/theme/app_text.dart';
import 'package:sanaya/features/auth/application/current_user_provider.dart';
import 'package:sanaya/features/provider_profile/presentation/widgets/availability_chip.dart';

/// En-tête du tableau de bord pro (FM-37a, issue #234) :
/// - Salutation « Bonjour, `firstName` » (ou titre fallback si le prénom
///   n'est pas encore disponible — BE-44 non livré, repli sur GET /auth/me).
/// - Badge de disponibilité commutable (en lecture seule ici, cf. FM-38 pour
///   l'écriture avec BE-44).
class DashboardHeader extends ConsumerWidget {
  const DashboardHeader({
    this.availabilityStatus,
    this.onAvailabilityTap,
    super.key,
  });

  final V1ProvidersSlugGet200ResponseAvailabilityStatusEnum? availabilityStatus;
  final VoidCallback? onAvailabilityTap;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final colors = context.colors;
    final locale = Localizations.localeOf(context);
    final t = ref.watch(translationsProvider);

    // `currentUserProvider` lit GET /auth/me — disponible dès que la session
    // est active, indépendamment de BE-44. En loading/error on affiche le
    // titre fallback (jamais d'écran blanc, critère issue #234).
    final userAsync = ref.watch(currentUserProvider);
    String? firstName;
    try {
      firstName = userAsync.valueOrNull?.firstName;
    } on Object {
      firstName = null;
    }

    final greetingText = (firstName != null && firstName.isNotEmpty)
        ? t.dashboard.greeting(name: firstName)
        : t.dashboard.title; // fallback : "Tableau de bord" / "لوحة التحكم"

    return Padding(
      padding: const EdgeInsets.fromLTRB(
        AppSpacing.lg,
        AppSpacing.lg,
        AppSpacing.lg,
        AppSpacing.md,
      ),
      child: Row(
        children: [
          Expanded(
            child: Text(
              greetingText,
              style: AppText.h2(locale).copyWith(color: colors.textPrimary),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ),
          if (availabilityStatus != null) ...[
            const SizedBox(width: AppSpacing.sm),
            if (onAvailabilityTap != null)
              InkWell(
                onTap: onAvailabilityTap,
                borderRadius: const BorderRadius.all(AppRadius.pill),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    AvailabilityChip(status: availabilityStatus!),
                    const SizedBox(width: AppSpacing.xxs),
                    Icon(
                      Icons.expand_more_rounded,
                      size: AppIconSize.sm,
                      color: colors.textSecondary,
                    ),
                  ],
                ),
              )
            else
              AvailabilityChip(status: availabilityStatus!),
          ],
        ],
      ),
    );
  }
}
