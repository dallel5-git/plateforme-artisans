import 'package:built_collection/built_collection.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:sanaya/app/providers.dart';
import 'package:sanaya/core/api/generated/api.dart';
import 'package:sanaya/core/i18n/translations.g.dart';
import 'package:sanaya/core/theme/app_colors.dart';
import 'package:sanaya/core/theme/app_spacing.dart';
import 'package:sanaya/core/theme/app_text.dart';
import 'package:sanaya/core/widgets/app_bottom_nav.dart';
import 'package:sanaya/core/widgets/app_button.dart';
import 'package:sanaya/core/widgets/app_card.dart';
import 'package:sanaya/core/widgets/app_skeleton.dart';
import 'package:sanaya/core/widgets/app_text_field.dart';
import 'package:sanaya/core/widgets/empty_state.dart';
import 'package:sanaya/core/widgets/error_state.dart';
import 'package:sanaya/core/widgets/offline_banner.dart';
import 'package:sanaya/core/widgets/provider_card.dart';
import 'package:sanaya/core/widgets/rating_stars.dart';
import 'package:sanaya/core/widgets/verified_badge.dart';
import 'package:sanaya/features/auth/presentation/widgets/otp_code_field.dart';
import 'package:sanaya/features/dashboard/data/dashboard_repository.dart';
import 'package:sanaya/features/dashboard/presentation/widgets/dashboard_comparison_chip.dart';
import 'package:sanaya/features/dashboard/presentation/widgets/dashboard_stat_card.dart';
import 'package:sanaya/features/dashboard/presentation/widgets/dashboard_trend_chart.dart';
import 'package:sanaya/features/favorites/presentation/widgets/favorite_card_skeleton.dart';
import 'package:sanaya/features/provider_profile/presentation/widgets/availability_chip.dart';
import 'package:sanaya/features/provider_profile/presentation/widgets/coverage_area_chip.dart';
import 'package:sanaya/features/provider_profile/presentation/widgets/offering_card.dart';
import 'package:sanaya/features/provider_profile/presentation/widgets/provider_gallery.dart';
import 'package:sanaya/features/provider_profile/presentation/widgets/rating_stars_input.dart';
import 'package:sanaya/features/provider_profile/presentation/widgets/review_tile.dart';
import 'package:sanaya/features/search/presentation/widgets/category_grid.dart';
import 'package:sanaya/features/search/presentation/widgets/category_grid_skeleton.dart';

/// Écran interne de vérification visuelle du design system (FM-04, enrichi
/// par FM-18d). Outil de développement, pas une fonctionnalité produit —
/// grandit au fil des PRs pour permettre une capture FR/AR sur device réel
/// de chaque widget au fur et à mesure de sa construction.
class DesignSystemPreviewScreen extends ConsumerWidget {
  const DesignSystemPreviewScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final t = ref.watch(translationsProvider);

