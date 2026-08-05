import 'dart:async';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:redesign/theme/app_colors.dart';
import 'package:redesign/model/User_Models/Home_Models/Scoreboard_Model/Boxing/boxing_state_models.dart';
import 'package:redesign/model/User_Models/Home_Models/Scoreboard_Model/Boxing/boxing_model.dart';
import 'package:redesign/model/User_Models/Home_Models/Friends_Model/friends_model.dart';
import 'package:redesign/sqflite/User_SQF/Home_SQF/Scoreboard_SQF/boxingSqflite.dart';
import 'package:redesign/view/USER/Home/Scoreboard/Boxing/live_match/boxing_scoreboard_screen.dart';

class BoxingController extends GetxController {
  final TextEditingController fighterAController = TextEditingController(text: 'Red Corner');
  final TextEditingController fighterBController = TextEditingController(text: 'Blue Corner');

  final RxString fighterAName = 'Red Corner'.obs;
  final RxString fighterBName = 'Blue Corner'.obs;

  final Rxn<FriendModel> fighterAFriend = Rxn<FriendModel>();
  final Rxn<FriendModel> fighterBFriend = Rxn<FriendModel>();

  final RxString format = 'PROFESSIONAL'.obs; // 'PROFESSIONAL', 'AMATEUR', 'FRIENDLY'
  final RxInt totalRounds = 12.obs; // 3, 4, 6, 8, 10, 12
  final RxInt roundDurationMinutes = 3.obs; // 1, 2, 3
  final RxString weightClass = 'WELTERWEIGHT'.obs;
  final RxBool isProRules = true.obs;

  // Live Scoreboard State Guards
  final RxBool isMatchStarted = false.obs;
  final Rxn<BoxingMatchModel> currentMatch = Rxn<BoxingMatchModel>();
  final Rxn<BoxingMatchState> liveState = Rxn<BoxingMatchState>();
  late BoxingMatchEngine engine;

  final RxString currentMatchId = ''.obs;
  final RxBool isLoading = false.obs;
  final RxBool isEngineReady = false.obs;
  final RxBool isReadOnly = false.obs;
  final RxBool hasMatchEndUndoBeenUsed = false.obs;

  // Round Timer
  Timer? _roundTimer;
  final RxBool isTimerRunning = false.obs;

  StreamSubscription<DocumentSnapshot>? _firestoreSubscription;

  @override
  void onInit() {
    super.onInit();
    fighterAController.addListener(() {
      fighterAName.value = fighterAController.text;
    });
    fighterBController.addListener(() {
      fighterBName.value = fighterBController.text;
    });
  }

  @override
  void onClose() {
    _roundTimer?.cancel();
    _firestoreSubscription?.cancel();
    super.onClose();
  }

  void resetSetupScreen() {
    fighterAController.text = 'Red Corner';
    fighterBController.text = 'Blue Corner';
    fighterAName.value = 'Red Corner';
    fighterBName.value = 'Blue Corner';
    fighterAFriend.value = null;
    fighterBFriend.value = null;
    format.value = 'PROFESSIONAL';
    totalRounds.value = 12;
    roundDurationMinutes.value = 3;
    weightClass.value = 'WELTERWEIGHT';
    isProRules.value = true;
  }

  void setFormat(String f) {
    format.value = f;
    if (f == 'AMATEUR') {
      totalRounds.value = 3;
      roundDurationMinutes.value = 3;
    } else if (f == 'PROFESSIONAL') {
      totalRounds.value = 12;
      roundDurationMinutes.value = 3;
    }
  }

  void incrementTotalRounds() {
    if (totalRounds.value == 3) {
      totalRounds.value = 4;
    } else if (totalRounds.value == 4) {
      totalRounds.value = 6;
    } else if (totalRounds.value == 6) {
      totalRounds.value = 8;
    } else if (totalRounds.value == 8) {
      totalRounds.value = 10;
    } else if (totalRounds.value == 10) {
      totalRounds.value = 12;
    }
  }

  void decrementTotalRounds() {
    if (totalRounds.value == 12) {
      totalRounds.value = 10;
    } else if (totalRounds.value == 10) {
      totalRounds.value = 8;
    } else if (totalRounds.value == 8) {
      totalRounds.value = 6;
    } else if (totalRounds.value == 6) {
      totalRounds.value = 4;
    } else if (totalRounds.value == 4) {
      totalRounds.value = 3;
    }
  }

