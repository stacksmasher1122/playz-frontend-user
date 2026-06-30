import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../../../../../controller/User_Controller/Home_Controller/Scoreboard_Controller/Badminton/live_match_controller.dart';
import 'point_history_card.dart';

class RecentPointsWidget extends StatelessWidget {
  const RecentPointsWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<LiveMatchController>();

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 8.0),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'RECENT POINTS',
                style: TextStyle(
                  color: Colors.grey,
                  fontSize: 10,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 1.5,
                ),
              ),
              Obx(() => AnimatedSwitcher(
                    duration: const Duration(milliseconds: 300),
                    transitionBuilder: (child, animation) => ScaleTransition(scale: animation, child: child),
                    child: Text(
                      'MOMENTUM ${controller.momentum.value}',
                      key: ValueKey(controller.momentum.value),
                      style: const TextStyle(
                        color: Color(0xFFC6FF00), // Neon Yellow-Green
                        fontSize: 10,
                        fontWeight: FontWeight.bold,
                        letterSpacing: 1.0,
                      ),
                    ),
                  )),
            ],
          ),
          const SizedBox(height: 12),
          SizedBox(
            height: 90,
            child: Obx(() {
              return AnimatedList(
                key: ValueKey(controller.pointHistory.length), // Rebuilds list on length change for mock purposes
                initialItemCount: controller.pointHistory.length,
                scrollDirection: Axis.horizontal,
                itemBuilder: (context, index, animation) {
                  return SlideTransition(
                    position: animation.drive(Tween(begin: const Offset(-1, 0), end: Offset.zero)),
                    child: PointHistoryCard(
                      point: controller.pointHistory[index],
                    ),
                  );
                },
              );
            }),
          ),
        ],
      ),
    );
  }
}
