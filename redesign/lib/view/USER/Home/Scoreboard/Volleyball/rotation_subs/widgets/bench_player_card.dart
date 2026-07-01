import 'package:flutter/material.dart';
import 'package:redesign/theme/app_colors.dart';
import 'package:redesign/theme/app_typography.dart';
import 'package:redesign/model/User_Models/Home_Models/Scoreboard_Model/Volleyball/volleyball_player_model.dart';
import 'package:redesign/theme/responsive_helper.dart';

class BenchPlayerCard extends StatelessWidget {
  final VolleyballPlayerModel player;
  final VoidCallback onSwap;

  BenchPlayerCard({
    super.key,
    required this.player,
    required this.onSwap,
  });

  @override
  Widget build(BuildContext context) {
    ResponsiveHelper.init(context);
    return Container(
      margin: EdgeInsets.only(bottom: 8),
      padding: EdgeInsets.all(ResponsiveHelper.w(16)),
      decoration: BoxDecoration(
        color: AppColors.surfaceContainerLowest,
        borderRadius: BorderRadius.circular(ResponsiveHelper.w(12)),
        border: Border.all(color: AppColors.surfaceContainerHighest),
      ),
      child: Row(
        children: [
          Container(
            width: ResponsiveHelper.w(40),
            height: ResponsiveHelper.h(40),
            decoration: BoxDecoration(
              color: AppColors.surfaceContainerHighest,
              borderRadius: BorderRadius.circular(ResponsiveHelper.w(8)),
            ),
            child: Center(
              child: Text(player.jerseyNumber, style: AppTypography.headlineSm.copyWith(color: AppColors.primary, fontWeight: FontWeight.bold)),
            ),
          ),
          SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(player.name, style: AppTypography.headlineSm.copyWith(color: AppColors.primary, fontWeight: FontWeight.bold)),
                SizedBox(height: 4),
                Text(player.position, style: AppTypography.labelCaps10.copyWith(color: AppColors.muted)),
              ],
            ),
          ),
          IconButton(
            icon: Icon(Icons.swap_horiz, color: AppColors.primaryContainer),
            onPressed: onSwap,
          ),
        ],
      ),
    );
  }
}
