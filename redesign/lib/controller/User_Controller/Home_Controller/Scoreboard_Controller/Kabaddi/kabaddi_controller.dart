import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:redesign/model/User_Models/Home_Models/Scoreboard_Model/Kabaddi/kabaddi_state_models.dart';
import 'package:redesign/model/User_Models/Home_Models/Scoreboard_Model/Kabaddi/kabaddi_model.dart';
import 'package:redesign/model/User_Models/Home_Models/Friends_Model/friends_model.dart';
import 'package:redesign/sqflite/User_SQF/Home_SQF/Scoreboard_SQF/kabaddiSqflite.dart';
import 'package:redesign/view/USER/Home/Scoreboard/coin_toss/coin_toss_screen.dart';
import 'package:redesign/view/USER/Home/Scoreboard/Kabaddi/live_match/kabaddi_scoreboard_screen.dart';
import 'package:redesign/common/common_select_players_sheet.dart';

class KabaddiController extends GetxController {
  final TextEditingController homeTeamController = TextEditingController(text: 'Side A');
  final TextEditingController awayTeamController = TextEditingController(text: 'Side B');

  final RxString homeTeamName = 'Side A'.obs;
  final RxString awayTeamName = 'Side B'.obs;

  final RxList<FriendModel> teamARoster = <FriendModel>[].obs;
  final RxList<FriendModel> teamBRoster = <FriendModel>[].obs;
  final RxList<String> teamAPlayers = <String>[].obs;
  final RxList<String> teamBPlayers = <String>[].obs;

  // Squad & Substitute controls matching Cricket
  final RxInt squadLimit = 7.obs;
  final RxBool subsEnabled = true.obs;
  final RxInt maxSubstitutes = 5.obs;

  int get maxAllowedPlayers => squadLimit.value + (subsEnabled.value ? maxSubstitutes.value : 0);

  final RxInt halfDurationMinutes = 15.obs;
  final RxBool isProRules = true.obs;

  // Live Scoreboard Timers & Start Guard
  final RxBool isMatchStarted = false.obs;
  final RxInt secondsRemaining = 900.obs;
  final RxBool isTimerRunning = false.obs;

  final RxInt raidClockSeconds = 30.obs;
  final RxBool isRaidClockRunning = false.obs;

  final Rxn<KabaddiMatchModel> currentMatch = Rxn<KabaddiMatchModel>();
  final Rxn<KabaddiMatchState> liveState = Rxn<KabaddiMatchState>();
  late KabaddiMatchEngine engine;

  final RxString currentMatchId = ''.obs;
  final RxBool isLoading = false.obs;
  final RxBool isEngineReady = false.obs;
  final RxBool isReadOnly = false.obs;
  final RxBool hasMatchEndUndoBeenUsed = false.obs;

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

