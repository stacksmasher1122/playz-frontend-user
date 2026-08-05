import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:redesign/theme/app_colors.dart';
import 'package:redesign/theme/app_typography.dart';
import 'package:redesign/theme/responsive_helper.dart';
import 'package:redesign/model/User_Models/Home_Models/Friends_Model/friends_model.dart';
import 'package:redesign/controller/User_Controller/Home_Controller/Friends_Controller/friends_controller.dart';

/// A reusable, universal Select Players bottom sheet complete with a search bar
/// for real-time filtering of friends and the current logged-in user.
class CommonSelectPlayersBottomSheet extends StatefulWidget {
  final String title;
  final int maxCount;
  final RxList<String> selectedPlayerEmails;
  final RxList<String> opponentPlayerEmails;
  final Function(FriendModel friend) onPlayerSelected;
  final FriendModel? currentUserModel;

  const CommonSelectPlayersBottomSheet({
    super.key,
    this.title = 'Select Players',
    required this.maxCount,
    required this.selectedPlayerEmails,
    required this.opponentPlayerEmails,
    required this.onPlayerSelected,
    this.currentUserModel,
  });

  static void show(
    BuildContext context, {
    String title = 'Select Players',
    required int maxCount,
    required RxList<String> selectedPlayerEmails,
    required RxList<String> opponentPlayerEmails,
    required Function(FriendModel friend) onPlayerSelected,
    FriendModel? currentUserModel,
  }) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: AppColors.cardSurface,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(ResponsiveHelper.w(24.0))),
      ),
      builder: (ctx) => CommonSelectPlayersBottomSheet(
        title: title,
        maxCount: maxCount,
        selectedPlayerEmails: selectedPlayerEmails,
        opponentPlayerEmails: opponentPlayerEmails,
        onPlayerSelected: onPlayerSelected,
        currentUserModel: currentUserModel,
      ),
    );
  }

  @override
  State<CommonSelectPlayersBottomSheet> createState() => _CommonSelectPlayersBottomSheetState();
}

class _CommonSelectPlayersBottomSheetState extends State<CommonSelectPlayersBottomSheet> {
  final TextEditingController _searchController = TextEditingController();
  final RxString _searchQuery = ''.obs;

