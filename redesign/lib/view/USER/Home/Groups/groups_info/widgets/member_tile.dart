import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:redesign/theme/app_colors.dart';
import 'package:redesign/controller/User_Controller/Home_Controller/Groups_Controller/group_info_controller.dart';

const _kGreen = AppColors.accent;
const _kBg = AppColors.surface;
const _kSurface = Color(0xFF222222);
const _kMuted = Colors.white54;

class MemberTile extends StatelessWidget {
  final String email;
  final Map<String, dynamic> data;
  final bool isMe;
  final GroupInfoController ctrl;

  const MemberTile({
    super.key,
    required this.email,
    required this.data,
    this.isMe = false,
    required this.ctrl,
  });

  @override
  Widget build(BuildContext context) {
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
            child: picUrl.isEmpty ? const Icon(Icons.person, color: _kMuted) : null,
          ),
          if (isMe)
            Positioned(
              bottom: 0,
              right: 0,
              child: Container(
                width: 14,
                height: 14,
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
              style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ),
          if (role == 'admin')
            Container(
              margin: const EdgeInsets.only(left: 8),
              padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
              decoration: BoxDecoration(
                color: _kGreen.withValues(alpha: 0.2),
                borderRadius: BorderRadius.circular(4),
              ),
              child: const Text(
                "GROUP ADMIN",
                style: TextStyle(color: _kGreen, fontSize: 8, fontWeight: FontWeight.bold),
              ),
            ),
        ],
      ),
      subtitle: Text(
        isMe ? "Ready for the finals! ⚽" : "Midfielder", // Mocked roles or status
        style: const TextStyle(color: _kMuted, fontSize: 12),
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
        margin: const EdgeInsets.all(16),
        padding: const EdgeInsets.symmetric(vertical: 16),
        decoration: BoxDecoration(
          color: _kSurface,
          borderRadius: BorderRadius.circular(16),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // ── Member avatar + name header ──
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Row(
                children: [
                  CircleAvatar(
                    radius: 20,
                    backgroundColor: _kBg,
                    backgroundImage: (data['imageUrl'] ?? '').isNotEmpty
                        ? CachedNetworkImageProvider(data['imageUrl'] as String)
                        : null,
                    child: (data['imageUrl'] ?? '').isEmpty
                        ? const Icon(Icons.person, color: _kMuted)
                        : null,
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          data['name'] ?? email,
                          style: const TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: 15),
                        ),
                        if (isTargetAdmin)
                          const Text(
                            "GROUP ADMIN",
                            style: TextStyle(
                                color: _kGreen,
                                fontSize: 10,
                                fontWeight: FontWeight.bold),
                          ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const Divider(color: Colors.white12, height: 32),

            // ── Make Admin / Make Member (toggled by current role) ──
            if (!isTargetAdmin)
              ListTile(
                leading: const Icon(Icons.admin_panel_settings, color: _kGreen),
                title: const Text("Make Group Admin",
                    style: TextStyle(color: Colors.white)),
                subtitle: const Text("Grant admin privileges",
                    style: TextStyle(color: _kMuted, fontSize: 12)),
                onTap: () {
                  Navigator.pop(context);
                  ctrl.makeAdmin(email);
                },
              )
            else
              ListTile(
                leading: const Icon(Icons.person_outline, color: Colors.orange),
                title: const Text("Make Member",
                    style: TextStyle(color: Colors.white)),
                subtitle: const Text("Revoke admin privileges",
                    style: TextStyle(color: _kMuted, fontSize: 12)),
                onTap: () {
                  Navigator.pop(context);
                  ctrl.makeMember(email);
                },
              ),

            // ── Remove ──
            ListTile(
              leading:
                  const Icon(Icons.person_remove, color: Colors.redAccent),
              title: const Text("Remove from Group",
                  style: TextStyle(color: Colors.redAccent)),
              subtitle: const Text("Remove this person from the group",
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
