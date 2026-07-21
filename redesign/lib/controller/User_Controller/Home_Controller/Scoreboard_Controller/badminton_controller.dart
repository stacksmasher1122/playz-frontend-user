import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:uuid/uuid.dart';

import 'package:redesign/model/User_Models/Home_Models/Friends_Model/friends_model.dart';
import 'package:redesign/model/User_Models/Home_Models/Scoreboard_Model/badminton_model.dart';
import 'package:redesign/model/User_Models/Home_Models/Scoreboard_Model/badminton_state_models.dart';
import 'package:redesign/sqflite/User_SQF/Home_SQF/Scoreboard_SQF/badmintonSqflite.dart';
import 'package:redesign/score_engine/badmintonMatchEngine/badminton_match_engine.dart';
import 'package:redesign/shared_preferences/userPreferences.dart';
import 'package:redesign/view/USER/Home/Scoreboard/Badminton/live_match/badminton_scoreboard_screen.dart';

class BadmintonController extends GetxController {
  // Setup Parameters
  var isFriendlyRules = false.obs;
  var pointsToWin = 21.obs;
  var gamesToWin = 2.obs;
  var winByTwo = true.obs;
  var maxPointCap = 30.obs;
  var intervalsEnabled = true.obs;
  var endsChangeEnabled = true.obs;
  var format = 'Singles'.obs;

  var maxAllowedPlayers = 1.obs; // 1 for singles, 2 for doubles

  var teamAPlayers = <String>[].obs;
  var teamBPlayers = <String>[].obs;

  var teamARoster = <FriendModel>[].obs;
  var teamBRoster = <FriendModel>[].obs;

  var isLoading = false.obs;

  var currentUserFriendModel = Rxn<FriendModel>();

  // ════════════════════ LIVE MATCH STATE ════════════════════
  var currentMatchId = ''.obs;
  var currentMatch = Rxn<BadmintonMatchModel>();

  // Real-time engine
  late BadmintonMatchEngine engine;
  var isEngineReady = false.obs;
  var liveState = Rxn<BadmintonMatchState>();

  @override
  void onInit() {
    super.onInit();
    _loadCurrentUserProfile();
  }

  Future<void> _loadCurrentUserProfile() async {
    try {
      final user = FirebaseAuth.instance.currentUser;
      if (user != null) {
        final profile = await UserPreferences.getUserProfile();
        if (profile != null) {
          currentUserFriendModel.value = FriendModel(
            email: user.email ?? profile['email'] ?? '',
            fullName: profile['fullName'] ?? '',
            username: profile['username'] ?? '',
            profileImageUrl: profile['profileImageUrl'] ?? '',
          );
        }
      }
    } catch (e) {
      debugPrint("Error loading profile: $e");
    }
  }

  // ════════════════════ SETUP METHODS ════════════════════

  void toggleFriendlyRules(bool val) {
    isFriendlyRules.value = val;
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

    if (roster.length >= maxAllowedPlayers.value) {
      Get.snackbar('Limit Reached', 'Cannot add more players to this side.');
      return;
    }

    // Prevent adding to both sides
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

  Future<void> createAndStartMatch() async {
    if (teamARoster.isEmpty || teamBRoster.isEmpty) {
      Get.snackbar('Error', 'Both sides need at least 1 player');
      return;
    }

    try {
      isLoading.value = true;
      final user = FirebaseAuth.instance.currentUser;
      final matchId = const Uuid().v4();

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
      );

      final newMatch = BadmintonMatchModel(
        matchId: matchId,
        createdBy: user?.uid ?? 'unknown',
        sport: 'badminton',
        allPlayers: [...teamAPlayers, ...teamBPlayers],
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

      Get.to(() => BadmintonScoreboardScreen());

    } catch (e) {
      Get.snackbar('Error', 'Failed to start match: $e');
    } finally {
      isLoading.value = false;
    }
  }

  // ════════════════════ ENGINE SYNC ════════════════════

  void _initEngineFromState(BadmintonMatchState state) {
    engine = BadmintonMatchEngine(state);
    liveState.value = engine.state;
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
        if (data['engineState'] != null) {
          final incomingState = BadmintonMatchState.fromJson(data['engineState']);
          // Only update UI if this is a remote update, not our own local sync loop mirroring back
          // Simplistic check: just replace engine state. In a real app we'd check timestamps/author
           engine = BadmintonMatchEngine(incomingState);
           liveState.value = engine.state;
        }
      }
    });
  }

  Future<void> _syncToDatabaseAsync(String? pointType, PlayerSide? winningSide) async {
    if (currentMatchId.isEmpty) return;
    final matchId = currentMatchId.value;

    try {
      final updatedEngineState = engine.state.toJson();
      final now = DateTime.now();

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
          matchResult: matchModel.matchResult,
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

    } catch (e) {
      debugPrint("Sync Error: $e");
    }
  }

  // ════════════════════ SCORING ACTIONS ════════════════════

  void addPoint(PlayerSide side) {
    if (!isEngineReady.value) return;

    engine.dispatch(PointEvent(side: side));
    liveState.value = engine.state;
    _syncToDatabaseAsync(null, side);
  }

  void undoLastEvent() {
    if (!isEngineReady.value || !engine.canUndo) return;

    engine.undo();
    liveState.value = engine.state;
    // We pass null for side/type so it just syncs the reverted engineState.
    // In a full implementation, we'd delete the last pointLog document as well.
    _syncToDatabaseAsync(null, null);
  }
}
