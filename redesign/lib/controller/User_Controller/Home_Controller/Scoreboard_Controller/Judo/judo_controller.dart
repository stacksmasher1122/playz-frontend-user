import 'dart:async';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:redesign/theme/app_colors.dart';
import 'package:redesign/model/User_Models/Home_Models/Scoreboard_Model/Judo/judo_state_models.dart';
import 'package:redesign/model/User_Models/Home_Models/Scoreboard_Model/Judo/judo_model.dart';
import 'package:redesign/model/User_Models/Home_Models/Friends_Model/friends_model.dart';
import 'package:redesign/sqflite/User_SQF/Home_SQF/Scoreboard_SQF/judoSqflite.dart';
import 'package:redesign/view/USER/Home/Scoreboard/Judo/live_match/judo_scoreboard_screen.dart';

class JudoController extends GetxController {
  final TextEditingController whiteFighterController = TextEditingController(text: 'WHITE Corner');
  final TextEditingController blueFighterController = TextEditingController(text: 'BLUE Corner');

  final RxString whiteFighterName = 'WHITE Corner'.obs;
  final RxString blueFighterName = 'BLUE Corner'.obs;

  final Rxn<FriendModel> whiteFighterFriend = Rxn<FriendModel>();
  final Rxn<FriendModel> blueFighterFriend = Rxn<FriendModel>();

  final RxString category = 'SENIOR_4MIN'.obs; // 'SENIOR_4MIN', 'CADET_3MIN', 'CUSTOM'
  final RxInt contestDurationMinutes = 4.obs; // 2, 3, 4, 5
  final RxString weightClass = 'OPEN'.obs;

  // Live Scoreboard State Guards
  final RxBool isMatchStarted = false.obs;
  final Rxn<JudoMatchModel> currentMatch = Rxn<JudoMatchModel>();
  final Rxn<JudoMatchState> liveState = Rxn<JudoMatchState>();
  late JudoMatchEngine engine;

  final RxString currentMatchId = ''.obs;
  final RxBool isLoading = false.obs;
  final RxBool isEngineReady = false.obs;
  final RxBool isReadOnly = false.obs;
  final RxBool hasMatchEndUndoBeenUsed = false.obs;

  // Contest Timer
  Timer? _contestTimer;
  final RxBool isTimerRunning = false.obs;

  // Osaekomi Timer
  Timer? _osaekomiTimer;

  StreamSubscription<DocumentSnapshot>? _firestoreSubscription;

  @override
  void onInit() {
    super.onInit();
    whiteFighterController.addListener(() {
      whiteFighterName.value = whiteFighterController.text;
    });
    blueFighterController.addListener(() {
      blueFighterName.value = blueFighterController.text;
    });
  }

  @override
  void onClose() {
    _contestTimer?.cancel();
    _osaekomiTimer?.cancel();
    _firestoreSubscription?.cancel();
    super.onClose();
  }

  void resetSetupScreen() {
    whiteFighterController.text = 'WHITE Corner';
    blueFighterController.text = 'BLUE Corner';
    whiteFighterName.value = 'WHITE Corner';
    blueFighterName.value = 'BLUE Corner';
    whiteFighterFriend.value = null;
    blueFighterFriend.value = null;
    category.value = 'SENIOR_4MIN';
    contestDurationMinutes.value = 4;
    weightClass.value = 'OPEN';
  }

  void setCategory(String cat) {
    category.value = cat;
    if (cat == 'SENIOR_4MIN') {
      contestDurationMinutes.value = 4;
    } else if (cat == 'CADET_3MIN') {
      contestDurationMinutes.value = 3;
    }
  }

  void incrementContestDuration() {
    if (contestDurationMinutes.value < 10) {
      contestDurationMinutes.value++;
    }
  }

  void decrementContestDuration() {
    if (contestDurationMinutes.value > 1) {
      contestDurationMinutes.value--;
    }
  }

