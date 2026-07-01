import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:redesign/theme/app_colors.dart';
import 'package:redesign/controller/User_Controller/Home_Controller/Groups_Controller/groups_controller.dart';
import 'squad_list_tile.dart';

const kGreen = AppColors.accent;
const kMuted = Colors.white70;

class MySquadsList extends StatelessWidget {
  const MySquadsList({super.key});

  @override
  Widget build(BuildContext context) {
    final ctrl = Get.find<GroupsController>();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Padding(
          padding: EdgeInsets.fromLTRB(16, 24, 16, 8),
          child: Text(
            'MY SQUADS',
            style: TextStyle(
              color: Colors.white,
              fontSize: 14,
              fontWeight: FontWeight.w400,
              letterSpacing: 1.2,
            ),
          ),
        ),

        Obx(() {
          if (ctrl.isLoading.value && ctrl.myGroups.isEmpty) {
            return const Padding(
              padding: EdgeInsets.symmetric(vertical: 40),
              child: Center(
                child: CircularProgressIndicator(color: kGreen),
              ),
            );
          }

          if (ctrl.myGroups.isEmpty) {
            return Padding(
              padding: const EdgeInsets.symmetric(vertical: 40, horizontal: 16),
              child: Center(
                child: Column(
                  children: [
                    Icon(Icons.group_outlined,
                        color: Colors.white.withValues(alpha: 0.2), size: 48),
                    const SizedBox(height: 12),
                    const Text(
                      'No groups yet',
                      style: TextStyle(
                        color: kMuted,
                        fontSize: 15,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'Create a group or join one to get started!',
                      style: TextStyle(
                        color: Colors.white.withValues(alpha: 0.4),
                        fontSize: 13,
                      ),
                    ),
                  ],
                ),
              ),
            );
          }

          return ListView.separated(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: ctrl.myGroups.length,
            separatorBuilder: (_, __) => const Divider(
              height: 1,
              color: Colors.white12,
              indent: 80,
              endIndent: 16,
            ),
            itemBuilder: (context, index) {
              final group = ctrl.myGroups[index];
              return SquadListTile(group: group);
            },
          );
        }),

        const Divider(height: 1, color: Colors.white12, indent: 80, endIndent: 16),
      ],
    );
  }
}
