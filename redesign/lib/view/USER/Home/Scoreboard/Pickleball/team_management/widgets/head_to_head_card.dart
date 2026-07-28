import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:redesign/theme/app_colors.dart';
import 'package:redesign/theme/app_typography.dart';
import 'package:redesign/theme/responsive_helper.dart';
import 'package:redesign/controller/User_Controller/Home_Controller/Scoreboard_Controller/Pickleball/pickleball_team_management_controller.dart';

class HeadToHeadCard extends StatelessWidget {
  final PickleballTeamManagementController controller;

  const HeadToHeadCard({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      var teamA = controller.teamAPlayers.isNotEmpty ? controller.teamAPlayers.first : null;
      var teamB = controller.teamBPlayers.isNotEmpty ? controller.teamBPlayers.first : null;

      if (teamA == null || teamB == null) return const SizedBox.shrink();

      return ClipRRect(
        borderRadius: BorderRadius.circular(ResponsiveHelper.w(16)),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
          child: Container(
            padding: EdgeInsets.all(ResponsiveHelper.w(16)),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.05),
              borderRadius: BorderRadius.circular(ResponsiveHelper.w(16)),
              border: Border.all(color: Colors.white.withOpacity(0.1)),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "HEAD TO HEAD",
                  style: AppTypography.bodyLg.copyWith(color: AppColors.textSecondary, letterSpacing: 1.2),
                ),
                SizedBox(height: 16),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(teamA.name.split(' ').first, style: AppTypography.headlineMd.copyWith(color: AppColors.onPrimary)),
                        SizedBox(height: 4),
                        Text("${controller.h2hWinsA} Wins", style: AppTypography.bodyLg.copyWith(color: AppColors.accent, fontWeight: FontWeight.bold)),
                      ],
                    ),
                    Text("VS", style: AppTypography.headlineMd.copyWith(color: AppColors.textSecondary, fontStyle: FontStyle.italic)),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Text(teamB.name.split(' ').first, style: AppTypography.headlineMd.copyWith(color: AppColors.onPrimary)),
                        SizedBox(height: 4),
                        Text("${controller.h2hWinsB} Wins", style: AppTypography.bodyLg.copyWith(color: AppColors.accent, fontWeight: FontWeight.bold)),
                      ],
                    ),
                  ],
                ),
                SizedBox(height: 16),
                Divider(color: Colors.white.withOpacity(0.1)),
                SizedBox(height: 12),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text("Last Winner", style: AppTypography.bodyMd.copyWith(color: AppColors.textSecondary)),
                    Text(controller.lastWinner.value, style: AppTypography.bodyMd.copyWith(color: AppColors.onPrimary)),
                  ],
                ),
                SizedBox(height: 8),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text("Avg Match Duration", style: AppTypography.bodyMd.copyWith(color: AppColors.textSecondary)),
                    Text(controller.avgMatchDuration.value, style: AppTypography.bodyMd.copyWith(color: AppColors.onPrimary)),
                  ],
                ),
              ],
            ),
          ),
        ),
      );
    });
  }
}
