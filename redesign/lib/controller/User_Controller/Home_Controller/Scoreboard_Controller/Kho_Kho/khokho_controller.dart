import 'dart:async';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:redesign/theme/app_colors.dart';
import 'package:redesign/model/User_Models/Home_Models/Scoreboard_Model/Kho_Kho/khokho_state_models.dart';
import 'package:redesign/model/User_Models/Home_Models/Scoreboard_Model/Kho_Kho/khokho_model.dart';
import 'package:redesign/model/User_Models/Home_Models/Friends_Model/friends_model.dart';
import 'package:redesign/sqflite/User_SQF/Home_SQF/Scoreboard_SQF/khokhoSqflite.dart';
import 'package:redesign/view/USER/Home/Scoreboard/coin_toss/coin_toss_screen.dart';
import 'package:redesign/view/USER/Home/Scoreboard/Kho_Kho/live_match/khokho_scoreboard_screen.dart';

class KhoKhoController extends GetxController {
  final TextEditingController homeTeamController = TextEditingController(text: 'Side A');
  final TextEditingController awayTeamController = TextEditingController(text: 'Side B');

  final RxString homeTeamName = 'Side A'.obs;
  final RxString awayTeamName = 'Side B'.obs;

  final RxList<FriendModel> teamARoster = <FriendModel>[].obs;
  final RxList<FriendModel> teamBRoster = <FriendModel>[].obs;
  final RxList<String> teamAPlayers = <String>[].obs;
  final RxList<String> teamBPlayers = <String>[].obs;

  final RxInt squadLimit = 12.obs; // KKFI 12v12 default
  final RxInt turnDurationMinutes = 9.obs; // 9m or 7m
  final RxBool isProRules = true.obs;

  // Live Scoreboard State Guards
  final RxBool isMatchStarted = false.obs;
  final Rxn<KhoKhoMatchModel> currentMatch = Rxn<KhoKhoMatchModel>();
  final Rxn<KhoKhoMatchState> liveState = Rxn<KhoKhoMatchState>();
  late KhoKhoMatchEngine engine;

  final RxString currentMatchId = ''.obs;
  final RxBool isLoading = false.obs;
  final RxBool isEngineReady = false.obs;
  final RxBool isReadOnly = false.obs;
  final RxBool hasMatchEndUndoBeenUsed = false.obs;

  StreamSubscription<DocumentSnapshot>? _firestoreSubscription;

  @override
  void onInit() {
    super.onInit();
    homeTeamController.addListener(() {
      homeTeamName.value = homeTeamController.text;
    });
    awayTeamController.addListener(() {
      awayTeamName.value = awayTeamController.text;
    });
  }

  @override
  void onClose() {
    _firestoreSubscription?.cancel();
    super.onClose();
  }

  void resetSetupScreen() {
    homeTeamController.text = 'Side A';
    awayTeamController.text = 'Side B';
    homeTeamName.value = 'Side A';
    awayTeamName.value = 'Side B';
    teamARoster.clear();
    teamBRoster.clear();
    teamAPlayers.clear();
    teamBPlayers.clear();
    squadLimit.value = 12;
    turnDurationMinutes.value = 9;
    isProRules.value = true;
  }

  void incrementSquadLimit() {
    if (squadLimit.value < 12) squadLimit.value++;
  }

  void decrementSquadLimit() {
    if (squadLimit.value > 6) squadLimit.value--;
  }

  void setTurnDuration(int mins) {
    turnDurationMinutes.value = mins;
  }

  void toggleProRules(bool value) {
    isProRules.value = value;
    if (value) {
      turnDurationMinutes.value = 9;
      squadLimit.value = 12;
    } else {
      turnDurationMinutes.value = 7;
    }
  }

  void addTeamPlayer(bool isTeamA, FriendModel player) {
    final roster = isTeamA ? teamARoster : teamBRoster;
    final playersList = isTeamA ? teamAPlayers : teamBPlayers;

    if (roster.length >= squadLimit.value) {
      Get.snackbar(
        'Limit Reached',
        'Cannot add more than ${squadLimit.value} players.',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: AppColors.cardSurface,
        colorText: Colors.white,
      );
      return;
    }

    if (teamAPlayers.contains(player.email) || teamBPlayers.contains(player.email)) {
      Get.snackbar(
        'Error',
        'Player already added.',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: AppColors.cardSurface,
        colorText: Colors.white,
      );
      return;
    }

    roster.add(player);
    playersList.add(player.email);
  }

