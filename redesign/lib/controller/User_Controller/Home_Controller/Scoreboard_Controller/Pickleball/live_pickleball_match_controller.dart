import 'dart:async';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:redesign/theme/app_colors.dart';
import 'package:redesign/view/USER/Home/Scoreboard/Pickleball/match_result/match_result_screen.dart';
import 'package:redesign/view/USER/Home/Scoreboard/Pickleball/statistics/pickleball_stats_screen.dart';

class LivePickleballMatchController extends GetxController {
  RxInt teamAScore = 8.obs;
  RxInt teamBScore = 6.obs;
  RxInt teamASets = 1.obs;
  RxInt teamBSets = 0.obs;
  RxBool isPaused = false.obs;
  RxBool isServingTeamA = true.obs;
  RxString matchStatus = "LIVE".obs;
  RxString currentServer = "TEAM A".obs;
  RxString currentGame = "GAME 1".obs;
  RxString currentSet = "SET 1".obs;
  RxDouble winPercentageA = 0.64.obs;
  RxDouble winPercentageB = 0.36.obs;
  RxInt rallyLength = 0.obs;
  RxInt longestRally = 12.obs;
  RxBool isLoading = false.obs;
  RxInt selectedTabIndex = 0.obs;
  RxString matchDuration = "00:00".obs;
  RxInt unforcedErrorsA = 4.obs;
  RxInt unforcedErrorsB = 7.obs;
  RxDouble serveAccuracyA = 0.78.obs;
  RxDouble serveAccuracyB = 0.65.obs;
  RxInt rallyLengthAvg = 7.obs;

  Timer? _timer;
  int _seconds = 0;

  void initialize() {
    startTimer();
    loadLiveStats();
  }

  void startTimer() {
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (!isPaused.value) {
        _seconds++;
        int m = _seconds ~/ 60;
        int s = _seconds % 60;
        matchDuration.value = '${m.toString().padLeft(2, '0')}:${s.toString().padLeft(2, '0')}';
      }
    });
  }

  @override
  void onClose() {
    _timer?.cancel();
    super.onClose();
  }

  void increaseTeamAScore() {
    teamAScore.value++;
    updateServingTeam();
    updateStats();
  }

  void increaseTeamBScore() {
    teamBScore.value++;
    updateServingTeam();
    updateStats();
  }

  void undoPoint() {
    if (teamAScore.value > 0 || teamBScore.value > 0) {
      if (isServingTeamA.value && teamAScore.value > 0) {
        teamAScore.value--;
      } else if (!isServingTeamA.value && teamBScore.value > 0) {
        teamBScore.value--;
      } else {
        if (teamAScore.value > 0) teamAScore.value--;
      }
      showSuccess("Point Undone");
    }
  }

  void pauseMatch() {
    isPaused.value = true;
    showSuccess("Match Paused");
  }

  void resumeMatch() {
    isPaused.value = false;
    showSuccess("Match Resumed");
  }

  void startTimeout() {
    showSuccess("Timeout Called (60s)");
  }

  void endMatch(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: AppColors.surfaceContainerHigh,
        title: const Text("End Match?", style: TextStyle(color: AppColors.primary)),
        content: const Text("Are you sure you want to finish this match?", style: TextStyle(color: AppColors.muted)),
        actions: [
          OutlinedButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("Cancel", style: TextStyle(color: AppColors.primary)),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: AppColors.error),
            onPressed: () {
              Navigator.pop(context); // Close dialog
              finishMatch();
              Navigator.push(context, MaterialPageRoute(builder: (_) => const MatchResultScreen()));
            },
            child: const Text("End Match", style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }

  void finishGame() {
    teamASets.value++;
    teamAScore.value = 0;
    teamBScore.value = 0;
  }

  void finishSet() {
    // Check match winner
  }

  void finishMatch() {
    showSuccess("Match Finished");
  }

  void updateServingTeam() {
    // Simple mock logic: alternate serve
    isServingTeamA.value = !isServingTeamA.value;
    currentServer.value = isServingTeamA.value ? "TEAM A" : "TEAM B";
  }

  void updateStats() {
    // Mock stat update
  }

  void loadLiveStats() {
    winPercentageA.value = 0.64;
    winPercentageB.value = 0.36;
    unforcedErrorsA.value = 4;
    unforcedErrorsB.value = 7;
  }

  void selectTab(int index) {
    selectedTabIndex.value = index;
    if (index == 1) goToStats();
    if (index == 2) goToPlayers();
    if (index == 3) goToSettings();
  }

  void goToStats() {
    Navigator.push(Get.context!, MaterialPageRoute(builder: (_) => const PickleballStatsScreen()));
  }
  void goToPlayers() => showSuccess("Navigating to Players");
  void goToSettings() => showSuccess("Navigating to Settings");

  void showSuccess(String msg) {
    Get.snackbar("Success", msg, backgroundColor: AppColors.success, colorText: Colors.black);
  }

  void showError(String msg) {
    Get.snackbar("Error", msg, backgroundColor: AppColors.error, colorText: AppColors.primary);
  }
}
