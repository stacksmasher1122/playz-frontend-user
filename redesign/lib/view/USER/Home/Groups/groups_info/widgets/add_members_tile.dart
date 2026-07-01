import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:redesign/theme/app_colors.dart';
import 'package:redesign/controller/User_Controller/Home_Controller/Groups_Controller/group_info_controller.dart';
import 'package:redesign/theme/responsive_helper.dart';

const _kGreen = AppColors.accent;
const _kBg = AppColors.surface;
const _kSurface = Color(0xFF222222);
const _kMuted = Colors.white54;

class AddMembersTile extends StatelessWidget {
  final GroupInfoController ctrl;

  AddMembersTile({super.key, required this.ctrl});

  @override
  Widget build(BuildContext context) {
    ResponsiveHelper.init(context);
    return ListTile(
      contentPadding: EdgeInsets.zero,
      leading: Container(
        width: ResponsiveHelper.w(46),
        height: ResponsiveHelper.h(46),
        decoration: BoxDecoration(
          color: _kGreen.withValues(alpha: 0.2),
          shape: BoxShape.circle,
        ),
        child: Icon(Icons.person_add, color: _kGreen),
      ),
      title: Text(
        "Add Members",
        style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
      ),
      onTap: () => _showAddMembersSheet(context),
    );
  }

  void _showAddMembersSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) {
        return DraggableScrollableSheet(
          initialChildSize: 0.8,
          builder: (_, controller) {
            return Container(
              decoration: BoxDecoration(
                color: _kBg,
                borderRadius: BorderRadius.vertical(top: Radius.circular(ResponsiveHelper.w(24))),
              ),
              child: Column(
                children: [
                  Container(
                    margin: EdgeInsets.only(top: ResponsiveHelper.h(12), bottom: 8),
                    width: ResponsiveHelper.w(40),
                    height: ResponsiveHelper.h(4),
                    decoration: BoxDecoration(color: Colors.white24, borderRadius: BorderRadius.circular(ResponsiveHelper.w(2))),
                  ),
                  Padding(
                    padding: EdgeInsets.all(ResponsiveHelper.w(16)),
                    child: Text("Add Members", style: TextStyle(color: Colors.white, fontSize: ResponsiveHelper.sp(18), fontWeight: FontWeight.bold)),
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: ResponsiveHelper.w(16)),
                    child: TextField(
                      style: TextStyle(color: Colors.white),
                      decoration: InputDecoration(
                        hintText: "Search name or email...",
                        hintStyle: TextStyle(color: _kMuted),
                        prefixIcon: Icon(Icons.search, color: _kMuted),
                        filled: true,
                        fillColor: _kSurface,
                        border: OutlineInputBorder(borderRadius: BorderRadius.circular(ResponsiveHelper.w(12)), borderSide: BorderSide.none),
                      ),
                      onChanged: (val) => ctrl.searchUsers(val),
                    ),
                  ),
                  Expanded(
                    child: Obx(() {
                      final results = ctrl.searchResults;
                      if (results.isEmpty) {
                        return Center(child: Text("Search to find people", style: TextStyle(color: _kMuted)));
                      }
                      return ListView.builder(
                        controller: controller,
                        padding: EdgeInsets.all(ResponsiveHelper.w(16)),
                        itemCount: results.length,
                        itemBuilder: (context, index) {
                          final user = results[index];
                          final email = user['email'] ?? '';
                          final name = user['fullName'] ?? user['Name'] ?? email;
                          final picUrl = user['profileImageUrl'] ?? '';
                          return ListTile(
                            leading: CircleAvatar(
                              backgroundColor: _kSurface,
                              backgroundImage: picUrl.isNotEmpty ? CachedNetworkImageProvider(picUrl) : null,
                              child: picUrl.isEmpty ? Icon(Icons.person, color: _kMuted) : null,
                            ),
                            title: Text(name, style: TextStyle(color: Colors.white)),
                            subtitle: Text(email, style: TextStyle(color: _kMuted, fontSize: 12)),
                            trailing: ElevatedButton(
                              style: ElevatedButton.styleFrom(backgroundColor: _kGreen, foregroundColor: Colors.black),
                              onPressed: () => ctrl.addMember(email, user),
                              child: Text("ADD"),
                            ),
                          );
                        },
                      );
                    }),
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }
}
