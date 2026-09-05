import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:sanaya/core/api/generated/api.dart';
import 'package:sanaya/core/theme/app_colors.dart';
import 'package:sanaya/core/theme/app_spacing.dart';
import 'package:sanaya/core/widgets/app_skeleton.dart';

/// Galerie photos de la fiche artisan (PageView + indicateur).
/// Hauteur fixe 220 px (évite les sauts de layout, critère FM-08).
class ProviderGallery extends StatefulWidget {
  const ProviderGallery({required this.gallery, super.key});

  final List<V1ProvidersSlugGet200ResponseGalleryInner> gallery;

  @override
  State<ProviderGallery> createState() => _ProviderGalleryState();
}

class _ProviderGalleryState extends State<ProviderGallery> {
  int _currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;

    if (widget.gallery.isEmpty) {
      return ColoredBox(
        color: colors.surfaceSunken,
        child: SizedBox(
          height: 220,
          width: double.infinity,
          child: Icon(Icons.photo_outlined, size: 48, color: colors.textMuted),
        ),
      );
    }

    return SizedBox(
      height: 220,
      width: double.infinity,
      child: Stack(
        alignment: Alignment.bottomCenter,
        children: [
          PageView.builder(
            itemCount: widget.gallery.length,
            onPageChanged: (index) {
              setState(() {
                _currentIndex = index;
              });
            },
            itemBuilder: (context, index) {
              final item = widget.gallery[index];
              return CachedNetworkImage(
                imageUrl: item.url,
                fit: BoxFit.cover,
                width: double.infinity,
                height: 220,
                placeholder: (context, url) => const AppSkeleton(
                  width: double.infinity,
                  height: 220,
                  borderRadius: BorderRadius.zero,
                ),
                errorWidget: (context, url, error) => ColoredBox(
                  color: colors.surfaceSunken,
                  child: Icon(
                    Icons.broken_image_outlined,
                    size: 48,
                    color: colors.textMuted,
                  ),
                ),
              );
            },
          ),
          if (widget.gallery.length > 1)
            Positioned(
              bottom: AppSpacing.sm,
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: AppSpacing.sm,
                  vertical: AppSpacing.xxs,
                ),
                decoration: BoxDecoration(
                  color: colors.scrim,
                  borderRadius: const BorderRadius.all(AppRadius.pill),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: List.generate(
                    widget.gallery.length,
                    (index) => Container(
                      margin: const EdgeInsets.symmetric(horizontal: 3),
                      width: _currentIndex == index ? 8 : 6,
                      height: 6,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: _currentIndex == index
                            ? colors.onScrim
                            : colors.onScrim.withValues(alpha: 0.54),
                      ),
                    ),
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}

/// Squelette de chargement pour la galerie (hauteur 220 px fixe, sans coins
/// arrondis — c'est une couverture plein-écran, pas une carte).
class ProviderGallerySkeleton extends StatelessWidget {
  const ProviderGallerySkeleton({super.key});

  @override
  Widget build(BuildContext context) {
    return const AppSkeleton(
      width: double.infinity,
      height: 220,
      borderRadius: BorderRadius.zero,
    );
  }
}
