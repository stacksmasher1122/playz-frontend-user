import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:intl/intl.dart';
import 'package:redesign/theme/app_colors.dart';
import 'package:redesign/theme/app_typography.dart';
import 'package:redesign/model/User_Models/Home_Models/Groups_Model/groups_model.dart';
import 'package:redesign/controller/User_Controller/Home_Controller/Groups_Controller/group_info_controller.dart';
import 'package:redesign/theme/responsive_helper.dart';

class GroupsInfoHeader extends StatelessWidget {
  final GroupModel group;
  final GroupInfoController ctrl;

  const GroupsInfoHeader({
    super.key,
    required this.group,
    required this.ctrl,
  });

  @override
  Widget build(BuildContext context) {
    ResponsiveHelper.init(context);
    final creatorName = group.members[group.creator]?['name'] ?? group.creator;
    final createdDate = DateFormat('MMM yyyy').format(group.createdAt).toUpperCase();
    final avatarSize = context.minDimensionPct(32).clamp(110.0, 140.0);

    return Column(
      children: [
        GestureDetector(
          onTap: () {
            if (ctrl.isAdmin.value) {
              _showEditGroupDetailsDialog(context, group);
            }
          },
          child: Stack(
            clipBehavior: Clip.none,
            children: [
              Container(
                width: avatarSize,
                height: avatarSize,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: AppColors.card,
                  border: Border.all(color: AppColors.accent, width: 2),
                  image: group.imageUrl.isNotEmpty
                      ? DecorationImage(
                          image: CachedNetworkImageProvider(group.imageUrl),
                          fit: BoxFit.cover,
                        )
                      : null,
                  boxShadow: [
                    BoxShadow(
                      color: AppColors.background.withValues(alpha: 0.5),
                      blurRadius: 15,
                      offset: const Offset(0, 5),
                    )
                  ],
                ),
                child: group.imageUrl.isEmpty
                    ? const Icon(Icons.groups, size: 60, color: AppColors.muted)
                    : null,
              ),
              if (group.isPlayZGlobalGroup)
                Positioned(
                  bottom: 4,
                  right: 4,
                  child: Container(
                    decoration: BoxDecoration(
                      color: AppColors.background,
                      shape: BoxShape.circle,
                      border: Border.all(color: AppColors.background, width: 3),
                    ),
                    padding: const EdgeInsets.all(2),
                    child: const Icon(
                      Icons.verified_rounded,
                      color: Color(0xFF1DB954),
                      size: 26,
                    ),
                  ),
                ),
              if (ctrl.isAdmin.value)
                Positioned(
                  bottom: 0,
                  right: 0,
                  child: Container(
                    decoration: BoxDecoration(
                      color: AppColors.accent,
                      shape: BoxShape.circle,
                      border: Border.all(color: AppColors.background, width: 3),
                      boxShadow: [
                        BoxShadow(
                          color: AppColors.accent.withValues(alpha: 0.5),
                          blurRadius: 10,
                          spreadRadius: 1,
                        )
                      ],
                    ),
                    padding: EdgeInsets.all(context.widthPct(2)),
                    child: const Icon(Icons.camera_alt, color: AppColors.background, size: 20),
                  ),
                ),
            ],
          ),
        ),
        SizedBox(height: context.heightPct(2)),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [
            Flexible(
              child: Text(
                group.name,
                style: AppTypography.displayLg.copyWith(
                  color: AppColors.textPrimary,
                  fontSize: context.responsiveFont(26),
                  fontWeight: FontWeight.w900,
                  letterSpacing: -0.5,
                ),
                textAlign: TextAlign.center,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
            ),
            if (group.isPlayZGlobalGroup) ...[
              SizedBox(width: context.widthPct(1.5)),
              const Icon(
                Icons.verified_rounded,
                color: Color(0xFF1DB954),
                size: 24,
              ),
            ],
          ],
        ),
        SizedBox(height: context.heightPct(0.5)),
        Text(
          "Group • ${group.members.length} members",
          style: AppTypography.bodySm.copyWith(
            color: AppColors.muted,
            fontSize: context.responsiveFont(14),
          ),
        ),
        SizedBox(height: context.heightPct(1.5)),
        if (group.description.isNotEmpty)
          Padding(
            padding: EdgeInsets.symmetric(horizontal: context.widthPct(4)),
            child: Text(
              group.description,
              style: AppTypography.bodySm.copyWith(
                color: AppColors.textSecondary,
                fontSize: context.responsiveFont(13),
                height: 1.4,
              ),
              textAlign: TextAlign.center,
            ),
          ),
        SizedBox(height: context.heightPct(1.5)),
        Text(
          "CREATED BY $creatorName IN $createdDate",
          style: AppTypography.labelCaps10.copyWith(
            color: AppColors.muted,
            fontSize: context.responsiveFont(11),
            fontWeight: FontWeight.bold,
            letterSpacing: 1.0,
          ),
        ),
        if (!group.isPlayZGlobalGroup && group.locality.isNotEmpty) ...[
          SizedBox(height: context.heightPct(1)),
          Container(
            padding: EdgeInsets.symmetric(
              horizontal: context.widthPct(3),
              vertical: context.heightPct(0.5),
            ),
            decoration: BoxDecoration(
              color: AppColors.accent.withValues(alpha: 0.15),
              borderRadius: BorderRadius.circular(context.minDimensionPct(3)),
              border: Border.all(color: AppColors.accent.withValues(alpha: 0.4)),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(
                  Icons.location_on,
                  color: AppColors.accent,
                  size: 14,
                ),
                SizedBox(width: context.widthPct(1)),
                Text(
                  '${group.locality}${group.city.isNotEmpty ? ', ${group.city}' : ''}',
                  style: AppTypography.bodySm.copyWith(
                    color: AppColors.accent,
                    fontSize: context.responsiveFont(12),
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
        ],
      ],
    );
  }

  void _showEditGroupDetailsDialog(BuildContext context, GroupModel group) {
    final nameCtrl = TextEditingController(text: group.name);
    final descCtrl = TextEditingController(text: group.description);

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: AppColors.surface,
        title: Text(
          "Edit Group Details",
          style: AppTypography.headlineSm.copyWith(
            color: AppColors.textPrimary,
            fontSize: context.responsiveFont(16),
          ),
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: nameCtrl,
              style: AppTypography.bodySm.copyWith(
                color: AppColors.textPrimary,
                fontSize: context.responsiveFont(14),
              ),
              decoration: InputDecoration(
                labelText: "Group Name",
                labelStyle: AppTypography.bodySm.copyWith(color: AppColors.muted),
                enabledBorder: const UnderlineInputBorder(
                  borderSide: BorderSide(color: AppColors.borderDark),
                ),
                focusedBorder: const UnderlineInputBorder(
                  borderSide: BorderSide(color: AppColors.accent),
                ),
              ),
            ),
            SizedBox(height: context.heightPct(1.5)),
            TextField(
              controller: descCtrl,
              style: AppTypography.bodySm.copyWith(
                color: AppColors.textPrimary,
                fontSize: context.responsiveFont(14),
              ),
              decoration: InputDecoration(
                labelText: "Description",
                labelStyle: AppTypography.bodySm.copyWith(color: AppColors.muted),
                enabledBorder: const UnderlineInputBorder(
                  borderSide: BorderSide(color: AppColors.borderDark),
                ),
                focusedBorder: const UnderlineInputBorder(
                  borderSide: BorderSide(color: AppColors.accent),
                ),
              ),
            ),
            SizedBox(height: context.heightPct(2)),
            ElevatedButton.icon(
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.card,
                foregroundColor: AppColors.textPrimary,
              ),
              icon: const Icon(Icons.image),
              label: const Text("Change Image"),
              onPressed: () async {
                final file = await ctrl.pickImage();
                if (file != null) {
                  if (!context.mounted) return;
                  Navigator.pop(context);
                  ctrl.updateGroupDetails(group.groupId, nameCtrl.text, descCtrl.text, newImage: file);
                }
              },
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(
              "Cancel",
              style: AppTypography.bodySm.copyWith(
                color: AppColors.muted,
                fontSize: context.responsiveFont(14),
              ),
            ),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: AppColors.accent),
            onPressed: () {
              Navigator.pop(context);
              ctrl.updateGroupDetails(group.groupId, nameCtrl.text, descCtrl.text);
            },
            child: Text(
              "Save",
              style: AppTypography.bodySm.copyWith(
                color: AppColors.background,
                fontWeight: FontWeight.bold,
                fontSize: context.responsiveFont(14),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
