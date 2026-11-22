import 'package:flutter/material.dart';
import 'package:sanaya/core/api/generated/api.dart';
import 'package:sanaya/core/i18n/translations.g.dart';
import 'package:sanaya/core/theme/app_colors.dart';
import 'package:sanaya/core/theme/app_spacing.dart';
import 'package:sanaya/core/theme/app_text.dart';
import 'package:sanaya/core/widgets/app_card.dart';
import 'package:sanaya/core/widgets/app_text_field.dart';

/// Barre de recherche de l'accueil client : service (texte libre) +
/// localisation (déclenche un sélecteur externe via [onLocationTap]).
/// Supporte un bouton d'effacement / validation et l'affichage de suggestions
/// en temps réel pour une recherche efficace et ergonomique.
class SearchHomeBar extends StatefulWidget {
  const SearchHomeBar({
    required this.t,
    required this.locationLabel,
    required this.onLocationTap,
    super.key,
    this.controller,
    this.suggestions = const [],
    this.onSuggestionTap,
    this.onQueryChanged,
    this.onQuerySubmitted,
  });

  final Translations t;
  final String locationLabel;
  final VoidCallback onLocationTap;
  final TextEditingController? controller;
  final List<CategoryTreeNode> suggestions;
  final ValueChanged<CategoryTreeNode>? onSuggestionTap;
  final ValueChanged<String>? onQueryChanged;
  final ValueChanged<String>? onQuerySubmitted;

  @override
  State<SearchHomeBar> createState() => _SearchHomeBarState();
}

class _SearchHomeBarState extends State<SearchHomeBar> {
  TextEditingController? _internalController;
  TextEditingController get _effectiveController =>
      widget.controller ?? (_internalController ??= TextEditingController());

  @override
  void initState() {
    super.initState();
    _effectiveController.addListener(_handleTextChange);
  }

  @override
  void didUpdateWidget(SearchHomeBar oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.controller != widget.controller) {
      (oldWidget.controller ?? _internalController)
          ?.removeListener(_handleTextChange);
      _effectiveController.addListener(_handleTextChange);
    }
  }

  @override
  void dispose() {
    _effectiveController.removeListener(_handleTextChange);
    _internalController?.dispose();
    super.dispose();
  }

  void _handleTextChange() {
    if (mounted) {
      setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final locale = Localizations.localeOf(context);
    final hasText = _effectiveController.text.trim().isNotEmpty;

    return AppCard(
      padding: const EdgeInsets.all(AppSpacing.sm),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          AppTextField(
            controller: _effectiveController,
            hintText: widget.t.search.searchPlaceholder,
            prefixIcon: Icon(Icons.search, color: colors.textMuted),
            textInputAction: TextInputAction.search,
            suffixIcon: hasText
                ? Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(
                        icon: const Icon(Icons.close, size: 20),
                        color: colors.textMuted,
                        onPressed: () {
                          _effectiveController.clear();
                          widget.onQueryChanged?.call('');
                        },
                      ),
                      IconButton(
                        icon: Icon(
                          Icons.arrow_forward,
                          size: 20,
                          color: colors.accent,
                        ),
                        onPressed: () {
                          widget.onQuerySubmitted?.call(
                            _effectiveController.text,
                          );
                        },
                      ),
                    ],
                  )
                : null,
            onChanged: widget.onQueryChanged,
            onSubmitted: widget.onQuerySubmitted,
          ),
          if (widget.suggestions.isNotEmpty) ...[
            const SizedBox(height: AppSpacing.xs),
            Wrap(
              spacing: AppSpacing.xs,
              runSpacing: AppSpacing.xxs,
              children: widget.suggestions.map((cat) {
                final catName = locale.languageCode == 'ar'
                    ? cat.nameAr
                    : cat.nameFr;
                return ActionChip(
                  avatar: Icon(Icons.search, size: 16, color: colors.accent),
                  label: Text(
                    catName,
                    style: AppText.small(locale).copyWith(
                      color: colors.textPrimary,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  backgroundColor: colors.surfaceRaised,
                  side: BorderSide(color: colors.border),
                  onPressed: () => widget.onSuggestionTap?.call(cat),
                );
              }).toList(),
            ),
          ],
          Divider(height: AppSpacing.lg, color: colors.border),
          InkWell(
            onTap: widget.onLocationTap,
            borderRadius: const BorderRadius.all(AppRadius.md),
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: AppSpacing.xs),
              child: Row(
                children: [
                  Icon(Icons.location_on_outlined, color: colors.accent),
                  const SizedBox(width: AppSpacing.sm),
                  Expanded(
                    child: Text(
                      widget.locationLabel,
                      style: AppText.bodyStrong(
                        locale,
                      ).copyWith(color: colors.textPrimary),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  Icon(Icons.chevron_right, color: colors.textMuted),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
