import 'dart:async';

import 'package:built_collection/built_collection.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:sanaya/app/providers.dart';
import 'package:sanaya/core/api/generated/api.dart';
import 'package:sanaya/core/demo/demo_mode_provider.dart';
import 'package:sanaya/core/theme/app_colors.dart';
import 'package:sanaya/core/theme/app_spacing.dart';
import 'package:sanaya/core/theme/app_text.dart';
import 'package:sanaya/core/widgets/app_badge.dart';
import 'package:sanaya/core/widgets/app_button.dart';
import 'package:sanaya/core/widgets/app_card.dart';
import 'package:sanaya/core/widgets/app_skeleton.dart';
import 'package:sanaya/core/widgets/empty_state.dart';
import 'package:sanaya/core/widgets/error_state.dart';
import 'package:sanaya/features/onboarding/application/onboarding_providers.dart';
import 'package:sanaya/features/onboarding/data/onboarding_repository.dart';
import 'package:sanaya/features/onboarding/domain/portfolio_upload_task.dart';
import 'package:sanaya/features/onboarding/presentation/widgets/onboarding_categories_step.dart';
import 'package:sanaya/features/onboarding/presentation/widgets/onboarding_photos_step.dart';
import 'package:sanaya/features/onboarding/presentation/widgets/onboarding_profile_step.dart';
import 'package:sanaya/features/onboarding/presentation/widgets/onboarding_zones_step.dart';
import 'package:sanaya/features/pro_profile/application/pro_profile_providers.dart';
import 'package:sanaya/features/pro_profile/data/offerings_repository.dart';
import 'package:sanaya/features/pro_profile/presentation/widgets/availability_selector.dart';
import 'package:sanaya/features/pro_profile/presentation/widgets/offering_edit_bottom_sheet.dart';
import 'package:sanaya/features/pro_profile/presentation/widgets/pro_offerings_card.dart';
import 'package:sanaya/features/pro_profile/presentation/widgets/pro_portfolio_card.dart';
import 'package:sanaya/features/reviews/application/pro_reviews_providers.dart';
import 'package:sanaya/features/search/application/catalog_providers.dart';
import 'package:sanaya/features/search/data/catalog_repository.dart';
import 'package:sanaya/features/settings/presentation/account_settings_section.dart';
import 'package:sanaya/features/verification/application/kyc_providers.dart';
import 'package:sanaya/features/verification/presentation/widgets/verification_status_card.dart';

/// Onglet Profil pro (`/pro/profile`, FM-38, issue #235) : espace complet
/// et valorisant pour l'artisan.
/// Comprend :
/// - Carte d'identité pro avec initiales, badge vérifié, note et expérience
/// - Barre et score de complétude avec raccourci vers le parcours complet
/// - Statistiques clés d'impact (vues, contacts, note moyenne)
/// - Disponibilité et bascule urgences 24/7
/// - Accès rapide à la fiche publique
/// - Raccourcis de test d'onboarding (Pro / Particulier)
/// - Édition des informations de profil
/// - Réglages généraux du compte
class ProProfileScreen extends ConsumerStatefulWidget {
  const ProProfileScreen({super.key});

  @override
  ConsumerState<ProProfileScreen> createState() => _ProProfileScreenState();
}

class _ProProfileScreenState extends ConsumerState<ProProfileScreen> {
  bool _isSaving = false;
  String? _errorMessage;

