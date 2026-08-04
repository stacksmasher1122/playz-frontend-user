import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:uuid/uuid.dart';
import '../../../../../model/User_Models/Home_Models/Scoreboard_Model/Table_Tennis/table_tennis_model.dart';
import '../../../../../model/User_Models/Home_Models/Scoreboard_Model/Table_Tennis/table_tennis_state_models.dart';
import '../../../../../model/User_Models/Home_Models/Friends_Model/friends_model.dart';
import '../../../../../sqflite/User_SQF/Home_SQF/Scoreboard_SQF/tableTennisSqflite.dart';
import '../../../../../score_engine/tableTennisMatchEngine/table_tennis_match_engine.dart';
import '../../../../../shared_preferences/userPreferences.dart';
import '../../../../../view/USER/Home/Scoreboard/coin_toss/coin_toss_screen.dart';
import '../../../../../view/USER/Home/Scoreboard/Table_Tennis/table_tennis_scoreboard_screen.dart';

class TableTennisController extends GetxController {
  // ════════════════════ SETUP PARAMETERS ════════════════════
  var format = 'SINGLES'.obs; // 'SINGLES' or 'DOUBLES'
  var gamesFormat = 'BEST_OF_5'.obs; // 'BEST_OF_1', 'BEST_OF_3', 'BEST_OF_5', 'BEST_OF_7'
  var isFriendlyMode = false.obs;
  var pointsPerGame = 11.obs; // 11 (Pro default) or 7 / 21 (Friendly)

  var homeTeamName = 'Player A'.obs;
  var awayTeamName = 'Player B'.obs;

  final homeTeamController = TextEditingController(text: 'Player A');
  final awayTeamController = TextEditingController(text: 'Player B');

  var homeTeamRoster = <FriendModel>[].obs;
  var awayTeamRoster = <FriendModel>[].obs;

  var isLoading = false.obs;
  var currentUserFriendModel = Rxn<FriendModel>();

  // ════════════════════ LIVE MATCH STATE ════════════════════
  var currentMatchId = ''.obs;
  var currentMatch = Rxn<TableTennisMatchModel>();
  var tournamentId = ''.obs;
  var bracketMatchId = ''.obs;
  var isReadOnly = false.obs;

  late TableTennisMatchEngine engine;
  var isEngineReady = false.obs;
  var liveState = Rxn<TableTennisMatchState>();

  StreamSubscription<DocumentSnapshot>? _firestoreSubscription;

  @override
  void onInit() {
    super.onInit();
    _loadCurrentUser();

    homeTeamController.addListener(() {
      homeTeamName.value = homeTeamController.text.trim().isEmpty
          ? 'Player A'
          : homeTeamController.text;
    });

    awayTeamController.addListener(() {
      awayTeamName.value = awayTeamController.text.trim().isEmpty
          ? 'Player B'
          : awayTeamController.text;
    });
  }

  // ════════════════════ COUNTDOWNS & UNDO TIMERS ════════════════════
  var gamePointUndoSeconds = 0.obs;
  var lastPointUndosUsed = 0.obs; // Max 1 per match
  Timer? _gamePointUndoTimer;

  var matchOverCountdownSeconds = 20.obs;
  Timer? _matchOverTimer;
  var _lastSeenGameIndex = 0;
  var hasSavedLifetimeStats = false.obs;
  var hasMatchEndUndoBeenUsed = false.obs;

  @override
  void onClose() {
    _firestoreSubscription?.cancel();
    _gamePointUndoTimer?.cancel();
    _matchOverTimer?.cancel();
    homeTeamController.dispose();
    awayTeamController.dispose();
    super.onClose();
  }

  Future<void> _loadCurrentUser() async {
    final uid = FirebaseAuth.instance.currentUser?.uid ??
        await UserPreferences.getDocId() ??
        '';
    final email = await UserPreferences.getUserEmail() ?? '';
    final name = await UserPreferences.getUserName() ?? 'Current User';
    final pic = await UserPreferences.getProfileImageUrl() ?? '';

    if (uid.isNotEmpty) {
      final userModel = FriendModel(
        email: email.isNotEmpty ? email : uid,
        fullName: name,
        profileImageUrl: pic,
        isOnline: true,
      );
      currentUserFriendModel.value = userModel;
    }
  }

