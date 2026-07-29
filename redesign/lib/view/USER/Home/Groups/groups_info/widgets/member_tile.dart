import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:redesign/theme/app_colors.dart';
import 'package:redesign/theme/app_typography.dart';
import 'package:redesign/controller/User_Controller/Home_Controller/Groups_Controller/group_info_controller.dart';
import 'package:redesign/theme/responsive_helper.dart';

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
    ResponsiveHelper.init(context);
    final name = isMe ? "You" : (data['name'] ?? email);
    final picUrl = data['imageUrl'] ?? '';
    final role = data['role'] ?? 'member';
    final avatarRadius = context.minDimensionPct(5.5).clamp(20.0, 26.0);

    return ListTile(
      contentPadding: EdgeInsets.zero,
      onLongPress: isMe ? null : () => _showMemberOptions(context, email, data),
      leading: Stack(
        children: [
          CircleAvatar(
            radius: avatarRadius,
            backgroundColor: AppColors.surface,
            backgroundImage: picUrl.isNotEmpty ? CachedNetworkImageProvider(picUrl) : null,
            child: picUrl.isEmpty ? const Icon(Icons.person, color: AppColors.muted) : null,
          ),
          if (isMe)
            Positioned(
              bottom: 0,
              right: 0,
              child: Container(
                width: 14,
                height: 14,
                decoration: BoxDecoration(
                  color: AppColors.accent,
                  shape: BoxShape.circle,
                  border: Border.all(color: AppColors.surface, width: 2),
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
              style: AppTypography.headlineSm.copyWith(
                color: AppColors.textPrimary,
                fontSize: context.responsiveFont(14),
                fontWeight: FontWeight.bold,
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ),
          if (role == 'admin')
            Container(
              margin: EdgeInsets.only(left: context.widthPct(2)),
              padding: EdgeInsets.symmetric(
                horizontal: context.widthPct(1.5),
                vertical: context.heightPct(0.3),
              ),
              decoration: BoxDecoration(
                color: AppColors.accent.withValues(alpha: 0.2),
                borderRadius: BorderRadius.circular(context.minDimensionPct(1)),
              ),
              child: Text(
                "GROUP ADMIN",
                style: AppTypography.labelCaps10.copyWith(
                  color: AppColors.accent,
                  fontSize: context.responsiveFont(8),
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
        ],
      ),
      subtitle: Text(
        isMe ? "Ready for the finals! ⚽" : "Midfielder",
        style: AppTypography.bodySm.copyWith(
          color: AppColors.muted,
          fontSize: context.responsiveFont(12),
        ),
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
        margin: EdgeInsets.all(context.widthPct(4)),
        padding: EdgeInsets.symmetric(vertical: context.heightPct(2)),
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(context.minDimensionPct(4)),
          border: Border.all(color: AppColors.borderDark),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // ── Member avatar + name header ──
            Padding(
              padding: EdgeInsets.symmetric(horizontal: context.widthPct(4)),
              child: Row(
                children: [
                  CircleAvatar(
                    radius: 20,
                    backgroundColor: AppColors.card,
                    backgroundImage: (data['imageUrl'] ?? '').isNotEmpty
                        ? CachedNetworkImageProvider(data['imageUrl'] as String)
                        : null,
                    child: (data['imageUrl'] ?? '').isEmpty
                        ? const Icon(Icons.person, color: AppColors.muted)
                        : null,
                  ),
                  SizedBox(width: context.widthPct(3)),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          data['name'] ?? email,
                          style: AppTypography.headlineSm.copyWith(
                            color: AppColors.textPrimary,
                            fontWeight: FontWeight.bold,
                            fontSize: context.responsiveFont(15),
                          ),
                        ),
                        if (isTargetAdmin)
                          Text(
                            "GROUP ADMIN",
                            style: AppTypography.labelCaps10.copyWith(
                              color: AppColors.accent,
                              fontSize: context.responsiveFont(10),
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            Divider(color: AppColors.borderDark, height: context.heightPct(3)),

            // ── Make Admin / Make Member (toggled by current role) ──
            if (!isTargetAdmin)
              ListTile(
                leading: const Icon(Icons.admin_panel_settings, color: AppColors.accent),
                title: Text(
                  "Make Group Admin",
                  style: AppTypography.bodySm.copyWith(
                    color: AppColors.textPrimary,
                    fontSize: context.responsiveFont(14),
                  ),
                ),
                subtitle: Text(
                  "Grant admin privileges",
                  style: AppTypography.bodySm.copyWith(
                    color: AppColors.muted,
                    fontSize: context.responsiveFont(12),
                  ),
                ),
                onTap: () {
                  Navigator.pop(context);
                  ctrl.makeAdmin(email);
                },
              )
            else
              ListTile(
                leading: const Icon(Icons.person_outline, color: Colors.orange),
                title: Text(
                  "Make Member",
                  style: AppTypography.bodySm.copyWith(
                    color: AppColors.textPrimary,
                    fontSize: context.responsiveFont(14),
                  ),
                ),
                subtitle: Text(
                  "Revoke admin privileges",
                  style: AppTypography.bodySm.copyWith(
                    color: AppColors.muted,
                    fontSize: context.responsiveFont(12),
                  ),
                ),
                onTap: () {
                  Navigator.pop(context);
                  ctrl.makeMember(email);
                },
              ),

            // ── Remove ──
            ListTile(
              leading: const Icon(Icons.person_remove, color: AppColors.error),
              title: Text(
                "Remove from Group",
                style: AppTypography.bodySm.copyWith(
                  color: AppColors.error,
                  fontSize: context.responsiveFont(14),
                ),
              ),
              subtitle: Text(
                "Remove this person from the group",
                style: AppTypography.bodySm.copyWith(
                  color: AppColors.muted,
                  fontSize: context.responsiveFont(12),
                ),
              ),
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
