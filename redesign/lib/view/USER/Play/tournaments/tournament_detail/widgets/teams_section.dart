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
    return Container(
      padding: EdgeInsets.all(ResponsiveHelper.w(16)),
      decoration: BoxDecoration(
        color: AppColors.card,
        borderRadius: BorderRadius.circular(ResponsiveHelper.w(12)),
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
                spacing: ResponsiveHelper.w(8),
                runSpacing: ResponsiveHelper.h(8),
                children: [
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text("Registered Teams", style: AppTypography.headlineSm.copyWith(color: AppColors.onPrimary)),
                      SizedBox(width: ResponsiveHelper.w(8)),
                      if (maxTeams > 0)
                        Text("($teamCount/$maxTeams)", style: AppTypography.bodyMd.copyWith(color: AppColors.muted)),
                    ],
                  ),
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      if (isOpen && (!userHasRegisteredTeam || isOrganizer) && !isFull)
                        ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppColors.accent,
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(ResponsiveHelper.w(8))),
                            padding: EdgeInsets.symmetric(horizontal: ResponsiveHelper.w(12), vertical: ResponsiveHelper.h(8)),
                          ),
                          onPressed: () {
                            Get.to(() => RegisterTeamScreen(
                              tournamentId: tournamentId,
                              tournamentData: data,
                              currentUserId: currentUserId,
                            ));
                          },
                          child: Text(
                            "Register Team",
                            style: AppTypography.labelCaps.copyWith(color: AppColors.background, fontWeight: FontWeight.bold),
                          ),
                        ),
                      if (isOpen && (!userHasRegisteredTeam || isOrganizer) && !isFull && isOrganizer && teamCount >= 2)
                        SizedBox(width: ResponsiveHelper.w(8)),
                      if (isOrganizer && isOpen && teamCount >= 2)
                        ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.orangeAccent,
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(ResponsiveHelper.w(8))),
                            padding: EdgeInsets.symmetric(horizontal: ResponsiveHelper.w(12), vertical: ResponsiveHelper.h(8)),
                          ),
                          onPressed: () => _startTournament(context, teamCount, isFull),
                          child: Text(
                            "Start Tournament",
                            style: AppTypography.labelCaps.copyWith(color: AppColors.background, fontWeight: FontWeight.bold),
                          ),
                        ),
                    ],
                  ),
                ],
              ),
              if (maxTeams > 0)
                Padding(
                  padding: EdgeInsets.only(top: ResponsiveHelper.h(4)),
                  child: Text(
                    "$teamCount / $maxTeams Teams",
                    style: AppTypography.bodySm.copyWith(color: AppColors.muted),
                  ),
                ),
              SizedBox(height: ResponsiveHelper.h(16)),
              if (snapshot.connectionState == ConnectionState.waiting)
                Center(child: CircularProgressIndicator(color: AppColors.accent))
              else if (snapshot.hasError || !snapshot.hasData || snapshot.data!.docs.isEmpty)
                Center(
                  child: Padding(
                    padding: EdgeInsets.symmetric(vertical: ResponsiveHelper.h(16)),
                    child: Text(
                      "No teams registered yet.",
                      style: AppTypography.bodyMd.copyWith(color: AppColors.muted),
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
                      padding: EdgeInsets.only(bottom: ResponsiveHelper.h(12)),
                      child: Row(
                        children: [
                          CircleAvatar(
                            radius: ResponsiveHelper.w(20),
                            backgroundColor: AppColors.surface,
                            backgroundImage: logoUrl.isNotEmpty ? CachedNetworkImageProvider(logoUrl) : null,
                            child: logoUrl.isEmpty ? Icon(Icons.group, color: AppColors.muted) : null,
                          ),
                          SizedBox(width: ResponsiveHelper.w(12)),
                          Expanded(
                            child: Text(name, style: AppTypography.bodyLg.copyWith(color: AppColors.onPrimary)),
                          ),
                          Text(
                            "${players.length} players",
                            style: AppTypography.bodySm.copyWith(color: AppColors.muted),
                          ),
                          // B2 Fix: Organizer must be able to remove a registered team
                          if (isOrganizer && isOpen)
                            IconButton(
                              icon: Icon(Icons.remove_circle_outline, color: Colors.redAccent),
                              onPressed: () {
                                _showRemoveTeamDialog(context, doc.id, name, data['paymentStatus'] == 'paid');
                              },
                            )
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

  // B2 Fix: Handle removing a team
  void _showRemoveTeamDialog(BuildContext context, String teamId, String teamName, bool hasPaid) {
    Get.dialog(
      AlertDialog(
        backgroundColor: AppColors.surface,
        title: Text("Remove Team", style: TextStyle(color: Colors.white)),
        content: Text(
          "Are you sure you want to remove $teamName from the tournament?"
          "${hasPaid ? '\n\nNote: This team paid an entry fee — removing them does not automatically refund it. You must handle refunds manually.' : ''}",
          style: TextStyle(color: Colors.white70),
        ),
        actions: [
          TextButton(
            onPressed: () => Get.back(),
            child: Text("Cancel", style: TextStyle(color: AppColors.muted)),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: Colors.redAccent),
            onPressed: () {
              Get.back();
              _removeTeam(teamId);
            },
            child: Text("Remove", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
          ),
        ],
      )
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

      Get.snackbar("Success", "Team removed successfully", backgroundColor: Colors.green, colorText: Colors.white);
    } catch (e) {
      Get.snackbar("Error", "Failed to remove team: $e", backgroundColor: Colors.redAccent, colorText: Colors.white);
    }
  }

  void _startTournament(BuildContext context, int teamCount, bool isFull) {
    if (!isFull) {
      Get.dialog(
        AlertDialog(
          backgroundColor: AppColors.surface,
          title: Text("Start Anyway?", style: TextStyle(color: Colors.white)),
          content: Text(
            "Only $teamCount of $maxTeams teams registered.\n\nAre you sure you want to start the tournament? Registration will be closed permanently.",
            style: TextStyle(color: Colors.white70),
          ),
          actions: [
            TextButton(
              onPressed: () => Get.back(),
              child: Text("Cancel", style: TextStyle(color: AppColors.muted)),
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(backgroundColor: AppColors.accent),
              onPressed: () {
                Get.back();
                _triggerStartTournament();
              },
              child: Text("Start", style: TextStyle(color: AppColors.background, fontWeight: FontWeight.bold)),
            ),
          ],
        )
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
      Get.snackbar("Error", "Failed to start tournament: $e", backgroundColor: AppColors.error, colorText: Colors.white);
    }
  }
}