  Future<void> _submitProfile(ProfileStepValues values) async {
    final t = ref.read(translationsProvider);
    setState(() {
      _isSaving = true;
      _errorMessage = null;
    });

    final body = V1ProvidersMePatchRequest(
      (b) => b
        ..businessName = values.businessName
        ..headline = values.headline
        ..bio = values.bio
        ..yearsExperience = values.yearsExperience
        ..whatsappPhone = values.whatsappPhone
        ..publicPhone = values.publicPhone,
    );

    try {
      await ref.read(proProfileUpdaterProvider).save(body);
      if (!mounted) return;
      setState(() => _isSaving = false);
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(t.proProfile.saveSuccess)));
    } on Object {
      if (!mounted) return;
      setState(() {
        _isSaving = false;
        _errorMessage = t.onboarding.profileSaveError;
      });
    }
  }

  Future<void> _submitCategories(
    Map<String, bool> selection,
    BuildContext sheetContext,
  ) async {
    final t = ref.read(translationsProvider);
    final body = V1ProvidersMeCategoriesPutRequest(
      (b) => b.categories.addAll(
        selection.entries.map(
          (entry) => V1ProvidersMeCategoriesPutRequestCategoriesInner(
            (cb) => cb
              ..categoryId = entry.key
              ..isPrimary = entry.value,
          ),
        ),
      ),
    );
    try {
      await ref.read(proProfileUpdaterProvider).saveCategories(body);
      if (!mounted) return;
      if (sheetContext.mounted) {
        Navigator.of(sheetContext).pop();
      }
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(t.proProfile.categoriesUpdated)),
      );
    } on Object {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(t.onboarding.categoriesSaveError)),
      );
    }
  }

  Future<void> _submitCoverageAreas(
    Set<String> selection,
    BuildContext sheetContext,
  ) async {
    final t = ref.read(translationsProvider);
    final body = V1ProvidersMeCoverageAreasPutRequest(
      (b) => b.coverageAreas.addAll(
        selection.map(
          (governorateId) =>
              V1ProvidersMeCoverageAreasPutRequestCoverageAreasInner(
                (cb) => cb.governorateId = governorateId,
              ),
        ),
      ),
    );
    try {
      await ref.read(proProfileUpdaterProvider).saveCoverageAreas(body);
      if (!mounted) return;
      if (sheetContext.mounted) {
        Navigator.of(sheetContext).pop();
      }
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(t.proProfile.zonesUpdated)),
      );
    } on Object {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(t.onboarding.zonesErrorMessage)),
      );
    }
  }

  void _openEditCategories(BuildContext context, ProviderMe profile) {
    final t = ref.read(translationsProvider);
    final colors = context.colors;
    final initialSelection = {
      for (final c in profile.categories) c.categoryId: c.isPrimary,
    };
    unawaited(
      showModalBottomSheet<void>(
        context: context,
        isScrollControlled: true,
        useSafeArea: true,
        builder: (sheetContext) => SizedBox(
          height: MediaQuery.sizeOf(sheetContext).height * 0.85,
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(vertical: AppSpacing.sm),
                child: Container(
                  width: 36,
                  height: 4,
                  decoration: BoxDecoration(
                    color: colors.border,
                    borderRadius: const BorderRadius.all(AppRadius.pill),
                  ),
                ),
              ),
              Expanded(
                child: OnboardingCategoriesStep(
                  initialSelection: initialSelection,
                  isSaving: _isSaving,
                  errorMessage: null,
                  submitLabel: t.proProfile.save,
                  onSubmit: (sel) => _submitCategories(sel, sheetContext),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _openEditZones(BuildContext context, ProviderMe profile) {
    final t = ref.read(translationsProvider);
    final colors = context.colors;
    final initialSelection = profile.coverageAreas
        .map((a) => a.governorateId)
        .toSet();
    unawaited(
      showModalBottomSheet<void>(
        context: context,
        isScrollControlled: true,
        useSafeArea: true,
        builder: (sheetContext) => SizedBox(
          height: MediaQuery.sizeOf(sheetContext).height * 0.85,
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(vertical: AppSpacing.sm),
                child: Container(
                  width: 36,
                  height: 4,
                  decoration: BoxDecoration(
                    color: colors.border,
                    borderRadius: const BorderRadius.all(AppRadius.pill),
                  ),
                ),
              ),
              Expanded(
                child: OnboardingZonesStep(
                  initialSelection: initialSelection,
                  isSaving: _isSaving,
                  errorMessage: null,
                  submitLabel: t.proProfile.save,
                  onSubmit: (sel) => _submitCoverageAreas(sel, sheetContext),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _openManagePortfolio(
    BuildContext context,
    ProviderMe profile,
  ) async {
    final t = ref.read(translationsProvider);
    final colors = context.colors;
    final initialItems = profile.portfolio
        .map(
          (p) => PortfolioUploadTask(
            localId: p.id,
            phase: PortfolioUploadPhase.done,
            portfolioItemId: p.id,
            mediaId: p.mediaId,
          ),
        )
        .toList();

    await showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      useSafeArea: true,
      builder: (sheetContext) => SizedBox(
        height: MediaQuery.sizeOf(sheetContext).height * 0.85,
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(vertical: AppSpacing.sm),
              child: Container(
                width: 36,
                height: 4,
                decoration: BoxDecoration(
                  color: colors.border,
                  borderRadius: const BorderRadius.all(AppRadius.pill),
                ),
              ),
            ),
            Expanded(
              child: OnboardingPhotosStep(
                confirmBeforeDelete: true,
                submitLabel: t.proProfile.save,
                isSaving: false,
                errorMessage: null,
                initialItems: initialItems,
                onSubmit: () {
                  Navigator.of(sheetContext).pop();
                },
              ),
            ),
          ],
        ),
      ),
    );
    ref.invalidate(myProviderProfileProvider);
  }

  void _openAddOffering(BuildContext context, ProviderMe profile) {
    unawaited(
      showModalBottomSheet<void>(
        context: context,
        isScrollControlled: true,
        useSafeArea: true,
        builder: (sheetContext) => OfferingEditBottomSheet(profile: profile),
      ),
    );
  }

  void _openEditOffering(
    BuildContext context,
    ProviderMe profile,
    MyOffering offering,
  ) {
    unawaited(
      showModalBottomSheet<void>(
        context: context,
        isScrollControlled: true,
        useSafeArea: true,
        builder: (sheetContext) => OfferingEditBottomSheet(
          profile: profile,
          initialOffering: offering,
        ),
      ),
    );
  }

  Future<void> _deleteOffering(
    BuildContext context,
    MyOffering offering,
  ) async {
    final t = ref.read(translationsProvider);
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: Text(t.proProfile.offeringsDeleteTitle),
        content: Text(t.proProfile.offeringsDeleteMessage),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(dialogContext).pop(false),
            child: Text(t.proProfile.portfolioCancel),
          ),
          TextButton(
            onPressed: () => Navigator.of(dialogContext).pop(true),
            child: Text(
              t.proProfile.offeringsDeleteConfirm,
              style: TextStyle(
                color: Theme.of(dialogContext).colorScheme.error,
              ),
            ),
          ),
        ],
      ),
    );

    if (confirmed != true) return;

    try {
      await ref.read(offeringsRepositoryProvider).deleteOffering(offering.id);
      ref.invalidate(myOfferingsProvider);
      if (!context.mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(t.proProfile.offeringsDeleted)),
      );
    } on Object {
      if (!context.mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(t.proProfile.errorMessage)),
      );
    }
  }

  Future<void> _updateAvailability(
    V1ProvidersMePatchRequestAvailabilityStatusEnum status,
  ) async {
    await _patch(
      V1ProvidersMePatchRequest((b) => b..availabilityStatus = status),
    );
  }

  Future<void> _updateAcceptsEmergency(bool value) async {
    await _patch(
      V1ProvidersMePatchRequest((b) => b..acceptsEmergency = value),
    );
  }

  Future<void> _patch(V1ProvidersMePatchRequest body) async {
    final t = ref.read(translationsProvider);
    try {
      await ref.read(proProfileUpdaterProvider).save(body);
    } on Object {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(t.onboarding.profileSaveError)),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final t = ref.watch(translationsProvider);
    final colors = context.colors;
    final profileAsync = ref.watch(myProviderProfileProvider);

    return Scaffold(
      backgroundColor: colors.background,
      appBar: AppBar(title: Text(t.proProfile.title)),
      body: profileAsync.when(
        loading: () => const _ProProfileSkeleton(),
        error: (error, _) => ErrorState(
          icon: '⚠️',
          title: t.proProfile.errorTitle,
          message: t.proProfile.errorMessage,
          actionLabel: t.proProfile.retry,
          onAction: () => ref.invalidate(myProviderProfileProvider),
        ),
        data: (profile) => profile == null
            ? EmptyState(
                icon: '👤',
                title: t.proProfile.emptyTitle,
                message: t.proProfile.emptyMessage,
                actionLabel: t.proProfile.switchToClientSpace,
                onAction: () => context.go('/client'),
              )
            : _ProProfileContent(
                profile: profile,
                isSaving: _isSaving,
                errorMessage: _errorMessage,
                onSubmitProfile: _submitProfile,
                onSelectAvailability: _updateAvailability,
                onToggleAcceptsEmergency: _updateAcceptsEmergency,
                onEditCategories: () => _openEditCategories(context, profile),
                onEditZones: () => _openEditZones(context, profile),
                onManagePortfolio: () => _openManagePortfolio(context, profile),
                onAddOffering: () => _openAddOffering(context, profile),
                onEditOffering: (offering) =>
                    _openEditOffering(context, profile, offering),
                onDeleteOffering: (offering) =>
                    _deleteOffering(context, offering),
              ),
      ),
    );
  }
}

