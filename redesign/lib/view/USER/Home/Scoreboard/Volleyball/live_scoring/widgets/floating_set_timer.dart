import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:redesign/theme/app_colors.dart';
import 'package:redesign/theme/app_typography.dart';
import 'package:redesign/controller/User_Controller/Home_Controller/Scoreboard_Controller/Volleyball/volleyball_live_scoring_controller.dart';

class FloatingSetTimer extends StatelessWidget {
  final VolleyballLiveScoringController controller;

  const FloatingSetTimer({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(16),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
          decoration: BoxDecoration(
            color: AppColors.surface.withOpacity(0.7),
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: AppColors.surfaceContainerHighest.withOpacity(0.5)),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.5),
                blurRadius: 10,
                offset: const Offset(0, 5),
              ),
            ],
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Obx(() => Text(
                'SET ${controller.currentSet.value}',
                style: AppTypography.labelCaps10.copyWith(color: AppColors.primaryContainer, fontWeight: FontWeight.bold, letterSpacing: 2),
              )),
              const SizedBox(height: 4),
              Obx(() {
                int seconds = controller.matchSeconds.value;
                int h = seconds ~/ 3600;
                int m = (seconds % 3600) ~/ 60;
                int s = seconds % 60;
                
                String timeStr;
                if (h > 0) {
                  timeStr = '${h.toString().padLeft(2, '0')}:${m.toString().padLeft(2, '0')}:${s.toString().padLeft(2, '0')}';
                } else {
                  timeStr = '${m.toString().padLeft(2, '0')}:${s.toString().padLeft(2, '0')}';
                }

                return Text(
                  timeStr,
                  style: AppTypography.headlineMd.copyWith(color: AppColors.primary, fontWeight: FontWeight.w900),
                );
              }),
            ],
          ),
        ),
      ),
    );
  }
}
