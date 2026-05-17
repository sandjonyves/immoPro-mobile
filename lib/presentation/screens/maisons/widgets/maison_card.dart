import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import 'package:immopro/core/theme/app_text_styles.dart';
import 'package:immopro/core/widgets/price_text.dart';
import 'package:immopro/core/widgets/status_badge.dart';
import 'package:immopro/domain/maison/entities/maison.dart';

class MaisonCard extends StatelessWidget {
  final Maison maison;
  final VoidCallback? onFavoriteToggle;
  final bool favori;

  const MaisonCard({
    super.key,
    required this.maison,
    this.onFavoriteToggle,
    this.favori = false,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: () => context.push('/maisons/${maison.id}'),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            AspectRatio(
              aspectRatio: 16 / 9,
              child: Stack(
                fit: StackFit.expand,
                children: [
                  Container(
                    color: Colors.blueGrey.shade100,
                    child: maison.photos.isEmpty
                        ? const Icon(Icons.house, size: 48)
                        : Image.network(
                            maison.photos.first,
                            fit: BoxFit.cover,
                            errorBuilder: (_, __, ___) =>
                                const Icon(Icons.house, size: 48),
                          ),
                  ),
                  Positioned(
                    top: 8,
                    left: 8,
                    child: StatusBadge.maison(context, maison.statut),
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
                  Text(maison.titre, style: AppTextStyles.syneTitle(context)),
                  Text(
                    '${maison.type.label} · ${maison.surfaceHabitableM2.toStringAsFixed(0)} m²',
                    style: AppTextStyles.interBody(context, size: 13),
                  ),
                  PriceText(montant: maison.prix),
                  Text(
                    '${maison.quartier}, ${maison.ville}',
                    style: AppTextStyles.interBody(context, size: 13),
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
