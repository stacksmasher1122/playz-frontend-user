import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:shimmer/shimmer.dart';
import 'package:intl/intl.dart';
import 'package:redesign/theme/app_colors.dart';
import 'package:redesign/model/User_Models/Home_Models/Groups_Model/groups_model.dart';
import 'package:redesign/controller/User_Controller/Home_Controller/Groups_Controller/groups_controller.dart';
import 'package:redesign/view/USER/Home/Groups/groups_chat/groups_chat_screen.dart';
import 'package:redesign/theme/responsive_helper.dart';

const kSurface = Color(0xFF0E0E0E);
const kGreen = AppColors.accent;
const kMuted = Colors.white70;

class SquadListTile extends StatelessWidget {
  final GroupModel group;

  SquadListTile({super.key, required this.group});

  String _sportEmoji(String sport) {
    switch (sport.toLowerCase()) {
      case 'cricket':
        return '🏏';
      case 'football':
        return '⚽';
      case 'basketball':
        return '🏀';
      case 'tennis':
        return '🎾';
      case 'badminton':
        return '🏸';
      case 'hockey':
        return '🏑';
      case 'volleyball':
        return '🏐';
      default:
        return '🎯';
    }
  }

  @override
  Widget build(BuildContext context) {
    ResponsiveHelper.init(context);
    final memberCount = group.members.length;
    final ctrl = Get.find<GroupsController>();
    final myEmail = ctrl.myEmail;

    return StreamBuilder<DocumentSnapshot>(
      stream: FirebaseFirestore.instance
          .collection('Groups')
          .doc(group.groupId)
          .snapshots(),
      builder: (context, groupSnapshot) {
        final groupData = groupSnapshot.hasData && groupSnapshot.data!.exists
            ? groupSnapshot.data!.data() as Map<String, dynamic>
            : group.toMap();

        final streamedMembers =
            groupData['members'] as Map<String, dynamic>? ?? {};

        return StreamBuilder<QuerySnapshot>(
          stream: FirebaseFirestore.instance
              .collection('Groups')
              .doc(group.groupId)
              .collection('chats')
              .orderBy('timestamp', descending: true)
              .limit(30)
              .snapshots(),
          builder: (context, snapshot) {
            String latestText = group.description.isNotEmpty
                ? group.description
                : '$memberCount member${memberCount == 1 ? '' : 's'} • ${group.sport}';
            String displayTime = _formatTime(group.createdAt);
            int unreadCount = 0;

            if (snapshot.hasData && snapshot.data!.docs.isNotEmpty) {
              final docs = snapshot.data!.docs;

              final latestDoc = docs.firstWhereOrNull((d) =>
                      (d.data() as Map<String, dynamic>)['type'] != 'system') ??
                  docs.first;
              final latestData = latestDoc.data() as Map<String, dynamic>;

              final type = latestData['type'] ?? 'text';
              final content = latestData['content'] ?? '';
              final senderName = latestData['senderName'] ?? '';
              final isMe = latestData['senderEmail'] == myEmail;

              if (type == 'text' || type == 'system') {
                latestText = type == 'system'
                    ? content
                    : (isMe ? 'You: $content' : '$senderName: $content');
              } else {
                latestText =
                    isMe ? 'You sent a $type' : '$senderName sent a $type';
              }

              final ts = latestData['timestamp'];
              if (ts is Timestamp) {
                displayTime = _formatTime(ts.toDate());
              }

              final myMemberData = streamedMembers[myEmail] as Map<String, dynamic>?;
              final lastSeenField = myMemberData?['lastSeenAt'];

              DateTime lastSeenAt = group.createdAt;
              if (lastSeenField is Timestamp) {
                lastSeenAt = lastSeenField.toDate();
              } else if (lastSeenField is String) {
                lastSeenAt = DateTime.tryParse(lastSeenField) ?? group.createdAt;
              } else if (lastSeenField is int) {
                lastSeenAt = DateTime.fromMillisecondsSinceEpoch(lastSeenField);
              }

              for (var doc in docs) {
                final data = doc.data() as Map<String, dynamic>;
                if (data['type'] != 'system' && data['senderEmail'] != myEmail) {
                  final tsField = data['timestamp'];
                  DateTime? msgTime;
                  if (tsField is Timestamp) {
                    msgTime = tsField.toDate();
                  } else if (tsField is String) {
                    msgTime = DateTime.tryParse(tsField);
                  }

                  if (msgTime != null && msgTime.isAfter(lastSeenAt)) {
                    unreadCount++;
                  }
                }
              }
            }

            return InkWell(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => GroupChatScreen(
                      groupId: group.groupId,
                      groupName: group.name,
                      groupPic: group.imageUrl,
                      memberCount: group.members.length,
                    ),
                  ),
                );
              },
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: ResponsiveHelper.w(16), vertical: ResponsiveHelper.h(12)),
                child: Row(
                  children: [
                    // Group Avatar
                    group.imageUrl.isNotEmpty
                        ? CircleAvatar(
                            radius: 28,
                            backgroundColor: kSurface,
                            child: ClipOval(
                              child: CachedNetworkImage(
                                imageUrl: group.imageUrl,
                                width: ResponsiveHelper.w(56),
                                height: ResponsiveHelper.h(56),
                                fit: BoxFit.cover,
                                placeholder: (_, __) => _buildShimmerCircle(),
                                errorWidget: (_, __, ___) => _buildDefaultAvatar(),
                              ),
                            ),
                          )
                        : CircleAvatar(
                            radius: 28,
                            backgroundColor: kSurface,
                            child: Text(
                              group.name.isNotEmpty
                                  ? group.name[0].toUpperCase()
                                  : 'G',
                              style: TextStyle(
                                color: kGreen,
                                fontSize: ResponsiveHelper.sp(22),
                                fontWeight: FontWeight.w800,
                              ),
                            ),
                          ),
                    SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Expanded(
                                child: Row(
                                  children: [
                                    Flexible(
                                      child: Text(
                                        group.name,
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                        style: TextStyle(
                                          color: Colors.white,
                                          fontSize: ResponsiveHelper.sp(16),
                                          fontWeight: FontWeight.w700,
                                        ),
                                      ),
                                    ),
                                    SizedBox(width: 4),
                                    Text(_sportEmoji(group.sport),
                                        style: TextStyle(fontSize: 14)),
                                  ],
                                ),
                              ),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.end,
                                children: [
                                  Text(
                                    displayTime,
                                    style: TextStyle(
                                      color: unreadCount > 0 ? kGreen : kMuted,
                                      fontSize: ResponsiveHelper.sp(11),
                                      fontWeight: unreadCount > 0
                                          ? FontWeight.w800
                                          : FontWeight.w600,
                                      letterSpacing: 0.5,
                                    ),
                                  ),
                                  if (unreadCount > 0) ...[
                                    SizedBox(height: 6),
                                    Container(
                                      padding: EdgeInsets.symmetric(horizontal: ResponsiveHelper.w(6), vertical: ResponsiveHelper.h(2)),
                                      decoration: BoxDecoration(
                                        color: kGreen,
                                        borderRadius: BorderRadius.circular(ResponsiveHelper.w(10)),
                                      ),
                                      child: Text(
                                        unreadCount > 20
                                            ? '20+'
                                            : unreadCount.toString(),
                                        style: TextStyle(
                                          color: Colors.black,
                                          fontSize: ResponsiveHelper.sp(10),
                                          fontWeight: FontWeight.w800,
                                        ),
                                      ),
                                    ),
                                  ],
                                ],
                              ),
                            ],
                          ),
                          SizedBox(height: 4),
                          Row(
                            children: [
                              Expanded(
                                child: Text(
                                  latestText,
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  style: TextStyle(
                                    color: unreadCount > 0
                                        ? Colors.white
                                        : Colors.white.withValues(alpha: 0.5),
                                    fontSize: ResponsiveHelper.sp(13),
                                    fontWeight: unreadCount > 0
                                        ? FontWeight.w700
                                        : FontWeight.w400,
                                  ),
                                ),
                              ),
                              if (!group.isPublic)
                                Padding(
                                  padding: EdgeInsets.only(left: 8),
                                  child: Icon(Icons.lock,
                                      color: Colors.white.withValues(alpha: 0.3),
                                      size: 14),
                                ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }

  String _formatTime(DateTime dt) {
    final now = DateTime.now();
    final diff = now.difference(dt);

    if (diff.inMinutes < 1) return 'NOW';
    if (diff.inHours < 1) return '${diff.inMinutes}m ago';
    if (diff.inHours < 24) return '${diff.inHours}h ago';
    if (diff.inDays < 7) return '${diff.inDays}d ago';
    return DateFormat('dd MMM').format(dt);
  }

  Widget _buildShimmerCircle() {
    return Shimmer.fromColors(
      baseColor: Color(0xFF2A2A2A),
      highlightColor: Color(0xFF3A3A3A),
      child: Container(
        width: ResponsiveHelper.w(56),
        height: ResponsiveHelper.h(56),
        decoration: BoxDecoration(
          color: Color(0xFF2A2A2A),
          shape: BoxShape.circle,
        ),
      ),
    );
  }

  Widget _buildDefaultAvatar() {
    return Container(
      width: ResponsiveHelper.w(56),
      height: ResponsiveHelper.h(56),
      decoration: BoxDecoration(
        color: kSurface,
        shape: BoxShape.circle,
      ),
      child: Icon(Icons.group, color: kMuted, size: 24),
    );
  }
}
