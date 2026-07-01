import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:redesign/theme/app_colors.dart';
import 'package:redesign/theme/app_typography.dart';
import 'package:redesign/controller/User_Controller/Home_Controller/Scoreboard_Controller/Volleyball/volleyball_starting_lineup_controller.dart';
import 'package:flutter/gestures.dart';
import 'player_card.dart';

class AvailablePlayersList extends StatelessWidget {
  final VolleyballStartingLineupController controller;

  const AvailablePlayersList({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text('Available Players', style: AppTypography.headlineSm.copyWith(color: AppColors.primary, fontWeight: FontWeight.bold)),
            Obx(() => Text(
              '${controller.currentState.availablePlayers.length}/12 ROSTERED',
              style: AppTypography.labelCaps10.copyWith(color: AppColors.muted, letterSpacing: 1.2),
            )),
          ],
        ),
        const SizedBox(height: 16),
        SizedBox(
          height: 140,
          child: Obx(() => ScrollConfiguration(
            behavior: ScrollConfiguration.of(context).copyWith(
              dragDevices: {PointerDeviceKind.touch, PointerDeviceKind.mouse, PointerDeviceKind.trackpad},
            ),
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              physics: const BouncingScrollPhysics(),
              itemCount: controller.currentState.availablePlayers.length,
              itemBuilder: (context, index) {
                return PlayerCard(
                  player: controller.currentState.availablePlayers[index],
                  controller: controller,
                );
              },
            ),
          )),
        ),
      ],
    );
  }
}
