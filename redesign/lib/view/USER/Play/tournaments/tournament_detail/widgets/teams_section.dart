import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import 'package:redesign/theme/app_colors.dart';
import 'package:redesign/theme/app_typography.dart';
import 'package:redesign/theme/responsive_helper.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../../register_team/register_team_screen.dart';
import '../../bracket_matchmaking/bracket_matchmaking_screen.dart';
import '../../../../../../controller/User_Controller/Tournament_Controller/bracket_controller.dart';

class TeamsSection extends StatelessWidget {
  final String tournamentId;
  final int maxTeams;
  final Map<String, dynamic> data;
  final String currentUserId;
  final bool isOrganizer;
  final bool isOpen;
  final bool userHasRegisteredTeam;

  const TeamsSection({
    super.key,
    required this.tournamentId,
    required this.maxTeams,
    required this.data,
    required this.currentUserId,
    required this.isOrganizer,
    required this.isOpen,
    required this.userHasRegisteredTeam,
  });

  @override
  Widget build(BuildContext context) {
    ResponsiveHelper.init(context);

    return Container(
      padding: EdgeInsets.all(context.widthPct(4)),
      decoration: BoxDecoration(
        color: AppColors.card,
        borderRadius: BorderRadius.circular(context.minDimensionPct(3)),
        border: Border.all(color: AppColors.borderDark),
      ),
      child: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection('tournaments')
            .doc(tournamentId)
            .collection('teams')
            .snapshots(),
        builder: (context, snapshot) {
          int teamCount = snapshot.hasData ? snapshot.data!.docs.length : 0;
          bool isFull = maxTeams > 0 && teamCount >= maxTeams;

          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Wrap(
                alignment: WrapAlignment.spaceBetween,
                crossAxisAlignment: WrapCrossAlignment.center,
                spacing: context.widthPct(2),
                runSpacing: context.heightPct(1),
                children: [
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        "Registered Teams",
                        style: AppTypography.headlineSm.copyWith(
                          color: AppColors.textPrimary,
                          fontSize: context.responsiveFont(16),
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(width: context.widthPct(2)),
                      if (maxTeams > 0)
                        Text(
                          "($teamCount/$maxTeams)",
                          style: AppTypography.bodyMd.copyWith(
                            color: AppColors.muted,
                            fontSize: context.responsiveFont(13),
                          ),
                        ),
                    ],
                  ),
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      if (isOpen && (!userHasRegisteredTeam || isOrganizer) && !isFull)
                        ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppColors.accent,
                            elevation: 0,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(context.minDimensionPct(2)),
                            ),
                            padding: EdgeInsets.symmetric(
                              horizontal: context.widthPct(3),
                              vertical: context.heightPct(0.8),
                            ),
                          ),
                          onPressed: () {
                            Get.to(() => RegisterTeamScreen(
                              tournamentId: tournamentId,
                              tournamentData: data,
                              currentUserId: currentUserId,
                            ));
                          },
                          child: FittedBox(
                            fit: BoxFit.scaleDown,
                            child: Text(
                              "Register Team",
                              style: AppTypography.labelCaps10.copyWith(
                                color: AppColors.background,
                                fontWeight: FontWeight.bold,
                                fontSize: context.responsiveFont(12),
                              ),
                            ),
                          ),
                        ),
                      if (isOpen && (!userHasRegisteredTeam || isOrganizer) && !isFull && isOrganizer && teamCount >= 2)
                        SizedBox(width: context.widthPct(2)),
                      if (isOrganizer && isOpen && teamCount >= 2)
                        ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppColors.warning,
                            elevation: 0,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(context.minDimensionPct(2)),
                            ),
                            padding: EdgeInsets.symmetric(
                              horizontal: context.widthPct(3),
                              vertical: context.heightPct(0.8),
                            ),
                          ),
                          onPressed: () => _startTournament(context, teamCount, isFull),
                          child: FittedBox(
                            fit: BoxFit.scaleDown,
                            child: Text(
                              "Start Tournament",
                              style: AppTypography.labelCaps10.copyWith(
                                color: AppColors.background,
                                fontWeight: FontWeight.bold,
                                fontSize: context.responsiveFont(12),
                              ),
                            ),
                          ),
                        ),
                    ],
                  ),
                ],
              ),
              if (maxTeams > 0)
                Padding(
                  padding: EdgeInsets.only(top: context.heightPct(0.5)),
                  child: Text(
                    "$teamCount / $maxTeams Teams",
                    style: AppTypography.bodySm.copyWith(
                      color: AppColors.muted,
                      fontSize: context.responsiveFont(12),
                    ),
                  ),
                ),
              SizedBox(height: context.heightPct(1.5)),
              if (snapshot.connectionState == ConnectionState.waiting)
                const Center(child: CircularProgressIndicator(color: AppColors.accent))
              else if (snapshot.hasError || !snapshot.hasData || snapshot.data!.docs.isEmpty)
                Center(
                  child: Padding(
                    padding: EdgeInsets.symmetric(vertical: context.heightPct(1.5)),
                    child: Text(
                      "No teams registered yet.",
                      style: AppTypography.bodyMd.copyWith(
                        color: AppColors.muted,
                        fontSize: context.responsiveFont(13),
                      ),
                    ),
                  ),
                )
              else
                Column(
                  children: snapshot.data!.docs.map((doc) {
                    final data = doc.data() as Map<String, dynamic>;
                    final name = data['name'] ?? 'Unknown Team';
                    final logoUrl = data['logoUrl'] ?? '';
                    final players = data['players'] as List<dynamic>? ?? [];

                    return Padding(
                      padding: EdgeInsets.only(bottom: context.heightPct(1.2)),
                      child: Row(
                        children: [
                          CircleAvatar(
                            radius: context.minDimensionPct(4.5).clamp(16.0, 22.0),
                            backgroundColor: AppColors.surface,
                            backgroundImage: logoUrl.isNotEmpty ? CachedNetworkImageProvider(logoUrl) : null,
                            child: logoUrl.isEmpty
                                ? const Icon(Icons.group_rounded, color: AppColors.muted, size: 18)
                                : null,
                          ),
                          SizedBox(width: context.widthPct(3)),
                          Expanded(
                            child: Text(
                              name,
                              style: AppTypography.bodyLg.copyWith(
                                color: AppColors.textPrimary,
                                fontSize: context.responsiveFont(14),
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                          Text(
                            "${players.length} players",
                            style: AppTypography.bodySm.copyWith(
                              color: AppColors.muted,
                              fontSize: context.responsiveFont(12),
                            ),
                          ),
                          if (isOrganizer && isOpen)
                            IconButton(
                              icon: const Icon(Icons.remove_circle_outline_rounded, color: AppColors.error, size: 20),
                              onPressed: () {
                                _showRemoveTeamDialog(context, doc.id, name, data['paymentStatus'] == 'paid');
                              },
                            ),
                        ],
                      ),
                    );
                  }).toList(),
                ),
            ],
          );
        },
      ),
    );
  }

  void _showRemoveTeamDialog(BuildContext context, String teamId, String teamName, bool hasPaid) {
    Get.dialog(
      AlertDialog(
        backgroundColor: AppColors.surface,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(context.minDimensionPct(3)),
        ),
        title: Text(
          "Remove Team",
          style: AppTypography.headlineSm.copyWith(
            color: AppColors.textPrimary,
            fontSize: context.responsiveFont(16),
            fontWeight: FontWeight.bold,
          ),
        ),
        content: Text(
          "Are you sure you want to remove $teamName from the tournament?"
          "${hasPaid ? '\n\nNote: This team paid an entry fee — removing them does not automatically refund it. You must handle refunds manually.' : ''}",
          style: AppTypography.bodySm.copyWith(
            color: AppColors.textSecondary,
            fontSize: context.responsiveFont(13),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Get.back(),
            child: Text(
              "Cancel",
              style: AppTypography.bodySm.copyWith(
                color: AppColors.muted,
                fontSize: context.responsiveFont(13),
              ),
            ),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.error,
              elevation: 0,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(context.minDimensionPct(2)),
              ),
            ),
            onPressed: () {
              Get.back();
              _removeTeam(teamId);
            },
            child: Text(
              "Remove",
              style: AppTypography.bodySm.copyWith(
                color: AppColors.textPrimary,
                fontWeight: FontWeight.bold,
                fontSize: context.responsiveFont(13),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _removeTeam(String teamId) async {
    try {
      final teamRef = FirebaseFirestore.instance.collection('tournaments').doc(tournamentId).collection('teams').doc(teamId);
      final tournamentRef = FirebaseFirestore.instance.collection('tournaments').doc(tournamentId);

      await FirebaseFirestore.instance.runTransaction((transaction) async {
        transaction.delete(teamRef);
        transaction.update(tournamentRef, {'teamCount': FieldValue.increment(-1)});
      });

      Get.snackbar(
        "Success",
        "Team removed successfully",
        backgroundColor: AppColors.card,
        colorText: AppColors.textPrimary,
      );
    } catch (e) {
      Get.snackbar(
        "Error",
        "Failed to remove team: $e",
        backgroundColor: AppColors.card,
        colorText: AppColors.error,
      );
    }
  }

  void _startTournament(BuildContext context, int teamCount, bool isFull) {
    if (!isFull) {
      Get.dialog(
        AlertDialog(
          backgroundColor: AppColors.surface,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(context.minDimensionPct(3)),
          ),
          title: Text(
            "Start Anyway?",
            style: AppTypography.headlineSm.copyWith(
              color: AppColors.textPrimary,
              fontSize: context.responsiveFont(16),
              fontWeight: FontWeight.bold,
            ),
          ),
          content: Text(
            "Only $teamCount of $maxTeams teams registered.\n\nAre you sure you want to start the tournament? Registration will be closed permanently.",
            style: AppTypography.bodySm.copyWith(
              color: AppColors.textSecondary,
              fontSize: context.responsiveFont(13),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Get.back(),
              child: Text(
                "Cancel",
                style: AppTypography.bodySm.copyWith(
                  color: AppColors.muted,
                  fontSize: context.responsiveFont(13),
                ),
              ),
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.accent,
                elevation: 0,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(context.minDimensionPct(2)),
                ),
              ),
              onPressed: () {
                Get.back();
                _triggerStartTournament();
              },
              child: Text(
                "Start",
                style: AppTypography.bodySm.copyWith(
                  color: AppColors.background,
                  fontWeight: FontWeight.bold,
                  fontSize: context.responsiveFont(13),
                ),
              ),
            ),
          ],
        ),
      );
    } else {
      _triggerStartTournament();
    }
  }

  void _triggerStartTournament() async {
    try {
      if (Get.isRegistered<BracketController>(tag: tournamentId)) {
        final bracketController = Get.find<BracketController>(tag: tournamentId);
        await bracketController.generateBracketDraft(forceGenerate: true, setInProgress: true);
      } else {
        final tempController = Get.put(BracketController(tournamentId: tournamentId, isOrganizer: true), tag: tournamentId);
        await tempController.generateBracketDraft(forceGenerate: true, setInProgress: true);
      }

      // Navigate to matchmaking screen
      Get.to(() => BracketMatchmakingScreen(tournamentId: tournamentId, isOrganizer: true));

      Get.snackbar(
        "Tournament Started!",
        "Bracket generated and registration locked.",
        backgroundColor: AppColors.accent,
        colorText: AppColors.background,
      );
    } catch (e) {
      Get.snackbar(
        "Error",
        "Failed to start tournament: $e",
        backgroundColor: AppColors.card,
        colorText: AppColors.error,
      );
    }
  }
}
