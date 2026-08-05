import 'dart:async';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:redesign/theme/app_colors.dart';
import 'package:redesign/model/User_Models/Home_Models/Scoreboard_Model/Hockey/hockey_state_models.dart';
import 'package:redesign/model/User_Models/Home_Models/Scoreboard_Model/Hockey/hockey_model.dart';
import 'package:redesign/model/User_Models/Home_Models/Friends_Model/friends_model.dart';
import 'package:redesign/sqflite/User_SQF/Home_SQF/Scoreboard_SQF/hockeySqflite.dart';
import 'package:redesign/view/USER/Home/Scoreboard/coin_toss/coin_toss_screen.dart';
import 'package:redesign/view/USER/Home/Scoreboard/Hockey/live_match/hockey_scoreboard_screen.dart';

class HockeyController extends GetxController {
  final TextEditingController homeTeamController = TextEditingController(text: 'Side A');
  final TextEditingController awayTeamController = TextEditingController(text: 'Side B');

  final RxString homeTeamName = 'Side A'.obs;
  final RxString awayTeamName = 'Side B'.obs;

  final RxList<FriendModel> teamARoster = <FriendModel>[].obs;
  final RxList<FriendModel> teamBRoster = <FriendModel>[].obs;
  final RxList<String> teamAPlayers = <String>[].obs;
  final RxList<String> teamBPlayers = <String>[].obs;

  // Squad & Substitute controls
  final RxInt squadLimit = 11.obs; // FIH 11v11 default
  final RxBool subsEnabled = true.obs;
  final RxInt maxSubstitutes = 5.obs;

  int get maxAllowedPlayers => squadLimit.value + (subsEnabled.value ? maxSubstitutes.value : 0);

  final RxInt maxPeriods = 4.obs; // 4 quarters or 2 halves
  final RxInt periodDurationMinutes = 15.obs; // 15m quarters or 35m halves
  final RxBool isProRules = true.obs;