class _ProProfileSkeleton extends StatelessWidget {
  const _ProProfileSkeleton();

  @override
  Widget build(BuildContext context) {
    return const SingleChildScrollView(
      physics: NeverScrollableScrollPhysics(),
      padding: EdgeInsets.all(AppSpacing.md),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          AppSkeleton(height: 120),
          SizedBox(height: AppSpacing.md),
          AppSkeleton(height: 70),
          SizedBox(height: AppSpacing.md),
          AppSkeleton(height: 72),
          SizedBox(height: AppSpacing.md),
          AppSkeleton(height: 280),
        ],
      ),
    );
  }
}

class _ProProfileContent extends ConsumerWidget {
  const _ProProfileContent({
    required this.profile,
    required this.isSaving,
    required this.errorMessage,
    required this.onSubmitProfile,
    required this.onSelectAvailability,
    required this.onToggleAcceptsEmergency,
    required this.onEditCategories,
    required this.onEditZones,
    required this.onManagePortfolio,
    required this.onAddOffering,
    required this.onEditOffering,
    required this.onDeleteOffering,
  });

  final ProviderMe profile;
  final bool isSaving;
  final String? errorMessage;
  final ValueChanged<ProfileStepValues> onSubmitProfile;
  final ValueChanged<V1ProvidersMePatchRequestAvailabilityStatusEnum>
  onSelectAvailability;
  final ValueChanged<bool> onToggleAcceptsEmergency;
  final VoidCallback onEditCategories;
  final VoidCallback onEditZones;
  final VoidCallback onManagePortfolio;
  final VoidCallback onAddOffering;
  final ValueChanged<MyOffering> onEditOffering;
  final ValueChanged<MyOffering> onDeleteOffering;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final t = ref.watch(translationsProvider);
    final colors = context.colors;
    final locale = Localizations.localeOf(context);
    final isDemo = ref.watch(demoModeProvider);
    final kycStatus = ref.watch(kycStatusProvider).valueOrNull;
    final effectiveStatus =
        kycStatus?.verificationStatus ??
        (profile.isVerified
            ? V1ProvidersMeVerificationGet200ResponseVerificationStatusEnum
                  .APPROVED
            : V1ProvidersMeVerificationGet200ResponseVerificationStatusEnum
                  .NOT_SUBMITTED);

