import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:uuid/uuid.dart';
import '../../../../../score_engine/footballMatchEngine/football_match_engine.dart';
import '../../../../../sqflite/User_SQF/Home_SQF/Scoreboard_SQF/footballSqflite.dart';
import '../../../../../model/football/football_model.dart';
import 'dart:async';

class FootballController extends GetxController {
  late MatchEngine engine;
  final RxString currentMatchId = ''.obs;
  final Rxn<FootballMatchModel> currentMatch = Rxn<FootballMatchModel>();
  final RxBool isEngineReady = false.obs;
  final RxBool isReadOnly = false.obs;

  StreamSubscription? _firestoreSubscription;

  @override
  void onInit() {
    super.onInit();
    engine = MatchEngine();
  }

  @override
  void onClose() {
    _firestoreSubscription?.cancel();
    engine.dispose();
    super.onClose();
  }

  void restoreFootballMatchFromSqflite(FootballMatchModel model) {
    currentMatchId.value = model.id;
    currentMatch.value = model;

    final int halfDuration = (model.config['halfDurationMinutes'] as num?)?.toInt() ?? 45;
    final bool extraTimeEnabled = model.config['extraTimeEnabled'] ?? false;
    final bool penaltiesEnabled = model.config['penaltiesEnabled'] ?? false;
    final int maxSubs = (model.config['maxSubs'] as num?)?.toInt() ?? 5;
    final bool allowProRules = model.config['allowProRules'] ?? false;

    engine = MatchEngine(
      halfDuration: halfDuration,
      extraTimeEnabled: extraTimeEnabled,
      penaltiesEnabled: penaltiesEnabled,
      maxSubs: maxSubs,
      allowProRules: allowProRules,
    );

    engine.loadState(model.engineState);
    engine.allowProRules = allowProRules;

    // Always pause game timer when resuming from a recovered/incomplete match
    if (engine.state.phase != MatchPhase.preMatch && engine.state.phase != MatchPhase.fullTime) {
      engine.state.isRunning = false;
    }

    isEngineReady.value = true;

    _listenToMatchUpdates();
  }

  void _listenToMatchUpdates() {
    if (currentMatchId.value.isEmpty) return;

    _firestoreSubscription?.cancel();
    _firestoreSubscription = FirebaseFirestore.instance
        .collection('matches')
        .doc(currentMatchId.value)
        .snapshots()
        .listen((snapshot) {
      if (!snapshot.exists || snapshot.data() == null) return;
      final data = snapshot.data()!;

      // Self-write guard: ignore remote writes if this device is the match creator
      final currentUid = FirebaseAuth.instance.currentUser?.uid;
      final creatorUid = data['createdBy']?.toString();
      if (currentUid != null && creatorUid != null && currentUid == creatorUid && !isReadOnly.value) {
        return;
      }

      if (data['engineState'] != null) {
        final remoteState = FootballMatchState.fromJson(Map<String, dynamic>.from(data['engineState']));
        engine.loadState(remoteState);
      }
    });
  }

  Future<void> _syncToDatabaseAsync() async {
    if (currentMatchId.value.isEmpty) return;

    try {
      final now = DateTime.now();
      final updatedEngineState = engine.state.toJson();
      final bool isCompleted = engine.state.phase == MatchPhase.fullTime;

      // Update SQLite locally first
      final sqfliteMatch = await FootballSqflite.instance.getMatch(currentMatchId.value);
      if (sqfliteMatch != null) {
        sqfliteMatch.engineState = engine.state;
        sqfliteMatch.lastUpdatedAt = now;
        sqfliteMatch.status = isCompleted ? 'Completed' : 'In Progress';
        sqfliteMatch.matchResult = engine.state.matchResult;
        await FootballSqflite.instance.updateMatch(sqfliteMatch);
      }

      // Update Firestore
      final docRef = FirebaseFirestore.instance.collection('matches').doc(currentMatchId.value);

      await docRef.update({
        'engineState': updatedEngineState,
        'status': isCompleted ? 'completed' : 'live',
        'matchResult': engine.state.matchResult,
        'lastUpdatedAt': now.toIso8601String(),
      });

      if (isCompleted) {
        await _updateAllPlayersFootballStats(engine.state);
      }
    } catch (e) {
      debugPrint("Sync Error: $e");
    }
  }

