import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:redesign/theme/app_colors.dart';
import 'package:redesign/model/User_Models/Home_Models/Scoreboard_Model/Pickleball/pickleball_statistics_model.dart';

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
    momentumData.value = [
      0.5, 0.8, -0.3, -0.6, 0.4, 0.9, 0.2, -0.5, -0.8, -0.2, 
      0.6, 1.0, 0.3, -0.4, -0.7, 0.5, 0.8, 0.1, -0.3, 0.7
    ];

    timelineData.value = [
      {"type": "Game Point", "desc": "Alpha scored 5 unanswered points after trailing 3-6", "game": "Game 1 Flashpoint"},
      {"type": "Turning Point", "desc": "Longest rally (24 hits) won by Omega, swinging energy.", "game": "Game 2 Turning Point"},
      {"type": "Closure", "desc": "Dominant service run by Smith closed the match.", "game": "Game 3 Closure"},
    ];

    statsModel = PickleballStatisticsModel(
      matchId: "PB-99021",
      winner: "TEAM ALPHA",
      loser: "TEAM OMEGA",
      games: [
        {"name": "G1", "scoreA": 11, "scoreB": 8},
        {"name": "G2", "scoreA": 9, "scoreB": 11},
        {"name": "G3", "scoreA": 11, "scoreB": 4},
      ],
      statistics: {
        "Total Points": {"A": 82, "B": 70, "Total": 152},
        "Service Pts Won": {"A": 48, "B": 22, "Avg": "62%"},
        "Side Outs": {"A": 20, "B": 22, "Total": 42},
        "Dink Accuracy": {"A": 0.78, "B": 0.65, "Avg": "71%"},
        "Kitchen Winners": {"A": 14, "B": 9, "Total": 23},
        "Third Shot Drops": {"A": 0.71, "B": 0.58, "Avg": "64%"},
        "Volley %": {"A": 0.64, "B": 0.55, "Avg": "59%"},
      },
      momentum: momentumData.value,
      errors: {
        "Unforced Errors": {"A": 14, "B": 19},
        "Forced Errors": {"A": 8, "B": 11},
        "Service Errors": {"A": 2, "B": 5},
        "Winners": {"A": 24, "B": 18},
      },
      timeline: timelineData.value,
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
    Get.snackbar("Success", msg, backgroundColor: AppColors.success, colorText: Colors.black);
  }

  void showError(String msg) {
    Get.snackbar("Error", msg, backgroundColor: AppColors.error, colorText: AppColors.accent);
  }
}
