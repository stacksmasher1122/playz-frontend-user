import 'dart:async';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../../../model/User_Models/Home_Models/Scoreboard_Model/Badminton/live_match_model.dart';
import '../../../../../../model/User_Models/Home_Models/Scoreboard_Model/Badminton/point_history_model.dart';
// Note: Normally we'd import AppColors etc. We'll use placeholder colors for GetX Snackbars.

class LiveMatchController extends GetxController {
  final RxBool isLoading = false.obs;
  final RxBool isPaused = false.obs;
  
  final RxInt playerOneScore = 18.obs;
  final RxInt playerTwoScore = 16.obs;
  final RxInt currentGame = 3.obs;
  final RxInt totalGames = 3.obs;
  
  final RxString matchDuration = "42:18".obs;
  final RxString momentum = "+12%".obs;
  final RxString serviceSide = "RIGHT COURT".obs;
  final RxString serverPlayer = "AXELSEN".obs;
  
  final RxList<PointHistoryModel> pointHistory = <PointHistoryModel>[].obs;
  final RxInt selectedTabIndex = 0.obs;

  Timer? _timer;
  int _secondsElapsed = 2538; // 42 minutes * 60 + 18 seconds

  void loadMatch() {
    isLoading.value = true;
    
    // Static mock data points
    pointHistory.value = [
      const PointHistoryModel(pointNumber: 33, playerName: 'Axelsen', score: '18 - 16', pointType: 'SMASH', time: '14:23', description: 'Cross court smash'),
      const PointHistoryModel(pointNumber: 32, playerName: 'Axelsen', score: '17 - 16', pointType: 'NET', time: '14:22', description: 'Net kill'),
      const PointHistoryModel(pointNumber: 31, playerName: 'Axelsen', score: '17 - 15', pointType: 'DRIVE', time: '14:20', description: 'Fast drive'),
      const PointHistoryModel(pointNumber: 30, playerName: 'Ginting', score: '16 - 15', pointType: 'OUT', time: '14:18', description: 'Wide clear'),
    ];
    
    isLoading.value = false;
  }

  void startTimer() {
    _timer?.cancel();
    if (!isPaused.value) {
      _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
        _secondsElapsed++;
        _updateMatchDurationString();
      });
    }
  }

  void _updateMatchDurationString() {
    int minutes = _secondsElapsed ~/ 60;
    int seconds = _secondsElapsed % 60;
    matchDuration.value = '${minutes.toString().padLeft(2, '0')}:${seconds.toString().padLeft(2, '0')}';
  }

  void pauseMatch() {
    isPaused.value = true;
    _timer?.cancel();
    showSuccess("Match Paused");
  }

  void resumeMatch() {
    isPaused.value = false;
    startTimer();
    showSuccess("Match Resumed");
  }

  void endMatch(BuildContext context) {
    showSuccess("Match Finished");
    Navigator.pop(context);
  }

  void undoPoint() {
    if (pointHistory.isNotEmpty) {
      final lastPoint = pointHistory.removeAt(0);
      if (lastPoint.playerName == 'Axelsen' && playerOneScore.value > 0) {
        playerOneScore.value--;
      } else if (lastPoint.playerName == 'Ginting' && playerTwoScore.value > 0) {
        playerTwoScore.value--;
      }
      changeService(); // revert service side just as an example mock
    }
  }

  void addPointToPlayerOne() {
    playerOneScore.value++;
    addPointHistory('Axelsen', '${playerOneScore.value} - ${playerTwoScore.value}');
    updateMomentum();
    changeService();
    calculateWinner();
  }

  void addPointToPlayerTwo() {
    playerTwoScore.value++;
    addPointHistory('Ginting', '${playerOneScore.value} - ${playerTwoScore.value}');
    updateMomentum();
    changeService();
    calculateWinner();
  }

  void updateMomentum() {
    // mock momentum logic
    momentum.value = "+${(10 + (playerOneScore.value - playerTwoScore.value) * 2)}%";
  }

  void changeService() {
    serviceSide.value = serviceSide.value == "RIGHT COURT" ? "LEFT COURT" : "RIGHT COURT";
    // Mock server changes on odd/even points logic
    final totalPoints = playerOneScore.value + playerTwoScore.value;
    if (totalPoints % 2 == 0) {
      serverPlayer.value = "AXELSEN";
    } else {
      serverPlayer.value = "GINTING";
    }
  }

  void addPointHistory(String playerName, String scoreString) {
    pointHistory.insert(
      0,
      PointHistoryModel(
        pointNumber: pointHistory.length + 30, // mock sequence
        playerName: playerName,
        score: scoreString,
        pointType: ['SMASH', 'NET', 'DRIVE', 'DROP', 'OUT'][(DateTime.now().millisecondsSinceEpoch % 5).toInt()],
        time: matchDuration.value,
        description: 'Mock point description',
      ),
    );
  }

  void calculateWinner() {
    if (playerOneScore.value >= 21 || playerTwoScore.value >= 21) {
      finishGame();
    }
  }

  void finishGame() {
    if (currentGame.value < totalGames.value) {
      currentGame.value++;
      playerOneScore.value = 0;
      playerTwoScore.value = 0;
      showSuccess("Game Finished. Starting Game ${currentGame.value}");
    } else {
      finishMatch();
    }
  }

  void finishMatch() {
    _timer?.cancel();
    showSuccess("Match Complete!");
  }

  void selectTab(int index) {
    selectedTabIndex.value = index;
  }

  void showSuccess(String message) {
    Get.snackbar(
      '',
      message,
      titleText: const SizedBox.shrink(),
      messageText: Text(
        message,
        style: const TextStyle(color: Colors.black, fontSize: 16, fontWeight: FontWeight.bold),
      ),
      backgroundColor: const Color(0xFFC6FF00), // Neon Yellow-Green
      colorText: Colors.black,
      snackPosition: SnackPosition.BOTTOM,
      margin: const EdgeInsets.all(16),
    );
  }

  void showError(String message) {
    Get.snackbar(
      '',
      message,
      titleText: const SizedBox.shrink(),
      messageText: Text(
        message,
        style: const TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold),
      ),
      backgroundColor: Colors.red.shade900,
      snackPosition: SnackPosition.BOTTOM,
      margin: const EdgeInsets.all(16),
    );
  }

  @override
  void onClose() {
    _timer?.cancel();
    super.onClose();
  }
}
