import 'dart:async';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:redesign/theme/app_colors.dart';
import 'package:redesign/model/User_Models/Home_Models/Scoreboard_Model/Karate/karate_state_models.dart';
import 'package:redesign/model/User_Models/Home_Models/Scoreboard_Model/Karate/karate_model.dart';
import 'package:redesign/model/User_Models/Home_Models/Friends_Model/friends_model.dart';
import 'package:redesign/sqflite/User_SQF/Home_SQF/Scoreboard_SQF/karateSqflite.dart';
import 'package:redesign/view/USER/Home/Scoreboard/Karate/live_match/karate_scoreboard_screen.dart';

class KarateController extends GetxController {
  final TextEditingController akaFighterController = TextEditingController(text: 'AKA (Red)');
  final TextEditingController aoFighterController = TextEditingController(text: 'AO (Blue)');

  final RxString akaFighterName = 'AKA (Red)'.obs;
  final RxString aoFighterName = 'AO (Blue)'.obs;

  final Rxn<FriendModel> akaFighterFriend = Rxn<FriendModel>();
  final Rxn<FriendModel> aoFighterFriend = Rxn<FriendModel>();

  final RxString category = 'SENIOR_3MIN'.obs; // 'SENIOR_3MIN', 'JUNIOR_2MIN', 'CUSTOM'
  final RxInt boutDurationMinutes = 3.obs; // 1, 2, 3, 4
  final RxString weightClass = 'OPEN'.obs;
  final RxBool senshuRuleEnabled = true.obs;

  // Live Scoreboard State Guards
  final RxBool isMatchStarted = false.obs;
  final Rxn<KarateMatchModel> currentMatch = Rxn<KarateMatchModel>();
  final Rxn<KarateMatchState> liveState = Rxn<KarateMatchState>();
  late KarateMatchEngine engine;

  final RxString currentMatchId = ''.obs;
  final RxBool isLoading = false.obs;
  final RxBool isEngineReady = false.obs;
  final RxBool isReadOnly = false.obs;
  final RxBool hasMatchEndUndoBeenUsed = false.obs;

  // Bout Timer
  Timer? _boutTimer;
  final RxBool isTimerRunning = false.obs;

  StreamSubscription<DocumentSnapshot>? _firestoreSubscription;

  @override
  void onInit() {
    super.onInit();
    akaFighterController.addListener(() {
      akaFighterName.value = akaFighterController.text;
    });
    aoFighterController.addListener(() {
      aoFighterName.value = aoFighterController.text;
    });
  }

  @override
  void onClose() {
    _boutTimer?.cancel();
    _firestoreSubscription?.cancel();
    super.onClose();
  }

  void resetSetupScreen() {
    akaFighterController.text = 'AKA (Red)';
    aoFighterController.text = 'AO (Blue)';
    akaFighterName.value = 'AKA (Red)';
    aoFighterName.value = 'AO (Blue)';
    akaFighterFriend.value = null;
    aoFighterFriend.value = null;
    category.value = 'SENIOR_3MIN';
    boutDurationMinutes.value = 3;
    weightClass.value = 'OPEN';
    senshuRuleEnabled.value = true;
  }

  void setCategory(String cat) {
    category.value = cat;
    if (cat == 'SENIOR_3MIN') {
      boutDurationMinutes.value = 3;
    } else if (cat == 'JUNIOR_2MIN') {
      boutDurationMinutes.value = 2;
    }
  }

  void incrementBoutDuration() {
    if (boutDurationMinutes.value < 5) {
      boutDurationMinutes.value++;
    }
  }

  void decrementBoutDuration() {
    if (boutDurationMinutes.value > 1) {
      boutDurationMinutes.value--;
    }
  }

