import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:redesign/theme/app_colors.dart';
import 'package:redesign/theme/app_typography.dart';
import 'package:redesign/theme/responsive_helper.dart';
import 'package:redesign/controller/User_Controller/Home_Controller/Scoreboard_Controller/Pickleball/pickleball_team_management_controller.dart';

class StickyBottomActionPanel extends StatelessWidget {
  final PickleballTeamManagementController controller;

  const StickyBottomActionPanel({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.vertical(top: Radius.circular(ResponsiveHelper.w(24))),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 15, sigmaY: 15),
        child: Container(
          padding: EdgeInsets.fromLTRB(
            ResponsiveHelper.w(20),
            ResponsiveHelper.w(16),
            ResponsiveHelper.w(20),
            ResponsiveHelper.w(32), // extra padding for bottom safe area
          ),
          decoration: BoxDecoration(
            color: AppColors.background.withOpacity(0.85),
            border: Border(
              top: BorderSide(color: Colors.white.withOpacity(0.1)),
            ),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [

              
              // Start Match Button
              Obx(() {
                bool isReady = controller.isMatchReady;
                return SizedBox(
                  width: double.infinity,
                  height: ResponsiveHelper.h(56),
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: isReady ? AppColors.accent : AppColors.surface,
                      foregroundColor: isReady ? Colors.black : Colors.grey,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(ResponsiveHelper.w(12)),
                      ),
                      elevation: isReady ? 8 : 0,
                    ),
                    onPressed: isReady ? () => controller.goNext(context) : null,
                    child: Text(
                      "START MATCH",
                      style: AppTypography.headlineMd.copyWith(
                        fontWeight: FontWeight.bold,
                        letterSpacing: 1.2,
                        color: isReady ? Colors.black : Colors.grey,
                      ),
                    ),
                  ),
                );
              }),
            ],
          ),
        ),
      ),
    );
  }
}

