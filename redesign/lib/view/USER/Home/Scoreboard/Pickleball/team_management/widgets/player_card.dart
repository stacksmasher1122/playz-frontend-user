import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:redesign/theme/app_colors.dart';
import 'package:redesign/theme/app_typography.dart';
import 'package:redesign/model/User_Models/Home_Models/Scoreboard_Model/Pickleball/pickleball_player_model.dart';
import 'package:redesign/theme/responsive_helper.dart';

class PlayerCard extends StatelessWidget {
  final PickleballPlayerModel player;
  final VoidCallback onRemove;

  PlayerCard({
    super.key,
    required this.player,
    required this.onRemove,
  });

  @override
  Widget build(BuildContext context) {
    ResponsiveHelper.init(context);
    return RepaintBoundary(
      child: Container(
        padding: EdgeInsets.all(ResponsiveHelper.w(12)),
        margin: EdgeInsets.only(bottom: 12),
        decoration: BoxDecoration(
          color: AppColors.card,
          borderRadius: BorderRadius.circular(ResponsiveHelper.w(12)),
          border: Border.all(color: AppColors.primaryContainer, width: 1),
        ),
        child: Row(
          children: [
            Container(
              width: ResponsiveHelper.w(60),
              height: ResponsiveHelper.h(60),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(ResponsiveHelper.w(8)),
                border: Border.all(color: AppColors.primaryContainer, width: 1),
                image: DecorationImage(
                  image: CachedNetworkImageProvider(player.image),
                  fit: BoxFit.cover,
                ),
              ),
            ),
            SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    player.name,
                    style: AppTypography.headlineMd.copyWith(color: AppColors.primary, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 6),
                  Row(
                    children: [
                      Container(
                        padding: EdgeInsets.symmetric(horizontal: ResponsiveHelper.w(8), vertical: ResponsiveHelper.h(4)),
                        decoration: BoxDecoration(
                          color: AppColors.primaryContainer.withOpacity(0.15),
                          borderRadius: BorderRadius.circular(ResponsiveHelper.w(4)),
                          border: Border.all(color: AppColors.primaryContainer.withOpacity(0.3)),
                        ),
                        child: Text(
                          player.rating,
                          style: AppTypography.labelCaps10.copyWith(color: AppColors.primaryContainer),
                        ),
                      ),
                      SizedBox(width: 8),
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
              icon: Icon(Icons.close, color: AppColors.muted),
              onPressed: onRemove,
              alignment: Alignment.topRight,
            ),
          ],
        ),
      ),
    );
  }
}
