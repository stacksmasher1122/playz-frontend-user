import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:redesign/theme/app_colors.dart';
import 'package:redesign/theme/responsive_helper.dart';
import 'package:redesign/controller/User_Controller/Home_Controller/Scoreboard_Controller/Football/football_create_match_controller.dart';
import 'package:redesign/view/USER/Home/Scoreboard/Football/kickoff_setup/widgets/friends_selection/football_friends_selection_sheet.dart';

class FootballTeamCard extends StatelessWidget {
  final BuildContext context;
  final FootballCreateMatchController controller;
  final String title;
  final Color dotColor;
  final Color accentColor;
  final bool isHome;

  FootballTeamCard({
    super.key,
    required this.context,
    required this.controller,
    required this.title,
    required this.dotColor,
    required this.accentColor,
    required this.isHome,
  });

  @override
  Widget build(BuildContext context) {
    ResponsiveHelper.init(context);
    return Container(
      decoration: BoxDecoration(
        color: AppColors.surface,
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
              Expanded(
                child: TextField(
                  style: TextStyle(
                    color: accentColor,
                    fontSize: ResponsiveHelper.sp(14),
                    fontWeight: FontWeight.w800,
                    letterSpacing: 1.2,
                  ),
                  decoration: InputDecoration(
                    hintText: isHome ? 'HOME TEAM NAME' : 'AWAY TEAM NAME',
                    hintStyle: TextStyle(
                      color: accentColor.withValues(alpha: 0.5),
                    ),
                    border: InputBorder.none,
                    isDense: true,
                  ),
                  onChanged: (val) {
                    if (isHome) {
                      controller.homeTeamName.value = val;
                    } else {
                      controller.awayTeamName.value = val;
                    }
                  },
                ),
              ),
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
          SizedBox(height: 16),

          // Search & Add Players Button
          GestureDetector(
            onTap: () => _showFriendsBottomSheet(context, isHome),
            child: Container(
              decoration: BoxDecoration(
                color: Colors.white10,
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
                    color: AppColors.muted.withValues(alpha: 0.5),
                  ),
                  SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      'Tap to add players from Friendlist',
                      style: TextStyle(
                        color: AppColors.muted.withValues(alpha: 0.5),
                        fontSize: ResponsiveHelper.sp(14),
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ),
            ),
          ),

          // Render selected player chips
          Obx(() {
            final roster = isHome
                ? controller.homeTeamRoster
                : controller.awayTeamRoster;
            if (roster.isEmpty) return SizedBox.shrink();
            return Padding(
              padding: EdgeInsets.only(top: 12.0),
              child: Wrap(
                spacing: 8,
                runSpacing: 8,
                children: roster.map((friend) {
                  return Chip(
                    backgroundColor: Colors.black26,
                    labelStyle: TextStyle(
                      color: Colors.white,
                      fontSize: ResponsiveHelper.sp(12),
                    ),
                    label: Text(
                      friend.fullName.isNotEmpty
                          ? friend.fullName
                          : friend.email,
                    ),
                    deleteIcon: Icon(
                      Icons.close,
                      color: AppColors.muted,
                      size: 16,
                    ),
                    onDeleted: () =>
                        controller.removeTeamPlayer(isHome, friend),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(
                        ResponsiveHelper.w(20),
                      ),
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

  void _showFriendsBottomSheet(BuildContext context, bool isHome) {
    showModalBottomSheet(
      context: context,
      backgroundColor: AppColors.surface,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(ResponsiveHelper.w(24)),
        ),
      ),
      isScrollControlled: true,
      builder: (context) {
        return FootballFriendsSelectionSheet(
          controller: controller,
          isHome: isHome,
        );
      },
    );
  }
}
