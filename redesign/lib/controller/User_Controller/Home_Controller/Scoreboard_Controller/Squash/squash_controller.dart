import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'dart:async';
import 'package:get/get.dart';
import 'package:uuid/uuid.dart';

import 'package:redesign/model/User_Models/Home_Models/Friends_Model/friends_model.dart';
import 'package:redesign/model/User_Models/Home_Models/Scoreboard_Model/Squash/squash_model.dart';
import 'package:redesign/model/User_Models/Home_Models/Scoreboard_Model/Squash/squash_state_models.dart';
import 'package:redesign/score_engine/squashMatchEngine/squash_match_engine.dart';
import 'package:redesign/sqflite/User_SQF/Home_SQF/Scoreboard_SQF/squashSqflite.dart';
import 'package:redesign/shared_preferences/userPreferences.dart';
import 'package:redesign/view/USER/Home/Scoreboard/Squash/live_match/squash_scoreboard_screen.dart';
import 'package:redesign/view/USER/Home/Scoreboard/coin_toss/coin_toss_screen.dart';

class SquashController extends GetxController {
  // Setup Parameters
  var isProRules = true.obs; // Pro Rules (Strict PARS 11 win by 2) vs Friendly Mode
  var scoringSystem = SquashScoringSystem.pars.obs; // Default PARS
  var pointsToWin = 11.obs;
  var gamesToWin = 2.obs; // Best of 3 = 2 games to win
  var winByTwo = true.obs;
  var format = 'Singles'.obs; // Singles (1v1) or Doubles (2v2)
  var maxAllowedPlayers = 1.obs;

  var teamAPlayers = <String>[].obs;
  var teamBPlayers = <String>[].obs;

  var teamARoster = <FriendModel>[].obs;
  var teamBRoster = <FriendModel>[].obs;

  var homeTeamController = TextEditingController();
  var awayTeamController = TextEditingController();

  var isLoading = false.obs;
  var currentUserFriendModel = Rxn<FriendModel>();

  // ════════════════════ LIVE MATCH STATE ════════════════════
  var currentMatchId = ''.obs;
  var currentMatch = Rxn<SquashMatchModel>();
  var tournamentId = ''.obs;
  var bracketMatchId = ''.obs;
  var isReadOnly = false.obs;
  var hasMatchEndUndoBeenUsed = false.obs;

  // Real-time engine
  late SquashMatchEngine engine;
  var isEngineReady = false.obs;
  var liveState = Rxn<SquashMatchState>();

  @override
  void onInit() {
    super.onInit();
    _loadCurrentUserProfile();
  }

  Future<void> _loadCurrentUserProfile() async {
    try {
      final user = FirebaseAuth.instance.currentUser;
      if (user != null) {
        final name = await UserPreferences.getUserName();
        final pic = await UserPreferences.getProfileImageUrl();
        currentUserFriendModel.value = FriendModel(
          email: user.email ?? '',
          fullName: name ?? '',
          profileImageUrl: pic ?? '',
        );
      }
    } catch (e) {
      debugPrint("Error loading profile in SquashController: $e");
    }
  }

  // ════════════════════ SETUP METHODS ════════════════════

  void toggleProRules(bool val) {
    isProRules.value = val;
    if (val) {
      // Pro WSF Rules
      winByTwo.value = true;
      pointsToWin.value = 11;
      scoringSystem.value = SquashScoringSystem.pars;
    } else {
      // Friendly Mode
      winByTwo.value = false;
    }
  }

  void setFormat(String newFormat) {
    format.value = newFormat;
    if (newFormat == 'Singles') {
      maxAllowedPlayers.value = 1;
    } else {
      maxAllowedPlayers.value = 2;
    }
    teamARoster.clear();
    teamBRoster.clear();
    teamAPlayers.clear();
    teamBPlayers.clear();
  }

  void setGamesToWin(int games) {
    gamesToWin.value = games;
  }

  void incrementPoints() {
    pointsToWin.value++;
  }