    return ListView(
      padding: const EdgeInsets.all(AppSpacing.md),
      children: [
        _ProIdentityHeader(profile: profile),
        const SizedBox(height: AppSpacing.md),
        VerificationStatusCard(
          status: effectiveStatus,
          rejectionReason: kycStatus?.currentRequest.rejectionReason,
          isCompact: true,
        ),
        const SizedBox(height: AppSpacing.md),
        _ProCompletionCard(profile: profile),
        const SizedBox(height: AppSpacing.md),
        _ProQuickStatsRow(profile: profile),
        const SizedBox(height: AppSpacing.md),
        _ProAvailabilityCard(
          status: profile.availabilityStatus,
          acceptsEmergency: profile.acceptsEmergency,
          onSelectAvailability: onSelectAvailability,
          onToggleAcceptsEmergency: onToggleAcceptsEmergency,
        ),
        const SizedBox(height: AppSpacing.md),
        _ProCategoriesCard(
          profile: profile,
          onEdit: onEditCategories,
        ),
        const SizedBox(height: AppSpacing.md),
        _ProZonesCard(
          profile: profile,
          onEdit: onEditZones,
        ),
        const SizedBox(height: AppSpacing.md),
        ProPortfolioCard(
          profile: profile,
          onManagePortfolio: onManagePortfolio,
        ),
        const SizedBox(height: AppSpacing.md),
        ProOfferingsCard(
          profile: profile,
          onAddOffering: onAddOffering,
          onEditOffering: onEditOffering,
          onDeleteOffering: onDeleteOffering,
        ),
        const SizedBox(height: AppSpacing.md),
        _ProPublicListingCard(slug: profile.slug),
        if (isDemo) ...[
          const SizedBox(height: AppSpacing.md),
          const _ProTestShortcutsCard(),
        ],
        const SizedBox(height: AppSpacing.xl),
        Text(
          t.proProfile.editSection,
          style: AppText.h3(locale).copyWith(color: colors.textPrimary),
        ),
        const SizedBox(height: AppSpacing.md),
        AppCard(
          child: OnboardingProfileStep(
            initialProfile: profile,
            isSaving: isSaving,
            errorMessage: errorMessage,
            onSubmit: onSubmitProfile,
            submitLabel: t.proProfile.save,
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            showGovernorate: false,
          ),
        ),
        const SizedBox(height: AppSpacing.xl),
        AccountSettingsSection(
          onOpenLegal: () => context.push('/pro/profile/legal'),
          accountActions: [
            AppButton(
              label: t.proProfile.switchToClientSpace,
              variant: AppButtonVariant.secondary,
              icon: const Icon(Icons.swap_horiz_rounded, size: AppIconSize.md),
              onPressed: () => context.go('/client'),
            ),
          ],
        ),
      ],
    );
  }
}

class _ProIdentityHeader extends StatelessWidget {
  const _ProIdentityHeader({required this.profile});

  final ProviderMe profile;

  String _initials(String name) {
    final trimmed = name.trim();
    if (trimmed.isEmpty) return 'P';
    final parts = trimmed.split(RegExp(r'\s+'));
    if (parts.length >= 2) {
      return '${parts[0][0]}${parts[1][0]}'.toUpperCase();
    }
    return trimmed.substring(0, trimmed.length >= 2 ? 2 : 1).toUpperCase();
  }