  void incrementRoundDuration() {
    if (roundDurationMinutes.value < 10) {
      roundDurationMinutes.value++;
    }
  }

  void decrementRoundDuration() {
    if (roundDurationMinutes.value > 1) {
      roundDurationMinutes.value--;
    }
  }

  void toggleProRules(bool value) {
    isProRules.value = value;
    if (value) {
      format.value = 'PROFESSIONAL';
      totalRounds.value = 12;
      roundDurationMinutes.value = 3;
    }
  }

  Future<void> startMatchFromSetup() async {
    isLoading.value = true;
    final matchId = 'BOXING_${DateTime.now().millisecondsSinceEpoch}';
    currentMatchId.value = matchId;

    final fA = BoxingFighter(
      id: fighterAFriend.value?.email ?? 'red_corner',
      name: fighterAName.value.isNotEmpty ? fighterAName.value : 'Red Corner',
      weightClass: weightClass.value,
    );

    final fB = BoxingFighter(
      id: fighterBFriend.value?.email ?? 'blue_corner',
      name: fighterBName.value.isNotEmpty ? fighterBName.value : 'Blue Corner',
      weightClass: weightClass.value,
    );

    final config = BoxingMatchConfig(
      format: format.value,
      totalRounds: totalRounds.value,
      roundDurationMinutes: roundDurationMinutes.value,
      restDurationSeconds: 60,
    );

    final initState = BoxingMatchState.initial(
      fighterA: fA,
      fighterB: fB,
      config: config,
    );

    engine = BoxingMatchEngine(initState);
    liveState.value = engine.state;
    isEngineReady.value = true;
    isMatchStarted.value = true;

    _startTimer();

    final user = FirebaseAuth.instance.currentUser;
    final userId = user?.uid ?? 'local_user';

    final model = BoxingMatchModel(
      matchId: matchId,
      userId: userId,
      fighterA: fA.name,
      fighterB: fB.name,
      fighterAScore: 0,
      fighterBScore: 0,
      currentRoundDisplay: 'Round 1 of ${config.totalRounds}',
      isCompleted: false,
      matchResult: '',
      engineState: engine.state.toJson(),
    );

    currentMatch.value = model;

    try {
      await BoxingSqfliteService.insertMatch(model);
    } catch (_) {}

    try {
      await FirebaseFirestore.instance
          .collection('boxing_matches')
          .doc(matchId)
          .set(model.toFirebaseJson());
    } catch (_) {}

    _listenToFirestore(matchId);

    isLoading.value = false;
    Get.off(() => const BoxingScoreboardScreen());
  }

  void _startTimer() {
    _roundTimer?.cancel();
    isTimerRunning.value = true;
    _roundTimer = Timer.periodic(const Duration(seconds: 1), (t) {
      if (liveState.value == null || isReadOnly.value) return;
      final curTime = liveState.value!.roundTimeRemaining;
      if (curTime > 0) {
        liveState.value = liveState.value!.copyWith(roundTimeRemaining: curTime - 1);
      } else {
        _roundTimer?.cancel();
        isTimerRunning.value = false;
      }
    });
  }

  void toggleTimer() {
    if (isTimerRunning.value) {
      _roundTimer?.cancel();
      isTimerRunning.value = false;
    } else {
      _startTimer();
    }
  }

  void _listenToFirestore(String matchId) {
    _firestoreSubscription?.cancel();
    _firestoreSubscription = FirebaseFirestore.instance
        .collection('boxing_matches')
        .doc(matchId)
        .snapshots()
        .listen((doc) {
      if (doc.exists && doc.data() != null) {
        final remoteModel = BoxingMatchModel.fromFirebaseJson(doc.data()!);
        if (remoteModel.userId != FirebaseAuth.instance.currentUser?.uid) {
          isReadOnly.value = true;
          currentMatch.value = remoteModel;
          if (remoteModel.engineState != null) {
            final remoteState = BoxingMatchState.fromJson(remoteModel.engineState!);
            liveState.value = remoteState;
          }
        }
      }
    });
  }

  void addPoint(String scoringSide, [int points = 1]) {
    if (isReadOnly.value || liveState.value == null) return;
    engine.addPoint(scoringSide, points);
    liveState.value = engine.state;
    _syncMatchState();
  }

