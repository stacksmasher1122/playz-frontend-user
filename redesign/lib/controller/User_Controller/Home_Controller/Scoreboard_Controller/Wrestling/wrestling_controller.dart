import 'dart:async';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:redesign/theme/app_colors.dart';
import 'package:redesign/model/User_Models/Home_Models/Scoreboard_Model/Wrestling/wrestling_state_models.dart';
import 'package:redesign/model/User_Models/Home_Models/Scoreboard_Model/Wrestling/wrestling_model.dart';
import 'package:redesign/model/User_Models/Home_Models/Friends_Model/friends_model.dart';
import 'package:redesign/sqflite/User_SQF/Home_SQF/Scoreboard_SQF/wrestlingSqflite.dart';
import 'package:redesign/view/USER/Home/Scoreboard/Wrestling/live_match/wrestling_scoreboard_screen.dart';

class WrestlingController extends GetxController {
  final TextEditingController wrestlerAController = TextEditingController(text: 'Red Corner');
  final TextEditingController wrestlerBController = TextEditingController(text: 'Blue Corner');

  final RxString wrestlerAName = 'Red Corner'.obs;
  final RxString wrestlerBName = 'Blue Corner'.obs;

  final Rxn<FriendModel> wrestlerAFriend = Rxn<FriendModel>();
  final Rxn<FriendModel> wrestlerBFriend = Rxn<FriendModel>();

  final RxString style = 'FREESTYLE'.obs; // 'FREESTYLE', 'GRECO_ROMAN'
  final RxInt totalPeriods = 2.obs; // Default 2
  final RxInt periodDurationMinutes = 3.obs; // 1, 2, 3, 5
  final RxString weightClass = '74 KG'.obs;

  // Live Scoreboard State Guards
  final RxBool isMatchStarted = false.obs;
  final Rxn<WrestlingMatchModel> currentMatch = Rxn<WrestlingMatchModel>();
  final Rxn<WrestlingMatchState> liveState = Rxn<WrestlingMatchState>();
  late WrestlingMatchEngine engine;

  final RxString currentMatchId = ''.obs;
  final RxBool isLoading = false.obs;
  final RxBool isEngineReady = false.obs;
  final RxBool isReadOnly = false.obs;
  final RxBool hasMatchEndUndoBeenUsed = false.obs;

  // Period Timer
  Timer? _periodTimer;
  final RxBool isTimerRunning = false.obs;

  StreamSubscription<DocumentSnapshot>? _firestoreSubscription;

  @override
  void onInit() {
    super.onInit();
    wrestlerAController.addListener(() {
      wrestlerAName.value = wrestlerAController.text;
    });
    wrestlerBController.addListener(() {
      wrestlerBName.value = wrestlerBController.text;
    });
  }

  @override
  void onClose() {
    _periodTimer?.cancel();
    _firestoreSubscription?.cancel();
    super.onClose();
  }

  void resetSetupScreen() {
    wrestlerAController.text = 'Red Corner';
    wrestlerBController.text = 'Blue Corner';
    wrestlerAName.value = 'Red Corner';
    wrestlerBName.value = 'Blue Corner';
    wrestlerAFriend.value = null;
    wrestlerBFriend.value = null;
    style.value = 'FREESTYLE';
    totalPeriods.value = 2;
    periodDurationMinutes.value = 3;
    weightClass.value = '74 KG';
  }

  void setStyle(String s) {
    style.value = s;
  }

  void incrementTotalPeriods() {
    if (totalPeriods.value < 4) {
      totalPeriods.value++;
    }
  }

  void decrementTotalPeriods() {
    if (totalPeriods.value > 1) {
      totalPeriods.value--;
    }
  }

  void incrementPeriodDuration() {
    if (periodDurationMinutes.value < 5) {
      periodDurationMinutes.value++;
    }
  }

  void decrementPeriodDuration() {
    if (periodDurationMinutes.value > 1) {
      periodDurationMinutes.value--;
    }
  }

