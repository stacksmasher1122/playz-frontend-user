import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:redesign/theme/app_colors.dart';
import 'package:redesign/theme/app_typography.dart';
import 'package:redesign/theme/responsive_helper.dart';
import 'package:redesign/controller/User_Controller/Home_Controller/Scoreboard_Controller/Pickleball/live_pickleball_match_controller.dart';
import 'package:redesign/model/User_Models/Home_Models/Scoreboard_Model/Pickleball/pickleball_rule_engine.dart';

class SmartServeIndicator extends StatelessWidget {
  final LivePickleballMatchController controller;
  final AnimationController pulseController;

  SmartServeIndicator({
    super.key,
    required this.controller,
    required this.pulseController,
  });

  @override
  Widget build(BuildContext context) {
    ResponsiveHelper.init(context);
    return RepaintBoundary(
      child: Container(
        padding: EdgeInsets.symmetric(
          horizontal: ResponsiveHelper.w(16),
          vertical: ResponsiveHelper.h(8),
        ),
        decoration: BoxDecoration(
          color: AppColors.background.withOpacity(0.5),
          borderRadius: BorderRadius.circular(ResponsiveHelper.w(20)),
          border: Border.all(color: AppColors.outlineVariant),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            FadeTransition(
              opacity: Tween<double>(begin: 0.3, end: 1.0).animate(pulseController),
              child: Container(
                width: ResponsiveHelper.w(10),
                height: ResponsiveHelper.h(10),
                decoration: BoxDecoration(
                  color: AppColors.accent,
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      color: AppColors.accent.withOpacity(0.5),
                      blurRadius: 8,
                      spreadRadius: 2,
                    )
                  ],
                ),
              ),
            ),
            SizedBox(width: ResponsiveHelper.w(12)),
            Obx(() {
              String server = controller.currentServer.value;
              String srvName = controller.currentServerName.value; // Server 1 / 2
              String side = controller.servingCourt.value; // Right / Left

              bool isDoubles = controller.rules.teamType != TeamType.singles;
              String detail = isDoubles ? " • \$srvName • \$side Court" : " • \$side Court";

              return Text(
                'SERVING • \$server\$detail'.toUpperCase(),
                style: AppTypography.labelCaps10.copyWith(
                  color: AppColors.accent,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 1.2,
                ),
              );
            }),
          ],
        ),
      ),
    );
  }
}