  Future<void> startMatchFromSetup() async {
    isLoading.value = true;
    final matchId = 'JUDO_${DateTime.now().millisecondsSinceEpoch}';
    currentMatchId.value = matchId;

    final white = Judoka(
      id: whiteFighterFriend.value?.email ?? 'white_corner',
      name: whiteFighterName.value.isNotEmpty ? whiteFighterName.value : 'WHITE Corner',
      weightClass: weightClass.value,
    );

    final blue = Judoka(
      id: blueFighterFriend.value?.email ?? 'blue_corner',
      name: blueFighterName.value.isNotEmpty ? blueFighterName.value : 'BLUE Corner',
      weightClass: weightClass.value,
    );

    final config = JudoMatchConfig(
      category: category.value,
      contestDurationMinutes: contestDurationMinutes.value,
      osaekomiTimerEnabled: true,
    );

    final initState = JudoMatchState.initial(
      whiteFighter: white,
      blueFighter: blue,
      config: config,
    );

    engine = JudoMatchEngine(initState);
    liveState.value = engine.state;
    isEngineReady.value = true;
    isMatchStarted.value = true;

    _startTimer();

    final user = FirebaseAuth.instance.currentUser;
    final userId = user?.uid ?? 'local_user';

    final model = JudoMatchModel(
      matchId: matchId,
      userId: userId,
      whiteFighter: white.name,
      blueFighter: blue.name,
      whiteWazaAri: 0,
      blueWazaAri: 0,
      currentContestDisplay: 'Judo Contest (${config.contestDurationMinutes} Min)',
      isCompleted: false,
      matchResult: '',
      engineState: engine.state.toJson(),
    );

    currentMatch.value = model;

    try {
      await JudoSqfliteService.insertMatch(model);
    } catch (_) {}

    try {
      await FirebaseFirestore.instance
          .collection('judo_matches')
          .doc(matchId)
          .set(model.toFirebaseJson());
    } catch (_) {}

    _listenToFirestore(matchId);

    isLoading.value = false;
    Get.off(() => const JudoScoreboardScreen());
  }

  void _startTimer() {
    _contestTimer?.cancel();
    isTimerRunning.value = true;
    _contestTimer = Timer.periodic(const Duration(seconds: 1), (t) {
      if (liveState.value == null || isReadOnly.value) return;
      final curTime = liveState.value!.contestTimeRemaining;
      if (curTime > 0) {
        liveState.value = liveState.value!.copyWith(contestTimeRemaining: curTime - 1);
      } else {
        _contestTimer?.cancel();
        isTimerRunning.value = false;
        finishContest();
      }
    });
  }

  void toggleTimer() {
    if (isTimerRunning.value) {
      _contestTimer?.cancel();
      isTimerRunning.value = false;
    } else {
      _startTimer();
    }
  }

  void _listenToFirestore(String matchId) {
    _firestoreSubscription?.cancel();
    _firestoreSubscription = FirebaseFirestore.instance
        .collection('judo_matches')
        .doc(matchId)
        .snapshots()
        .listen((doc) {
      if (doc.exists && doc.data() != null) {
        final remoteModel = JudoMatchModel.fromFirebaseJson(doc.data()!);
        if (remoteModel.userId != FirebaseAuth.instance.currentUser?.uid) {
          isReadOnly.value = true;
          currentMatch.value = remoteModel;
          if (remoteModel.engineState != null) {
            final remoteState = JudoMatchState.fromJson(remoteModel.engineState!);
            liveState.value = remoteState;
          }
        }
      }
    });
  }

  void scoreIppon(String scoringSide) {
    if (isReadOnly.value || liveState.value == null) return;
    _stopOsaekomiTimerInternal();
    engine.scoreIppon(scoringSide);
    liveState.value = engine.state;
    _syncMatchState();

    if (engine.state.isMatchFinished) {
      finishMatch();
    }
  }

  void scoreWazaAri(String scoringSide) {
    if (isReadOnly.value || liveState.value == null) return;
    engine.scoreWazaAri(scoringSide);
    liveState.value = engine.state;
    _syncMatchState();

    if (engine.state.isMatchFinished) {
      finishMatch();
    }
  }

  void startOsaekomi(String pinSide) {
    if (isReadOnly.value || liveState.value == null) return;
    engine.startOsaekomi(pinSide);
    liveState.value = engine.state;
    _startOsaekomiTimer();
    _syncMatchState();
  }

  void _startOsaekomiTimer() {
    _osaekomiTimer?.cancel();
    _osaekomiTimer = Timer.periodic(const Duration(seconds: 1), (t) {
      if (liveState.value == null || !liveState.value!.isOsaekomiActive) {
        t.cancel();
        return;
      }
      engine.tickOsaekomi();
      liveState.value = engine.state;
      _syncMatchState();

      if (engine.state.isMatchFinished) {
        t.cancel();
        finishMatch();
      }
    });
  }

  void stopOsaekomiToketa() {
    if (isReadOnly.value || liveState.value == null) return;
    _stopOsaekomiTimerInternal();
    engine.stopOsaekomiToketa();
    liveState.value = engine.state;
    _syncMatchState();

    if (engine.state.isMatchFinished) {
      finishMatch();
    }
  }

  void _stopOsaekomiTimerInternal() {
    _osaekomiTimer?.cancel();
  }

  void recordShido(String foulSide) {
    if (isReadOnly.value || liveState.value == null) return;
    engine.recordShido(foulSide);
    liveState.value = engine.state;
    _syncMatchState();

    if (engine.state.isMatchFinished) {
      finishMatch();
    }
  }