  Future<void> _updateAllPlayersFootballStats(FootballMatchState state) async {
    try {
      final bool isHomeWinner = state.homeScore > state.awayScore;
      final bool isDraw = state.homeScore == state.awayScore;

      // Update squad players
      for (final p in [...state.homeTeam.squad, ...state.awayTeam.squad]) {
        if (p.id.isEmpty) continue;
        final bool isHome = state.homeTeam.squad.any((hp) => hp.id == p.id);
        final bool isWinner = isDraw ? false : (isHome ? isHomeWinner : !isHomeWinner);

        final updates = {
          'footballStats.totalMatches': FieldValue.increment(1),
          'footballStats.goals': FieldValue.increment(p.goals),
          'footballStats.assists': FieldValue.increment(p.assists),
          'footballStats.yellowCards': FieldValue.increment(p.yellowCards),
          'footballStats.redCards': FieldValue.increment(p.redCards),
          'footballStats.wins': FieldValue.increment(isWinner ? 1 : 0),
          'footballStats.draws': FieldValue.increment(isDraw ? 1 : 0),
          'footballStats.losses': FieldValue.increment((!isWinner && !isDraw) ? 1 : 0),
          'footballStats.lastMatchDate': FieldValue.serverTimestamp(),
        };

        await FirebaseFirestore.instance
            .collection('User')
            .doc(p.id)
            .set(updates, SetOptions(merge: true));
      }
    } catch (e) {
      debugPrint("Error updating football stats: $e");
    }
  }

  // Wrappers to call Engine and ensure sync occurs for specific events
  void processGoal(TeamSide side, MatchPlayer? scorer, MatchPlayer? assist) {
    engine.processGoal(side, scorer, assist);
    _syncToDatabaseAsync();
    _writeLastEventToFirestore();
  }

  void processOwnGoal(TeamSide teamWhoConceded, MatchPlayer ownGoalScorer) {
    engine.processOwnGoal(teamWhoConceded, ownGoalScorer);
    _syncToDatabaseAsync();
    _writeLastEventToFirestore();
  }

  void processCard(TeamSide side, MatchPlayer player, EventType type, String reason) {
    engine.processCard(side, player, type, reason);
    _syncToDatabaseAsync();
    _writeLastEventToFirestore();
  }

  void processSubstitution(TeamSide side, MatchPlayer subOut, MatchPlayer subIn) {
    engine.processSubstitution(side, subOut, subIn);
    _syncToDatabaseAsync();
    _writeLastEventToFirestore();
  }

  void processOffside(TeamSide side, MatchPlayer? player) {
    engine.processOffside(side, player);
    _syncToDatabaseAsync();
    _writeLastEventToFirestore();
  }

  void processFreeKick(TeamSide side, MatchPlayer? player) {
    engine.processFreeKick(side, player);
    _syncToDatabaseAsync();
    _writeLastEventToFirestore();
  }

  void processPenalty(TeamSide side, MatchPlayer? taker, bool scored) {
    engine.processPenalty(side, taker, scored);
    _syncToDatabaseAsync();
    _writeLastEventToFirestore();
  }

  void endPhase() {
    engine.endPhase();
    _syncToDatabaseAsync();
    _writeLastEventToFirestore();
  }

  void endMatch() {
    engine.endMatch();
    _syncToDatabaseAsync();
    _writeLastEventToFirestore();
  }

  void undo() {
    if (engine.canUndo) {
      engine.undo();
      _syncToDatabaseAsync();
    }
  }

  void toggleTimer() {
    engine.toggleTimer();
    _syncToDatabaseAsync();
  }

  Future<void> _writeLastEventToFirestore() async {
    if (currentMatchId.value.isEmpty || engine.state.events.isEmpty) return;

    try {
      final lastEvent = engine.state.events.first;
      final eventId = const Uuid().v4();
      final docRef = FirebaseFirestore.instance.collection('matches').doc(currentMatchId.value);

      await docRef.collection('events').doc(eventId).set({
        ...lastEvent.toJson(),
        'timestamp': DateTime.now().toIso8601String(),
      });
    } catch (e) {
      debugPrint("Event Sync Error: $e");
    }
  }
}
