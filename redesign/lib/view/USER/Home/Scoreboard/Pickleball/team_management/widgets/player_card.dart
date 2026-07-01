import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:redesign/theme/app_colors.dart';
import 'package:redesign/theme/app_typography.dart';
import 'package:redesign/model/User_Models/Home_Models/Scoreboard_Model/Pickleball/pickleball_player_model.dart';

class PlayerCard extends StatelessWidget {
  final PickleballPlayerModel player;
  final VoidCallback onRemove;

  const PlayerCard({
    super.key,
    required this.player,
    required this.onRemove,
  });

  @override
  Widget build(BuildContext context) {
    return RepaintBoundary(
      child: Container(
        padding: const EdgeInsets.all(12),
        margin: const EdgeInsets.only(bottom: 12),
        decoration: BoxDecoration(
          color: AppColors.card,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: AppColors.primaryContainer, width: 1),
        ),
        child: Row(
          children: [
            Container(
              width: 60,
              height: 60,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: AppColors.primaryContainer, width: 1),
                image: DecorationImage(
                  image: CachedNetworkImageProvider(player.image),
                  fit: BoxFit.cover,
                ),
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    player.name,
                    style: AppTypography.headlineMd.copyWith(color: AppColors.primary, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 6),
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                        decoration: BoxDecoration(
                          color: AppColors.primaryContainer.withOpacity(0.15),
                          borderRadius: BorderRadius.circular(4),
                          border: Border.all(color: AppColors.primaryContainer.withOpacity(0.3)),
                        ),
                        child: Text(
                          player.rating,
                          style: AppTypography.labelCaps10.copyWith(color: AppColors.primaryContainer),
                        ),
                      ),
                      const SizedBox(width: 8),
                      Text(
                        player.club,
                        style: AppTypography.bodySm.copyWith(color: AppColors.muted),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            IconButton(
              icon: const Icon(Icons.close, color: AppColors.muted),
              onPressed: onRemove,
              alignment: Alignment.topRight,
            ),
          ],
        ),
      ),
    );
  }
}
