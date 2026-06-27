import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:redesign/controller/user_profile_controller.dart';
import '../home_screen.dart';

/* ============================================================
   HOME HEADER (GREETING + TOGGLE)
   ============================================================ */
class HomeHeader extends StatelessWidget {
  final bool isTrainer;
  // final AppMode mode;
  // final ValueChanged<AppMode> onChanged;
  final _controller = Get.find<UserProfileController>();

  HomeHeader({
    required this.isTrainer,
    // required this.mode,
    // required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;

    if (isTrainer) {
      return Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(child: _greeting(width)),
          const SizedBox(width: 20),
          _toggle(),
        ],
      );
    } else {
      return _greeting(width);
    }
  }

  Widget _greeting(double width) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start, // ✅ FIX: Align to left
      children: [
        const SizedBox(height: 10),
        Obx(() {
          final fullName = _controller.rxUser.value?.fullName ?? 'User';
          final firstName = fullName.split(' ').first;
          return RichText(
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            text: TextSpan(
              children: [
                TextSpan(
                  text: "Hey $firstName! 👋\n",
                  style: TextStyle(
                    fontSize: width < 360 ? 16 : 20,
                    fontWeight: FontWeight.w800,
                    color: Colors.white,
                    height: 1.1,
                  ),
                ),
                TextSpan(
                  text: "Ready for some competition?",
                  style: TextStyle(
                    fontSize: width < 360 ? 8 : 13,
                    fontWeight: FontWeight.w500,
                    color: UserHomePage.muted,
                    height: 1.2,
                  ),
                ),
              ],
            ),
          );
        }),
      ],
    );
  }

  Widget _toggle() {
    return Flexible(
      child: Column(
        children: [
          const SizedBox(height: 15),
          ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 150, minWidth: 110),
            // child: TrainerModePillToggle(
            //   mode: mode,
            //   onChanged: onChanged,
            //   compact: true,
            // ),
          ),
        ],
      ),
    );
  }
}
