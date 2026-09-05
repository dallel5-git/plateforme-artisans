import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:sanaya/app/providers.dart';
import 'package:sanaya/core/api/generated/api.dart';
import 'package:sanaya/core/theme/app_colors.dart';
import 'package:sanaya/core/theme/app_spacing.dart';
import 'package:sanaya/core/theme/app_text.dart';
import 'package:sanaya/core/widgets/app_button.dart';
import 'package:sanaya/core/widgets/app_skeleton.dart';
import 'package:sanaya/core/widgets/empty_state.dart';
import 'package:sanaya/core/widgets/error_state.dart';
import 'package:sanaya/features/onboarding/data/onboarding_repository.dart';
import 'package:sanaya/features/onboarding/presentation/widgets/onboarding_profile_step.dart';
import 'package:sanaya/features/pro_profile/application/pro_profile_providers.dart';
import 'package:sanaya/features/pro_profile/presentation/widgets/availability_selector.dart';
import 'package:sanaya/features/reviews/application/pro_reviews_providers.dart';
import 'package:sanaya/features/settings/presentation/account_settings_section.dart';

/// Onglet Profil pro (`/pro/profile`, FM-38, issue #235) : édition post-
/// onboarding (bio, téléphones…, `OnboardingProfileStep` réutilisé tel quel
/// — FM-38b lui a ajouté `submitLabel`/`shrinkWrap` pour ce cas), badge de
/// disponibilité commutable, bascule « Accepte les urgences » (alimente le
/// chip Urgence de la recherche, FM-28), lien vers sa propre fiche publique,
/// réglages (`AccountSettingsSection`, FM-38a). Remplace
/// `ProProfilePlaceholderScreen`.
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

    // `baseGovernorateId` n'est pas envoyé : `updateProviderMeSchema` ne
    // l'accepte pas en PATCH (voir `OnboardingProfileStep.showGovernorate`,
    // FM-38c) — le champ n'est de toute façon pas affiché dans ce contexte.
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
              ),
      ),
    );
  }
}

class _ProProfileSkeleton extends StatelessWidget {
  const _ProProfileSkeleton();

  @override
  Widget build(BuildContext context) {
    return const Padding(
      padding: EdgeInsets.all(AppSpacing.md),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          AppSkeleton(height: 72),
          SizedBox(height: AppSpacing.lg),
          AppSkeleton(height: 56),
          SizedBox(height: AppSpacing.md),
          AppSkeleton(height: 320),
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
  });

  final ProviderMe profile;
  final bool isSaving;
  final String? errorMessage;
  final ValueChanged<ProfileStepValues> onSubmitProfile;
  final ValueChanged<V1ProvidersMePatchRequestAvailabilityStatusEnum>
  onSelectAvailability;
  final ValueChanged<bool> onToggleAcceptsEmergency;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final t = ref.watch(translationsProvider);
    final colors = context.colors;
    final locale = Localizations.localeOf(context);

    return ListView(
      padding: const EdgeInsets.all(AppSpacing.md),
      children: [
        AvailabilitySelector(
          status: profile.availabilityStatus,
          onSelect: onSelectAvailability,
        ),
        const SizedBox(height: AppSpacing.md),
        _AcceptsEmergencyTile(
          value: profile.acceptsEmergency,
          onChanged: onToggleAcceptsEmergency,
        ),
        const SizedBox(height: AppSpacing.md),
        AppButton(
          label: t.proProfile.viewMyListing,
          variant: AppButtonVariant.secondary,
          onPressed: () => context.push('/providers/${profile.slug}'),
        ),
        const SizedBox(height: AppSpacing.xl),
        Text(
          t.proProfile.editSection,
          style: AppText.h3(locale).copyWith(color: colors.textPrimary),
        ),
        const SizedBox(height: AppSpacing.md),
        OnboardingProfileStep(
          initialProfile: profile,
          isSaving: isSaving,
          errorMessage: errorMessage,
          onSubmit: onSubmitProfile,
          submitLabel: t.proProfile.save,
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          showGovernorate: false,
        ),
        const SizedBox(height: AppSpacing.xl),
        AccountSettingsSection(
          onOpenLegal: () => context.push('/pro/profile/legal'),
          accountActions: [
            AppButton(
              label: t.proProfile.switchToClientSpace,
              variant: AppButtonVariant.secondary,
              onPressed: () => context.go('/client'),
            ),
          ],
        ),
      ],
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
