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

  void _showMatchActionsModal(BuildContext context) {
    final match = widget.match;
    final teamA = widget.teamA;
    final teamB = widget.teamB;
    final isOrganizer = widget.isOrganizer;

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
    final bool hasRefereeAssigned = match.referee != null &&
        match.referee!['status'] != 'revoked' &&
        match.referee!['status'] != 'none';

    final bool canScore = isOrganizer || isAcceptedReferee;
    final bool isBye = match.teamAId == null || match.teamBId == null;

    Get.bottomSheet(
      Container(
        padding: EdgeInsets.all(context.widthPct(5)),
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.vertical(
            top: Radius.circular(context.minDimensionPct(5)),
          ),
          border: Border.all(color: AppColors.borderDark),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Handle bar
            Center(
              child: Container(
                width: context.widthPct(12),
                height: 4,
                margin: EdgeInsets.only(bottom: context.heightPct(2)),
                decoration: BoxDecoration(
                  color: AppColors.muted.withValues(alpha: 0.4),
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
            ),

            // Header
            Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "$teamA vs $teamB",
                        style: AppTypography.headlineSm.copyWith(
                          color: AppColors.textPrimary,
                          fontWeight: FontWeight.bold,
                          fontSize: context.responsiveFont(16),
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      SizedBox(height: context.heightPct(0.5)),
                      Text(
                        "Round ${match.round} • ${match.status.replaceAll('_', ' ').toUpperCase()}",
                        style: AppTypography.bodySm.copyWith(
                          color: match.status == 'completed'
                              ? AppColors.accent
                              : (match.status == 'in_progress' ? AppColors.warning : AppColors.muted),
                          fontSize: context.responsiveFont(12),
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.close, color: AppColors.muted),
                  onPressed: () => Get.back(),
                ),
              ],
            ),

            Divider(color: AppColors.borderDark, height: context.heightPct(3)),

            // Option 1: Start Match / Resume Scoring
            if (!isBye && (match.status == 'unscheduled' || match.status == 'scheduled' || match.status == 'in_progress'))
              ListTile(
                contentPadding: EdgeInsets.zero,
                leading: Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: AppColors.accent.withValues(alpha: 0.15),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    match.status == 'in_progress' ? Icons.play_arrow_rounded : Icons.sports_score_rounded,
                    color: AppColors.accent,
                  ),
                ),
                title: Text(
                  match.status == 'in_progress' ? "Resume Scoring Console" : "Start Match",
                  style: AppTypography.bodyLg.copyWith(
                    color: AppColors.textPrimary,
                    fontWeight: FontWeight.bold,
                    fontSize: context.responsiveFont(14),
                  ),
                ),
                subtitle: Text(
                  canScore
                      ? "Launch live match scoring controller"
                      : "Only assigned referee or organizer can start match",
                  style: AppTypography.bodySm.copyWith(
                    color: AppColors.muted,
                    fontSize: context.responsiveFont(12),
                  ),
                ),
                onTap: () {
                  Get.back();
                  widget.onTap();
                },
              ),

            // Option 2: Assign Referee
            if (isOrganizer && !hasRefereeAssigned && match.status != 'completed')
              ListTile(
                contentPadding: EdgeInsets.zero,
                leading: Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: AppColors.accent.withValues(alpha: 0.15),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(Icons.person_add_rounded, color: AppColors.accent),
                ),
                title: Text(
                  "Assign Referee",
                  style: AppTypography.bodyLg.copyWith(
                    color: AppColors.textPrimary,
                    fontWeight: FontWeight.bold,
                    fontSize: context.responsiveFont(14),
                  ),
                ),
                subtitle: Text(
                  "Search and invite a referee to officiate this match",
                  style: AppTypography.bodySm.copyWith(
                    color: AppColors.muted,
                    fontSize: context.responsiveFont(12),
                  ),
                ),
                onTap: () {
                  Get.back();
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
              ),

            // Option 3: Revoke Referee Access
            if (isOrganizer && hasRefereeAssigned && match.status != 'completed')
              ListTile(
                contentPadding: EdgeInsets.zero,
                leading: Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: AppColors.error.withValues(alpha: 0.15),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(Icons.person_remove_rounded, color: AppColors.error),
                ),
                title: Text(
                  "Revoke Referee Access",
                  style: AppTypography.bodyLg.copyWith(
                    color: AppColors.error,
                    fontWeight: FontWeight.bold,
                    fontSize: context.responsiveFont(14),
                  ),
                ),
                subtitle: Text(
                  "Remove referee (${match.referee?['userName'] ?? 'Assigned'}) access",
                  style: AppTypography.bodySm.copyWith(
                    color: AppColors.muted,
                    fontSize: context.responsiveFont(12),
                  ),
                ),
                onTap: () async {
                  Get.back();
                  _revokeReferee(context);
                },
              ),

            // Option 4: View Scoreboard
            if (match.status == 'completed' || match.status == 'in_progress')
              ListTile(
                contentPadding: EdgeInsets.zero,
                leading: Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: AppColors.infoBlue.withValues(alpha: 0.15),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(Icons.scoreboard_rounded, color: AppColors.infoBlue),
                ),
                title: Text(
                  "View Live Scoreboard",
                  style: AppTypography.bodyLg.copyWith(
                    color: AppColors.textPrimary,
                    fontWeight: FontWeight.bold,
                    fontSize: context.responsiveFont(14),
                  ),
                ),
                subtitle: Text(
                  "View live match scores and set stats",
                  style: AppTypography.bodySm.copyWith(
                    color: AppColors.muted,
                    fontSize: context.responsiveFont(12),
                  ),
                ),
                onTap: () {
                  Get.back();
                  widget.onTap();
                },
              ),

            SizedBox(height: context.heightPct(1)),
          ],
        ),
      ),
      isScrollControlled: true,
    );
  }

  Future<void> _revokeReferee(BuildContext context) async {
    final confirm = await Get.dialog<bool>(
      AlertDialog(
        backgroundColor: AppColors.surface,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(context.minDimensionPct(3)),
        ),
        title: Text(
          "Revoke Referee Access?",
          style: AppTypography.headlineSm.copyWith(color: AppColors.textPrimary),
        ),
        content: Text(
          "This will remove the assigned referee from this match. You can assign a new one after.",
          style: AppTypography.bodySm.copyWith(color: AppColors.muted),
        ),
        actions: [
          TextButton(
            onPressed: () => Get.back(result: false),
            child: Text("Cancel", style: AppTypography.bodySm.copyWith(color: AppColors.muted)),
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
            .doc(widget.match.id)
            .update({
              'referee': FieldValue.delete(),
            });
        Get.snackbar(
          "Referee Revoked",
          "Referee access has been revoked for this match.",
          backgroundColor: AppColors.card,
          colorText: AppColors.textPrimary,
        );
      } catch (e) {
        Get.snackbar(
          "Error",
          "Failed to revoke referee: $e",
          backgroundColor: AppColors.card,
          colorText: AppColors.error,
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    ResponsiveHelper.init(context);

    final match = widget.match;
    final teamA = widget.teamA;
    final teamB = widget.teamB;

    final bool isBye = match.teamAId == null || match.teamBId == null;
    final bool isCompleted = match.status == 'completed';
    final bool isInProgress = match.status == 'in_progress';

    final isTeamAWinner = match.winnerId != null && match.winnerId == match.teamAId;
    final isTeamBWinner = match.winnerId != null && match.winnerId == match.teamBId;

    // UEFA Bracket style colors:
    // Match didn't happen (unplayed): Grey border and grey elements
    // Match completed: Green accent border and green winner highlights
    final Color borderColor = isCompleted
        ? AppColors.accent
        : (isInProgress ? AppColors.warning : AppColors.borderDark);

    final Color cardBgColor = const Color(0xFF16161E);

    return GestureDetector(
      onTap: () {
        if (!isBye) {
          _showMatchActionsModal(context);
        }
      },
      child: Container(
        margin: EdgeInsets.only(bottom: context.heightPct(1.5)),
        decoration: BoxDecoration(
          color: cardBgColor,
          borderRadius: BorderRadius.circular(context.minDimensionPct(3)),
          border: Border.all(
            color: borderColor,
            width: isCompleted ? 1.5 : 1.0,
          ),
          boxShadow: isCompleted ? [
            BoxShadow(
              color: AppColors.accent.withValues(alpha: 0.12),
              blurRadius: 10,
              offset: const Offset(0, 3),
            ),
          ] : [],
        ),
        child: Column(
          children: [
            // Top Match Header (UEFA Champions League Style)
            Container(
              padding: EdgeInsets.symmetric(
                horizontal: context.widthPct(3.5),
                vertical: context.heightPct(0.8),
              ),
              decoration: BoxDecoration(
                color: Colors.black.withValues(alpha: 0.25),
                borderRadius: BorderRadius.vertical(
                  top: Radius.circular(context.minDimensionPct(2.8)),
                ),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    match.groupName ?? "Round ${match.round}",
                    style: AppTypography.labelCaps10.copyWith(
                      color: AppColors.muted,
                      fontSize: context.responsiveFont(11),
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  Row(
                    children: [
                      Container(
                        width: 6,
                        height: 6,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: isCompleted
                              ? AppColors.accent
                              : (isInProgress ? AppColors.warning : AppColors.muted),
                        ),
                      ),
                      SizedBox(width: context.widthPct(1.5)),
                      Text(
                        isBye
                            ? "BYE"
                            : (isCompleted
                                ? "COMPLETED"
                                : (isInProgress ? "LIVE" : "UNPLAYED")),
                        style: AppTypography.labelCaps10.copyWith(
                          color: isCompleted
                              ? AppColors.accent
                              : (isInProgress ? AppColors.warning : AppColors.muted),
                          fontSize: context.responsiveFont(10),
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),

            // Team Rows (UEFA Bracket style)
            Padding(
              padding: EdgeInsets.all(context.widthPct(3.5)),
              child: Column(
                children: [
                  // Team A Row
                  _buildTeamRow(
                    context,
                    teamName: teamA,
                    isWinner: isTeamAWinner,
                    isCompleted: isCompleted,
                    isInProgress: isInProgress,
                  ),

                  SizedBox(height: context.heightPct(0.8)),
                  Divider(color: AppColors.borderDark.withValues(alpha: 0.5), height: 1),
                  SizedBox(height: context.heightPct(0.8)),

                  // Team B Row
                  _buildTeamRow(
                    context,
                    teamName: teamB,
                    isWinner: isTeamBWinner,
                    isCompleted: isCompleted,
                    isInProgress: isInProgress,
                  ),
                ],
              ),
            ),

            // Referee status / action bar if referee assigned/invited
            if (match.referee != null &&
                match.referee!['status'] != 'revoked' &&
                match.referee!['status'] != 'none')
              Container(
                padding: EdgeInsets.symmetric(
                  horizontal: context.widthPct(3.5),
                  vertical: context.heightPct(0.6),
                ),
                decoration: BoxDecoration(
                  color: AppColors.card.withValues(alpha: 0.5),
                  borderRadius: BorderRadius.vertical(
                    bottom: Radius.circular(context.minDimensionPct(2.8)),
                  ),
                ),
                child: Row(
                  children: [
                    Icon(
                      match.referee!['status'] == 'accepted'
                          ? Icons.verified_user_rounded
                          : Icons.schedule_send_rounded,
                      size: 13,
                      color: match.referee!['status'] == 'accepted'
                          ? AppColors.accent
                          : AppColors.warning,
                    ),
                    SizedBox(width: context.widthPct(1.5)),
                    Expanded(
                      child: Text(
                        "Referee: ${match.referee!['userName'] ?? 'Assigned'} (${match.referee!['status'].toString().toUpperCase()})",
                        style: AppTypography.bodySm.copyWith(
                          color: match.referee!['status'] == 'accepted'
                              ? AppColors.accent
                              : AppColors.warning,
                          fontSize: context.responsiveFont(10),
                          fontWeight: FontWeight.w600,
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
      ),
    );
  }

  Widget _buildTeamRow(
    BuildContext context, {
    required String teamName,
    required bool isWinner,
    required bool isCompleted,
    required bool isInProgress,
  }) {
    // Green text for winner if match completed, else white if active, grey if unplayed
    final Color textColor = isWinner
        ? AppColors.accent
        : (isCompleted ? AppColors.textSecondary : AppColors.textPrimary);

    return Row(
      children: [
        // Emblem / Icon
        Container(
          width: 24,
          height: 24,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: isWinner
                ? AppColors.accent.withValues(alpha: 0.2)
                : AppColors.card,
            border: Border.all(
              color: isWinner ? AppColors.accent : AppColors.borderDark,
              width: 1,
            ),
          ),
          child: Icon(
            Icons.sports_soccer_rounded,
            size: 13,
            color: isWinner ? AppColors.accent : AppColors.muted,
          ),
        ),
        SizedBox(width: context.widthPct(2.5)),

        // Team Name
        Expanded(
          child: Text(
            teamName,
            style: AppTypography.bodyMd.copyWith(
              color: textColor,
              fontWeight: isWinner ? FontWeight.bold : FontWeight.w500,
              fontSize: context.responsiveFont(13.5),
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ),

        // Winner Badge / Green Indicator
        if (isWinner && isCompleted) ...[
          Container(
            padding: EdgeInsets.symmetric(
              horizontal: context.widthPct(2),
              vertical: context.heightPct(0.3),
            ),
            decoration: BoxDecoration(
              color: AppColors.accent.withValues(alpha: 0.18),
              borderRadius: BorderRadius.circular(context.minDimensionPct(1)),
              border: Border.all(color: AppColors.accent.withValues(alpha: 0.4)),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(Icons.emoji_events_rounded, color: AppColors.accent, size: 12),
                SizedBox(width: context.widthPct(1)),
                Text(
                  "WINNER",
                  style: AppTypography.labelCaps10.copyWith(
                    color: AppColors.accent,
                    fontSize: context.responsiveFont(9.5),
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
        ],

        if (!isCompleted && !isInProgress)
          Text(
            "-",
            style: AppTypography.bodyLg.copyWith(
              color: AppColors.muted,
              fontSize: context.responsiveFont(14),
              fontWeight: FontWeight.bold,
            ),
          ),
      ],
    );
  }
}