  void removeTeamPlayer(bool isTeamA, FriendModel player) {
    final roster = isTeamA ? teamARoster : teamBRoster;
    final playersList = isTeamA ? teamAPlayers : teamBPlayers;

    roster.remove(player);
    playersList.remove(player.email);
  }

  void proceedToCoinToss(BuildContext context) {
    if (teamARoster.isEmpty || teamBRoster.isEmpty) {
      Get.snackbar(
        'Teams Required',
        'Please add players to both teams.',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: AppColors.cardSurface,
        colorText: Colors.white,
      );
      return;
    }

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => CoinFlipScreen(
          teamAName: homeTeamName.value.isNotEmpty ? homeTeamName.value : 'Side A',
          teamBName: awayTeamName.value.isNotEmpty ? awayTeamName.value : 'Side B',
          sport: 'kho_kho',
          onTossComplete: (winnerTeam, choice) async {
            // Choice: 'Chasing' or 'Running'
            final isSideAChasing = (winnerTeam == homeTeamName.value && choice.toLowerCase().contains('chasing')) ||
                (winnerTeam != homeTeamName.value && choice.toLowerCase().contains('running'));
            startMatchFromSetup(activeChasingTeam: isSideAChasing ? 'sideA' : 'sideB');
          },
        ),
      ),
    );
  }

  Future<void> startMatchFromSetup({String activeChasingTeam = 'sideA'}) async {
    isLoading.value = true;
    final matchId = 'KHOKHO_${DateTime.now().millisecondsSinceEpoch}';
    currentMatchId.value = matchId;

    final teamAPlayerModels = teamARoster
        .map((f) => KhoKhoPlayer(
              id: f.email,
              name: f.fullName.isNotEmpty ? f.fullName : f.email,
            ))
        .toList();

    final teamBPlayerModels = teamBRoster
        .map((f) => KhoKhoPlayer(
              id: f.email,
              name: f.fullName.isNotEmpty ? f.fullName : f.email,
            ))
        .toList();

    final config = KhoKhoMatchConfig(
      maxTurns: 4,
      turnDurationMinutes: turnDurationMinutes.value,
      isProRules: isProRules.value,
      squadLimit: squadLimit.value,
      defendersPerBatch: 3,
    );

    final initState = KhoKhoMatchState.initial(
      teamA: teamAPlayerModels,
      teamB: teamBPlayerModels,
      config: config,
      activeChasingTeam: activeChasingTeam,
    );

    engine = KhoKhoMatchEngine(initState);
    liveState.value = engine.state;
    isEngineReady.value = true;
    isMatchStarted.value = true; // Auto-started for instant scoring!

    final user = FirebaseAuth.instance.currentUser;
    final userId = user?.uid ?? 'local_user';

    final model = KhoKhoMatchModel(
      matchId: matchId,
      userId: userId,
      homeTeam: homeTeamName.value.isNotEmpty ? homeTeamName.value : 'Side A',
      awayTeam: awayTeamName.value.isNotEmpty ? awayTeamName.value : 'Side B',
      homePoints: 0,
      awayPoints: 0,
      currentTurnDisplay: 'Turn 1',
      isCompleted: false,
      matchResult: '',
      engineState: engine.state.toJson(),
    );

    currentMatch.value = model;

    try {
      await KhoKhoSqfliteService.insertMatch(model);
    } catch (_) {}

    try {
      await FirebaseFirestore.instance
          .collection('khokho_matches')
          .doc(matchId)
          .set(model.toFirebaseJson());
    } catch (_) {}

    _listenToFirestore(matchId);

    isLoading.value = false;
    Get.off(() => const KhoKhoScoreboardScreen());
  }

  void _listenToFirestore(String matchId) {
    _firestoreSubscription?.cancel();
    _firestoreSubscription = FirebaseFirestore.instance
        .collection('khokho_matches')
        .doc(matchId)
        .snapshots()
        .listen((doc) {
      if (doc.exists && doc.data() != null) {
        final remoteModel = KhoKhoMatchModel.fromFirebaseJson(doc.data()!);
        if (remoteModel.userId != FirebaseAuth.instance.currentUser?.uid) {
          isReadOnly.value = true;
          currentMatch.value = remoteModel;
          if (remoteModel.engineState != null) {
            final remoteState = KhoKhoMatchState.fromJson(remoteModel.engineState!);
            liveState.value = remoteState;
          }
        }
      }
    });
  }

  void scoreOut({bool isPoleDive = false}) {
    if (isReadOnly.value || liveState.value == null) return;
    final chasing = liveState.value!.activeChasingTeam;
    engine.scoreOut(chasing, isPoleDive: isPoleDive);
    liveState.value = engine.state;
    _syncMatchState();

    if (engine.state.isMatchFinished) {
      finishMatch();
    }
  }

  void awardDreamRun() {
    if (isReadOnly.value || liveState.value == null) return;
    final defending = liveState.value!.activeChasingTeam == 'sideA' ? 'sideB' : 'sideA';
    engine.awardDreamRun(defending);
    liveState.value = engine.state;
    _syncMatchState();
    Get.snackbar(
      'Dream Run!',
      'Bonus point awarded to defending team for surviving batch!',
      snackPosition: SnackPosition.BOTTOM,
      backgroundColor: AppColors.cardSurface,
      colorText: Colors.white,
    );
  }

  void advanceTurn() {
    if (isReadOnly.value) return;
    engine.advanceTurn();
    liveState.value = engine.state;
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

  void undoTurnCompletionPoint() {
    if (isReadOnly.value) return;
    if (engine.canUndo) {
      engine.undo();
      liveState.value = engine.state;
      _syncMatchState();
      Get.snackbar(
        'Turn Undone',
        'The turn-ending point was undone.',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: AppColors.cardSurface,
        colorText: Colors.white,
      );
    }
  }

  void undoLastMatchPoint() {
    if (isReadOnly.value || hasMatchEndUndoBeenUsed.value) return;
    if (engine.canUndo) {
      engine.undo();
      liveState.value = engine.state;
      hasMatchEndUndoBeenUsed.value = true;
      isMatchStarted.value = true;
      _syncMatchState();
      Get.snackbar(
        'Match End Undone',
        'The final point was undone. Match resumed!',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: AppColors.cardSurface,
        colorText: Colors.white,
      );
    }
  }

  void finishMatch() {
    engine.endMatch();
    liveState.value = engine.state;

    final winner = engine.state.matchWinner;
    String result = 'MATCH TIED';
    if (winner == 'sideA') {
      result = '${currentMatch.value?.homeTeam ?? "Side A"} won the match ${engine.state.pointsA}-${engine.state.pointsB} pts!';
    } else if (winner == 'sideB') {
      result = '${currentMatch.value?.awayTeam ?? "Side B"} won the match ${engine.state.pointsB}-${engine.state.pointsA} pts!';
    }

    _syncMatchState(isFinished: true, result: result);
  }

  Future<void> _syncMatchState({bool isFinished = false, String result = ''}) async {
    if (currentMatch.value == null) return;
    final updated = KhoKhoMatchModel(
      matchId: currentMatch.value!.matchId,
      userId: currentMatch.value!.userId,
      homeTeam: currentMatch.value!.homeTeam,
      awayTeam: currentMatch.value!.awayTeam,
      homePoints: engine.state.pointsA,
      awayPoints: engine.state.pointsB,
      currentTurnDisplay: 'Turn ${engine.state.currentTurn}',
      isCompleted: isFinished || engine.state.isMatchFinished,
      matchResult: result.isNotEmpty ? result : currentMatch.value!.matchResult,
      engineState: engine.state.toJson(),
      updatedAt: DateTime.now(),
    );

    currentMatch.value = updated;
    try {
      await KhoKhoSqfliteService.updateMatch(updated);
    } catch (_) {}

    try {
      await FirebaseFirestore.instance
          .collection('khokho_matches')
          .doc(updated.matchId)
          .set(updated.toFirebaseJson(), SetOptions(merge: true));
    } catch (_) {}
  }

  Future<void> restoreKhoKhoMatchFromSqflite(KhoKhoMatchModel matchModel) async {
    currentMatchId.value = matchModel.matchId;
    currentMatch.value = matchModel;
    isReadOnly.value = false;

    if (matchModel.engineState != null) {
      final restoredState = KhoKhoMatchState.fromJson(matchModel.engineState!);
      engine = KhoKhoMatchEngine(restoredState);
      liveState.value = engine.state;
      isEngineReady.value = true;
      isMatchStarted.value = true;
      _listenToFirestore(matchModel.matchId);
    }
  }

  static Future<void> resumeMatch(String matchId) async {
    final controller = Get.isRegistered<KhoKhoController>()
        ? Get.find<KhoKhoController>()
        : Get.put(KhoKhoController());

    final matchData = await KhoKhoSqfliteService.getMatchById(matchId);
    if (matchData != null) {
      await controller.restoreKhoKhoMatchFromSqflite(matchData);
      Get.to(() => const KhoKhoScoreboardScreen());
    }
  }
}
