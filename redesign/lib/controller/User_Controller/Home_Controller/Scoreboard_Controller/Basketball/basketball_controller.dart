import 'dart:async';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:redesign/model/User_Models/Home_Models/Scoreboard_Model/Basketball/basketball_state_models.dart';
import 'package:redesign/model/User_Models/Home_Models/Scoreboard_Model/Basketball/basketball_model.dart';
import 'package:redesign/model/User_Models/Home_Models/Friends_Model/friends_model.dart';
import 'package:redesign/sqflite/User_SQF/Home_SQF/Scoreboard_SQF/basketballSqflite.dart';
import 'package:redesign/view/USER/Home/Scoreboard/coin_toss/coin_toss_screen.dart';
import 'package:redesign/view/USER/Home/Scoreboard/Basketball/live_match/basketball_scoreboard_screen.dart';

class BasketballController extends GetxController {
  final TextEditingController homeTeamController = TextEditingController(
    text: 'Side A',
  );
  final TextEditingController awayTeamController = TextEditingController(
    text: 'Side B',
  );

  final RxString homeTeamName = 'Side A'.obs;
  final RxString awayTeamName = 'Side B'.obs;

  final RxList<FriendModel> teamARoster = <FriendModel>[].obs;
  final RxList<FriendModel> teamBRoster = <FriendModel>[].obs;
  final RxList<String> teamAPlayers = <String>[].obs;
  final RxList<String> teamBPlayers = <String>[].obs;

  // Squad & Substitute controls (Squad limit locked to 5 in FIBA Pro Rules mode)
  final RxInt squadLimit = 5.obs;
  final RxBool subsEnabled = true.obs;
  final RxInt maxSubstitutes = 7.obs;

  int get maxAllowedPlayers =>
      squadLimit.value + (subsEnabled.value ? maxSubstitutes.value : 0);

  final RxInt quarterDurationMinutes = 10.obs;
  final RxBool isProRules = true.obs;
  final RxBool enableShotClock = true.obs;

  // Live Scoreboard Timers & Start Guard
  final RxBool isMatchStarted = false.obs;
  final RxInt secondsRemaining = 600.obs;
  final RxBool isTimerRunning = false.obs;

  final RxInt shotClockSeconds = 24.obs;
  final RxBool isShotClockRunning = false.obs;

  Timer? _gameTimer;
  Timer? _shotClockTimer;

