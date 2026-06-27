import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:redesign/theme/app_colors.dart';
import 'package:redesign/controller/User_Controller/Home_Controller/Groups_Controller/groups_controller.dart';
import 'package:redesign/view/USER/Home/Groups/groups_info/groups_info_screen.dart';
import 'package:redesign/view/USER/Home/Groups/group_request/group_request_screen.dart';

const _kGreen = AppColors.accent;
const _kMuted = Colors.white38;
const _kSurface = Color(0xFF222222);

class GroupsChatAppBar extends StatelessWidget {
  final String groupId;
  final String name;
  final String pic;
  final int memberCount;

  const GroupsChatAppBar({
    super.key,
    required this.groupId,
    required this.name,
    required this.pic,
    required this.memberCount,
  });

  @override
  Widget build(BuildContext context) {
    final groupsCtrl = Get.find<GroupsController>();
    final isAdmin = groupsCtrl.isGroupAdmin(groupId);

    // If admin, start listening to requests for this group
    if (isAdmin) {
      groupsCtrl.listenToGroupRequests(groupId);
    }

    return Container(
      color: Colors.black.withOpacity(0.8),
      padding: const EdgeInsets.fromLTRB(8, 12, 16, 12),
      child: Row(
        children: [
          IconButton(
            onPressed: () => Navigator.of(context).pop(),
            icon: const Icon(
              Icons.arrow_back_ios_new,
              color: Colors.white,
              size: 20,
            ),
          ),
          Expanded(
            child: GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => GroupsInfoScreen(groupId: groupId),
                  ),
                );
              },
              child: Row(
                children: [
                  CircleAvatar(
                    radius: 19,
                    backgroundColor: _kSurface,
                    backgroundImage: pic.isNotEmpty
                        ? CachedNetworkImageProvider(pic) as ImageProvider
                        : null,
                    child: pic.isEmpty
                        ? const Icon(Icons.group, color: _kMuted)
                        : null,
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          name,
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                        Text(
                          '$memberCount member${memberCount == 1 ? '' : 's'}',
                          style: const TextStyle(
                            color: _kMuted,
                            fontSize: 11,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),

          // ── Requests Button (Only for Admins) ──
          if (isAdmin)
            Obx(() {
              final count = groupsCtrl.pendingGroupRequests.length;
              final hasRequests = count > 0;

              return Stack(
                clipBehavior: Clip.none,
                children: [
                  Container(
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: hasRequests ? _kGreen : Colors.transparent,
                        width: 2,
                      ),
                      boxShadow: hasRequests
                          ? [
                              BoxShadow(
                                color: _kGreen.withOpacity(0.3),
                                blurRadius: 8,
                                spreadRadius: 1,
                              ),
                            ]
                          : [],
                    ),
                    child: IconButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) =>
                                GroupRequestScreen(groupId: groupId),
                          ),
                        );
                      },
                      icon: const Icon(
                        Icons.person_add_outlined,
                        color: Colors.white,
                        size: 26,
                      ),
                    ),
                  ),
                  if (hasRequests)
                    Positioned(
                      right: 0,
                      top: 0,
                      child: Container(
                        padding: const EdgeInsets.all(4),
                        decoration: const BoxDecoration(
                          color: _kGreen,
                          shape: BoxShape.circle,
                        ),
                        constraints: const BoxConstraints(
                          minWidth: 18,
                          minHeight: 18,
                        ),
                        child: Text(
                          '$count',
                          style: const TextStyle(
                            color: Colors.black,
                            fontSize: 10,
                            fontWeight: FontWeight.bold,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ),
                ],
              );
            }),
        ],
      ),
    );
  }
}