  int get maxAllowedPlayers => format.value == 'DOUBLES' ? 2 : 1;
  List<String> get homeTeamPlayers => homeTeamRoster.map((f) => f.email).toList();
  List<String> get awayTeamPlayers => awayTeamRoster.map((f) => f.email).toList();

  void addTeamPlayer(bool isSideA, FriendModel friend) {
    final roster = isSideA ? homeTeamRoster : awayTeamRoster;
    if (roster.any((p) => p.email == friend.email)) return;
    if (roster.length >= maxAllowedPlayers) {
      if (maxAllowedPlayers == 1) {
        roster.clear();
      } else {
        roster.removeAt(0);
      }
    }
    roster.add(friend);
    if (isSideA && (homeTeamName.value == 'Player A' || homeTeamName.value.isEmpty)) {
      homeTeamController.text = friend.fullName;
    } else if (!isSideA && (awayTeamName.value == 'Player B' || awayTeamName.value.isEmpty)) {
      awayTeamController.text = friend.fullName;
    }
  }

  void removeTeamPlayer(bool isSideA, FriendModel friend) {
    final roster = isSideA ? homeTeamRoster : awayTeamRoster;
    roster.removeWhere((p) => p.email == friend.email);
  }

  // ════════════════════ SETUP ACTIONS ════════════════════
  void setFormat(String newFormat) {
    format.value = newFormat;
  }

  void setGamesFormat(String newGamesFormat) {
    gamesFormat.value = newGamesFormat;
  }

  void toggleFriendlyRules(bool val) {
    isFriendlyMode.value = val;
    if (!val) {
      // Pro defaults
      pointsPerGame.value = 11;
    }
  }

  void setPointsPerGame(int val) {
    pointsPerGame.value = val;
  }

