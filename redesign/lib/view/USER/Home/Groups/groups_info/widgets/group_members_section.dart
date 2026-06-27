import 'package:flutter/material.dart';
import 'package:redesign/model/User_Models/Home_Models/Groups_Model/groups_model.dart';
import 'package:redesign/controller/User_Controller/Home_Controller/Groups_Controller/group_info_controller.dart';
import 'member_tile.dart';
import 'add_members_tile.dart';

const _kSurface = Color(0xFF222222);
const _kMuted = Colors.white54;

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
        color: _kSurface.withOpacity(0.6),
        borderRadius: BorderRadius.circular(16),
      ),
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "MEMBERS ($totalCount MEMBERS)",
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 0.5,
                ),
              ),
              const Icon(Icons.search, color: _kMuted, size: 20),
            ],
          ),
          const SizedBox(height: 16),
          
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
