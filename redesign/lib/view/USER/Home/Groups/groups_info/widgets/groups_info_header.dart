import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:intl/intl.dart';
import 'package:get/get.dart';
import 'package:redesign/theme/app_colors.dart';
import 'package:redesign/model/User_Models/Home_Models/Groups_Model/groups_model.dart';
import 'package:redesign/controller/User_Controller/Home_Controller/Groups_Controller/group_info_controller.dart';

const _kGreen = AppColors.accent;
const _kBg = AppColors.surface;
const _kSurface = Color(0xFF222222);
const _kMuted = Colors.white54;

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
    final creatorName = group.members[group.creator]?['name'] ?? group.creator;
    final createdDate = DateFormat('MMM yyyy').format(group.createdAt).toUpperCase();

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
                width: 130,
                height: 130,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: _kSurface,
                  image: group.imageUrl.isNotEmpty
                      ? DecorationImage(
                          image: CachedNetworkImageProvider(group.imageUrl),
                          fit: BoxFit.cover,
                        )
                      : null,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.5),
                      blurRadius: 15,
                      offset: const Offset(0, 5),
                    )
                  ],
                ),
                child: group.imageUrl.isEmpty
                    ? const Icon(Icons.groups, size: 60, color: _kMuted)
                    : null,
              ),
              if (ctrl.isAdmin.value)
                Positioned(
                  bottom: 0,
                  right: 0,
                  child: Container(
                    decoration: BoxDecoration(
                      color: _kGreen,
                      shape: BoxShape.circle,
                      border: Border.all(color: _kBg, width: 3),
                      boxShadow: [
                        BoxShadow(
                          color: _kGreen.withOpacity(0.5),
                          blurRadius: 10,
                          spreadRadius: 1,
                        )
                      ],
                    ),
                    padding: const EdgeInsets.all(8),
                    child: const Icon(Icons.camera_alt, color: Colors.black, size: 20),
                  ),
                ),
            ],
          ),
        ),
        const SizedBox(height: 16),
        Text(
          group.name,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 26,
            fontWeight: FontWeight.w900,
            letterSpacing: -0.5,
          ),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 6),
        Text(
          group.description,
          style: const TextStyle(
            color: _kMuted,
            fontSize: 14,
          ),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 12),
        Text(
          "CREATED BY ${creatorName.toUpperCase()} • $createdDate",
          style: const TextStyle(
            color: _kGreen,
            fontSize: 10,
            fontWeight: FontWeight.bold,
            letterSpacing: 1.0,
          ),
        ),
      ],
    );
  }

  void _showEditGroupDetailsDialog(BuildContext context, GroupModel group) {
    final nameCtrl = TextEditingController(text: group.name);
    final descCtrl = TextEditingController(text: group.description);

    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        backgroundColor: _kSurface,
        title: const Text("Edit Group", style: TextStyle(color: Colors.white)),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: nameCtrl,
              style: const TextStyle(color: Colors.white),
              decoration: const InputDecoration(
                labelText: "Name",
                labelStyle: TextStyle(color: _kMuted),
                focusedBorder: UnderlineInputBorder(borderSide: BorderSide(color: _kGreen)),
              ),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: descCtrl,
              style: const TextStyle(color: Colors.white),
              decoration: const InputDecoration(
                labelText: "Description",
                labelStyle: TextStyle(color: _kMuted),
                focusedBorder: UnderlineInputBorder(borderSide: BorderSide(color: _kGreen)),
              ),
            ),
            const SizedBox(height: 16),
            ElevatedButton.icon(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.black.withOpacity(0.4),
                foregroundColor: Colors.white,
              ),
              icon: const Icon(Icons.image),
              label: const Text("Change Image"),
              onPressed: () async {
                final file = await ctrl.pickImage();
                if (file != null) {
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
            child: const Text("Cancel", style: TextStyle(color: _kMuted)),
          ),
          Obx(() {
            return TextButton(
              onPressed: ctrl.isSaving.value ? null : () {
                ctrl.updateGroupDetails(group.groupId, nameCtrl.text, descCtrl.text);
                Navigator.pop(context);
              },
              child: ctrl.isSaving.value 
                  ? const SizedBox(width: 16, height: 16, child: CircularProgressIndicator(color: _kGreen, strokeWidth: 2))
                  : const Text("Save", style: TextStyle(color: _kGreen)),
            );
          }),
        ],
      ),
    );
  }
}
