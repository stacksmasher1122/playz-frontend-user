import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:redesign/theme/app_colors.dart';
import 'package:redesign/theme/app_typography.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:redesign/theme/responsive_helper.dart';
import '../../../../../controller/User_Controller/Tournament_Controller/bracket_controller.dart';
import '../../../../../model/User_Models/Tournament_Model/bracket_model.dart';
import '../match_team_confirmation/match_team_confirmation_screen.dart';
import '../../../../../controller/User_Controller/Home_Controller/Scoreboard_Controller/badminton_controller.dart';
import '../../../../../shared_preferences/userPreferences.dart';
import 'widgets/match_slot_card.dart';

class BracketMatchmakingScreen extends StatefulWidget {
  final String tournamentId;
  final bool isOrganizer;

  const BracketMatchmakingScreen({
    super.key,
    required this.tournamentId,
    required this.isOrganizer,
  });

  @override
  State<BracketMatchmakingScreen> createState() => _BracketMatchmakingScreenState();
}

class _BracketMatchmakingScreenState extends State<BracketMatchmakingScreen> {
  late BracketController controller;

  @override
  void initState() {
    super.initState();
    // Use the existing bracket controller if it's there
    if (Get.isRegistered<BracketController>(tag: widget.tournamentId)) {
      controller = Get.find<BracketController>(tag: widget.tournamentId);
    } else {
      controller = Get.put(
        BracketController(tournamentId: widget.tournamentId, isOrganizer: widget.isOrganizer),
        tag: widget.tournamentId,
      );
    }
  }

  String _getTeamName(String? id) {
    if (id == null) return "BYE";
    final team = controller.teams.firstWhereOrNull((t) => t.id == id);

    // C3 Fix: Display real name appropriately if "(me)" is needed for the current user
    // However, BracketMatchmaking displays team names. We should append "(me)" if the current user is part of the team.
    String name = team?.name ?? "TBD";
    final currentUser = FirebaseAuth.instance.currentUser;
    if (team != null && currentUser != null) {
      if (team.registeredBy == currentUser.uid) {
         return "$name (me)";
      }
      for (var player in team.players) {
        if (player.userId == currentUser.uid) {
          return "$name (me)";
        }
      }
    }
    return name;
  }