    return Scaffold(
      backgroundColor: context.colors.background,
      appBar: AppBar(title: Text(t.common.home.designSystemPreview)),
      body: ListView(
        padding: const EdgeInsets.all(AppSpacing.lg),
        children: [
          _Section(
            title: t.common.devPreview.sectionColorRoles,
            child: _ColorRoleSwatches(t: t),
          ),
          const SizedBox(height: AppSpacing.xl),
          _Section(
            title: t.common.devPreview.sectionTypography,
            child: const _TypographyScale(),
          ),
          const SizedBox(height: AppSpacing.xl),
          _Section(
            title: t.common.devPreview.sectionAppButton,
            child: Wrap(
              spacing: AppSpacing.sm,
              runSpacing: AppSpacing.sm,
              children: [
                AppButton(
                  label: t.common.devPreview.buttonPrimary,
                  onPressed: () {},
                ),
                AppButton(
                  label: t.common.devPreview.buttonDisabled,
                  onPressed: null,
                ),
                AppButton(
                  label: t.common.devPreview.buttonSecondary,
                  onPressed: () {},
                  variant: AppButtonVariant.secondary,
                ),
                AppButton(
                  label: t.common.devPreview.buttonGhost,
                  onPressed: () {},
                  variant: AppButtonVariant.ghost,
                ),
                AppButton(
                  label: t.common.devPreview.buttonWhatsapp,
                  onPressed: () {},
                  variant: AppButtonVariant.whatsapp,
                ),
                AppButton(
                  label: t.common.devPreview.buttonOutlineWhatsapp,
                  onPressed: () {},
                  variant: AppButtonVariant.outlineWhatsapp,
                ),
                AppButton(
                  label: t.common.devPreview.buttonDanger,
                  onPressed: () {},
                  variant: AppButtonVariant.danger,
                  size: AppButtonSize.small,
                ),
              ],
            ),
          ),
          const SizedBox(height: AppSpacing.xl),
          _Section(
            title: t.common.devPreview.sectionAppCard,
            child: AppCard(child: Text(t.common.appName)),
          ),
          const SizedBox(height: AppSpacing.xl),
          _Section(
            title: t.common.devPreview.sectionAppTextField,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                AppTextField(
                  label: t.common.devPreview.phoneLabel,
                  hintText: t.common.devPreview.phoneHint,
                ),
                const SizedBox(height: AppSpacing.md),
                AppTextField(
                  label: t.common.devPreview.otpLabel,
                  errorText: t.common.devPreview.otpError,
                ),
              ],
            ),
          ),
          const SizedBox(height: AppSpacing.xl),
          _Section(
            title: t.common.devPreview.sectionRatingStars,
            child: const Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                RatingStars(rating: 4.8, reviewCount: 63),
                SizedBox(height: AppSpacing.sm),
                RatingStars(rating: 4.2, reviewCount: 18),
              ],
            ),
          ),
          const SizedBox(height: AppSpacing.xl),
          _Section(
            title: t.common.devPreview.sectionVerifiedBadge,
            child: const VerifiedBadge(),
          ),
          const SizedBox(height: AppSpacing.xl),
          _Section(
            title: t.common.devPreview.sectionProviderCard,
            child: Column(
              children: [
                ProviderCard(
                  providerId: 'ds-preview-provider-1',
                  name: t.common.devPreview.sampleProvider1Name,
                  categoryLabel: t.common.devPreview.sampleProvider1Category,
                  locationLabel: t.common.devPreview.sampleProvider1Location,
                  rating: 4.8,
                  reviewCount: 63,
                  priceLabel: t.common.devPreview.sampleProvider1Price,
                  isVerified: true,
                  onTap: () {},
                ),
                const SizedBox(height: AppSpacing.sm),
                ProviderCard(
                  providerId: 'ds-preview-provider-2',
                  name: t.common.devPreview.sampleProvider2Name,
                  categoryLabel: t.common.devPreview.sampleProvider2Category,
                  locationLabel: t.common.devPreview.sampleProvider2Location,
                  rating: 4.2,
                  reviewCount: 18,
                  priceLabel: t.common.devPreview.sampleProvider2Price,
                  onTap: () {},
                ),
              ],
            ),
          ),
          const SizedBox(height: AppSpacing.xl),
          _Section(
            title: t.common.devPreview.sectionAppSkeleton,
            child: const Row(
              children: [
                AppSkeleton.circle(size: 48),
                SizedBox(width: AppSpacing.md),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      AppSkeleton(width: 140),
                      SizedBox(height: AppSpacing.sm),
                      AppSkeleton(width: 90),
                    ],
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: AppSpacing.xl),
          _Section(
            title: t.common.devPreview.sectionEmptyState,
            child: EmptyState(
              icon: '🔍',
              title: t.common.devPreview.emptyTitle,
              message: t.common.devPreview.emptyMessage,
              actionLabel: t.common.devPreview.emptyAction,
              onAction: () {},
            ),
          ),
          const SizedBox(height: AppSpacing.xl),
          _Section(
            title: t.common.devPreview.sectionErrorState,
            child: ErrorState(
              icon: '⚠️',
              title: t.common.devPreview.errorTitle,
              message: t.common.devPreview.errorMessage,
              actionLabel: t.common.devPreview.errorAction,
              onAction: () {},
            ),
          ),
          const SizedBox(height: AppSpacing.xl),
          _Section(
            title: t.common.devPreview.sectionOfflineBanner,
            child: OfflineBanner(onDismiss: () {}),
          ),
          const SizedBox(height: AppSpacing.xl),
          _Section(
            title: t.common.devPreview.sectionAvailabilityChip,
            child: const Wrap(
              spacing: AppSpacing.sm,
              runSpacing: AppSpacing.sm,
              children: [
                AvailabilityChip(
                  status: V1ProvidersSlugGet200ResponseAvailabilityStatusEnum
                      .AVAILABLE,
                ),
                AvailabilityChip(
                  status:
                      V1ProvidersSlugGet200ResponseAvailabilityStatusEnum.BUSY,
                ),
                AvailabilityChip(
                  status: V1ProvidersSlugGet200ResponseAvailabilityStatusEnum
                      .ON_HOLIDAY,
                ),
              ],
            ),
          ),
          const SizedBox(height: AppSpacing.xl),
          _Section(
            title: t.common.devPreview.sectionReviewTile,
            child: ReviewTile(review: _sampleReview),
          ),
          const SizedBox(height: AppSpacing.xl),
          _Section(
            title: t.common.devPreview.sectionOfferingCard,
            child: OfferingCard(offering: _sampleOffering),
          ),
          const SizedBox(height: AppSpacing.xl),
          _Section(
            title: t.common.devPreview.sectionProviderGallery,
            child: ProviderGallery(gallery: _sampleGallery),
          ),
          const SizedBox(height: AppSpacing.xl),
          _Section(
            title: t.common.devPreview.sectionDashboardStatCard,
            child: DashboardStatCard(
              label: t.common.devPreview.statViewsLabel,
              value: '1 284',
              comparisonRatio: 0.12,
              comparisonNewLabel: t.common.devPreview.statNewLabel,
            ),
          ),
          const SizedBox(height: AppSpacing.xl),
          _Section(
            title: t.common.devPreview.sectionDashboardTrendChart,
            child: DashboardTrendChart(series: _sampleSeries),
          ),
          const SizedBox(height: AppSpacing.xl),
          _Section(
            title: t.common.devPreview.sectionDashboardComparisonChip,
            child: Wrap(
              spacing: AppSpacing.sm,
              children: [
                DashboardComparisonChip(
                  deltaRatio: 0.12,
                  newLabel: t.common.devPreview.statNewLabel,
                ),
                DashboardComparisonChip(
                  deltaRatio: -0.08,
                  newLabel: t.common.devPreview.statNewLabel,
                ),
                DashboardComparisonChip(
                  deltaRatio: null,
                  newLabel: t.common.devPreview.statNewLabel,
                ),
              ],
            ),
          ),
          const SizedBox(height: AppSpacing.xl),
          _Section(
            title: t.common.devPreview.sectionRatingStarsInput,
            child: RatingStarsInput(value: 4, onChanged: (_) {}),
          ),
          const SizedBox(height: AppSpacing.xl),
          _Section(
            title: t.common.devPreview.sectionOtpCodeField,
            child: OtpCodeField(
              length: 6,
              autofocus: false,
              onCompleted: (_) {},
            ),
          ),
          const SizedBox(height: AppSpacing.xl),
          _Section(
            title: t.common.devPreview.sectionCoverageAreaChip,
            child: const Wrap(
              spacing: AppSpacing.sm,
              children: [
                CoverageAreaChip(label: 'Sousse'),
                CoverageAreaChip(label: 'Monastir'),
                CoverageAreaChip(label: 'Mahdia'),
              ],
            ),
          ),
          const SizedBox(height: AppSpacing.xl),
          _Section(
            title: t.common.devPreview.sectionCategoryGrid,
            child: CategoryGrid(categories: _sampleCategories, onTap: (_) {}),
          ),
          const SizedBox(height: AppSpacing.xl),
          _Section(
            title: t.common.devPreview.sectionCategoryGridSkeleton,
            child: const CategoryGridSkeleton(itemCount: 3),
          ),
          const SizedBox(height: AppSpacing.xl),
          _Section(
            title: t.common.devPreview.sectionFavoriteCardSkeleton,
            child: const FavoriteCardSkeleton(),
          ),
          const SizedBox(height: AppSpacing.xl),
          _Section(
            title: t.common.devPreview.sectionAppBottomNav,
            child: _AppBottomNavShowcase(t: t),
          ),
        ],
      ),
    );
  }
}

