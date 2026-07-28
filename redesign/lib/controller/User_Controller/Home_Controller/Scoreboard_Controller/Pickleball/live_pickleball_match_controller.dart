import 'dart:async';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:redesign/theme/app_colors.dart';
import 'package:redesign/view/USER/Home/Scoreboard/Pickleball/match_result/match_result_screen.dart';
import 'package:redesign/view/USER/Home/Scoreboard/Pickleball/statistics/pickleball_stats_screen.dart';
import 'package:uuid/uuid.dart';
import 'package:redesign/model/User_Models/Home_Models/Scoreboard_Model/Pickleball/pickleball_rule_engine.dart';
import 'package:redesign/model/User_Models/Home_Models/Scoreboard_Model/Pickleball/live_pickleball_match_model.dart';
import 'package:redesign/controller/User_Controller/Home_Controller/Scoreboard_Controller/Pickleball/pickleball_sync_service.dart';
import 'package:redesign/controller/User_Controller/Home_Controller/Scoreboard_Controller/Pickleball/pickleball_initialize_match_controller.dart';
import 'package:redesign/controller/User_Controller/Home_Controller/Scoreboard_Controller/Pickleball/pickleball_team_management_controller.dart';

class LivePickleballMatchController extends GetxController {
  final PickleballSyncService syncService = Get.put(PickleballSyncService());
  String matchId = const Uuid().v4();
  late final PickleballRuleProfile rules;

  RxInt teamAScore = 0.obs;
  RxInt teamBScore = 0.obs;
  RxInt teamASets = 0.obs;
  RxInt teamBSets = 0.obs;

  RxInt teamATimeoutsUsed = 0.obs;
  RxInt teamBTimeoutsUsed = 0.obs;

  RxInt teamAChallengesUsed = 0.obs;
  RxInt teamBChallengesUsed = 0.obs;

  RxBool isPaused = false.obs;
  RxBool isServingTeamA = true.obs;
  RxString matchStatus = "LIVE".obs;
  RxString currentServer = "TEAM A".obs;
  RxString currentServerName = "Server 1".obs;
  RxInt serverNumber = 1.obs; // 1 or 2 for doubles
  RxString servingCourt = "Right".obs; // Right or Left
  RxString currentGame = "GAME 1".obs;
  RxString currentSet = "SET 1".obs;

  RxString matchTitle = "FRIENDLY MATCH".obs;
  RxString courtInfo = "MAIN COURT".obs;
  RxString teamAName = "TEAM A".obs;
  RxString teamBName = "TEAM B".obs;

  RxDouble winPercentageA = 0.50.obs;
  RxDouble winPercentageB = 0.50.obs;
  RxInt rallyLength = 0.obs;
  RxInt longestRally = 0.obs;

  RxBool isLoading = false.obs;
  RxInt selectedTabIndex = 0.obs;
  RxString matchDuration = "00:00".obs;

  RxInt unforcedErrorsA = 0.obs;
  RxInt unforcedErrorsB = 0.obs;
  RxDouble serveAccuracyA = 1.0.obs;
  RxDouble serveAccuracyB = 1.0.obs;
  RxInt rallyLengthAvg = 0.obs;
  
  // Advanced Stats
  RxInt winnersA = 0.obs;
  RxInt winnersB = 0.obs;
  RxInt forcedErrorsA = 0.obs;
  RxInt forcedErrorsB = 0.obs;
  RxInt acesA = 0.obs;
  RxInt acesB = 0.obs;
  RxInt faultsA = 0.obs;
  RxInt faultsB = 0.obs;

  RxList<PickleballMatchEvent> timeline = <PickleballMatchEvent>[].obs;

  Timer? _timer;
  int _seconds = 0;