  @override
  void initState() {
    super.initState();
    _searchController.addListener(() {
      _searchQuery.value = _searchController.text.trim().toLowerCase();
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    ResponsiveHelper.init(context);
    final FriendsController friendsCtrl = Get.put(FriendsController());

    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: ResponsiveHelper.w(20.0),
        vertical: ResponsiveHelper.h(12.0),
      ),
      height: MediaQuery.of(context).size.height * 0.75,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Top Drag Handle Pill
          Center(
            child: Container(
              width: ResponsiveHelper.w(44.0),
              height: ResponsiveHelper.h(4.5),
              margin: EdgeInsets.only(bottom: ResponsiveHelper.h(14.0)),
              decoration: BoxDecoration(
                color: Colors.white.withValues(alpha: 0.3),
                borderRadius: BorderRadius.circular(ResponsiveHelper.w(10.0)),
              ),
            ),
          ),

          // Header Row with Title & Count Indicator
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                widget.title,
                style: AppTypography.headlineSm.copyWith(
                  color: AppColors.textPrimary,
                  fontSize: ResponsiveHelper.sp(20.0),
                  fontWeight: FontWeight.bold,
                ).responsive(context),
              ),
              Obx(
                () => Text(
                  '( ${widget.selectedPlayerEmails.length} / ${widget.maxCount} )',
                  style: AppTypography.bodySm.copyWith(
                    color: AppColors.accent,
                    fontSize: ResponsiveHelper.sp(14.0),
                    fontWeight: FontWeight.bold,
                  ).responsive(context),
                ),
              ),
            ],
          ),
          SizedBox(height: ResponsiveHelper.h(16.0)),

          // Search Bar Input
          Container(
            decoration: BoxDecoration(
              color: const Color(0xFF131313),
              borderRadius: BorderRadius.circular(ResponsiveHelper.w(14.0)),
              border: Border.all(color: Colors.white.withValues(alpha: 0.08)),
            ),
            child: TextField(
              controller: _searchController,
              style: AppTypography.bodyMd.copyWith(color: AppColors.textPrimary).responsive(context),
              decoration: InputDecoration(
                hintText: 'Search friends or current user...',
                hintStyle: AppTypography.bodySm.copyWith(color: AppColors.mutedText).responsive(context),
                prefixIcon: const Icon(Icons.search_rounded, color: AppColors.mutedText),
                suffixIcon: ValueListenableBuilder<TextEditingValue>(
                  valueListenable: _searchController,
                  builder: (ctx, value, _) {
                    return value.text.isNotEmpty
                        ? IconButton(
                            icon: const Icon(Icons.close_rounded, color: AppColors.mutedText),
                            onPressed: () => _searchController.clear(),
                          )
                        : const SizedBox.shrink();
                  },
                ),
                border: InputBorder.none,
                contentPadding: EdgeInsets.symmetric(
                  horizontal: ResponsiveHelper.w(16.0),
                  vertical: ResponsiveHelper.h(14.0),
                ),
              ),
            ),
          ),
          SizedBox(height: ResponsiveHelper.h(16.0)),

          // Friends + Current User List View
          Expanded(
            child: Obx(() {
              final user = FirebaseAuth.instance.currentUser;
              final String myEmail = user?.email ?? 'you@local';
              final String myName = user?.displayName ?? 'You';

              final currentUserModel = widget.currentUserModel ??
                  FriendModel(
                    email: myEmail,
                    fullName: '$myName (You)',
                  );

              // Build combined list
              List<FriendModel> allSelectable = [currentUserModel];
              allSelectable.addAll(friendsCtrl.friends.where((f) => f.email != currentUserModel.email));

              // Filter by search query
              final query = _searchQuery.value;
              List<FriendModel> filteredList = allSelectable.where((friend) {
                final name = friend.fullName.toLowerCase();
                final email = friend.email.toLowerCase();
                return name.contains(query) || email.contains(query);
              }).toList();

              if (friendsCtrl.isLoading.value && friendsCtrl.friends.isEmpty) {
                return const Center(child: CircularProgressIndicator(color: AppColors.accent));
              }

              if (filteredList.isEmpty) {
                return Center(
                  child: Text(
                    query.isNotEmpty ? 'No matching players found.' : 'No friends found.',
                    style: AppTypography.bodySm.copyWith(color: AppColors.mutedText).responsive(context),
                  ),
                );
              }

              return ListView.separated(
                itemCount: filteredList.length,
                separatorBuilder: (ctx, idx) => const Divider(color: Colors.white10, height: 1),
                itemBuilder: (context, index) {
                  final friend = filteredList[index];
                  final bool isMe = friend.email == myEmail;

                  final String displayName = friend.fullName.isNotEmpty
                      ? friend.fullName
                      : friend.email;

                  final String finalName = isMe && !displayName.contains('(You)')
                      ? '$displayName (You)'
                      : displayName;

                  return Obx(() {
                    final bool isSelected = widget.selectedPlayerEmails.contains(friend.email);
                    final bool isOpponentSelected = widget.opponentPlayerEmails.contains(friend.email);

                    return ListTile(
                      contentPadding: EdgeInsets.symmetric(
                        horizontal: ResponsiveHelper.w(8.0),
                        vertical: ResponsiveHelper.h(4.0),
                      ),
                      leading: CircleAvatar(
                        backgroundColor: isMe ? AppColors.accent.withValues(alpha: 0.3) : Colors.grey[800],
                        backgroundImage: friend.profileImageUrl.isNotEmpty
                            ? NetworkImage(friend.profileImageUrl)
                            : null,
                        child: friend.profileImageUrl.isEmpty
                            ? Icon(
                                isMe ? Icons.person_pin : Icons.person,
                                color: isMe ? AppColors.accent : Colors.white,
                              )
                            : null,
                      ),
                      title: Text(
                        finalName,
                        style: AppTypography.bodyMd.copyWith(
                          color: AppColors.textPrimary,
                          fontWeight: FontWeight.bold,
                        ).responsive(context),
                      ),
                      trailing: isSelected
                          ? const Icon(Icons.check_circle_rounded, color: AppColors.accent, size: 24)
                          : (isOpponentSelected
                              ? Text(
                                  'In Opponent Team',
                                  style: AppTypography.bodySm.copyWith(
                                    color: Colors.amber,
                                    fontSize: 11,
                                    fontWeight: FontWeight.bold,
                                  ).responsive(context),
                                )
                              : IconButton(
                                  icon: const Icon(Icons.add, color: AppColors.accent, size: 24),
                                  onPressed: () {
                                    widget.onPlayerSelected(friend);
                                    // Auto close bottom sheet if team becomes full after adding this player
                                    if (widget.selectedPlayerEmails.length >= widget.maxCount) {
                                      Navigator.of(context).pop();
                                    }
                                  },
                                )),
                    );
                  });
                },
              );
            }),
          ),
        ],
      ),
    );
  }
}
