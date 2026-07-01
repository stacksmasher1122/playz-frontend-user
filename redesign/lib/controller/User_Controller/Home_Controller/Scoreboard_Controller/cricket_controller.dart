import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:redesign/view/USER/Home/Scoreboard/Cricket/cricket_scoreboard/cricket_scoreboard_screen.dart';
import 'package:uuid/uuid.dart';
import 'package:redesign/model/User_Models/Home_Models/Scoreboard_Model/cricket_model.dart';
import 'package:redesign/model/User_Models/Home_Models/Friends_Model/friends_model.dart';
import 'package:redesign/sqflite/User_SQF/Home_SQF/Scoreboard_SQF/cricketSqflite.dart';
import 'package:redesign/view/USER/Home/Scoreboard/coin_toss/coin_toss_screen.dart';
import 'package:redesign/model/User_Models/Home_Models/Scoreboard_Model/cricket_state_models.dart';
import 'package:redesign/shared_preferences/userPreferences.dart';
import 'package:redesign/score_engine/cricketMatchEngine/cricket_match_engine.dart';

class CricketController extends GetxController {
  // Setup Parameters
  var squadLimit = 11.obs;
  var subsEnabled = true.obs;
  var maxSubstitutes = 3.obs;
  var overs = 20.obs;
  var isFormalRules = true.obs; // Toggle for Last Man Standing

  var homeTeamName = 'Team Red'.obs;
  var awayTeamName = 'Team Blue'.obs;

  final homeTeamController = TextEditingController(text: 'Team Red');
  final awayTeamController = TextEditingController(text: 'Team Blue');

  var homeTeamPlayers = <String>[].obs;
  var awayTeamPlayers = <String>[].obs;

  var homeTeamRoster = <FriendModel>[].obs;
  var awayTeamRoster = <FriendModel>[].obs;

  var isLoading = false.obs;

  var currentUserFriendModel = Rxn<FriendModel>();

  // ════════════════════ LIVE MATCH STATE ════════════════════
  var currentMatchId = ''.obs;
  var currentMatch = Rxn<CricketMatchModel>();

  // Real-time engine
  late MatchEngine engine;
  var isEngineReady = false.obs;
  // Observable wrapper for the state so UI can dynamically rebuild
  var liveState = Rxn<MatchState>();

  @override
  void onInit() {
    super.onInit();
    _loadCurrentUser();
    homeTeamController.addListener(() {
      homeTeamName.value = homeTeamController.text;
    });
    awayTeamController.addListener(() {
      awayTeamName.value = awayTeamController.text;
    });
  }

  @override
  void onClose() {
    homeTeamController.dispose();
    awayTeamController.dispose();
    super.onClose();
  }

  Future<void> _loadCurrentUser() async {
    final email =
        await UserPreferences.getUserEmail() ??
        await UserPreferences.getDocId() ??
        '';
    final name = await UserPreferences.getUserName() ?? '';
    final pic = await UserPreferences.getProfileImageUrl() ?? '';

    if (email.isNotEmpty) {
      currentUserFriendModel.value = FriendModel(
        email: email,
        fullName: name,
        profileImageUrl: pic,
        isOnline: true,
      );
    }
  }

  // ════════════════════ SETUP ACTIONS ════════════════════
  void incrementSquadLimit() {
    if (squadLimit.value < 15) squadLimit.value++;
  }

  void decrementSquadLimit() {
    if (squadLimit.value > 1) squadLimit.value--;
  }

  void toggleSubs(bool val) => subsEnabled.value = val;
  void incrementSubs() {
    if (maxSubstitutes.value < 10) maxSubstitutes.value++;
  }

  void decrementSubs() {
    if (maxSubstitutes.value > 0) maxSubstitutes.value--;
  }

  void incrementOvers() {
    if (overs.value < 50) overs.value++;
  }

  void decrementOvers() {
    if (overs.value > 1) overs.value--;
  }

  void toggleFormalRules(bool val) => isFormalRules.value = val;

  int get maxAllowedPlayers =>
      squadLimit.value + (subsEnabled.value ? maxSubstitutes.value : 0);

  void addTeamPlayer(bool isHome, FriendModel friend) {
    if (isHome) {
      if (homeTeamRoster.length < maxAllowedPlayers) {
        if (!homeTeamPlayers.contains(friend.email)) {
          homeTeamPlayers.add(friend.email);
          homeTeamRoster.add(friend);
        }
      } else {
        Get.snackbar('Limit Reached', 'Cannot add more players to Home Team');
      }
    } else {
      if (awayTeamRoster.length < maxAllowedPlayers) {
        if (!awayTeamPlayers.contains(friend.email)) {
          awayTeamPlayers.add(friend.email);
          awayTeamRoster.add(friend);
        }
      } else {
        Get.snackbar('Limit Reached', 'Cannot add more players to Away Team');
      }
    }
  }