  final Rxn<BasketballMatchModel> currentMatch = Rxn<BasketballMatchModel>();
  final Rxn<BasketballMatchState> liveState = Rxn<BasketballMatchState>();
  late BasketballMatchEngine engine;

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
    _initDefaultUserRoster();
  }

  @override
  void onClose() {
    _gameTimer?.cancel();
    _shotClockTimer?.cancel();
    _firestoreSubscription?.cancel();
    super.onClose();
  }

  void _initDefaultUserRoster() {
    final user = FirebaseAuth.instance.currentUser;
    final userName = user?.displayName ?? 'You';
    final userEmail = user?.email ?? 'you@local';

    if (teamARoster.isEmpty) {
      teamARoster.add(
        FriendModel(email: userEmail, fullName: '$userName (You)'),
      );
      teamAPlayers.add(userEmail);
    }
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
    squadLimit.value = 5;
    subsEnabled.value = true;
    maxSubstitutes.value = 7;
    quarterDurationMinutes.value = 10;
    isProRules.value = true;
    enableShotClock.value = true;
    _initDefaultUserRoster();
  }

  void incrementSquadLimit() {
    if (squadLimit.value < 12) squadLimit.value++;
  }

  void decrementSquadLimit() {
    if (squadLimit.value > 1) squadLimit.value--;
  }

  void toggleSubs(bool value) {
    subsEnabled.value = value;
  }

  void incrementSubs() {
    if (maxSubstitutes.value < 10) maxSubstitutes.value++;
  }

  void decrementSubs() {
    if (maxSubstitutes.value > 0) maxSubstitutes.value--;
  }

  void toggleProRules(bool value) {
    isProRules.value = value;
    if (value) {
      quarterDurationMinutes.value = 10;
      enableShotClock.value = true;
      secondsRemaining.value = 600;
    } else {
      quarterDurationMinutes.value = 8;
      secondsRemaining.value = 480;
    }
  }

  void setQuarterDuration(int minutes) {
    quarterDurationMinutes.value = minutes;
    secondsRemaining.value = minutes * 60;
  }

  void toggleShotClock(bool value) {
    enableShotClock.value = value;
  }

  void addTeamPlayer(bool isTeamA, FriendModel player) {
    final roster = isTeamA ? teamARoster : teamBRoster;
    final playersList = isTeamA ? teamAPlayers : teamBPlayers;

    final maxAllowed =
        squadLimit.value + (subsEnabled.value ? maxSubstitutes.value : 0);
    if (roster.length >= maxAllowed) {
      Get.snackbar(
        'Limit Reached',
        'Cannot add more than $maxAllowed players.',
      );
      return;
    }

    if (teamAPlayers.contains(player.email) ||
        teamBPlayers.contains(player.email)) {
      Get.snackbar('Error', 'Player already added.');
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

  void proceedToJumpBall(BuildContext context) {
    if (teamARoster.isEmpty || teamBRoster.isEmpty) {
      Get.snackbar('Teams Required', 'Please add players to both teams.');
      return;
    }

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => CoinFlipScreen(
          teamAName: homeTeamName.value.isNotEmpty
              ? homeTeamName.value
              : 'Side A',
          teamBName: awayTeamName.value.isNotEmpty
              ? awayTeamName.value
              : 'Side B',
          sport: 'basketball',
          onTossComplete: (winnerTeam, choice) async {
            // Per FIBA rules, the team that LOSES the opening tip gets the initial alternating possession arrow!
            String initialArrowDirection = 'sideB';
            if (winnerTeam ==
                (awayTeamName.value.isNotEmpty
                    ? awayTeamName.value
                    : 'Side B')) {
              initialArrowDirection = 'sideA';
            }
            startMatchFromSetup(initialPossession: initialArrowDirection);
          },
        ),
      ),
    );
  }

  Future<void> startMatchFromSetup({required String initialPossession}) async {
    isLoading.value = true;
    final matchId = 'BASKETBALL_${DateTime.now().millisecondsSinceEpoch}';
    currentMatchId.value = matchId;

    final teamAPlayerModels = teamARoster
        .map(
          (f) => BasketballPlayer(
            id: f.email,
            name: f.fullName.isNotEmpty ? f.fullName : f.email,
            isOnCourt: true,
          ),
        )
        .toList();

    final teamBPlayerModels = teamBRoster
        .map(
          (f) => BasketballPlayer(
            id: f.email,
            name: f.fullName.isNotEmpty ? f.fullName : f.email,
            isOnCourt: true,
          ),
        )
        .toList();

    final config = BasketballMatchConfig(
      quarterDurationMinutes: quarterDurationMinutes.value,
      isProRules: isProRules.value,
      enableShotClock: enableShotClock.value,
      squadLimit: squadLimit.value,
      subsEnabled: subsEnabled.value,
      maxSubstitutes: maxSubstitutes.value,
    );

    final initState = BasketballMatchState.initial(
      teamA: teamAPlayerModels,
      teamB: teamBPlayerModels,
      config: config,
      initialPossession: initialPossession,
    );

    engine = BasketballMatchEngine(initState);
    liveState.value = engine.state;
    isEngineReady.value = true;
    isMatchStarted.value = false;
    secondsRemaining.value = quarterDurationMinutes.value * 60;
    shotClockSeconds.value = 24;

    final user = FirebaseAuth.instance.currentUser;
    final userId = user?.uid ?? 'local_user';

    final model = BasketballMatchModel(
      matchId: matchId,
      userId: userId,
      homeTeam: homeTeamName.value.isNotEmpty ? homeTeamName.value : 'Side A',
      awayTeam: awayTeamName.value.isNotEmpty ? awayTeamName.value : 'Side B',
      homeScore: 0,
      awayScore: 0,
      currentQuarter: 'Q1',
      isCompleted: false,
      matchResult: '',
      engineState: engine.state.toJson(),
    );

    currentMatch.value = model;

    await BasketballSqfliteService.insertMatch(model);

    try {
      await FirebaseFirestore.instance
          .collection('basketball_matches')
          .doc(matchId)
          .set(model.toFirebaseJson());
    } catch (_) {}

    _listenToFirestore(matchId);

    isLoading.value = false;
    Get.off(() => const BasketballScoreboardScreen());
  }

  void _listenToFirestore(String matchId) {
    _firestoreSubscription?.cancel();
    _firestoreSubscription = FirebaseFirestore.instance
        .collection('basketball_matches')
        .doc(matchId)
        .snapshots()
        .listen((doc) {
          if (doc.exists && doc.data() != null) {
            final remoteModel = BasketballMatchModel.fromFirebaseJson(
              doc.data()!,
            );
            if (remoteModel.userId != FirebaseAuth.instance.currentUser?.uid) {
              isReadOnly.value = true;
              currentMatch.value = remoteModel;
              if (remoteModel.engineState != null) {
                final remoteState = BasketballMatchState.fromJson(
                  remoteModel.engineState!,
                );
                liveState.value = remoteState;
              }
            }
          }
        });
  }

  void startMatch() {
    isMatchStarted.value = true;
    _startTimers();
  }

  void pauseForBreak() {
    isTimerRunning.value = false;
    isShotClockRunning.value = false;
    _gameTimer?.cancel();
    _shotClockTimer?.cancel();
  }

  void resumeFromBreak() {
    if (!isMatchStarted.value) return;
    _startTimers();
  }

  void _startTimers() {
    isTimerRunning.value = true;
    _gameTimer?.cancel();
    _gameTimer = Timer.periodic(const Duration(seconds: 1), (t) {
      if (secondsRemaining.value > 0) {
        secondsRemaining.value--;
      } else {
        t.cancel();
        isTimerRunning.value = false;
        pauseForBreak();
        _onQuarterEnded();
      }
    });

    if (enableShotClock.value) {
      isShotClockRunning.value = true;
      _shotClockTimer?.cancel();
      _shotClockTimer = Timer.periodic(const Duration(seconds: 1), (t) {
        if (shotClockSeconds.value > 0) {
          shotClockSeconds.value--;
        } else {
          t.cancel();
          isShotClockRunning.value = false;
          Get.snackbar(
            'VIOLATION',
            '24-Second Shot Clock Violation! Turnover.',
          );
          resetShotClock24();
        }
      });
    }
  }

  void _onQuarterEnded() {
    if (liveState.value == null) return;
    if (engine.state.currentQuarter < 4) {
      engine.advanceQuarter();
      liveState.value = engine.state;
      secondsRemaining.value = engine.state.config.quarterDurationMinutes * 60;
      resetShotClock24();
      _syncMatchState();
      Get.defaultDialog(
        title: 'Quarter Ended',
        middleText: '${engine.state.quarterDisplay} is starting now.',
        confirmTextColor: Colors.black,
        textConfirm: 'Start Next Quarter',
        onConfirm: () {
          Get.back();
          startMatch();
        },
      );
    } else {
      // Q4 or OT ended
      if (engine.state.sideAScore == engine.state.sideBScore) {
        // Tied -> Go to Overtime!
        engine.advanceQuarter();
        liveState.value = engine.state;
        secondsRemaining.value = 300; // 5-minute OT
        resetShotClock24();
        _syncMatchState();
        Get.defaultDialog(
          title: 'MATCH TIED!',
          middleText:
              '5-Minute Overtime (${engine.state.quarterDisplay}) will begin.',
          textConfirm: 'Start Overtime',
          onConfirm: () {
            Get.back();
            startMatch();
          },
        );
      } else {
        finishMatch();
      }
    }
  }

  void scorePoints(String team, int points, {String? scorerId}) {
    if (!isMatchStarted.value || isReadOnly.value) return;
    engine.scorePoints(team, points, scorerId: scorerId);
    liveState.value = engine.state;
    resetShotClock24(); // All made points (+1, +2, +3) reset shot clock to 24s for inbound!
    _syncMatchState();
  }

  void recordFoul(String team, {String? playerFouledId}) {
    if (!isMatchStarted.value || isReadOnly.value) return;
    engine.recordFoul(team, playerFouledId: playerFouledId);
    liveState.value = engine.state;
    _syncMatchState();

    final isTeamA = team == 'sideA';
    final teamFouls = isTeamA
        ? engine.state.teamFoulsA
        : engine.state.teamFoulsB;
    if (teamFouls >= engine.state.config.teamFoulPenaltyThreshold) {
      Get.snackbar(
        'BONUS PENALTY',
        'Team is in Penalty! Opponent awarded 2 Bonus Free Throws.',
      );
    }
  }

  void recordHeldBall() {
    if (!isMatchStarted.value || isReadOnly.value) return;
    engine.recordHeldBallJumpBall();
    liveState.value = engine.state;
    resetShotClock24();
    _syncMatchState();
    Get.snackbar('HELD BALL', 'Possession awarded via Alternating Arrow!');
  }

  void togglePossessionArrow() {
    if (!isMatchStarted.value || isReadOnly.value) return;
    engine.togglePossessionArrow();
    liveState.value = engine.state;
    _syncMatchState();
    Get.snackbar(
      'POSSESSION ARROW',
      'Alternating possession arrow manually toggled.',
    );
  }

  void useTimeout(String team) {
    if (!isMatchStarted.value || isReadOnly.value) return;
    engine.useTimeout(team);
    liveState.value = engine.state;
    pauseForBreak();
    _syncMatchState();
    Get.snackbar('TIMEOUT', 'Official 60s Timeout called by $team');
  }

  void resetShotClock24() {
    shotClockSeconds.value = 24;
  }

  void resetShotClock14() {
    shotClockSeconds.value = 14;
  }

  void undoLastAction() {
    if (!isMatchStarted.value || isReadOnly.value) return;
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
      _syncMatchState();
      Get.snackbar(
        'Match End Undone',
        'The final point was undone. Match resumed!',
      );
    }
  }

  void finishMatch() {
    pauseForBreak();
    engine.endMatch();
    liveState.value = engine.state;

    final winner = engine.state.matchWinner;
    String result = 'MATCH TIED';
    if (winner == 'sideA') {
      result = '${currentMatch.value?.homeTeam ?? "Side A"} won the match!';
    } else if (winner == 'sideB') {
      result = '${currentMatch.value?.awayTeam ?? "Side B"} won the match!';
    }

    _syncMatchState(isFinished: true, result: result);
  }

  Future<void> _syncMatchState({
    bool isFinished = false,
    String result = '',
  }) async {
    if (currentMatch.value == null) return;
    final updated = BasketballMatchModel(
      matchId: currentMatch.value!.matchId,
      userId: currentMatch.value!.userId,
      homeTeam: currentMatch.value!.homeTeam,
      awayTeam: currentMatch.value!.awayTeam,
      homeScore: engine.state.sideAScore,
      awayScore: engine.state.sideBScore,
      currentQuarter: engine.state.quarterDisplay,
      isCompleted: isFinished || engine.state.isMatchFinished,
      matchResult: result.isNotEmpty ? result : currentMatch.value!.matchResult,
      engineState: engine.state.toJson(),
      updatedAt: DateTime.now(),
    );

    currentMatch.value = updated;
    await BasketballSqfliteService.updateMatch(updated);

    try {
      await FirebaseFirestore.instance
          .collection('basketball_matches')
          .doc(updated.matchId)
          .set(updated.toFirebaseJson(), SetOptions(merge: true));
    } catch (_) {}
  }

  Future<void> restoreBasketballMatchFromSqflite(
    BasketballMatchModel matchModel,
  ) async {
    currentMatchId.value = matchModel.matchId;
    currentMatch.value = matchModel;
    isReadOnly.value = false;

    if (matchModel.engineState != null) {
      final restoredState = BasketballMatchState.fromJson(
        matchModel.engineState!,
      );
      engine = BasketballMatchEngine(restoredState);
      liveState.value = engine.state;
      isEngineReady.value = true;
      isMatchStarted.value = false;
      secondsRemaining.value = restoredState.config.quarterDurationMinutes * 60;
      shotClockSeconds.value = 24;
      _listenToFirestore(matchModel.matchId);
    }
  }

  static Future<void> resumeMatch(String matchId) async {
    final controller = Get.isRegistered<BasketballController>()
        ? Get.find<BasketballController>()
        : Get.put(BasketballController());

    final matchData = await BasketballSqfliteService.getMatchById(matchId);
    if (matchData != null) {
      await controller.restoreBasketballMatchFromSqflite(matchData);
      Get.to(() => const BasketballScoreboardScreen());
    }
  }
}
