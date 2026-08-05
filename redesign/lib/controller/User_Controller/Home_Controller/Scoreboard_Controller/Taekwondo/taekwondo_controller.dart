import 'dart:async';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:redesign/theme/app_colors.dart';
import 'package:redesign/model/User_Models/Home_Models/Scoreboard_Model/Taekwondo/taekwondo_state_models.dart';
import 'package:redesign/model/User_Models/Home_Models/Scoreboard_Model/Taekwondo/taekwondo_model.dart';
import 'package:redesign/model/User_Models/Home_Models/Friends_Model/friends_model.dart';
import 'package:redesign/sqflite/User_SQF/Home_SQF/Scoreboard_SQF/taekwondoSqflite.dart';
import 'package:redesign/view/USER/Home/Scoreboard/Taekwondo/live_match/taekwondo_scoreboard_screen.dart';

class TaekwondoController extends GetxController {
  final TextEditingController hongFighterController = TextEditingController(text: 'HONG (Red)');
  final TextEditingController chongFighterController = TextEditingController(text: 'CHONG (Blue)');

  final RxString hongFighterName = 'HONG (Red)'.obs;
  final RxString chongFighterName = 'CHONG (Blue)'.obs;

  final Rxn<FriendModel> hongFighterFriend = Rxn<FriendModel>();
  final Rxn<FriendModel> chongFighterFriend = Rxn<FriendModel>();

  final RxString category = 'SENIOR_3x2MIN'.obs;
  final RxInt totalRounds = 3.obs; // 3 or 5
  final RxInt roundDurationMinutes = 2.obs; // 1, 2, 3
  final RxInt restDurationSeconds = 60.obs; // 30, 60
  final RxString weightClass = 'OPEN'.obs;

