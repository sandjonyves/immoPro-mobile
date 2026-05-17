import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import 'package:immopro/core/theme/app_text_styles.dart';
import 'package:immopro/core/widgets/price_text.dart';
import 'package:immopro/core/widgets/status_badge.dart';
import 'package:immopro/domain/terrain/entities/terrain.dart';

class TerrainCard extends StatelessWidget {
  final Terrain terrain;
  final VoidCallback? onFavoriteToggle;
  final bool favori;

  const TerrainCard({
    super.key,
    required this.terrain,
    this.onFavoriteToggle,
    this.favori = false,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: () => context.push('/terrains/${terrain.id}'),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            AspectRatio(
              aspectRatio: 16 / 9,
              child: Stack(
                fit: StackFit.expand,
                children: [
                  Container(
                    color: Colors.grey.shade300,
                    child: terrain.photos.isEmpty
                        ? const Icon(Icons.terrain, size: 48)
                        : Image.network(
                            terrain.photos.first,
                            fit: BoxFit.cover,
                            errorBuilder: (_, __, ___) =>
                                const Icon(Icons.terrain, size: 48),
                          ),
                  ),
                  Positioned(
                    top: 8,
                    left: 8,
                    child: StatusBadge.terrain(context, terrain.statut),
                  ),
                  if (onFavoriteToggle != null)
                    Positioned(
                      top: 4,
                      right: 4,
                      child: IconButton(
                        onPressed: onFavoriteToggle,
                        icon: Icon(
                          favori ? Icons.favorite : Icons.favorite_border,
                          color: Colors.white,
                        ),
                      ),
                    ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(terrain.titre, style: AppTextStyles.syneTitle(context)),
                  const SizedBox(height: 4),
                  Text(
                    terrain.surfaceM2.formate,
                    style: AppTextStyles.interBody(context, size: 13),
                  ),
                  PriceText(montant: terrain.prix),
                  Text(
                    '${terrain.quartier}, ${terrain.ville}',
                    style: AppTextStyles.interBody(context, size: 13),
                  ),
                  Text(
                    'Délimité par ${terrain.bornes.length} bornes GPS',
                    style: AppTextStyles.interLabel(context),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