  bool get _isVerified {
    try {
      return profile.isVerified;
    } on Object catch (_) {
      return false;
    }
  }

  num get _ratingAvg {
    try {
      return profile.ratingAvg;
    } on Object catch (_) {
      return 0.0;
    }
  }

  int get _ratingCount {
    try {
      return profile.ratingCount;
    } on Object catch (_) {
      return 0;
    }
  }

  int get _yearsExp {
    try {
      return profile.yearsExperience;
    } on Object catch (_) {
      return 0;
    }
  }

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final locale = Localizations.localeOf(context);

    return AppCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 56,
                height: 56,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: colors.accentSubtle,
                  border: Border.all(
                    color: colors.accent.withValues(alpha: 0.3),
                    width: 2,
                  ),
                ),
                child: Center(
                  child: Text(
                    _initials(profile.businessName),
                    style: AppText.h3(locale).copyWith(
                      color: colors.accent,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
              const SizedBox(width: AppSpacing.md),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Flexible(
                          child: Text(
                            profile.businessName,
                            style: AppText.h3(locale).copyWith(
                              color: colors.textPrimary,
                              fontWeight: FontWeight.bold,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        if (_isVerified) ...[
                          const SizedBox(width: AppSpacing.xs),
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: AppSpacing.xs,
                              vertical: 2,
                            ),
                            decoration: BoxDecoration(
                              color: colors.verifiedSubtle,
                              borderRadius: const BorderRadius.all(
                                AppRadius.sm,
                              ),
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Icon(
                                  Icons.verified_rounded,
                                  size: AppIconSize.xs,
                                  color: colors.verified,
                                ),
                              ],
                            ),
                          ),
                        ],
                      ],
                    ),
                    if (profile.headline.isNotEmpty) ...[
                      const SizedBox(height: AppSpacing.xxs),
                      Text(
                        profile.headline,
                        style: AppText.body(locale).copyWith(
                          color: colors.textSecondary,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.md),
          Wrap(
            spacing: AppSpacing.xs,
            runSpacing: AppSpacing.xs,
            children: [
              _ProBadgePill(
                icon: Icons.star_rounded,
                iconColor: colors.amber,
                label:
                    '${_ratingAvg.toStringAsFixed(1)} '
                    '($_ratingCount)',
              ),
              _ProBadgePill(
                icon: Icons.work_history_rounded,
                iconColor: colors.accent,
                label: "$_yearsExp ans d'exp.",
              ),
              if (profile.baseGovernorateId.isNotEmpty)
                _ProBadgePill(
                  icon: Icons.location_on_rounded,
                  iconColor: colors.textSecondary,
                  label: profile.baseGovernorateId.toUpperCase(),
                ),
            ],
          ),
        ],
      ),
    );
  }
}

class _ProBadgePill extends StatelessWidget {
  const _ProBadgePill({
    required this.icon,
    required this.iconColor,
    required this.label,
  });

