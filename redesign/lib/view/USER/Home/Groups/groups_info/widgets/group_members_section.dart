import 'package:flutter/material.dart';
import 'package:redesign/theme/app_colors.dart';
import 'package:redesign/theme/app_typography.dart';
import 'package:redesign/model/User_Models/Home_Models/Groups_Model/groups_model.dart';
import 'package:redesign/controller/User_Controller/Home_Controller/Groups_Controller/group_info_controller.dart';
import 'member_tile.dart';
import 'add_members_tile.dart';
import 'package:redesign/theme/responsive_helper.dart';

class GroupMembersSection extends StatelessWidget {
  final GroupModel group;
  final GroupInfoController ctrl;

  const GroupMembersSection({
    super.key,
    required this.group,
    required this.ctrl,
  });

  @override
  Widget build(BuildContext context) {
    ResponsiveHelper.init(context);
    final membersMap = group.members;
    final totalCount = membersMap.length;

    // Separate "Me", "Admins", and "Others"
    Map<String, dynamic>? myData;
    List<MapEntry<String, dynamic>> admins = [];
    List<MapEntry<String, dynamic>> others = [];

    for (var entry in membersMap.entries) {
      if (entry.key == ctrl.myEmail) {
        myData = entry.value;
      } else if (entry.value['role'] == 'admin') {
        admins.add(entry);
      } else {
        others.add(entry);
      }
    }

    return Container(
      decoration: BoxDecoration(
        color: AppColors.card,
        borderRadius: BorderRadius.circular(context.minDimensionPct(4)),
        border: Border.all(color: AppColors.borderDark),
      ),
      padding: EdgeInsets.all(context.widthPct(4)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "MEMBERS ($totalCount MEMBERS)",
                style: AppTypography.labelCaps10.copyWith(
                  color: AppColors.textPrimary,
                  fontSize: context.responsiveFont(12),
                  fontWeight: FontWeight.bold,
                  letterSpacing: 0.5,
                ),
              ),
              const Icon(Icons.search, color: AppColors.muted, size: 20),
            ],
          ),
          SizedBox(height: context.heightPct(1.5)),
          
          if (ctrl.isAdmin.value)
             AddMembersTile(ctrl: ctrl),

          if (myData != null)
             MemberTile(email: ctrl.myEmail, data: myData, isMe: true, ctrl: ctrl),

          ...admins.map((entry) => MemberTile(email: entry.key, data: entry.value, ctrl: ctrl)),
          
          ...others.map((entry) => MemberTile(email: entry.key, data: entry.value, ctrl: ctrl)),
        ],
      ),
    );
  }
}