  @override
  void onInit() {
    super.onInit();
    try {
      final initController = Get.find<PickleballInitializeMatchController>();
      rules = initController.currentProfile.value;
      matchTitle.value = initController.selectedTournament.value.isNotEmpty 
          ? initController.selectedTournament.value 
          : "FRIENDLY MATCH";
      courtInfo.value = initController.selectedSurface.value.isNotEmpty 
          ? "COURT ${initController.selectedSurface.value}" 
          : "MAIN COURT";
    } catch (e) {
      rules = PickleballRuleProfile.localTournament;
    }

    try {
      final teamController = Get.find<PickleballTeamManagementController>();
      if (teamController.teamAPlayers.isNotEmpty) {
        teamAName.value = teamController.isSingles.value 
            ? teamController.teamAPlayers.first.name 
            : "${teamController.teamAPlayers.first.name} & Co";
      }
      if (teamController.teamBPlayers.isNotEmpty) {
        teamBName.value = teamController.isSingles.value 
            ? teamController.teamBPlayers.first.name 
            : "${teamController.teamBPlayers.first.name} & Co";
      }
    } catch (_) {}

    _logEvent("Match Started", "Match");
  }

  void initialize() {
    startTimer();
    // Save match state immediately on start to create the DB entries
    _persistMatchState();
  }

  void startTimer() {
    _timer = Timer.periodic(Duration(seconds: 1), (timer) {
      if (!isPaused.value) {
        _seconds++;
        int m = _seconds ~/ 60;
        int s = _seconds % 60;
        matchDuration.value =
            '${m.toString().padLeft(2, '0')}:${s.toString().padLeft(2, '0')}';
      }
    });
  }

  @override
  void onClose() {
    _timer?.cancel();
    super.onClose();
  }

  void _logEvent(
    String description,
    String type, [
    Map<String, dynamic>? meta,
  ]) {
    timeline.add(
      PickleballMatchEvent(
        timestamp: DateTime.now(),
        description: description,
        eventType: type,
        metadata: meta,
      ),
    );
  }

  void processPoint(String teamId, PointType type, {FaultType? fault}) {
    if (matchStatus.value == "COMPLETED") return;

    if (type == PointType.replay) {
      _logEvent("Point Replayed", "Replay", {"team": teamId});
      return;
    }

    bool isTeamA = teamId == teamAName.value;
    bool isServingTeam = isTeamA == isServingTeamA.value;

    // Log detailed point
    _logEvent(
      "${isTeamA ? teamAName.value : teamBName.value} scored via ${type.name}",
      "Point",
      {"type": type.name, "fault": fault?.name},
    );

    // Update Stats
    if (isTeamA) {
      if (type == PointType.rallyWinner || type == PointType.netCordWinner) winnersA.value++;
      if (type == PointType.ace) acesA.value++;
      if (type == PointType.forcedError) forcedErrorsB.value++; // Opponent forced error
      if (type == PointType.unforcedError) unforcedErrorsA.value++;
      if (type == PointType.opponentFault) faultsB.value++;
    } else {
      if (type == PointType.rallyWinner || type == PointType.netCordWinner) winnersB.value++;
      if (type == PointType.ace) acesB.value++;
      if (type == PointType.forcedError) forcedErrorsA.value++;
      if (type == PointType.unforcedError) unforcedErrorsB.value++;
      if (type == PointType.opponentFault) faultsA.value++;
    }

    // Rule Engine Core
    if (rules.scoringSystem == ScoringSystem.traditional) {
      if (isServingTeam) {
        // Serving team wins rally
        _awardPoint(isTeamA);
        // Switch serving court side
        servingCourt.value = servingCourt.value == "Right" ? "Left" : "Right";
      } else {
        // Receiving team wins rally - Side Out
        _handleSideOut(isTeamA);
      }
    } else {
      // Rally Scoring
      _awardPoint(isTeamA);
      if (!isServingTeam) {
        _handleSideOut(isTeamA);
      } else {
        servingCourt.value = servingCourt.value == "Right" ? "Left" : "Right";
      }
    }
    
    // Save match state to Database
    _persistMatchState();
  }

  void _awardPoint(bool isTeamA) {
    if (isTeamA) {
      teamAScore.value++;
    } else {
      teamBScore.value++;
    }
    checkGameWinner();
    
    // Auto Dialogs for Game/Match Point
    if (matchStatus.value != "COMPLETED") {
      _checkGameOrMatchPoint();
    }
  }