  void removeTeamPlayer(bool isHome, FriendModel friend) {
    if (isHome) {
      homeTeamPlayers.remove(friend.email);
      homeTeamRoster.removeWhere((f) => f.email == friend.email);
    } else {
      awayTeamPlayers.remove(friend.email);
      awayTeamRoster.removeWhere((f) => f.email == friend.email);
    }
  }

  List<String> getTeamPlayerNames(bool isHome) {
    final roster = isHome ? homeTeamRoster : awayTeamRoster;
    if (roster.isNotEmpty) {
      return roster
          .map((f) => f.fullName.isNotEmpty ? f.fullName : f.email)
          .toList();
    }
    return List.generate(squadLimit.value, (i) => 'Player ${i + 1}');
  }

  void goToToss() {
    if (homeTeamName.value.trim().isEmpty ||
        awayTeamName.value.trim().isEmpty) {
      Get.snackbar(
        'Validation',
        'Please enter names for both teams',
        snackPosition: SnackPosition.BOTTOM,
      );
      return;
    }
    Get.to(() => const CoinFlipScreen());
  }

  // ════════════════════ MATCH LIFECYCLE ════════════════════

  Future<void> finalizeMatchAndStart(
    String tossWinner,
    String tossDecision,
  ) async {
    try {
      isLoading.value = true;
      final String matchId = const Uuid().v4();
      final String? currentUserId = FirebaseAuth.instance.currentUser?.uid;
      final String safeUserId = currentUserId ?? 'local_user';

      List<String> allPlayers = [];
      allPlayers.addAll(homeTeamPlayers);
      allPlayers.addAll(awayTeamPlayers);
      if (currentUserId != null && !allPlayers.contains(currentUserId)) {
        allPlayers.add(currentUserId);
      }

      String battingFirst = '';
      String bowlingFirst = '';
      String otherTeam = tossWinner == homeTeamName.value
          ? awayTeamName.value
          : homeTeamName.value;

      if (tossDecision == 'bat') {
        battingFirst = tossWinner;
        bowlingFirst = otherTeam;
      } else {
        bowlingFirst = tossWinner;
        battingFirst = otherTeam;
      }

      final newMatch = CricketMatchModel(
        matchId: matchId,
        createdBy: safeUserId,
        allPlayers: allPlayers,
        homeTeamName: homeTeamName.value,
        awayTeamName: awayTeamName.value,
        homeTeamPlayers: homeTeamPlayers.toList(),
        awayTeamPlayers: awayTeamPlayers.toList(),
        squadLimit: squadLimit.value,
        subsEnabled: subsEnabled.value,
        maxSubstitutes: maxSubstitutes.value,
        overs: overs.value,
        status: 'live',
        scorecard: {},
        createdAt: DateTime.now(),
        tossWinner: tossWinner,
        tossDecision: tossDecision,
        battingFirstTeam: battingFirst,
        bowlingFirstTeam: bowlingFirst,
        currentInnings: 1,
        currentBattingTeam: battingFirst,
        currentBowlingTeam: bowlingFirst,
      );

      await CricketSqflite.instance.insertMatch(newMatch);

      try {
        await FirebaseFirestore.instance
            .collection('matches')
            .doc(matchId)
            .set(newMatch.toJson());
      } catch (e) {
        debugPrint("Firestore creation error (non-critical): $e");
      }

      currentMatchId.value = matchId;
      currentMatch.value = newMatch;

      _initEngine(newMatch);
      _listenToFirestore(matchId);

      Get.offAll(() => const CricketScoreboardScreen());
    } catch (e) {
      if (Get.context != null) {
        Get.snackbar(
          'Error',
          'Failed to create match: $e',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: const Color(0xFF2A2A2A),
          colorText: Colors.white,
        );
      }
    } finally {
      isLoading.value = false;
    }
  }

