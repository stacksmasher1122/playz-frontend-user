import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:redesign/theme/app_colors.dart';
import 'package:redesign/theme/app_typography.dart';
import 'package:redesign/controller/User_Controller/Home_Controller/Scoreboard_Controller/Volleyball/volleyball_starting_lineup_controller.dart';
import 'package:redesign/theme/responsive_helper.dart';

class LineupStatusWidget extends StatelessWidget {
  final VolleyballStartingLineupController controller;

  LineupStatusWidget({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    ResponsiveHelper.init(context);
    return Container(
      padding: EdgeInsets.symmetric(vertical: ResponsiveHelper.h(16)),
      decoration: BoxDecoration(
        border: Border(top: BorderSide(color: AppColors.outlineVariant)),
      ),
      child: Obx(() {
        return Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                Container(
                  width: ResponsiveHelper.w(8),
                  height: ResponsiveHelper.h(8),
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: controller.currentState.lineupReady.value ? AppColors.accent : AppColors.muted,
                  ),
                ),
                SizedBox(width: 8),
                Text(
                  'Starting Six Ready',
                  style: AppTypography.labelCaps10.copyWith(color: AppColors.muted),
                ),
              ],
            ),
            Row(
              children: [
                _buildRoleStatus('CAPTAIN', controller.currentState.captain.value?.name, controller.currentState.captain.value?.jerseyNumber),
                SizedBox(width: 24),
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
        SizedBox(height: 2),
        if (name != null)
          Text(
            '#$number ${name.split(' ').last}',
            style: AppTypography.bodyMd.copyWith(color: AppColors.accent, fontWeight: FontWeight.bold),
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
