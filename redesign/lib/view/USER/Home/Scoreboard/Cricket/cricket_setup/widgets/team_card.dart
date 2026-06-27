import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:redesign/controller/User_Controller/Home_Controller/Scoreboard_Controller/cricket_controller.dart';
import '../cricket_setup_screen.dart';
import 'friends_selection_sheet.dart';

class TeamCard extends StatelessWidget {
  final BuildContext context;
  final CricketController controller;
  final RxString titleStream;
  final Color dotColor;
  final Color accentColor;
  final TextEditingController textController;
  final bool isHome;

  const TeamCard({
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
    return Container(
      decoration: BoxDecoration(
        color: kSurface,
        borderRadius: BorderRadius.circular(20),
        border: Border(left: BorderSide(color: accentColor, width: 4)),
      ),
      padding: const EdgeInsets.all(20),
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
                    fontSize: 11,
                    fontWeight: FontWeight.w800,
                    letterSpacing: 1.2,
                  ),
                ),
              ),
              Container(
                width: 10,
                height: 10,
                decoration: BoxDecoration(
                  color: dotColor,
                  shape: BoxShape.circle,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),

          // Team Name Field
          Container(
            decoration: BoxDecoration(
              color: const Color(0xFF131313),
              borderRadius: BorderRadius.circular(16),
            ),
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
            child: TextField(
              controller: textController,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
              decoration: const InputDecoration(border: InputBorder.none),
            ),
          ),
          const SizedBox(height: 12),

          // Search & Add Players Button
          GestureDetector(
            onTap: () => _showFriendsBottomSheet(context, isHome),
            child: Container(
              decoration: BoxDecoration(
                color: const Color(0xFF1C1C1C),
                borderRadius: BorderRadius.circular(16),
              ),
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              child: Row(
                children: [
                  Icon(
                    Icons.person_add,
                    color: kMutedText.withValues(alpha: 0.5),
                  ),
                  const SizedBox(width: 12),
                  Text(
                    'Tap to add players from Friendlist',
                    style: TextStyle(
                      color: kMutedText.withValues(alpha: 0.5),
                      fontSize: 14,
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
            if (roster.isEmpty) return const SizedBox.shrink();
            return Padding(
              padding: const EdgeInsets.only(top: 12.0),
              child: Wrap(
                spacing: 8,
                runSpacing: 8,
                children: roster.map((friend) {
                  return Chip(
                    backgroundColor: const Color(0xFF131313),
                    labelStyle: const TextStyle(
                      color: Colors.white,
                      fontSize: 12,
                    ),
                    label: Text(
                      friend.fullName.isNotEmpty
                          ? friend.fullName
                          : friend.email,
                    ),
                    deleteIcon: const Icon(
                      Icons.close,
                      color: kMutedText,
                      size: 16,
                    ),
                    onDeleted: () =>
                        controller.removeTeamPlayer(isHome, friend),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
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
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      isScrollControlled: true,
      builder: (context) {
        return FriendsSelectionSheet(controller: controller, isHome: isHome);
      },
    );
  }
}
