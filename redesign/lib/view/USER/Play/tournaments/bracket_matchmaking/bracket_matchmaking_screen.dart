import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:redesign/theme/app_colors.dart';
import 'package:redesign/theme/app_typography.dart';
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
  late PageController _pageController;
  int _selectedRoundIndex = 0;

  @override
  void initState() {
    super.initState();
    _pageController = PageController(initialPage: 0);

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

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  String _getTeamName(String? id) {
    if (id == null) return "BYE";
    final team = controller.teams.firstWhereOrNull((t) => t.id == id);

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

  String _getRoundDisplayLabel(String key, int index, int totalRounds, int matchCount) {
    if (!key.startsWith('Round')) {
      return key;
    }

    if (totalRounds >= 4) {
      if (index == totalRounds - 1) return "Final";
      if (index == totalRounds - 2) return "Semi Final";
      if (index == totalRounds - 3) return "Quarter Final";
      if (index == totalRounds - 4) return "Round of 16";
    } else if (totalRounds == 3) {
      if (index == 2) return "Final";
      if (index == 1) return "Semi Final";
      if (index == 0) return "Quarter Final";
    } else if (totalRounds == 2) {
      if (index == 1) return "Final";
      if (index == 0) return "Semi Final";
    } else if (totalRounds == 1) {
      return "Final";
    }

    if (matchCount == 1) return "Final";
    if (matchCount == 2) return "Semi Final";
    if (matchCount == 4) return "Quarter Final";
    if (matchCount == 8) return "Round of 16";

    return "Round ${index + 1}";
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

    if (!mounted) return;

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
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(context.minDimensionPct(3)),
            ),
            title: Row(
              children: [
                const Icon(Icons.lock_clock_rounded, color: AppColors.warning, size: 24),
                SizedBox(width: context.widthPct(2)),
                Expanded(
                  child: Text(
                    "Tournament Not Started",
                    style: AppTypography.headlineSm.copyWith(
                      color: AppColors.textPrimary,
                      fontSize: context.responsiveFont(16),
                      fontWeight: FontWeight.bold,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
            content: Text(
              widget.isOrganizer
                  ? "You must click 'Start Tournament' before matches can be started."
                  : "The tournament organizer has not started the tournament yet. Please wait for the organizer to start it.",
              style: AppTypography.bodySm.copyWith(
                color: AppColors.muted,
                fontSize: context.responsiveFont(13),
              ),
            ),
            actions: [
              TextButton(
                onPressed: () => Get.back(),
                child: Text(
                  "OK",
                  style: AppTypography.headlineSm.copyWith(
                    color: AppColors.accent,
                    fontWeight: FontWeight.bold,
                    fontSize: context.responsiveFont(14),
                  ),
                ),
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
        Get.snackbar(
          "Notice",
          "This match has not started yet.",
          backgroundColor: AppColors.card,
          colorText: AppColors.textPrimary,
        );
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
    ResponsiveHelper.init(context);

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.surface,
        elevation: 0,
        centerTitle: true,
        title: Text(
          "Bracket & Matchmaking",
          style: AppTypography.headlineSm.copyWith(
            color: AppColors.textPrimary,
            fontSize: context.responsiveFont(18),
            fontWeight: FontWeight.bold,
          ),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded, color: AppColors.textPrimary, size: 20),
          onPressed: () => Get.back(),
        ),
      ),
      body: Obx(() {
        if (controller.isLoading.value) {
          return const Center(child: CircularProgressIndicator(color: AppColors.accent));
        }

        if (controller.matches.isEmpty) {
          return Center(
            child: Text(
              "No bracket available.",
              style: AppTypography.bodyMd.copyWith(
                color: AppColors.muted,
                fontSize: context.responsiveFont(14),
              ),
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
                return m.status == 'completed' ||
                    (m.teamAId != null && m.teamBId == null) ||
                    (m.teamAId == null && m.teamBId != null) ||
                    (m.teamAId != null && m.teamBId != null);
              }).where((m) {
                if (m.status == 'unscheduled' && (m.teamAId == null || m.teamBId == null)) {
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

        // Determine final round key
        String? finalRoundKey;
        if (sortedKeys.isNotEmpty) {
          final lastKey = sortedKeys.last;
          if (lastKey.startsWith('Round') && grouped[lastKey]!.length == 1) {
            finalRoundKey = lastKey;
          }
        }

        // Find the tournament champion
        String? championName;
        if (allMatchesCompleted && finalRoundKey != null) {
          final finalMatch = grouped[finalRoundKey]!.first;
          if (finalMatch.winnerId != null) {
            championName = _getTeamName(finalMatch.winnerId);
          }
        }

        final bool showStartBanner = !controller.isTournamentStarted && !allMatchesCompleted;

        // Ensure current page index is valid
        if (_selectedRoundIndex >= sortedKeys.length) {
          _selectedRoundIndex = (sortedKeys.length - 1).clamp(0, 99);
        }

        return Column(
          children: [
            // Start Tournament Banner for Organizer
            if (showStartBanner)
              Container(
                margin: EdgeInsets.all(context.widthPct(4)),
                padding: EdgeInsets.all(context.widthPct(3.5)),
                decoration: BoxDecoration(
                  color: AppColors.warning.withValues(alpha: 0.12),
                  borderRadius: BorderRadius.circular(context.minDimensionPct(3)),
                  border: Border.all(color: AppColors.warning.withValues(alpha: 0.4)),
                ),
                child: Column(
                  children: [
                    Row(
                      children: [
                        const Icon(Icons.info_outline_rounded, color: AppColors.warning, size: 22),
                        SizedBox(width: context.widthPct(2.5)),
                        Expanded(
                          child: Text(
                            widget.isOrganizer
                                ? "Tournament has not started yet. Click 'Start Tournament' to open match scoring for referees."
                                : "Tournament has not started yet. Matches will become active once the organizer starts the tournament.",
                            style: AppTypography.bodySm.copyWith(
                              color: AppColors.textPrimary,
                              fontSize: context.responsiveFont(12),
                            ),
                          ),
                        ),
                      ],
                    ),
                    if (widget.isOrganizer) ...[
                      SizedBox(height: context.heightPct(1.5)),
                      Row(
                        children: [
                          Expanded(
                            child: SizedBox(
                              height: context.heightPct(5).clamp(42.0, 50.0),
                              child: ElevatedButton.icon(
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: AppColors.accent,
                                  elevation: 0,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(context.minDimensionPct(2)),
                                  ),
                                ),
                                icon: const Icon(Icons.play_circle_fill_rounded, color: AppColors.background),
                                label: FittedBox(
                                  fit: BoxFit.scaleDown,
                                  child: Text(
                                    "START TOURNAMENT",
                                    style: AppTypography.headlineSm.copyWith(
                                      color: AppColors.background,
                                      fontWeight: FontWeight.bold,
                                      fontSize: context.responsiveFont(14),
                                    ),
                                  ),
                                ),
                                onPressed: () => controller.startTournament(context),
                              ),
                            ),
                          ),
                          SizedBox(width: context.widthPct(2)),
                          SizedBox(
                            height: context.heightPct(5).clamp(42.0, 50.0),
                            child: OutlinedButton.icon(
                              style: OutlinedButton.styleFrom(
                                side: const BorderSide(color: AppColors.accent, width: 1.2),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(context.minDimensionPct(2)),
                                ),
                              ),
                              icon: const Icon(Icons.shuffle_rounded, color: AppColors.accent, size: 18),
                              label: Text(
                                "Shuffle",
                                style: AppTypography.headlineSm.copyWith(
                                  color: AppColors.accent,
                                  fontWeight: FontWeight.bold,
                                  fontSize: context.responsiveFont(13),
                                ),
                              ),
                              onPressed: () => controller.shuffleBracket(),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ],
                ),
              ),

            // Tournament Complete Banner
            if (allMatchesCompleted)
              Container(
                margin: EdgeInsets.all(context.widthPct(4)),
                padding: EdgeInsets.all(context.widthPct(4)),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      AppColors.accent.withValues(alpha: 0.15),
                      AppColors.accent.withValues(alpha: 0.05),
                    ],
                  ),
                  borderRadius: BorderRadius.circular(context.minDimensionPct(3)),
                  border: Border.all(color: AppColors.accent.withValues(alpha: 0.5)),
                ),
                child: Column(
                  children: [
                    const Icon(Icons.emoji_events_rounded, color: AppColors.accent, size: 36),
                    SizedBox(height: context.heightPct(1)),
                    Text(
                      "Tournament Complete",
                      style: AppTypography.headlineSm.copyWith(
                        color: AppColors.accent,
                        fontSize: context.responsiveFont(16),
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    if (championName != null) ...[
                      SizedBox(height: context.heightPct(0.5)),
                      Text(
                        "Champion: $championName",
                        style: AppTypography.bodyLg.copyWith(
                          color: AppColors.textPrimary,
                          fontWeight: FontWeight.bold,
                          fontSize: context.responsiveFont(14),
                        ),
                      ),
                    ],
                    SizedBox(height: context.heightPct(1)),
                    Text(
                      "All ${realMatches.length} matches completed",
                      style: AppTypography.bodySm.copyWith(
                        color: AppColors.muted,
                        fontSize: context.responsiveFont(12),
                      ),
                    ),
                  ],
                ),
              ),

            // Horizontally Scrollable Round Selection Pills Bar (Reference UI style)
            if (sortedKeys.isNotEmpty)
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                physics: const BouncingScrollPhysics(),
                padding: EdgeInsets.symmetric(
                  horizontal: context.widthPct(4),
                  vertical: context.heightPct(1),
                ),
                child: Row(
                  children: List.generate(sortedKeys.length, (idx) {
                    final isSelected = idx == _selectedRoundIndex;
                    final key = sortedKeys[idx];
                    final matches = grouped[key]!;
                    final label = _getRoundDisplayLabel(key, idx, sortedKeys.length, matches.length);

                    return Padding(
                      padding: EdgeInsets.only(right: context.widthPct(2.5)),
                      child: Material(
                        color: Colors.transparent,
                        child: InkWell(
                          borderRadius: BorderRadius.circular(context.minDimensionPct(5)),
                          onTap: () {
                            setState(() => _selectedRoundIndex = idx);
                            if (_pageController.hasClients) {
                              _pageController.animateToPage(
                                idx,
                                duration: const Duration(milliseconds: 300),
                                curve: Curves.easeInOut,
                              );
                            }
                          },
                          child: AnimatedContainer(
                            duration: const Duration(milliseconds: 200),
                            padding: EdgeInsets.symmetric(
                              horizontal: context.widthPct(4),
                              vertical: context.heightPct(1.2),
                            ),
                            decoration: BoxDecoration(
                              color: isSelected ? AppColors.accent : AppColors.surface,
                              borderRadius: BorderRadius.circular(context.minDimensionPct(5)),
                              border: Border.all(
                                color: isSelected ? AppColors.accent : AppColors.borderDark,
                                width: 1.2,
                              ),
                              boxShadow: isSelected ? [
                                BoxShadow(
                                  color: AppColors.accent.withValues(alpha: 0.3),
                                  blurRadius: 8,
                                  offset: const Offset(0, 2),
                                ),
                              ] : [],
                            ),
                            child: Text(
                              label,
                              style: AppTypography.headlineSm.copyWith(
                                color: isSelected ? AppColors.background : AppColors.textPrimary,
                                fontWeight: isSelected ? FontWeight.bold : FontWeight.w600,
                                fontSize: context.responsiveFont(13),
                              ),
                            ),
                          ),
                        ),
                      ),
                    );
                  }),
                ),
              ),

            SizedBox(height: context.heightPct(1)),

            // Round-by-Round Sliding PageView
            Expanded(
              child: PageView.builder(
                controller: _pageController,
                onPageChanged: (pageIndex) {
                  setState(() {
                    _selectedRoundIndex = pageIndex;
                  });
                },
                itemCount: sortedKeys.length,
                itemBuilder: (context, roundIndex) {
                  final key = sortedKeys[roundIndex];
                  final matches = grouped[key]!;
                  final displayLabel = _getRoundDisplayLabel(key, roundIndex, sortedKeys.length, matches.length);

                  final completedInRound = matches.where((m) => m.status == 'completed').length;
                  final totalInRound = matches.where((m) => m.teamAId != null && m.teamBId != null).length;

                  return ListView(
                    physics: const BouncingScrollPhysics(),
                    padding: EdgeInsets.symmetric(horizontal: context.widthPct(4)),
                    children: [
                      Padding(
                        padding: EdgeInsets.symmetric(vertical: context.heightPct(1)),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              displayLabel,
                              style: AppTypography.headlineSm.copyWith(
                                color: AppColors.accent,
                                fontWeight: FontWeight.bold,
                                fontSize: context.responsiveFont(15),
                              ),
                            ),
                            if (totalInRound > 0)
                              Text(
                                "$completedInRound/$totalInRound played",
                                style: AppTypography.bodySm.copyWith(
                                  color: AppColors.muted,
                                  fontSize: context.responsiveFont(12),
                                  fontWeight: FontWeight.w500,
                                ),
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
