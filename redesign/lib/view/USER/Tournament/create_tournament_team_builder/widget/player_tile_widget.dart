import 'package:flutter/material.dart';
import 'package:redesign/theme/app_colors.dart';
import 'package:redesign/theme/app_typography.dart';
import 'package:redesign/theme/responsive_helper.dart';

import '../../../../../model/User_Models/Tournament_Model/player_model.dart';

class PlayerTileWidget extends StatelessWidget {
  final PlayerModel player;
  final VoidCallback onTap;

  const PlayerTileWidget({
    super.key,
    required this.player,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(ResponsiveHelper.w(8)),
      child: Container(
        padding: EdgeInsets.all(ResponsiveHelper.w(8)),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(ResponsiveHelper.w(8)),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                SizedBox(
                  width: ResponsiveHelper.w(24),
                  child: Text(
                    player.jerseyNumber,
                    textAlign: TextAlign.center,
                    style: AppTypography.labelCaps.copyWith(color: AppColors.accent),
                  ),
                ),
                SizedBox(width: ResponsiveHelper.w(12)),
                Container(
                  width: ResponsiveHelper.w(32),
                  height: ResponsiveHelper.w(32),
                  decoration: BoxDecoration(
                    color: AppColors.surface,
                    shape: BoxShape.circle,
                    image: DecorationImage(
                      image: NetworkImage(player.imageUrl),
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                SizedBox(width: ResponsiveHelper.w(12)),
                Text(
                  player.name,
                  style: AppTypography.bodySm.copyWith(color: AppColors.onPrimary),
                ),
              ],
            ),
            Container(
              padding: EdgeInsets.symmetric(
                horizontal: ResponsiveHelper.w(8),
                vertical: ResponsiveHelper.h(4),
              ),
              decoration: BoxDecoration(
                color: AppColors.surface,
                borderRadius: BorderRadius.circular(ResponsiveHelper.w(4)),
              ),
              child: Text(
                player.position.toUpperCase(),
                style: AppTypography.labelCaps.copyWith(
                  color: AppColors.muted,
                  fontSize: 10,
                  letterSpacing: 1.0,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
