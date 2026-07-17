import 'package:flutter/material.dart';
import 'package:redesign/theme/app_colors.dart';
import 'package:redesign/theme/app_typography.dart';
import 'package:redesign/model/User_Models/Home_Models/Scoreboard_Model/Volleyball/volleyball_team_model.dart';
import 'package:redesign/controller/User_Controller/Home_Controller/Scoreboard_Controller/Volleyball/volleyball_team_management_controller.dart';
import 'edit_team_dialog.dart';
import 'package:redesign/theme/responsive_helper.dart';

class TeamHeaderCard extends StatelessWidget {
  final bool isTeamA;
  final VolleyballTeamModel team;
  final VolleyballTeamManagementController controller;

  TeamHeaderCard({super.key, required this.isTeamA, required this.team, required this.controller});

  @override
  Widget build(BuildContext context) {
    ResponsiveHelper.init(context);
    return Row(
      children: [
        Container(
          width: ResponsiveHelper.w(60),
          height: ResponsiveHelper.h(60),
          decoration: BoxDecoration(
            color: team.primaryColor.withOpacity(0.1),
            borderRadius: BorderRadius.circular(ResponsiveHelper.w(12)),
            border: Border.all(color: team.primaryColor, width: 2),
            boxShadow: [
              BoxShadow(
                color: team.primaryColor.withOpacity(0.3),
                blurRadius: 15,
                spreadRadius: 1,
              ),
            ],
          ),
          child: Center(
            child: Icon(Icons.shield, color: team.primaryColor, size: 32),
          ),
        ),
        SizedBox(width: 16),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                team.teamName,
                style: AppTypography.headlineSm.copyWith(color: AppColors.accent, fontWeight: FontWeight.w900, letterSpacing: 1.2),
              ),
              SizedBox(height: 4),
              Text(
                'Primary: ${team.teamName == 'VIPER ELITE' ? 'Neon Green' : 'Electric Blue'}',
                style: AppTypography.labelCaps10.copyWith(color: AppColors.muted, fontWeight: FontWeight.bold),
              ),
            ],
          ),
        ),
        Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Text('Head Coach', style: AppTypography.labelCaps10.copyWith(color: AppColors.muted, fontWeight: FontWeight.bold)),
            SizedBox(height: 4),
            Text(
              team.coachName,
              style: AppTypography.bodyMd.copyWith(color: AppColors.accent, fontWeight: FontWeight.bold),
            ),
          ],
        ),
        SizedBox(width: 8),
        IconButton(
          icon: Icon(Icons.edit_outlined, color: AppColors.muted, size: 20),
          onPressed: () {
            showDialog(
              context: context,
              builder: (_) => EditTeamDialog(isTeamA: isTeamA, team: team, controller: controller),
            );
          },
        ),
      ],
    );
  }
}
