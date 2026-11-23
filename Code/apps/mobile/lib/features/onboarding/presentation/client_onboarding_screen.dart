import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:sanaya/app/providers.dart';
import 'package:sanaya/core/theme/app_colors.dart';
import 'package:sanaya/core/theme/app_spacing.dart';
import 'package:sanaya/core/theme/app_text.dart';
import 'package:sanaya/core/widgets/app_button.dart';
import 'package:sanaya/core/widgets/app_card.dart';
import 'package:sanaya/features/search/application/catalog_providers.dart';
import 'package:sanaya/features/search/data/governorate_persistence.dart';

/// Écran d'onboarding et de bienvenue pour les particuliers (Client).
/// Présente les 3 piliers (recherche locale, artisans vérifiés, contact
/// direct gratuit) et permet de sélectionner son gouvernorat.
class ClientOnboardingScreen extends ConsumerStatefulWidget {
  const ClientOnboardingScreen({super.key});

  @override
  ConsumerState<ClientOnboardingScreen> createState() =>
      _ClientOnboardingScreenState();
}

class _ClientOnboardingScreenState
    extends ConsumerState<ClientOnboardingScreen> {
  final PageController _pageController = PageController();
  int _currentPage = 0;

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  void _onNext() {
    if (_currentPage < 2) {
      unawaited(
        _pageController.nextPage(
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeInOut,
        ),
      );
    } else {
      _finishOnboarding();
    }
  }

  void _finishOnboarding() {
    context.go('/client');
  }

  @override
  Widget build(BuildContext context) {
    final t = ref.watch(translationsProvider);
    final colors = context.colors;
    final locale = Localizations.localeOf(context);

    return Scaffold(
      backgroundColor: colors.background,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        actions: [
          TextButton(
            onPressed: _finishOnboarding,
            child: Text(
              t.onboarding.clientSkip,
              style: AppText.bodyStrong(locale).copyWith(
                color: colors.textSecondary,
              ),
            ),
          ),
          const SizedBox(width: AppSpacing.sm),
        ],
      ),
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: PageView(
                controller: _pageController,
                onPageChanged: (page) => setState(() => _currentPage = page),
                children: [
                  _OnboardingSlide(
                    icon: Icons.search_rounded,
                    iconBgColor: colors.accentSubtle,
                    iconColor: colors.accent,
                    title: t.onboarding.clientStep1Title,
                    description: t.onboarding.clientStep1Desc,
                  ),
                  _OnboardingSlide(
                    icon: Icons.verified_user_rounded,
                    iconBgColor: colors.verifiedSubtle,
                    iconColor: colors.verified,
                    title: t.onboarding.clientStep2Title,
                    description: t.onboarding.clientStep2Desc,
                  ),
                  _OnboardingSlide(
                    icon: Icons.phone_forwarded_rounded,
                    iconBgColor: colors.whatsapp.withValues(alpha: 0.15),
                    iconColor: colors.whatsapp,
                    title: t.onboarding.clientStep3Title,
                    description: t.onboarding.clientStep3Desc,
                    extraContent: const _GovernorateQuickSelector(),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: AppSpacing.lg,
                vertical: AppSpacing.md,
              ),
              child: Column(
                children: [
                  _PageIndicators(
                    count: 3,
                    currentPage: _currentPage,
                    accentColor: colors.accent,
                    inactiveColor: colors.border,
                  ),
                  const SizedBox(height: AppSpacing.lg),
                  AppButton(
                    label: _currentPage == 2
                        ? t.onboarding.clientStartExploring
                        : t.onboarding.next,
                    onPressed: _onNext,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _OnboardingSlide extends StatelessWidget {
  const _OnboardingSlide({
    required this.icon,
    required this.iconBgColor,
    required this.iconColor,
    required this.title,
    required this.description,
    this.extraContent,
  });

  final IconData icon;
  final Color iconBgColor;
  final Color iconColor;
  final String title;
  final String description;
  final Widget? extraContent;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final locale = Localizations.localeOf(context);

    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.xl),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const SizedBox(height: AppSpacing.xl),
          Container(
            width: 96,
            height: 96,
            decoration: BoxDecoration(
              color: iconBgColor,
              shape: BoxShape.circle,
            ),
            child: Icon(icon, size: 48, color: iconColor),
          ),
          const SizedBox(height: AppSpacing.xl),
          Text(
            title,
            textAlign: TextAlign.center,
            style: AppText.h2(locale).copyWith(
              color: colors.textPrimary,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: AppSpacing.md),
          Text(
            description,
            textAlign: TextAlign.center,
            style: AppText.body(locale).copyWith(
              color: colors.textSecondary,
              height: 1.5,
            ),
          ),
          if (extraContent != null) ...[
            const SizedBox(height: AppSpacing.lg),
            extraContent!,
          ],
        ],
      ),
    );
  }
}

class _GovernorateQuickSelector extends ConsumerWidget {
  const _GovernorateQuickSelector();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final t = ref.watch(translationsProvider);
    final colors = context.colors;
    final locale = Localizations.localeOf(context);
    final selectedGov = ref.watch(selectedGovernorateIdProvider);

    final governorates = [
      (id: 'sousse', label: locale.languageCode == 'ar' ? 'سوسة' : 'Sousse'),
      (
        id: 'monastir',
        label: locale.languageCode == 'ar' ? 'المنستير' : 'Monastir',
      ),
      (id: 'mahdia', label: locale.languageCode == 'ar' ? 'المهدية' : 'Mahdia'),
    ];

    return AppCard(
      padding: const EdgeInsets.all(AppSpacing.md),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            t.onboarding.clientChooseGovernorate,
            style: AppText.bodyStrong(locale).copyWith(
              color: colors.textPrimary,
            ),
          ),
          const SizedBox(height: AppSpacing.sm),
          Wrap(
            spacing: AppSpacing.xs,
            runSpacing: AppSpacing.xs,
            children: governorates.map((gov) {
              final isSelected = selectedGov == gov.id;
              return ChoiceChip(
                label: Text(gov.label),
                selected: isSelected,
                selectedColor: colors.accentSubtle,
                labelStyle: AppText.small(locale).copyWith(
                  color: isSelected ? colors.accent : colors.textPrimary,
                  fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                ),
                onSelected: (selected) {
                  if (selected) {
                    ref.read(selectedGovernorateIdProvider.notifier).state =
                        gov.id;
                    unawaited(persistGovernorateId(gov.id));
                  }
                },
              );
            }).toList(),
          ),
        ],
      ),
    );
  }
}

class _PageIndicators extends StatelessWidget {
  const _PageIndicators({
    required this.count,
    required this.currentPage,
    required this.accentColor,
    required this.inactiveColor,
  });

  final int count;
  final int currentPage;
  final Color accentColor;
  final Color inactiveColor;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(count, (index) {
        final isActive = index == currentPage;
        return AnimatedContainer(
          duration: const Duration(milliseconds: 250),
          margin: const EdgeInsets.symmetric(horizontal: 4),
          height: 8,
          width: isActive ? 24 : 8,
          decoration: BoxDecoration(
            color: isActive ? accentColor : inactiveColor,
            borderRadius: const BorderRadius.all(AppRadius.pill),
          ),
        );
      }),
    );
  }
}
