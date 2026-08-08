import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'dart:async';
import 'package:get/get.dart';
import 'package:uuid/uuid.dart';

import 'package:redesign/model/User_Models/Home_Models/Friends_Model/friends_model.dart';
import 'package:redesign/model/User_Models/Home_Models/Scoreboard_Model/badminton_model.dart';
import 'package:redesign/model/User_Models/Home_Models/Scoreboard_Model/badminton_state_models.dart';
import 'package:redesign/sqflite/User_SQF/Home_SQF/Scoreboard_SQF/badmintonSqflite.dart';
import 'package:redesign/score_engine/badmintonMatchEngine/badminton_match_engine.dart';
import 'package:redesign/shared_preferences/userPreferences.dart';
import 'package:redesign/view/USER/Home/Scoreboard/Badminton/live_match/badminton_scoreboard_screen.dart';
import 'package:redesign/view/USER/Home/Scoreboard/coin_toss/coin_toss_screen.dart';
import 'package:redesign/services/xp_reward_service.dart';

import 'package:redesign/common/common_select_players_sheet.dart';

class BadmintonController extends GetxController {
  // Setup Parameters
  var isFriendlyRules = false.obs;
  var isProRules = true.obs;
  var pointsToWin = 21.obs;
  var gamesToWin = 2.obs;
  var setsFormat = 'BEST_OF_3'.obs;
  var winByTwo = true.obs;
  var maxPointCap = 30.obs;
  var intervalsEnabled = true.obs;
  var endsChangeEnabled = true.obs;
  var format = 'SINGLES'.obs;

  var maxAllowedPlayers = 1.obs; // 1 for singles, 2 for doubles

  final homeTeamController = TextEditingController(text: 'Side A');
  final awayTeamController = TextEditingController(text: 'Side B');
  var homeTeamName = 'Side A'.obs;
  var awayTeamName = 'Side B'.obs;

  var teamAPlayers = <String>[].obs;
  var teamBPlayers = <String>[].obs;

  var teamARoster = <FriendModel>[].obs;
  var teamBRoster = <FriendModel>[].obs;

  var isLoading = false.obs;

  var currentUserFriendModel = Rxn<FriendModel>();

  // ════════════════════ LIVE MATCH STATE ════════════════════
  var currentMatchId = ''.obs;
  var currentMatch = Rxn<BadmintonMatchModel>();
  var tournamentId = ''.obs;
  var bracketMatchId = ''.obs;
  var isReadOnly = false.obs;
  var hasMatchEndUndoBeenUsed = false.obs;

  // Real-time engine
  late BadmintonMatchEngine engine;
  var isEngineReady = false.obs;
  var liveState = Rxn<BadmintonMatchState>();

