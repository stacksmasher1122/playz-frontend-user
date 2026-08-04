import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:redesign/theme/app_colors.dart';
import 'package:redesign/theme/app_typography.dart';
import 'package:redesign/theme/responsive_helper.dart';
import 'package:redesign/controller/User_Controller/Home_Controller/Friends_Controller/friends_controller.dart';
import 'package:redesign/controller/User_Controller/Home_Controller/Scoreboard_Controller/Table_Tennis/table_tennis_controller.dart';
import 'package:redesign/model/User_Models/Home_Models/Friends_Model/friends_model.dart';

class TtFriendsSelectionSheet extends StatelessWidget {
  final TableTennisController controller;
  final bool isSideA;

  const TtFriendsSelectionSheet({
    super.key,
    required this.controller,
    required this.isSideA,
  });

  @override
  Widget build(BuildContext context) {
    ResponsiveHelper.init(context);
    final FriendsController friendsCtrl = Get.put(FriendsController());

    return Container(
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(ResponsiveHelper.w(24)),
        ),
      ),
      padding: EdgeInsets.all(ResponsiveHelper.w(20)),
      height: MediaQuery.of(context).size.height * 0.6,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                controller.format.value == 'SINGLES' ? 'Select Player' : 'Select Partners',
                style: AppTypography.headlineMd.copyWith(
                  color: AppColors.textPrimary,
                  fontSize: context.responsiveFont(20),
                  fontWeight: FontWeight.bold,
                ),
              ),
              Obx(
                () => Text(
                  '( ${isSideA ? controller.homeTeamRoster.length : controller.awayTeamRoster.length} / ${controller.maxAllowedPlayers} )',
                  style: AppTypography.bodySm.copyWith(
                    color: AppColors.mutedText,
                    fontSize: context.responsiveFont(14),
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: ResponsiveHelper.h(16)),
          Expanded(
            child: Obx(() {
              final currentUser = controller.currentUserFriendModel.value;

              if (friendsCtrl.isLoading.value &&
                  friendsCtrl.friends.isEmpty &&
                  currentUser == null) {
                return const Center(
                  child: CircularProgressIndicator(color: AppColors.primaryGreen),
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
                    style: AppTypography.bodyMd.copyWith(color: AppColors.mutedText),
                  ),
                );
              }
              return ListView.builder(
                itemCount: allSelectable.length,
                itemBuilder: (context, index) {
                  final friend = allSelectable[index];
                  final bool inA = controller.homeTeamPlayers.contains(friend.email);
                  final bool inB = controller.awayTeamPlayers.contains(friend.email);
                  final bool isSelected = inA || inB;
                  final bool isMe = currentUser != null && currentUser.email == friend.email;
                  final String displayName = friend.fullName.isNotEmpty ? friend.fullName : friend.email;
                  final String finalName = isMe ? "$displayName (You)" : displayName;

                  return ListTile(
                    leading: CircleAvatar(
                      backgroundColor: AppColors.cardSurface,
                      backgroundImage: friend.profileImageUrl.isNotEmpty
                          ? NetworkImage(friend.profileImageUrl)
                          : null,
                      child: friend.profileImageUrl.isEmpty
                          ? const Icon(Icons.person, color: AppColors.primaryGreen)
                          : null,
                    ),
                    title: Text(
                      finalName,
                      style: AppTypography.bodyLg.copyWith(
                        color: isSelected ? AppColors.mutedText : AppColors.textPrimary,
                        fontSize: context.responsiveFont(14),
                      ),
                    ),
                    subtitle: Text(
                      friend.email,
                      style: AppTypography.bodySm.copyWith(
                        color: AppColors.mutedText,
                        fontSize: context.responsiveFont(11),
                      ),
                    ),
                    trailing: isSelected
                        ? const Icon(Icons.check_circle, color: AppColors.primaryGreen)
                        : IconButton(
                            icon: const Icon(Icons.add_circle_outline, color: AppColors.primaryGreen),
                            onPressed: () {
                              controller.addTeamPlayer(isSideA, friend);
                              final currentRoster = isSideA
                                  ? controller.homeTeamRoster
                                  : controller.awayTeamRoster;
                              if (currentRoster.length >= controller.maxAllowedPlayers) {
                                Navigator.pop(context);
                              }
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
