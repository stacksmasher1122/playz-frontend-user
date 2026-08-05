import 'dart:async';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:redesign/theme/app_colors.dart';
import 'package:redesign/model/User_Models/Home_Models/Scoreboard_Model/Volleyball/volleyball_state_models.dart';
import 'package:redesign/model/User_Models/Home_Models/Scoreboard_Model/Volleyball/volleyball_model.dart';
import 'package:redesign/model/User_Models/Home_Models/Friends_Model/friends_model.dart';
import 'package:redesign/sqflite/User_SQF/Home_SQF/Scoreboard_SQF/volleyballSqflite.dart';
import 'package:redesign/view/USER/Home/Scoreboard/coin_toss/coin_toss_screen.dart';
import 'package:redesign/view/USER/Home/Scoreboard/Volleyball/live_match/volleyball_scoreboard_screen.dart';

class VolleyballController extends GetxController {
  final TextEditingController homeTeamController = TextEditingController(text: 'Side A');
  final TextEditingController awayTeamController = TextEditingController(text: 'Side B');

  final RxString homeTeamName = 'Side A'.obs;
  final RxString awayTeamName = 'Side B'.obs;

  final RxList<FriendModel> teamARoster = <FriendModel>[].obs;
  final RxList<FriendModel> teamBRoster = <FriendModel>[].obs;
  final RxList<String> teamAPlayers = <String>[].obs;
  final RxList<String> teamBPlayers = <String>[].obs;

  // Squad & Substitute controls
  final RxInt squadLimit = 6.obs; // FIVB 6v6 default
  final RxBool subsEnabled = true.obs;
  final RxInt maxSubstitutes = 6.obs;

  int get maxAllowedPlayers => squadLimit.value + (subsEnabled.value ? maxSubstitutes.value : 0);

  final RxInt maxSets = 5.obs; // Best of 1, 3, or 5
  final RxInt setTargetPoints = 25.obs; // 15, 21, 25
  final RxBool isProRules = true.obs;

