import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:redesign/theme/app_colors.dart';
import 'package:redesign/theme/app_typography.dart';
import 'package:redesign/controller/User_Controller/Home_Controller/Friends_Controller/friends_controller.dart';
import 'package:redesign/view/USER/Home/Friends/friends_chat/friends_chat_screen.dart';
import 'package:redesign/view/USER/Home/Friends/friends_requests/friends_requests_screen.dart';
import 'package:redesign/theme/responsive_helper.dart';

class MessagesListSection extends StatelessWidget {
  const MessagesListSection({super.key});

  @override
  Widget build(BuildContext context) {
    ResponsiveHelper.init(context);
    final ctrl = Get.find<FriendsController>();

    return Obx(() {
      final requestCount = ctrl.pendingRequests.length;

      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: EdgeInsets.fromLTRB(
              context.widthPct(4),
              context.heightPct(2.5),
              context.widthPct(4),
              context.heightPct(1),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'MESSAGES',
                  style: AppTypography.labelCaps10.copyWith(
                    color: AppColors.textPrimary,
                    fontSize: context.responsiveFont(14),
                    fontWeight: FontWeight.w400,
                    letterSpacing: 1.2,
                  ),
                ),
                InkWell(
                  onTap: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (_) => const FriendsRequestsScreen(),
                      ),
                    );
                  },
                  borderRadius: BorderRadius.circular(context.minDimensionPct(1)),
                  child: Padding(
                    padding: EdgeInsets.symmetric(
                      horizontal: context.widthPct(1),
                      vertical: context.heightPct(0.3),
                    ),
                    child: Text(
                      '$requestCount Requests',
                      style: AppTypography.bodySm.copyWith(
                        color: AppColors.accent,
                        fontSize: context.responsiveFont(13),
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          // Show friends as message list
          Obx(() {
            final friendsList = ctrl.friends;
            if (friendsList.isEmpty) {
              return Padding(
                padding: EdgeInsets.symmetric(
                  horizontal: context.widthPct(4),
                  vertical: context.heightPct(3),
                ),
                child: Center(
                  child: Text(
                    'No friends yet. Search and add players!',
                    style: AppTypography.bodySm.copyWith(
                      color: AppColors.muted,
                      fontSize: context.responsiveFont(14),
                    ),
                  ),
                ),
              );
            }
            return ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              padding: EdgeInsets.fromLTRB(
                context.widthPct(4),
                0,
                context.widthPct(4),
                context.heightPct(2),
              ),
              itemCount: friendsList.length,
              itemBuilder: (_, i) {
                final f = friendsList[i];
                return MessageListTile(
                  name: f.fullName,
                  subtitle: 'Tap to chat',
                  isNew: false,
                  hasDot: f.isOnline,
                  imageUrl: f.profileImageUrl,
                  email: f.email,
                  isOnline: f.isOnline,
                );
              },
            );
          }),
        ],
      );
    });
  }
}

class MessageListTile extends StatelessWidget {
  final String name;
  final String subtitle;
  final bool isNew;
  final bool hasDot;
  final String imageUrl;
  final String email;
  final bool isOnline;

  const MessageListTile({
    super.key,
    required this.name,
    required this.subtitle,
    required this.isNew,
    required this.hasDot,
    required this.imageUrl,
    required this.email,
    required this.isOnline,
  });

  @override
  Widget build(BuildContext context) {
    ResponsiveHelper.init(context);
    final avatarSize = context.minDimensionPct(13).clamp(44.0, 56.0);

    return InkWell(
      borderRadius: BorderRadius.circular(context.minDimensionPct(3.5)),
      onTap: () {
        Navigator.of(context).push(MaterialPageRoute(
          builder: (context) => ChatScreen(
            friendEmail: email,
            friendName: name,
            friendPic: imageUrl,
            isOnline: isOnline,
          ),
        ));
      },
      onLongPress: () {
        _showRemoveFriendSheet(context);
      },
      child: Padding(
        padding: EdgeInsets.symmetric(vertical: context.heightPct(1.2)),
        child: Row(
          children: [
            Stack(
              children: [
                ClipOval(
                  child: imageUrl.isNotEmpty
                      ? CachedNetworkImage(
                          imageUrl: imageUrl,
                          width: avatarSize,
                          height: avatarSize,
                          fit: BoxFit.cover,
                          placeholder: (_, __) => CircleAvatar(
                            radius: avatarSize / 2,
                            backgroundColor: AppColors.surface,
                          ),
                          errorWidget: (_, __, ___) => CircleAvatar(
                            radius: avatarSize / 2,
                            backgroundColor: AppColors.surface,
                            child: const Icon(Icons.person, color: AppColors.muted),
                          ),
                        )
                      : CircleAvatar(
                          radius: avatarSize / 2,
                          backgroundColor: AppColors.surface,
                          child: const Icon(Icons.person, color: AppColors.muted),
                        ),
                ),
                if (hasDot)
                  Positioned(
                    bottom: 0,
                    right: 0,
                    child: Container(
                      width: 12,
                      height: 12,
                      decoration: BoxDecoration(
                        color: AppColors.accent,
                        shape: BoxShape.circle,
                        border: Border.all(color: AppColors.background, width: 2),
                      ),
                    ),
                  ),
              ],
            ),
            SizedBox(width: context.widthPct(3.5)),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    name,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: AppTypography.headlineSm.copyWith(
                      color: AppColors.textPrimary,
                      fontSize: context.responsiveFont(16),
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  SizedBox(height: context.heightPct(0.4)),
                  Text(
                    subtitle,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: AppTypography.bodySm.copyWith(
                      color: isNew ? AppColors.accent : AppColors.muted,
                      fontSize: context.responsiveFont(14),
                      fontWeight: isNew ? FontWeight.w500 : FontWeight.w400,
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(width: context.widthPct(2)),
          ],
        ),
      ),
    );
  }

  void _showRemoveFriendSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: AppColors.card,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(context.minDimensionPct(5))),
      ),
      builder: (context) => SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            SizedBox(height: context.heightPct(1)),
            Container(
              width: context.widthPct(10),
              height: 4,
              decoration: BoxDecoration(
                color: AppColors.borderDark,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            SizedBox(height: context.heightPct(2.5)),
            Text(
              'Remove $name?',
              style: AppTypography.headlineSm.copyWith(
                color: AppColors.textPrimary,
                fontSize: context.responsiveFont(18),
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: context.heightPct(1)),
            Text(
              'This will delete all messages permanently.',
              style: AppTypography.bodySm.copyWith(
                color: AppColors.muted,
                fontSize: context.responsiveFont(13),
              ),
            ),
            SizedBox(height: context.heightPct(3)),
            ListTile(
              leading: const Icon(Icons.person_remove, color: AppColors.error),
              title: Text(
                'Remove Friend',
                style: AppTypography.bodySm.copyWith(
                  color: AppColors.error,
                  fontWeight: FontWeight.w600,
                ),
              ),
              onTap: () {
                Navigator.pop(context);
                Get.find<FriendsController>().removeFriend(email);
                Get.snackbar(
                  'Removed',
                  '$name removed from friends',
                  backgroundColor: AppColors.error.withValues(alpha: 0.2),
                  colorText: AppColors.textPrimary,
                );
              },
            ),
            SizedBox(height: context.heightPct(2)),
          ],
        ),
      ),
    );
  }
}
