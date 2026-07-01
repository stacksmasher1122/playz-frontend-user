import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../../../model/User_Models/Home_Models/Scoreboard_Model/Badminton/performance_metric_model.dart';
import '../../../../../../model/User_Models/Home_Models/Scoreboard_Model/Badminton/timeline_model.dart';

class MatchStatsController extends GetxController {
  final RxBool isLoading = false.obs;

  final RxInt totalPoints = 0.obs;
  final RxInt longestRally = 0.obs;
  final RxDouble servicePercentage = 0.0.obs;
  final RxDouble dominance = 0.0.obs;

  final RxList<PerformanceMetricModel> performanceMetrics = <PerformanceMetricModel>[].obs;
  final RxList<TimelineModel> timeline = <TimelineModel>[].obs;
  final RxList<double> chartPoints = <double>[].obs; // Normalized 0-1 for line chart

  void loadStatistics() {
    isLoading.value = true;
    // Mock quick stats
    totalPoints.value = 84;
    longestRally.value = 34;
    servicePercentage.value = 0.68;
    calculateDominance();
    isLoading.value = false;
  }

  void loadPerformanceMetrics() {
    performanceMetrics.value = [
      PerformanceMetricModel(
        speed: 0.85,
        power: 0.90,
        netPlay: 0.75,
        tactics: 0.80,
        defense: 0.70,
        playerOneWinners: 24,
        playerTwoWinners: 18,
        playerOneSmashes: 15,
        playerTwoSmashes: 12,
        playerOneNetWinners: 9,
        playerTwoNetWinners: 6,
        playerOneUnforcedErrors: 4,
        playerTwoUnforcedErrors: 11,
      )
    ];
  }

  void loadTimeline() {
    timeline.value = [
      TimelineModel(
        gameNumber: 1,
        playerOneScore: 21,
        playerTwoScore: 16,
        duration: '12:15 MINS',
        momentumBars: [0.2, 0.3, 0.5, 0.4, 0.8, 1.0, 0.9, 0.4, 0.3, 0.2, 0.4, 0.5, 0.8, 0.9, 1.0], // peak momentum moment
        description: '+4 RUN @18-14',
        winner: 'AXELSEN',
      ),
      TimelineModel(
        gameNumber: 2,
        playerOneScore: 21,
        playerTwoScore: 19,
        duration: '18:40 MINS',
        momentumBars: [0.3, 0.2, 0.4, 0.5, 0.6, 0.5, 0.7, 0.8, 0.9, 0.8, 0.7, 0.9, 1.0, 0.9, 1.0], // upward trending
        description: 'TIGHT FINISH',
        winner: 'AXELSEN',
      ),
    ];
  }

  void loadPointDistribution() {
    // Mock array of point distribution (jagged rising line)
    chartPoints.value = [
      0.0, 0.1, 0.15, 0.25, 0.35, 0.4, 0.45, 0.55, 0.6, 0.65, 0.75, 0.85, 0.9, 1.0
    ];
  }

  void calculateDominance() {
    dominance.value = 0.14; // "Viktor leads tactical control by 14%"
  }

  void calculateServicePoints() {
    servicePercentage.value = 0.68;
  }

  void calculateMomentum() {
    // In actual implementation, calculates momentum per game
  }

  void refreshStatistics() {
    loadStatistics();
    loadPerformanceMetrics();
    loadTimeline();
    loadPointDistribution();
    showSuccess("Statistics Updated Successfully");
  }

  void refreshCharts() {
    // Could trigger re-animation here if needed by resetting observables
  }

  void syncLiveData() {
    // Placeholder for future live polling
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
