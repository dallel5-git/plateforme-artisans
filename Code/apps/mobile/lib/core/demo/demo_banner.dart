import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sanaya/app/providers.dart';
import 'package:sanaya/core/demo/demo_mode_provider.dart';
import 'package:sanaya/core/theme/app_colors.dart';
import 'package:sanaya/core/theme/app_spacing.dart';

/// Bandeau visuel discret indiquant que le Mode Démo est actif.
class DemoBanner extends ConsumerWidget {
  const DemoBanner({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isDemo = ref.watch(demoModeProvider);
    if (!isDemo) return const SizedBox.shrink();

    final colors = context.colors;
    final role = ref.watch(demoRoleProvider);
    final t = ref.watch(translationsProvider);

    final roleLabel = switch (role) {
      DemoRole.provider => t.settings.demoRolePro,
      DemoRole.client => t.settings.demoRoleClient,
      DemoRole.guest => t.settings.demoRoleGuest,
    };

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.sm,
        vertical: 4,
      ),
      color: colors.pendingSubtle,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.science_outlined, size: 14, color: colors.pending),
          const SizedBox(width: AppSpacing.xs),
          Text(
            '${t.settings.demoBanner} ($roleLabel)',
            style: TextStyle(
              fontSize: 11,
              fontWeight: FontWeight.w600,
              color: colors.pending,
            ),
          ),
        ],
      ),
    );
  }
}