/// Rôles `AppColors`, groupés comme `Code/docs/design-system.html` §1 —
/// nuancier avec bascule clair/sombre locale (état propre à ce widget, ne
/// touche jamais `themeModeProvider` : la vitrine ne doit pas changer le
/// thème de toute l'app pour afficher les deux jeux de rôles côte à côte).
final List<(String, Color, Color)> _colorRoles = [
  ('background', AppColors.light.background, AppColors.dark.background),
  ('surface', AppColors.light.surface, AppColors.dark.surface),
  (
    'surfaceRaised',
    AppColors.light.surfaceRaised,
    AppColors.dark.surfaceRaised,
  ),
  (
    'surfaceSunken',
    AppColors.light.surfaceSunken,
    AppColors.dark.surfaceSunken,
  ),
  ('border', AppColors.light.border, AppColors.dark.border),
  ('borderStrong', AppColors.light.borderStrong, AppColors.dark.borderStrong),
  ('textPrimary', AppColors.light.textPrimary, AppColors.dark.textPrimary),
  (
    'textSecondary',
    AppColors.light.textSecondary,
    AppColors.dark.textSecondary,
  ),
  ('textMuted', AppColors.light.textMuted, AppColors.dark.textMuted),
  ('textInverse', AppColors.light.textInverse, AppColors.dark.textInverse),
  ('accent', AppColors.light.accent, AppColors.dark.accent),
  ('accentHover', AppColors.light.accentHover, AppColors.dark.accentHover),
  ('accentSubtle', AppColors.light.accentSubtle, AppColors.dark.accentSubtle),
  ('onAccent', AppColors.light.onAccent, AppColors.dark.onAccent),
  ('verified', AppColors.light.verified, AppColors.dark.verified),
  (
    'verifiedSubtle',
    AppColors.light.verifiedSubtle,
    AppColors.dark.verifiedSubtle,
  ),
  ('pending', AppColors.light.pending, AppColors.dark.pending),
  (
    'pendingSubtle',
    AppColors.light.pendingSubtle,
    AppColors.dark.pendingSubtle,
  ),
  ('destructive', AppColors.light.destructive, AppColors.dark.destructive),
  (
    'destructiveSubtle',
    AppColors.light.destructiveSubtle,
    AppColors.dark.destructiveSubtle,
  ),
  ('rating', AppColors.light.rating, AppColors.dark.rating),
  ('sponsored', AppColors.light.sponsored, AppColors.dark.sponsored),
  ('whatsapp', AppColors.light.whatsapp, AppColors.dark.whatsapp),
  ('onWhatsapp', AppColors.light.onWhatsapp, AppColors.dark.onWhatsapp),
  ('amber', AppColors.light.amber, AppColors.dark.amber),
  ('onAmber', AppColors.light.onAmber, AppColors.dark.onAmber),
  ('scrim', AppColors.light.scrim, AppColors.dark.scrim),
  ('onScrim', AppColors.light.onScrim, AppColors.dark.onScrim),
  ('thumbnail', AppColors.light.thumbnail, AppColors.dark.thumbnail),
  (
    'thumbnailBorder',
    AppColors.light.thumbnailBorder,
    AppColors.dark.thumbnailBorder,
  ),
  ('chartBar', AppColors.light.chartBar, AppColors.dark.chartBar),
  (
    'chartBarHighlight',
    AppColors.light.chartBarHighlight,
    AppColors.dark.chartBarHighlight,
  ),
  ('navActive', AppColors.light.navActive, AppColors.dark.navActive),
  ('navInactive', AppColors.light.navInactive, AppColors.dark.navInactive),
  (
    'navBackground',
    AppColors.light.navBackground,
    AppColors.dark.navBackground,
  ),
];

