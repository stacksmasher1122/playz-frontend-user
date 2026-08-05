import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:redesign/theme/app_colors.dart';
import 'package:redesign/theme/app_typography.dart';
import 'package:redesign/theme/responsive_helper.dart';
import 'package:redesign/model/User_Models/Home_Models/Friends_Model/friends_model.dart';

class HockeyTeamCard extends StatelessWidget {
  final String teamTitle;
  final TextEditingController nameController;
  final Color accentColor;
  final Color dotColor;
  final RxList<FriendModel> roster;
  final int maxPlayers;
  final VoidCallback onAddPlayer;
  final Function(FriendModel) onRemovePlayer;

  const HockeyTeamCard({
    super.key,
    required this.teamTitle,
    required this.nameController,
    required this.accentColor,
    required this.dotColor,
    required this.roster,
    required this.maxPlayers,
    required this.onAddPlayer,
    required this.onRemovePlayer,
  });

  @override
  Widget build(BuildContext context) {
    ResponsiveHelper.init(context);

    return Container(
      decoration: BoxDecoration(
        color: AppColors.cardSurface,
        borderRadius: BorderRadius.circular(ResponsiveHelper.w(20)),
        border: Border(
          left: BorderSide(color: accentColor, width: ResponsiveHelper.w(4)),
        ),
      ),
      padding: EdgeInsets.all(ResponsiveHelper.w(20)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Container(
                    width: ResponsiveHelper.w(8),
                    height: ResponsiveHelper.w(8),
                    decoration: BoxDecoration(
                      color: dotColor,
                      shape: BoxShape.circle,
                    ),
                  ),
                  SizedBox(width: ResponsiveHelper.w(8)),
                  Text(
                    teamTitle.toUpperCase(),
                    style: AppTypography.labelCaps.copyWith(
                      color: AppColors.mutedText,
                      fontSize: ResponsiveHelper.sp(11),
                      fontWeight: FontWeight.w800,
                      letterSpacing: 1.2,
                    ).responsive(context),
                  ),
                ],
              ),
              Obx(
                () => Container(
                  padding: EdgeInsets.symmetric(
                    horizontal: ResponsiveHelper.w(8),
                    vertical: ResponsiveHelper.h(2),
                  ),
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: 0.05),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Text(
                    '${roster.length}/$maxPlayers',
                    style: AppTypography.bodySm.copyWith(
                      color: AppColors.mutedText,
                      fontSize: ResponsiveHelper.sp(11),
                      fontWeight: FontWeight.bold,
                    ).responsive(context),
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: ResponsiveHelper.h(12)),
          Container(
            decoration: BoxDecoration(
              color: const Color(0xFF131313),
              borderRadius: BorderRadius.circular(ResponsiveHelper.w(12)),
            ),
            padding: EdgeInsets.symmetric(horizontal: ResponsiveHelper.w(14)),
            child: TextField(
              controller: nameController,
              style: AppTypography.bodyMd.copyWith(
                color: AppColors.textPrimary,
                fontWeight: FontWeight.bold,
              ).responsive(context),
              decoration: const InputDecoration(
                border: InputBorder.none,
                hintText: 'Enter Team Name',
                hintStyle: TextStyle(color: AppColors.mutedText),
              ),
            ),
          ),
          SizedBox(height: ResponsiveHelper.h(16)),
          Text(
            'PLAYERS',
            style: AppTypography.labelCaps.copyWith(
              color: AppColors.mutedText,
              fontSize: ResponsiveHelper.sp(10),
              fontWeight: FontWeight.w800,
              letterSpacing: 1.0,
            ).responsive(context),
          ),
          SizedBox(height: ResponsiveHelper.h(8)),
          Obx(
            () => Wrap(
              spacing: ResponsiveHelper.w(8),
              runSpacing: ResponsiveHelper.h(8),
              children: [
                ...roster.map(
                  (player) => Chip(
                    backgroundColor: const Color(0xFF262626),
                    deleteIcon: const Icon(Icons.close, size: 14, color: Colors.white54),
                    onDeleted: () => onRemovePlayer(player),
                    label: Text(
                      player.fullName.isNotEmpty ? player.fullName : player.email,
                      style: AppTypography.bodySm.copyWith(
                        color: AppColors.textPrimary,
                        fontSize: ResponsiveHelper.sp(11),
                      ).responsive(context),
                    ),
                  ),
                ),
                if (roster.length < maxPlayers)
                  ActionChip(
                    backgroundColor: accentColor.withValues(alpha: 0.15),
                    side: BorderSide(color: accentColor.withValues(alpha: 0.3)),
                    avatar: Icon(Icons.add, size: 16, color: accentColor),
                    label: Text(
                      'Add Player',
                      style: AppTypography.bodySm.copyWith(
                        color: accentColor,
                        fontSize: ResponsiveHelper.sp(11),
                        fontWeight: FontWeight.bold,
                      ).responsive(context),
                    ),
                    onPressed: onAddPlayer,
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
