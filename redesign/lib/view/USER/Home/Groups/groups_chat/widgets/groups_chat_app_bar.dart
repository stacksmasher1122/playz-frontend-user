import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:redesign/theme/app_colors.dart';
import 'package:redesign/controller/User_Controller/Home_Controller/Groups_Controller/groups_controller.dart';
import 'package:redesign/view/USER/Home/Groups/groups_info/groups_info_screen.dart';
import 'package:redesign/view/USER/Home/Groups/group_request/group_request_screen.dart';
import 'package:redesign/theme/responsive_helper.dart';
import 'package:redesign/model/User_Models/Home_Models/Groups_Model/groups_model.dart';
import 'package:redesign/common/app_back_button.dart';

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
    ResponsiveHelper.init(context);
    final groupsCtrl = Get.find<GroupsController>();
    final isAdmin = groupsCtrl.isGroupAdmin(groupId);
    final groupModel = groupsCtrl.myGroups.firstWhereOrNull((g) => g.groupId == groupId);
    final isGlobal = groupModel?.isPlayZGlobalGroup ??
        GroupModel.isOfficialGlobal(
          creator: groupModel?.creator ?? '',
          groupId: groupId,
          groupName: name,
        );

    // If admin, start listening to requests for this group
    if (isAdmin) {
      groupsCtrl.listenToGroupRequests(groupId);
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
      decoration: const BoxDecoration(
        color: AppColors.background,
        border: Border(bottom: BorderSide(color: Colors.white10)),
      ),
      child: Row(
        children: [
          const AppBackButton(),
          const SizedBox(width: 8),
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
                  Stack(
                    clipBehavior: Clip.none,
                    children: [
                      CircleAvatar(
                        radius: 19,
                        backgroundColor: _kSurface,
                        backgroundImage: pic.isNotEmpty
                            ? CachedNetworkImageProvider(pic) as ImageProvider
                            : null,
                        child: pic.isEmpty
                            ? Icon(Icons.group, color: _kMuted)
                            : null,
                      ),
                      if (isGlobal)
                        Positioned(
                          bottom: -2,
                          right: -2,
                          child: Container(
                            decoration: const BoxDecoration(
                              color: Color(0xFF0F172A),
                              shape: BoxShape.circle,
                            ),
                            padding: const EdgeInsets.all(1),
                            child: const Icon(
                              Icons.verified_rounded,
                              color: Color(0xFF1DB954),
                              size: 14,
                            ),
                          ),
                        ),
                    ],
                  ),
                  SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Flexible(
                              child: Text(
                                name,
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: ResponsiveHelper.sp(16),
                                  fontWeight: FontWeight.bold,
                                ),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                            if (isGlobal) ...[
                              SizedBox(width: 4),
                              const Icon(
                                Icons.verified_rounded,
                                color: Color(0xFF1DB954),
                                size: 16,
                              ),
                            ],
                          ],
                        ),
                        Text(
                          '$memberCount member${memberCount == 1 ? '' : 's'}',
                          style: TextStyle(
                            color: _kMuted,
                            fontSize: ResponsiveHelper.sp(11),
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
                        width: ResponsiveHelper.w(2),
                      ),
                      boxShadow: hasRequests
                          ? [
                              BoxShadow(
                                color: _kGreen.withValues(alpha: 0.3),
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
                      icon: Icon(
                        Icons.person_add_outlined,
                        color: Colors.white,
                        size: 26,
                      ),
                    ),
                  ),
                  if (hasRequests)
                    Positioned(
                      right: ResponsiveHelper.w(0),
                      top: ResponsiveHelper.h(0),
                      child: Container(
                        padding: EdgeInsets.all(ResponsiveHelper.w(4)),
                        decoration: BoxDecoration(
                          color: _kGreen,
                          shape: BoxShape.circle,
                        ),
                        constraints: BoxConstraints(
                          minWidth: 18,
                          minHeight: 18,
                        ),
                        child: Text(
                          '$count',
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: ResponsiveHelper.sp(10),
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
