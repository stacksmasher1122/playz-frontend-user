import 'package:flutter/material.dart';
import 'package:redesign/theme/app_colors.dart';
import 'package:redesign/theme/app_typography.dart';
import 'package:redesign/theme/responsive_helper.dart';
import 'package:redesign/model/User_Models/Home_Models/Scoreboard_Model/Pickleball/pickleball_player_model.dart';

class PlayerSlotWidget extends StatelessWidget {
  final PickleballPlayerModel? player;
  final VoidCallback onTap;
  final VoidCallback? onRemove;
  final bool isLeftTeam;

  const PlayerSlotWidget({
    super.key,
    this.player,
    required this.onTap,
    this.onRemove,
    required this.isLeftTeam,
  });

  @override
  Widget build(BuildContext context) {
    bool isEmpty = player == null;

    return GestureDetector(
      onTap: onTap,
      child: Stack(
        clipBehavior: Clip.none,
        alignment: Alignment.topCenter,
        children: [
          Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: ResponsiveHelper.w(70),
                height: ResponsiveHelper.w(70),
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: isEmpty ? Colors.white.withValues(alpha: 0.05) : AppColors.card,
                  border: Border.all(
                    color: isEmpty ? Colors.white.withValues(alpha: 0.2) : AppColors.accent,
                    width: isEmpty ? 1 : 2,
                  ),
                  boxShadow: isEmpty
                      ? []
                      : [
                          BoxShadow(
                            color: AppColors.accent.withValues(alpha: 0.4),
                            blurRadius: 15,
                            spreadRadius: 2,
                          )
                        ],
                  image: !isEmpty && player!.image.isNotEmpty
                      ? DecorationImage(
                          image: NetworkImage(player!.image),
                          fit: BoxFit.cover,
                        )
                      : null,
                ),
                child: isEmpty
                    ? Icon(Icons.add, color: AppColors.accent, size: 30)
                    : (player!.image.isEmpty ? Icon(Icons.person, color: AppColors.onPrimary, size: 35) : null),
              ),
              SizedBox(height: 8),
              if (!isEmpty) ...[
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                  decoration: BoxDecoration(
                    color: AppColors.background.withValues(alpha: 0.8),
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: Text(
                    player!.name.split(' ').first,
                    style: AppTypography.headlineSm.copyWith(color: AppColors.onPrimary),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                SizedBox(height: 2),
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                  decoration: BoxDecoration(
                    color: AppColors.accent.withValues(alpha: 0.2),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    player!.rating,
                    style: AppTypography.bodySm.copyWith(color: AppColors.accent, fontSize: 10),
                  ),
                ),
              ] else ...[
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                  decoration: BoxDecoration(
                    color: AppColors.background.withValues(alpha: 0.6),
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: Text(
                    "Add Player",
                    style: AppTypography.bodySm.copyWith(color: Colors.white.withValues(alpha: 0.5)),
                  ),
                ),
              ],
            ],
          ),
          if (!isEmpty && onRemove != null)
            Positioned(
              top: -5,
              right: -5,
              child: GestureDetector(
                onTap: onRemove,
                child: Container(
                  padding: EdgeInsets.all(4),
                  decoration: BoxDecoration(
                    color: AppColors.error,
                    shape: BoxShape.circle,
                  ),
                  child: Icon(Icons.close, color: Colors.white, size: 14),
                ),
              ),
            ),
        ],
      ),
    );
  }
}
