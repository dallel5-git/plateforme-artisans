import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sanaya/app/providers.dart';
import 'package:sanaya/core/api/generated/api.dart';
import 'package:sanaya/core/i18n/translations.g.dart';
import 'package:sanaya/core/theme/app_colors.dart';
import 'package:sanaya/core/theme/app_spacing.dart';
import 'package:sanaya/core/theme/app_text.dart';
import 'package:sanaya/core/widgets/app_card.dart';

/// Badge de disponibilité **commutable** (FM-38, issue #235) — l'artisan
/// choisit AVAILABLE/BUSY/ON_HOLIDAY dans une feuille modale, écrit via
/// `PATCH /v1/providers/me`.
///
/// Ne réutilise pas `AvailabilityChip` (`features/provider_profile/`) : ce
/// widget est en lecture seule et typé contre l'enum de la fiche publique
/// (`V1ProvidersSlugGet200ResponseAvailabilityStatusEnum`), alors que
/// `GET`/`PATCH /providers/me` génèrent chacun leur propre enum distinct
/// (`V1ProvidersMePost200ResponseProviderAvailabilityStatusEnum` en lecture,
/// `V1ProvidersMePatchRequestAvailabilityStatusEnum` en écriture) — même
/// défaut de déduplication openapi-generator déjà documenté pour
/// `ProviderMe` (voir `onboarding_repository.dart`, BE-44).
class AvailabilitySelector extends ConsumerWidget {
  const AvailabilitySelector({
    required this.status,
    required this.onSelect,
    super.key,
  });

  final V1ProvidersMePost200ResponseProviderAvailabilityStatusEnum status;
  final ValueChanged<V1ProvidersMePatchRequestAvailabilityStatusEnum> onSelect;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final colors = context.colors;
    final locale = Localizations.localeOf(context);
    final t = ref.watch(translationsProvider);
    final (textColor, bgColor, label) = _presentation(status.name, t, colors);

    return AppCard(
      padding: EdgeInsets.zero,
      child: InkWell(
        onTap: () => unawaited(_openPicker(context, t)),
        child: Padding(
          padding: const EdgeInsets.all(AppSpacing.md),
          child: Row(
            children: [
              Expanded(
                child: Text(
                  t.proProfile.availabilitySection,
                  style: AppText.body(
                    locale,
                  ).copyWith(color: colors.textPrimary),
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: AppSpacing.sm,
                  vertical: AppSpacing.xxs,
                ),
                decoration: BoxDecoration(
                  color: bgColor,
                  borderRadius: const BorderRadius.all(AppRadius.pill),
                ),
                child: Text(
                  label,
                  style: AppText.caption(locale).copyWith(color: textColor),
                ),
              ),
              const SizedBox(width: AppSpacing.xs),
              Icon(Icons.expand_more, color: colors.textMuted),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _openPicker(BuildContext context, Translations t) {
    return showModalBottomSheet<void>(
      context: context,
      builder: (sheetContext) {
        final colors = sheetContext.colors;
        return SafeArea(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              for (final option
                  in V1ProvidersMePatchRequestAvailabilityStatusEnum.values)
                ListTile(
                  title: Text(_presentation(option.name, t, colors).$3),
                  trailing: option.name == status.name
                      ? Icon(Icons.check, color: colors.accent)
                      : null,
                  onTap: () {
                    Navigator.of(sheetContext).pop();
                    if (option.name != status.name) onSelect(option);
                  },
                ),
            ],
          ),
        );
      },
    );
  }
}

/// `(textColor, bgColor, label)` partagés entre l'affichage et la feuille de
/// sélection — indexés par [name] plutôt que par enum précis, puisque les
/// deux types générés (lecture/écriture) ne partagent aucune hiérarchie.
(Color, Color, String) _presentation(
  String name,
  Translations t,
  AppColors colors,
) {
  return switch (name) {
    'AVAILABLE' => (
      colors.verified,
      colors.verifiedSubtle,
      t.provider.profile.availableNow,
    ),
    'BUSY' => (colors.pending, colors.pendingSubtle, t.provider.profile.busy),
    'ON_HOLIDAY' => (
      colors.textMuted,
      colors.surfaceSunken,
      t.provider.profile.onHoliday,
    ),
    _ => (colors.textMuted, colors.surfaceSunken, t.provider.profile.busy),
  };
}
