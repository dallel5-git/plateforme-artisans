import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:sanaya/core/api/generated/api.dart';
import 'package:sanaya/core/theme/app_colors.dart';
import 'package:sanaya/core/theme/app_spacing.dart';
import 'package:sanaya/core/widgets/app_skeleton.dart';
import 'package:sanaya/features/provider_profile/presentation/widgets/provider_gallery.dart';

const double _kAvatarSize = 72;
const double _kCoverHeight = 220;

/// Repéré par les tests widget (alignement RTL) — pas de `String` affiché,
/// donc pas de contrainte i18n sur cette clé.
const Key providerAvatarKey = Key('providerAvatarKey');

/// Couverture plein-écran de la fiche artisan (FM-29) : galerie photos
/// jusqu'en haut d'écran, bouton retour flottant sur voile `scrim` (remplace
/// l'`AppBar` Material), avatar rond superposé chevauchant le bas de la
/// couverture, aligné au bord `start` (donc à droite en arabe/RTL).
class ProviderCoverHeader extends StatelessWidget {
  const ProviderCoverHeader({required this.gallery, super.key});

  final List<V1ProvidersSlugGet200ResponseGalleryInner> gallery;

  @override
  Widget build(BuildContext context) {
    // Pas de champ avatar dédié côté contrat public (V1ProvidersSlugGet200
    // Response n'expose que `gallery`, cf. issue FM-29) — repli volontaire
    // sur la 1ère photo de la galerie.
    final avatarUrl = gallery.isNotEmpty ? gallery.first.url : null;

    return SizedBox(
      height: _kCoverHeight + _kAvatarSize / 2,
      child: Stack(
        children: [
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            child: ProviderGallery(gallery: gallery),
          ),
          const PositionedDirectional(
            top: AppSpacing.sm,
            start: AppSpacing.sm,
            child: SafeArea(
              bottom: false,
              left: false,
              right: false,
              child: ProviderBackButton(),
            ),
          ),
          PositionedDirectional(
            top: _kCoverHeight - _kAvatarSize / 2,
            start: AppSpacing.lg,
            child: _Avatar(url: avatarUrl),
          ),
        ],
      ),
    );
  }
}

/// Bouton retour circulaire sur voile `scrim` — remplace l'`AppBar`
/// Material retirée par FM-29. Réutilisé tel quel par `_ProfileSkeleton`/
/// `_ProfileError` (`provider_profile_screen.dart`) pour ne jamais perdre la
/// navigation retour hors de l'état chargé.
class ProviderBackButton extends StatelessWidget {
  const ProviderBackButton({super.key});

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;

    return Material(
      color: colors.scrim,
      shape: const CircleBorder(),
      child: InkWell(
        customBorder: const CircleBorder(),
        onTap: () => context.pop(),
        child: Padding(
          padding: const EdgeInsets.all(AppSpacing.sm),
          // Icons.arrow_back porte déjà IconData.matchTextDirection: true —
          // miroité automatiquement en RTL (cf. apps/mobile/CLAUDE.md).
          child: Icon(Icons.arrow_back, color: colors.onScrim, size: 20),
        ),
      ),
    );
  }
}

class _Avatar extends StatelessWidget {
  const _Avatar({required this.url});

  final String? url;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;

    return Container(
      key: providerAvatarKey,
      width: _kAvatarSize,
      height: _kAvatarSize,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        border: Border.all(color: colors.surface, width: 3),
      ),
      child: ClipOval(
        child: url == null
            ? ColoredBox(
                color: colors.surfaceSunken,
                child: Icon(
                  Icons.person,
                  color: colors.textMuted,
                  size: _kAvatarSize / 2,
                ),
              )
            : CachedNetworkImage(
                imageUrl: url!,
                fit: BoxFit.cover,
                width: _kAvatarSize,
                height: _kAvatarSize,
                placeholder: (context, url) =>
                    const AppSkeleton.circle(size: _kAvatarSize),
                errorWidget: (context, url, error) => ColoredBox(
                  color: colors.surfaceSunken,
                  child: Icon(
                    Icons.person,
                    color: colors.textMuted,
                    size: _kAvatarSize / 2,
                  ),
                ),
              ),
      ),
    );
  }
}
