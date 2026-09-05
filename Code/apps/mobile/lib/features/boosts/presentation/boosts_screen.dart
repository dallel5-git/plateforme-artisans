import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:sanaya/app/providers.dart';
import 'package:sanaya/core/theme/app_colors.dart';
import 'package:sanaya/core/theme/app_spacing.dart';
import 'package:sanaya/core/theme/app_text.dart';
import 'package:sanaya/core/widgets/app_button.dart';
import 'package:sanaya/core/widgets/app_segmented_control.dart';
import 'package:sanaya/features/boosts/presentation/widgets/boost_option_card.dart';
import 'package:sanaya/features/boosts/presentation/widgets/credit_balance_card.dart';

enum BoostDurationOption { h24, d7 }

/// Écran Boosts et Crédits de l'Espace Pro (FM-40, issue #237 — maquettes A6/C3).
///
/// Permet à l'artisan de consulter son solde de crédits et de sélectionner une
/// durée de visibilité sponsorisée (24h / 7j).
///
/// ⚠️ Coquille visuelle sans tunnel d'achat réel (bloqué par EP-BILLING /
/// ADR-004). Zéro écriture de paiement.
class BoostsScreen extends ConsumerStatefulWidget {
  const BoostsScreen({super.key});

  @override
  ConsumerState<BoostsScreen> createState() => _BoostsScreenState();
}

class _BoostsScreenState extends ConsumerState<BoostsScreen> {
  BoostDurationOption _selectedDuration = BoostDurationOption.h24;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final locale = Localizations.localeOf(context);
    final t = ref.watch(translationsProvider);

    return Scaffold(
      backgroundColor: colors.background,
      appBar: AppBar(
        title: Text(t.boosts.title),
        elevation: 0,
        backgroundColor: colors.background,
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(48),
          child: Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: AppSpacing.lg,
              vertical: AppSpacing.xs,
            ),
            child: AppSegmentedControl<String>(
              selectedValue: 'pro',
              onValueChanged: (val) {
                if (val == 'client') {
                  context.go('/client');
                }
              },
              segments: [
                AppSegment(
                  value: 'client',
                  label: t.billing.clientSpace,
                  icon: Icons.person_outline,
                ),
                AppSegment(
                  value: 'pro',
                  label: t.billing.proSpace,
                  icon: Icons.work_outline,
                ),
              ],
            ),
          ),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(AppSpacing.lg),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const CreditBalanceCard(),
            const SizedBox(height: AppSpacing.xl),
            Text(
              t.billing.boostSectionTitle,
              style: AppText.h2(locale).copyWith(color: colors.textPrimary),
            ),
            const SizedBox(height: AppSpacing.xxs),
            Text(
              t.billing.boostSectionSubtitle,
              style: AppText.body(locale).copyWith(
                color: colors.textSecondary,
              ),
            ),
            const SizedBox(height: AppSpacing.md),
            BoostOptionCard(
              title: t.billing.boostOption24h,
              description: t.billing.boostOption24hDesc,
              priceLabel: t.billing.boostOptionPrice24h,
              sponsoredLabel: t.billing.sponsoredTag,
              selected: _selectedDuration == BoostDurationOption.h24,
              onTap: () {
                setState(() => _selectedDuration = BoostDurationOption.h24);
              },
            ),
            const SizedBox(height: AppSpacing.md),
            BoostOptionCard(
              title: t.billing.boostOption7d,
              description: t.billing.boostOption7dDesc,
              priceLabel: t.billing.boostOptionPrice7d,
              sponsoredLabel: t.billing.sponsoredTag,
              selected: _selectedDuration == BoostDurationOption.d7,
              onTap: () {
                setState(() => _selectedDuration = BoostDurationOption.d7);
              },
            ),
            const SizedBox(height: AppSpacing.xl),
            AppButton(
              label: t.billing.activateBoostCta,
              icon: const Icon(Icons.bolt_rounded, size: AppIconSize.md),
              onPressed: () => showUpcomingFeatureDialog(context, ref),
            ),
          ],
        ),
      ),
    );
  }
}