  final IconData icon;
  final Color iconColor;
  final String label;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final locale = Localizations.localeOf(context);

    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.sm,
        vertical: 4,
      ),
      decoration: BoxDecoration(
        color: colors.surfaceSunken,
        borderRadius: const BorderRadius.all(AppRadius.pill),
        border: Border.all(color: colors.border),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: AppIconSize.xs, color: iconColor),
          const SizedBox(width: AppSpacing.xxs),
          Text(
            label,
            style: AppText.caption(locale).copyWith(
              color: colors.textPrimary,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}

class _ProCompletionCard extends ConsumerWidget {
  const _ProCompletionCard({required this.profile});

  final ProviderMe profile;

  int get _score {
    try {
      return profile.completionScore.clamp(0, 100);
    } on Object catch (_) {
      return 0;
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final t = ref.watch(translationsProvider);
    final colors = context.colors;
    final locale = Localizations.localeOf(context);
    final score = _score;

    return AppCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Row(
                  children: [
                    Icon(
                      Icons.trending_up_rounded,
                      color: colors.accent,
                      size: AppIconSize.md,
                    ),
                    const SizedBox(width: AppSpacing.xs),
                    Expanded(
                      child: Text(
                        t.proProfile.completionTitle,
                        style: AppText.bodyStrong(locale).copyWith(
                          color: colors.textPrimary,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: AppSpacing.xs),
              Text(
                '$score %',
                style: AppText.bodyStrong(locale).copyWith(
                  color: colors.accent,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.sm),
          ClipRRect(
            borderRadius: const BorderRadius.all(AppRadius.pill),
            child: LinearProgressIndicator(
              value: score / 100.0,
              minHeight: 8,
              color: colors.accent,
              backgroundColor: colors.surfaceSunken,
            ),
          ),
          const SizedBox(height: AppSpacing.xs),
          Text(
            t.proProfile.completionTip,
            style: AppText.caption(locale).copyWith(
              color: colors.textSecondary,
            ),
          ),
          const SizedBox(height: AppSpacing.sm),
          InkWell(
            onTap: () {
              ref.read(hasPublishedProfileProvider.notifier).state = false;
              ref.invalidate(onboardingProvider);
              context.go('/pro/onboarding');
            },
            borderRadius: const BorderRadius.all(AppRadius.md),
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 4),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Flexible(
                    child: Text(
                      t.proProfile.relaunchOnboarding,
                      style: AppText.caption(locale).copyWith(
                        color: colors.accent,
                        fontWeight: FontWeight.bold,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  const SizedBox(width: AppSpacing.xxs),
                  Icon(
                    Icons.arrow_forward_rounded,
                    size: AppIconSize.xs,
                    color: colors.accent,
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _ProQuickStatsRow extends ConsumerWidget {
  const _ProQuickStatsRow({required this.profile});

  final ProviderMe profile;

  int get _views {
    try {
      return profile.totalProfileViews;
    } on Object catch (_) {
      return 0;
    }
  }

  int get _contacts {
    try {
      return profile.totalContacts;
    } on Object catch (_) {
      return 0;
    }
  }

  num get _ratingAvg {
    try {
      return profile.ratingAvg;
    } on Object catch (_) {
      return 0.0;
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final t = ref.watch(translationsProvider);
    final colors = context.colors;

    return Row(
      children: [
        Expanded(
          child: _StatTile(
            value: '$_views',
            label: t.proProfile.statsViews,
            icon: Icons.remove_red_eye_outlined,
            iconColor: colors.accent,
          ),
        ),
        const SizedBox(width: AppSpacing.sm),
        Expanded(
          child: _StatTile(
            value: '$_contacts',
            label: t.proProfile.statsContacts,
            icon: Icons.call_outlined,
            iconColor: colors.whatsapp,
          ),
        ),
        const SizedBox(width: AppSpacing.sm),
        Expanded(
          child: _StatTile(
            value: _ratingAvg.toStringAsFixed(1),
            label: t.proProfile.statsRating,
            icon: Icons.star_outline_rounded,
            iconColor: colors.amber,
          ),
        ),
      ],
    );
  }
}

class _StatTile extends StatelessWidget {
  const _StatTile({
    required this.value,
    required this.label,
    required this.icon,
    required this.iconColor,
  });

  final String value;
  final String label;
  final IconData icon;
  final Color iconColor;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final locale = Localizations.localeOf(context);

    return AppCard(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.sm,
        vertical: AppSpacing.md,
      ),
      child: Column(
        children: [
          Icon(icon, color: iconColor, size: AppIconSize.md),
          const SizedBox(height: AppSpacing.xs),
          Text(
            value,
            style: AppText.h3(locale).copyWith(
              color: colors.textPrimary,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 2),
          Text(
            label,
            style: AppText.caption(locale).copyWith(
              color: colors.textSecondary,
            ),
            textAlign: TextAlign.center,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }
}

class _ProAvailabilityCard extends StatelessWidget {
  const _ProAvailabilityCard({
    required this.status,
    required this.acceptsEmergency,
    required this.onSelectAvailability,
    required this.onToggleAcceptsEmergency,
  });

  final V1ProvidersMePost200ResponseProviderAvailabilityStatusEnum status;
  final bool acceptsEmergency;
  final ValueChanged<V1ProvidersMePatchRequestAvailabilityStatusEnum>
  onSelectAvailability;
  final ValueChanged<bool> onToggleAcceptsEmergency;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        AvailabilitySelector(
          status: status,
          onSelect: onSelectAvailability,
        ),
        const SizedBox(height: AppSpacing.sm),
        _AcceptsEmergencyTile(
          value: acceptsEmergency,
          onChanged: onToggleAcceptsEmergency,
        ),
      ],
    );
  }
}

class _ProPublicListingCard extends ConsumerWidget {
  const _ProPublicListingCard({required this.slug});

  final String slug;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final t = ref.watch(translationsProvider);
    final colors = context.colors;
    final locale = Localizations.localeOf(context);

    return AppCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            children: [
              Container(
                width: 44,
                height: 44,
                decoration: BoxDecoration(
                  color: colors.accentSubtle,
                  borderRadius: const BorderRadius.all(AppRadius.md),
                ),
                child: Icon(
                  Icons.storefront_rounded,
                  color: colors.accent,
                  size: AppIconSize.md,
                ),
              ),
              const SizedBox(width: AppSpacing.md),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      t.proProfile.publicPreviewTitle,
                      style: AppText.bodyStrong(locale).copyWith(
                        color: colors.textPrimary,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      t.proProfile.publicPreviewSubtitle,
                      style: AppText.caption(locale).copyWith(
                        color: colors.textSecondary,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.md),
          AppButton(
            label: t.proProfile.viewMyListing,
            variant: AppButtonVariant.secondary,
            icon: const Icon(Icons.visibility_rounded, size: AppIconSize.sm),
            onPressed: () => unawaited(context.push('/providers/$slug')),
          ),
        ],
      ),
    );
  }
}

class _ProTestShortcutsCard extends ConsumerWidget {
  const _ProTestShortcutsCard();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final colors = context.colors;
    final locale = Localizations.localeOf(context);
    final t = ref.watch(translationsProvider);

    return AppCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                Icons.science_rounded,
                color: colors.amber,
                size: AppIconSize.md,
              ),
              const SizedBox(width: AppSpacing.xs),
              Text(
                t.settings.testToolsSection,
                style: AppText.bodyStrong(locale).copyWith(
                  color: colors.textPrimary,
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.md),
          Row(
            children: [
              Expanded(
                child: AppButton(
                  label: t.proProfile.testOnboardingPro,
                  variant: AppButtonVariant.secondary,
                  icon: const Icon(
                    Icons.handyman_rounded,
                    size: AppIconSize.sm,
                  ),
                  onPressed: () async {
                    await ref
                        .read(demoModeProvider.notifier)
                        .setEnabled(enabled: true);
                    await ref
                        .read(demoRoleProvider.notifier)
                        .setRole(DemoRole.provider);
                    ref.read(hasPublishedProfileProvider.notifier).state =
                        false;
                    ref.invalidate(onboardingProvider);
                    if (context.mounted) {
                      context.go('/pro/onboarding');
                    }
                  },
                ),
              ),
              const SizedBox(width: AppSpacing.sm),
              Expanded(
                child: AppButton(
                  label: t.proProfile.testOnboardingClient,
                  variant: AppButtonVariant.ghost,
                  icon: const Icon(
                    Icons.person_search_rounded,
                    size: AppIconSize.sm,
                  ),
                  onPressed: () =>
                      unawaited(context.push('/client/onboarding')),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _AcceptsEmergencyTile extends ConsumerWidget {
  const _AcceptsEmergencyTile({required this.value, required this.onChanged});

  final bool value;
  final ValueChanged<bool> onChanged;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final colors = context.colors;
    final locale = Localizations.localeOf(context);
    final t = ref.watch(translationsProvider);

    return SwitchListTile(
      value: value,
      onChanged: onChanged,
      activeThumbColor: colors.accent,
      tileColor: colors.surface,
      shape: RoundedRectangleBorder(
        borderRadius: const BorderRadius.all(AppRadius.lg),
        side: BorderSide(color: colors.border),
      ),
      title: Text(
        t.proProfile.acceptsEmergencyLabel,
        style: AppText.body(locale).copyWith(color: colors.textPrimary),
      ),
      subtitle: Text(
        t.proProfile.acceptsEmergencyDescription,
        style: AppText.small(locale).copyWith(color: colors.textSecondary),
      ),
    );
  }
}

class _ProCategoriesCard extends ConsumerWidget {
  const _ProCategoriesCard({
    required this.profile,
    required this.onEdit,
  });

  final ProviderMe profile;
  final VoidCallback onEdit;

  BuiltList<V1ProvidersMePost200ResponseProviderCategoriesInner>
  get _categories {
    try {
      return profile.categories;
    } on Object catch (_) {
      return BuiltList();
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final t = ref.watch(translationsProvider);
    final colors = context.colors;
    final locale = Localizations.localeOf(context);
    final categoriesAsync = ref.watch(categoriesProvider);
    final categories = _categories;

    return AppCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            children: [
              Container(
                width: 44,
                height: 44,
                decoration: BoxDecoration(
                  color: colors.accentSubtle,
                  borderRadius: const BorderRadius.all(AppRadius.md),
                ),
                child: Icon(
                  Icons.handyman_rounded,
                  color: colors.accent,
                  size: AppIconSize.md,
                ),
              ),
              const SizedBox(width: AppSpacing.md),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      t.proProfile.categoriesSection,
                      style: AppText.bodyStrong(locale).copyWith(
                        color: colors.textPrimary,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      t.proProfile.categoriesDesc,
                      style: AppText.caption(locale).copyWith(
                        color: colors.textSecondary,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.md),
          if (categories.isEmpty)
            Text(
              t.proProfile.categoriesEmpty,
              style: AppText.body(locale).copyWith(
                color: colors.textSecondary,
              ),
            )
          else
            Wrap(
              spacing: AppSpacing.xs,
              runSpacing: AppSpacing.xs,
              children: [
                for (final item in categories)
                  _CategoryBadge(
                    item: item,
                    categoriesCatalog: categoriesAsync.valueOrNull,
                    locale: locale,
                  ),
              ],
            ),
          const SizedBox(height: AppSpacing.md),
          AppButton(
            label: t.proProfile.editCategories,
            variant: AppButtonVariant.secondary,
            icon: const Icon(Icons.edit_rounded, size: AppIconSize.sm),
            onPressed: onEdit,
          ),
        ],
      ),
    );
  }
}

class _CategoryBadge extends StatelessWidget {
  const _CategoryBadge({
    required this.item,
    required this.categoriesCatalog,
    required this.locale,
  });

  final V1ProvidersMePost200ResponseProviderCategoriesInner item;
  final List<CategoryTreeNode>? categoriesCatalog;
  final Locale locale;

  @override
  Widget build(BuildContext context) {
    var label = item.categoryId;
    if (categoriesCatalog != null) {
      final match = categoriesCatalog!.where(
        (c) => c.id == item.categoryId,
      );
      if (match.isNotEmpty) {
        label = locale.languageCode == 'ar'
            ? match.first.nameAr
            : match.first.nameFr;
      }
    }

    return AppBadge(
      label: label,
      variant: item.isPrimary
          ? AppBadgeVariant.verified
          : AppBadgeVariant.neutral,
      icon: item.isPrimary ? Icons.star_rounded : null,
      bordered: !item.isPrimary,
    );
  }
}

class _ProZonesCard extends ConsumerWidget {
  const _ProZonesCard({
    required this.profile,
    required this.onEdit,
  });

  final ProviderMe profile;
  final VoidCallback onEdit;

  BuiltList<V1ProvidersMePost200ResponseProviderCoverageAreasInner> get _zones {
    try {
      return profile.coverageAreas;
    } on Object catch (_) {
      return BuiltList();
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final t = ref.watch(translationsProvider);
    final colors = context.colors;
    final locale = Localizations.localeOf(context);
    final governoratesAsync = ref.watch(governoratesProvider);
    final zones = _zones;

    return AppCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            children: [
              Container(
                width: 44,
                height: 44,
                decoration: BoxDecoration(
                  color: colors.accentSubtle,
                  borderRadius: const BorderRadius.all(AppRadius.md),
                ),
                child: Icon(
                  Icons.map_rounded,
                  color: colors.accent,
                  size: AppIconSize.md,
                ),
              ),
              const SizedBox(width: AppSpacing.md),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      t.proProfile.zonesSection,
                      style: AppText.bodyStrong(locale).copyWith(
                        color: colors.textPrimary,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      t.proProfile.zonesDesc,
                      style: AppText.caption(locale).copyWith(
                        color: colors.textSecondary,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.md),
          if (zones.isEmpty)
            Text(
              t.proProfile.zonesEmpty,
              style: AppText.body(locale).copyWith(
                color: colors.textSecondary,
              ),
            )
          else
            Wrap(
              spacing: AppSpacing.xs,
              runSpacing: AppSpacing.xs,
              children: [
                for (final item in zones)
                  _GovernorateBadge(
                    governorateId: item.governorateId,
                    governoratesCatalog: governoratesAsync.valueOrNull,
                    locale: locale,
                  ),
              ],
            ),
          const SizedBox(height: AppSpacing.md),
          AppButton(
            label: t.proProfile.editZones,
            variant: AppButtonVariant.secondary,
            icon: const Icon(
              Icons.edit_location_rounded,
              size: AppIconSize.sm,
            ),
            onPressed: onEdit,
          ),
        ],
      ),
    );
  }
}

class _GovernorateBadge extends StatelessWidget {
  const _GovernorateBadge({
    required this.governorateId,
    required this.governoratesCatalog,
    required this.locale,
  });

  final String governorateId;
  final List<Governorate>? governoratesCatalog;
  final Locale locale;

  @override
  Widget build(BuildContext context) {
    var label = governorateId.toUpperCase();
    if (governoratesCatalog != null) {
      final match = governoratesCatalog!.where(
        (g) => g.id == governorateId,
      );
      if (match.isNotEmpty) {
        label = locale.languageCode == 'ar'
            ? match.first.nameAr
            : match.first.nameFr;
      }
    }

    return AppBadge(
      label: label,
      variant: AppBadgeVariant.neutral,
      icon: Icons.location_on_outlined,
      bordered: true,
    );
  }
}
