import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../../../../controller/User_Controller/Home_Controller/Scoreboard_Controller/Badminton/player_management_controller.dart';

class PlayerManagementAppbar extends StatelessWidget implements PreferredSizeWidget {
  const PlayerManagementAppbar({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<PlayerManagementController>();

    return AppBar(
      backgroundColor: Colors.transparent,
      elevation: 0,
      leading: IconButton(
        icon: const Icon(Icons.arrow_back_rounded, color: Colors.white),
        onPressed: () => Navigator.pop(context),
      ),
      title: const Text(
        'MATCH CENTER',
        style: TextStyle(
          color: Colors.white,
          fontSize: 14,
          letterSpacing: 1.5,
          fontWeight: FontWeight.bold,
        ),
      ),
      centerTitle: true,
      actions: [
        Obx(() => GestureDetector(
          onTap: controller.toggleAutoSync,
          child: Padding(
            padding: const EdgeInsets.only(right: 16.0),
            child: Row(
              children: [
                Text(
                  controller.autoSync.value ? 'AUTO-SYNC ON' : 'AUTO-SYNC OFF',
                  style: TextStyle(
                    color: controller.autoSync.value ? Colors.white : Colors.grey,
                    fontSize: 10,
                    letterSpacing: 1.0,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(width: 8),
                Icon(
                  Icons.timer_outlined,
                  color: controller.autoSync.value ? Colors.white : Colors.grey,
                  size: 18,
                ),
              ],
            ),
          ),
        )),
      ],
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
