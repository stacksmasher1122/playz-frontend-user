import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../../../../controller/User_Controller/Home_Controller/Scoreboard_Controller/Football/live_football_dashboard_controller.dart';
import 'quick_event_button.dart';

class QuickEventGridWidget extends StatelessWidget {
  const QuickEventGridWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<LiveFootballDashboardController>();

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: const [
              Icon(Icons.bolt, color: Colors.grey, size: 16),
              SizedBox(width: 8),
              Text(
                'QUICK EVENT TRACKER',
                style: TextStyle(
                  color: Colors.grey,
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 1.0,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          // Goal Button (Full width)
          SizedBox(
            width: double.infinity,
            height: 80,
            child: QuickEventButton(
              title: 'Goal',
              icon: Icons.sports_soccer,
              isPrimary: true,
              onTap: controller.recordGoal,
            ),
          ),
          const SizedBox(height: 12),
          // 2x2 Grid for others
          GridView.count(
            crossAxisCount: 2,
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            mainAxisSpacing: 12,
            crossAxisSpacing: 12,
            childAspectRatio: 1.8,
            children: [
              QuickEventButton(
                title: 'Card',
                icon: Icons.style,
                onTap: controller.recordCard,
              ),
              QuickEventButton(
                title: 'Foul', // From screenshot
                icon: Icons.warning_amber_rounded,
                onTap: () {}, // Optional handler
              ),
              QuickEventButton(
                title: 'Sub',
                icon: Icons.sync,
                onTap: controller.recordSubstitution,
              ),
              QuickEventButton(
                title: 'VAR',
                icon: Icons.videocam_outlined,
                onTap: controller.recordVAR,
              ),
            ],
          ),
        ],
      ),
    );
  }
}