  Future<void> _handleMatchTap(BracketMatchModel match) async {
    final doc = await FirebaseFirestore.instance
        .collection('tournaments')
        .doc(widget.tournamentId)
        .collection('bracket')
        .doc(match.id)
        .get();

    if (!doc.exists) return;
    final freshMatch = BracketMatchModel.fromMap(doc.id, doc.data()!);

    final authUid = FirebaseAuth.instance.currentUser?.uid;
    final authEmail = FirebaseAuth.instance.currentUser?.email;
    final docId = await UserPreferences.getDocId();

    final refUserId = freshMatch.referee?['userId']?.toString();
    final refUserEmail = freshMatch.referee?['userEmail']?.toString();

    final isMatchReferee = freshMatch.referee != null &&
        freshMatch.referee!['status'] == 'accepted' && (
          (authUid != null && authUid == refUserId) ||
          (docId != null && docId.isNotEmpty && (docId == refUserId || docId == refUserEmail)) ||
          (authEmail != null && authEmail.isNotEmpty && (authEmail == refUserEmail || authEmail == refUserId))
        );

    final canScore = widget.isOrganizer || isMatchReferee;

    if (freshMatch.status == 'in_progress' && freshMatch.liveMatchId != null) {
      final badmintonController = Get.put(BadmintonController());

      if (canScore) {
        // Organizer or accepted referee gets full scoring console access
        badmintonController.resumeTournamentMatch(
          tId: widget.tournamentId,
          bMatchId: freshMatch.id,
          matchId: freshMatch.liveMatchId!,
          readOnly: false,
        );
      } else {
        // Normal players / spectators get read-only live scoreboard
        badmintonController.viewTournamentMatch(
          tId: widget.tournamentId,
          bMatchId: freshMatch.id,
          matchId: freshMatch.liveMatchId!,
        );
      }
    } else if (freshMatch.status == 'unscheduled' || freshMatch.status == 'scheduled') {
      if (!controller.isTournamentStarted) {
        Get.dialog(
          AlertDialog(
            backgroundColor: AppColors.surface,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            title: Row(
              children: [
                Icon(Icons.lock_clock, color: Colors.orange, size: 24),
                const SizedBox(width: 8),
                Text("Tournament Not Started", style: TextStyle(color: AppColors.onPrimary, fontSize: 16)),
              ],
            ),
            content: Text(
              widget.isOrganizer
                  ? "You must click 'Start Tournament' before matches can be started."
                  : "The tournament organizer has not started the tournament yet. Please wait for the organizer to start it.",
              style: TextStyle(color: AppColors.muted, fontSize: 14),
            ),
            actions: [
              TextButton(
                onPressed: () => Get.back(),
                child: Text("OK", style: TextStyle(color: AppColors.accent, fontWeight: FontWeight.bold)),
              ),
            ],
          ),
        );
        return;
      }

      if (canScore) {
        Get.to(() => MatchTeamConfirmationScreen(
          tournamentId: widget.tournamentId,
          matchId: freshMatch.id,
          teamAId: freshMatch.teamAId!,
          teamBId: freshMatch.teamBId!,
        ));
      } else {
        Get.snackbar("Notice", "This match has not started yet.");
      }
    } else if (freshMatch.status == 'completed' && freshMatch.liveMatchId != null) {
      // Completed match: view-only scoreboard for everyone
      final badmintonController = Get.put(BadmintonController());
      badmintonController.viewTournamentMatch(
        tId: widget.tournamentId,
        bMatchId: freshMatch.id,
        matchId: freshMatch.liveMatchId!,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.surface,
        title: Text("Bracket & Matchmaking", style: AppTypography.headlineSm.copyWith(color: AppColors.onPrimary)),
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: AppColors.onPrimary),
          onPressed: () => Get.back(),
        ),
      ),
      body: Obx(() {
        if (controller.isLoading.value) {
          return const Center(child: CircularProgressIndicator());
        }

        if (controller.matches.isEmpty) {
          return Center(
            child: Text(
              "No bracket available.",
              style: AppTypography.bodyMd.copyWith(color: AppColors.muted),
            ),
          );
        }

        // Determine if ALL real matches (non-bye) are completed
        final realMatches = controller.matches.where(
          (m) => m.teamAId != null && m.teamBId != null,
        ).toList();
        final allMatchesCompleted = realMatches.isNotEmpty &&
            realMatches.every((m) => m.status == 'completed');

        // Filter out unplayed placeholder matches (both teams null/TBD) when tournament is done
        final displayMatches = allMatchesCompleted
            ? controller.matches.where((m) {
                // Keep: completed matches, bye matches, or matches that actually had teams assigned
                return m.status == 'completed' ||
                    (m.teamAId != null && m.teamBId == null) || // bye
                    (m.teamAId == null && m.teamBId != null) || // bye
                    (m.teamAId != null && m.teamBId != null);   // real match
              }).where((m) {
                // Additionally hide unscheduled matches that never got both teams
                if (m.status == 'unscheduled' && (m.teamAId == null || m.teamBId == null)) {
                  // This is a future-round placeholder that was never filled
                  return false;
                }
                return true;
              }).toList()
            : controller.matches.toList();

        // Group matches by round or group name
        Map<String, List<BracketMatchModel>> grouped = {};
        for (var m in displayMatches) {
          String key = m.groupName ?? "Round ${m.round}";
          grouped.putIfAbsent(key, () => []).add(m);
        }

        final sortedKeys = grouped.keys.toList()..sort((a, b) {
          if (a.startsWith('Round') && b.startsWith('Round')) {
            int rA = int.tryParse(a.split(' ').last) ?? 0;
            int rB = int.tryParse(b.split(' ').last) ?? 0;
            return rA.compareTo(rB);
          }
          return a.compareTo(b);
        });

        // Sort matches within each round: completed first, then in_progress, then others
        for (var key in sortedKeys) {
          grouped[key]!.sort((a, b) {
            const order = {'completed': 0, 'in_progress': 1, 'scheduled': 2, 'unscheduled': 3};
            return (order[a.status] ?? 4).compareTo(order[b.status] ?? 4);
          });
        }

        // Determine the final round label (e.g. "Final" for last round in knockout)
        String? finalRoundKey;
        if (sortedKeys.isNotEmpty) {
          final lastKey = sortedKeys.last;
          if (lastKey.startsWith('Round') && grouped[lastKey]!.length == 1) {
            finalRoundKey = lastKey;
          }
        }

        // Find the tournament champion (winner of the final match)
        String? championName;
        if (allMatchesCompleted && finalRoundKey != null) {
          final finalMatch = grouped[finalRoundKey]!.first;
          if (finalMatch.winnerId != null) {
            championName = _getTeamName(finalMatch.winnerId);
          }
        }

        final bool showStartBanner = !controller.isTournamentStarted && !allMatchesCompleted;

        return Column(
          children: [
            if (showStartBanner)
              Container(
                margin: EdgeInsets.all(ResponsiveHelper.w(16)),
                padding: EdgeInsets.all(ResponsiveHelper.w(14)),
                decoration: BoxDecoration(
                  color: Colors.orange.withValues(alpha: 0.12),
                  borderRadius: BorderRadius.circular(ResponsiveHelper.w(12)),
                  border: Border.all(color: Colors.orange.withValues(alpha: 0.4)),
                ),
                child: Column(
                  children: [
                    Row(
                      children: [
                        Icon(Icons.info_outline, color: Colors.orange, size: 22),
                        const SizedBox(width: 10),
                        Expanded(
                          child: Text(
                            widget.isOrganizer
                                ? "Tournament has not started yet. Click 'Start Tournament' to open match scoring for referees."
                                : "Tournament has not started yet. Matches will become active once the organizer starts the tournament.",
                            style: TextStyle(color: AppColors.onPrimary, fontSize: 12),
                          ),
                        ),
                      ],
                    ),
                    if (widget.isOrganizer) ...[
                      const SizedBox(height: 12),
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton.icon(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppColors.accent,
                            padding: const EdgeInsets.symmetric(vertical: 12),
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                          ),
                          icon: Icon(Icons.play_circle_fill, color: AppColors.background),
                          label: Text(
                            "START TOURNAMENT",
                            style: TextStyle(color: AppColors.background, fontWeight: FontWeight.bold, fontSize: 14),
                          ),
                          onPressed: () => controller.startTournament(context),
                        ),
                      ),
                    ],
                  ],
                ),
              ),
            Expanded(
              child: ListView.builder(
                padding: EdgeInsets.symmetric(horizontal: ResponsiveHelper.w(16)),
                itemCount: sortedKeys.length + (allMatchesCompleted ? 1 : 0),
                itemBuilder: (context, index) {
            // Show completion banner at the top
            if (allMatchesCompleted && index == 0) {
              return Container(
                margin: EdgeInsets.only(bottom: ResponsiveHelper.h(16)),
                padding: EdgeInsets.all(ResponsiveHelper.w(16)),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      AppColors.accent.withValues(alpha: 0.15),
                      AppColors.accent.withValues(alpha: 0.05),
                    ],
                  ),
                  borderRadius: BorderRadius.circular(ResponsiveHelper.w(12)),
                  border: Border.all(color: AppColors.accent.withValues(alpha: 0.5)),
                ),
                child: Column(
                  children: [
                    Icon(Icons.emoji_events, color: AppColors.accent, size: 36),
                    SizedBox(height: ResponsiveHelper.h(8)),
                    Text(
                      "Tournament Complete",
                      style: AppTypography.headlineSm.copyWith(color: AppColors.accent),
                    ),
                    if (championName != null) ...[
                      SizedBox(height: ResponsiveHelper.h(4)),
                      Text(
                        "Champion: $championName",
                        style: AppTypography.bodyLg.copyWith(color: AppColors.onPrimary, fontWeight: FontWeight.bold),
                      ),
                    ],
                    SizedBox(height: ResponsiveHelper.h(8)),
                    Text(
                      "All ${realMatches.length} matches completed",
                      style: AppTypography.bodySm.copyWith(color: AppColors.muted),
                    ),
                  ],
                ),
              );
            }

            final adjustedIndex = allMatchesCompleted ? index - 1 : index;
            String key = sortedKeys[adjustedIndex];
            List<BracketMatchModel> matches = grouped[key]!;

            // Rename the final round for display
            String displayKey = key;
            if (key == finalRoundKey) {
              displayKey = "Final";
            } else if (sortedKeys.length > 2 && key == sortedKeys[sortedKeys.length - 2]) {
              if (key.startsWith('Round') && matches.length <= 2) {
                displayKey = "Semi-Final";
              }
            }

            // Compute round completion summary
            final completedInRound = matches.where((m) => m.status == 'completed').length;
            final totalInRound = matches.where((m) => m.teamAId != null && m.teamBId != null).length;

            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: EdgeInsets.symmetric(vertical: ResponsiveHelper.h(12)),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        displayKey,
                        style: AppTypography.bodyLg.copyWith(color: AppColors.accent, fontWeight: FontWeight.bold),
                      ),
                      if (totalInRound > 0)
                        Text(
                          "$completedInRound/$totalInRound played",
                          style: AppTypography.bodySm.copyWith(color: AppColors.muted, fontSize: 11),
                        ),
                    ],
                  ),
                ),
                ...matches.map((match) => MatchSlotCard(
                  tournamentId: widget.tournamentId,
                  match: match,
                  teamA: _getTeamName(match.teamAId),
                  teamB: _getTeamName(match.teamBId),
                  isOrganizer: widget.isOrganizer,
                  onTap: () => _handleMatchTap(match),
                )),
              ],
            );
          },
        ),
      ),
    ],
  );
}),
);
  }
}
