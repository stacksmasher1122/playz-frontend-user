import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:redesign/theme/app_colors.dart';
import 'package:redesign/theme/app_typography.dart';
import '../../../../../../../model/User_Models/Home_Models/Friends_Model/friends_model.dart';

class BasketballFriendsSelectionSheet extends StatelessWidget {
  final RxList<FriendModel> friends;
  final Function(FriendModel) onPlayerSelected;

  const BasketballFriendsSelectionSheet({
    super.key,
    required this.friends,
    required this.onPlayerSelected,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      color: AppColors.surface,
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: Text('Select Friends', style: AppTypography.headlineLg.copyWith(color: Colors.white)),
          ),
          const Divider(color: AppColors.surface),
          Expanded(
            child: Obx(() {
              if (friends.isEmpty) {
                return Center(
                  child: Text('No friends found.', style: AppTypography.bodyLg.copyWith(color: Colors.grey)),
                );
              }
              return ListView.builder(
                itemCount: friends.length,
                itemBuilder: (context, index) {
                  final friend = friends[index];
                  return ListTile(
                    leading: CircleAvatar(
                      backgroundImage: friend.profileImageUrl.isNotEmpty
                          ? NetworkImage(friend.profileImageUrl)
                          : null,
                      backgroundColor: AppColors.card,
                      child: (friend.profileImageUrl.isEmpty)
                          ? const Icon(Icons.person, color: Colors.white)
                          : null,
                    ),
                    title: Text(friend.fullName, style: AppTypography.bodyLg.copyWith(color: Colors.white)),
                    onTap: () {
                      onPlayerSelected(friend);
                      Navigator.pop(context);
                    },
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
