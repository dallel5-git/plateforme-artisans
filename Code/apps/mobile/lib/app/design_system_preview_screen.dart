import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:sanaya/app/providers.dart';
import 'package:sanaya/core/theme/app_colors.dart';
import 'package:sanaya/core/theme/app_spacing.dart';
import 'package:sanaya/core/widgets/app_button.dart';
import 'package:sanaya/core/widgets/app_card.dart';
import 'package:sanaya/core/widgets/app_text_field.dart';

/// Écran interne de vérification visuelle du design system (FM-04).
/// Outil de développement, pas une fonctionnalité produit — grandit au fil
/// des PRs FM-04a→e pour permettre une capture FR/AR sur device réel de
/// chaque widget au fur et à mesure de sa construction.
class DesignSystemPreviewScreen extends ConsumerWidget {
  const DesignSystemPreviewScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final t = ref.watch(translationsProvider);

    return Scaffold(
      backgroundColor: context.colors.background,
      appBar: AppBar(
        backgroundColor: context.colors.surface,
        title: Text(t.common.home.designSystemPreview),
      ),
      body: ListView(
        padding: const EdgeInsets.all(AppSpacing.lg),
        children: [
          _Section(
            title: 'AppButton',
            child: Wrap(
              spacing: AppSpacing.sm,
              runSpacing: AppSpacing.sm,
              children: [
                AppButton(label: 'Primary', onPressed: () {}),
                const AppButton(label: 'Disabled', onPressed: null),
                AppButton(
                  label: 'Secondary',
                  onPressed: () {},
                  variant: AppButtonVariant.secondary,
                ),
                AppButton(
                  label: 'Ghost',
                  onPressed: () {},
                  variant: AppButtonVariant.ghost,
                ),
                AppButton(
                  label: 'WhatsApp',
                  onPressed: () {},
                  variant: AppButtonVariant.whatsapp,
                ),
                AppButton(
                  label: 'Danger',
                  onPressed: () {},
                  variant: AppButtonVariant.danger,
                  size: AppButtonSize.small,
                ),
              ],
            ),
          ),
          const SizedBox(height: AppSpacing.xl),
          _Section(
            title: 'AppCard',
            child: AppCard(child: Text(t.common.appName)),
          ),
          const SizedBox(height: AppSpacing.xl),
          const _Section(
            title: 'AppTextField',
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                AppTextField(
                  label: 'Numéro de téléphone',
                  hintText: '+216 22 123 456',
                  keyboardType: TextInputType.phone,
                  textDirection: TextDirection.ltr,
                ),
                SizedBox(height: AppSpacing.md),
                AppTextField(
                  label: 'Code de vérification',
                  hintText: '1234',
                  keyboardType: TextInputType.number,
                  textDirection: TextDirection.ltr,
                  errorText: 'Code incorrect — il vous reste 2 tentatives',
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _Section extends StatelessWidget {
  const _Section({required this.title, required this.child});

  final String title;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(title, style: Theme.of(context).textTheme.titleMedium),
        const SizedBox(height: AppSpacing.sm),
        child,
      ],
    );
  }
}
