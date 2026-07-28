import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:redesign/theme/app_colors.dart';
import 'package:redesign/model/User_Models/Home_Models/Scoreboard_Model/Pickleball/match_result_model.dart';
import 'package:redesign/controller/User_Controller/Home_Controller/Scoreboard_Controller/Pickleball/live_pickleball_match_controller.dart';

class MatchResultController extends GetxController {
  RxBool isLoading = false.obs;
  RxString winnerName = "TEAM ALPHA".obs;
  RxString runnerUp = "TEAM OMEGA".obs;
  RxString matchDuration = "54:22".obs;
  RxString matchStatus = "SERIES FINISHED".obs;
  RxString matchId = "PB-99021".obs;
  RxInt winnerGames = 2.obs;
  RxInt runnerGames = 1.obs;
  RxInt longestRally = 32.obs;
  RxInt fastestServe = 98.obs;
  RxList<GameResult> gameResults = <GameResult>[].obs;
  RxList<PlayerPerformance> topPlayers = <PlayerPerformance>[].obs;

  late Rx<MatchResultModel> matchResult;

  @override
  void onInit() {
    super.onInit();
    loadMatchResult();
  }

  void loadMatchResult() {
    LivePickleballMatchController? liveController;
    try {
      liveController = Get.find<LivePickleballMatchController>();
    } catch (_) {}

    String aName = "TEAM A";
    String bName = "TEAM B";
    int aSets = liveController?.teamASets.value ?? 0;
    int bSets = liveController?.teamBSets.value ?? 0;
    String dur = liveController?.matchDuration.value ?? "00:00";
    
    String finalWinner = aSets > bSets ? aName : (bSets > aSets ? bName : aName);
    String finalLoser = aSets > bSets ? bName : (bSets > aSets ? aName : bName);

    winnerName.value = finalWinner;
    runnerUp.value = finalLoser;
    matchDuration.value = dur;
    winnerGames.value = aSets > bSets ? aSets : (bSets > aSets ? bSets : aSets);
    runnerGames.value = aSets > bSets ? bSets : (bSets > aSets ? aSets : bSets);

    List<GameResult> dynamicGameResults = [];
    if (liveController != null) {
      // Basic game inference from sets. In a robust app, we'd store each game's end score in timeline.
      int totalGames = aSets + bSets;
      for (int i = 0; i < totalGames; i++) {
        dynamicGameResults.add(GameResult(game: "GAME ${i+1}", scoreA: 11, scoreB: 8, winner: "N/A")); // Placeholder until game-by-game scores are tracked
      }
    }
    gameResults.value = dynamicGameResults.isEmpty ? [
      GameResult(game: "GAME 1", scoreA: 11, scoreB: 7, winner: finalWinner),
    ] : dynamicGameResults;

    topPlayers.value = [
      PlayerPerformance(name: "Player 1", image: "", pointsWon: liveController?.teamAScore.value ?? 0, aces: 0, servePercent: 80, errors: 0, winners: 0, reactionTime: 0),
    ];

    matchResult = MatchResultModel(
      matchId: "PB-99021",
      winner: finalWinner,
      runnerUp: finalLoser,
      games: gameResults,
      duration: dur,
      mvpName: finalWinner,
      mvpImage: "",
      mvpTeamName: finalWinner,
      mvpWinRate: "TBD",
      statistics: {},
      analytics: {
        "serveAccuracy": 0.82,
        "returnAccuracy": 0.71,
        "winPercent": 0.64,
        "forcedErrors": 6,
        "unforcedErrors": 4,
        "netWinners": 8,
        "avgRally": 7,
        "longestRally": 32,
      },
      players: topPlayers,
      achievements: [
        "🏆 Match Completed",
      ],
      tournament: "Championship Finals",
      court: "Court 1",
      referee: "John Smith",
      matchDate: "Today",
      matchTime: "3:30 PM",
      courtType: "Indoor",
    ).obs;
  }

  void calculateWinner() {}
  void calculateStatistics() {}

  void shareResult() {
    showSuccess("Share Coming Soon");
  }

  void returnDashboard(BuildContext context) {
    // Placeholder for returnDashboard
    showSuccess("Returning to Dashboard");
    Navigator.of(context).popUntil((route) => route.isFirst);
  }

  void generateMatchSummary() {}
  void exportPDF() {
    showSuccess("Export Coming Soon");
  }

  void saveHistory() {}

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
}
