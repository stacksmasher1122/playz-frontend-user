import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:redesign/controller/User_Controller/Home_Controller/Scoreboard_Controller/cricket_controller.dart';
import '../cricket_setup_screen.dart';
import 'circle_button.dart';

class LargeStepperCard extends StatelessWidget {
  final CricketController controller;

  const LargeStepperCard({
    super.key,
    required this.controller,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: kSurface,
        borderRadius: BorderRadius.circular(24),
      ),
      padding: const EdgeInsets.symmetric(vertical: 24, horizontal: 20),
      child: Column(
        children: [
          const Text(
            'MATCH LENGTH',
            style: TextStyle(
              color: kMutedText,
              fontSize: 11,
              fontWeight: FontWeight.w800,
              letterSpacing: 1.5,
            ),
          ),
          const SizedBox(height: 8),
          const Text(
            'Number of Overs',
            style: TextStyle(
              color: Colors.white,
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 24),
          FittedBox(
            fit: BoxFit.scaleDown,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                CircleButton(
                  icon: Icons.remove,
                  color: const Color(0xFF131313),
                  iconColor: kGreen.withValues(alpha: 0.7),
                  onTap: controller.decrementOvers,
                  size: 56,
                  iconSize: 28,
                ),
                const SizedBox(width: 32),
                Column(
                  children: [
                    Obx(
                      () => Text(
                        controller.overs.value.toString(),
                        style: const TextStyle(
                          color: kGreen,
                          fontSize: 64,
                          fontWeight: FontWeight.w800,
                          height: 1,
                        ),
                      ),
                    ),
                    const SizedBox(height: 4),
                  ],
                ),
                const SizedBox(width: 32),
                Container(
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    boxShadow: [
                       BoxShadow(
                        color: kGreen.withValues(alpha: 0.3),
                        blurRadius: 20,
                        spreadRadius: 2,
                      ),
                    ],
                  ),
                  child: CircleButton(
                    icon: Icons.add,
                    color: kGreen,
                    iconColor: Colors.black,
                    onTap: controller.incrementOvers,
                    size: 56,
                    iconSize: 28,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
