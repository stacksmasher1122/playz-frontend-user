import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:redesign/theme/app_colors.dart';
import 'package:redesign/model/User_Models/Home_Models/Scoreboard_Model/Pickleball/pickleball_statistics_model.dart';
import 'package:redesign/controller/User_Controller/Home_Controller/Scoreboard_Controller/Pickleball/live_pickleball_match_controller.dart';

class PickleballStatsController extends GetxController {
  RxBool isLoading = false.obs;
  RxInt teamAScore = 2.obs;
  RxInt teamBScore = 1.obs;
  RxString selectedGame = "G3".obs;
  RxDouble serveAccuracy = 0.62.obs;
  RxDouble returnAccuracy = 0.71.obs;
  RxDouble winProbability = 0.68.obs;

  RxList<Map<String, dynamic>> gameStatistics = <Map<String, dynamic>>[].obs;
  RxList<Map<String, dynamic>> playerStatistics = <Map<String, dynamic>>[].obs;
  RxList<double> momentumData = <double>[].obs;
  RxList<Map<String, dynamic>> timelineData = <Map<String, dynamic>>[].obs;
  RxList<List<double>> heatMapData = <List<double>>[].obs;

  late Rx<PickleballStatisticsModel> statsModel;

  @override
  void onInit() {
    super.onInit();
    loadMatchStatistics();
  }

  void loadMatchStatistics() {
    LivePickleballMatchController? liveController;
    try {
      liveController = Get.find<LivePickleballMatchController>();
    } catch (_) {}

    momentumData.assignAll([
      0.5,
      0.8,
      -0.3,
      -0.6,
      0.4,
      0.9,
      0.2,
      -0.5,
      -0.8,
      -0.2,
      0.6,
      1.0,
      0.3,
      -0.4,
      -0.7,
      0.5,
      0.8,
      0.1,
      -0.3,
      0.7,
    ]);

    if (liveController != null && liveController.timeline.isNotEmpty) {
      timelineData.assignAll(
        liveController.timeline.reversed
            .take(15)
            .map(
              (e) => {
                "type": e.eventType ?? "Event",
                "desc": e.description,
                "game":
                    "${e.timestamp.hour.toString().padLeft(2, '0')}:${e.timestamp.minute.toString().padLeft(2, '0')}",
              },
            )
            .toList(),
      );
    } else {
      timelineData.assignAll([
        {"type": "Match", "desc": "Match Started", "game": "00:00"},
      ]);
    }

    int scoreA = liveController?.teamAScore.value ?? 82;
    int scoreB = liveController?.teamBScore.value ?? 70;
    int totalPts = scoreA + scoreB;
    
    String finalWinner = (liveController?.teamASets.value ?? 0) > (liveController?.teamBSets.value ?? 0) ? "TEAM A" : "TEAM B";
    String finalLoser = finalWinner == "TEAM A" ? "TEAM B" : "TEAM A";

    statsModel = PickleballStatisticsModel(
      matchId: "PB-99021",
      winner: finalWinner,
      loser: finalLoser,
      games: [
        {"game": "Game 1", "score": "$scoreA-$scoreB", "duration": liveController?.matchDuration.value ?? "14 min", "winner": finalWinner},
      ],
      statistics: {
        "Total Points": {"A": scoreA, "B": scoreB, "Total": totalPts},
        "Service Pts Won": {"A": (scoreA * 0.6).round(), "B": (scoreB * 0.4).round(), "Avg": "62%"},
        "Side Outs": {"A": 20, "B": 22, "Total": 42},
        "Dink Accuracy": {"A": 0.78, "B": 0.65, "Avg": "71%"},
        "Kitchen Winners": {"A": 14, "B": 9, "Total": 23},
        "Third Shot Drops": {"A": 0.71, "B": 0.58, "Avg": "64%"},
        "Volley %": {"A": 0.64, "B": 0.55, "Avg": "59%"},
      },
      momentum: momentumData.toList(),
      errors: {
        "Unforced Errors": {"A": liveController?.unforcedErrorsA.value ?? 14, "B": liveController?.unforcedErrorsB.value ?? 19},
        "Forced Errors": {"A": 8, "B": 11},
        "Service Errors": {"A": 2, "B": 5},
        "Winners": {"A": 24, "B": 18},
      },
      timeline: timelineData.toList(),
      heatMapData: [],
      coachInsights: [
        "Improve cross-court returns.",
        "Reduce kitchen faults.",
        "Increase drop-shot frequency.",
        "Better third-shot accuracy.",
      ],
    ).obs;

    calculateWinner();
    calculateMatchAnalytics();
    calculateMomentum();
    calculateHeatMap();
    calculateErrors();
    loadPlayerComparison();
    loadCoachInsights();
  }

  void calculateWinner() {}
  void calculateMatchAnalytics() {}
  void calculateMomentum() {}
  void calculateHeatMap() {}
  void calculateErrors() {}
  void loadPlayerComparison() {}
  void loadCoachInsights() {}

  void refreshStatistics() {
    showSuccess("Statistics Refreshed");
  }

  void selectGame(String game) {
    selectedGame.value = game;
  }

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
