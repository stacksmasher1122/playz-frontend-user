import 'dart:async';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:redesign/theme/app_colors.dart';
import 'package:redesign/model/User_Models/Home_Models/Scoreboard_Model/MuayThai/muay_thai_state_models.dart';
import 'package:redesign/model/User_Models/Home_Models/Scoreboard_Model/MuayThai/muay_thai_model.dart';
import 'package:redesign/model/User_Models/Home_Models/Friends_Model/friends_model.dart';
import 'package:redesign/sqflite/User_SQF/Home_SQF/Scoreboard_SQF/muayThaiSqflite.dart';
import 'package:redesign/view/USER/Home/Scoreboard/MuayThai/live_match/muay_thai_scoreboard_screen.dart';

class MuayThaiController extends GetxController {
  final TextEditingController fighterAController = TextEditingController(text: 'RED Corner');
  final TextEditingController fighterBController = TextEditingController(text: 'BLUE Corner');

  final RxString fighterAName = 'RED Corner'.obs;
  final RxString fighterBName = 'BLUE Corner'.obs;

  final Rxn<FriendModel> fighterAFriend = Rxn<FriendModel>();
  final Rxn<FriendModel> fighterBFriend = Rxn<FriendModel>();

  final RxString format = 'STADIUM_5x3MIN'.obs;
  final RxInt totalRounds = 5.obs; // 3 or 5
  final RxInt roundDurationMinutes = 3.obs; // 2, 3
  final RxInt restDurationSeconds = 60.obs; // 60, 120
  final RxString weightClass = 'OPEN'.obs;

  // Live Scoreboard State Guards
  final RxBool isMatchStarted = false.obs;
  final Rxn<MuayThaiMatchModel> currentMatch = Rxn<MuayThaiMatchModel>();
  final Rxn<MuayThaiMatchState> liveState = Rxn<MuayThaiMatchState>();
  late MuayThaiMatchEngine engine;

  final RxString currentMatchId = ''.obs;
  final RxBool isLoading = false.obs;
  final RxBool isEngineReady = false.obs;
  final RxBool isReadOnly = false.obs;
  final RxBool hasMatchEndUndoBeenUsed = false.obs;