  void _initEngine(CricketMatchModel match) {
    List<Player> initialBat = match.battingFirstTeam == homeTeamName.value
        ? getTeamPlayerNames(true).map((n) => Player(name: n)).toList()
        : getTeamPlayerNames(false).map((n) => Player(name: n)).toList();

    List<Player> initialBowl = match.bowlingFirstTeam == homeTeamName.value
        ? getTeamPlayerNames(true).map((n) => Player(name: n)).toList()
        : getTeamPlayerNames(false).map((n) => Player(name: n)).toList();

    engine = MatchEngine(
      maxOvers: match.overs > 0 ? match.overs : 20,
      battingTeam: initialBat,
      bowlingTeam: initialBowl,
      matchConfig: MatchConfig(
        maxOvers: match.overs > 0 ? match.overs : 20,
        maxOversPerBowler: match.overs <= 5 ? 1 : (match.overs ~/ 5),
        isFormalRules: isFormalRules.value,
        format: match.overs <= 10 ? 'T10' : (match.overs <= 20 ? 'T20' : 'ODI'),
      ),
    );
    liveState.value = engine.state;
    isEngineReady.value = true;
  }

  String _buildCommentary(BallEvent ball) {
    final s = ball.strikerName;
    final b = ball.bowlerName;
    final r = ball.runs;

    if (ball.dismissalType != null) {
      String type = ball.dismissalType!.name
          .replaceAll('runOut', 'run out')
          .replaceAll('retiredHurt', 'retired hurt');
      return '$b to $s, WICKET ($type)!! ${ball.batterOutName} is gone.';
    }

    if (ball.extraType != null) {
      if (ball.extraType == ExtraType.wide) {
        return '$b to $s, WIDE ball. Pressure on the bowler.';
      }
      if (ball.extraType == ExtraType.noBall) {
        return '$b to $s, NO BALL! Free hit coming up.';
      }
      return '$b to $s, ${ball.extraRuns} ${ball.extraType!.name}(s).';
    }

    if (r == 6) return '$b to $s, SIX!! That is huge, out of the ground!';
    if (r == 4) return '$b to $s, FOUR! Elegantly placed through the gaps.';
    if (r == 0) return '$b to $s, no run. Solid defense.';

    return '$b to $s, ${r == 1 ? "single" : "$r runs"}. Well played.';
  }

  // ════════════════════ SCOREBOARD ACTIONS ════════════════════

  Future<void> resumeMatch(String matchId) async {
    isLoading.value = true;
    final match = await CricketSqflite.instance.getMatch(matchId);
    if (match != null) {
      final String currentUserId = FirebaseAuth.instance.currentUser?.uid ?? '';
      if (currentUserId.isNotEmpty &&
          !match.allPlayers.contains(currentUserId)) {
        Get.snackbar('Access Denied', 'You are not a player in this match.');
        isLoading.value = false;
        return;
      }
      currentMatchId.value = matchId;
      currentMatch.value = match;
      _initEngine(match);
      if (match.engineState != null) {
        engine.restoreState(match.engineState!);
        liveState.value = engine.state;
      }

      _listenToFirestore(matchId);
      Get.to(() => const CricketScoreboardScreen());
    } else {
      Get.snackbar('Error', 'Match data not found localy.');
    }
    isLoading.value = false;
  }

  void _listenToFirestore(String matchId) {
    FirebaseFirestore.instance
        .collection('matches')
        .doc(matchId)
        .snapshots()
        .listen((doc) {
          if (doc.exists && doc.data() != null) {
            final m = CricketMatchModel.fromMap(doc.data()!);
            if (currentMatch.value == null ||
                m.lastUpdatedAt.isAfter(currentMatch.value!.lastUpdatedAt)) {
              currentMatch.value = m;
              if (m.engineState != null &&
                  FirebaseAuth.instance.currentUser?.uid != m.createdBy) {
                engine.restoreState(m.engineState!);
                liveState.value = engine.state;
              }
            }
          }
        });
  }

  void updateEngineState() {
    final lastBall = engine.state.ballHistory.isNotEmpty
        ? engine.state.ballHistory.last
        : null;
    if (lastBall != null && lastBall.commentary.isEmpty) {
      final comm = _buildCommentary(lastBall);
      final updatedBall = lastBall.copyWith(commentary: comm);
      final updatedHistory = List<BallEvent>.from(engine.state.ballHistory);
      updatedHistory[updatedHistory.length - 1] = updatedBall;

      // Ownership of state is handled by engine, but we can restore an updated snapshot
      engine.restoreState(
        engine.state.copyWith(ballHistory: updatedHistory).toJson(),
      );
    }

    liveState.value = engine.state;
    liveState.refresh();
    _syncToDatabaseAsync(engine.state);
  }

  void startInnings({
    required String strikerName,
    required String nonStrikerName,
    required String bowlerName,
  }) {
    engine.startInnings(
      strikerName: strikerName,
      nonStrikerName: nonStrikerName,
      bowlerName: bowlerName,
    );
    updateEngineState();
  }

