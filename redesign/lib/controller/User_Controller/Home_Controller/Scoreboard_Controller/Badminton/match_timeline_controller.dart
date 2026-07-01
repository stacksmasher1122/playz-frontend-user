import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../../../model/User_Models/Home_Models/Scoreboard_Model/Badminton/match_metric_model.dart';
import '../../../../../../model/User_Models/Home_Models/Scoreboard_Model/Badminton/match_achievement_model.dart';

class MatchTimelineController extends GetxController {
  final RxBool isLoading = false.obs;
  
  final RxString winnerName = 'VIKTOR AXELSEN'.obs;
  final RxString finalScore = '2 : 1'.obs;
  final RxInt longestRally = 42.obs;
  final RxInt duration = 74.obs;
  final RxList<String> gameScores = <String>['21-17', '18-21', '21-19'].obs;
  final RxBool isTournamentChampion = true.obs;

  final RxList<MatchAchievementModel> achievements = <MatchAchievementModel>[].obs;
  final Rx<MatchMetricModel?> metrics = Rx<MatchMetricModel?>(null);

  final RxBool isExporting = false.obs;
  final RxBool isGeneratingSummary = false.obs;

  void loadMatchResult() {
    // Already set defaults above to match mock
  }

  void loadWinner() {
    // Setting up the Player of the Match static mock data 
  }

  void loadAchievements() {
    achievements.value = [
      MatchAchievementModel(
        title: 'SMASHER',
        subtitle: 'Top speed: 412 km/h',
        icon: Icons.bolt,
        achievementType: 'smasher',
        badgeColor: Color(0xFFC6FF00), // Neon Yellow-Green
        description: 'Highest smash speed of the tournament',
      ),
      MatchAchievementModel(
        title: 'THE WALL',
        subtitle: '88% Defense Success',
        icon: Icons.security,
        achievementType: 'defense',
        badgeColor: Color(0xFFC6FF00),
        description: 'Impenetrable defense during rallies',
      ),
      MatchAchievementModel(
        title: 'TACTICIAN',
        subtitle: 'Zero unforced errors set 3',
        icon: Icons.psychology,
        achievementType: 'tactics',
        badgeColor: Color(0xFFC6FF00),
        description: 'Flawless execution under pressure',
      ),
    ];
  }

  void loadMetrics() {
    metrics.value = MatchMetricModel(
      matchDuration: 74,
      longestRally: 42,
      totalSmashes: 45,
      fastestSmash: 412,
      averageRally: 14,
      intensity: 'ABOVE AVERAGE INTENSITY',
    );
  }

  Future<void> generateAISummary() async {
    isGeneratingSummary.value = true;
    await Future.delayed(Duration(seconds: 2));
    isGeneratingSummary.value = false;
    showSuccess("AI Summary Generated Successfully");
  }

  void shareQRCode() {
    showSuccess("QR Code Shared Successfully");
  }

  Future<void> exportPDF() async {
    isExporting.value = true;
    await Future.delayed(Duration(seconds: 2));
    isExporting.value = false;
    showSuccess("Match Result Exported as PDF Successfully");
  }

  void refreshTimeline() {
    isLoading.value = true;
    loadMatchResult();
    loadWinner();
    loadAchievements();
    loadMetrics();
    isLoading.value = false;
  }

  void syncMatchResult() {
    // Placeholder for live sync end match logic
  }

  void calculateWinner() {
    // Derive winner based on gamesWon
  }

  void calculateStatistics() {
    // Derive intensity label
  }

  void showSuccess(String message) {
    Get.snackbar(
      '',
      message,
      titleText: SizedBox.shrink(),
      messageText: Text(
        message,
        style: TextStyle(color: Colors.black, fontSize: 16, fontWeight: FontWeight.bold),
      ),
      backgroundColor: Color(0xFFC6FF00), // Neon Yellow-Green
      colorText: Colors.black,
      snackPosition: SnackPosition.BOTTOM,
      margin: EdgeInsets.all(16),
    );
  }

  void showError(String message) {
    Get.snackbar(
      '',
      message,
      titleText: SizedBox.shrink(),
      messageText: Text(
        message,
        style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold),
      ),
      backgroundColor: Colors.red.shade900,
      snackPosition: SnackPosition.BOTTOM,
      margin: EdgeInsets.all(16),
    );
  }
}
