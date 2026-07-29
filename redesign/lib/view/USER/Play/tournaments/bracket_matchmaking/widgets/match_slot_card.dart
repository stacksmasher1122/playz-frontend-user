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
    ResponsiveHelper.init(context);

    final match = widget.match;
    final teamA = widget.teamA;
    final teamB = widget.teamB;
    final isOrganizer = widget.isOrganizer;

    final bool isBye = match.teamAId == null || match.teamBId == null;

    Color statusColor = AppColors.muted;
    String statusText = "Upcoming";
    IconData statusIcon = Icons.access_time_rounded;

    final isTeamAWinner = match.winnerId != null && match.winnerId == match.teamAId;
    final isTeamBWinner = match.winnerId != null && match.winnerId == match.teamBId;
    final bool isCompleted = match.status == 'completed';

    if (isBye) {
      statusText = "Auto-Advance";
      statusIcon = Icons.fast_forward_rounded;
    } else if (match.status == 'in_progress') {
      statusColor = AppColors.warning;
      statusText = "In Progress";
      statusIcon = Icons.play_circle_fill_rounded;
    } else if (isCompleted) {
      statusColor = AppColors.accent;
      statusText = "Completed";
      statusIcon = Icons.emoji_events_rounded;
    } else if (match.status == 'scheduled') {
      statusColor = AppColors.infoBlue;
      statusText = "Scheduled";
      statusIcon = Icons.calendar_today_rounded;
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
        margin: EdgeInsets.only(bottom: context.heightPct(1.5)),
        padding: EdgeInsets.all(context.widthPct(3.5)),
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(context.minDimensionPct(3)),
          border: Border.all(
            color: isCompleted
                ? AppColors.accent
                : (match.status == 'in_progress' ? AppColors.warning : AppColors.borderDark),
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
                                color: isTeamAWinner ? AppColors.accent : AppColors.textPrimary,
                                fontWeight: isTeamAWinner ? FontWeight.bold : FontWeight.normal,
                                fontSize: context.responsiveFont(14),
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                          if (isTeamAWinner) ...[
                            SizedBox(width: context.widthPct(1.5)),
                            Container(
                              padding: EdgeInsets.symmetric(
                                horizontal: context.widthPct(1.5),
                                vertical: context.heightPct(0.3),
                              ),
                              decoration: BoxDecoration(
                                color: AppColors.accent.withValues(alpha: 0.2),
                                borderRadius: BorderRadius.circular(context.minDimensionPct(1)),
                              ),
                              child: Text(
                                "WINNER",
                                style: AppTypography.labelCaps10.copyWith(
                                  color: AppColors.accent,
                                  fontSize: context.responsiveFont(9),
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ],
                        ],
                      ),
                      SizedBox(height: context.heightPct(0.5)),
                      Text(
                        "vs",
                        style: AppTypography.labelCaps10.copyWith(
                          color: AppColors.muted,
                          fontSize: context.responsiveFont(11),
                        ),
                      ),
                      SizedBox(height: context.heightPct(0.5)),

                      // Team B Row
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Flexible(
                            child: Text(
                              teamB,
                              style: AppTypography.bodyMd.copyWith(
                                color: isTeamBWinner ? AppColors.accent : AppColors.textPrimary,
                                fontWeight: isTeamBWinner ? FontWeight.bold : FontWeight.normal,
                                fontSize: context.responsiveFont(14),
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                          if (isTeamBWinner) ...[
                            SizedBox(width: context.widthPct(1.5)),
                            Container(
                              padding: EdgeInsets.symmetric(
                                horizontal: context.widthPct(1.5),
                                vertical: context.heightPct(0.3),
                              ),
                              decoration: BoxDecoration(
                                color: AppColors.accent.withValues(alpha: 0.2),
                                borderRadius: BorderRadius.circular(context.minDimensionPct(1)),
                              ),
                              child: Text(
                                "WINNER",
                                style: AppTypography.labelCaps10.copyWith(
                                  color: AppColors.accent,
                                  fontSize: context.responsiveFont(9),
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ],
                        ],
                      ),
                    ],
                  ),
                ),
                SizedBox(width: context.widthPct(3)),
                Container(
                  width: context.widthPct(24).clamp(80.0, 100.0),
                  padding: EdgeInsets.symmetric(
                    horizontal: context.widthPct(1.5),
                    vertical: context.heightPct(1),
                  ),
                  decoration: BoxDecoration(
                    color: AppColors.card,
                    borderRadius: BorderRadius.circular(context.minDimensionPct(2)),
                  ),
                  child: Column(
                    children: [
                      Icon(statusIcon, color: statusColor, size: 20),
                      SizedBox(height: context.heightPct(0.5)),
                      Text(
                        statusText,
                        textAlign: TextAlign.center,
                        style: AppTypography.bodySm.copyWith(
                          color: statusColor,
                          fontSize: context.responsiveFont(10),
                          fontWeight: FontWeight.bold,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      if (match.status == 'in_progress')
                        Padding(
                          padding: EdgeInsets.only(top: context.heightPct(0.5)),
                          child: Text(
                            canScore ? "Score Match" : "View Live",
                            style: AppTypography.bodySm.copyWith(
                              color: canScore ? AppColors.warning : AppColors.accent,
                              fontSize: context.responsiveFont(9),
                              fontWeight: FontWeight.bold,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        )
                      else if (match.status == 'unscheduled' && canScore && !isBye)
                        Padding(
                          padding: EdgeInsets.only(top: context.heightPct(0.5)),
                          child: Text(
                            "Start",
                            style: AppTypography.bodySm.copyWith(
                              color: AppColors.accent,
                              fontSize: context.responsiveFont(9),
                              fontWeight: FontWeight.bold,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        )
                      else if (isCompleted)
                        Padding(
                          padding: EdgeInsets.only(top: context.heightPct(0.5)),
                          child: Text(
                            "View Score",
                            style: AppTypography.bodySm.copyWith(
                              color: AppColors.accent,
                              fontSize: context.responsiveFont(9),
                              fontWeight: FontWeight.bold,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
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
                padding: EdgeInsets.only(top: context.heightPct(1)),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Referee Status Display
                    if (isAcceptedReferee)
                      Row(
                        children: [
                          const Icon(Icons.check_circle_rounded, size: 14, color: AppColors.accent),
                          SizedBox(width: context.widthPct(1.5)),
                          Expanded(
                            child: Text(
                              "Referee: You (Assigned ✓)",
                              style: AppTypography.bodySm.copyWith(
                                color: AppColors.accent,
                                fontSize: context.responsiveFont(10),
                                fontWeight: FontWeight.bold,
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ],
                      )
                    else if (isInvitedReferee)
                      Row(
                        children: [
                          const Icon(Icons.schedule_send_rounded, size: 14, color: AppColors.warning),
                          SizedBox(width: context.widthPct(1.5)),
                          Expanded(
                            child: Text(
                              "Referee: You (Invitation Sent ✓)",
                              style: AppTypography.bodySm.copyWith(
                                color: AppColors.warning,
                                fontSize: context.responsiveFont(10),
                                fontWeight: FontWeight.bold,
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ],
                      )
                    else if (match.referee != null && match.referee!['status'] != 'revoked' && match.referee!['status'] != 'none')
                      Row(
                        children: [
                          Icon(
                            match.referee!['status'] == 'accepted' ? Icons.check_circle_rounded : Icons.schedule_send_rounded,
                            size: 14,
                            color: match.referee!['status'] == 'accepted' ? AppColors.accent : AppColors.warning,
                          ),
                          SizedBox(width: context.widthPct(1.5)),
                          Expanded(
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
                              style: AppTypography.bodySm.copyWith(
                                color: match.referee!['status'] == 'accepted' ? AppColors.accent : AppColors.warning,
                                fontSize: context.responsiveFont(10),
                                fontWeight: FontWeight.w600,
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ],
                      )
                    else if (isOrganizer)
                      Row(
                        children: [
                          const Icon(Icons.person_add_alt_1_rounded, size: 14, color: AppColors.muted),
                          SizedBox(width: context.widthPct(1.5)),
                          Text(
                            "No referee assigned",
                            style: AppTypography.bodySm.copyWith(
                              color: AppColors.muted,
                              fontSize: context.responsiveFont(10),
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ],
                      ),

                    // Organizer Referee Management Actions
                    if (isOrganizer && (match.status == 'unscheduled' || match.status == 'scheduled' || match.status == 'in_progress'))
                      Padding(
                        padding: EdgeInsets.only(top: context.heightPct(0.5)),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            // Revoke button (only if a referee is currently assigned/invited)
                            if (match.referee != null && match.referee!['status'] != 'revoked' && match.referee!['status'] != 'none')
                              TextButton.icon(
                                style: TextButton.styleFrom(
                                  padding: EdgeInsets.symmetric(
                                    horizontal: context.widthPct(1.5),
                                    vertical: context.heightPct(0.3),
                                  ),
                                  minimumSize: Size.zero,
                                  tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                                ),
                                icon: const Icon(Icons.person_remove_rounded, size: 12, color: AppColors.error),
                                onPressed: () async {
                                  final confirm = await Get.dialog<bool>(
                                    AlertDialog(
                                      backgroundColor: AppColors.surface,
                                      title: Text(
                                        "Revoke Referee?",
                                        style: AppTypography.headlineSm.copyWith(color: AppColors.textPrimary),
                                      ),
                                      content: Text(
                                        "This will remove the current referee. You can assign a new one after.",
                                        style: AppTypography.bodySm.copyWith(color: AppColors.muted),
                                      ),
                                      actions: [
                                        TextButton(
                                          onPressed: () => Get.back(result: false),
                                          child: Text(
                                            "Cancel",
                                            style: AppTypography.bodySm.copyWith(color: AppColors.muted),
                                          ),
                                        ),
                                        ElevatedButton(
                                          style: ElevatedButton.styleFrom(backgroundColor: AppColors.error),
                                          onPressed: () => Get.back(result: true),
                                          child: Text(
                                            "Revoke",
                                            style: AppTypography.bodySm.copyWith(
                                              color: AppColors.textPrimary,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
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
                                      Get.snackbar(
                                        "Revoked",
                                        "Referee removed. You can now assign a new one.",
                                        backgroundColor: AppColors.card,
                                        colorText: AppColors.textPrimary,
                                      );
                                    } catch (e) {
                                      Get.snackbar(
                                        "Error",
                                        "Failed to revoke: $e",
                                        backgroundColor: AppColors.card,
                                        colorText: AppColors.error,
                                      );
                                    }
                                  }
                                },
                                label: Text(
                                  "Revoke",
                                  style: AppTypography.bodySm.copyWith(
                                    color: AppColors.error,
                                    fontSize: context.responsiveFont(10),
                                  ),
                                ),
                              ),
                            SizedBox(width: context.widthPct(2)),
                            // Assign / Manage button
                            TextButton.icon(
                              style: TextButton.styleFrom(
                                padding: EdgeInsets.symmetric(
                                  horizontal: context.widthPct(1.5),
                                  vertical: context.heightPct(0.3),
                                ),
                                minimumSize: Size.zero,
                                tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                              ),
                              icon: Icon(
                                (match.referee != null && match.referee!['status'] != 'revoked' && match.referee!['status'] != 'none')
                                    ? Icons.manage_accounts_rounded
                                    : Icons.person_add_rounded,
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
                                style: AppTypography.bodySm.copyWith(
                                  color: AppColors.accent,
                                  fontSize: context.responsiveFont(10),
                                  fontWeight: FontWeight.w600,
                                ),
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