  @override
  void onInit() {
    super.onInit();
    _loadCurrentUserProfile();
    homeTeamController.addListener(() {
      homeTeamName.value = homeTeamController.text;
    });
    awayTeamController.addListener(() {
      awayTeamName.value = awayTeamController.text;
    });
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
      debugPrint("Error loading profile: $e");
    }
  }

  // ════════════════════ SETUP METHODS ════════════════════

  void toggleFriendlyRules(bool val) {
    isFriendlyRules.value = val;
    isProRules.value = !val;
    if (val) {
      // Relaxed defaults
      winByTwo.value = false;
      intervalsEnabled.value = false;
      endsChangeEnabled.value = false;
    } else {
      // Strict defaults
      winByTwo.value = true;
      intervalsEnabled.value = true;
      endsChangeEnabled.value = true;
      pointsToWin.value = 21;
      maxPointCap.value = 30;
    }
  }

  void toggleProRules(bool val) {
    isProRules.value = val;
    toggleFriendlyRules(!val);
  }

  void setFormat(String newFormat) {
    format.value = newFormat.toUpperCase();
    if (format.value == 'SINGLES') {
      maxAllowedPlayers.value = 1;
      if (teamARoster.length > 1) {
        teamARoster.removeRange(1, teamARoster.length);
        teamAPlayers.assignAll(teamARoster.map((p) => p.email));
      }
      if (teamBRoster.length > 1) {
        teamBRoster.removeRange(1, teamBRoster.length);
        teamBPlayers.assignAll(teamBRoster.map((p) => p.email));
      }
    } else {
      maxAllowedPlayers.value = 2;
    }
  }

  void setSetsFormat(String setCode) {
    setsFormat.value = setCode;
    if (setCode == 'BEST_OF_1') {
      gamesToWin.value = 1;
    } else if (setCode == 'BEST_OF_5') {
      gamesToWin.value = 3;
    } else {
      gamesToWin.value = 2;
    }
  }

  void incrementPoints() {
    pointsToWin.value++;
    maxPointCap.value = pointsToWin.value + 9;
  }

  void decrementPoints() {
    if (pointsToWin.value > 5) {
      pointsToWin.value--;
      maxPointCap.value = pointsToWin.value + 9;
    }
  }

  void addTeamPlayer(bool isTeamA, FriendModel player) {
    final roster = isTeamA ? teamARoster : teamBRoster;
    final playersList = isTeamA ? teamAPlayers : teamBPlayers;

    if (roster.any((p) => p.email == player.email)) return;

    final maxCount = maxAllowedPlayers.value;
    if (roster.length >= maxCount) {
      if (maxCount == 1) {
        roster.clear();
        playersList.clear();
      } else {
        roster.removeAt(0);
        if (playersList.isNotEmpty) playersList.removeAt(0);
      }
    }
    roster.add(player);
    playersList.add(player.email);

    if (isTeamA && (homeTeamController.text == 'Side A' || homeTeamController.text.isEmpty)) {
      homeTeamController.text = player.fullName.isNotEmpty ? player.fullName : player.email;
      homeTeamName.value = homeTeamController.text;
    } else if (!isTeamA && (awayTeamController.text == 'Side B' || awayTeamController.text.isEmpty)) {
      awayTeamController.text = player.fullName.isNotEmpty ? player.fullName : player.email;
      awayTeamName.value = awayTeamController.text;
    }
  }

  void removeTeamPlayer(bool isTeamA, FriendModel player) {
    final roster = isTeamA ? teamARoster : teamBRoster;
    final playersList = isTeamA ? teamAPlayers : teamBPlayers;

    roster.removeWhere((p) => p.email == player.email);
    playersList.remove(player.email);
  }

  void openPlayerSelection(BuildContext context, bool isSideA) {
    final selectedEmails = isSideA ? teamAPlayers : teamBPlayers;
    final opponentEmails = isSideA ? teamBPlayers : teamAPlayers;
    final sideLabel = isSideA
        ? (homeTeamController.text.isNotEmpty ? homeTeamController.text : 'Side A')
        : (awayTeamController.text.isNotEmpty ? awayTeamController.text : 'Side B');
    final maxCount = maxAllowedPlayers.value;

    CommonSelectPlayersBottomSheet.show(
      context,
      title: 'Select $sideLabel Player',
      maxCount: maxCount,
      selectedPlayerEmails: selectedEmails,
      opponentPlayerEmails: opponentEmails,
      onPlayerSelected: (friend) {
        addTeamPlayer(isSideA, friend);
      },
    );
  }

  void openTossDecision(BuildContext context) {
    if (teamARoster.isEmpty || teamBRoster.isEmpty) {
      Get.snackbar('Error', 'Both sides need at least 1 player');
      return;
    }

    final sideAName = homeTeamController.text.trim().isNotEmpty
        ? homeTeamController.text.trim()
        : 'Side A';
    final sideBName = awayTeamController.text.trim().isNotEmpty
        ? awayTeamController.text.trim()
        : 'Side B';

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (ctx) => CoinFlipScreen(
          teamAName: sideAName,
          teamBName: sideBName,
          sport: 'badminton',
          onTossComplete: (tossWinner, tossDecision) async {
            final isWinnerA = tossWinner == sideAName;
            final servingSide = (isWinnerA && tossDecision.toLowerCase() == 'serve') ||
                    (!isWinnerA && tossDecision.toLowerCase() == 'choose side')
                ? PlayerSide.sideA
                : PlayerSide.sideB;

            await createAndStartMatch(context, initialServingSide: servingSide);
          },
        ),
      ),
    );
  }

  void goToToss([BuildContext? context]) {
    if (teamARoster.isEmpty || teamBRoster.isEmpty) {
      Get.snackbar('Error', 'Both sides need at least 1 player');
      return;
    }

    final teamAName = teamARoster.first.fullName.isNotEmpty
        ? teamARoster.first.fullName
        : 'Side A';
    final teamBName = teamBRoster.first.fullName.isNotEmpty
        ? teamBRoster.first.fullName
        : 'Side B';

    final navContext = context ?? Get.context;
    if (navContext != null) {
      Navigator.push(
        navContext,
        MaterialPageRoute(
          builder: (context) => CoinFlipScreen(
            teamAName: teamAName,
            teamBName: teamBName,
            sport: 'badminton',
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
    if (teamARoster.isEmpty || teamBRoster.isEmpty) {
      Get.snackbar('Error', 'Both sides need at least 1 player');
      return;
    }

    try {
      isLoading.value = true;
      final user = FirebaseAuth.instance.currentUser;
      final matchId = currentMatchId.value.isNotEmpty
          ? currentMatchId.value
          : const Uuid().v4();

      final config = BadmintonMatchConfig(
        pointsToWin: pointsToWin.value,
        maxPointCap: maxPointCap.value,
        winByTwo: winByTwo.value,
        gamesToWin: gamesToWin.value,
        isFriendlyRules: isFriendlyRules.value,
        intervalsEnabled: intervalsEnabled.value,
        endsChangeEnabled: endsChangeEnabled.value,
      );

      final initialState = BadmintonMatchState(
        config: config,
        teamA: teamARoster.map((f) => BadmintonPlayer(name: f.fullName.isNotEmpty ? f.fullName : f.email)).toList(),
        teamB: teamBRoster.map((f) => BadmintonPlayer(name: f.fullName.isNotEmpty ? f.fullName : f.email)).toList(),
        servingSide: initialServingSide,
      );

      final allPlayersList = <String>[...teamAPlayers, ...teamBPlayers];
      if (user?.uid != null && !allPlayersList.contains(user!.uid)) {
        allPlayersList.add(user.uid);
      }

      final newMatch = BadmintonMatchModel(
        matchId: matchId,
        createdBy: user?.uid ?? 'unknown',
        sport: 'badminton',
        allPlayers: allPlayersList,
        teamAPlayers: teamAPlayers.toList(),
        teamBPlayers: teamBPlayers.toList(),
        maxAllowedPlayers: maxAllowedPlayers.value,
        isFriendlyRules: isFriendlyRules.value,
        pointsToWin: pointsToWin.value,
        maxPointCap: maxPointCap.value,
        winByTwo: winByTwo.value,
        gamesToWin: gamesToWin.value,
        intervalsEnabled: intervalsEnabled.value,
        endsChangeEnabled: endsChangeEnabled.value,
        status: 'In Progress',
        createdAt: DateTime.now(),
        engineState: initialState.toJson(),
        lastUpdatedAt: DateTime.now(),
      );

      // Save Local
      await BadmintonSqflite.instance.createMatch(newMatch);

      // Save Remote
      await FirebaseFirestore.instance
          .collection('matches')
          .doc(matchId)
          .set(newMatch.toJson());

      // Start locally
      currentMatchId.value = matchId;
      currentMatch.value = newMatch;
      _initEngineFromState(initialState);

      final navContext = context ?? Get.context;
      if (navContext != null && navContext.mounted) {
        Navigator.push(
          navContext,
          MaterialPageRoute(builder: (context) => const BadmintonScoreboardScreen()),
        );
      }

    } catch (e) {
      Get.snackbar('Error', 'Failed to start match: $e');
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> createAndStartTournamentMatch({
    required String tId,
    required String bMatchId,
    required List<FriendModel> teamA,
    required List<FriendModel> teamB,
    required Map<String, dynamic> sportRules,
    String? teamALogo,
    String? teamBLogo,
    BuildContext? context,
  }) async {
    try {
      isLoading.value = true;
      isReadOnly.value = false;
      final user = FirebaseAuth.instance.currentUser;
      final matchId = const Uuid().v4();

      tournamentId.value = tId;
      bracketMatchId.value = bMatchId;

      teamARoster.assignAll(teamA);
      teamBRoster.assignAll(teamB);
      teamAPlayers.assignAll(teamA.map((p) => p.email).toList());
      teamBPlayers.assignAll(teamB.map((p) => p.email).toList());

      // Map tournament rules to engine config
      final int pointsToWinRule = sportRules['pointsPerGame'] ?? 21;
      final int gamesToWinRule = ((sportRules['bestOf'] ?? 3) / 2).ceil();

      // A7 Fix: Determine friendly rules from format config
      final bool isFriendly = sportRules['matchMode'] == 'friendly';
      final config = BadmintonMatchConfig(
        pointsToWin: pointsToWinRule,
        maxPointCap: pointsToWinRule + 9,
        winByTwo: !isFriendly,
        gamesToWin: gamesToWinRule,
        isFriendlyRules: isFriendly,
        intervalsEnabled: !isFriendly,
        endsChangeEnabled: true,
      );

      final initialState = BadmintonMatchState(
        config: config,
        teamA: teamA.map((f) => BadmintonPlayer(name: f.fullName.isNotEmpty ? f.fullName : f.email)).toList(),
        teamB: teamB.map((f) => BadmintonPlayer(name: f.fullName.isNotEmpty ? f.fullName : f.email)).toList(),
      );

      final newMatch = BadmintonMatchModel(
        matchId: matchId,
        createdBy: user?.uid ?? 'unknown',
        sport: 'badminton',
        allPlayers: [...teamAPlayers, ...teamBPlayers],
        teamAPlayers: teamAPlayers.toList(),
        teamBPlayers: teamBPlayers.toList(),
        maxAllowedPlayers: teamA.length,
        isFriendlyRules: false,
        pointsToWin: pointsToWinRule,
        maxPointCap: pointsToWinRule + 9,
        winByTwo: true,
        gamesToWin: gamesToWinRule,
        intervalsEnabled: true,
        endsChangeEnabled: true,
        status: 'In Progress',
        createdAt: DateTime.now(),
        engineState: initialState.toJson(),
        lastUpdatedAt: DateTime.now(),
        tournamentId: tId,
        bracketMatchId: bMatchId,
        teamALogo: teamALogo,
        teamBLogo: teamBLogo,
      );

      // Save Local
      await BadmintonSqflite.instance.createMatch(newMatch);

      // Save Remote (atomic WriteBatch)
      final batch = FirebaseFirestore.instance.batch();

      final matchDocRef = FirebaseFirestore.instance.collection('matches').doc(matchId);
      batch.set(matchDocRef, newMatch.toJson());

      final bracketDocRef = FirebaseFirestore.instance
          .collection('tournaments')
          .doc(tId)
          .collection('bracket')
          .doc(bMatchId);
      batch.update(bracketDocRef, {
        'status': 'in_progress',
        'liveMatchId': matchId,
      });

      await batch.commit();

      // Start locally
      currentMatchId.value = matchId;
      currentMatch.value = newMatch;
      _initEngineFromState(initialState);

      final navContext = context ?? Get.context;
      if (navContext != null && navContext.mounted) {
        Navigator.push(
          navContext,
          MaterialPageRoute(builder: (context) => const BadmintonScoreboardScreen()),
        );
      }

    } catch (e) {
      Get.snackbar('Error', 'Failed to start tournament match: $e');
    } finally {
      isLoading.value = false;
    }
  }

  void restoreBadmintonMatchFromSqflite(BadmintonMatchModel match) {
    currentMatchId.value = match.matchId;
    currentMatch.value = match;
    teamAPlayers.assignAll(match.teamAPlayers);
    teamBPlayers.assignAll(match.teamBPlayers);

    if (match.engineState != null) {
      final restoredState = BadmintonMatchState.fromJson(match.engineState!);
      _initEngineFromState(restoredState);
    } else {
      final config = BadmintonMatchConfig(
        pointsToWin: match.pointsToWin,
        maxPointCap: match.maxPointCap,
        winByTwo: match.winByTwo,
        gamesToWin: match.gamesToWin,
        isFriendlyRules: match.isFriendlyRules,
        intervalsEnabled: match.intervalsEnabled,
        endsChangeEnabled: match.endsChangeEnabled,
      );

      final initialState = BadmintonMatchState(
        config: config,
        teamA: match.teamAPlayers.map((n) => BadmintonPlayer(name: n)).toList(),
        teamB: match.teamBPlayers.map((n) => BadmintonPlayer(name: n)).toList(),
      );
      _initEngineFromState(initialState);
    }
    isEngineReady.value = true;
  }

  Future<void> resumeTournamentMatch({
    required String tId,
    required String bMatchId,
    required String matchId,
    bool readOnly = false,
    BuildContext? context,
  }) async {
    try {
      isLoading.value = true;
      isReadOnly.value = readOnly;
      final doc = await FirebaseFirestore.instance.collection('matches').doc(matchId).get();
      if (!doc.exists || doc.data() == null) {
        Get.snackbar("Error", "Match data not found.");
        return;
      }

      final matchData = doc.data()!;
      final matchModel = BadmintonMatchModel.fromJson(matchData);

      // A5 Fix: resumeTournamentMatch must not silently discard match data
      if (matchData['engineState'] == null) {
        Get.snackbar("Error", "Could not restore match state — contact support");
        return;
      }

      tournamentId.value = tId;
      bracketMatchId.value = bMatchId;
      currentMatchId.value = matchId;
      currentMatch.value = matchModel;

      final incomingState = BadmintonMatchState.fromJson(matchData['engineState']);
      _initEngineFromState(incomingState);

      final navContext = context ?? Get.context;
      if (navContext != null && navContext.mounted) {
        Navigator.push(
          navContext,
          MaterialPageRoute(builder: (context) => const BadmintonScoreboardScreen()),
        );
      }
    } catch (e) {
      Get.snackbar("Error", "Failed to resume match: $e");
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> viewTournamentMatch({
    required String tId,
    required String bMatchId,
    required String matchId,
    BuildContext? context,
  }) async {
    await resumeTournamentMatch(
      tId: tId,
      bMatchId: bMatchId,
      matchId: matchId,
      readOnly: true,
      context: context,
    );
  }

  // ════════════════════ ENGINE SYNC ════════════════════

  void _initEngineFromState(BadmintonMatchState state) {
    engine = BadmintonMatchEngine(state);
    liveState.value = engine.state;
    hasMatchEndUndoBeenUsed.value = false;
    isEngineReady.value = true;
    _listenToMatchUpdates();
  }

  void _listenToMatchUpdates() {
    if (currentMatchId.isEmpty) return;

    FirebaseFirestore.instance
        .collection('matches')
        .doc(currentMatchId.value)
        .snapshots()
        .listen((doc) {
      if (doc.exists && doc.data() != null) {
        final data = doc.data()!;
        final m = BadmintonMatchModel.fromJson(data);

        // Self-write guard: only restore from remote updates
        if (currentMatch.value == null ||
            (m.lastUpdatedAt != null &&
                m.lastUpdatedAt!.isAfter(currentMatch.value!.lastUpdatedAt ?? DateTime(2000)))) {
          currentMatch.value = m;

          // Only overwrite engine state if the update came from a DIFFERENT device
          if (data['engineState'] != null &&
              FirebaseAuth.instance.currentUser?.uid != m.createdBy) {
            engine = BadmintonMatchEngine(
              BadmintonMatchState.fromJson(data['engineState']),
            );
            liveState.value = engine.state;
          }
        }
      }
    });
  }

  String _buildMatchResult(BadmintonMatchState state) {
    if (state.status != MatchStatus.completed || state.matchWinner == null) {
      return '';
    }

    final winnerLabel = state.matchWinner == PlayerSide.sideA
        ? (state.teamA.isNotEmpty ? state.teamA.first.name : 'Side A')
        : (state.teamB.isNotEmpty ? state.teamB.first.name : 'Side B');

    final gamesWonA = state.games
        .where((g) => g.isCompleted && g.winner == PlayerSide.sideA)
        .length;
    final gamesWonB = state.games
        .where((g) => g.isCompleted && g.winner == PlayerSide.sideB)
        .length;

    final gameScore = state.matchWinner == PlayerSide.sideA
        ? '$gamesWonA-$gamesWonB'
        : '$gamesWonB-$gamesWonA';

    return '$winnerLabel won $gameScore';
  }

  Future<void> _syncToDatabaseAsync(String? pointType, PlayerSide? winningSide) async {
    if (currentMatchId.isEmpty) return;
    final matchId = currentMatchId.value;

    try {
      final updatedEngineState = engine.state.toJson();
      final now = DateTime.now();
      final resultString = engine.state.status == MatchStatus.completed
          ? _buildMatchResult(engine.state)
          : (currentMatch.value?.matchResult ?? '');

      bool isNewlyCompleted = engine.state.status == MatchStatus.completed &&
          currentMatch.value?.status != 'Completed';

      // Update local SQLite
      final matchModel = currentMatch.value;
      if (matchModel != null) {
        final updatedMatch = BadmintonMatchModel(
          matchId: matchModel.matchId,
          createdBy: matchModel.createdBy,
          sport: matchModel.sport,
          allPlayers: matchModel.allPlayers,
          teamAPlayers: matchModel.teamAPlayers,
          teamBPlayers: matchModel.teamBPlayers,
          maxAllowedPlayers: matchModel.maxAllowedPlayers,
          isFriendlyRules: matchModel.isFriendlyRules,
          tournamentId: matchModel.tournamentId,
          bracketMatchId: matchModel.bracketMatchId,
          pointsToWin: matchModel.pointsToWin,
          maxPointCap: matchModel.maxPointCap,
          winByTwo: matchModel.winByTwo,
          gamesToWin: matchModel.gamesToWin,
          intervalsEnabled: matchModel.intervalsEnabled,
          endsChangeEnabled: matchModel.endsChangeEnabled,
          status: engine.state.status == MatchStatus.completed ? 'Completed' : 'In Progress',
          createdAt: matchModel.createdAt,
          engineState: updatedEngineState,
          lastUpdatedAt: now,
          matchResult: resultString,
          pointLog: matchModel.pointLog,
        );
        currentMatch.value = updatedMatch;
        await BadmintonSqflite.instance.updateMatch(updatedMatch);
      }

      final docRef = FirebaseFirestore.instance.collection('matches').doc(matchId);

      // Update Match Doc
      await docRef.update({
        'engineState': updatedEngineState,
        'status': engine.state.status == MatchStatus.completed ? 'Completed' : 'In Progress',
        'matchResult': resultString,
        'lastUpdatedAt': now.toIso8601String(),
      });

      // Event Source Point Log
      if (winningSide != null) {
        final pointId = const Uuid().v4();
        await docRef.collection('pointLog').doc(pointId).set({
          'timestamp': now.toIso8601String(),
          'winningSide': winningSide.index,
          'pointType': pointType,
          'scoreA': engine.state.currentScoreA,
          'scoreB': engine.state.currentScoreB,
        });
      }

      // ON MATCH COMPLETION: Update cumulative lifetime stats of all players in User collection
      if (isNewlyCompleted) {
        await _updateAllPlayersBadmintonStats(engine.state);
      }

    } catch (e) {
      debugPrint("Sync Error: $e");
    }
  }

  Future<void> _updateAllPlayersBadmintonStats(BadmintonMatchState state) async {
    if (state.status != MatchStatus.completed) return;

    final allEmails = [...teamAPlayers, ...teamBPlayers];

    for (final email in allEmails) {
      try {
        final query = await FirebaseFirestore.instance
            .collection('User')
            .where('email', isEqualTo: email)
            .limit(1)
            .get();

        if (query.docs.isEmpty) continue;
        final userDocId = query.docs.first.id;

        final isTeamA = teamAPlayers.contains(email);
        final isWinner = (isTeamA && state.matchWinner == PlayerSide.sideA) ||
            (!isTeamA && state.matchWinner == PlayerSide.sideB);

        int pointsWon = 0;
        for (final game in state.games.where((g) => g.isCompleted)) {
          pointsWon += isTeamA ? game.scoreA : game.scoreB;
        }

        int gamesWon = state.games
            .where((g) => g.isCompleted &&
                g.winner == (isTeamA ? PlayerSide.sideA : PlayerSide.sideB))
            .length;

        final updates = {
          'badmintonStats.totalMatches': FieldValue.increment(1),
          'badmintonStats.totalWins': FieldValue.increment(isWinner ? 1 : 0),
          'badmintonStats.totalLosses': FieldValue.increment(isWinner ? 0 : 1),
          'badmintonStats.totalPointsWon': FieldValue.increment(pointsWon),
          'badmintonStats.totalGamesWon': FieldValue.increment(gamesWon),
          'badmintonStats.lastMatchDate': FieldValue.serverTimestamp(),
        };

        await FirebaseFirestore.instance
            .collection('User')
            .doc(userDocId)
            .set(updates, SetOptions(merge: true));

      } catch (e) {
        debugPrint("Error updating badminton stats for $email: $e");
      }
    }
  }

  // ════════════════════ SCORING ACTIONS ════════════════════

  void addPoint(PlayerSide side) {
    if (!isEngineReady.value) return;

    engine.dispatch(PointEvent(side: side));
    liveState.value = engine.state;
    _syncToDatabaseAsync(null, side);
  }

  void addPointWithType(PlayerSide side, String pointType) {
    if (!isEngineReady.value) return;

    engine.dispatch(PointEvent(side: side, pointType: pointType));
    liveState.value = engine.state;
    _syncToDatabaseAsync(pointType, pointType == 'let' ? null : side);
  }

  void tagLastPoint(String pointType) {
    if (currentMatchId.isEmpty) return;

    _syncToDatabaseAsync(pointType, null);
  }

  // A11 Fix: Medical timeout functionality (preserves undo history)
  var medicalTimeoutSeconds = 180.obs;
  Timer? _timeoutTimer;

  void startMedicalTimeout() {
    if (!isEngineReady.value) return;
    if (liveState.value?.status == MatchStatus.completed) return;

    engine.startMedicalTimeout();
    liveState.value = engine.state;
    _syncToDatabaseAsync('timeout_start', null);

    medicalTimeoutSeconds.value = 180;
    _timeoutTimer?.cancel();
    _timeoutTimer = Timer.periodic(Duration(seconds: 1), (timer) {
      if (medicalTimeoutSeconds.value > 0) {
        medicalTimeoutSeconds.value--;
      } else {
        resumeMedicalTimeout();
      }
    });
  }

  void resumeMedicalTimeout() {
    _timeoutTimer?.cancel();
    if (!isEngineReady.value) return;
    if (liveState.value?.status == MatchStatus.timeout) {
      engine.resumeFromTimeout();
      liveState.value = engine.state;
      _syncToDatabaseAsync('timeout_end', null);
    }
  }

  void retireMatch(PlayerSide retiringSide) {
    if (!isEngineReady.value) return;
    if (liveState.value?.status == MatchStatus.completed) return;

    engine.retireMatch(retiringSide);
    liveState.value = engine.state;
    _syncToDatabaseAsync('retire', retiringSide == PlayerSide.sideA ? PlayerSide.sideB : PlayerSide.sideA);
  }

  @override
  void onClose() {
    _timeoutTimer?.cancel();
    super.onClose();
  }

  void addConduct(PlayerSide side, String conductType) {
    if (!isEngineReady.value) return;

    engine.dispatch(ConductEvent(side: side, conductType: conductType));
    liveState.value = engine.state;

    if (conductType == 'fault') {
      _syncToDatabaseAsync('conduct_fault', side == PlayerSide.sideA ? PlayerSide.sideB : PlayerSide.sideA);
    } else if (conductType == 'disqualify') {
      _syncToDatabaseAsync('disqualify', side == PlayerSide.sideA ? PlayerSide.sideB : PlayerSide.sideA);
      // A1 Fix: Disqualification must update bracket + leaderboard
      if (tournamentId.isNotEmpty && bracketMatchId.isNotEmpty && engine.state.status == MatchStatus.completed) {
        endTournamentMatch();
      }
    } else {
      // warning only logs
      _syncToDatabaseAsync('warning', null);
    }
  }

  void undoLastEvent() {
    if (!isEngineReady.value || !engine.canUndo) return;

    engine.undo();
    liveState.value = engine.state;
    // We pass null for side/type so it just syncs the reverted engineState.
    // In a full implementation, we'd delete the last pointLog document as well.
    _syncToDatabaseAsync(null, null);
  }

  Future<void> endTournamentMatch([BuildContext? context]) async {
    if (tournamentId.isEmpty || bracketMatchId.isEmpty || !isEngineReady.value) return;

    final state = engine.state;
    if (state.status != MatchStatus.completed) return;

    isLoading.value = true;
    try {
      final batch = FirebaseFirestore.instance.batch();

      // Get bracket doc to find next match
      final bracketRef = FirebaseFirestore.instance
          .collection('tournaments')
          .doc(tournamentId.value)
          .collection('bracket')
          .doc(bracketMatchId.value);

      final bracketDoc = await bracketRef.get();
      if (!bracketDoc.exists) return;

      final bracketData = bracketDoc.data()!;
      final teamAId = bracketData['teamAId'];
      final teamBId = bracketData['teamBId'];

      final winningTeamId = state.matchWinner == PlayerSide.sideA ? teamAId : teamBId;
      final nextMatchId = bracketData['nextMatchId'];
      final nextMatchSlot = bracketData['nextMatchSlot'];

      // 1. Update Current Bracket Match
      batch.update(bracketRef, {
        'status': 'completed',
        'winnerId': winningTeamId,
      });

      // 2. Propagate winner to next match if applicable
      if (nextMatchId != null && nextMatchSlot != null) {
        if (nextMatchSlot != 'A' && nextMatchSlot != 'B') {
          // A2 Fix: nextMatchSlot validation
          debugPrint("ERROR: nextMatchSlot is invalid: $nextMatchSlot. Expected 'A' or 'B'.");
          Get.snackbar("Error", "Invalid next match slot configuration: $nextMatchSlot");
        } else {
          final nextMatchRef = FirebaseFirestore.instance
              .collection('tournaments')
              .doc(tournamentId.value)
              .collection('bracket')
              .doc(nextMatchId);

          if (nextMatchSlot == 'A') {
            batch.update(nextMatchRef, {'teamAId': winningTeamId});
          } else if (nextMatchSlot == 'B') {
            batch.update(nextMatchRef, {'teamBId': winningTeamId});
          }
        }
      }

      // 3. Update Leaderboard (Points, W/L, Games)
      // Leaderboard is at tournaments/{tournamentId}/leaderboard/{teamId}

      // Calculate games won/lost for tiebreakers
      int gamesWonA = state.games.where((g) => g.isCompleted && g.winner == PlayerSide.sideA).length;
      int gamesWonB = state.games.where((g) => g.isCompleted && g.winner == PlayerSide.sideB).length;

      final leaderboardRefA = FirebaseFirestore.instance
          .collection('tournaments')
          .doc(tournamentId.value)
          .collection('leaderboard')
          .doc(teamAId);

      final leaderboardRefB = FirebaseFirestore.instance
          .collection('tournaments')
          .doc(tournamentId.value)
          .collection('leaderboard')
          .doc(teamBId);

      // Points Logic (assuming 2 for win, 0 for loss)
      // Note: We use set with merge:true in case they don't exist yet
      batch.set(leaderboardRefA, {
        'matchesPlayed': FieldValue.increment(1),
        'wins': FieldValue.increment(state.matchWinner == PlayerSide.sideA ? 1 : 0),
        'losses': FieldValue.increment(state.matchWinner == PlayerSide.sideA ? 0 : 1),
        'points': FieldValue.increment(state.matchWinner == PlayerSide.sideA ? 2 : 0),
        'gamesWon': FieldValue.increment(gamesWonA),
        'gamesLost': FieldValue.increment(gamesWonB),
      }, SetOptions(merge: true));

      batch.set(leaderboardRefB, {
        'matchesPlayed': FieldValue.increment(1),
        'wins': FieldValue.increment(state.matchWinner == PlayerSide.sideB ? 1 : 0),
        'losses': FieldValue.increment(state.matchWinner == PlayerSide.sideB ? 0 : 1),
        'points': FieldValue.increment(state.matchWinner == PlayerSide.sideB ? 2 : 0),
        'gamesWon': FieldValue.increment(gamesWonB),
        'gamesLost': FieldValue.increment(gamesWonA),
      }, SetOptions(merge: true));

      // 4. Check if tournament is complete
      // Check if any other bracket matches are still incomplete/in progress
      final allBracketDocs = await FirebaseFirestore.instance
          .collection('tournaments')
          .doc(tournamentId.value)
          .collection('bracket')
          .get();

      bool allCompleted = true;
      for (var doc in allBracketDocs.docs) {
        if (doc.id == bracketMatchId.value) continue; // skip the one we just completed
        final status = doc.data()['status'];
        if (status != 'completed' && doc.data()['teamAId'] != null && doc.data()['teamBId'] != null) {
          allCompleted = false;
          break;
        }
      }

      if (allCompleted) {
        final tRef = FirebaseFirestore.instance.collection('tournaments').doc(tournamentId.value);
        batch.update(tRef, {'status': 'completed'});
        await batch.commit();

        final runnerUpTeamId = winningTeamId == teamAId ? teamBId : teamAId;
        final tDoc = await tRef.get();
        final sportStr = (tDoc.data()?['sport'] ?? 'Badminton').toString();

        await XpRewardService.awardTournamentRankingsXp(
          tournamentId: tournamentId.value,
          winnerTeamId: winningTeamId,
          runnerUpTeamId: runnerUpTeamId,
          sport: sportStr,
        );
      } else {
        await batch.commit();
      }

      // Navigate back to Bracket & Matchmaking screen
      final navContext = context ?? Get.context;
      if (navContext != null && navContext.mounted) {
        Navigator.popUntil(navContext, (route) {
          final routeName = route.settings.name ?? '';
          return routeName.contains('BracketMatchmaking') ||
                 routeName.contains('TournamentDetail') ||
                 route.isFirst;
        });
      }

    } catch (e) {
      Get.snackbar('Error', 'Failed to save tournament result: $e');
    } finally {
      isLoading.value = false;
    }
  }
}
