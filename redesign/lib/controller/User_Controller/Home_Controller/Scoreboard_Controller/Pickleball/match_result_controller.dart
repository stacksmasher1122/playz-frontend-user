import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:redesign/theme/app_colors.dart';
import 'package:redesign/model/User_Models/Home_Models/Scoreboard_Model/Pickleball/match_result_model.dart';

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
    gameResults.value = [
      GameResult(game: "GAME 1", scoreA: 11, scoreB: 7, winner: "TEAM ALPHA"),
      GameResult(game: "GAME 2", scoreA: 9, scoreB: 11, winner: "TEAM OMEGA"),
      GameResult(game: "GAME 3", scoreA: 11, scoreB: 8, winner: "TEAM ALPHA"),
    ];

    topPlayers.value = [
      PlayerPerformance(name: "Alex Carter", image: "", pointsWon: 18, aces: 4, servePercent: 82, errors: 2, winners: 11, reactionTime: 0),
      PlayerPerformance(name: "Sam Rivera", image: "", pointsWon: 12, aces: 2, servePercent: 71, errors: 5, winners: 7, reactionTime: 0),
    ];

    matchResult = MatchResultModel(
      matchId: "PB-99021",
      winner: "TEAM ALPHA",
      runnerUp: "TEAM OMEGA",
      games: gameResults,
      duration: "54:22",
      mvpName: "Alpha Duo",
      mvpImage: "",
      mvpTeamName: "Alpha Duo",
      mvpWinRate: "92% Win Rate on Serve",
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
        "🏆 Longest Rally: 32 shots",
        "⚡ Fastest Serve: 98 km/h",
        "🎯 Best Accuracy: 94%",
        "🔥 6 Consecutive Points",
        "🛡 Best Defensive Rally"
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
    Get.snackbar("Success", msg, backgroundColor: AppColors.success, colorText: Colors.black);
  }

  void showError(String msg) {
    Get.snackbar("Error", msg, backgroundColor: AppColors.error, colorText: AppColors.accent);
  }
}
