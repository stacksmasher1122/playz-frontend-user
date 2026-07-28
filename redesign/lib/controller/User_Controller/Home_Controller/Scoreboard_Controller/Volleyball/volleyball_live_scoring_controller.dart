import 'dart:async';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:redesign/theme/app_colors.dart';
import 'package:redesign/theme/app_typography.dart';
import 'package:redesign/view/USER/Home/Scoreboard/Volleyball/stats/volleyball_stats_screen.dart';
import 'package:redesign/model/User_Models/Home_Models/Scoreboard_Model/Volleyball/volleyball_review_model.dart';
import 'package:redesign/model/User_Models/Home_Models/Scoreboard_Model/Volleyball/volleyball_live_match_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:redesign/sqflite/User_SQF/Home_SQF/Scoreboard_SQF/volleyballSqflite.dart';
import 'package:redesign/model/User_Models/Home_Models/Scoreboard_Model/Volleyball/volleyball_match_model.dart';

class VolleyballLiveScoringController extends GetxController {
  VolleyballMatchModel? _matchModel;
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

  void initializeMatch(VolleyballReviewModel data, bool teamAServesFirst, [VolleyballMatchModel? matchModel]) {
    initialData = data;
    _matchModel = matchModel;
    if (matchModel != null) {
      teamAScore.value = matchModel.scoreTeamA;
      teamBScore.value = matchModel.scoreTeamB;
      teamASets.value = matchModel.setsTeamA;
      teamBSets.value = matchModel.setsTeamB;
      currentSet.value = matchModel.currentSet;
      isTeamAServing.value = matchModel.isTeamAServing;
      matchSeconds.value = matchModel.matchSeconds;
      isPaused.value = matchModel.isPaused;
    } else {
      isTeamAServing.value = teamAServesFirst;
    }
    _saveStateToUndo("Match Started");
    if (!isPaused.value) startTimer();
  }

  void startTimer() {
    if (matchFinished.value) return;
    isPaused.value = false;
    _timer?.cancel();
    _timer = Timer.periodic(Duration(seconds: 1), (timer) {
      matchSeconds.value++;
    });
  }

  void pauseMatch() {
    isPaused.value = true;
    _timer?.cancel();
    _saveStateToUndo("Match Paused");
    _syncToDatabase();
  }

  void resumeMatch() {
    isPaused.value = false;
    startTimer();
    _saveStateToUndo("Match Resumed");
    _syncToDatabase();
  }

  void addPointTeamA({String reason = "Point"}) {
    if (matchFinished.value || isPaused.value) {
      _showWarning();
      return;
    }
    
    _saveStateToUndo("$reason awarded to ${initialData.teamA.teamName}");
    teamAScore.value++;
    isTeamAServing.value = true;
    _checkSetWinner();
    _syncToDatabase();
  }

  void addPointTeamB({String reason = "Point"}) {
    if (matchFinished.value || isPaused.value) {
      _showWarning();
      return;
    }

    _saveStateToUndo("$reason awarded to ${initialData.teamB.teamName}");
    teamBScore.value++;
    isTeamAServing.value = false;
    _checkSetWinner();
    _syncToDatabase();
  }

  void issuePenalty(String teamName, String cardType, String reason) {
    bool isTeamA = teamName == initialData.teamA.teamName;
    _saveStateToUndo("$cardType issued to $teamName for $reason");
    
    Get.snackbar(
      "$cardType: $teamName", 
      reason, 
      backgroundColor: cardType == 'Red Card' ? AppColors.error : Colors.amber, 
      colorText: Colors.white
    );

    if (cardType == 'Red Card') {
      // Red card gives a penalty point to the OPPOSING team
      if (isTeamA) {
        teamBScore.value++;
        isTeamAServing.value = false;
      } else {
        teamAScore.value++;
        isTeamAServing.value = true;
      }
      _checkSetWinner();
    }
    _syncToDatabase();
  }

  void _showWarning() {
    if (matchFinished.value) {
      showMatchFinishedDialog();
    } else if (isPaused.value) {
      Get.snackbar("Match Paused", "Please resume the timer before scoring.", backgroundColor: AppColors.error, colorText: AppColors.accent);
    }
  }

  void showMatchFinishedDialog() {
    Get.defaultDialog(
      title: "Match Finished!",
      titleStyle: AppTypography.headlineMd.copyWith(color: AppColors.accent, fontWeight: FontWeight.bold),
      backgroundColor: AppColors.card,
      barrierDismissible: false,
      content: Text("The match has concluded.", style: AppTypography.bodyMd.copyWith(color: Colors.white)),
      confirm: ElevatedButton(
        style: ElevatedButton.styleFrom(backgroundColor: AppColors.accent),
        onPressed: () {
          Get.back(); // close dialog
          Get.off(() => const VolleyballStatsScreen());
        },
        child: Text("VIEW STATS", style: AppTypography.headlineMd.copyWith(color: Colors.black)),
      )
    );
  }

  void undoLastPoint() {
    if (undoStack.isEmpty) {
      Get.snackbar("Undo", "No previous actions to undo.", backgroundColor: AppColors.card, colorText: AppColors.accent);
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
    _syncToDatabase();
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
    Get.snackbar("Set Completed", "Proceeding to Set ${currentSet.value}", backgroundColor: AppColors.accent, colorText: Colors.black);
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
    pauseMatch(); // Also calls syncToDatabase
    Get.snackbar("Match Complete", "$winner has won the match!", backgroundColor: AppColors.accent, colorText: Colors.black, duration: Duration(seconds: 5));
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

  void _syncToDatabase() {
    if (_matchModel != null) {
      final updated = _matchModel!.copyWith(
        scoreTeamA: teamAScore.value,
        scoreTeamB: teamBScore.value,
        setsTeamA: teamASets.value,
        setsTeamB: teamBSets.value,
        currentSet: currentSet.value,
        isTeamAServing: isTeamAServing.value,
        matchSeconds: matchSeconds.value,
        isPaused: isPaused.value,
        status: matchFinished.value ? 'completed' : 'active',
      );
      
      VolleyballSqflite.instance.updateMatch(updated);
      
      try {
        FirebaseFirestore.instance.collection('volleyball_matches').doc(updated.matchId).update({
          'scoreTeamA': updated.scoreTeamA,
          'scoreTeamB': updated.scoreTeamB,
          'setsTeamA': updated.setsTeamA,
          'setsTeamB': updated.setsTeamB,
          'currentSet': updated.currentSet,
          'isTeamAServing': updated.isTeamAServing,
          'matchSeconds': updated.matchSeconds,
          'isPaused': updated.isPaused,
          'status': matchFinished.value ? 'completed' : 'active',
        });
      } catch (e) {
        debugPrint('Firestore sync failed: $e');
      }
    }
  }
}
