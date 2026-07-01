import 'dart:async';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../../../model/User_Models/Home_Models/Scoreboard_Model/Football/live_match_model.dart';
import '../../../../../../model/User_Models/Home_Models/Scoreboard_Model/Football/team_statistics_model.dart';
import '../../../../../../model/User_Models/Home_Models/Scoreboard_Model/Football/match_event_model.dart';

class LiveFootballDashboardController extends GetxController {
  final RxBool isLoading = false.obs;
  final RxBool isLive = false.obs;
  
  // Bottom Nav
  final RxInt selectedBottomIndex = 0.obs;

  // Match State
  final Rx<LiveMatchModel?> match = Rx<LiveMatchModel?>(null);
  final Rx<TeamStatisticsModel?> statsA = Rx<TeamStatisticsModel?>(null);
  final Rx<TeamStatisticsModel?> statsB = Rx<TeamStatisticsModel?>(null);
  final RxList<MatchEventModel> events = <MatchEventModel>[].obs;

  // Dynamic values that update often
  final RxInt currentMinute = 0.obs;
  final RxString currentHalf = ''.obs;
  final RxInt scoreA = 0.obs;
  final RxInt scoreB = 0.obs;
  final RxInt possessionA = 0.obs;
  final RxInt possessionB = 0.obs;
  final RxInt shotsOnTargetA = 0.obs;
  final RxInt shotsOnTargetB = 0.obs;
  
  // Global XP / Stats demo
  final RxDouble xpPoints = 0.0.obs;
  final RxInt passAccuracy = 0.obs;
  final RxInt corners = 0.obs;
  final RxInt interceptions = 0.obs;

  Timer? _liveTimer;

  void initialize() {
    Future.microtask(() => isLoading.value = true);
    Future.delayed(const Duration(milliseconds: 500), () {
      loadMatch();
      syncStateFromModels();
      startLiveTimer();
      isLoading.value = false;
    });
  }

  void loadMatch() {
    // Static dummy data matching screenshot
    match.value = const LiveMatchModel(
      matchId: '8829-X',
      teamAName: 'TEAM A',
      teamBName: 'TEAM B',
      scoreA: 2,
      scoreB: 1,
      currentHalf: '2ND HALF',
      currentMinute: 67,
      isLive: true,
      possessionA: 58,
      possessionB: 42,
    );

    statsA.value = const TeamStatisticsModel(
      possession: 58,
      shots: 12,
      shotsOnTarget: 7,
      passes: 450,
      passAccuracy: 82,
      corners: 6,
      interceptions: 12,
      fouls: 10,
      yellowCards: 1,
      redCards: 0,
      expectedGoals: 1.5,
      xpPoints: 2.41,
    );

    statsB.value = const TeamStatisticsModel(
      possession: 42,
      shots: 6,
      shotsOnTarget: 3,
      passes: 320,
      passAccuracy: 75,
      corners: 4,
      interceptions: 8,
      fouls: 14,
      yellowCards: 2,
      redCards: 0,
      expectedGoals: 0.8,
      xpPoints: 1.85,
    );
  }

  void syncStateFromModels() {
    if (match.value != null) {
      currentMinute.value = match.value!.currentMinute;
      currentHalf.value = match.value!.currentHalf;
      scoreA.value = match.value!.scoreA;
      scoreB.value = match.value!.scoreB;
      isLive.value = match.value!.isLive;
      possessionA.value = match.value!.possessionA;
      possessionB.value = match.value!.possessionB;
    }
    
    if (statsA.value != null) {
      shotsOnTargetA.value = statsA.value!.shotsOnTarget;
      xpPoints.value = statsA.value!.xpPoints;
      passAccuracy.value = statsA.value!.passAccuracy;
      corners.value = statsA.value!.corners;
      interceptions.value = statsA.value!.interceptions;
    }
    if (statsB.value != null) {
      shotsOnTargetB.value = statsB.value!.shotsOnTarget;
    }
  }

  void startLiveTimer() {
    isLive.value = true;
    _liveTimer?.cancel();
    _liveTimer = Timer.periodic(const Duration(seconds: 10), (timer) {
      if (isLive.value) {
        currentMinute.value += 1;
        
        // Slightly random possession shifts for demo
        if (currentMinute.value % 2 == 0) {
          if (possessionA.value < 65) {
            possessionA.value += 1;
            possessionB.value -= 1;
          }
        } else {
          if (possessionB.value < 55) {
            possessionB.value += 1;
            possessionA.value -= 1;
          }
        }
      }
    });
  }

  void pauseMatch() {
    isLive.value = false;
    _liveTimer?.cancel();
    showSuccess("Match Paused");
  }

  void resumeMatch() {
    startLiveTimer();
    showSuccess("Match Resumed");
  }

  void endMatch() {
    isLive.value = false;
    _liveTimer?.cancel();
    showSuccess("Match Ended");
  }

  void recordGoal() {
    Get.bottomSheet(
      Container(
        color: Colors.grey.shade900,
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text('Which team scored?', style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 24),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ElevatedButton(
                  style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFFC6FF00)),
                  onPressed: () {
                    Get.back();
                    scoreA.value += 1;
                    xpPoints.value += 0.50;
                    _addEvent("Goal", "A", "Player scored");
                    showSuccess("Goal recorded for Team A!");
                  },
                  child: const Text('Team A', style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold)),
                ),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFFC6FF00)),
                  onPressed: () {
                    Get.back();
                    scoreB.value += 1;
                    xpPoints.value += 0.50;
                    _addEvent("Goal", "B", "Player scored");
                    showSuccess("Goal recorded for Team B!");
                  },
                  child: const Text('Team B', style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold)),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }

  void recordCard() {
    _addEvent("Card", "B", "Yellow Card");
    showSuccess("Card recorded.");
  }

  void recordSubstitution() {
    _addEvent("Substitution", "A", "Sub in/out");
    showSuccess("Substitution recorded.");
  }

  void recordVAR() {
    pauseMatch();
    _addEvent("VAR", "System", "VAR Review ongoing");
    showSuccess("VAR Review initialized.");
  }

  void updatePossession(int newPossessionA) {
    if (newPossessionA >= 0 && newPossessionA <= 100) {
      possessionA.value = newPossessionA;
      possessionB.value = 100 - newPossessionA;
    }
  }

  void updateStatistics() {
    // Stub for sync functionality
  }

  void syncMatch() {
    showSuccess("Match synced with server.");
  }

  void _addEvent(String type, String team, String desc) {
    events.insert(0, MatchEventModel(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      eventType: type,
      team: team,
      minute: currentMinute.value,
      description: desc,
    ));
  }

  void changeBottomNav(int index) {
    selectedBottomIndex.value = index;
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
      backgroundColor: const Color(0xFFC6FF00),
      colorText: Colors.black,
      snackPosition: SnackPosition.TOP,
      margin: const EdgeInsets.all(16),
      duration: const Duration(seconds: 2),
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
      snackPosition: SnackPosition.TOP,
      margin: const EdgeInsets.all(16),
    );
  }

  @override
  void onClose() {
    _liveTimer?.cancel();
    super.onClose();
  }
}