class _ColorRoleSwatches extends StatefulWidget {
  const _ColorRoleSwatches({required this.t});

  final Translations t;

  @override
  State<_ColorRoleSwatches> createState() => _ColorRoleSwatchesState();
}

class _ColorRoleSwatchesState extends State<_ColorRoleSwatches> {
  bool _dark = false;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Align(
          alignment: AlignmentDirectional.centerStart,
          child: SegmentedButton<bool>(
            segments: [
              ButtonSegment(
                value: false,
                label: Text(widget.t.common.devPreview.swatchLight),
              ),
              ButtonSegment(
                value: true,
                label: Text(widget.t.common.devPreview.swatchDark),
              ),
            ],
            selected: {_dark},
            onSelectionChanged: (selection) =>
                setState(() => _dark = selection.first),
          ),
        ),
        const SizedBox(height: AppSpacing.md),
        Wrap(
          spacing: AppSpacing.sm,
          runSpacing: AppSpacing.sm,
          children: [
            for (final role in _colorRoles)
              _ColorSwatch(name: role.$1, color: _dark ? role.$3 : role.$2),
          ],
        ),
      ],
    );
  }
}

class _ColorSwatch extends StatelessWidget {
  const _ColorSwatch({required this.name, required this.color});

  final String name;
  final Color color;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final locale = Localizations.localeOf(context);