  void _checkGameOrMatchPoint() {
    int winPts = rules.winningPoints == WinningPoints.points11
        ? 11
        : rules.winningPoints == WinningPoints.points15
        ? 15
        : 21;

    int reqDiff = rules.winByRule == WinByRule.winBy2 ? 2 : 1;
    if (rules.winByRule == WinByRule.unlimited) reqDiff = 1;

    bool isGamePointA = teamAScore.value >= winPts - 1 && (teamAScore.value - teamBScore.value) >= reqDiff - 1;
    bool isGamePointB = teamBScore.value >= winPts - 1 && (teamBScore.value - teamAScore.value) >= reqDiff - 1;

    if (isGamePointA || isGamePointB) {
      bool isMatchPointA = isGamePointA && (teamASets.value == _getSetsToWin() - 1 || rules.matchFormat == PickleballMatchFormat.oneGame);
      bool isMatchPointB = isGamePointB && (teamBSets.value == _getSetsToWin() - 1 || rules.matchFormat == PickleballMatchFormat.oneGame);

      String title = (isMatchPointA || isMatchPointB) ? "MATCH POINT" : "GAME POINT";
      String team = isGamePointA ? teamAName.value : teamBName.value;
      if (isGamePointA && isGamePointB) team = "BOTH TEAMS"; // Tie-break scenario

      Get.snackbar(
        title,
        "$team is at $title!",
        backgroundColor: AppColors.accent,
        colorText: Colors.black,
        duration: Duration(seconds: 3),
        snackPosition: SnackPosition.TOP,
      );
    }
  }

  int _getSetsToWin() {
    if (rules.matchFormat == PickleballMatchFormat.bestOf3) return 2;
    if (rules.matchFormat == PickleballMatchFormat.bestOf5) return 3;
    return 1;
  }

  void _handleSideOut(bool winningTeamIsA) {
    // In Doubles, handle 2nd server logic
    if (rules.teamType != TeamType.singles) {
      // If it's the very first serve of the game, only 1 server gets to serve
      bool isFirstServeOfGame = teamAScore.value == 0 && teamBScore.value == 0 && serverNumber.value == 2;
      
      if (serverNumber.value == 1 && !isFirstServeOfGame) {
        // Move to Server 2
        serverNumber.value = 2;
        currentServerName.value = "Server 2";
        _logEvent("Second Server", "Serve");
      } else {
        // Side Out to other team
        _switchTeamServe(winningTeamIsA);
      }
    } else {
      // Singles always side out immediately
      _switchTeamServe(winningTeamIsA);
    }
  }

  void _switchTeamServe(bool newServingTeamIsA) {
    isServingTeamA.value = newServingTeamIsA;
    currentServer.value = newServingTeamIsA ? teamAName.value : teamBName.value;
    serverNumber.value = 1;
    currentServerName.value = "Server 1";
    
    // In Pickleball, side out starts on right or left depending on score
    int newTeamScore = newServingTeamIsA ? teamAScore.value : teamBScore.value;
    servingCourt.value = (newTeamScore % 2 == 0) ? "Right" : "Left";
    
    _logEvent("Side Out -> ${currentServer.value} Serves", "Serve");
    showSuccess("Side Out! ${currentServer.value} is now serving.");
  }

  void checkGameWinner() {
    int winPts = rules.winningPoints == WinningPoints.points11
        ? 11
        : rules.winningPoints == WinningPoints.points15
        ? 15
        : 21;

    int requiredDiff = rules.winByRule == WinByRule.winBy2 ? 2 : 1;
    if (rules.winByRule == WinByRule.unlimited) requiredDiff = 1;

    bool aWins =
        teamAScore.value >= winPts &&
        (teamAScore.value - teamBScore.value) >= requiredDiff;
    bool bWins =
        teamBScore.value >= winPts &&
        (teamBScore.value - teamAScore.value) >= requiredDiff;

    if (aWins) {
      teamASets.value++;
      _logEvent(
        "Team A won the Game ${teamASets.value + teamBSets.value}",
        "Game",
      );
      _handleGameEnd();
    } else if (bWins) {
      teamBSets.value++;
      _logEvent(
        "Team B won the Game ${teamASets.value + teamBSets.value}",
        "Game",
      );
      _handleGameEnd();
    }
  }