  // Live Scoreboard State Guards
  final RxBool isMatchStarted = false.obs;
  final Rxn<VolleyballMatchModel> currentMatch = Rxn<VolleyballMatchModel>();
  final Rxn<VolleyballMatchState> liveState = Rxn<VolleyballMatchState>();
  late VolleyballMatchEngine engine;

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
    squadLimit.value = 6;
    subsEnabled.value = true;
    maxSubstitutes.value = 6;
    maxSets.value = 5;
    setTargetPoints.value = 25;
    isProRules.value = true;
  }

  void incrementSquadLimit() {
    if (squadLimit.value < 6) squadLimit.value++;
  }

  void decrementSquadLimit() {
    if (squadLimit.value > 1) squadLimit.value--;
  }

  void toggleSubs(bool value) {
    subsEnabled.value = value;
  }

  void incrementSubs() {
    if (maxSubstitutes.value < 6) maxSubstitutes.value++;
  }

  void decrementSubs() {
    if (maxSubstitutes.value > 0) maxSubstitutes.value--;
  }

  void toggleProRules(bool value) {
    isProRules.value = value;
    if (value) {
      maxSets.value = 5;
      setTargetPoints.value = 25;
      squadLimit.value = 6;
    } else {
      maxSets.value = 3;
      setTargetPoints.value = 21;
    }
  }

  void setMaxSets(int sets) {
    maxSets.value = sets;
  }

  void setSetTargetPoints(int pts) {
    setTargetPoints.value = pts;
  }

  void addTeamPlayer(bool isTeamA, FriendModel player) {
    final roster = isTeamA ? teamARoster : teamBRoster;
    final playersList = isTeamA ? teamAPlayers : teamBPlayers;

    final maxAllowed = squadLimit.value + (subsEnabled.value ? maxSubstitutes.value : 0);
    if (roster.length >= maxAllowed) {
      Get.snackbar(
        'Limit Reached',
        'Cannot add more than $maxAllowed players.',
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
          sport: 'volleyball',
          onTossComplete: (winnerTeam, choice) async {
            String initialServing = 'sideA';
            if (winnerTeam == (awayTeamName.value.isNotEmpty ? awayTeamName.value : 'Side B')) {
              initialServing = 'sideB';
            }
            startMatchFromSetup(initialServingTeam: initialServing);
          },
        ),
      ),
    );
  }

  Future<void> startMatchFromSetup({required String initialServingTeam}) async {
    isLoading.value = true;
    final matchId = 'VOLLEYBALL_${DateTime.now().millisecondsSinceEpoch}';
    currentMatchId.value = matchId;

    final teamAPlayerModels = teamARoster
        .map((f) => VolleyballPlayer(
              id: f.email,
              name: f.fullName.isNotEmpty ? f.fullName : f.email,
              isOnCourt: true,
            ))
        .toList();

    final teamBPlayerModels = teamBRoster
        .map((f) => VolleyballPlayer(
              id: f.email,
              name: f.fullName.isNotEmpty ? f.fullName : f.email,
              isOnCourt: true,
            ))
        .toList();

    final config = VolleyballMatchConfig(
      maxSets: maxSets.value,
      setTargetPoints: setTargetPoints.value,
      finalSetTargetPoints: 15,
      isProRules: isProRules.value,
      squadLimit: squadLimit.value,
      subsEnabled: subsEnabled.value,
      maxSubstitutes: maxSubstitutes.value,
    );

    final initState = VolleyballMatchState.initial(
      teamA: teamAPlayerModels,
      teamB: teamBPlayerModels,
      config: config,
      initialServingTeam: initialServingTeam,
    );

    engine = VolleyballMatchEngine(initState);
    liveState.value = engine.state;
    isEngineReady.value = true;
    isMatchStarted.value = false;

    final user = FirebaseAuth.instance.currentUser;
    final userId = user?.uid ?? 'local_user';

    final model = VolleyballMatchModel(
      matchId: matchId,
      userId: userId,
      homeTeam: homeTeamName.value.isNotEmpty ? homeTeamName.value : 'Side A',
      awayTeam: awayTeamName.value.isNotEmpty ? awayTeamName.value : 'Side B',
      homeSetsWon: 0,
      awaySetsWon: 0,
      currentSetDisplay: 'SET 1',
      isCompleted: false,
      matchResult: '',
      engineState: engine.state.toJson(),
    );

    currentMatch.value = model;

    try {
      await VolleyballSqfliteService.insertMatch(model);
    } catch (_) {}

    try {
      await FirebaseFirestore.instance
          .collection('volleyball_matches')
          .doc(matchId)
          .set(model.toFirebaseJson());
    } catch (_) {}

    _listenToFirestore(matchId);

    isLoading.value = false;
    Get.off(() => const VolleyballScoreboardScreen());
  }

  void _listenToFirestore(String matchId) {
    _firestoreSubscription?.cancel();
    _firestoreSubscription = FirebaseFirestore.instance
        .collection('volleyball_matches')
        .doc(matchId)
        .snapshots()
        .listen((doc) {
      if (doc.exists && doc.data() != null) {
        final remoteModel = VolleyballMatchModel.fromFirebaseJson(doc.data()!);
        if (remoteModel.userId != FirebaseAuth.instance.currentUser?.uid) {
          isReadOnly.value = true;
          currentMatch.value = remoteModel;
          if (remoteModel.engineState != null) {
            final remoteState = VolleyballMatchState.fromJson(remoteModel.engineState!);
            liveState.value = remoteState;
          }
        }
      }
    });
  }

  void startMatch() {
    isMatchStarted.value = true;
  }

  void scorePoint(String team, {String? scorerId}) {
    if (!isMatchStarted.value || isReadOnly.value) return;
    engine.scorePoint(team, scorerId: scorerId);
    liveState.value = engine.state;
    _syncMatchState();

    if (engine.state.isMatchFinished) {
      finishMatch();
    }
  }

  void advanceToNextSet() {
    if (isReadOnly.value) return;
    engine.advanceToNextSet();
    liveState.value = engine.state;
    _syncMatchState();
  }

  void toggleServingTeam() {
    if (!isMatchStarted.value || isReadOnly.value) return;
    engine.toggleServingTeam();
    liveState.value = engine.state;
    _syncMatchState();
  }

  void useTimeout(String team) {
    if (!isMatchStarted.value || isReadOnly.value) return;
    engine.useTimeout(team);
    liveState.value = engine.state;
    _syncMatchState();
    Get.snackbar(
      'TIMEOUT',
      'Official 30s Timeout called by $team',
      snackPosition: SnackPosition.BOTTOM,
      backgroundColor: AppColors.cardSurface,
      colorText: Colors.white,
    );
  }

  void undoLastAction() {
    if (!isMatchStarted.value || isReadOnly.value) return;
    if (engine.canUndo) {
      engine.undo();
      liveState.value = engine.state;
      _syncMatchState();
    }
  }

  void undoSetCompletionPoint() {
    if (isReadOnly.value) return;
    if (engine.canUndo) {
      engine.undo();
      liveState.value = engine.state;
      _syncMatchState();
      Get.snackbar(
        'Set Point Undone',
        'The set-ending point was undone. Resuming Set ${engine.state.currentSetNumber}!',
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
        'The final set point was undone. Match resumed!',
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
      result = '${currentMatch.value?.homeTeam ?? "Side A"} won the match ${engine.state.setsWonA}-${engine.state.setsWonB}!';
    } else if (winner == 'sideB') {
      result = '${currentMatch.value?.awayTeam ?? "Side B"} won the match ${engine.state.setsWonB}-${engine.state.setsWonA}!';
    }

    _syncMatchState(isFinished: true, result: result);
  }

  Future<void> _syncMatchState({bool isFinished = false, String result = ''}) async {
    if (currentMatch.value == null) return;
    final updated = VolleyballMatchModel(
      matchId: currentMatch.value!.matchId,
      userId: currentMatch.value!.userId,
      homeTeam: currentMatch.value!.homeTeam,
      awayTeam: currentMatch.value!.awayTeam,
      homeSetsWon: engine.state.setsWonA,
      awaySetsWon: engine.state.setsWonB,
      currentSetDisplay: 'SET ${engine.state.currentSetNumber}',
      isCompleted: isFinished || engine.state.isMatchFinished,
      matchResult: result.isNotEmpty ? result : currentMatch.value!.matchResult,
      engineState: engine.state.toJson(),
      updatedAt: DateTime.now(),
    );

    currentMatch.value = updated;
    try {
      await VolleyballSqfliteService.updateMatch(updated);
    } catch (_) {}

    try {
      await FirebaseFirestore.instance
          .collection('volleyball_matches')
          .doc(updated.matchId)
          .set(updated.toFirebaseJson(), SetOptions(merge: true));
    } catch (_) {}
  }

  Future<void> restoreVolleyballMatchFromSqflite(VolleyballMatchModel matchModel) async {
    currentMatchId.value = matchModel.matchId;
    currentMatch.value = matchModel;
    isReadOnly.value = false;

    if (matchModel.engineState != null) {
      final restoredState = VolleyballMatchState.fromJson(matchModel.engineState!);
      engine = VolleyballMatchEngine(restoredState);
      liveState.value = engine.state;
      isEngineReady.value = true;
      isMatchStarted.value = true;
      _listenToFirestore(matchModel.matchId);
    }
  }

  static Future<void> resumeMatch(String matchId) async {
    final controller = Get.isRegistered<VolleyballController>()
        ? Get.find<VolleyballController>()
        : Get.put(VolleyballController());

    final matchData = await VolleyballSqfliteService.getMatchById(matchId);
    if (matchData != null) {
      await controller.restoreVolleyballMatchFromSqflite(matchData);
      Get.to(() => const VolleyballScoreboardScreen());
    }
  }
}
