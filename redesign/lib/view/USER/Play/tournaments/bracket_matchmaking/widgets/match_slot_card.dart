import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:redesign/theme/app_colors.dart';
import 'package:redesign/theme/app_typography.dart';
import 'package:redesign/theme/responsive_helper.dart';
import '../../../../../../controller/User_Controller/Tournament_Controller/bracket_controller.dart';
import '../../../../../../model/User_Models/Tournament_Model/bracket_model.dart';

class MatchSlotCard extends StatelessWidget {
  final BracketMatchModel match;
  final String teamA;
  final String teamB;
  final bool isOrganizer;
  final VoidCallback onTap;

  const MatchSlotCard({
    super.key,
    required this.match,
    required this.teamA,
    required this.teamB,
    required this.isOrganizer,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    bool isBye = match.teamAId == null || match.teamBId == null;

    Color statusColor = AppColors.muted;
    String statusText = "Unscheduled";
    IconData statusIcon = Icons.access_time;

    if (isBye) {
      statusText = "Auto-Advance";
      statusIcon = Icons.fast_forward;
    } else if (match.status == 'in_progress') {
      statusColor = Colors.orange;
      statusText = "In Progress";
      statusIcon = Icons.play_circle_fill;
    } else if (match.status == 'completed') {
      statusColor = AppColors.accent;
      statusText = "Completed";
      statusIcon = Icons.check_circle;
    }

    return GestureDetector(
      onTap: (!isBye && isOrganizer && match.status != 'completed') ? onTap : null,
      child: Container(
        margin: EdgeInsets.only(bottom: ResponsiveHelper.h(12)),
        padding: EdgeInsets.all(ResponsiveHelper.w(12)),
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(ResponsiveHelper.w(8)),
          border: Border.all(color: match.status == 'completed' ? AppColors.accent : (match.status == 'in_progress' ? Colors.orange : Colors.transparent)),
        ),
        child: Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(teamA, style: AppTypography.bodyMd.copyWith(color: match.winnerId == match.teamAId ? AppColors.accent : AppColors.onPrimary, fontWeight: match.winnerId == match.teamAId ? FontWeight.bold : FontWeight.normal)),
                  SizedBox(height: ResponsiveHelper.h(4)),
                  Text("vs", style: AppTypography.labelCaps.copyWith(color: AppColors.muted)),
                  SizedBox(height: ResponsiveHelper.h(4)),
                  Text(teamB, style: AppTypography.bodyMd.copyWith(color: match.winnerId == match.teamBId ? AppColors.accent : AppColors.onPrimary, fontWeight: match.winnerId == match.teamBId ? FontWeight.bold : FontWeight.normal)),
                ],
              ),
            ),
            SizedBox(width: ResponsiveHelper.w(12)),
            Container(
              width: ResponsiveHelper.w(80),
              padding: EdgeInsets.symmetric(horizontal: ResponsiveHelper.w(4), vertical: ResponsiveHelper.h(8)),
              decoration: BoxDecoration(
                color: AppColors.background,
                borderRadius: BorderRadius.circular(ResponsiveHelper.w(4)),
              ),
              child: Column(
                children: [
                  Icon(statusIcon, color: statusColor, size: 20),
                  SizedBox(height: 4),
                  Text(
                    statusText,
                    textAlign: TextAlign.center,
                    style: AppTypography.bodySm.copyWith(color: statusColor, fontSize: 10, fontWeight: FontWeight.bold),
                  ),
                  if (match.status == 'in_progress' && isOrganizer)
                    Padding(
                      padding: const EdgeInsets.only(top: 4.0),
                      child: Text("Continue", style: TextStyle(color: Colors.orange, fontSize: 9, fontWeight: FontWeight.bold)),
                    )
                  else if (match.status == 'unscheduled' && isOrganizer && !isBye)
                    Padding(
                      padding: const EdgeInsets.only(top: 4.0),
                      child: Text("Start", style: TextStyle(color: AppColors.accent, fontSize: 9, fontWeight: FontWeight.bold)),
                    )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
