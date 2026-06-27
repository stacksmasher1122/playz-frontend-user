import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:redesign/theme/app_colors.dart';
import 'package:redesign/controller/User_Controller/Home_Controller/Friends_Controller/friends_controller.dart';
import 'package:redesign/view/USER/Home/Friends/friends_chat/friends_chat_screen.dart';
import 'package:redesign/view/USER/Home/Friends/friends_requests/friends_requests_screen.dart';

const kBg = AppColors.background;
const kSurface = Color(0xFF0E0E0E);
const kGreen = AppColors.accent;
const kMuted = Colors.white70;

class MessagesListSection extends StatelessWidget {
  const MessagesListSection({super.key});

  @override
  Widget build(BuildContext context) {
    final ctrl = Get.find<FriendsController>();

    return Obx(() {
      final requestCount = ctrl.pendingRequests.length;

      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 24, 16, 8),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'MESSAGES',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 14,
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
                  borderRadius: BorderRadius.circular(4),
                  child: Padding(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 4, vertical: 2),
                    child: Text(
                      '$requestCount Requests',
                      style: const TextStyle(
                        color: kGreen,
                        fontSize: 13,
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
              return const Padding(
                padding: EdgeInsets.symmetric(horizontal: 16, vertical: 24),
                child: Center(
                  child: Text(
                    'No friends yet. Search and add players!',
                    style: TextStyle(color: kMuted, fontSize: 14),
                  ),
                ),
              );
            }
            return ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
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
    return InkWell(
      borderRadius: BorderRadius.circular(14),
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
        padding: const EdgeInsets.symmetric(vertical: 12),
        child: Row(
          children: [
            Stack(
              children: [
                CircleAvatar(
                  radius: 26,
                  backgroundImage: imageUrl.isNotEmpty
                      ? CachedNetworkImageProvider(imageUrl) as ImageProvider
                      : null,
                  backgroundColor: kSurface,
                ),
                if (hasDot)
                  Positioned(
                    bottom: 0,
                    right: 0,
                    child: Container(
                      width: 14,
                      height: 14,
                      decoration: BoxDecoration(
                        color: kGreen,
                        shape: BoxShape.circle,
                        border: Border.all(color: kBg, width: 2.5),
                      ),
                    ),
                  ),
              ],
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    name,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    subtitle,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      color: isNew ? kGreen : kMuted,
                      fontSize: 14,
                      fontWeight: isNew ? FontWeight.w500 : FontWeight.w400,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 8),
          ],
        ),
      ),
    );
  }

  void _showRemoveFriendSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: const Color(0xFF141414),
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const SizedBox(height: 8),
            Container(width: 40, height: 4, decoration: BoxDecoration(color: Colors.white24, borderRadius: BorderRadius.circular(2))),
            const SizedBox(height: 20),
            Text('Remove $name?', style: const TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            const Text('This will delete all messages permanently.', style: TextStyle(color: kMuted, fontSize: 13)),
            const SizedBox(height: 24),
            ListTile(
              leading: const Icon(Icons.person_remove, color: Colors.redAccent),
              title: const Text('Remove Friend', style: TextStyle(color: Colors.redAccent, fontWeight: FontWeight.w600)),
              onTap: () {
                Navigator.pop(context);
                Get.find<FriendsController>().removeFriend(email);
                Get.snackbar('Removed', '$name removed from friends', backgroundColor: Colors.redAccent.withAlpha(50), colorText: Colors.white);
              },
            ),
            const SizedBox(height: 16),
          ],
        ),
      ),
    );
  }
}