  // Live Scoreboard State Guards
  final RxBool isMatchStarted = false.obs;
  final Rxn<TaekwondoMatchModel> currentMatch = Rxn<TaekwondoMatchModel>();
  final Rxn<TaekwondoMatchState> liveState = Rxn<TaekwondoMatchState>();
  late TaekwondoMatchEngine engine;

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
    hongFighterController.addListener(() {
      hongFighterName.value = hongFighterController.text;
    });
    chongFighterController.addListener(() {
      chongFighterName.value = chongFighterController.text;
    });
  }

  @override
  void onClose() {
    _timer?.cancel();
    _firestoreSubscription?.cancel();
    super.onClose();
  }

  void resetSetupScreen() {
    hongFighterController.text = 'HONG (Red)';
    chongFighterController.text = 'CHONG (Blue)';
    hongFighterName.value = 'HONG (Red)';
    chongFighterName.value = 'CHONG (Blue)';
    hongFighterFriend.value = null;
    chongFighterFriend.value = null;
    category.value = 'SENIOR_3x2MIN';
    totalRounds.value = 3;
    roundDurationMinutes.value = 2;
    restDurationSeconds.value = 60;
    weightClass.value = 'OPEN';
  }

  void setCategory(String cat) {
    category.value = cat;
    if (cat == 'SENIOR_3x2MIN') {
      totalRounds.value = 3;
      roundDurationMinutes.value = 2;
    } else if (cat == 'JUNIOR_3x1_5MIN') {
      totalRounds.value = 3;
      roundDurationMinutes.value = 2; // Rounded to 2 min
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
    final matchId = 'TKD_${DateTime.now().millisecondsSinceEpoch}';
    currentMatchId.value = matchId;

    final hong = Taekwondoin(
      id: hongFighterFriend.value?.email ?? 'hong_red',
      name: hongFighterName.value.isNotEmpty ? hongFighterName.value : 'HONG (Red)',
      weightClass: weightClass.value,
    );

    final chong = Taekwondoin(
      id: chongFighterFriend.value?.email ?? 'chong_blue',
      name: chongFighterName.value.isNotEmpty ? chongFighterName.value : 'CHONG (Blue)',
      weightClass: weightClass.value,
    );

    final config = TaekwondoMatchConfig(
      category: category.value,
      totalRounds: totalRounds.value,
      roundDurationMinutes: roundDurationMinutes.value,
      restDurationSeconds: restDurationSeconds.value,
      pointGapThreshold: 12,
    );

    final initState = TaekwondoMatchState.initial(
      hongFighter: hong,
      chongFighter: chong,
      config: config,
    );

    engine = TaekwondoMatchEngine(initState);
    liveState.value = engine.state;
    isEngineReady.value = true;
    isMatchStarted.value = true;

    _startTimer();

    final user = FirebaseAuth.instance.currentUser;
    final userId = user?.uid ?? 'local_user';

    final model = TaekwondoMatchModel(
      matchId: matchId,
      userId: userId,
      hongFighter: hong.name,
      chongFighter: chong.name,
      hongScore: 0,
      chongScore: 0,
      currentRoundDisplay: 'Round 1 / ${config.totalRounds}',
      isCompleted: false,
      matchResult: '',
      engineState: engine.state.toJson(),
    );

    currentMatch.value = model;

    try {
      await TaekwondoSqfliteService.insertMatch(model);
    } catch (_) {}

    try {
      await FirebaseFirestore.instance
          .collection('taekwondo_matches')
          .doc(matchId)
          .set(model.toFirebaseJson());
    } catch (_) {}

    _listenToFirestore(matchId);

    isLoading.value = false;
    Get.off(() => const TaekwondoScoreboardScreen());
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
          endRound();
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
        .collection('taekwondo_matches')
        .doc(matchId)
        .snapshots()
        .listen((doc) {
      if (doc.exists && doc.data() != null) {
        final remoteModel = TaekwondoMatchModel.fromFirebaseJson(doc.data()!);
        if (remoteModel.userId != FirebaseAuth.instance.currentUser?.uid) {
          isReadOnly.value = true;
          currentMatch.value = remoteModel;
          if (remoteModel.engineState != null) {
            final remoteState = TaekwondoMatchState.fromJson(remoteModel.engineState!);
            liveState.value = remoteState;
          }
        }
      }
    });
  }

  void scorePoints(String scoringSide, int points) {
    if (isReadOnly.value || liveState.value == null) return;
    engine.scorePoints(scoringSide, points);
    liveState.value = engine.state;
    _syncMatchState();

    if (engine.state.isMatchFinished) {
      finishMatch();
    }
  }

  void recordGamJeom(String foulSide) {
    if (isReadOnly.value || liveState.value == null) return;
    engine.recordGamJeom(foulSide);
    liveState.value = engine.state;
    _syncMatchState();

    if (engine.state.isMatchFinished) {
      finishMatch();
    }
  }

  void recordDisqualification(String dqSide) {
    if (isReadOnly.value || liveState.value == null) return;
    engine.recordDisqualification(dqSide);
    liveState.value = engine.state;

    final winnerName = dqSide == 'hong' ? engine.state.chongFighter.name : engine.state.hongFighter.name;
    final result = '$winnerName won by PUN (Disqualification)!';

    _syncMatchState(isFinished: true, result: result);
  }

  void endRound() {
    if (isReadOnly.value || liveState.value == null) return;
    engine.endRound();
    liveState.value = engine.state;

    if (engine.state.isMatchFinished) {
      finishMatch();
    } else {
      _startTimer();
      _syncMatchState();
    }
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
        'Stoppage undone. Taekwondo match resumed!',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: AppColors.cardSurface,
        colorText: Colors.white,
      );
    }
  }

  void finishMatch() {
    _timer?.cancel();
    isTimerRunning.value = false;

    final scoreA = engine.state.sideAPoints;
    final scoreB = engine.state.sideBPoints;
    final nameA = engine.state.hongFighter.name;
    final nameB = engine.state.chongFighter.name;

    String result = 'DRAW';
    if (engine.state.victoryType != null && engine.state.winnerSide != null) {
      final winnerName = engine.state.winnerSide == 'hong' ? nameA : (engine.state.winnerSide == 'chong' ? nameB : 'Draw');
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
    final updated = TaekwondoMatchModel(
      matchId: currentMatch.value!.matchId,
      userId: currentMatch.value!.userId,
      hongFighter: currentMatch.value!.hongFighter,
      chongFighter: currentMatch.value!.chongFighter,
      hongScore: engine.state.sideAPoints,
      chongScore: engine.state.sideBPoints,
      currentRoundDisplay: 'Round ${engine.state.currentRound} / ${engine.state.config.totalRounds}',
      isCompleted: isFinished || engine.state.isMatchFinished,
      matchResult: result.isNotEmpty ? result : currentMatch.value!.matchResult,
      engineState: engine.state.toJson(),
      updatedAt: DateTime.now(),
    );

    currentMatch.value = updated;
    try {
      await TaekwondoSqfliteService.updateMatch(updated);
    } catch (_) {}

    try {
      await FirebaseFirestore.instance
          .collection('taekwondo_matches')
          .doc(updated.matchId)
          .set(updated.toFirebaseJson(), SetOptions(merge: true));
    } catch (_) {}
  }

  Future<void> restoreTaekwondoMatchFromSqflite(TaekwondoMatchModel matchModel) async {
    currentMatchId.value = matchModel.matchId;
    currentMatch.value = matchModel;
    isReadOnly.value = false;

    if (matchModel.engineState != null) {
      final restoredState = TaekwondoMatchState.fromJson(matchModel.engineState!);
      engine = TaekwondoMatchEngine(restoredState);
      liveState.value = engine.state;
      isEngineReady.value = true;
      isMatchStarted.value = true;
      _listenToFirestore(matchModel.matchId);
    }
  }

  static Future<void> resumeMatch(String matchId) async {
    final controller = Get.isRegistered<TaekwondoController>()
        ? Get.find<TaekwondoController>()
        : Get.put(TaekwondoController());

    final matchData = await TaekwondoSqfliteService.getMatchById(matchId);
    if (matchData != null) {
      await controller.restoreTaekwondoMatchFromSqflite(matchData);
      Get.to(() => const TaekwondoScoreboardScreen());
    }
  }
}
