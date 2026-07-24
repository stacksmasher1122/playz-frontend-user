import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:uuid/uuid.dart';
import '../../../../../score_engine/footballMatchEngine/football_match_engine.dart';
import '../../../../../sqflite/User_SQF/Home_SQF/Scoreboard_SQF/footballSqflite.dart';
import 'dart:async';

class FootballController extends GetxController {
  final MatchEngine engine = MatchEngine();
  final RxString currentMatchId = ''.obs;

  @override
  void onInit() {
    super.onInit();
  }

  @override
  void onClose() {
    engine.dispose();
    super.onClose();
  }

  Future<void> _syncToDatabaseAsync() async {
    if (currentMatchId.value.isEmpty) return;

    try {
      final now = DateTime.now();
      final updatedEngineState = engine.state.toJson();

      // Update SQLite locally first
      final sqfliteMatch = await FootballSqflite.instance.getMatch(currentMatchId.value);
      if (sqfliteMatch != null) {
        sqfliteMatch.engineState = engine.state;
        sqfliteMatch.lastUpdatedAt = now;
        sqfliteMatch.status = engine.state.phase == MatchPhase.fullTime ? 'Completed' : 'In Progress';
        await FootballSqflite.instance.updateMatch(sqfliteMatch);
      }

      // Update Firestore
      final docRef = FirebaseFirestore.instance.collection('matches').doc(currentMatchId.value);

      await docRef.update({
        'engineState': updatedEngineState,
        'status': engine.state.phase == MatchPhase.fullTime ? 'completed' : 'live',
        'lastUpdatedAt': now.toIso8601String(),
      });
    } catch (e) {
      debugPrint("Sync Error: \$e");
    }
  }

  // Wrappers to call Engine and ensure sync occurs for specific events
  void processGoal(TeamSide side, MatchPlayer? scorer, MatchPlayer? assist) {
    engine.processGoal(side, scorer, assist);
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

  void undo() {
    if (engine.canUndo) {
        engine.undo();
        _syncToDatabaseAsync();
    }
  }

  // Timer control
  void toggleTimer() {
    engine.toggleTimer();
    _syncToDatabaseAsync(); // Sync once when clock changes state
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
    } catch(e) {
        debugPrint("Event Sync Error: \$e");
    }
  }
}