  Future<void> startMatchFromSetup() async {
    isLoading.value = true;
    final matchId = 'WRESTLING_${DateTime.now().millisecondsSinceEpoch}';
    currentMatchId.value = matchId;

    final wA = Wrestler(
      id: wrestlerAFriend.value?.email ?? 'red_corner',
      name: wrestlerAName.value.isNotEmpty ? wrestlerAName.value : 'Red Corner',
      weightClass: weightClass.value,
    );

    final wB = Wrestler(
      id: wrestlerBFriend.value?.email ?? 'blue_corner',
      name: wrestlerBName.value.isNotEmpty ? wrestlerBName.value : 'Blue Corner',
      weightClass: weightClass.value,
    );

    final techDiff = style.value == 'FREESTYLE' ? 10 : 8;
    final config = WrestlingMatchConfig(
      style: style.value,
      totalPeriods: totalPeriods.value,
      periodDurationMinutes: periodDurationMinutes.value,
      restDurationSeconds: 30,
      techFallDifference: techDiff,
    );

    final initState = WrestlingMatchState.initial(
      wrestlerA: wA,
      wrestlerB: wB,
      config: config,
    );

    engine = WrestlingMatchEngine(initState);
    liveState.value = engine.state;
    isEngineReady.value = true;
    isMatchStarted.value = true;

    _startTimer();

    final user = FirebaseAuth.instance.currentUser;
    final userId = user?.uid ?? 'local_user';

    final model = WrestlingMatchModel(
      matchId: matchId,
      userId: userId,
      wrestlerA: wA.name,
      wrestlerB: wB.name,
      wrestlerAScore: 0,
      wrestlerBScore: 0,
      currentPeriodDisplay: 'Period 1 of ${config.totalPeriods}',
      isCompleted: false,
      matchResult: '',
      engineState: engine.state.toJson(),
    );

    currentMatch.value = model;

    try {
      await WrestlingSqfliteService.insertMatch(model);
    } catch (_) {}

    try {
      await FirebaseFirestore.instance
          .collection('wrestling_matches')
          .doc(matchId)
          .set(model.toFirebaseJson());
    } catch (_) {}

    _listenToFirestore(matchId);

    isLoading.value = false;
    Get.off(() => const WrestlingScoreboardScreen());
  }

  void _startTimer() {
    _periodTimer?.cancel();
    isTimerRunning.value = true;
    _periodTimer = Timer.periodic(const Duration(seconds: 1), (t) {
      if (liveState.value == null || isReadOnly.value) return;
      final curTime = liveState.value!.periodTimeRemaining;
      if (curTime > 0) {
        liveState.value = liveState.value!.copyWith(periodTimeRemaining: curTime - 1);
      } else {
        _periodTimer?.cancel();
        isTimerRunning.value = false;
      }
    });
  }

  void toggleTimer() {
    if (isTimerRunning.value) {
      _periodTimer?.cancel();
      isTimerRunning.value = false;
    } else {
      _startTimer();
    }
  }

  void _listenToFirestore(String matchId) {
    _firestoreSubscription?.cancel();
    _firestoreSubscription = FirebaseFirestore.instance
        .collection('wrestling_matches')
        .doc(matchId)
        .snapshots()
        .listen((doc) {
      if (doc.exists && doc.data() != null) {
        final remoteModel = WrestlingMatchModel.fromFirebaseJson(doc.data()!);
        if (remoteModel.userId != FirebaseAuth.instance.currentUser?.uid) {
          isReadOnly.value = true;
          currentMatch.value = remoteModel;
          if (remoteModel.engineState != null) {
            final remoteState = WrestlingMatchState.fromJson(remoteModel.engineState!);
            liveState.value = remoteState;
          }
        }
      }
    });
  }

  void addPoints(String scoringSide, int points) {
    if (isReadOnly.value || liveState.value == null) return;
    engine.addPoints(scoringSide, points);
    liveState.value = engine.state;
    _syncMatchState();

    if (engine.state.isMatchFinished) {
      finishMatch();
    }
  }

  void recordCaution(String foulSide) {
    if (isReadOnly.value || liveState.value == null) return;
    engine.recordCaution(foulSide);
    liveState.value = engine.state;
    _syncMatchState();
  }

  void recordFall(String winnerSide) {
    if (isReadOnly.value || liveState.value == null) return;
    engine.recordFall(winnerSide);
    liveState.value = engine.state;

    final winnerName = winnerSide == 'wrestlerA' ? engine.state.wrestlerA.name : engine.state.wrestlerB.name;
    final result = '$winnerName won by Fall (Pin) in Period ${engine.state.currentPeriodIndex + 1}!';

    _syncMatchState(isFinished: true, result: result);
  }

  void completePeriod() {
    if (isReadOnly.value || liveState.value == null) return;
    engine.completePeriod();
    liveState.value = engine.state;
    _syncMatchState();

    if (engine.state.isMatchFinished) {
      finishMatch();
    }
  }

