import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:redesign/theme/app_colors.dart';
import 'package:redesign/theme/responsive_helper.dart';
import 'package:redesign/controller/User_Controller/Home_Controller/Scoreboard_Controller/badminton_controller.dart';
import 'package:redesign/view/USER/Home/Scoreboard/Cricket/cricket_setup/widgets/friends_selection_sheet.dart';

class BadmintonTeamCard extends StatelessWidget {
  final BuildContext context;
  final BadmintonController controller;
  final String title;
  final Color dotColor;
  final Color accentColor;
  final bool isSideA;

  BadmintonTeamCard({
    super.key,
    required this.context,
    required this.controller,
    required this.title,
    required this.dotColor,
    required this.accentColor,
    required this.isSideA,
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
              Text(
                title.toUpperCase(),
                style: TextStyle(
                  color: accentColor.withValues(alpha: 1.0),
                  fontSize: ResponsiveHelper.sp(11),
                  fontWeight: FontWeight.w800,
                  letterSpacing: 1.2,
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
            onTap: () => _showFriendsBottomSheet(context, isSideA),
            child: Container(
              decoration: BoxDecoration(
                color: Colors.white10,
                borderRadius: BorderRadius.circular(ResponsiveHelper.w(16)),
              ),
              padding: EdgeInsets.symmetric(horizontal: ResponsiveHelper.w(16), vertical: ResponsiveHelper.h(12)),
              child: Row(
                children: [
                  Icon(
                    Icons.person_add,
                    color: AppColors.muted.withValues(alpha: 0.5),
                  ),
                  SizedBox(width: 12),
                  Expanded(
                    child: Obx(() => Text(
                      controller.format.value == 'Singles' ? 'Tap to add player from Friendlist' : 'Tap to add partners from Friendlist',
                      style: TextStyle(
                        color: AppColors.muted.withValues(alpha: 0.5),
                        fontSize: ResponsiveHelper.sp(14),
                      ),
                      overflow: TextOverflow.ellipsis,
                    )),
                  ),
                ],
              ),
            ),
          ),

          // Render selected player chips
          Obx(() {
            final roster = isSideA
                ? controller.teamARoster
                : controller.teamBRoster;
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
                        controller.removeTeamPlayer(isSideA, friend),
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

  void _showFriendsBottomSheet(BuildContext context, bool isSideA) {
    showModalBottomSheet(
      context: context,
      backgroundColor: AppColors.surface,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(ResponsiveHelper.w(24))),
      ),
      isScrollControlled: true,
      builder: (context) {
        // Reuse Cricket's FriendsSelectionSheet which we will adapt next
        return BadmintonFriendsSelectionSheet(controller: controller, isSideA: isSideA);
      },
    );
  }
}