  void goToToss(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => CoinFlipScreen(
          teamAName: homeTeamName.value,
          teamBName: awayTeamName.value,
          sport: 'table_tennis',
          onTossComplete: (tossWinnerName, tossDecision) async {
            final tossWinnerSide = tossWinnerName == homeTeamName.value ? 'A' : 'B';
            await finalizeMatchAndStart(
              context: context,
              tossWinnerSide: tossWinnerSide,
              tossDecision: tossDecision,
            );
          },
        ),
      ),
    );
  }

  Future<void> finalizeMatchAndStart({
    required BuildContext context,
    String tossWinnerSide = 'A',
    String tossDecision = 'serve',
  }) async {
    isLoading.value = true;

    try {
      final matchId = const Uuid().v4();
      final currentUid = FirebaseAuth.instance.currentUser?.uid ?? 'guest_user';

      // Build stable player objects with UIDs
      final sideAPlays = _buildPlayersFromRoster(homeTeamRoster, homeTeamName.value);
      final sideBPlays = _buildPlayersFromRoster(awayTeamRoster, awayTeamName.value);

      final config = TableTennisMatchConfig(
        format: format.value,
        gamesFormat: gamesFormat.value,
        isFriendlyMode: isFriendlyMode.value,
        pointsPerGame: pointsPerGame.value,
        homeTeamName: homeTeamName.value,
        awayTeamName: awayTeamName.value,
      );

      engine = TableTennisMatchEngine(
        sideAPlayers: sideAPlays,
        sideBPlayers: sideBPlays,
        config: config,
        tossWinner: tossWinnerSide,
        tossDecision: tossDecision,
      );

      engine.startMatch();

      currentMatchId.value = matchId;
      liveState.value = engine.state;
      isEngineReady.value = true;

      // Build allPlayers list using stable UIDs
      final allPlayerUids = <String>{
        ...sideAPlays.map((p) => p.id),
        ...sideBPlays.map((p) => p.id),
        currentUid,
      }.toList();

      final model = TableTennisMatchModel(
        matchId: matchId,
        createdBy: currentUid,
        sport: 'table_tennis',
        status: 'in_progress',
        matchResult: '',
        allPlayers: allPlayerUids,
        homeTeamName: homeTeamName.value,
        awayTeamName: awayTeamName.value,
        homeTeamPlayers: sideAPlays.map((p) => p.id).toList(),
        awayTeamPlayers: sideBPlays.map((p) => p.id).toList(),
        engineState: engine.state.toJson(),
        config: config.toJson(),
      );

      currentMatch.value = model;

      // Save to SQLite & Firestore
      await TableTennisSqflite.instance.insertOrUpdateMatch(model);
      await FirebaseFirestore.instance
          .collection('matches')
          .doc(matchId)
          .set(model.toFirebaseJson());

      _listenToFirestore(matchId);

      isLoading.value = false;

      if (context.mounted) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (_) => const TableTennisScoreboardScreen(),
          ),
        );
      }
    } catch (e) {
      isLoading.value = false;
      Get.snackbar(
        'Error starting match',
        e.toString(),
        backgroundColor: Colors.redAccent,
        colorText: Colors.white,
      );
    }
  }

  // ════════════════════ LIVE SCORING WRAPPERS ════════════════════

  void recordPoint(String winnerSide, {String outcomeType = 'normalPoint'}) {
    if (!isEngineReady.value) return;
    if (liveState.value?.matchStatus == 'COMPLETED' || liveState.value?.matchStatus == 'RETIRED') return;
    try {
      engine.recordPoint(winnerSide: winnerSide, outcomeType: outcomeType);
      _syncMatchState();
    } catch (e) {
      Get.snackbar('Scoring Info', e.toString());
    }
  }

  void recordServiceFault() {
    if (!isEngineReady.value) return;
    if (liveState.value?.matchStatus == 'COMPLETED' || liveState.value?.matchStatus == 'RETIRED') return;
    engine.recordServiceFault();
    _syncMatchState();
  }

  void recordLet() {
    if (!isEngineReady.value) return;
    if (liveState.value?.matchStatus == 'COMPLETED' || liveState.value?.matchStatus == 'RETIRED') return;
    engine.recordLet();
    _syncMatchState();
  }

  void retirePlayer(String retiringSide) {
    if (!isEngineReady.value) return;
    if (liveState.value?.matchStatus == 'COMPLETED' || liveState.value?.matchStatus == 'RETIRED') return;
    engine.retirePlayer(retiringSide: retiringSide);
    _syncMatchState();
  }

  void callTimeout(String side) {
    if (!isEngineReady.value) return;
    if (liveState.value?.matchStatus == 'COMPLETED' || liveState.value?.matchStatus == 'RETIRED') return;
    try {
      engine.callTimeout(side: side);
      _syncMatchState();
    } catch (e) {
      Get.snackbar('Timeout Error', e.toString());
    }
  }

  void toggleExpedite() {
    if (!isEngineReady.value) return;
    if (liveState.value?.matchStatus == 'COMPLETED' || liveState.value?.matchStatus == 'RETIRED') return;
    engine.toggleExpedite();
    _syncMatchState();
  }

  void changeServer() {
    if (!isEngineReady.value) return;
    if (liveState.value?.matchStatus == 'COMPLETED' || liveState.value?.matchStatus == 'RETIRED') return;
    engine.changeServer();
    _syncMatchState();
  }

  void undo() {
    if (!isEngineReady.value || !engine.canUndo) return;
    final success = engine.undo();
    if (success) {
      _syncMatchState();
    }
  }

  void restoreTableTennisMatchFromSqflite(TableTennisMatchModel matchModel) {
    currentMatchId.value = matchModel.matchId;
    currentMatch.value = matchModel;

    final parsedState = matchModel.parsedEngineState;
    if (parsedState != null) {
      engine = TableTennisMatchEngine(
        sideAPlayers: parsedState.sideAPlayers,
        sideBPlayers: parsedState.sideBPlayers,
        config: parsedState.matchConfig,
      );
      engine.restoreState(parsedState.toJson());
      liveState.value = engine.state;

      // Sync controller setup parameters
      homeTeamName.value = parsedState.matchConfig.homeTeamName;
      awayTeamName.value = parsedState.matchConfig.awayTeamName;
      format.value = parsedState.matchConfig.format;
      gamesFormat.value = parsedState.matchConfig.gamesFormat;
      pointsPerGame.value = parsedState.matchConfig.pointsPerGame;
      isFriendlyMode.value = parsedState.matchConfig.isFriendlyMode;

      isEngineReady.value = true;
      _listenToFirestore(matchModel.matchId);
    }
  }

  void undoLastGamePoint() {
    if (!isEngineReady.value || !engine.canUndo) return;

    final success = engine.undo();
    if (success) {
      _gamePointUndoTimer?.cancel();
      gamePointUndoSeconds.value = 0;
      _syncMatchState();
    }
  }

  final Set<int> gamesWithUndoUsed = <int>{};

  void undoGamePoint() {
    final state = engine.state;
    final completedGameIdx = state.currentGameIndex > 0 ? state.currentGameIndex - 1 : 0;
    gamesWithUndoUsed.add(completedGameIdx);
    undoLastGamePoint();
  }

  void _triggerGamePointUndoCountdown() {
    _gamePointUndoTimer?.cancel();
    gamePointUndoSeconds.value = 10;
    _gamePointUndoTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (gamePointUndoSeconds.value > 1) {
        gamePointUndoSeconds.value--;
      } else {
        gamePointUndoSeconds.value = 0;
        timer.cancel();
      }
    });
  }

  void startMatchOverCountdown(VoidCallback onCountdownFinished) {
    _matchOverTimer?.cancel();
    matchOverCountdownSeconds.value = 20;
    _matchOverTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (matchOverCountdownSeconds.value > 1) {
        matchOverCountdownSeconds.value--;
      } else {
        matchOverCountdownSeconds.value = 0;
        timer.cancel();
        onCountdownFinished();
      }
    });
  }

  // ════════════════════ PERSISTENCE & SYNC ════════════════════

  void _syncMatchState() {
    final state = engine.state;
    liveState.value = state;

    // Detect if a game was just completed
    if (state.currentGameIndex > _lastSeenGameIndex) {
      final completedGameIdx = _lastSeenGameIndex;
      _lastSeenGameIndex = state.currentGameIndex;
      if (!gamesWithUndoUsed.contains(completedGameIdx)) {
        _triggerGamePointUndoCountdown();
      }
    } else if (state.currentGameIndex < _lastSeenGameIndex) {
      // Reverted game via normal undo
      _lastSeenGameIndex = state.currentGameIndex;
    }

    final stateJson = state.toJson();
    final isCompleted = state.matchStatus == 'COMPLETED' ||
        state.matchStatus == 'RETIRED';

    if (!isCompleted) {
      hasSavedLifetimeStats.value = false;
    }

    final updatedModel = TableTennisMatchModel(
      matchId: currentMatchId.value,
      createdBy: currentMatch.value?.createdBy ?? '',
      sport: 'table_tennis',
      status: isCompleted ? 'completed' : 'in_progress',
      matchResult: state.matchResult,
      allPlayers: currentMatch.value?.allPlayers ?? [],
      homeTeamName: state.matchConfig.homeTeamName,
      awayTeamName: state.matchConfig.awayTeamName,
      homeTeamPlayers: currentMatch.value?.homeTeamPlayers ?? [],
      awayTeamPlayers: currentMatch.value?.awayTeamPlayers ?? [],
      engineState: stateJson,
      config: state.matchConfig.toJson(),
      lastUpdatedAt: DateTime.now(),
      tournamentId: tournamentId.value.isNotEmpty ? tournamentId.value : currentMatch.value?.tournamentId,
      bracketMatchId: bracketMatchId.value.isNotEmpty ? bracketMatchId.value : currentMatch.value?.bracketMatchId,
    );

    currentMatch.value = updatedModel;

    // Async storage writes
    TableTennisSqflite.instance.insertOrUpdateMatch(updatedModel);
    FirebaseFirestore.instance
        .collection('matches')
        .doc(currentMatchId.value)
        .set(updatedModel.toFirebaseJson(), SetOptions(merge: true));

    if (isCompleted && !hasSavedLifetimeStats.value) {
      hasSavedLifetimeStats.value = true;
      _saveLifetimeStats(updatedModel);
    }
  }

  void _listenToFirestore(String matchId) {
    _firestoreSubscription?.cancel();
    _firestoreSubscription = FirebaseFirestore.instance
        .collection('matches')
        .doc(matchId)
        .snapshots()
        .listen((doc) {
      if (!doc.exists || doc.data() == null) return;
      final m = TableTennisMatchModel.fromFirebaseJson(doc.data()!);

      // CREATOR-DEVICE SELF-WRITE GUARD:
      // Only patch state if this device is NOT the match creator to prevent
      // local undo racing incoming Firestore snapshots!
      final currentUid = FirebaseAuth.instance.currentUser?.uid;
      if (currentUid != m.createdBy && m.engineState != null && isEngineReady.value) {
        engine.patchState(m.engineState!);
        liveState.value = engine.state;
      }
    });
  }

  Future<void> _saveLifetimeStats(TableTennisMatchModel m) async {
    try {
      final state = engine.state;
      final allPlayers = [...state.sideAPlayers, ...state.sideBPlayers];

      for (final player in allPlayers) {
        if (player.id.isEmpty || player.id.startsWith('guest_')) continue;

        final userRef = FirebaseFirestore.instance.collection('users').doc(player.id);

        final isWinner = (state.matchResult.contains(m.homeTeamName) &&
                state.sideAPlayers.any((p) => p.id == player.id)) ||
            (state.matchResult.contains(m.awayTeamName) &&
                state.sideBPlayers.any((p) => p.id == player.id));

        await FirebaseFirestore.instance.runTransaction((transaction) async {
          final snapshot = await transaction.get(userRef);
          if (!snapshot.exists) return;

          final stats = Map<String, dynamic>.from(
              snapshot.data()?['tableTennisStats'] ?? {});

          final matchesPlayed = (stats['matchesPlayed'] ?? 0) + 1;
          final matchesWon = (stats['matchesWon'] ?? 0) + (isWinner ? 1 : 0);
          final acesTotal = (stats['aces'] ?? 0) + player.aces;
          final serviceFaultsTotal = (stats['serviceFaults'] ?? 0) + player.serviceFaults;
          final pointsWonTotal = (stats['pointsWon'] ?? 0) + player.pointsWon;

          transaction.update(userRef, {
            'tableTennisStats': {
              'matchesPlayed': matchesPlayed,
              'matchesWon': matchesWon,
              'aces': acesTotal,
              'serviceFaults': serviceFaultsTotal,
              'pointsWon': pointsWonTotal,
              'lastPlayedAt': FieldValue.serverTimestamp(),
            }
          });
        });
      }
    } catch (e) {
      debugPrint("Error writing lifetime table tennis stats: $e");
    }
  }

  List<TableTennisPlayer> _buildPlayersFromRoster(
      List<FriendModel> roster, String defaultName) {
    if (roster.isEmpty) {
      return [
        TableTennisPlayer(
          id: const Uuid().v4(),
          name: defaultName,
        )
      ];
    }
    return roster.map((friend) {
      final uid = friend.email.isNotEmpty ? friend.email : const Uuid().v4();
      return TableTennisPlayer(
        id: uid,
        name: friend.fullName.isNotEmpty ? friend.fullName : defaultName,
        email: friend.email,
        profilePic: friend.profileImageUrl,
      );
    }).toList();
  }
}
