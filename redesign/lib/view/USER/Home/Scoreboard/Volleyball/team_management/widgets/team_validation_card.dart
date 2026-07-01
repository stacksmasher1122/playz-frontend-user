import 'package:flutter/material.dart';
import 'package:redesign/theme/app_colors.dart';
import 'package:redesign/theme/app_typography.dart';
import 'package:get/get.dart';
import 'package:redesign/controller/User_Controller/Home_Controller/Scoreboard_Controller/Volleyball/volleyball_team_management_controller.dart';

class TeamValidationCard extends StatelessWidget {
  final VolleyballTeamManagementController controller;

  const TeamValidationCard({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: AppColors.surfaceContainer.withOpacity(0.8),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: AppColors.surfaceContainerHighest),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('TEAM VALIDATION', style: AppTypography.labelCaps10.copyWith(color: AppColors.muted, fontWeight: FontWeight.bold, letterSpacing: 1.5)),
          const SizedBox(height: 16),
          Obx(() => Column(
            children: [
              _buildCheckItem('Coach Assigned (Team A & B)', controller.teamA.value.coachName.isNotEmpty && controller.teamB.value.coachName.isNotEmpty),
              const SizedBox(height: 12),
              _buildCheckItem('Captain Selected', controller.teamA.value.captain != null && controller.teamB.value.captain != null),
              const SizedBox(height: 12),
              _buildCheckItem('Minimum 6 Players per Team', controller.teamAActivePlayers.value >= 6 && controller.teamBActivePlayers.value >= 6),
            ],
          )),
        ],
      ),
    );
  }

  Widget _buildCheckItem(String label, bool isValid) {
    return Row(
      children: [
        Icon(
          isValid ? Icons.check_circle : Icons.circle_outlined,
          color: isValid ? AppColors.primaryContainer : AppColors.muted,
          size: 20,
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Text(
            label,
            style: AppTypography.bodyMd.copyWith(
              color: isValid ? AppColors.primary : AppColors.muted,
              decoration: isValid ? TextDecoration.none : TextDecoration.lineThrough,
            ),
          ),
        ),
      ],
    );
  }
}