  void stopMatch(String victoryType, String winnerSide) {
    if (isReadOnly.value || liveState.value == null) return;
    engine.stopMatch(victoryType, winnerSide);
    liveState.value = engine.state;

    final winnerName = winnerSide == 'wrestlerA' ? engine.state.wrestlerA.name : engine.state.wrestlerB.name;
    final result = '$winnerName won by $victoryType!';

    _syncMatchState(isFinished: true, result: result);
  }

  void advanceNextPeriod() {
    if (isReadOnly.value) return;
    engine.advanceNextPeriod();
    liveState.value = engine.state;
    _startTimer();
    _syncMatchState();
  }

  void undoLastAction() {
    if (isReadOnly.value) return;
    if (engine.canUndo) {
      engine.undo();
      liveState.value = engine.state;
      _syncMatchState();
    }
  }

  void undoLastMatchPoint() {
    if (isReadOnly.value || hasMatchEndUndoBeenUsed.value) return;
    if (engine.canUndo) {
      engine.undo();
      liveState.value = engine.state;
      hasMatchEndUndoBeenUsed.value = true;
      isMatchStarted.value = true;
      _startTimer();
      _syncMatchState();
      Get.snackbar(
        'Match End Undone',
        'Stoppage undone. Wrestling match resumed!',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: AppColors.cardSurface,
        colorText: Colors.white,
      );
    }
  }

  void finishMatch() {
    _periodTimer?.cancel();
    isTimerRunning.value = false;

    final scoreA = engine.state.sideAPoints;
    final scoreB = engine.state.sideBPoints;
    final nameA = engine.state.wrestlerA.name;
    final nameB = engine.state.wrestlerB.name;

    String result = 'DRAW';
    if (engine.state.victoryType != null && engine.state.winnerSide != null) {
      final winnerName = engine.state.winnerSide == 'wrestlerA' ? nameA : nameB;
      result = '$winnerName won by ${engine.state.victoryType} ($scoreA - $scoreB)';
    } else if (scoreA > scoreB) {
      result = '$nameA won by Points ($scoreA - $scoreB)';
    } else if (scoreB > scoreA) {
      result = '$nameB won by Points ($scoreB - $scoreA)';
    }

    _syncMatchState(isFinished: true, result: result);
  }

  Future<void> _syncMatchState({bool isFinished = false, String result = ''}) async {
    if (currentMatch.value == null) return;
    final updated = WrestlingMatchModel(
      matchId: currentMatch.value!.matchId,
      userId: currentMatch.value!.userId,
      wrestlerA: currentMatch.value!.wrestlerA,
      wrestlerB: currentMatch.value!.wrestlerB,
      wrestlerAScore: engine.state.sideAPoints,
      wrestlerBScore: engine.state.sideBPoints,
      currentPeriodDisplay: 'Period ${engine.state.currentPeriodIndex + 1} of ${engine.state.config.totalPeriods}',
      isCompleted: isFinished || engine.state.isMatchFinished,
      matchResult: result.isNotEmpty ? result : currentMatch.value!.matchResult,
      engineState: engine.state.toJson(),
      updatedAt: DateTime.now(),
    );

    currentMatch.value = updated;
    try {
      await WrestlingSqfliteService.updateMatch(updated);
    } catch (_) {}

    try {
      await FirebaseFirestore.instance
          .collection('wrestling_matches')
          .doc(updated.matchId)
          .set(updated.toFirebaseJson(), SetOptions(merge: true));
    } catch (_) {}
  }

  Future<void> restoreWrestlingMatchFromSqflite(WrestlingMatchModel matchModel) async {
    currentMatchId.value = matchModel.matchId;
    currentMatch.value = matchModel;
    isReadOnly.value = false;

    if (matchModel.engineState != null) {
      final restoredState = WrestlingMatchState.fromJson(matchModel.engineState!);
      engine = WrestlingMatchEngine(restoredState);
      liveState.value = engine.state;
      isEngineReady.value = true;
      isMatchStarted.value = true;
      _listenToFirestore(matchModel.matchId);
    }
  }

  static Future<void> resumeMatch(String matchId) async {
    final controller = Get.isRegistered<WrestlingController>()
        ? Get.find<WrestlingController>()
        : Get.put(WrestlingController());

    final matchData = await WrestlingSqfliteService.getMatchById(matchId);
    if (matchData != null) {
      await controller.restoreWrestlingMatchFromSqflite(matchData);
      Get.to(() => const WrestlingScoreboardScreen());
    }
  }
}