  // Live Scoreboard State Guards
  final RxBool isMatchStarted = false.obs;
  final Rxn<HockeyMatchModel> currentMatch = Rxn<HockeyMatchModel>();
  final Rxn<HockeyMatchState> liveState = Rxn<HockeyMatchState>();
  late HockeyMatchEngine engine;

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
    squadLimit.value = 11;
    subsEnabled.value = true;
    maxSubstitutes.value = 5;
    maxPeriods.value = 4;
    periodDurationMinutes.value = 15;
    isProRules.value = true;
  }

  void incrementSquadLimit() {
    if (squadLimit.value < 11) squadLimit.value++;
  }

  void decrementSquadLimit() {
    if (squadLimit.value > 1) squadLimit.value--;
  }

  void toggleSubs(bool value) {
    subsEnabled.value = value;
  }

  void incrementSubs() {
    if (maxSubstitutes.value < 5) maxSubstitutes.value++;
  }

  void decrementSubs() {
    if (maxSubstitutes.value > 0) maxSubstitutes.value--;
  }

  void toggleProRules(bool value) {
    isProRules.value = value;
    if (value) {
      maxPeriods.value = 4;
      periodDurationMinutes.value = 15;
      squadLimit.value = 11;
    } else {
      maxPeriods.value = 2;
      periodDurationMinutes.value = 20;
    }
  }

  void setMaxPeriods(int periods) {
    maxPeriods.value = periods;
  }

  void setPeriodDuration(int mins) {
    periodDurationMinutes.value = mins;
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
          sport: 'hockey',
          onTossComplete: (winnerTeam, choice) async {
            startMatchFromSetup();
          },
        ),
      ),
    );
  }

  Future<void> startMatchFromSetup() async {
    isLoading.value = true;
    final matchId = 'HOCKEY_${DateTime.now().millisecondsSinceEpoch}';
    currentMatchId.value = matchId;

    final teamAPlayerModels = teamARoster
        .map((f) => HockeyPlayer(
              id: f.email,
              name: f.fullName.isNotEmpty ? f.fullName : f.email,
              isOnField: true,
            ))
        .toList();

    final teamBPlayerModels = teamBRoster
        .map((f) => HockeyPlayer(
              id: f.email,
              name: f.fullName.isNotEmpty ? f.fullName : f.email,
              isOnField: true,
            ))
        .toList();

    final config = HockeyMatchConfig(
      maxPeriods: maxPeriods.value,
      periodDurationMinutes: periodDurationMinutes.value,
      isProRules: isProRules.value,
      squadLimit: squadLimit.value,
      subsEnabled: subsEnabled.value,
      maxSubstitutes: maxSubstitutes.value,
    );

    final initState = HockeyMatchState.initial(
      teamA: teamAPlayerModels,
      teamB: teamBPlayerModels,
      config: config,
    );

    engine = HockeyMatchEngine(initState);
    liveState.value = engine.state;
    isEngineReady.value = true;
    isMatchStarted.value = true;

    final user = FirebaseAuth.instance.currentUser;
    final userId = user?.uid ?? 'local_user';

    final model = HockeyMatchModel(
      matchId: matchId,
      userId: userId,
      homeTeam: homeTeamName.value.isNotEmpty ? homeTeamName.value : 'Side A',
      awayTeam: awayTeamName.value.isNotEmpty ? awayTeamName.value : 'Side B',
      homeGoals: 0,
      awayGoals: 0,
      currentPeriodDisplay: 'Q1',
      isCompleted: false,
      matchResult: '',
      engineState: engine.state.toJson(),
    );

    currentMatch.value = model;

    try {
      await HockeySqfliteService.insertMatch(model);
    } catch (_) {}

    try {
      await FirebaseFirestore.instance
          .collection('hockey_matches')
          .doc(matchId)
          .set(model.toFirebaseJson());
    } catch (_) {}

    _listenToFirestore(matchId);

    isLoading.value = false;
    Get.off(() => const HockeyScoreboardScreen());
  }

  void _listenToFirestore(String matchId) {
    _firestoreSubscription?.cancel();
    _firestoreSubscription = FirebaseFirestore.instance
        .collection('hockey_matches')
        .doc(matchId)
        .snapshots()
        .listen((doc) {
      if (doc.exists && doc.data() != null) {
        final remoteModel = HockeyMatchModel.fromFirebaseJson(doc.data()!);
        if (remoteModel.userId != FirebaseAuth.instance.currentUser?.uid) {
          isReadOnly.value = true;
          currentMatch.value = remoteModel;
          if (remoteModel.engineState != null) {
            final remoteState = HockeyMatchState.fromJson(remoteModel.engineState!);
            liveState.value = remoteState;
          }
        }
      }
    });
  }

  void startMatch() {
    isMatchStarted.value = true;
  }

  void scoreGoal(String team, {String? scorerName, GoalType goalType = GoalType.fieldGoal}) {
    if (!isMatchStarted.value || isReadOnly.value) return;
    engine.scoreGoal(team, scorerName: scorerName, goalType: goalType);
    liveState.value = engine.state;
    _syncMatchState();

    if (engine.state.isMatchFinished) {
      finishMatch();
    }
  }

  void addPenaltyCorner(String team) {
    if (!isMatchStarted.value || isReadOnly.value) return;
    engine.addPenaltyCorner(team);
    liveState.value = engine.state;
    _syncMatchState();
    Get.snackbar(
      'Penalty Corner',
      'Penalty Corner awarded to $team',
      snackPosition: SnackPosition.BOTTOM,
      backgroundColor: AppColors.cardSurface,
      colorText: Colors.white,
    );
  }

  void advancePeriod() {
    if (isReadOnly.value) return;
    engine.advancePeriod();
    liveState.value = engine.state;
    _syncMatchState();
  }

  void undoLastAction() {
    if (!isMatchStarted.value || isReadOnly.value) return;
    if (engine.canUndo) {
      engine.undo();
      liveState.value = engine.state;
      _syncMatchState();
    }
  }

  void undoPeriodCompletionGoal() {
    if (isReadOnly.value) return;
    if (engine.canUndo) {
      engine.undo();
      liveState.value = engine.state;
      _syncMatchState();
      Get.snackbar(
        'Period Goal Undone',
        'The period-ending goal was undone.',
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
        'The final goal was undone. Match resumed!',
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
      result = '${currentMatch.value?.homeTeam ?? "Side A"} won the match ${engine.state.goalsA}-${engine.state.goalsB}!';
    } else if (winner == 'sideB') {
      result = '${currentMatch.value?.awayTeam ?? "Side B"} won the match ${engine.state.goalsB}-${engine.state.goalsA}!';
    }

    _syncMatchState(isFinished: true, result: result);
  }

  Future<void> _syncMatchState({bool isFinished = false, String result = ''}) async {
    if (currentMatch.value == null) return;
    final updated = HockeyMatchModel(
      matchId: currentMatch.value!.matchId,
      userId: currentMatch.value!.userId,
      homeTeam: currentMatch.value!.homeTeam,
      awayTeam: currentMatch.value!.awayTeam,
      homeGoals: engine.state.goalsA,
      awayGoals: engine.state.goalsB,
      currentPeriodDisplay: 'Q${engine.state.currentPeriod}',
      isCompleted: isFinished || engine.state.isMatchFinished,
      matchResult: result.isNotEmpty ? result : currentMatch.value!.matchResult,
      engineState: engine.state.toJson(),
      updatedAt: DateTime.now(),
    );

    currentMatch.value = updated;
    try {
      await HockeySqfliteService.updateMatch(updated);
    } catch (_) {}

    try {
      await FirebaseFirestore.instance
          .collection('hockey_matches')
          .doc(updated.matchId)
          .set(updated.toFirebaseJson(), SetOptions(merge: true));
    } catch (_) {}
  }

  Future<void> restoreHockeyMatchFromSqflite(HockeyMatchModel matchModel) async {
    currentMatchId.value = matchModel.matchId;
    currentMatch.value = matchModel;
    isReadOnly.value = false;

    if (matchModel.engineState != null) {
      final restoredState = HockeyMatchState.fromJson(matchModel.engineState!);
      engine = HockeyMatchEngine(restoredState);
      liveState.value = engine.state;
      isEngineReady.value = true;
      isMatchStarted.value = true;
      _listenToFirestore(matchModel.matchId);
    }
  }

  static Future<void> resumeMatch(String matchId) async {
    final controller = Get.isRegistered<HockeyController>()
        ? Get.find<HockeyController>()
        : Get.put(HockeyController());

    final matchData = await HockeySqfliteService.getMatchById(matchId);
    if (matchData != null) {
      await controller.restoreHockeyMatchFromSqflite(matchData);
      Get.to(() => const HockeyScoreboardScreen());
    }
  }
}
