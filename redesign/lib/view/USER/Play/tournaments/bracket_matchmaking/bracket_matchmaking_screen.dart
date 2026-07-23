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
    // Before navigating, fetch a fresh copy of the match status from Firestore
    // to prevent starting/resuming based on stale cached data.
    final doc = await FirebaseFirestore.instance
        .collection('tournaments')
        .doc(widget.tournamentId)
        .collection('bracket')
        .doc(match.id)
        .get();

    if (!doc.exists) return;
    final freshMatch = BracketMatchModel.fromMap(doc.id, doc.data()!);

    if (freshMatch.status == 'in_progress' && freshMatch.liveMatchId != null) {
      // It is currently in progress, we must resume it.
      // Additionally, we should verify the live match document itself hasn't already completed
      // (in case they force closed exactly after match completed but before bracket updated).
      final liveDoc = await FirebaseFirestore.instance
          .collection('matches')
          .doc(freshMatch.liveMatchId)
          .get();

      if (liveDoc.exists && liveDoc.data()?['status'] == 'Completed') {
        // Edge case recovery: live match is done, but bracket isn't.
        Get.snackbar("Notice", "Match already completed.");
        return;
      }

      final badmintonController = Get.put(BadmintonController());
      badmintonController.resumeTournamentMatch(
        tId: widget.tournamentId,
        bMatchId: freshMatch.id,
        matchId: freshMatch.liveMatchId!
      );
    } else if (freshMatch.status == 'unscheduled' || freshMatch.status == 'scheduled') {
      final currentUser = FirebaseAuth.instance.currentUser?.uid;
      final isReferee = freshMatch.referee != null && freshMatch.referee!['userId'] == currentUser && freshMatch.referee!['status'] == 'accepted';

      if (widget.isOrganizer || isReferee) {
        Get.to(() => MatchTeamConfirmationScreen(
          tournamentId: widget.tournamentId,
          matchId: freshMatch.id,
          teamAId: freshMatch.teamAId!,
          teamBId: freshMatch.teamBId!,
        ));
      }
    } else if (freshMatch.status == 'completed') {
      Get.snackbar("Notice", "Match already completed.");
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

        // Group matches by round or group Name
        Map<String, List<BracketMatchModel>> grouped = {};
        for (var m in controller.matches) {
          String key = m.groupName ?? "Round ${m.round}";
          grouped.putIfAbsent(key, () => []).add(m);
        }

        final sortedKeys = grouped.keys.toList()..sort((a, b) {
          if (a.startsWith('Round') && b.startsWith('Round')) {
            int rA = int.parse(a.split(' ')[1]);
            int rB = int.parse(b.split(' ')[1]);
            return rA.compareTo(rB);
          }
          return a.compareTo(b);
        });

        return ListView.builder(
          padding: EdgeInsets.all(ResponsiveHelper.w(16)),
          itemCount: sortedKeys.length,
          itemBuilder: (context, index) {
            String key = sortedKeys[index];
            List<BracketMatchModel> matches = grouped[key]!;

            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: EdgeInsets.symmetric(vertical: ResponsiveHelper.h(12)),
                  child: Text(
                    key,
                    style: AppTypography.bodyLg.copyWith(color: AppColors.accent, fontWeight: FontWeight.bold),
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
        );
      }),
    );
  }
}