  void _handleGameEnd() {
    int setsToWin = rules.matchFormat == PickleballMatchFormat.oneGame
        ? 1
        : rules.matchFormat == PickleballMatchFormat.bestOf3
        ? 2
        : 3;

    if (teamASets.value == setsToWin || teamBSets.value == setsToWin) {
      matchStatus.value = "COMPLETED";
      isPaused.value = true;
      String winner = teamASets.value == setsToWin ? "TEAM A" : "TEAM B";
      _logEvent("$winner Wins Match", "Match");
      _persistMatchState();
      showSuccess("$winner WINS THE MATCH!");
      // Optionally auto-trigger end match dialog
    } else {
      teamAScore.value = 0;
      teamBScore.value = 0;
      int totalGames = teamASets.value + teamBSets.value + 1;
      currentGame.value = "GAME $totalGames";
      currentSet.value = "SET $totalGames";
      showSuccess("Game Finished. Starting ${currentGame.value}");
    }
  }

  void recordFault(FaultType fault) {
    _logEvent("Fault Recorded: ${fault.name}", "Fault");
    showError("Fault: ${fault.name}");
    // Typical fault results in loss of rally
    if (isServingTeamA.value) {
      processPoint(teamBName.value, PointType.opponentFault, fault: fault);
    } else {
      processPoint(teamAName.value, PointType.opponentFault, fault: fault);
    }
  }

  void callTimeout(bool isTeamA, TimeoutType type) {
    if (type == TimeoutType.standard) {
      if (isTeamA) {
        if (teamATimeoutsUsed.value >= rules.timeoutsPerTeam) {
          showError("Team A has no timeouts left.");
          return;
        }
        teamATimeoutsUsed.value++;
      } else {
        if (teamBTimeoutsUsed.value >= rules.timeoutsPerTeam) {
          showError("Team B has no timeouts left.");
          return;
        }
        teamBTimeoutsUsed.value++;
      }
    }

    isPaused.value = true;
    _logEvent(
      "${isTeamA ? 'Team A' : 'Team B'} Called Timeout (${type.name})",
      "Timeout",
    );
    showSuccess("Timeout Called: ${rules.timeoutDurationSeconds}s");
  }

  void startTimeout() {
    callTimeout(isServingTeamA.value, TimeoutType.standard);
  }

  void callChallenge(bool isTeamA) {
    if (!rules.challengeSystemEnabled) {
      showError("Challenges are disabled in this rule profile.");
      return;
    }

    if (isTeamA && teamAChallengesUsed.value >= rules.maxChallengesPerTeam) {
      showError("Team A has no challenges left.");
      return;
    } else if (!isTeamA &&
        teamBChallengesUsed.value >= rules.maxChallengesPerTeam) {
      showError("Team B has no challenges left.");
      return;
    }

    if (isTeamA)
      teamAChallengesUsed.value++;
    else
      teamBChallengesUsed.value++;

    _logEvent(
      "${isTeamA ? 'Team A' : 'Team B'} Challenged a Call",
      "Challenge",
    );
    showSuccess("Challenge Initiated!");
  }

  void undoPoint() {
    if (matchStatus.value == "COMPLETED") return;
    if (timeline.isEmpty) return;

    // A real undo would revert to previous state based on timeline history.
    // For now, simple fallback
    if (teamAScore.value > 0 || teamBScore.value > 0) {
      if (isServingTeamA.value && teamAScore.value > 0) {
        teamAScore.value--;
      } else if (!isServingTeamA.value && teamBScore.value > 0) {
        teamBScore.value--;
      } else {
        if (teamAScore.value > 0) teamAScore.value--;
      }
      _logEvent("Point Undone", "Undo");
      _persistMatchState();
      showSuccess("Point Undone");
    }
  }

