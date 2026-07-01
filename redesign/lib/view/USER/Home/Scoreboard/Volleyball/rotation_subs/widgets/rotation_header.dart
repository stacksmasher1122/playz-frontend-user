import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:redesign/theme/app_colors.dart';
import 'package:redesign/theme/app_typography.dart';
import 'package:redesign/controller/User_Controller/Home_Controller/Scoreboard_Controller/Volleyball/volleyball_rotation_subs_controller.dart';

class RotationHeader extends StatelessWidget {
  final VolleyballRotationSubsController controller;

  const RotationHeader({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Container(width: 4, height: 24, color: AppColors.primaryContainer),
            const SizedBox(width: 8),
            Text('TEAM A • SERVING', style: AppTypography.labelCaps10.copyWith(color: AppColors.primaryContainer, fontWeight: FontWeight.bold, letterSpacing: 1.5)),
          ],
        ),
        const SizedBox(height: 4),
        Text(controller.servingTeam.toUpperCase(), style: AppTypography.headlineMd.copyWith(color: AppColors.primary, fontWeight: FontWeight.w900)),
        const SizedBox(height: 16),
        Row(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Text('${controller.teamScore}', style: const TextStyle(fontSize: 56, fontWeight: FontWeight.w900, color: AppColors.primary, height: 1)),
            Padding(
              padding: const EdgeInsets.only(bottom: 8.0, left: 12.0, right: 12.0),
              child: Text('SET ${controller.currentSet}', style: AppTypography.headlineSm.copyWith(color: AppColors.muted)),
            ),
            Text('${controller.oppScore}', style: const TextStyle(fontSize: 40, fontWeight: FontWeight.w900, color: AppColors.muted, height: 1)),
          ],
        ),
        const SizedBox(height: 16),
        Align(
          alignment: Alignment.centerRight,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text('TEAM B', style: AppTypography.labelCaps10.copyWith(color: AppColors.muted, letterSpacing: 1.5)),
              Text(controller.receivingTeam.toUpperCase(), style: AppTypography.headlineSm.copyWith(color: AppColors.primary, fontWeight: FontWeight.w900)),
            ],
          ),
        ),
        const SizedBox(height: 8),
        const Divider(color: AppColors.surfaceContainerHighest),
      ],
    );
  }
}