  void resetSetupScreen() {
    homeTeamController.text = 'Side A';
    awayTeamController.text = 'Side B';
    homeTeamName.value = 'Side A';
    awayTeamName.value = 'Side B';
    teamARoster.clear();
    teamBRoster.clear();
    teamAPlayers.clear();
    teamBPlayers.clear();
    squadLimit.value = 7;
    subsEnabled.value = true;
    maxSubstitutes.value = 5;
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
      halfDurationMinutes.value = 20; // Official Pro Mode 20-min half default
      secondsRemaining.value = 1200;
    } else {
      halfDurationMinutes.value = 15;
      secondsRemaining.value = 900;
    }
  }

  void setHalfDuration(int minutes) {
    halfDurationMinutes.value = minutes;
    secondsRemaining.value = minutes * 60;
  }

  void addTeamPlayer(bool isTeamA, FriendModel player) {
    final roster = isTeamA ? teamARoster : teamBRoster;
    final playersList = isTeamA ? teamAPlayers : teamBPlayers;

    final maxAllowed = squadLimit.value + (subsEnabled.value ? maxSubstitutes.value : 0);
    if (roster.length >= maxAllowed) {
      Get.snackbar('Limit Reached', 'Cannot add more than $maxAllowed players.');
      return;
    }

    if (teamAPlayers.contains(player.email) || teamBPlayers.contains(player.email)) {
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

  void openPlayerSelection(BuildContext context, bool isTeamA) {
    final teamName = isTeamA ? homeTeamName.value : awayTeamName.value;
    final selectedEmails = isTeamA ? teamAPlayers : teamBPlayers;
    final opponentEmails = isTeamA ? teamBPlayers : teamAPlayers;

    CommonSelectPlayersBottomSheet.show(
      context,
      title: 'Select $teamName Players',
      maxCount: maxAllowedPlayers,
      selectedPlayerEmails: selectedEmails,
      opponentPlayerEmails: opponentEmails,
      onPlayerSelected: (friend) {
        addTeamPlayer(isTeamA, friend);
      },
    );
  }

  void goToToss([BuildContext? context]) {
    final teamAName = homeTeamController.text.trim().isNotEmpty
        ? homeTeamController.text.trim()
        : (teamARoster.isNotEmpty ? teamARoster.first.fullName : 'Side A');
    final teamBName = awayTeamController.text.trim().isNotEmpty
        ? awayTeamController.text.trim()
        : (teamBRoster.isNotEmpty ? teamBRoster.first.fullName : 'Side B');

    if (teamARoster.isEmpty) {
      teamARoster.add(FriendModel(email: 'sideA@local', fullName: teamAName));
      teamAPlayers.add('sideA@local');
    }
    if (teamBRoster.isEmpty) {
      teamBRoster.add(FriendModel(email: 'sideB@local', fullName: teamBName));
      teamBPlayers.add('sideB@local');
    }

    final navContext = context ?? Get.context;
    if (navContext != null) {
      Navigator.push(
        navContext,
        MaterialPageRoute(
          builder: (context) => CoinFlipScreen(
            teamAName: teamAName,
            teamBName: teamBName,
            sport: 'kabaddi',
            onTossComplete: (tossWinner, tossDecision) async {
              final isWinnerA = tossWinner == teamAName;
              final bool isRaidChosen = tossDecision.toLowerCase().contains('raid');
              final raidingSide = (isWinnerA && isRaidChosen) || (!isWinnerA && !isRaidChosen)
                  ? PlayerSide.sideA
                  : PlayerSide.sideB;

              await createAndStartMatch(navContext, initialRaidingSide: raidingSide);
            },
          ),
        ),
      );
    }
  }

  Future<void> createAndStartMatch(
    BuildContext context, {
    required PlayerSide initialRaidingSide,
  }) async {
    try {
      isLoading.value = true;
      final userId = FirebaseAuth.instance.currentUser?.uid ?? 'guest';
      final matchId = 'KABADDI_${DateTime.now().millisecondsSinceEpoch}';

      final teamAName = homeTeamController.text.trim().isNotEmpty
          ? homeTeamController.text.trim()
          : (teamARoster.isNotEmpty ? teamARoster.first.fullName : 'Side A');
      final teamBName = awayTeamController.text.trim().isNotEmpty
          ? awayTeamController.text.trim()
          : (teamBRoster.isNotEmpty ? teamBRoster.first.fullName : 'Side B');

      final List<KabaddiPlayer> sideAPlayers = teamARoster
          .map((f) => KabaddiPlayer(id: f.email, name: f.fullName))
          .toList();
      final List<KabaddiPlayer> sideBPlayers = teamBRoster
          .map((f) => KabaddiPlayer(id: f.email, name: f.fullName))
          .toList();

      final config = KabaddiMatchConfig(
        halfDurationMinutes: halfDurationMinutes.value,
        isProRules: isProRules.value,
        activePlayersPerTeam: squadLimit.value,
      );

      final initialState = KabaddiMatchState.initial(
        teamA: sideAPlayers,
        teamB: sideBPlayers,
        config: config,
        initialRaidingSide: initialRaidingSide,
      );

      final matchModel = KabaddiMatchModel(
        matchId: matchId,
        userId: userId,
        homeTeam: teamAName,
        awayTeam: teamBName,
        homeScore: 0,
        awayScore: 0,
        currentHalf: '1st Half',
        isCompleted: false,
        matchResult: '',
        engineState: initialState.toJson(),
      );

      currentMatchId.value = matchId;
      currentMatch.value = matchModel;
      hasMatchEndUndoBeenUsed.value = false;

      _initEngineFromState(initialState);
      startMatch();
      await KabaddiSqfliteService.insertMatch(matchModel);

      try {
        await FirebaseFirestore.instance
            .collection('kabaddi_matches')
            .doc(matchId)
            .set(matchModel.toFirebaseJson());
      } catch (e) {
        debugPrint("Kabaddi Firestore creation error (non-critical): $e");
      }

      _listenToFirestore(matchId);

      if (context.mounted) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const KabaddiScoreboardScreen()),
        );
      }
    } catch (e) {
      Get.snackbar('Error', 'Failed to start Kabaddi match: $e');
    } finally {
      isLoading.value = false;
    }
  }

  void _listenToFirestore(String matchId) {
    FirebaseFirestore.instance
        .collection('kabaddi_matches')
        .doc(matchId)
        .snapshots()
        .listen((doc) {
      if (doc.exists && doc.data() != null) {
        final m = KabaddiMatchModel.fromFirebaseJson(doc.data()!);
        if (currentMatch.value == null || m.updatedAt.isAfter(currentMatch.value!.updatedAt)) {
          currentMatch.value = m;
          if (m.engineState != null && FirebaseAuth.instance.currentUser?.uid != m.userId) {
            final state = KabaddiMatchState.fromJson(m.engineState!);
            _initEngineFromState(state);
          }
        }
      }
    });
  }

  Future<void> resumeMatch(String matchId) async {
    isLoading.value = true;
    final match = await KabaddiSqfliteService.getMatchById(matchId);
    if (match != null) {
      restoreKabaddiMatchFromSqflite(match);
      _listenToFirestore(matchId);
      Get.to(() => const KabaddiScoreboardScreen());
    } else {
      try {
        final doc = await FirebaseFirestore.instance.collection('kabaddi_matches').doc(matchId).get();
        if (doc.exists && doc.data() != null) {
          final m = KabaddiMatchModel.fromFirebaseJson(doc.data()!);
          restoreKabaddiMatchFromSqflite(m);
          await KabaddiSqfliteService.insertMatch(m);
          _listenToFirestore(matchId);
          Get.to(() => const KabaddiScoreboardScreen());
        } else {
          Get.snackbar('Error', 'Kabaddi match data not found.');
        }
      } catch (e) {
        Get.snackbar('Error', 'Failed to load Kabaddi match: $e');
      }
    }
    isLoading.value = false;
  }

  void _initEngineFromState(KabaddiMatchState state) {
    engine = KabaddiMatchEngine(state);
    liveState.value = engine.state;
    isEngineReady.value = true;
  }

  void restoreKabaddiMatchFromSqflite(KabaddiMatchModel match) {
    currentMatchId.value = match.matchId;
    currentMatch.value = match;

    if (match.engineState != null) {
      final restoredState = KabaddiMatchState.fromJson(match.engineState!);
      secondsRemaining.value = restoredState.config.halfDurationMinutes * 60;
      isProRules.value = restoredState.config.isProRules;
      _initEngineFromState(restoredState);
      if (!restoredState.isMatchFinished) {
        startMatch();
      }
    }
  }

  // ════════════════════ MATCH START & BREAK CONTROLS ════════════════════

  void startMatch() {
    isMatchStarted.value = true;
    isTimerRunning.value = true;
    if (isProRules.value) {
      isRaidClockRunning.value = true;
    }
  }

  void pauseForBreak() {
    isTimerRunning.value = false;
    isRaidClockRunning.value = false;
  }

  void resumeFromBreak() {
    if (!isMatchStarted.value) {
      isMatchStarted.value = true;
    }
    isTimerRunning.value = true;
    if (isProRules.value) {
      isRaidClockRunning.value = true;
    }
  }

  // ════════════════════ LIVE SCORING ACTIONS ════════════════════

  void scoreRaidPoint(PlayerSide team, {int points = 1, String? revivedPlayerId}) {
    if (!isEngineReady.value || !isMatchStarted.value) return;
    engine.scoreRaidPoint(team, points: points, revivedPlayerId: revivedPlayerId);
    resetRaidClock();
    _syncState();
  }

  void scoreEmptyRaid(PlayerSide team) {
    if (!isEngineReady.value || !isMatchStarted.value) return;
    engine.scoreEmptyRaid(team);
    resetRaidClock();
    _syncState();
  }

  void scoreTacklePoint(PlayerSide team, {String? revivedPlayerId}) {
    if (!isEngineReady.value || !isMatchStarted.value) return;
    engine.scoreTacklePoint(team, revivedPlayerId: revivedPlayerId);
    resetRaidClock();
    _syncState();
  }

  void scoreAllOut(PlayerSide team) {
    if (!isEngineReady.value || !isMatchStarted.value) return;
    engine.scoreAllOut(team);
    _syncState();
  }

  void scoreBonusPoint(PlayerSide team) {
    if (!isEngineReady.value || !isMatchStarted.value) return;
    engine.scoreBonusPoint(team);
    resetRaidClock();
    _syncState();
  }

  void substitutePlayer(PlayerSide side, KabaddiPlayer outPlayer, KabaddiPlayer inPlayer) {
    if (!isEngineReady.value || !isMatchStarted.value) return;
    // Swap on-court status
    final currentList = side == PlayerSide.sideA ? liveState.value!.teamA : liveState.value!.teamB;
    final updatedList = currentList.map((p) {
      if (p.id == outPlayer.id) return p.copyWith(isOnCourt: false);
      if (p.id == inPlayer.id) return p.copyWith(isOnCourt: true);
      return p;
    }).toList();

    final newState = side == PlayerSide.sideA
        ? liveState.value!.copyWith(teamA: updatedList)
        : liveState.value!.copyWith(teamB: updatedList);

    engine = KabaddiMatchEngine(newState);
    _syncState();
  }

  // ════════════════════ TIMERS ════════════════════

  void resetRaidClock() {
    raidClockSeconds.value = 30;
  }

  void toggleRaidClock() {
    isRaidClockRunning.value = !isRaidClockRunning.value;
  }

  void tickRaidClock() {
    if (raidClockSeconds.value > 0) {
      raidClockSeconds.value--;
    } else {
      isRaidClockRunning.value = false;
    }
  }

  void tickHalfTimer() {
    if (secondsRemaining.value > 0) {
      secondsRemaining.value--;
    } else {
      isTimerRunning.value = false;
    }
  }

  void toggleHalfTimer() {
    isTimerRunning.value = !isTimerRunning.value;
  }

  void switchHalf() {
    if (!isEngineReady.value) return;
    engine.switchHalf();
    _syncState();
  }

  void undoLastAction() {
    if (!isEngineReady.value || !engine.canUndo) return;
    engine.undo();
    _syncState();
  }

  void undoLastMatchPoint() {
    if (!isEngineReady.value || hasMatchEndUndoBeenUsed.value || !engine.canUndo) return;
    hasMatchEndUndoBeenUsed.value = true;
    engine.undo();
    _syncState();
  }

  void _syncState() {
    liveState.value = engine.state;
    final updatedState = liveState.value;
    if (updatedState == null || currentMatch.value == null) return;

    final isCompleted = updatedState.isMatchFinished;
    String resultText = '';
    if (isCompleted) {
      final winnerName = updatedState.matchWinner == PlayerSide.sideA
          ? currentMatch.value!.homeTeam
          : currentMatch.value!.awayTeam;
      resultText = '$winnerName won (${updatedState.sideAScore} - ${updatedState.sideBScore})';
    }

    final updatedModel = KabaddiMatchModel(
      matchId: currentMatch.value!.matchId,
      userId: currentMatch.value!.userId,
      homeTeam: currentMatch.value!.homeTeam,
      awayTeam: currentMatch.value!.awayTeam,
      homeScore: updatedState.sideAScore,
      awayScore: updatedState.sideBScore,
      currentHalf: updatedState.currentHalf == 1 ? '1st Half' : '2nd Half',
      isCompleted: isCompleted,
      matchResult: resultText,
      engineState: updatedState.toJson(),
      createdAt: currentMatch.value!.createdAt,
      updatedAt: DateTime.now(),
    );

    currentMatch.value = updatedModel;
    KabaddiSqfliteService.updateMatch(updatedModel);

    // Sync to Firestore in background
    FirebaseFirestore.instance
        .collection('kabaddi_matches')
        .doc(updatedModel.matchId)
        .set(updatedModel.toFirebaseJson(), SetOptions(merge: true))
        .catchError((e) {
          debugPrint("Kabaddi Firestore sync error: $e");
        });
  }
}
