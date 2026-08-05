import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:redesign/theme/app_colors.dart';
import 'package:redesign/theme/app_typography.dart';
import 'package:redesign/theme/responsive_helper.dart';
import 'package:redesign/model/User_Models/Home_Models/Friends_Model/friends_model.dart';

class BasketballTeamCard extends StatelessWidget {
  final String teamTitle;
  final TextEditingController nameController;
  final Color accentColor;
  final Color dotColor;
  final RxList<FriendModel> roster;
  final int maxPlayers;
  final VoidCallback onAddPlayer;
  final Function(FriendModel) onRemovePlayer;

  const BasketballTeamCard({
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
        border: Border(left: BorderSide(color: accentColor, width: 4)),
      ),
      padding: EdgeInsets.all(ResponsiveHelper.w(20)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                teamTitle.toUpperCase(),
                style: AppTypography.labelCaps.copyWith(
                  color: accentColor,
                  fontWeight: FontWeight.w800,
                  letterSpacing: 1.2,
                ).responsive(context),
              ),
              Row(
                children: [
                  Obx(() => Text(
                        '( ${roster.length} / $maxPlayers )',
                        style: AppTypography.labelCaps.copyWith(
                          color: AppColors.mutedText,
                        ).responsive(context),
                      )),
                  SizedBox(width: ResponsiveHelper.w(8)),
                  Container(
                    width: ResponsiveHelper.w(10),
                    height: ResponsiveHelper.h(10),
                    decoration: BoxDecoration(
                      color: dotColor,
                      shape: BoxShape.circle,
                    ),
                  ),
                ],
              ),
            ],
          ),
          SizedBox(height: ResponsiveHelper.h(16)),

          // Team Name Input Field (Cricket Style)
          Container(
            decoration: BoxDecoration(
              color: const Color(0xFF131313),
              borderRadius: BorderRadius.circular(ResponsiveHelper.w(16)),
            ),
            padding: EdgeInsets.symmetric(
              horizontal: ResponsiveHelper.w(16),
              vertical: ResponsiveHelper.h(4),
            ),
            child: TextField(
              controller: nameController,
              style: AppTypography.headlineSm.copyWith(
                color: AppColors.textPrimary,
                fontSize: ResponsiveHelper.sp(18),
                fontWeight: FontWeight.bold,
              ),
              decoration: InputDecoration(
                hintText: 'Enter Team Name',
                hintStyle: AppTypography.headlineSm.copyWith(
                  color: AppColors.mutedText,
                  fontSize: ResponsiveHelper.sp(16),
                ),
                border: InputBorder.none,
              ),
            ),
          ),
          SizedBox(height: ResponsiveHelper.h(12)),

          // Search & Add Players Container
          GestureDetector(
            onTap: onAddPlayer,
            child: Container(
              decoration: BoxDecoration(
                color: const Color(0xFF1C1C1C),
                borderRadius: BorderRadius.circular(ResponsiveHelper.w(16)),
              ),
              padding: EdgeInsets.symmetric(
                horizontal: ResponsiveHelper.w(16),
                vertical: ResponsiveHelper.h(12),
              ),
              child: Row(
                children: [
                  Icon(
                    Icons.person_add,
                    color: AppColors.mutedText.withValues(alpha: 0.6),
                    size: 20,
                  ),
                  SizedBox(width: ResponsiveHelper.w(12)),
                  Expanded(
                    child: Text(
                      'Tap to add players from Friendlist',
                      style: AppTypography.bodySm.copyWith(
                        color: AppColors.mutedText.withValues(alpha: 0.7),
                        fontSize: ResponsiveHelper.sp(14),
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ),
            ),
          ),

          // Render Selected Player Chips (Cricket Style)
          Obx(() {
            if (roster.isEmpty) return const SizedBox.shrink();
            return Padding(
              padding: const EdgeInsets.only(top: 12.0),
              child: Wrap(
                spacing: 8,
                runSpacing: 8,
                children: roster.map((friend) {
                  return Chip(
                    backgroundColor: const Color(0xFF131313),
                    labelStyle: AppTypography.bodySm.copyWith(
                      color: AppColors.textPrimary,
                      fontSize: ResponsiveHelper.sp(12),
                    ),
                    label: Text(
                      friend.fullName.isNotEmpty ? friend.fullName : friend.email,
                    ),
                    deleteIcon: const Icon(
                      Icons.close,
                      color: AppColors.mutedText,
                      size: 16,
                    ),
                    onDeleted: () => onRemovePlayer(friend),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(ResponsiveHelper.w(20)),
                      side: BorderSide.none,
                    ),
                  );
                }).toList(),
              ),
            );
          }),
        ],
      ),
    );
  }
}
