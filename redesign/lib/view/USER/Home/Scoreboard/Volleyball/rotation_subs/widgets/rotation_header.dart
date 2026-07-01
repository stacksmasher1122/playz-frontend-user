import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:redesign/theme/app_colors.dart';
import 'package:redesign/theme/app_typography.dart';
import 'package:redesign/controller/User_Controller/Home_Controller/Scoreboard_Controller/Volleyball/volleyball_rotation_subs_controller.dart';
import 'package:redesign/theme/responsive_helper.dart';

class RotationHeader extends StatelessWidget {
  final VolleyballRotationSubsController controller;

  RotationHeader({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    ResponsiveHelper.init(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Container(width: ResponsiveHelper.w(4), height: ResponsiveHelper.h(24), color: AppColors.primaryContainer),
            SizedBox(width: 8),
            Text('TEAM A • SERVING', style: AppTypography.labelCaps10.copyWith(color: AppColors.primaryContainer, fontWeight: FontWeight.bold, letterSpacing: 1.5)),
          ],
        ),
        SizedBox(height: 4),
        Text(controller.servingTeam.toUpperCase(), style: AppTypography.headlineMd.copyWith(color: AppColors.primary, fontWeight: FontWeight.w900)),
        SizedBox(height: 16),
        Row(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Text('${controller.teamScore}', style: TextStyle(fontSize: ResponsiveHelper.sp(56), fontWeight: FontWeight.w900, color: AppColors.primary, height: 1)),
            Padding(
              padding: EdgeInsets.only(bottom: ResponsiveHelper.h(8.0), left: ResponsiveHelper.w(12.0), right: 12.0),
              child: Text('SET ${controller.currentSet}', style: AppTypography.headlineSm.copyWith(color: AppColors.muted)),
            ),
            Text('${controller.oppScore}', style: TextStyle(fontSize: ResponsiveHelper.sp(40), fontWeight: FontWeight.w900, color: AppColors.muted, height: 1)),
          ],
        ),
        SizedBox(height: 16),
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
        SizedBox(height: 8),
        Divider(color: AppColors.surfaceContainerHighest),
      ],
    );
  }
}
