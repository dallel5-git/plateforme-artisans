import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sanaya/app/providers.dart';
import 'package:sanaya/core/api/generated/api.dart';
import 'package:sanaya/core/theme/app_colors.dart';
import 'package:sanaya/core/theme/app_spacing.dart';
import 'package:sanaya/core/theme/app_text.dart';
import 'package:sanaya/core/widgets/app_button.dart';
import 'package:sanaya/features/onboarding/data/onboarding_repository.dart';
import 'package:sanaya/features/pro_profile/application/pro_profile_providers.dart';
import 'package:sanaya/features/pro_profile/data/offerings_repository.dart';

/// Feuille modale d'ajout ou modification d'une offre tarifaire (MOB-022 / BE-47).
class OfferingEditBottomSheet extends ConsumerStatefulWidget {
  const OfferingEditBottomSheet({
    required this.profile,
    this.initialOffering,
    super.key,
  });

  final ProviderMe profile;
  final MyOffering? initialOffering;

  @override
  ConsumerState<OfferingEditBottomSheet> createState() =>
      _OfferingEditBottomSheetState();
}

class _OfferingEditBottomSheetState
    extends ConsumerState<OfferingEditBottomSheet> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _titleFrController;
  late final TextEditingController _titleArController;
  late final TextEditingController _descriptionController;
  late final TextEditingController _priceMinController;
  late final TextEditingController _priceMaxController;

  String? _selectedCategoryId;
  String _priceUnit = 'FIXED';
  bool _isNegotiable = false;
  bool _isSaving = false;
  String? _errorMessage;

  @override
  void initState() {
    super.initState();
    final initial = widget.initialOffering;
    _titleFrController = TextEditingController(text: initial?.titleFr ?? '');
    _titleArController = TextEditingController(text: initial?.titleAr ?? '');
    _descriptionController = TextEditingController(
      text: initial?.description ?? '',
    );
    _priceMinController = TextEditingController(
      text: initial?.priceMin != null ? '${initial!.priceMin}' : '',
    );
    _priceMaxController = TextEditingController(
      text: initial?.priceMax != null ? '${initial!.priceMax}' : '',
    );

    if (initial != null) {
      _priceUnit = initial.priceUnit.name;
      _isNegotiable = initial.isNegotiable;
      _selectedCategoryId = widget.profile.categories
          .where((c) => c.categoryId.isNotEmpty)
          .map((c) => c.categoryId)
          .firstOrNull;
    } else {
      _selectedCategoryId = widget.profile.categories.isNotEmpty
          ? widget.profile.categories.first.categoryId
          : null;
    }
  }

  @override
  void dispose() {
    _titleFrController.dispose();
    _titleArController.dispose();
    _descriptionController.dispose();
    _priceMinController.dispose();
    _priceMaxController.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;
    if (_selectedCategoryId == null) return;

    final t = ref.read(translationsProvider);
    setState(() {
      _isSaving = true;
      _errorMessage = null;
    });

    final repo = ref.read(offeringsRepositoryProvider);
    final isEditing = widget.initialOffering != null;

    final priceMin =
        _priceUnit != 'ON_QUOTE' && _priceMinController.text.trim().isNotEmpty
        ? num.tryParse(_priceMinController.text.trim().replaceAll(',', '.'))
        : null;
    final priceMax =
        _priceUnit != 'ON_QUOTE' && _priceMaxController.text.trim().isNotEmpty
        ? num.tryParse(_priceMaxController.text.trim().replaceAll(',', '.'))
        : null;

    try {
      if (isEditing) {
        final patchUnitEnum =
            V1ProvidersMeOfferingsIdPatchRequestPriceUnitEnum.valueOf(
              _priceUnit,
            );
        final patchRequest = V1ProvidersMeOfferingsIdPatchRequest(
          (b) => b
            ..titleFr = _titleFrController.text.trim()
            ..titleAr = _titleArController.text.trim().isNotEmpty
                ? _titleArController.text.trim()
                : null
            ..description = _descriptionController.text.trim().isNotEmpty
                ? _descriptionController.text.trim()
                : null
            ..priceMin = priceMin
            ..priceMax = priceMax
            ..priceUnit = patchUnitEnum
            ..isNegotiable = _isNegotiable,
        );
        await repo.updateOffering(widget.initialOffering!.id, patchRequest);
      } else {
        final postUnitEnum =
            V1ProvidersMeOfferingsPostRequestPriceUnitEnum.valueOf(_priceUnit);
        final postRequest = V1ProvidersMeOfferingsPostRequest(
          (b) => b
            ..categoryId = _selectedCategoryId
            ..titleFr = _titleFrController.text.trim()
            ..titleAr = _titleArController.text.trim().isNotEmpty
                ? _titleArController.text.trim()
                : null
            ..description = _descriptionController.text.trim().isNotEmpty
                ? _descriptionController.text.trim()
                : null
            ..priceMin = priceMin
            ..priceMax = priceMax
            ..priceUnit = postUnitEnum
            ..isNegotiable = _isNegotiable,
        );
        await repo.createOffering(postRequest);
      }

      ref.invalidate(myOfferingsProvider);
      if (!mounted) return;
      Navigator.of(context).pop();
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(t.proProfile.offeringsSaved)),
      );
    } on Object {
      if (!mounted) return;
      setState(() {
        _isSaving = false;
        _errorMessage = t.proProfile.errorMessage;
      });
    }
  }

  String _unitLabel(String unit) {
    final t = ref.read(translationsProvider);
    return switch (unit) {
      'HOUR' => t.proProfile.unitHour,
      'DAY' => t.proProfile.unitDay,
      'SQUARE_METER' => t.proProfile.unitSquareMeter,
      'ON_QUOTE' => t.proProfile.unitOnQuote,
      _ => t.proProfile.unitFixed,
    };
  }

  @override
  Widget build(BuildContext context) {
    final t = ref.watch(translationsProvider);
    final colors = context.colors;
    final locale = Localizations.localeOf(context);
    final isEditing = widget.initialOffering != null;
    final isArabic = locale.languageCode == 'ar';

    return SingleChildScrollView(
      padding: EdgeInsets.only(
        left: AppSpacing.md,
        right: AppSpacing.md,
        top: AppSpacing.md,
        bottom: MediaQuery.viewInsetsOf(context).bottom + AppSpacing.xl,
      ),
      child: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          mainAxisSize: MainAxisSize.min,
          children: [
            Center(
              child: Container(
                width: 36,
                height: 4,
                decoration: BoxDecoration(
                  color: colors.border,
                  borderRadius: const BorderRadius.all(AppRadius.pill),
                ),
              ),
            ),
            const SizedBox(height: AppSpacing.md),
            Text(
              isEditing
                  ? t.proProfile.offeringsEdit
                  : t.proProfile.offeringsAdd,
              style: AppText.h2(locale).copyWith(
                color: colors.textPrimary,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: AppSpacing.sm),
            Text(
              t.proProfile.offeringsDesc,
              style: AppText.small(locale).copyWith(
                color: colors.textSecondary,
              ),
            ),
            const SizedBox(height: AppSpacing.lg),

            if (!isEditing && widget.profile.categories.length > 1) ...[
              Text(
                t.proProfile.offeringCategory,
                style: AppText.body(locale).copyWith(
                  fontWeight: FontWeight.w600,
                  color: colors.textPrimary,
                ),
              ),
              const SizedBox(height: AppSpacing.xs),
              Wrap(
                spacing: AppSpacing.sm,
                children: [
                  for (final cat in widget.profile.categories)
                    ChoiceChip(
                      label: Text(cat.categoryId),
                      selected: _selectedCategoryId == cat.categoryId,
                      onSelected: (selected) {
                        if (selected) {
                          setState(() => _selectedCategoryId = cat.categoryId);
                        }
                      },
                    ),
                ],
              ),
              const SizedBox(height: AppSpacing.md),
            ],

            TextFormField(
              controller: _titleFrController,
              decoration: InputDecoration(
                labelText: t.proProfile.offeringTitleFr,
                border: const OutlineInputBorder(),
              ),
              validator: (v) {
                if (v == null || v.trim().isEmpty) {
                  return isArabic
                      ? 'هذا الحقل إجباري'
                      : 'Ce champ est obligatoire';
                }
                if (v.trim().length > 160) {
                  return isArabic
                      ? '160 حرف كحد أقصى'
                      : '160 caractères maximum';
                }
                return null;
              },
            ),
            const SizedBox(height: AppSpacing.md),

            TextFormField(
              controller: _titleArController,
              textDirection: TextDirection.rtl,
              decoration: InputDecoration(
                labelText: t.proProfile.offeringTitleAr,
                border: const OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: AppSpacing.md),

            TextFormField(
              controller: _descriptionController,
              maxLines: 2,
              decoration: InputDecoration(
                labelText: t.proProfile.offeringDescription,
                border: const OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: AppSpacing.md),

            Text(
              t.proProfile.offeringPriceUnit,
              style: AppText.body(locale).copyWith(
                fontWeight: FontWeight.w600,
                color: colors.textPrimary,
              ),
            ),
            const SizedBox(height: AppSpacing.xs),
            Wrap(
              spacing: AppSpacing.xs,
              runSpacing: AppSpacing.xs,
              children: [
                for (final unit in [
                  'FIXED',
                  'HOUR',
                  'DAY',
                  'SQUARE_METER',
                  'ON_QUOTE',
                ])
                  ChoiceChip(
                    label: Text(_unitLabel(unit)),
                    selected: _priceUnit == unit,
                    onSelected: (sel) {
                      if (sel) setState(() => _priceUnit = unit);
                    },
                  ),
              ],
            ),
            const SizedBox(height: AppSpacing.md),

            if (_priceUnit != 'ON_QUOTE') ...[
              Row(
                children: [
                  Expanded(
                    child: TextFormField(
                      controller: _priceMinController,
                      keyboardType: const TextInputType.numberWithOptions(
                        decimal: true,
                      ),
                      decoration: InputDecoration(
                        labelText: t.proProfile.offeringPriceMin,
                        suffixText: 'DT',
                        border: const OutlineInputBorder(),
                      ),
                      validator: (v) {
                        if (v != null && v.trim().isNotEmpty) {
                          final numVal = num.tryParse(
                            v.trim().replaceAll(',', '.'),
                          );
                          if (numVal == null || numVal <= 0) {
                            return isArabic
                                ? 'السعر غير صالح'
                                : 'Prix invalide';
                          }
                        }
                        return null;
                      },
                    ),
                  ),
                  const SizedBox(width: AppSpacing.md),
                  Expanded(
                    child: TextFormField(
                      controller: _priceMaxController,
                      keyboardType: const TextInputType.numberWithOptions(
                        decimal: true,
                      ),
                      decoration: InputDecoration(
                        labelText: t.proProfile.offeringPriceMax,
                        suffixText: 'DT',
                        border: const OutlineInputBorder(),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: AppSpacing.md),
            ],

            SwitchListTile.adaptive(
              title: Text(
                t.proProfile.offeringNegotiableSwitch,
                style: AppText.body(locale),
              ),
              value: _isNegotiable,
              onChanged: (val) => setState(() => _isNegotiable = val),
              contentPadding: EdgeInsets.zero,
            ),
            const SizedBox(height: AppSpacing.md),

            if (_errorMessage != null) ...[
              Text(
                _errorMessage!,
                style: AppText.small(locale).copyWith(
                  color: colors.destructive,
                ),
              ),
              const SizedBox(height: AppSpacing.md),
            ],

            AppButton(
              label: _isSaving ? '...' : t.proProfile.save,
              onPressed: _isSaving ? null : _submit,
            ),
          ],
        ),
      ),
    );
  }
}
