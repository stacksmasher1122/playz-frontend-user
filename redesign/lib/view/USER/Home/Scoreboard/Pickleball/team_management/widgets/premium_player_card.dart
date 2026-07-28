import 'package:flutter/material.dart';
import 'package:redesign/theme/app_colors.dart';
import 'package:redesign/theme/app_typography.dart';
import 'package:redesign/theme/responsive_helper.dart';
import 'package:redesign/model/User_Models/Home_Models/Scoreboard_Model/Pickleball/pickleball_player_model.dart';

class PremiumPlayerCard extends StatelessWidget {
  final PickleballPlayerModel player;
  final VoidCallback onRemove;
  final bool isReady;

  const PremiumPlayerCard({
    super.key,
    required this.player,
    required this.onRemove,
    this.isReady = false,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.05),
        borderRadius: BorderRadius.circular(ResponsiveHelper.w(12)),
        border: Border.all(color: Colors.white.withOpacity(0.1)),
      ),
      child: ListTile(
        contentPadding: EdgeInsets.symmetric(horizontal: ResponsiveHelper.w(12), vertical: 4),
        leading: Container(
          width: ResponsiveHelper.w(48),
          height: ResponsiveHelper.w(48),
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: AppColors.outlineVariant,
            image: player.image.isNotEmpty
                ? DecorationImage(
                    image: NetworkImage(player.image),
                    fit: BoxFit.cover,
                  )
                : null,
          ),
          child: player.image.isEmpty ? Icon(Icons.person, color: AppColors.onPrimary) : null,
        ),
        title: Text(player.name, style: AppTypography.headlineSm.copyWith(color: AppColors.onPrimary, fontWeight: FontWeight.bold)),
        subtitle: Row(
          children: [
            Text(player.rating, style: AppTypography.bodySm.copyWith(color: AppColors.accent)),
            SizedBox(width: 8),
            Expanded(child: Text(player.club, style: AppTypography.bodySm.copyWith(color: AppColors.textSecondary), maxLines: 1, overflow: TextOverflow.ellipsis)),
          ],
        ),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (isReady) ...[
              Container(
                padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: AppColors.accent.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text("Ready", style: AppTypography.bodySm.copyWith(color: AppColors.accent)),
              ),
              SizedBox(width: 12),
            ],
            IconButton(
              icon: Icon(Icons.close, color: AppColors.textSecondary, size: 20),
              onPressed: onRemove,
              padding: EdgeInsets.zero,
              constraints: BoxConstraints(),
            ),
          ],
        ),
      ),
    );
  }
}
