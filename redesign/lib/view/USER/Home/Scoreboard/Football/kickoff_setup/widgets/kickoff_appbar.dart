import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../../../../controller/User_Controller/Home_Controller/Scoreboard_Controller/Football/kickoff_setup_controller.dart';

class KickoffAppbar extends StatelessWidget implements PreferredSizeWidget {
  const KickoffAppbar({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<KickoffSetupController>();

    return AppBar(
      backgroundColor: Colors.black.withValues(alpha: 0.85),
      elevation: 0,
      centerTitle: true,
      leading: IconButton(
        icon: const Icon(Icons.arrow_back, color: Colors.white),
        onPressed: () => Navigator.pop(context),
      ),
      title: const Text(
        'KICKOFF SETUP',
        style: TextStyle(
          color: Color(0xFFC6FF00), // Lime Green
          fontSize: 16,
          fontWeight: FontWeight.w900,
          letterSpacing: 1.0,
        ),
      ),
      actions: [
        Center(
          child: Container(
            margin: const EdgeInsets.only(right: 16),
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
            decoration: BoxDecoration(
              color: Colors.grey.shade900,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: Colors.grey.shade800),
            ),
            child: Obx(() {
              return Text(
                'MATCH ID: ${controller.matchId.value}',
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 10,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 0.5,
                ),
              );
            }),
          ),
        ),
      ],
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