  Future<void> startMatchFromSetup() async {
    isLoading.value = true;
    final matchId = 'KARATE_${DateTime.now().millisecondsSinceEpoch}';
    currentMatchId.value = matchId;

    final aka = Karateka(
      id: akaFighterFriend.value?.email ?? 'aka_red',
      name: akaFighterName.value.isNotEmpty ? akaFighterName.value : 'AKA (Red)',
      weightClass: weightClass.value,
    );

    final ao = Karateka(
      id: aoFighterFriend.value?.email ?? 'ao_blue',
      name: aoFighterName.value.isNotEmpty ? aoFighterName.value : 'AO (Blue)',
      weightClass: weightClass.value,
    );

    final config = KarateMatchConfig(
      category: category.value,
      boutDurationMinutes: boutDurationMinutes.value,
      senshuRuleEnabled: senshuRuleEnabled.value,
      maxLeadSuperiority: 8,
    );

    final initState = KarateMatchState.initial(
      akaFighter: aka,
      aoFighter: ao,
      config: config,
    );

    engine = KarateMatchEngine(initState);
    liveState.value = engine.state;
    isEngineReady.value = true;
    isMatchStarted.value = true;

    _startTimer();

    final user = FirebaseAuth.instance.currentUser;
    final userId = user?.uid ?? 'local_user';

    final model = KarateMatchModel(
      matchId: matchId,
      userId: userId,
      akaFighter: aka.name,
      aoFighter: ao.name,
      akaScore: 0,
      aoScore: 0,
      currentBoutDisplay: 'Kumite Bout (${config.boutDurationMinutes} Min)',
      isCompleted: false,
      matchResult: '',
      engineState: engine.state.toJson(),
    );

    currentMatch.value = model;

    try {
      await KarateSqfliteService.insertMatch(model);
    } catch (_) {}

    try {
      await FirebaseFirestore.instance
          .collection('karate_matches')
          .doc(matchId)
          .set(model.toFirebaseJson());
    } catch (_) {}

    _listenToFirestore(matchId);

    isLoading.value = false;
    Get.off(() => const KarateScoreboardScreen());
  }

  void _startTimer() {
    _boutTimer?.cancel();
    isTimerRunning.value = true;
    _boutTimer = Timer.periodic(const Duration(seconds: 1), (t) {
      if (liveState.value == null || isReadOnly.value) return;
      final curTime = liveState.value!.boutTimeRemaining;
      if (curTime > 0) {
        liveState.value = liveState.value!.copyWith(boutTimeRemaining: curTime - 1);
      } else {
        _boutTimer?.cancel();
        isTimerRunning.value = false;
        finishBout();
      }
    });
  }

  void toggleTimer() {
    if (isTimerRunning.value) {
      _boutTimer?.cancel();
      isTimerRunning.value = false;
    } else {
      _startTimer();
    }
  }

  void _listenToFirestore(String matchId) {
    _firestoreSubscription?.cancel();
    _firestoreSubscription = FirebaseFirestore.instance
        .collection('karate_matches')
        .doc(matchId)
        .snapshots()
        .listen((doc) {
      if (doc.exists && doc.data() != null) {
        final remoteModel = KarateMatchModel.fromFirebaseJson(doc.data()!);
        if (remoteModel.userId != FirebaseAuth.instance.currentUser?.uid) {
          isReadOnly.value = true;
          currentMatch.value = remoteModel;
          if (remoteModel.engineState != null) {
            final remoteState = KarateMatchState.fromJson(remoteModel.engineState!);
            liveState.value = remoteState;
          }
        }
      }
    });
  }

  void scoreYuko(String scoringSide) {
    if (isReadOnly.value || liveState.value == null) return;
    engine.scorePoints(scoringSide, 1);
    liveState.value = engine.state;
    _syncMatchState();

    if (engine.state.isMatchFinished) {
      finishMatch();
    }
  }

  void scoreWazaAri(String scoringSide) {
    if (isReadOnly.value || liveState.value == null) return;
    engine.scorePoints(scoringSide, 2);
    liveState.value = engine.state;
    _syncMatchState();

    if (engine.state.isMatchFinished) {
      finishMatch();
    }
  }

  void scoreIppon(String scoringSide) {
    if (isReadOnly.value || liveState.value == null) return;
    engine.scorePoints(scoringSide, 3);
    liveState.value = engine.state;
    _syncMatchState();

    if (engine.state.isMatchFinished) {
      finishMatch();
    }
  }