  void recordKnockdown(String downSide) {
    if (isReadOnly.value || liveState.value == null) return;
    engine.recordKnockdown(downSide);
    liveState.value = engine.state;
    _syncMatchState();
  }

  void recordFoul(String foulSide) {
    if (isReadOnly.value || liveState.value == null) return;
    engine.recordFoul(foulSide);
    liveState.value = engine.state;
    _syncMatchState();
  }

  void completeRound() {
    if (isReadOnly.value || liveState.value == null) return;
    engine.completeRound();
    liveState.value = engine.state;
    _syncMatchState();

    if (engine.state.isMatchFinished) {
      finishMatch();
    }
  }

  void stopMatch(String stoppageType, String winnerSide) {
    if (isReadOnly.value || liveState.value == null) return;
    engine.stopMatch(stoppageType, winnerSide);
    liveState.value = engine.state;

    final winnerName = winnerSide == 'fighterA' ? engine.state.fighterA.name : engine.state.fighterB.name;
    final result = '$winnerName won by $stoppageType in Round ${engine.state.currentRoundIndex + 1}!';

    _syncMatchState(isFinished: true, result: result);
  }

  void advanceNextRound() {
    if (isReadOnly.value) return;
    engine.advanceNextRound();
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
        'Stoppage undone. Fight resumed!',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: AppColors.cardSurface,
        colorText: Colors.white,
      );
    }
  }

  void finishMatch() {
    _roundTimer?.cancel();
    isTimerRunning.value = false;

    final scoreA = engine.state.sideAPoints;
    final scoreB = engine.state.sideBPoints;
    final nameA = engine.state.fighterA.name;
    final nameB = engine.state.fighterB.name;

    String result = 'DRAW';
    if (scoreA > scoreB) {
      result = '$nameA won by Points ($scoreA - $scoreB)';
    } else if (scoreB > scoreA) {
      result = '$nameB won by Points ($scoreB - $scoreA)';
    }

    _syncMatchState(isFinished: true, result: result);
  }

  Future<void> _syncMatchState({bool isFinished = false, String result = ''}) async {
    if (currentMatch.value == null) return;
    final updated = BoxingMatchModel(
      matchId: currentMatch.value!.matchId,
      userId: currentMatch.value!.userId,
      fighterA: currentMatch.value!.fighterA,
      fighterB: currentMatch.value!.fighterB,
      fighterAScore: engine.state.sideAPoints,
      fighterBScore: engine.state.sideBPoints,
      currentRoundDisplay: 'Round ${engine.state.currentRoundIndex + 1} of ${engine.state.config.totalRounds}',
      isCompleted: isFinished || engine.state.isMatchFinished,
      matchResult: result.isNotEmpty ? result : currentMatch.value!.matchResult,
      engineState: engine.state.toJson(),
      updatedAt: DateTime.now(),
    );

    currentMatch.value = updated;
    try {
      await BoxingSqfliteService.updateMatch(updated);
    } catch (_) {}

    try {
      await FirebaseFirestore.instance
          .collection('boxing_matches')
          .doc(updated.matchId)
          .set(updated.toFirebaseJson(), SetOptions(merge: true));
    } catch (_) {}
  }

  Future<void> restoreBoxingMatchFromSqflite(BoxingMatchModel matchModel) async {
    currentMatchId.value = matchModel.matchId;
    currentMatch.value = matchModel;
    isReadOnly.value = false;

    if (matchModel.engineState != null) {
      final restoredState = BoxingMatchState.fromJson(matchModel.engineState!);
      engine = BoxingMatchEngine(restoredState);
      liveState.value = engine.state;
      isEngineReady.value = true;
      isMatchStarted.value = true;
      _listenToFirestore(matchModel.matchId);
    }
  }

  static Future<void> resumeMatch(String matchId) async {
    final controller = Get.isRegistered<BoxingController>()
        ? Get.find<BoxingController>()
        : Get.put(BoxingController());

    final matchData = await BoxingSqfliteService.getMatchById(matchId);
    if (matchData != null) {
      await controller.restoreBoxingMatchFromSqflite(matchData);
      Get.to(() => const BoxingScoreboardScreen());
    }
  }
}
