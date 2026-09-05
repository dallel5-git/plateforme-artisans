import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sanaya/app/providers.dart';
import 'package:sanaya/core/theme/app_colors.dart';
import 'package:sanaya/core/theme/app_spacing.dart';
import 'package:sanaya/core/theme/app_text.dart';
import 'package:sanaya/core/widgets/app_button.dart';
import 'package:sanaya/core/widgets/app_card.dart';
import 'package:sanaya/core/widgets/app_text_field.dart';
import 'package:sanaya/features/onboarding/data/onboarding_repository.dart';
import 'package:sanaya/features/search/application/catalog_providers.dart';
import 'package:sanaya/features/search/data/catalog_repository.dart';

/// Valeurs collectées par l'étape « profil », remises telles quelles à
/// l'écran parent (`OnboardingScreen`) qui construit le
/// `V1ProvidersMePostRequest` et pilote `OnboardingNotifier.saveProfile` —
/// ce widget reste pure présentation (P3), sans savoir que Riverpod existe.
class ProfileStepValues {
  const ProfileStepValues({
    required this.businessName,
    required this.baseGovernorateId,
    this.headline,
    this.bio,
    this.yearsExperience,
    this.whatsappPhone,
    this.publicPhone,
  });

  final String businessName;
  final String baseGovernorateId;
  final String? headline;
  final String? bio;
  final int? yearsExperience;
  final String? whatsappPhone;
  final String? publicPhone;
}

class OnboardingProfileStep extends StatefulWidget {
  const OnboardingProfileStep({
    required this.initialProfile,
    required this.isSaving,
    required this.errorMessage,
    required this.onSubmit,
    this.submitLabel,
    super.key,
  });

  final ProviderMe? initialProfile;
  final bool isSaving;
  final String? errorMessage;
  final ValueChanged<ProfileStepValues> onSubmit;

  /// Libellé du bouton de validation. `null` = « Suivant » (parcours
  /// d'onboarding, comportement historique). `ProProfileScreen` (FM-38c)
  /// passe son propre libellé « Enregistrer » — ce widget reste sans savoir
  /// dans quel écran il est monté (P3 CLAUDE.md).
  final String? submitLabel;

  @override
  State<OnboardingProfileStep> createState() => _OnboardingProfileStepState();
}

class _OnboardingProfileStepState extends State<OnboardingProfileStep> {
  late final TextEditingController _businessName;
  late final TextEditingController _headline;
  late final TextEditingController _bio;
  late final TextEditingController _yearsExperience;
  late final TextEditingController _whatsapp;
  late final TextEditingController _publicPhone;
  String? _baseGovernorateId;

  @override
  void initState() {
    super.initState();
    final profile = widget.initialProfile;
    _businessName = TextEditingController(text: profile?.businessName ?? '');
    _headline = TextEditingController(text: profile?.headline ?? '');
    _bio = TextEditingController(text: profile?.bio ?? '');
    _yearsExperience = TextEditingController(
      text: (profile != null && profile.yearsExperience > 0)
          ? '${profile.yearsExperience}'
          : '',
    );
    _whatsapp = TextEditingController(text: profile?.whatsappPhone ?? '');
    _publicPhone = TextEditingController(text: profile?.publicPhone ?? '');
    _baseGovernorateId = profile?.baseGovernorateId;
  }

  @override
  void dispose() {
    _businessName.dispose();
    _headline.dispose();
    _bio.dispose();
    _yearsExperience.dispose();
    _whatsapp.dispose();
    _publicPhone.dispose();
    super.dispose();
  }

  bool get _canSubmit =>
      _businessName.text.trim().isNotEmpty &&
      _baseGovernorateId != null &&
      !widget.isSaving;

