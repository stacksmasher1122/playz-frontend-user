import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:redesign/theme/app_colors.dart';
import 'package:redesign/controller/User_Controller/Home_Controller/Groups_Controller/group_info_controller.dart';

const _kGreen = AppColors.accent;
const _kBg = AppColors.surface;
const _kSurface = Color(0xFF222222);
const _kMuted = Colors.white54;

class AddMembersTile extends StatelessWidget {
  final GroupInfoController ctrl;

  const AddMembersTile({super.key, required this.ctrl});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      contentPadding: EdgeInsets.zero,
      leading: Container(
        width: 46,
        height: 46,
        decoration: BoxDecoration(
          color: _kGreen.withOpacity(0.2),
          shape: BoxShape.circle,
        ),
        child: const Icon(Icons.person_add, color: _kGreen),
      ),
      title: const Text(
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
              decoration: const BoxDecoration(
                color: _kBg,
                borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
              ),
              child: Column(
                children: [
                  Container(
                    margin: const EdgeInsets.only(top: 12, bottom: 8),
                    width: 40,
                    height: 4,
                    decoration: BoxDecoration(color: Colors.white24, borderRadius: BorderRadius.circular(2)),
                  ),
                  const Padding(
                    padding: EdgeInsets.all(16),
                    child: Text("Add Members", style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold)),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: TextField(
                      style: const TextStyle(color: Colors.white),
                      decoration: InputDecoration(
                        hintText: "Search name or email...",
                        hintStyle: const TextStyle(color: _kMuted),
                        prefixIcon: const Icon(Icons.search, color: _kMuted),
                        filled: true,
                        fillColor: _kSurface,
                        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide.none),
                      ),
                      onChanged: (val) => ctrl.searchUsers(val),
                    ),
                  ),
                  Expanded(
                    child: Obx(() {
                      final results = ctrl.searchResults;
                      if (results.isEmpty) {
                        return const Center(child: Text("Search to find people", style: TextStyle(color: _kMuted)));
                      }
                      return ListView.builder(
                        controller: controller,
                        padding: const EdgeInsets.all(16),
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
                              child: picUrl.isEmpty ? const Icon(Icons.person, color: _kMuted) : null,
                            ),
                            title: Text(name, style: const TextStyle(color: Colors.white)),
                            subtitle: Text(email, style: const TextStyle(color: _kMuted, fontSize: 12)),
                            trailing: ElevatedButton(
                              style: ElevatedButton.styleFrom(backgroundColor: _kGreen, foregroundColor: Colors.black),
                              onPressed: () => ctrl.addMember(email, user),
                              child: const Text("ADD"),
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
