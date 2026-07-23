import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:redesign/theme/app_colors.dart';
import 'package:redesign/theme/app_typography.dart';
import 'package:redesign/theme/responsive_helper.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:redesign/shared_preferences/userPreferences.dart';
import '../../../../../../model/User_Models/Tournament_Model/bracket_model.dart';
import 'referee_assignment_sheet.dart';

class MatchSlotCard extends StatefulWidget {
  final String tournamentId;
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
  State<MatchSlotCard> createState() => _MatchSlotCardState();
}

class _MatchSlotCardState extends State<MatchSlotCard> {
  String? _docId;

  @override
  void initState() {
    super.initState();
    _loadUser();
  }

  Future<void> _loadUser() async {
    final docId = await UserPreferences.getDocId();
    if (mounted) {
      setState(() {
        _docId = docId;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final match = widget.match;
    final teamA = widget.teamA;
    final teamB = widget.teamB;
    final isOrganizer = widget.isOrganizer;

    bool isBye = match.teamAId == null || match.teamBId == null;

    Color statusColor = AppColors.muted;
    String statusText = "Upcoming";
    IconData statusIcon = Icons.access_time;

    final isTeamAWinner = match.winnerId != null && match.winnerId == match.teamAId;
    final isTeamBWinner = match.winnerId != null && match.winnerId == match.teamBId;
    final bool isCompleted = match.status == 'completed';

    if (isBye) {
      statusText = "Auto-Advance";
      statusIcon = Icons.fast_forward;
    } else if (match.status == 'in_progress') {
      statusColor = Colors.orange;
      statusText = "In Progress";
      statusIcon = Icons.play_circle_fill;
    } else if (isCompleted) {
      statusColor = AppColors.accent;
      statusText = "Completed";
      statusIcon = Icons.emoji_events;
    } else if (match.status == 'scheduled') {
      statusColor = Colors.blueAccent;
      statusText = "Scheduled";
      statusIcon = Icons.calendar_today;
    }

    final authUid = FirebaseAuth.instance.currentUser?.uid;
    final authEmail = FirebaseAuth.instance.currentUser?.email;

    final refUserId = match.referee?['userId']?.toString();
    final refUserEmail = match.referee?['userEmail']?.toString();

    final bool isRefereeUser = match.referee != null && (
      (authUid != null && authUid == refUserId) ||
      (_docId != null && _docId!.isNotEmpty && (_docId == refUserId || _docId == refUserEmail)) ||
      (authEmail != null && authEmail.isNotEmpty && (authEmail == refUserEmail || authEmail == refUserId))
    );

    final bool isAcceptedReferee = isRefereeUser && match.referee!['status'] == 'accepted';
    final bool isInvitedReferee = isRefereeUser && match.referee!['status'] == 'invited';

    final bool canScore = isOrganizer || isAcceptedReferee;
    final bool canViewScore = match.status == 'in_progress' || isCompleted;
    final bool canTapCard = !isBye && (canScore || canViewScore);

    return GestureDetector(
      onTap: canTapCard ? widget.onTap : null,
      child: Container(
        margin: EdgeInsets.only(bottom: ResponsiveHelper.h(12)),
        padding: EdgeInsets.all(ResponsiveHelper.w(12)),
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(ResponsiveHelper.w(8)),
          border: Border.all(
            color: isCompleted
                ? AppColors.accent
                : (match.status == 'in_progress' ? Colors.orange : Colors.transparent),
            width: isCompleted ? 1.5 : 1.0,
          ),
        ),
        child: Column(
          children: [
            Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      // Team A Row
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Flexible(
                            child: Text(
                              teamA,
                              style: AppTypography.bodyMd.copyWith(
                                color: isTeamAWinner ? AppColors.accent : AppColors.onPrimary,
                                fontWeight: isTeamAWinner ? FontWeight.bold : FontWeight.normal,
                              ),
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                          if (isTeamAWinner) ...[
                            SizedBox(width: ResponsiveHelper.w(6)),
                            Container(
                              padding: EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                              decoration: BoxDecoration(
                                color: AppColors.accent.withValues(alpha: 0.2),
                                borderRadius: BorderRadius.circular(4),
                              ),
                              child: Text(
                                "WINNER",
                                style: TextStyle(
                                  color: AppColors.accent,
                                  fontSize: 9,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            )
                          ]
                        ],
                      ),
                      SizedBox(height: ResponsiveHelper.h(4)),
                      Text("vs", style: AppTypography.labelCaps.copyWith(color: AppColors.muted)),
                      SizedBox(height: ResponsiveHelper.h(4)),

                      // Team B Row
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Flexible(
                            child: Text(
                              teamB,
                              style: AppTypography.bodyMd.copyWith(
                                color: isTeamBWinner ? AppColors.accent : AppColors.onPrimary,
                                fontWeight: isTeamBWinner ? FontWeight.bold : FontWeight.normal,
                              ),
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                          if (isTeamBWinner) ...[
                            SizedBox(width: ResponsiveHelper.w(6)),
                            Container(
                              padding: EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                              decoration: BoxDecoration(
                                color: AppColors.accent.withValues(alpha: 0.2),
                                borderRadius: BorderRadius.circular(4),
                              ),
                              child: Text(
                                "WINNER",
                                style: TextStyle(
                                  color: AppColors.accent,
                                  fontSize: 9,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            )
                          ]
                        ],
                      ),
                    ],
                  ),
                ),
                SizedBox(width: ResponsiveHelper.w(12)),
                Container(
                  width: ResponsiveHelper.w(90),
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
                      if (match.status == 'in_progress')
                        Padding(
                          padding: const EdgeInsets.only(top: 4.0),
                          child: Text(
                            canScore ? "Score Match" : "View Live",
                            style: TextStyle(
                              color: canScore ? Colors.orange : AppColors.accent,
                              fontSize: 9,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        )
                      else if (match.status == 'unscheduled' && canScore && !isBye)
                        Padding(
                          padding: const EdgeInsets.only(top: 4.0),
                          child: Text("Start", style: TextStyle(color: AppColors.accent, fontSize: 9, fontWeight: FontWeight.bold)),
                        )
                      else if (isCompleted)
                        Padding(
                          padding: const EdgeInsets.only(top: 4.0),
                          child: Text(
                            "View Score",
                            style: TextStyle(color: AppColors.accent, fontSize: 9, fontWeight: FontWeight.bold),
                          ),
                        ),
                    ],
                  ),
                ),
              ],
            ),

             // Referee status badge or organizer management row
            if (!isBye)
              Padding(
                padding: const EdgeInsets.only(top: 8.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Referee Status Display
                    if (isAcceptedReferee)
                      Row(
                        children: [
                          Icon(Icons.check_circle, size: 14, color: AppColors.accent),
                          SizedBox(width: 4),
                          Expanded(
                            child: Text("Referee: You (Assigned ✓)", style: TextStyle(color: AppColors.accent, fontSize: 10, fontWeight: FontWeight.bold)),
                          ),
                        ],
                      )
                    else if (isInvitedReferee)
                      Row(
                        children: [
                          Icon(Icons.schedule_send, size: 14, color: Colors.orange),
                          SizedBox(width: 4),
                          Expanded(
                            child: Text("Referee: You (Invitation Sent ✓)", style: TextStyle(color: Colors.orange, fontSize: 10, fontWeight: FontWeight.bold)),
                          ),
                        ],
                      )
                    else if (match.referee != null && match.referee!['status'] != 'revoked' && match.referee!['status'] != 'none')
                      Row(
                        children: [
                          Icon(
                            match.referee!['status'] == 'accepted' ? Icons.check_circle : Icons.schedule_send,
                            size: 14,
                            color: match.referee!['status'] == 'accepted' ? AppColors.accent : Colors.orange,
                          ),
                          SizedBox(width: 4),
                          Flexible(
                            child: Text(
                              () {
                                final refName = (match.referee!['userName'] ?? '').toString();
                                if (match.referee!['status'] == 'accepted') {
                                  return refName.isNotEmpty
                                      ? 'Referee Assigned ✓ — $refName'
                                      : 'Referee Assigned ✓';
                                } else {
                                  return refName.isNotEmpty
                                      ? 'Invitation Sent ✓ — $refName'
                                      : 'Invitation Sent ✓';
                                }
                              }(),
                              style: TextStyle(
                                color: match.referee!['status'] == 'accepted' ? AppColors.accent : Colors.orange,
                                fontSize: 10,
                                fontWeight: FontWeight.w600,
                              ),
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ],
                      )
                    else if (isOrganizer)
                      Row(
                        children: [
                          Icon(Icons.person_add_alt_1, size: 14, color: AppColors.muted),
                          SizedBox(width: 4),
                          Text("No referee assigned", style: TextStyle(color: AppColors.muted, fontSize: 10)),
                        ],
                      ),

                    // Organizer Referee Management Actions
                    if (isOrganizer && (match.status == 'unscheduled' || match.status == 'scheduled' || match.status == 'in_progress'))
                      Padding(
                        padding: const EdgeInsets.only(top: 4.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            // Revoke button (only if a referee is currently assigned/invited)
                            if (match.referee != null && match.referee!['status'] != 'revoked' && match.referee!['status'] != 'none')
                              TextButton.icon(
                                style: TextButton.styleFrom(
                                  padding: EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                                  minimumSize: Size.zero,
                                  tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                                ),
                                icon: Icon(Icons.person_remove, size: 12, color: Colors.redAccent),
                                onPressed: () async {
                                  final confirm = await Get.dialog<bool>(
                                    AlertDialog(
                                      backgroundColor: AppColors.surface,
                                      title: Text("Revoke Referee?", style: TextStyle(color: AppColors.onPrimary)),
                                      content: Text(
                                        "This will remove the current referee. You can assign a new one after.",
                                        style: TextStyle(color: AppColors.muted),
                                      ),
                                      actions: [
                                        TextButton(
                                          onPressed: () => Get.back(result: false),
                                          child: Text("Cancel", style: TextStyle(color: AppColors.muted)),
                                        ),
                                        ElevatedButton(
                                          style: ElevatedButton.styleFrom(backgroundColor: Colors.redAccent),
                                          onPressed: () => Get.back(result: true),
                                          child: Text("Revoke", style: TextStyle(color: Colors.white)),
                                        ),
                                      ],
                                    ),
                                  );
                                  if (confirm == true) {
                                    try {
                                      await FirebaseFirestore.instance
                                          .collection('tournaments')
                                          .doc(widget.tournamentId)
                                          .collection('bracket')
                                          .doc(match.id)
                                          .update({'referee.status': 'revoked'});
                                      Get.snackbar("Revoked", "Referee removed. You can now assign a new one.", backgroundColor: Colors.green, colorText: Colors.white);
                                    } catch (e) {
                                      Get.snackbar("Error", "Failed to revoke: $e", backgroundColor: Colors.red, colorText: Colors.white);
                                    }
                                  }
                                },
                                label: Text("Revoke", style: TextStyle(color: Colors.redAccent, fontSize: 10)),
                              ),
                            SizedBox(width: 8),
                            // Assign / Manage button
                            TextButton.icon(
                              style: TextButton.styleFrom(
                                padding: EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                                minimumSize: Size.zero,
                                tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                              ),
                              icon: Icon(
                                (match.referee != null && match.referee!['status'] != 'revoked' && match.referee!['status'] != 'none')
                                    ? Icons.manage_accounts
                                    : Icons.person_add,
                                size: 12,
                                color: AppColors.accent,
                              ),
                              onPressed: () {
                                Get.bottomSheet(
                                  RefereeAssignmentSheet(
                                    tournamentId: widget.tournamentId,
                                    matchId: match.id,
                                    currentReferee: match.referee,
                                    teamA: teamA,
                                    teamB: teamB,
                                    round: match.round,
                                  ),
                                  isScrollControlled: true,
                                );
                              },
                              label: Text(
                                (match.referee != null && match.referee!['status'] != 'revoked' && match.referee!['status'] != 'none')
                                    ? "Manage Referee"
                                    : "Assign Referee",
                                style: TextStyle(color: AppColors.accent, fontSize: 10, fontWeight: FontWeight.w600),
                              ),
                            ),
                          ],
                        ),
                      ),
                  ],
                ),
              ),
          ],
        ),
      ),
    );
  }
}
