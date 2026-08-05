import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:redesign/theme/app_colors.dart';
import 'package:redesign/theme/app_typography.dart';
import 'package:redesign/theme/responsive_helper.dart';
import 'package:redesign/model/User_Models/Home_Models/Friends_Model/friends_model.dart';

/// A reusable Team Builder / Battle Rosters section widget containing:
/// 1. Section Title ("BATTLE ROSTERS")
/// 2. Home Team Card (Red Accent)
/// 3. Away Team Card (Blue Accent)
class TeamBuilderSection extends StatelessWidget {
  final String sectionTitle;
  final TextEditingController homeTeamController;
  final TextEditingController awayTeamController;
  final RxString homeTeamName;
  final RxString awayTeamName;
  final RxList<FriendModel> homeTeamRoster;
  final RxList<FriendModel> awayTeamRoster;
  final VoidCallback onSelectHomePlayers;
  final VoidCallback onSelectAwayPlayers;
  final Function(bool isHome, FriendModel friend) onRemovePlayer;
  final Color homeAccentColor;
  final Color awayAccentColor;

  const TeamBuilderSection({
    super.key,
    this.sectionTitle = 'TEAM FORMATION',
    required this.homeTeamController,
    required this.awayTeamController,
    required this.homeTeamName,
    required this.awayTeamName,
    required this.homeTeamRoster,
    required this.awayTeamRoster,
    required this.onSelectHomePlayers,
    required this.onSelectAwayPlayers,
    required this.onRemovePlayer,
    this.homeAccentColor = const Color(0xFFFF6B6B),
    this.awayAccentColor = const Color(0xFF4D96FF),
  });

  @override
  Widget build(BuildContext context) {
    ResponsiveHelper.init(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Section Header
        Text(
          sectionTitle.toUpperCase(),
          style: AppTypography.labelCaps.copyWith(
            color: AppColors.mutedText,
            fontSize: ResponsiveHelper.sp(12.0),
            fontWeight: FontWeight.bold,
            letterSpacing: 1.5,
          ).responsive(context),
        ),
        SizedBox(height: ResponsiveHelper.h(16.0)),

        // Home Team Card
        _buildTeamCard(
          context,
          isHome: true,
          titleStream: homeTeamName,
          accentColor: homeAccentColor,
          dotColor: homeAccentColor,
          textController: homeTeamController,
          rosterStream: homeTeamRoster,
          onSelectPlayers: onSelectHomePlayers,
        ),
        SizedBox(height: ResponsiveHelper.h(16.0)),

        // Away Team Card
        _buildTeamCard(
          context,
          isHome: false,
          titleStream: awayTeamName,
          accentColor: awayAccentColor,
          dotColor: awayAccentColor,
          textController: awayTeamController,
          rosterStream: awayTeamRoster,
          onSelectPlayers: onSelectAwayPlayers,
        ),
      ],
    );
  }

  Widget _buildTeamCard(
    BuildContext context, {
    required bool isHome,
    required RxString titleStream,
    required Color accentColor,
    required Color dotColor,
    required TextEditingController textController,
    required RxList<FriendModel> rosterStream,
    required VoidCallback onSelectPlayers,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.cardSurface,
        borderRadius: BorderRadius.circular(ResponsiveHelper.w(20.0)),
        border: Border(left: BorderSide(color: accentColor, width: 4.0)),
      ),
      padding: EdgeInsets.all(ResponsiveHelper.w(20.0)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header Row with Title Stream & Dot
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Obx(
                () => Text(
                  titleStream.value.trim().isEmpty
                      ? (isHome ? 'HOME TEAM' : 'AWAY TEAM')
                      : titleStream.value.toUpperCase(),
                  style: AppTypography.labelCaps.copyWith(
                    color: accentColor,
                    fontSize: ResponsiveHelper.sp(11.0),
                    fontWeight: FontWeight.w800,
                    letterSpacing: 1.2,
                  ).responsive(context),
                ),
              ),
              Container(
                width: ResponsiveHelper.w(10.0),
                height: ResponsiveHelper.w(10.0),
                decoration: BoxDecoration(
                  color: dotColor,
                  shape: BoxShape.circle,
                ),
              ),
            ],
          ),
          SizedBox(height: ResponsiveHelper.h(16.0)),

          // Team Name Text Field
          Container(
            decoration: BoxDecoration(
              color: const Color(0xFF131313),
              borderRadius: BorderRadius.circular(ResponsiveHelper.w(14.0)),
            ),
            padding: EdgeInsets.symmetric(
              horizontal: ResponsiveHelper.w(16.0),
              vertical: ResponsiveHelper.h(4.0),
            ),
            child: TextField(
              controller: textController,
              style: AppTypography.headlineSm.copyWith(
                color: AppColors.textPrimary,
                fontSize: ResponsiveHelper.sp(18.0),
                fontWeight: FontWeight.bold,
              ).responsive(context),
              decoration: const InputDecoration(border: InputBorder.none),
            ),
          ),
          SizedBox(height: ResponsiveHelper.h(12.0)),

          // Search & Add Players Button
          GestureDetector(
            onTap: onSelectPlayers,
            child: Container(
              decoration: BoxDecoration(
                color: const Color(0xFF1C1C1C),
                borderRadius: BorderRadius.circular(ResponsiveHelper.w(14.0)),
                border: Border.all(color: Colors.white.withValues(alpha: 0.05)),
              ),
              padding: EdgeInsets.symmetric(
                horizontal: ResponsiveHelper.w(16.0),
                vertical: ResponsiveHelper.h(12.0),
              ),
              child: Row(
                children: [
                  Icon(
                    Icons.person_add_alt_1_rounded,
                    color: AppColors.mutedText,
                    size: ResponsiveHelper.w(20.0),
                  ),
                  SizedBox(width: ResponsiveHelper.w(12.0)),
                  Expanded(
                    child: Text(
                      'Tap to add players from Friendlist',
                      style: AppTypography.bodySm.copyWith(
                        color: AppColors.mutedText,
                        fontSize: ResponsiveHelper.sp(14.0),
                      ).responsive(context),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  Icon(
                    Icons.chevron_right_rounded,
                    color: AppColors.mutedText,
                    size: ResponsiveHelper.w(20.0),
                  ),
                ],
              ),
            ),
          ),

          // Selected Player Chips
          Obx(() {
            final roster = rosterStream;
            if (roster.isEmpty) return const SizedBox.shrink();

            return Padding(
              padding: EdgeInsets.only(top: ResponsiveHelper.h(12.0)),
              child: Wrap(
                spacing: 8.0,
                runSpacing: 8.0,
                children: roster.map((friend) {
                  return Chip(
                    backgroundColor: const Color(0xFF131313),
                    labelStyle: AppTypography.bodySm.copyWith(
                      color: AppColors.textPrimary,
                      fontSize: ResponsiveHelper.sp(12.0),
                      fontWeight: FontWeight.w600,
                    ).responsive(context),
                    label: Text(
                      friend.fullName.isNotEmpty ? friend.fullName : friend.email,
                    ),
                    deleteIcon: const Icon(
                      Icons.close,
                      color: AppColors.mutedText,
                      size: 16,
                    ),
                    onDeleted: () => onRemovePlayer(isHome, friend),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(ResponsiveHelper.w(20.0)),
                      side: BorderSide(color: accentColor.withValues(alpha: 0.3)),
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
