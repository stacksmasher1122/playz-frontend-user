import 'dart:async';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:redesign/theme/app_colors.dart';
import 'package:redesign/model/User_Models/Home_Models/Scoreboard_Model/Volleyball/volleyball_review_model.dart';
import 'package:redesign/model/User_Models/Home_Models/Scoreboard_Model/Volleyball/volleyball_live_match_model.dart';

class VolleyballLiveScoringController extends GetxController {
  late VolleyballReviewModel initialData;

  // Rx State
  RxInt teamAScore = 0.obs;
  RxInt teamBScore = 0.obs;
  RxInt teamASets = 0.obs;
  RxInt teamBSets = 0.obs;
  RxInt currentSet = 1.obs;
  
  RxInt matchSeconds = 0.obs;
  RxBool isPaused = true.obs;
  RxBool isTeamAServing = true.obs;
  RxBool matchFinished = false.obs;

  RxList<VolleyballLiveMatchModel> undoStack = <VolleyballLiveMatchModel>[].obs;
  RxList<String> latestActions = <String>[].obs;
  
  Timer? _timer;

  @override
  void onClose() {
    _timer?.cancel();
    super.onClose();
  }

  void initializeMatch(VolleyballReviewModel data) {
    initialData = data;
    // By default team A serves first, or whatever coin toss dictates
    isTeamAServing.value = true;
    _saveStateToUndo("Match Started");
    startTimer();
  }

  void startTimer() {
    if (matchFinished.value) return;
    isPaused.value = false;
    _timer?.cancel();
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      matchSeconds.value++;
    });
  }

  void pauseMatch() {
    isPaused.value = true;
    _timer?.cancel();
    _saveStateToUndo("Match Paused");
  }

  void resumeMatch() {
    isPaused.value = false;
    startTimer();
    _saveStateToUndo("Match Resumed");
  }

  void addPointTeamA() {
    if (matchFinished.value || isPaused.value) {
      _showWarning();
      return;
    }
    
    _saveStateToUndo("Point awarded to ${initialData.teamA.teamName}");
    teamAScore.value++;
    isTeamAServing.value = true;
    _checkSetWinner();
  }

  void addPointTeamB() {
    if (matchFinished.value || isPaused.value) {
      _showWarning();
      return;
    }

    _saveStateToUndo("Point awarded to ${initialData.teamB.teamName}");
    teamBScore.value++;
    isTeamAServing.value = false;
    _checkSetWinner();
  }

  void _showWarning() {
    if (matchFinished.value) {
      Get.snackbar("Match Over", "The match has already concluded.", backgroundColor: AppColors.error, colorText: AppColors.primary);
    } else if (isPaused.value) {
      Get.snackbar("Match Paused", "Please resume the timer before scoring.", backgroundColor: AppColors.error, colorText: AppColors.primary);
    }
  }

  void undoLastPoint() {
    if (undoStack.isEmpty) {
      Get.snackbar("Undo", "No previous actions to undo.", backgroundColor: AppColors.surfaceContainerHigh, colorText: AppColors.primary);
      return;
    }

    final lastState = undoStack.removeLast();
    teamAScore.value = lastState.scoreA;
    teamBScore.value = lastState.scoreB;
    teamASets.value = lastState.setsWonA;
    teamBSets.value = lastState.setsWonB;
    currentSet.value = lastState.currentSet;
    isTeamAServing.value = lastState.isTeamAServing;
    
    // Timer can revert too, or we can leave it
    
    if (latestActions.isNotEmpty) {
      latestActions.removeAt(0); // Remove the top action
    }
    matchFinished.value = false;
  }

  void _checkSetWinner() {
    int target = (currentSet.value == _getTotalSets()) ? initialData.config.finalSetPoints : initialData.config.pointsPerSet;
    bool winByTwo = initialData.config.winByTwo;
    
    if (teamAScore.value >= target && (!winByTwo || teamAScore.value - teamBScore.value >= 2)) {
      _endSet(true);
    } else if (teamBScore.value >= target && (!winByTwo || teamBScore.value - teamAScore.value >= 2)) {
      _endSet(false);
    }
  }

  void _endSet(bool teamAWon) {
    _saveStateToUndo("Set ${currentSet.value} won by ${teamAWon ? initialData.teamA.teamName : initialData.teamB.teamName}");
    
    if (teamAWon) {
      teamASets.value++;
    } else {
      teamBSets.value++;
    }

    if (_checkMatchWinner()) return;

    // Reset for next set
    teamAScore.value = 0;
    teamBScore.value = 0;
    currentSet.value++;
    // Usually loser of previous set serves next, or alternates
    isTeamAServing.value = !teamAWon;
    
    pauseMatch(); // Automatically pause between sets
    Get.snackbar("Set Completed", "Proceeding to Set ${currentSet.value}", backgroundColor: AppColors.primaryContainer, colorText: Colors.black);
  }

  bool _checkMatchWinner() {
    int setsToWin = (_getTotalSets() / 2).ceil();
    if (teamASets.value >= setsToWin) {
      _endMatch(initialData.teamA.teamName);
      return true;
    } else if (teamBSets.value >= setsToWin) {
      _endMatch(initialData.teamB.teamName);
      return true;
    }
    return false;
  }

  void _endMatch(String winner) {
    matchFinished.value = true;
    pauseMatch();
    Get.snackbar("Match Complete", "$winner has won the match!", backgroundColor: AppColors.primaryContainer, colorText: Colors.black, duration: const Duration(seconds: 5));
    // Navigator.push(context, MaterialPageRoute(builder: (_) => VolleyballMatchSummaryScreen()));
  }

  int _getTotalSets() {
    return int.tryParse(initialData.config.format.split(" ").last) ?? 5;
  }

  void _saveStateToUndo(String action) {
    undoStack.add(VolleyballLiveMatchModel(
      config: initialData.config,
      teamA: initialData.teamA,
      teamB: initialData.teamB,
      scoreA: teamAScore.value,
      scoreB: teamBScore.value,
      setsWonA: teamASets.value,
      setsWonB: teamBSets.value,
      currentSet: currentSet.value,
      isTeamAServing: isTeamAServing.value,
      elapsedSeconds: matchSeconds.value,
      latestAction: action,
      timestamp: DateTime.now(),
    ));

    // Keep top 20 actions
    latestActions.insert(0, "${_formatTime(matchSeconds.value)} - $action");
    if (latestActions.length > 20) {
      latestActions.removeLast();
    }
  }

  String _formatTime(int seconds) {
    int h = seconds ~/ 3600;
    int m = (seconds % 3600) ~/ 60;
    int s = seconds % 60;
    if (h > 0) return '${h.toString().padLeft(2, '0')}:${m.toString().padLeft(2, '0')}:${s.toString().padLeft(2, '0')}';
    return '${m.toString().padLeft(2, '0')}:${s.toString().padLeft(2, '0')}';
  }
}