  void decrementPoints() {
    if (pointsToWin.value > 5) {
      pointsToWin.value--;
    }
  }

  void addTeamPlayer(bool isTeamA, FriendModel player) {
    final roster = isTeamA ? teamARoster : teamBRoster;
    final playersList = isTeamA ? teamAPlayers : teamBPlayers;

    if (roster.length >= maxAllowedPlayers.value) {
      Get.snackbar('Limit Reached', 'Cannot add more players to this side.');
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
            sport: 'squash',
            onTossComplete: (tossWinner, tossDecision) async {
              final isWinnerA = tossWinner == teamAName;
              final servingSide = (isWinnerA && tossDecision == 'serve') ||
                      (!isWinnerA && tossDecision == 'receive')
                  ? PlayerSide.sideA
                  : PlayerSide.sideB;

              await createAndStartMatch(navContext, initialServingSide: servingSide);
            },
          ),
        ),
      );
    }
  }

  Future<void> createAndStartMatch(BuildContext? context, {PlayerSide initialServingSide = PlayerSide.sideA}) async {
    try {
      isLoading.value = true;
      final user = FirebaseAuth.instance.currentUser;
      final matchId = currentMatchId.value.isNotEmpty ? currentMatchId.value : const Uuid().v4();

      final config = SquashMatchConfig(
        scoringSystem: scoringSystem.value,
        pointsToWin: pointsToWin.value,
        gamesToWin: gamesToWin.value,
        winByTwo: winByTwo.value,
        isFriendlyRules: !isProRules.value,
        isDoubles: format.value == 'Doubles',
      );

      final initialState = SquashMatchState(
        config: config,
        teamA: teamARoster.map((f) => SquashPlayer(name: f.fullName.isNotEmpty ? f.fullName : f.email, email: f.email)).toList(),
        teamB: teamBRoster.map((f) => SquashPlayer(name: f.fullName.isNotEmpty ? f.fullName : f.email, email: f.email)).toList(),
        currentServer: initialServingSide,
        currentServeBox: ServeBox.right,
        mustSelectServeBox: true, // WSF Rule 4.2: Server chooses box at start of match
      );

      final allPlayersList = <String>[...teamAPlayers, ...teamBPlayers];
      if (user?.uid != null && !allPlayersList.contains(user!.uid)) {
        allPlayersList.add(user.uid);
      }

      final newMatch = SquashMatchModel(
        matchId: matchId,
        createdBy: user?.uid ?? 'unknown',
        sport: 'squash',
        allPlayers: allPlayersList,
        teamAPlayers: teamAPlayers.toList(),
        teamBPlayers: teamBPlayers.toList(),
        maxAllowedPlayers: maxAllowedPlayers.value,
        isFriendlyRules: !isProRules.value,
        scoringSystem: scoringSystem.value.name,
        pointsToWin: pointsToWin.value,
        gamesToWin: gamesToWin.value,
        winByTwo: winByTwo.value,
        status: 'In Progress',
        createdAt: DateTime.now(),
        engineState: initialState.toJson(),
        lastUpdatedAt: DateTime.now(),
      );

      // Local save
      await SquashSqflite.instance.createMatch(newMatch);

      // Remote save
      try {
        await FirebaseFirestore.instance.collection('matches').doc(matchId).set(newMatch.toJson());
      } catch (e) {
        debugPrint("Remote firestore match write error (offline fallback ok): $e");
      }

      // Start locally
      currentMatchId.value = matchId;
      currentMatch.value = newMatch;
      _initEngineFromState(initialState);

      final navContext = context ?? Get.context;
      if (navContext != null && navContext.mounted) {
        Navigator.push(
          navContext,
          MaterialPageRoute(builder: (context) => const SquashScoreboardScreen()),
        );
      }
    } catch (e) {
      Get.snackbar('Error', 'Failed to start Squash match: $e');
    } finally {
      isLoading.value = false;
    }
  }

  void _initEngineFromState(SquashMatchState state) {
    engine = SquashMatchEngine(state);
    liveState.value = engine.state;
    isEngineReady.value = true;
  }

  void restoreSquashMatchFromSqflite(SquashMatchModel match) {
    currentMatchId.value = match.matchId;
    currentMatch.value = match;

    if (match.engineState != null) {
      final restoredState = SquashMatchState.fromJson(match.engineState!);
      _initEngineFromState(restoredState);
    }
  }

  // ════════════════════ LIVE SCORING ACTIONS ════════════════════

  void scoreRally(PlayerSide winner) {
    if (!isEngineReady.value) return;
    engine.scoreRally(winner);
    _syncState();
  }

  void recordLet() {
    if (!isEngineReady.value) return;
    engine.recordLet();
    _syncState();
  }

  void recordStroke(PlayerSide recipient) {
    if (!isEngineReady.value) return;
    engine.recordStroke(recipient);
    _syncState();
  }

  void recordNoLet(PlayerSide recipient) {
    if (!isEngineReady.value) return;
    engine.recordNoLet(recipient);
    _syncState();
  }

  void recordConductWarning(PlayerSide side, String reason) {
    if (!isEngineReady.value) return;
    engine.recordConductWarning(side, reason);
    _syncState();
  }

  void recordConductStroke(PlayerSide recipient) {
    if (!isEngineReady.value) return;
    engine.recordConductStroke(recipient);
    _syncState();
  }

  void recordConductGame(PlayerSide recipient) {
    if (!isEngineReady.value) return;
    engine.recordConductGame(recipient);
    _syncState();
  }

  void selectServeBox(ServeBox box) {
    if (!isEngineReady.value) return;
    engine.selectServeBox(box);
    _syncState();
  }

  void switchServeBox() {
    if (!isEngineReady.value) return;
    engine.switchServeBox();
    _syncState();
  }

  void selectHihoDeuceOption(int target) {
    if (!isEngineReady.value) return;
    engine.selectHihoDeuceOption(target);
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

  void startNextGame() {
    if (!isEngineReady.value) return;
    engine.startNextGame();
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
          ? (updatedState.teamA.isNotEmpty ? updatedState.teamA.first.name : 'Side A')
          : (updatedState.teamB.isNotEmpty ? updatedState.teamB.first.name : 'Side B');
      resultText = '$winnerName won (${updatedState.sideAGamesWon} - ${updatedState.sideBGamesWon})';
    }

    final updatedModel = SquashMatchModel(
      matchId: currentMatch.value!.matchId,
      createdBy: currentMatch.value!.createdBy,
      sport: 'squash',
      allPlayers: currentMatch.value!.allPlayers,
      teamAPlayers: currentMatch.value!.teamAPlayers,
      teamBPlayers: currentMatch.value!.teamBPlayers,
      maxAllowedPlayers: currentMatch.value!.maxAllowedPlayers,
      isFriendlyRules: currentMatch.value!.isFriendlyRules,
      scoringSystem: updatedState.config.scoringSystem.name,
      pointsToWin: updatedState.config.pointsToWin,
      gamesToWin: updatedState.config.gamesToWin,
      winByTwo: updatedState.config.winByTwo,
      status: isCompleted ? 'completed' : 'In Progress',
      createdAt: currentMatch.value!.createdAt,
      engineState: updatedState.toJson(),
      lastUpdatedAt: DateTime.now(),
      matchResult: resultText,
      tournamentId: currentMatch.value!.tournamentId,
      bracketMatchId: currentMatch.value!.bracketMatchId,
      bookingId: currentMatch.value!.bookingId,
      matchType: currentMatch.value!.matchType,
      isRecoverable: !isCompleted,
    );

    currentMatch.value = updatedModel;

    // Asynchronous background persistence
    SquashSqflite.instance.updateMatch(updatedModel);
    try {
      FirebaseFirestore.instance
          .collection('matches')
          .doc(updatedModel.matchId)
          .set(updatedModel.toJson(), SetOptions(merge: true));
    } catch (_) {}
  }
}