  void addRuns(int runs) {
    engine.dispatch(DeliveryEvent(runs: runs));
    updateEngineState();
  }

  void addExtra(ExtraType type, int runInAdditionToExtra) {
    engine.dispatch(DeliveryEvent(extra: type, runs: runInAdditionToExtra));
    updateEngineState();
  }

  void addWicket(
    DismissalType type, {
    String? fielder,
    String? newBatterName,
    bool newBatterOnStrike = true,
    String? outPlayer = 'striker',
    bool crossed = false,
    int runInAdditionToWicket = 0,
  }) {
    engine.dispatch(
      DeliveryEvent(
        runs: runInAdditionToWicket,
        crossedBeforeThrow: crossed,
        wickets: [
          WicketDetails(
            type: type,
            outPlayerName: outPlayer == 'striker'
                ? engine.state.striker!.name
                : engine.state.nonStriker!.name,
            fielderName: fielder,
          ),
        ],
        newBatterName: newBatterName,
        newBatterOnStrike: newBatterOnStrike,
      ),
    );
    updateEngineState();
  }

  void changeBowler(String newBowlerName) {
    engine.changeBowler(newBowlerName);
    updateEngineState();
  }

  void undoEvent() {
    if (engine.canUndo) {
      engine.undo();
      // Need to delete last event from subcollection logically, or just let states handle it.
      // But subcollections are tricky. For now just sync state.
      updateEngineState();
    }
  }

  void startSuperOver() {
    engine.startSuperOver();
    updateEngineState();
  }

  void startSecondInnings() {
    engine.startSecondInnings();
    updateEngineState();
  }

  Future<void> _syncToDatabaseAsync(MatchState state) async {
    if (currentMatchId.value.isEmpty || currentMatch.value == null) return;

    final lastEvent = state.ballHistory.isNotEmpty
        ? state.ballHistory.last
        : null;

    Map<String, dynamic> sc = Map<String, dynamic>.from(
      currentMatch.value!.scorecard,
    );
    List<Map<String, dynamic>> inningsArr = List.from(
      currentMatch.value!.inningsArray,
    );

    final currentScorecard = engine.generateScorecard();

    if (state.inningsNumber == 1) {
      sc['innings1'] = currentScorecard;
    } else {
      sc['innings2'] = currentScorecard;
    }

    if (inningsArr.length < state.inningsNumber) {
      inningsArr.add(currentScorecard);
    } else {
      inningsArr[state.inningsNumber - 1] = currentScorecard;
    }

    var updated = currentMatch.value!.copyWith(
      currentInnings: state.inningsNumber,
      innings1Score: state.inningsNumber == 1
          ? state.totalRuns
          : currentMatch.value!.innings1Score,
      innings1Wickets: state.inningsNumber == 1
          ? state.wickets
          : currentMatch.value!.innings1Wickets,
      innings1Overs: state.inningsNumber == 1
          ? state.overs
          : currentMatch.value!.innings1Overs,
      innings1Balls: state.inningsNumber == 1
          ? state.balls
          : currentMatch.value!.innings1Balls,
      innings2Score: state.inningsNumber == 2
          ? state.totalRuns
          : currentMatch.value!.innings2Score,
      innings2Wickets: state.inningsNumber == 2
          ? state.wickets
          : currentMatch.value!.innings2Wickets,
      innings2Overs: state.inningsNumber == 2
          ? state.overs
          : currentMatch.value!.innings2Overs,
      innings2Balls: state.inningsNumber == 2
          ? state.balls
          : currentMatch.value!.innings2Balls,
      matchResult: state.matchStatus == 'MATCH_COMPLETED'
          ? 'Match Finished'
          : '',
      scorecard: sc,
      inningsArray: inningsArr,
      engineState: state.toJson(),
      lastUpdatedAt: DateTime.now(),
      status: state.matchStatus == 'MATCH_COMPLETED' ? 'completed' : 'live',
    );

    currentMatch.value = updated;

    // OFFLINE FIRST: local db first
    await CricketSqflite.instance.updateMatch(updated);

    try {
      final docRef = FirebaseFirestore.instance
          .collection('matches')
          .doc(updated.matchId);
      await docRef.update(updated.toJson());

      // Event-based sync to subcollection (scale proof)
      if (lastEvent != null) {
        await docRef
            .collection('balls')
            .doc(lastEvent.id)
            .set(lastEvent.toJson());
      }
    } catch (e) {
      debugPrint("Firestore sync error: $e");
    }
  }
}