    return Container(
      width: 96,
      padding: const EdgeInsets.all(AppSpacing.xs),
      decoration: BoxDecoration(
        border: Border.all(color: colors.border),
        borderRadius: const BorderRadius.all(AppRadius.md),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            height: 40,
            decoration: BoxDecoration(
              color: color,
              borderRadius: const BorderRadius.all(AppRadius.sm),
              border: Border.all(color: colors.border),
            ),
          ),
          const SizedBox(height: AppSpacing.xxs),
          Text(
            name,
            style: AppText.caption(
              locale,
            ).copyWith(color: colors.textSecondary),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }
}

/// Vitrine interactive d'`AppBottomNav` (FM-22) — état local pour illustrer
/// le changement d'onglet actif au tap, sur les 4 onglets du shell client
/// (`t.common.nav.*`, FM-19).
class _AppBottomNavShowcase extends StatefulWidget {
  const _AppBottomNavShowcase({required this.t});

  final Translations t;

  @override
  State<_AppBottomNavShowcase> createState() => _AppBottomNavShowcaseState();
}

class _AppBottomNavShowcaseState extends State<_AppBottomNavShowcase> {
  int _currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    final t = widget.t;
    final items = [
      AppBottomNavItem(icon: Icons.search, label: t.common.nav.searchTab),
      AppBottomNavItem(
        icon: Icons.favorite_border,
        label: t.common.nav.favoritesTab,
      ),
      AppBottomNavItem(icon: Icons.history, label: t.common.nav.historyTab),
      AppBottomNavItem(
        icon: Icons.person_outline,
        label: t.common.nav.profileTab,
      ),
    ];

    return ClipRRect(
      borderRadius: const BorderRadius.all(AppRadius.md),
      child: AppBottomNav(
        items: items,
        currentIndex: _currentIndex,
        onTap: (index) => setState(() => _currentIndex = index),
      ),
    );
  }
}

/// Échelle typographique complète (`AppText.*`, `packages/design-tokens`) —
/// les noms de méthode (`display`, `h1`…) sont des identifiants d'API, pas
/// du contenu produit : laissés en dur, même traitement que les noms de
/// variable CSS dans `design-system.html` (FM-18b).
class _TypographyScale extends StatelessWidget {
  const _TypographyScale();

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final locale = Localizations.localeOf(context);
    final entries = <(String, TextStyle)>[
      ('display', AppText.display(locale)),
      ('h1', AppText.h1(locale)),
      ('h2', AppText.h2(locale)),
      ('h3', AppText.h3(locale)),
      ('subtitle', AppText.subtitle(locale)),
      ('body', AppText.body(locale)),
      ('bodyStrong', AppText.bodyStrong(locale)),
      ('small', AppText.small(locale)),
      ('caption', AppText.caption(locale)),
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        for (final entry in entries) ...[
          Text(entry.$1, style: entry.$2.copyWith(color: colors.textPrimary)),
          const SizedBox(height: AppSpacing.sm),
        ],
      ],
    );
  }
}