  void recordHansokuMake(String dqSide) {
    if (isReadOnly.value || liveState.value == null) return;
    _stopOsaekomiTimerInternal();
    engine.recordHansokuMake(dqSide);
    liveState.value = engine.state;

    final winnerName = dqSide == 'white' ? engine.state.blueFighter.name : engine.state.whiteFighter.name;
    final result = '$winnerName won by Hansoku-make (Disqualification)!';

    _syncMatchState(isFinished: true, result: result);
  }

  void finishContest() {
    if (isReadOnly.value || liveState.value == null) return;
    _stopOsaekomiTimerInternal();
    engine.finishContest();
    liveState.value = engine.state;

    if (engine.state.isMatchFinished) {
      finishMatch();
    } else {
      _syncMatchState();
    }
  }

  void undoLastAction() {
    if (isReadOnly.value) return;
    _stopOsaekomiTimerInternal();
    if (engine.canUndo) {
      engine.undo();
      liveState.value = engine.state;
      _syncMatchState();
    }
  }

  void undoLastMatchPoint() {
    if (isReadOnly.value || hasMatchEndUndoBeenUsed.value) return;
    _stopOsaekomiTimerInternal();
    if (engine.canUndo) {
      engine.undo();
      liveState.value = engine.state;
      hasMatchEndUndoBeenUsed.value = true;
      isMatchStarted.value = true;
      _startTimer();
      _syncMatchState();
      Get.snackbar(
        'Match End Undone',
        'Stoppage undone. Judo contest resumed!',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: AppColors.cardSurface,
        colorText: Colors.white,
      );
    }
  }

  void finishMatch() {
    _contestTimer?.cancel();
    _stopOsaekomiTimerInternal();
    isTimerRunning.value = false;

    final wWaza = engine.state.whiteFighter.wazaAriCount;
    final bWaza = engine.state.blueFighter.wazaAriCount;
    final nameW = engine.state.whiteFighter.name;
    final nameB = engine.state.blueFighter.name;

    String result = 'DRAW';
    if (engine.state.victoryType != null && engine.state.winnerSide != null) {
      final winnerName = engine.state.winnerSide == 'white' ? nameW : (engine.state.winnerSide == 'blue' ? nameB : 'Draw');
      result = '$winnerName won by ${engine.state.victoryType}';
    } else if (wWaza > bWaza) {
      result = '$nameW won by Waza-ari Advantage ($wWaza - $bWaza)';
    } else if (bWaza > wWaza) {
      result = '$nameB won by Waza-ari Advantage ($bWaza - $wWaza)';
    }

    _syncMatchState(isFinished: true, result: result);
  }

  Future<void> _syncMatchState({bool isFinished = false, String result = ''}) async {
    if (currentMatch.value == null) return;
    final updated = JudoMatchModel(
      matchId: currentMatch.value!.matchId,
      userId: currentMatch.value!.userId,
      whiteFighter: currentMatch.value!.whiteFighter,
      blueFighter: currentMatch.value!.blueFighter,
      whiteWazaAri: engine.state.whiteFighter.wazaAriCount,
      blueWazaAri: engine.state.blueFighter.wazaAriCount,
      currentContestDisplay: 'Judo Contest (${engine.state.config.contestDurationMinutes} Min)',
      isCompleted: isFinished || engine.state.isMatchFinished,
      matchResult: result.isNotEmpty ? result : currentMatch.value!.matchResult,
      engineState: engine.state.toJson(),
      updatedAt: DateTime.now(),
    );

    currentMatch.value = updated;
    try {
      await JudoSqfliteService.updateMatch(updated);
    } catch (_) {}

    try {
      await FirebaseFirestore.instance
          .collection('judo_matches')
          .doc(updated.matchId)
          .set(updated.toFirebaseJson(), SetOptions(merge: true));
    } catch (_) {}
  }

  Future<void> restoreJudoMatchFromSqflite(JudoMatchModel matchModel) async {
    currentMatchId.value = matchModel.matchId;
    currentMatch.value = matchModel;
    isReadOnly.value = false;

    if (matchModel.engineState != null) {
      final restoredState = JudoMatchState.fromJson(matchModel.engineState!);
      engine = JudoMatchEngine(restoredState);
      liveState.value = engine.state;
      isEngineReady.value = true;
      isMatchStarted.value = true;
      _listenToFirestore(matchModel.matchId);
    }
  }

  static Future<void> resumeMatch(String matchId) async {
    final controller = Get.isRegistered<JudoController>()
        ? Get.find<JudoController>()
        : Get.put(JudoController());

    final matchData = await JudoSqfliteService.getMatchById(matchId);
    if (matchData != null) {
      await controller.restoreJudoMatchFromSqflite(matchData);
      Get.to(() => const JudoScoreboardScreen());
    }
  }
}
