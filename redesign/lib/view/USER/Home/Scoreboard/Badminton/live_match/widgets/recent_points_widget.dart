import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../../../../../controller/User_Controller/Home_Controller/Scoreboard_Controller/Badminton/live_match_controller.dart';
import 'point_history_card.dart';
import 'package:redesign/theme/responsive_helper.dart';

class RecentPointsWidget extends StatelessWidget {
  RecentPointsWidget({super.key});

  @override
  Widget build(BuildContext context) {
    ResponsiveHelper.init(context);
    final controller = Get.find<LiveMatchController>();

    return Padding(
      padding: EdgeInsets.symmetric(horizontal: ResponsiveHelper.w(24.0), vertical: ResponsiveHelper.h(8.0)),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'RECENT POINTS',
                style: TextStyle(
                  color: Colors.grey,
                  fontSize: ResponsiveHelper.sp(10),
                  fontWeight: FontWeight.bold,
                  letterSpacing: 1.5,
                ),
              ),
              Obx(() => AnimatedSwitcher(
                    duration: Duration(milliseconds: 300),
                    transitionBuilder: (child, animation) => ScaleTransition(scale: animation, child: child),
                    child: Text(
                      'MOMENTUM ${controller.momentum.value}',
                      key: ValueKey(controller.momentum.value),
                      style: TextStyle(
                        color: Color(0xFFC6FF00), // Neon Yellow-Green
                        fontSize: ResponsiveHelper.sp(10),
                        fontWeight: FontWeight.bold,
                        letterSpacing: 1.0,
                      ),
                    ),
                  )),
            ],
          ),
          SizedBox(height: 12),
          SizedBox(
            height: ResponsiveHelper.h(90),
            child: Obx(() {
              return AnimatedList(
                key: ValueKey(controller.pointHistory.length), // Rebuilds list on length change for mock purposes
                initialItemCount: controller.pointHistory.length,
                scrollDirection: Axis.horizontal,
                itemBuilder: (context, index, animation) {
                  return SlideTransition(
                    position: animation.drive(Tween(begin: Offset(-1, 0), end: Offset.zero)),
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