  void _submit() {
    if (!_canSubmit) return;
    widget.onSubmit(
      ProfileStepValues(
        businessName: _businessName.text.trim(),
        baseGovernorateId: _baseGovernorateId!,
        headline: _headline.text.trim().isEmpty ? null : _headline.text.trim(),
        bio: _bio.text.trim().isEmpty ? null : _bio.text.trim(),
        yearsExperience: int.tryParse(_yearsExperience.text.trim()),
        whatsappPhone: _whatsapp.text.trim().isEmpty
            ? null
            : _whatsapp.text.trim(),
        publicPhone: _publicPhone.text.trim().isEmpty
            ? null
            : _publicPhone.text.trim(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Consumer(
      builder: (context, ref, _) {
        final t = ref.watch(translationsProvider);
        return ListView(
          padding: const EdgeInsets.all(AppSpacing.lg),
          children: [
            AppTextField(
              label: t.onboarding.profileBusinessName,
              controller: _businessName,
              onChanged: (_) => setState(() {}),
            ),
            const SizedBox(height: AppSpacing.md),
            AppTextField(
              label: t.onboarding.profileHeadline,
              controller: _headline,
            ),
            const SizedBox(height: AppSpacing.md),
            AppTextField(
              label: t.onboarding.profileBio,
              controller: _bio,
            ),
            const SizedBox(height: AppSpacing.md),
            AppTextField(
              label: t.onboarding.profileYearsExperience,
              controller: _yearsExperience,
              keyboardType: TextInputType.number,
            ),
            const SizedBox(height: AppSpacing.md),
            AppTextField(
              label: t.onboarding.profileWhatsapp,
              controller: _whatsapp,
              keyboardType: TextInputType.phone,
            ),
            const SizedBox(height: AppSpacing.md),
            AppTextField(
              label: t.onboarding.profilePublicPhone,
              controller: _publicPhone,
              keyboardType: TextInputType.phone,
            ),
            const SizedBox(height: AppSpacing.md),
            _GovernoratePicker(
              label: t.onboarding.profileGovernorate,
              errorLabel: t.onboarding.profileGovernorateError,
              selectedId: _baseGovernorateId,
              onSelected: (id) => setState(() => _baseGovernorateId = id),
            ),
            if (widget.errorMessage != null) ...[
              const SizedBox(height: AppSpacing.md),
              Text(
                widget.errorMessage!,
                style: AppText.small(
                  Localizations.localeOf(context),
                ).copyWith(color: context.colors.destructive),
              ),
            ],
            const SizedBox(height: AppSpacing.xl),
            AppButton(
              label: widget.submitLabel ?? t.onboarding.next,
              onPressed: _canSubmit ? _submit : null,
            ),
          ],
        );
      },
    );
  }
}

class _GovernoratePicker extends ConsumerWidget {
  const _GovernoratePicker({
    required this.label,
    required this.errorLabel,
    required this.selectedId,
    required this.onSelected,
  });

  final String label;
  final String errorLabel;
  final String? selectedId;
  final ValueChanged<String> onSelected;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final governoratesAsync = ref.watch(governoratesProvider);
    final colors = context.colors;
    final locale = Localizations.localeOf(context);

    return governoratesAsync.when(
      loading: () => const SizedBox.shrink(),
      error: (error, stackTrace) => Text(
        errorLabel,
        style: AppText.small(locale).copyWith(color: colors.destructive),
      ),
      data: (governorates) {
        Governorate? selected;
        for (final g in governorates) {
          if (g.id == selectedId) selected = g;
        }
        final selectedLabel = selected == null
            ? label
            : (locale.languageCode == 'ar' ? selected.nameAr : selected.nameFr);

        return AppCard(
          child: InkWell(
            onTap: () => _openPicker(context, governorates, locale),
            child: Row(
              children: [
                Expanded(
                  child: Text(
                    selectedLabel,
                    style: AppText.body(
                      locale,
                    ).copyWith(color: colors.textPrimary),
                  ),
                ),
                Icon(Icons.expand_more, color: colors.textMuted),
              ],
            ),
          ),
        );
      },
    );
  }

  void _openPicker(
    BuildContext context,
    List<Governorate> governorates,
    Locale locale,
  ) {
    unawaited(
      showModalBottomSheet<void>(
        context: context,
        isScrollControlled: true,
        builder: (_) => SafeArea(
          child: ListView.builder(
            shrinkWrap: true,
            itemCount: governorates.length,
            itemBuilder: (context, index) {
              final governorate = governorates[index];
              final itemLabel = locale.languageCode == 'ar'
                  ? governorate.nameAr
                  : governorate.nameFr;
              return ListTile(
                title: Text(itemLabel),
                onTap: () {
                  onSelected(governorate.id);
                  Navigator.of(context).pop();
                },
              );
            },
          ),
        ),
      ),
    );
  }
}