  void recordPenalty(String foulSide) {
    if (isReadOnly.value || liveState.value == null) return;
    engine.recordPenalty(foulSide);
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

    final winnerName = dqSide == 'aka' ? engine.state.aoFighter.name : engine.state.akaFighter.name;
    final result = '$winnerName won by Hansoku (Disqualification)!';

    _syncMatchState(isFinished: true, result: result);
  }

  void stopMatch(String victoryType, String winnerSide) {
    if (isReadOnly.value || liveState.value == null) return;
    engine.stopMatch(victoryType, winnerSide);
    liveState.value = engine.state;

    final winnerName = winnerSide == 'aka' ? engine.state.akaFighter.name : engine.state.aoFighter.name;
    final result = '$winnerName won by $victoryType!';

    _syncMatchState(isFinished: true, result: result);
  }

  void finishBout() {
    if (isReadOnly.value || liveState.value == null) return;
    engine.finishBout();
    liveState.value = engine.state;
    finishMatch();
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
        'Stoppage undone. Kumite bout resumed!',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: AppColors.cardSurface,
        colorText: Colors.white,
      );
    }
  }

  void finishMatch() {
    _boutTimer?.cancel();
    isTimerRunning.value = false;

    final scoreA = engine.state.sideAPoints;
    final scoreB = engine.state.sideBPoints;
    final nameA = engine.state.akaFighter.name;
    final nameB = engine.state.aoFighter.name;

    String result = 'DRAW';
    if (engine.state.victoryType != null && engine.state.winnerSide != null) {
      final winnerName = engine.state.winnerSide == 'aka' ? nameA : (engine.state.winnerSide == 'ao' ? nameB : 'Draw');
      if (winnerName == 'Draw') {
        result = 'DRAW ($scoreA - $scoreB)';
      } else {
        result = '$winnerName won by ${engine.state.victoryType} ($scoreA - $scoreB)';
      }
    } else if (scoreA > scoreB) {
      result = '$nameA won by Points ($scoreA - $scoreB)';
    } else if (scoreB > scoreA) {
      result = '$nameB won by Points ($scoreB - $scoreA)';
    }

    _syncMatchState(isFinished: true, result: result);
  }

  Future<void> _syncMatchState({bool isFinished = false, String result = ''}) async {
    if (currentMatch.value == null) return;
    final updated = KarateMatchModel(
      matchId: currentMatch.value!.matchId,
      userId: currentMatch.value!.userId,
      akaFighter: currentMatch.value!.akaFighter,
      aoFighter: currentMatch.value!.aoFighter,
      akaScore: engine.state.sideAPoints,
      aoScore: engine.state.sideBPoints,
      currentBoutDisplay: 'Kumite Bout (${engine.state.config.boutDurationMinutes} Min)',
      isCompleted: isFinished || engine.state.isMatchFinished,
      matchResult: result.isNotEmpty ? result : currentMatch.value!.matchResult,
      engineState: engine.state.toJson(),
      updatedAt: DateTime.now(),
    );

    currentMatch.value = updated;
    try {
      await KarateSqfliteService.updateMatch(updated);
    } catch (_) {}

    try {
      await FirebaseFirestore.instance
          .collection('karate_matches')
          .doc(updated.matchId)
          .set(updated.toFirebaseJson(), SetOptions(merge: true));
    } catch (_) {}
  }

  Future<void> restoreKarateMatchFromSqflite(KarateMatchModel matchModel) async {
    currentMatchId.value = matchModel.matchId;
    currentMatch.value = matchModel;
    isReadOnly.value = false;

    if (matchModel.engineState != null) {
      final restoredState = KarateMatchState.fromJson(matchModel.engineState!);
      engine = KarateMatchEngine(restoredState);
      liveState.value = engine.state;
      isEngineReady.value = true;
      isMatchStarted.value = true;
      _listenToFirestore(matchModel.matchId);
    }
  }

  static Future<void> resumeMatch(String matchId) async {
    final controller = Get.isRegistered<KarateController>()
        ? Get.find<KarateController>()
        : Get.put(KarateController());

    final matchData = await KarateSqfliteService.getMatchById(matchId);
    if (matchData != null) {
      await controller.restoreKarateMatchFromSqflite(matchData);
      Get.to(() => const KarateScoreboardScreen());
    }
  }
}
