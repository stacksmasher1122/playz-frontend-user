import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:uuid/uuid.dart';
import '../../../../../score_engine/footballMatchEngine/football_match_engine.dart';
import '../../../../../sqflite/User_SQF/Home_SQF/Scoreboard_SQF/footballSqflite.dart';
import '../../../../../model/football/football_model.dart';
import 'dart:async';

import 'package:redesign/view/USER/Home/Scoreboard/Football/football_scoreboard/football_scoreboard_screen.dart';
import 'package:redesign/model/User_Models/Home_Models/Friends_Model/friends_model.dart';
import 'package:redesign/services/xp_reward_service.dart';

class FootballController extends GetxController {
  late MatchEngine engine;
  final RxString currentMatchId = ''.obs;
  final Rxn<FootballMatchModel> currentMatch = Rxn<FootballMatchModel>();
  final RxBool isEngineReady = false.obs;
  final RxBool isReadOnly = false.obs;
  final RxString tournamentId = ''.obs;
  final RxString bracketMatchId = ''.obs;
  final RxBool isLoading = false.obs;

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

  // ════════════════════ TOURNAMENT MATCH LIFECYCLE ════════════════════

  Future<void> createAndStartTournamentMatch({
    required String tId,
    required String bMatchId,
    required List<FriendModel> teamA,
    required List<FriendModel> teamB,
    required Map<String, dynamic> sportRules,
    String? teamAName,
    String? teamBName,
    String? teamALogo,
    String? teamBLogo,
    String? tossWinner,
    String? tossDecision,
    BuildContext? context,
  }) async {
    try {
      isLoading.value = true;
      isReadOnly.value = false;
      final user = FirebaseAuth.instance.currentUser;
      final matchId = const Uuid().v4();

      tournamentId.value = tId;
      bracketMatchId.value = bMatchId;
      currentMatchId.value = matchId;

      final nameA = (teamAName != null && teamAName.trim().isNotEmpty)
          ? teamAName.trim()
          : (teamA.isNotEmpty ? 'Team A' : 'Side A');
      final nameB = (teamBName != null && teamBName.trim().isNotEmpty)
          ? teamBName.trim()
          : (teamB.isNotEmpty ? 'Team B' : 'Side B');

      final int halfDurationMins = (sportRules['halfDuration'] as num?)?.toInt() ??
          (sportRules['matchDuration'] as num?)?.toInt() ?? 45;
      final bool allowExtraTime = sportRules['extraTime'] == true;
      final bool allowPenalties = sportRules['penaltyShootout'] == true;
      final int maxSubsAllowed = (sportRules['maxSubs'] as num?)?.toInt() ?? 5;

      final homeSquad = teamA.map((p) => MatchPlayer(
        id: p.email,
        name: p.fullName.isNotEmpty ? p.fullName : p.email,
        number: 0,
        isStarter: true,
        isOnPitch: true,
      )).toList();

      final awaySquad = teamB.map((p) => MatchPlayer(
        id: p.email,
        name: p.fullName.isNotEmpty ? p.fullName : p.email,
        number: 0,
        isStarter: true,
        isOnPitch: true,
      )).toList();

      final engineState = FootballMatchState();
      engineState.homeTeam = MatchTeam(id: 'home', name: nameA, color: '0xFF1DB954', squad: homeSquad, logo: teamALogo ?? '');
      engineState.awayTeam = MatchTeam(id: 'away', name: nameB, color: '0xFFE53935', squad: awaySquad, logo: teamBLogo ?? '');

      final List<String> teamAPlayers = teamA.map((p) => p.email).toList();
      final List<String> teamBPlayers = teamB.map((p) => p.email).toList();

      final config = {
        'halfDurationMinutes': halfDurationMins,
        'extraTimeEnabled': allowExtraTime,
        'penaltiesEnabled': allowPenalties,
        'maxSubs': maxSubsAllowed,
        'tossWinner': tossWinner ?? nameA,
        'tossDecision': tossDecision ?? 'kickoff',
      };

      final newMatch = FootballMatchModel(
        id: matchId,
        createdBy: user?.uid ?? 'unknown',
        sport: 'football',
        allPlayers: [...teamAPlayers, ...teamBPlayers],
        homeTeamPlayers: teamAPlayers,
        awayTeamPlayers: teamBPlayers,
        config: config,
        status: 'In Progress',
        engineState: engineState,
        lastUpdatedAt: DateTime.now(),
        createdAt: DateTime.now(),
        tournamentId: tId,
        bracketMatchId: bMatchId,
      );

      restoreFootballMatchFromSqflite(newMatch);

      // Save to SQLite
      await FootballSqflite.instance.createMatch(newMatch);

      // Save to Remote (atomic WriteBatch)
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
      _listenToMatchUpdates();

      final navContext = context ?? Get.context;
      if (navContext != null && navContext.mounted) {
        Navigator.push(
          navContext,
          MaterialPageRoute(builder: (_) => const FootballScoreboardScreen()),
        );
      }
    } catch (e) {
      Get.snackbar('Error', 'Failed to start tournament football match: $e');
    } finally {
      isLoading.value = false;
    }
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
      final matchModel = FootballMatchModel.fromJson(matchData);

      tournamentId.value = tId;
      bracketMatchId.value = bMatchId;
      currentMatchId.value = matchId;
      currentMatch.value = matchModel;

      restoreFootballMatchFromSqflite(matchModel);

      final navContext = context ?? Get.context;
      if (navContext != null && navContext.mounted) {
        Navigator.push(
          navContext,
          MaterialPageRoute(builder: (_) => const FootballScoreboardScreen()),
        );
      }
    } catch (e) {
      Get.snackbar("Error", "Failed to resume football match: $e");
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

  Future<void> endTournamentMatch([BuildContext? context]) async {
    if (tournamentId.isEmpty || bracketMatchId.isEmpty || !isEngineReady.value) return;

    isLoading.value = true;
    try {
      final batch = FirebaseFirestore.instance.batch();

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

      final homeScore = engine.state.homeScore;
      final awayScore = engine.state.awayScore;
      final bool isDraw = homeScore == awayScore;
      final bool isHomeWinner = homeScore > awayScore;

      String winningTeamId = isHomeWinner ? teamAId : (isDraw ? teamAId : teamBId);
      if (isDraw) {
        if (engine.state.homeTeam.penaltiesScored > engine.state.awayTeam.penaltiesScored) {
          winningTeamId = teamAId;
        } else if (engine.state.awayTeam.penaltiesScored > engine.state.homeTeam.penaltiesScored) {
          winningTeamId = teamBId;
        }
      }

      final nextMatchId = bracketData['nextMatchId'];
      final nextMatchSlot = bracketData['nextMatchSlot'];

      // 1. Update Current Bracket Match
      batch.update(bracketRef, {
        'status': 'completed',
        'winnerId': winningTeamId,
      });

      // 2. Propagate winner to next match if applicable
      if (nextMatchId != null && nextMatchSlot != null) {
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

      // 3. Update Leaderboard (Points, W/D/L, Goals, GD)
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

      final bool isTeamAWinner = winningTeamId == teamAId;

      batch.set(leaderboardRefA, {
        'matchesPlayed': FieldValue.increment(1),
        'wins': FieldValue.increment(isDraw ? 0 : (isTeamAWinner ? 1 : 0)),
        'draws': FieldValue.increment(isDraw ? 1 : 0),
        'losses': FieldValue.increment(isDraw ? 0 : (isTeamAWinner ? 0 : 1)),
        'points': FieldValue.increment(isDraw ? 1 : (isTeamAWinner ? 3 : 0)),
        'goalsScored': FieldValue.increment(homeScore),
        'goalsConceded': FieldValue.increment(awayScore),
        'goalDifference': FieldValue.increment(homeScore - awayScore),
      }, SetOptions(merge: true));

      batch.set(leaderboardRefB, {
        'matchesPlayed': FieldValue.increment(1),
        'wins': FieldValue.increment(isDraw ? 0 : (!isTeamAWinner ? 1 : 0)),
        'draws': FieldValue.increment(isDraw ? 1 : 0),
        'losses': FieldValue.increment(isDraw ? 0 : (!isTeamAWinner ? 0 : 1)),
        'points': FieldValue.increment(isDraw ? 1 : (!isTeamAWinner ? 3 : 0)),
        'goalsScored': FieldValue.increment(awayScore),
        'goalsConceded': FieldValue.increment(homeScore),
        'goalDifference': FieldValue.increment(awayScore - homeScore),
      }, SetOptions(merge: true));

      // 4. Check if entire bracket is completed
      final allBracketDocs = await FirebaseFirestore.instance
          .collection('tournaments')
          .doc(tournamentId.value)
          .collection('bracket')
          .get();

      bool allCompleted = true;
      for (var doc in allBracketDocs.docs) {
        if (doc.id == bracketMatchId.value) continue;
        final s = doc.data()['status'];
        if (s != 'completed' && doc.data()['teamAId'] != null && doc.data()['teamBId'] != null) {
          allCompleted = false;
          break;
        }
      }

      if (allCompleted) {
        final tRef = FirebaseFirestore.instance.collection('tournaments').doc(tournamentId.value);
        batch.update(tRef, {'status': 'completed'});
        await batch.commit();

        final runnerUpTeamId = isTeamAWinner ? teamBId : teamAId;
        await XpRewardService.awardTournamentRankingsXp(
          tournamentId: tournamentId.value,
          winnerTeamId: winningTeamId,
          runnerUpTeamId: runnerUpTeamId,
          sport: 'Football',
        );
      } else {
        await batch.commit();
      }

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
      Get.snackbar('Error', 'Failed to save football tournament result: $e');
    } finally {
      isLoading.value = false;
    }
  }
}