  void loadMatch(LivePickleballMatchModel model) {
    matchId = model.matchId;
    teamAName.value = model.teamA;
    teamBName.value = model.teamB;
    teamAScore.value = model.scoreA;
    teamBScore.value = model.scoreB;
    teamASets.value = model.setsA;
    teamBSets.value = model.setsB;
    currentServer.value = model.server;
    currentGame.value = model.game;
    currentSet.value = model.set;
    servingCourt.value = model.court;
    matchStatus.value = model.status;
    matchDuration.value = model.duration;
    
    // Default fallback rules if not passed explicitly during resume
    rules = PickleballRuleProfile.localTournament;

    winnersA.value = model.statistics['winnersA'] ?? 0;
    winnersB.value = model.statistics['winnersB'] ?? 0;
    forcedErrorsA.value = model.statistics['forcedErrorsA'] ?? 0;
    forcedErrorsB.value = model.statistics['forcedErrorsB'] ?? 0;
    unforcedErrorsA.value = model.statistics['unforcedErrorsA'] ?? 0;
    unforcedErrorsB.value = model.statistics['unforcedErrorsB'] ?? 0;
    acesA.value = model.statistics['acesA'] ?? 0;
    acesB.value = model.statistics['acesB'] ?? 0;
    faultsA.value = model.statistics['faultsA'] ?? 0;
    faultsB.value = model.statistics['faultsB'] ?? 0;
    rallyLengthAvg.value = model.statistics['rallyLengthAvg'] ?? 0;
    longestRally.value = model.statistics['longestRally'] ?? 0;
  }

  void pauseMatch() {
    isPaused.value = true;
    _logEvent("Match Paused", "Match");
    showSuccess("Match Paused");
  }

  void resumeMatch() {
    isPaused.value = false;
    _logEvent("Match Resumed", "Match");
    showSuccess("Match Resumed");
  }

  void endMatch(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: AppColors.card,
        title: Text("End Match?", style: TextStyle(color: AppColors.accent)),
        content: Text(
          "Are you sure you want to finish this match?",
          style: TextStyle(color: AppColors.muted),
        ),
        actions: [
          OutlinedButton(
            onPressed: () => Navigator.pop(context),
            child: Text("Cancel", style: TextStyle(color: AppColors.accent)),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: AppColors.error),
            onPressed: () {
              Navigator.pop(context);
              finishMatch();
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => MatchResultScreen()),
              );
            },
            child: Text("End Match", style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }

  void finishMatch() {
    matchStatus.value = "COMPLETED";
    isPaused.value = true;
    _logEvent("Match Manually Ended", "Match");
    showSuccess("Match Finished");
  }

  void selectTab(int index) {
    selectedTabIndex.value = index;
    if (index == 1) goToStats();
    if (index == 2) goToPlayers();
    if (index == 3) goToSettings();
  }

  void goToStats() {
    Navigator.push(
      Get.context!,
      MaterialPageRoute(builder: (_) => PickleballStatsScreen()),
    );
  }

  void goToPlayers() => showSuccess("Navigating to Players");
  void goToSettings() => showSuccess("Navigating to Settings");

  void showSuccess(String msg) {
    Get.snackbar(
      "Success",
      msg,
      backgroundColor: AppColors.success,
      colorText: Colors.black,
    );
  }

  void showError(String msg) {
    Get.snackbar(
      "Error",
      msg,
      backgroundColor: AppColors.error,
      colorText: AppColors.accent,
    );
  }

  void _persistMatchState() {
    LivePickleballMatchModel model = LivePickleballMatchModel(
      matchId: matchId,
      teamA: teamAName.value,
      teamB: teamBName.value,
      scoreA: teamAScore.value,
      scoreB: teamBScore.value,
      setsA: teamASets.value,
      setsB: teamBSets.value,
      server: currentServer.value,
      game: currentGame.value,
      set: currentSet.value,
      court: servingCourt.value,
      status: matchStatus.value,
      duration: matchDuration.value,
      statistics: {
        'winnersA': winnersA.value,
        'winnersB': winnersB.value,
        'forcedErrorsA': forcedErrorsA.value,
        'forcedErrorsB': forcedErrorsB.value,
        'unforcedErrorsA': unforcedErrorsA.value,
        'unforcedErrorsB': unforcedErrorsB.value,
        'acesA': acesA.value,
        'acesB': acesB.value,
        'faultsA': faultsA.value,
        'faultsB': faultsB.value,
        'rallyLengthAvg': rallyLengthAvg.value,
        'longestRally': longestRally.value,
      },
    );
    syncService.saveMatch(model);
  }
}
