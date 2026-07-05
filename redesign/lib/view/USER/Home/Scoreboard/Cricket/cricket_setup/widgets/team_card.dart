import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:redesign/controller/User_Controller/Home_Controller/Scoreboard_Controller/cricket_controller.dart';
import '../cricket_setup_screen.dart';
import 'friends_selection_sheet.dart';
import 'package:redesign/theme/responsive_helper.dart';

class TeamCard extends StatelessWidget {
  final BuildContext context;
  final CricketController controller;
  final RxString titleStream;
  final Color dotColor;
  final Color accentColor;
  final TextEditingController textController;
  final bool isHome;

  TeamCard({
    super.key,
    required this.context,
    required this.controller,
    required this.titleStream,
    required this.dotColor,
    required this.accentColor,
    required this.textController,
    required this.isHome,
  });

  @override
  Widget build(BuildContext context) {
    ResponsiveHelper.init(context);
    return Container(
      decoration: BoxDecoration(
        color: kSurface,
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
              Obx(
                () => Text(
                  titleStream.value.trim().isEmpty
                      ? (isHome ? 'HOMETEAM' : 'AWAYTEAM')
                      : titleStream.value.toUpperCase(),
                  style: TextStyle(
                    color: accentColor.withValues(alpha: 1.0),
                    fontSize: ResponsiveHelper.sp(11),
                    fontWeight: FontWeight.w800,
                    letterSpacing: 1.2,
                  ),
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

          // Team Name Field
          Container(
            decoration: BoxDecoration(
              color: Color(0xFF131313),
              borderRadius: BorderRadius.circular(ResponsiveHelper.w(16)),
            ),
            padding: EdgeInsets.symmetric(horizontal: ResponsiveHelper.w(16), vertical: ResponsiveHelper.h(4)),
            child: TextField(
              controller: textController,
              style: TextStyle(
                color: Colors.white,
                fontSize: ResponsiveHelper.sp(18),
                fontWeight: FontWeight.bold,
              ),
              decoration: InputDecoration(border: InputBorder.none),
            ),
          ),
          SizedBox(height: 12),

          // Search & Add Players Button
          GestureDetector(
            onTap: () => _showFriendsBottomSheet(context, isHome),
            child: Container(
              decoration: BoxDecoration(
                color: Color(0xFF1C1C1C),
                borderRadius: BorderRadius.circular(ResponsiveHelper.w(16)),
              ),
              padding: EdgeInsets.symmetric(horizontal: ResponsiveHelper.w(16), vertical: ResponsiveHelper.h(12)),
              child: Row(
                children: [
                  Icon(
                    Icons.person_add,
                    color: kMutedText.withValues(alpha: 0.5),
                  ),
                  SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      'Tap to add players from Friendlist',
                      style: TextStyle(
                        color: kMutedText.withValues(alpha: 0.5),
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
                    backgroundColor: Color(0xFF131313),
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
                      color: kMutedText,
                      size: 16,
                    ),
                    onDeleted: () =>
                        controller.removeTeamPlayer(isHome, friend),
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

  void _showFriendsBottomSheet(BuildContext context, bool isHome) {
    showModalBottomSheet(
      context: context,
      backgroundColor: kSurface,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(ResponsiveHelper.w(24))),
      ),
      isScrollControlled: true,
      builder: (context) {
        return FriendsSelectionSheet(controller: controller, isHome: isHome);
      },
    );
  }
}
