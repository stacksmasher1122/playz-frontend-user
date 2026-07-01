import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:redesign/controller/User_Controller/Home_Controller/Scoreboard_Controller/cricket_controller.dart';
import 'package:redesign/controller/User_Controller/Home_Controller/Friends_Controller/friends_controller.dart';
import 'package:redesign/model/User_Models/Home_Models/Friends_Model/friends_model.dart';
import '../cricket_setup_screen.dart';
import 'package:redesign/theme/responsive_helper.dart';

class FriendsSelectionSheet extends StatelessWidget {
  final CricketController controller;
  final bool isHome;

  FriendsSelectionSheet({
    super.key,
    required this.controller,
    required this.isHome,
  });

  @override
  Widget build(BuildContext context) {
    ResponsiveHelper.init(context);
    // Inject the real friends controller
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
              Obx(
                () => Text(
                  '( ${isHome ? controller.homeTeamRoster.length : controller.awayTeamRoster.length} / ${controller.maxAllowedPlayers} )',
                  style: TextStyle(color: kMutedText, fontSize: 14),
                ),
              ),
            ],
          ),
          SizedBox(height: 16),
          Expanded(
            child: Obx(() {
              final currentUser = controller.currentUserFriendModel.value;

              if (friendsCtrl.isLoading.value &&
                  friendsCtrl.friends.isEmpty &&
                  currentUser == null) {
                return Center(
                  child: CircularProgressIndicator(color: kGreen),
                );
              }

              List<FriendModel> allSelectable = [];
              if (currentUser != null) {
                allSelectable.add(currentUser);
              }
              allSelectable.addAll(friendsCtrl.friends);

              if (allSelectable.isEmpty) {
                return Center(
                  child: Text(
                    'No players found.',
                    style: TextStyle(color: kMutedText),
                  ),
                );
              }
              return ListView.builder(
                itemCount: allSelectable.length,
                itemBuilder: (context, index) {
                  final friend = allSelectable[index];
                  // Check to prevent selecting a player who's in any team bounds
                  final bool inHome = controller.homeTeamPlayers.contains(
                    friend.email,
                  );
                  final bool inAway = controller.awayTeamPlayers.contains(
                    friend.email,
                  );
                  final bool isSelected = inHome || inAway;

                  final bool isMe =
                      currentUser != null &&
                      currentUser.email == friend.email;
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
                        ? Icon(Icons.check_circle, color: kGreen)
                        : IconButton(
                            icon: Icon(Icons.add, color: kMutedText),
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
