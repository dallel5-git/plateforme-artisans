import 'package:flutter/material.dart';
import 'package:sanaya/core/theme/app_colors.dart';
import 'package:sanaya/core/theme/app_spacing.dart';
import 'package:sanaya/core/theme/app_text.dart';

/// Ouvre le contenu de [builder] dans une feuille modale au chrome standard :
/// poignée de glissement, titre optionnel, `SafeArea` (design-system.html,
/// issue FM-41/#238). Remplace le `showModalBottomSheet` + `SafeArea` recopié
/// à la main dans `governorate_picker_sheet.dart` et
/// `onboarding_profile_step.dart`.
///
/// États loading/vide/erreur : à la charge du contenu (composer avec
/// `AppSkeleton`/`EmptyState`/`ErrorState`, déjà partagés) — cette feuille
/// ne fait que le chrome, comme les autres primitives de `core/widgets`
/// (P3 : aucune dépendance HTTP/Riverpod ici).
Future<T?> showAppBottomSheet<T>(
  BuildContext context, {
  required WidgetBuilder builder,
  String? title,
}) {
  return showModalBottomSheet<T>(
    context: context,
    isScrollControlled: true,
    builder: (sheetContext) => AppBottomSheet(
      title: title,
      child: Builder(builder: builder),
    ),
  );
}

class AppBottomSheet extends StatelessWidget {
  const AppBottomSheet({required this.child, super.key, this.title});

  final Widget child;
  final String? title;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final locale = Localizations.localeOf(context);

    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(
          AppSpacing.lg,
          AppSpacing.sm,
          AppSpacing.lg,
          AppSpacing.lg,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Center(
              child: Container(
                width: 36,
                height: 4,
                margin: const EdgeInsets.only(bottom: AppSpacing.md),
                decoration: BoxDecoration(
                  color: colors.border,
                  borderRadius: const BorderRadius.all(AppRadius.pill),
                ),
              ),
            ),
            if (title != null) ...[
              Text(
                title!,
                style: AppText.h3(locale).copyWith(color: colors.textPrimary),
              ),
              const SizedBox(height: AppSpacing.sm),
            ],
            child,
          ],
        ),
      ),
    );
  }
}