/// Fixtures de démonstration (FM-18d) — pas des chaînes UI de la vitrine
/// elle-même (titres, libellés de bouton…), mais des données bilingues
/// alimentant un modèle généré ; même convention que les fixtures des
/// fichiers de test (ex. `provider_profile_screen_test.dart`), pas de clé
/// i18n : le widget choisit `nameFr`/`nameAr` lui-même selon la locale.
final V1ProvidersSlugReviewsGet200ResponseItemsInner _sampleReview =
    V1ProvidersSlugReviewsGet200ResponseItemsInner(
      (r) => r
        ..id = 'review-preview'
        ..rating = 5
        ..comment = 'Intervention rapide et soignée, je recommande.'
        ..isVerifiedContact = true
        ..createdAt = DateTime.utc(2026, 8, 20)
        ..authorDisplayName = 'Sonia Trabelsi',
    );

final V1ProvidersSlugGet200ResponseOfferingsInner _sampleOffering =
    V1ProvidersSlugGet200ResponseOfferingsInner(
      (o) => o
        ..id = 'offering-preview'
        ..category = V1ProvidersSlugGet200ResponseOfferingsInnerCategory(
          (c) => c
            ..slug = 'climatisation'
            ..nameFr = 'Climatisation'
            ..nameAr = 'تكييف',
        ).toBuilder()
        ..titleFr = 'Installation climatiseur split'
        ..titleAr = 'تركيب مكيف هواء منقسم'
        ..description = 'Devis gratuit, intervention sous 48h'
        ..priceMin = 150000
        ..priceMax = 300000
        ..priceUnit =
            V1ProvidersSlugGet200ResponseOfferingsInnerPriceUnitEnum.FIXED
        ..isNegotiable = false
        ..displayPrice = 'à partir de 150 TND',
    );

final List<V1ProvidersSlugGet200ResponseGalleryInner> _sampleGallery = [
  for (final id in ['1', '2', '3'])
    V1ProvidersSlugGet200ResponseGalleryInner(
      (g) => g
        ..id = 'gallery-$id'
        ..url = 'https://picsum.photos/seed/sanaya$id/800/600'
        ..width = 800
        ..height = 600
        ..blurhash = ''
        ..caption = ''
        ..category = V1ProvidersSlugGet200ResponseCoverageAreasInnerDelegation(
          (c) => c
            ..slug = 'chantier'
            ..nameFr = 'Chantier'
            ..nameAr = 'ورشة',
        ).toBuilder(),
    ),
];

final List<ProviderStatsSeriesPoint> _sampleSeries = [
  for (var i = 0; i < 7; i++)
    ProviderStatsSeriesPoint(
      (s) => s
        ..date = DateTime.utc(2026, 8, 20 + i)
        ..profileViews = 40 + i * 5
        ..uniqueProfileViews = 30 + i * 3
        ..contacts = 5 + i,
    ),
];

CategoryTreeNode _sampleCategory({
  required String slug,
  required String nameFr,
  required String nameAr,
  required String iconKey,
  required String colorHex,
}) => CategoryTreeNode(
  (c) => c
    ..id = 'category-$slug'
    ..slug = slug
    ..nameFr = nameFr
    ..nameAr = nameAr
    ..descriptionFr = nameFr
    ..descriptionAr = nameAr
    ..iconKey = iconKey
    ..colorHex = colorHex
    ..sortOrder = 1
    ..children = ListBuilder<CategoryTreeNode>([]),
);

final List<CategoryTreeNode> _sampleCategories = [
  _sampleCategory(
    slug: 'plomberie',
    nameFr: 'Plomberie',
    nameAr: 'سباكة',
    iconKey: 'plomberie',
    colorHex: '#3B6FE0',
  ),
  _sampleCategory(
    slug: 'electricite',
    nameFr: 'Électricité',
    nameAr: 'كهرباء',
    iconKey: 'electricite',
    colorHex: '#A9640A',
  ),
  _sampleCategory(
    slug: 'peinture',
    nameFr: 'Peinture',
    nameAr: 'دهان',
    iconKey: 'peinture',
    colorHex: '#1E7F4C',
  ),
];

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
