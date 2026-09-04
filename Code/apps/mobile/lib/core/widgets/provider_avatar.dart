import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

import 'package:sanaya/core/theme/app_colors.dart';
import 'package:sanaya/core/widgets/app_skeleton.dart';

/// Vignette circulaire d'un artisan : image réseau si [url] est fourni,
/// repli sur une icône neutre sinon — extrait de `ProviderCoverHeader`
/// (FM-29, aucun champ avatar dédié côté contrat public) pour être réutilisé
/// tel quel par l'en-tête du formulaire d'avis (FM-30).
class ProviderAvatar extends StatelessWidget {
  const ProviderAvatar({required this.url, super.key, this.size = 72});

  final String? url;
  final double size;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;

    return Container(
      width: size,
      height: size,
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
                  size: size / 2,
                ),
              )
            : CachedNetworkImage(
                imageUrl: url!,
                fit: BoxFit.cover,
                width: size,
                height: size,
                placeholder: (context, url) => AppSkeleton.circle(size: size),
                errorWidget: (context, url, error) => ColoredBox(
                  color: colors.surfaceSunken,
                  child: Icon(
                    Icons.person,
                    color: colors.textMuted,
                    size: size / 2,
                  ),
                ),
              ),
      ),
    );
  }
}
