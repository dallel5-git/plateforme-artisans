import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:sanaya/app/providers.dart';
import 'package:sanaya/core/theme/app_colors.dart';
import 'package:sanaya/core/theme/app_spacing.dart';
import 'package:sanaya/core/widgets/app_button.dart';
import 'package:sanaya/features/auth/application/auth_flow_state.dart';

/// Premier écran du parcours FM-05 : choix client/artisan. Aiguillage de
/// navigation pur — jamais envoyé à l'API (cf. `AuthFlowState`).
class RoleSelectionStep extends ConsumerWidget {
  const RoleSelectionStep({required this.onSelect, super.key});

  final ValueChanged<UserRoleChoice> onSelect;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final t = ref.watch(translationsProvider);
    final colors = context.colors;

    return Padding(
      padding: const EdgeInsetsDirectional.all(AppSpacing.lg),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(
            t.auth.roleTitle,
            textAlign: TextAlign.center,
            style: Theme.of(
              context,
            ).textTheme.headlineSmall?.copyWith(color: colors.textPrimary),
          ),
          const SizedBox(height: AppSpacing.xl),
          AppButton(
            label: t.auth.roleClient,
            onPressed: () => onSelect(UserRoleChoice.client),
          ),
          const SizedBox(height: AppSpacing.md),
          AppButton(
            label: t.auth.roleProvider,
            variant: AppButtonVariant.secondary,
            onPressed: () => onSelect(UserRoleChoice.provider),
          ),
        ],
      ),
    );
  }
}
