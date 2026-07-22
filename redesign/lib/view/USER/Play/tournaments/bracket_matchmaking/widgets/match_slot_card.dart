import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:redesign/theme/app_colors.dart';
import 'package:redesign/theme/app_typography.dart';
import 'package:redesign/theme/responsive_helper.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../../../../../../controller/User_Controller/Tournament_Controller/bracket_controller.dart';
import '../../../../../../model/User_Models/Tournament_Model/bracket_model.dart';
import 'referee_assignment_sheet.dart';

class MatchSlotCard extends StatelessWidget {
  final String tournamentId; // D2 Fix: Needs tournamentId to do referee things
  final BracketMatchModel match;
  final String teamA;
  final String teamB;
  final bool isOrganizer;
  final VoidCallback onTap;

  const MatchSlotCard({
    super.key,
    required this.tournamentId,
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
    } else if (match.status == 'scheduled') {
      statusColor = Colors.blueAccent;
      statusText = "Scheduled"; // could also show scheduledTime if available
      statusIcon = Icons.calendar_today;
    }

    // D4 Fix: Allow referee to drive scoreboard
    final currentUserId = FirebaseAuth.instance.currentUser?.uid;
    final isReferee = match.referee != null && match.referee!['userId'] == currentUserId && match.referee!['status'] == 'accepted';

    return GestureDetector(
      onTap: (!isBye && (isOrganizer || isReferee) && match.status != 'completed') ? onTap : null,
      child: Container(
        margin: EdgeInsets.only(bottom: ResponsiveHelper.h(12)),
        padding: EdgeInsets.all(ResponsiveHelper.w(12)),
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(ResponsiveHelper.w(8)),
          border: Border.all(color: match.status == 'completed' ? AppColors.accent : (match.status == 'in_progress' ? Colors.orange : Colors.transparent)),
        ),
        child: Column(
          children: [
            Row(
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
                      if (match.status == 'in_progress' && (isOrganizer || isReferee))
                        Padding(
                          padding: const EdgeInsets.only(top: 4.0),
                          child: Text("Continue", style: TextStyle(color: Colors.orange, fontSize: 9, fontWeight: FontWeight.bold)),
                        )
                      else if (match.status == 'unscheduled' && (isOrganizer || isReferee) && !isBye)
                        Padding(
                          padding: const EdgeInsets.only(top: 4.0),
                          child: Text("Start", style: TextStyle(color: AppColors.accent, fontSize: 9, fontWeight: FontWeight.bold)),
                        )
                    ],
                  ),
                ),
              ],
            ),

            // D2 Fix: Referee Assignment UI
            if (isOrganizer && !isBye && (match.status == 'unscheduled' || match.status == 'in_progress'))
              Padding(
                padding: const EdgeInsets.only(top: 12.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    if (match.referee != null && match.referee!['status'] != 'revoked' && match.referee!['status'] != 'none') ...[
                      Icon(Icons.sports, size: 14, color: AppColors.accent),
                      SizedBox(width: 4),
                      Text(
                        match.referee!['status'] == 'accepted' ? 'Referee Assigned' : 'Referee Invited',
                        style: AppTypography.bodySm.copyWith(color: AppColors.accent, fontSize: 10)
                      ),
                      SizedBox(width: 12),
                    ],
                    TextButton(
                      style: TextButton.styleFrom(
                        padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                        minimumSize: Size.zero,
                        tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                      ),
                      onPressed: () {
                        Get.bottomSheet(
                          RefereeAssignmentSheet(
                            tournamentId: tournamentId,
                            matchId: match.id,
                            currentReferee: match.referee,
                            teamA: teamA,
                            teamB: teamB,
                            round: match.round,
                          ),
                          isScrollControlled: true,
                        );
                      },
                      child: Text(
                        (match.referee != null && match.referee!['status'] != 'revoked' && match.referee!['status'] != 'none') ? "Manage Referee" : "Assign Referee",
                        style: AppTypography.bodySm.copyWith(color: AppColors.muted, fontSize: 10, decoration: TextDecoration.underline)
                      ),
                    ),
                  ],
                ),
              )
          ],
        ),
      ),
    );
  }
}
