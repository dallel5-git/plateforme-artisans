import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:sanaya/app/providers.dart';
import 'package:sanaya/core/theme/app_colors.dart';
import 'package:sanaya/core/theme/app_spacing.dart';
import 'package:sanaya/core/theme/app_text.dart';
import 'package:sanaya/core/widgets/app_card.dart';
import 'package:sanaya/core/widgets/rating_stars.dart';
import 'package:sanaya/core/widgets/verified_badge.dart';
import 'package:sanaya/features/favorites/application/favorites_providers.dart';

/// Carte artisan (design-system.html §7) — le composant le plus vu du
/// produit. Purement présentation : `categoryLabel`/`locationLabel`/
/// `priceLabel` arrivent déjà formatés par l'appelant (API `displayPrice`,
/// `distanceLabel` — CLAUDE.md §3.3, aucune règle métier dupliquée en Dart).
/// `isVerified` pilote l'affichage de [VerifiedBadge] ; ce widget ne lit
/// jamais `Subscription`/`Plan` lui-même (ADR-002).
class ProviderCard extends StatelessWidget {
  const ProviderCard({
    required this.providerId,
    required this.name,
    required this.categoryLabel,
    required this.locationLabel,
    required this.rating,
    super.key,
    this.photoUrl,
    this.reviewCount,
    this.priceLabel,
    this.isVerified = false,
    this.onTap,
  });

  final String providerId;
  final String name;
  final String categoryLabel;
  final String locationLabel;
  final double rating;
  final String? photoUrl;
  final int? reviewCount;
  final String? priceLabel;
  final bool isVerified;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final locale = Localizations.localeOf(context);

    // Material(transparency), pas de Material ambiant : même raison que
    // AppButton (design-system.html §4) — un MaterialApp ne fournit pas de
    // Material sur son `home` (seul Scaffold en insère un), et InkWell en
    // exige un ancêtre pour dessiner ses ripples.
    return Material(
      type: MaterialType.transparency,
      child: InkWell(
        onTap: onTap,
        borderRadius: const BorderRadius.all(AppRadius.lg),
        child: AppCard(
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _Thumbnail(
                photoUrl: photoUrl,
                initials: _initialsOf(name),
                colors: colors,
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
                            name,
                            style: AppText.bodyStrong(
                              locale,
                            ).copyWith(color: colors.textPrimary),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        if (isVerified) ...[
                          const SizedBox(width: AppSpacing.xs),
                          const VerifiedBadge(),
                        ],
                      ],
                    ),
                    const SizedBox(height: AppSpacing.xxs),
                    Text(
                      '$categoryLabel · $locationLabel',
                      style: AppText.small(
                        locale,
                      ).copyWith(color: colors.textSecondary),
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: AppSpacing.sm),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Flexible(
                          child: RatingStars(
                            rating: rating,
                            reviewCount: reviewCount,
                          ),
                        ),
                        if (priceLabel != null)
                          Flexible(
                            child: Text(
                              priceLabel!,
                              style: AppText.small(
                                locale,
                              ).copyWith(color: colors.accent, height: 1),
                              overflow: TextOverflow.ellipsis,
                              textAlign: TextAlign.end,
                            ),
                          ),
                      ],
                    ),
                  ],
                ),
              ),
              _FavoriteButton(providerId: providerId),
            ],
          ),
        ),
      ),
    );
  }

  static String _initialsOf(String name) {
    final words = name.trim().split(RegExp(r'\s+')).where((w) => w.isNotEmpty);
    final letters = words.take(2).map((w) => w[0].toUpperCase());
    return letters.join();
  }
}

/// Vignette carrée (maquettes A1/B3, FM-27) — image réseau avec repli sur
/// les initiales si `photoUrl` est nul ou échoue au chargement. Taille en
/// constante locale : FM-15 n'a livré que la couleur `thumbnail`/
/// `thumbnailBorder` (`AppColors`), pas de token de taille dédié — même
/// écart déjà documenté pour `_Avatar` avant cette refonte.
class _Thumbnail extends StatelessWidget {
  const _Thumbnail({
    required this.initials,
    required this.colors,
    this.photoUrl,
  });

  final String? photoUrl;
  final String initials;
  final AppColors colors;

  static const double _size = 56;

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: const BorderRadius.all(AppRadius.sm),
      child: SizedBox(
        width: _size,
        height: _size,
        child: photoUrl == null
            ? _InitialsFallback(initials: initials, colors: colors)
            : CachedNetworkImage(
                imageUrl: photoUrl!,
                fit: BoxFit.cover,
                width: _size,
                height: _size,
                placeholder: (context, url) =>
                    ColoredBox(color: colors.surfaceSunken),
                errorWidget: (context, url, error) =>
                    _InitialsFallback(initials: initials, colors: colors),
              ),
      ),
    );
  }
}

class _InitialsFallback extends StatelessWidget {
  const _InitialsFallback({required this.initials, required this.colors});

  final String initials;
  final AppColors colors;

  @override
  Widget build(BuildContext context) {
    return ColoredBox(
      color: colors.accentSubtle,
      child: Center(
        child: Text(
          initials,
          style: AppText.bodyStrong(
            Localizations.localeOf(context),
          ).copyWith(color: colors.accent),
        ),
      ),
    );
  }
}

/// Bouton favori (FM-27, même patron que `_FavoriteButton` de
/// `ProviderProfileScreen`/FM-26b) — dupliqué en privé plutôt qu'extrait en
/// widget partagé : deux points d'usage seulement à ce stade, pas de
/// sur-abstraction prématurée.
class _FavoriteButton extends ConsumerWidget {
  const _FavoriteButton({required this.providerId});

  final String providerId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final colors = context.colors;
    final t = ref.watch(translationsProvider);
    final isFavorite = ref.watch(isFavoriteProvider(providerId));

    return IconButton(
      visualDensity: VisualDensity.compact,
      icon: Icon(
        isFavorite ? Icons.favorite : Icons.favorite_border,
        color: colors.accent,
      ),
      tooltip: isFavorite ? t.favorites.removeTooltip : t.favorites.addTooltip,
      onPressed: () async {
        final notifier = ref.read(favoritesListProvider.notifier);
        try {
          if (isFavorite) {
            await notifier.removeFavorite(providerId);
            if (context.mounted) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(t.favorites.removeSuccess),
                  duration: const Duration(seconds: 2),
                ),
              );
            }
          } else {
            await notifier.addFavorite(providerId);
            if (context.mounted) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(t.favorites.addSuccess),
                  duration: const Duration(seconds: 2),
                ),
              );
            }
          }
        } on Object {
          if (context.mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(
                  isFavorite ? t.favorites.removeError : t.favorites.addError,
                ),
                backgroundColor: colors.destructive,
              ),
            );
          }
        }
      },
    );
  }
}
