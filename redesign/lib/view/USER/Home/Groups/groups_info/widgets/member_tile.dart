import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:redesign/theme/app_colors.dart';
import 'package:redesign/controller/User_Controller/Home_Controller/Groups_Controller/group_info_controller.dart';
import 'package:redesign/theme/responsive_helper.dart';

const _kGreen = AppColors.accent;
const _kBg = AppColors.surface;
const _kSurface = Color(0xFF222222);
const _kMuted = Colors.white54;

class MemberTile extends StatelessWidget {
  final String email;
  final Map<String, dynamic> data;
  final bool isMe;
  final GroupInfoController ctrl;

  MemberTile({
    super.key,
    required this.email,
    required this.data,
    this.isMe = false,
    required this.ctrl,
  });

  @override
  Widget build(BuildContext context) {
    ResponsiveHelper.init(context);
    final name = isMe ? "You" : (data['name'] ?? email);
    final picUrl = data['imageUrl'] ?? '';
    final role = data['role'] ?? 'member';

    return ListTile(
      contentPadding: EdgeInsets.zero,
      onLongPress: isMe ? null : () => _showMemberOptions(context, email, data),
      leading: Stack(
        children: [
          CircleAvatar(
            radius: 23,
            backgroundColor: _kBg,
            backgroundImage: picUrl.isNotEmpty ? CachedNetworkImageProvider(picUrl) : null,
            child: picUrl.isEmpty ? Icon(Icons.person, color: _kMuted) : null,
          ),
          if (isMe)
            Positioned(
              bottom: ResponsiveHelper.h(0),
              right: ResponsiveHelper.w(0),
              child: Container(
                width: ResponsiveHelper.w(14),
                height: ResponsiveHelper.h(14),
                decoration: BoxDecoration(
                  color: _kGreen,
                  shape: BoxShape.circle,
                  border: Border.all(color: _kSurface, width: 2),
                ),
              ),
            ),
        ],
      ),
      title: Row(
        children: [
          Expanded(
            child: Text(
              name,
              style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ),
          if (role == 'admin')
            Container(
              margin: EdgeInsets.only(left: 8),
              padding: EdgeInsets.symmetric(horizontal: ResponsiveHelper.w(6), vertical: ResponsiveHelper.h(2)),
              decoration: BoxDecoration(
                color: _kGreen.withValues(alpha: 0.2),
                borderRadius: BorderRadius.circular(ResponsiveHelper.w(4)),
              ),
              child: Text(
                "GROUP ADMIN",
                style: TextStyle(color: _kGreen, fontSize: ResponsiveHelper.sp(8), fontWeight: FontWeight.bold),
              ),
            ),
        ],
      ),
      subtitle: Text(
        isMe ? "Ready for the finals! ⚽" : "Midfielder", // Mocked roles or status
        style: TextStyle(color: _kMuted, fontSize: 12),
      ),
    );
  }

  void _showMemberOptions(BuildContext context, String email, Map<String, dynamic> data) {
    if (!ctrl.isAdmin.value) return;

    final isTargetAdmin = data['role'] == 'admin';

    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (_) => Container(
        margin: EdgeInsets.all(ResponsiveHelper.w(16)),
        padding: EdgeInsets.symmetric(vertical: ResponsiveHelper.h(16)),
        decoration: BoxDecoration(
          color: _kSurface,
          borderRadius: BorderRadius.circular(ResponsiveHelper.w(16)),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // ── Member avatar + name header ──
            Padding(
              padding: EdgeInsets.symmetric(horizontal: ResponsiveHelper.w(16)),
              child: Row(
                children: [
                  CircleAvatar(
                    radius: 20,
                    backgroundColor: _kBg,
                    backgroundImage: (data['imageUrl'] ?? '').isNotEmpty
                        ? CachedNetworkImageProvider(data['imageUrl'] as String)
                        : null,
                    child: (data['imageUrl'] ?? '').isEmpty
                        ? Icon(Icons.person, color: _kMuted)
                        : null,
                  ),
                  SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          data['name'] ?? email,
                          style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: 15),
                        ),
                        if (isTargetAdmin)
                          Text(
                            "GROUP ADMIN",
                            style: TextStyle(
                                color: _kGreen,
                                fontSize: ResponsiveHelper.sp(10),
                                fontWeight: FontWeight.bold),
                          ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            Divider(color: Colors.white12, height: 32),

            // ── Make Admin / Make Member (toggled by current role) ──
            if (!isTargetAdmin)
              ListTile(
                leading: Icon(Icons.admin_panel_settings, color: _kGreen),
                title: Text("Make Group Admin",
                    style: TextStyle(color: Colors.white)),
                subtitle: Text("Grant admin privileges",
                    style: TextStyle(color: _kMuted, fontSize: 12)),
                onTap: () {
                  Navigator.pop(context);
                  ctrl.makeAdmin(email);
                },
              )
            else
              ListTile(
                leading: Icon(Icons.person_outline, color: Colors.orange),
                title: Text("Make Member",
                    style: TextStyle(color: Colors.white)),
                subtitle: Text("Revoke admin privileges",
                    style: TextStyle(color: _kMuted, fontSize: 12)),
                onTap: () {
                  Navigator.pop(context);
                  ctrl.makeMember(email);
                },
              ),

            // ── Remove ──
            ListTile(
              leading:
                  Icon(Icons.person_remove, color: Colors.redAccent),
              title: Text("Remove from Group",
                  style: TextStyle(color: Colors.redAccent)),
              subtitle: Text("Remove this person from the group",
                  style: TextStyle(color: _kMuted, fontSize: 12)),
              onTap: () {
                Navigator.pop(context);
                ctrl.removeMember(email);
              },
            ),
          ],
        ),
      ),
    );
  }
}
