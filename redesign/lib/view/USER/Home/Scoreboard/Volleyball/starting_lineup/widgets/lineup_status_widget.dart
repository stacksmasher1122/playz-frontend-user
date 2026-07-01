import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:redesign/theme/app_colors.dart';
import 'package:redesign/theme/app_typography.dart';
import 'package:redesign/controller/User_Controller/Home_Controller/Scoreboard_Controller/Volleyball/volleyball_starting_lineup_controller.dart';

class LineupStatusWidget extends StatelessWidget {
  final VolleyballStartingLineupController controller;

  const LineupStatusWidget({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 16),
      decoration: const BoxDecoration(
        border: Border(top: BorderSide(color: AppColors.surfaceContainerHighest)),
      ),
      child: Obx(() {
        return Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                Container(
                  width: 8,
                  height: 8,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: controller.currentState.lineupReady.value ? AppColors.primaryContainer : AppColors.muted,
                  ),
                ),
                const SizedBox(width: 8),
                Text(
                  'Starting Six Ready',
                  style: AppTypography.labelCaps10.copyWith(color: AppColors.muted),
                ),
              ],
            ),
            Row(
              children: [
                _buildRoleStatus('CAPTAIN', controller.currentState.captain.value?.name, controller.currentState.captain.value?.jerseyNumber),
                const SizedBox(width: 24),
                _buildRoleStatus('LIBERO', controller.currentState.libero.value?.name, controller.currentState.libero.value?.jerseyNumber),
              ],
            ),
          ],
        );
      }),
    );
  }

  Widget _buildRoleStatus(String title, String? name, String? number) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(title, style: AppTypography.labelCaps10.copyWith(color: AppColors.muted, fontSize: 8)),
        const SizedBox(height: 2),
        if (name != null)
          Text(
            '#$number ${name.split(' ').last}',
            style: AppTypography.bodyMd.copyWith(color: AppColors.primary, fontWeight: FontWeight.bold),
          )
        else
          Text(
            'Not Assigned',
            style: AppTypography.bodyMd.copyWith(color: AppColors.error, fontWeight: FontWeight.bold),
          ),
      ],
    );
  }
}
