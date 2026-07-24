import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:redesign/theme/app_colors.dart';
import 'package:redesign/theme/responsive_helper.dart';
import 'package:redesign/controller/User_Controller/Home_Controller/Scoreboard_Controller/Football/football_create_match_controller.dart';
import 'package:redesign/controller/User_Controller/Home_Controller/Friends_Controller/friends_controller.dart';
import 'package:redesign/model/User_Models/Home_Models/Friends_Model/friends_model.dart';

class FootballFriendsSelectionSheet extends StatelessWidget {
  final FootballCreateMatchController controller;
  final bool isHome;

  FootballFriendsSelectionSheet({
    super.key,
    required this.controller,
    required this.isHome,
  });

  @override
  Widget build(BuildContext context) {
    ResponsiveHelper.init(context);
    final FriendsController friendsCtrl = Get.put(FriendsController());

    return Container(
      padding: EdgeInsets.all(ResponsiveHelper.w(20)),
      height: MediaQuery.of(context).size.height * 0.6,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Select Players',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: ResponsiveHelper.sp(20),
                  fontWeight: FontWeight.bold,
                ),
              ),
              Obx(() {
                final roster = isHome
                    ? controller.homeTeamRoster
                    : controller.awayTeamRoster;
                roster.isEmpty;
                final count = roster.length;
                final maxPlayers = controller.maxAllowedPlayers.value;
                return Text(
                  '( $count / $maxPlayers )',
                  style: TextStyle(color: AppColors.muted, fontSize: 14),
                );
              }),
            ],
          ),
          SizedBox(height: 16),
          Expanded(
            child: Obx(() {
              final currentUser = controller.currentUserFriendModel.value;
              final isFriendsLoading = friendsCtrl.isLoading.value;
              final friendList = friendsCtrl.friends;
              friendList.isEmpty;
              final homePlayers = controller.homeTeamPlayers;
              homePlayers.isEmpty;
              final awayPlayers = controller.awayTeamPlayers;
              awayPlayers.isEmpty;

              if (isFriendsLoading &&
                  friendList.isEmpty &&
                  currentUser == null) {
                return Center(
                  child: CircularProgressIndicator(color: AppColors.accent),
                );
              }

              List<FriendModel> allSelectable = [];
              if (currentUser != null) {
                allSelectable.add(currentUser);
              }
              allSelectable.addAll(friendList);

              if (allSelectable.isEmpty) {
                return Center(
                  child: Text(
                    'No players found.',
                    style: TextStyle(color: AppColors.muted),
                  ),
                );
              }
              return ListView.builder(
                itemCount: allSelectable.length,
                itemBuilder: (context, index) {
                  final friend = allSelectable[index];
                  final bool inHome = homePlayers.contains(
                    friend.email,
                  );
                  final bool inAway = awayPlayers.contains(
                    friend.email,
                  );
                  final bool isSelected = inHome || inAway;
                  final bool isMe =
                      currentUser != null && currentUser.email == friend.email;
                  final String displayName = friend.fullName.isNotEmpty
                      ? friend.fullName
                      : friend.email;
                  final String finalName = isMe
                      ? "$displayName (You)"
                      : displayName;

                  return ListTile(
                    leading: CircleAvatar(
                      backgroundColor: Colors.grey[800],
                      backgroundImage: friend.profileImageUrl.isNotEmpty
                          ? NetworkImage(friend.profileImageUrl)
                          : null,
                      child: friend.profileImageUrl.isEmpty
                          ? Icon(Icons.person, color: Colors.white)
                          : null,
                    ),
                    title: Text(
                      finalName,
                      style: TextStyle(color: Colors.white),
                    ),
                    trailing: isSelected
                        ? Icon(Icons.check_circle, color: AppColors.accent)
                        : IconButton(
                            icon: Icon(Icons.add, color: AppColors.muted),
                            onPressed: () {
                              controller.addTeamPlayer(isHome, friend);
                            },
                          ),
                  );
                },
              );
            }),
          ),
        ],
      ),
    );
  }
}