  // Round / Rest Timer
  Timer? _timer;
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
    _timer?.cancel();
    _firestoreSubscription?.cancel();
    super.onClose();
  }

  void resetSetupScreen() {
    fighterAController.text = 'RED Corner';
    fighterBController.text = 'BLUE Corner';
    fighterAName.value = 'RED Corner';
    fighterBName.value = 'BLUE Corner';
    fighterAFriend.value = null;
    fighterBFriend.value = null;
    format.value = 'STADIUM_5x3MIN';
    totalRounds.value = 5;
    roundDurationMinutes.value = 3;
    restDurationSeconds.value = 60;
    weightClass.value = 'OPEN';
  }

  void setFormat(String fmt) {
    format.value = fmt;
    if (fmt == 'STADIUM_5x3MIN') {
      totalRounds.value = 5;
      roundDurationMinutes.value = 3;
      restDurationSeconds.value = 60;
    } else if (fmt == 'AMATEUR_3x3MIN') {
      totalRounds.value = 3;
      roundDurationMinutes.value = 3;
      restDurationSeconds.value = 60;
    }
  }

  void incrementRoundDuration() {
    if (roundDurationMinutes.value < 5) {
      roundDurationMinutes.value++;
    }
  }

  void decrementRoundDuration() {
    if (roundDurationMinutes.value > 1) {
      roundDurationMinutes.value--;
    }
  }

  Future<void> startMatchFromSetup() async {
    isLoading.value = true;
    final matchId = 'MT_${DateTime.now().millisecondsSinceEpoch}';
    currentMatchId.value = matchId;

    final red = NakMuay(
      id: fighterAFriend.value?.email ?? 'red_corner',
      name: fighterAName.value.isNotEmpty ? fighterAName.value : 'RED Corner',
      weightClass: weightClass.value,
    );

    final blue = NakMuay(
      id: fighterBFriend.value?.email ?? 'blue_corner',
      name: fighterBName.value.isNotEmpty ? fighterBName.value : 'BLUE Corner',
      weightClass: weightClass.value,
    );

    final config = MuayThaiMatchConfig(
      format: format.value,
      totalRounds: totalRounds.value,
      roundDurationMinutes: roundDurationMinutes.value,
      restDurationSeconds: restDurationSeconds.value,
    );

    final initState = MuayThaiMatchState.initial(
      fighterA: red,
      fighterB: blue,
      config: config,
    );

    engine = MuayThaiMatchEngine(initState);
    liveState.value = engine.state;
    isEngineReady.value = true;
    isMatchStarted.value = true;

    _startTimer();

    final user = FirebaseAuth.instance.currentUser;
    final userId = user?.uid ?? 'local_user';

    final model = MuayThaiMatchModel(
      matchId: matchId,
      userId: userId,
      fighterA: red.name,
      fighterB: blue.name,
      fighterAScore: 0,
      fighterBScore: 0,
      currentRoundDisplay: 'Round 1 / ${config.totalRounds}',
      isCompleted: false,
      matchResult: '',
      engineState: engine.state.toJson(),
    );

    currentMatch.value = model;

    try {
      await MuayThaiSqfliteService.insertMatch(model);
    } catch (_) {}

    try {
      await FirebaseFirestore.instance
          .collection('muay_thai_matches')
          .doc(matchId)
          .set(model.toFirebaseJson());
    } catch (_) {}

    _listenToFirestore(matchId);

    isLoading.value = false;
    Get.off(() => const MuayThaiScoreboardScreen());
  }

  void _startTimer() {
    _timer?.cancel();
    isTimerRunning.value = true;
    _timer = Timer.periodic(const Duration(seconds: 1), (t) {
      if (liveState.value == null || isReadOnly.value) return;

      final state = liveState.value!;
      if (state.isRestTime) {
        if (state.restTimeRemaining > 0) {
          liveState.value = state.copyWith(restTimeRemaining: state.restTimeRemaining - 1);
        } else {
          engine.nextRound();
          liveState.value = engine.state;
          _syncMatchState();
        }
      } else {
        if (state.roundTimeRemaining > 0) {
          liveState.value = state.copyWith(roundTimeRemaining: state.roundTimeRemaining - 1);
        } else {
          _timer?.cancel();
          isTimerRunning.value = false;
        }
      }
    });
  }

  void toggleTimer() {
    if (isTimerRunning.value) {
      _timer?.cancel();
      isTimerRunning.value = false;
    } else {
      _startTimer();
    }
  }

  void _listenToFirestore(String matchId) {
    _firestoreSubscription?.cancel();
    _firestoreSubscription = FirebaseFirestore.instance
        .collection('muay_thai_matches')
        .doc(matchId)
        .snapshots()
        .listen((doc) {
      if (doc.exists && doc.data() != null) {
        final remoteModel = MuayThaiMatchModel.fromFirebaseJson(doc.data()!);
        if (remoteModel.userId != FirebaseAuth.instance.currentUser?.uid) {
          isReadOnly.value = true;
          currentMatch.value = remoteModel;
          if (remoteModel.engineState != null) {
            final remoteState = MuayThaiMatchState.fromJson(remoteModel.engineState!);
            liveState.value = remoteState;
          }
        }
      }
    });
  }

  void scoreRound(int scoreA, int scoreB) {
    if (isReadOnly.value || liveState.value == null) return;
    engine.scoreRound(scoreA, scoreB);
    liveState.value = engine.state;

    if (engine.state.isMatchFinished) {
      finishMatch();
    } else {
      _startTimer();
      _syncMatchState();
    }
  }

  void recordKnockdown(String side) {
    if (isReadOnly.value || liveState.value == null) return;
    engine.recordKnockdown(side);
    liveState.value = engine.state;
    _syncMatchState();
  }

  void stopMatch(String victoryType, String winnerSide) {
    if (isReadOnly.value || liveState.value == null) return;
    engine.stopMatch(victoryType, winnerSide);
    liveState.value = engine.state;

    final nameA = engine.state.fighterA.name;
    final nameB = engine.state.fighterB.name;
    final winnerName = winnerSide == 'fighterA' ? nameA : nameB;
    final result = '$winnerName won by $victoryType!';

    _syncMatchState(isFinished: true, result: result);
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
        'Stoppage undone. Muay Thai bout resumed!',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: AppColors.cardSurface,
        colorText: Colors.white,
      );
    }
  }

  void finishMatch() {
    _timer?.cancel();
    isTimerRunning.value = false;

    final nameA = engine.state.fighterA.name;
    final nameB = engine.state.fighterB.name;
    final totA = engine.state.totalScoreA;
    final totB = engine.state.totalScoreB;

    String result = 'DRAW ($totA - $totB)';
    if (engine.state.victoryType != null && engine.state.winnerSide != null) {
      final winnerName = engine.state.winnerSide == 'fighterA' ? nameA : (engine.state.winnerSide == 'fighterB' ? nameB : 'Draw');
      if (winnerName == 'Draw') {
        result = 'DRAW ($totA - $totB)';
      } else {
        result = '$winnerName won by ${engine.state.victoryType}';
      }
    } else if (totA > totB) {
      result = '$nameA won by Decision ($totA - $totB)';
    } else if (totB > totA) {
      result = '$nameB won by Decision ($totB - $totA)';
    }

    _syncMatchState(isFinished: true, result: result);
  }

  Future<void> _syncMatchState({bool isFinished = false, String result = ''}) async {
    if (currentMatch.value == null) return;
    final updated = MuayThaiMatchModel(
      matchId: currentMatch.value!.matchId,
      userId: currentMatch.value!.userId,
      fighterA: currentMatch.value!.fighterA,
      fighterB: currentMatch.value!.fighterB,
      fighterAScore: engine.state.totalScoreA,
      fighterBScore: engine.state.totalScoreB,
      currentRoundDisplay: 'Round ${engine.state.currentRound} / ${engine.state.config.totalRounds}',
      isCompleted: isFinished || engine.state.isMatchFinished,
      matchResult: result.isNotEmpty ? result : currentMatch.value!.matchResult,
      engineState: engine.state.toJson(),
      updatedAt: DateTime.now(),
    );

    currentMatch.value = updated;
    try {
      await MuayThaiSqfliteService.updateMatch(updated);
    } catch (_) {}

    try {
      await FirebaseFirestore.instance
          .collection('muay_thai_matches')
          .doc(updated.matchId)
          .set(updated.toFirebaseJson(), SetOptions(merge: true));
    } catch (_) {}
  }

  Future<void> restoreMuayThaiMatchFromSqflite(MuayThaiMatchModel matchModel) async {
    currentMatchId.value = matchModel.matchId;
    currentMatch.value = matchModel;
    isReadOnly.value = false;

    if (matchModel.engineState != null) {
      final restoredState = MuayThaiMatchState.fromJson(matchModel.engineState!);
      engine = MuayThaiMatchEngine(restoredState);
      liveState.value = engine.state;
      isEngineReady.value = true;
      isMatchStarted.value = true;
      _listenToFirestore(matchModel.matchId);
    }
  }

  static Future<void> resumeMatch(String matchId) async {
    final controller = Get.isRegistered<MuayThaiController>()
        ? Get.find<MuayThaiController>()
        : Get.put(MuayThaiController());

    final matchData = await MuayThaiSqfliteService.getMatchById(matchId);
    if (matchData != null) {
      await controller.restoreMuayThaiMatchFromSqflite(matchData);
      Get.to(() => const MuayThaiScoreboardScreen());
    }
  }
}
