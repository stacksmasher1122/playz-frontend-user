import 'dart:async';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:redesign/theme/app_colors.dart';
import 'package:redesign/model/User_Models/Home_Models/Scoreboard_Model/Pickleball/pickleball_state_models.dart';
import 'package:redesign/model/User_Models/Home_Models/Scoreboard_Model/Pickleball/pickleball_model.dart';
import 'package:redesign/model/User_Models/Home_Models/Friends_Model/friends_model.dart';
import 'package:redesign/sqflite/User_SQF/Home_SQF/Scoreboard_SQF/pickleballSqflite.dart';
import 'package:redesign/view/USER/Home/Scoreboard/coin_toss/coin_toss_screen.dart';
import 'package:redesign/view/USER/Home/Scoreboard/Pickleball/live_match/pickleball_scoreboard_screen.dart';

class PickleballController extends GetxController {
  final TextEditingController homeTeamController = TextEditingController(text: 'Side A');
  final TextEditingController awayTeamController = TextEditingController(text: 'Side B');

  final RxString homeTeamName = 'Side A'.obs;
  final RxString awayTeamName = 'Side B'.obs;

  final RxList<FriendModel> teamARoster = <FriendModel>[].obs;
  final RxList<FriendModel> teamBRoster = <FriendModel>[].obs;
  final RxList<String> teamAPlayers = <String>[].obs;
  final RxList<String> teamBPlayers = <String>[].obs;

  final RxString format = 'SINGLES'.obs; // 'SINGLES' or 'DOUBLES'
  final RxInt targetPoints = 11.obs; // 11, 15, 21
  final RxInt gamesToWin = 2.obs; // 1 (Best of 1), 2 (Best of 3), 3 (Best of 5)
  final RxBool isSideoutScoring = true.obs; // USAPA Sideout scoring default
  final RxBool isProRules = true.obs;

  // Live Scoreboard State Guards
  final RxBool isMatchStarted = false.obs;
  final Rxn<PickleballMatchModel> currentMatch = Rxn<PickleballMatchModel>();
  final Rxn<PickleballMatchState> liveState = Rxn<PickleballMatchState>();
  late PickleballMatchEngine engine;

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
  }

  @override
  void onClose() {
    _firestoreSubscription?.cancel();
    super.onClose();
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
    format.value = 'SINGLES';
    targetPoints.value = 11;
    gamesToWin.value = 2;
    isSideoutScoring.value = true;
    isProRules.value = true;
  }

  void setFormat(String f) {
    format.value = f;
  }

  void incrementTargetPoints() {
    if (targetPoints.value == 11) targetPoints.value = 15;
    else if (targetPoints.value == 15) targetPoints.value = 21;
  }

  void decrementTargetPoints() {
    if (targetPoints.value == 21) targetPoints.value = 15;
    else if (targetPoints.value == 15) targetPoints.value = 11;
  }

  void setGamesToWin(int count) {
    gamesToWin.value = count;
  }

  void toggleSideoutScoring(bool value) {
    isSideoutScoring.value = value;
  }

  void toggleProRules(bool value) {
    isProRules.value = value;
    if (value) {
      isSideoutScoring.value = true;
      targetPoints.value = 11;
      gamesToWin.value = 2;
    }
  }

  void addTeamPlayer(bool isTeamA, FriendModel player) {
    final roster = isTeamA ? teamARoster : teamBRoster;
    final playersList = isTeamA ? teamAPlayers : teamBPlayers;
    final maxAllowed = format.value == 'DOUBLES' ? 2 : 1;

    if (roster.length >= maxAllowed) {
      Get.snackbar(
        'Limit Reached',
        'Cannot add more than $maxAllowed player(s) for ${format.value.toLowerCase()} match.',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: AppColors.cardSurface,
        colorText: Colors.white,
      );
      return;
    }

    if (teamAPlayers.contains(player.email) || teamBPlayers.contains(player.email)) {
      Get.snackbar(
        'Error',
        'Player already added.',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: AppColors.cardSurface,
        colorText: Colors.white,
      );
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

  void proceedToCoinToss(BuildContext context) {
    if (teamARoster.isEmpty || teamBRoster.isEmpty) {
      Get.snackbar(
        'Teams Required',
        'Please add players to both teams.',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: AppColors.cardSurface,
        colorText: Colors.white,
      );
      return;
    }

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => CoinFlipScreen(
          teamAName: homeTeamName.value.isNotEmpty ? homeTeamName.value : 'Side A',
          teamBName: awayTeamName.value.isNotEmpty ? awayTeamName.value : 'Side B',
          sport: 'pickleball',
          onTossComplete: (winnerTeam, choice) async {
            final isSideAServing = (winnerTeam == homeTeamName.value && choice.toLowerCase().contains('serve')) ||
                (winnerTeam != homeTeamName.value && choice.toLowerCase().contains('receive'));
            startMatchFromSetup(initialServingSide: isSideAServing ? 'sideA' : 'sideB');
          },
        ),
      ),
    );
  }

  Future<void> startMatchFromSetup({String initialServingSide = 'sideA'}) async {
    isLoading.value = true;
    final matchId = 'PICKLE_${DateTime.now().millisecondsSinceEpoch}';
    currentMatchId.value = matchId;

    final teamAPlayerModels = teamARoster
        .map((f) => PickleballPlayer(
              id: f.email,
              name: f.fullName.isNotEmpty ? f.fullName : f.email,
            ))
        .toList();

    final teamBPlayerModels = teamBRoster
        .map((f) => PickleballPlayer(
              id: f.email,
              name: f.fullName.isNotEmpty ? f.fullName : f.email,
            ))
        .toList();

    final config = PickleballMatchConfig(
      format: format.value,
      targetPoints: targetPoints.value,
      winByTwo: true,
      isSideoutScoring: isSideoutScoring.value,
      gamesToWin: gamesToWin.value,
      isProRules: isProRules.value,
    );

    final initState = PickleballMatchState.initial(
      teamA: teamAPlayerModels,
      teamB: teamBPlayerModels,
      config: config,
      servingSide: initialServingSide,
    );

    engine = PickleballMatchEngine(initState);
    liveState.value = engine.state;
    isEngineReady.value = true;
    isMatchStarted.value = true; // Auto-started for instant 1-tap scoring!

    final user = FirebaseAuth.instance.currentUser;
    final userId = user?.uid ?? 'local_user';

    final model = PickleballMatchModel(
      matchId: matchId,
      userId: userId,
      homeTeam: homeTeamName.value.isNotEmpty ? homeTeamName.value : 'Side A',
      awayTeam: awayTeamName.value.isNotEmpty ? awayTeamName.value : 'Side B',
      homeGamesWon: 0,
      awayGamesWon: 0,
      currentScoreDisplay: 'Game 1',
      isCompleted: false,
      matchResult: '',
      engineState: engine.state.toJson(),
    );

    currentMatch.value = model;

    try {
      await PickleballSqfliteService.insertMatch(model);
    } catch (_) {}

    try {
      await FirebaseFirestore.instance
          .collection('pickleball_matches')
          .doc(matchId)
          .set(model.toFirebaseJson());
    } catch (_) {}

    _listenToFirestore(matchId);

    isLoading.value = false;
    Get.off(() => const PickleballScoreboardScreen());
  }

  void _listenToFirestore(String matchId) {
    _firestoreSubscription?.cancel();
    _firestoreSubscription = FirebaseFirestore.instance
        .collection('pickleball_matches')
        .doc(matchId)
        .snapshots()
        .listen((doc) {
      if (doc.exists && doc.data() != null) {
        final remoteModel = PickleballMatchModel.fromFirebaseJson(doc.data()!);
        if (remoteModel.userId != FirebaseAuth.instance.currentUser?.uid) {
          isReadOnly.value = true;
          currentMatch.value = remoteModel;
          if (remoteModel.engineState != null) {
            final remoteState = PickleballMatchState.fromJson(remoteModel.engineState!);
            liveState.value = remoteState;
          }
        }
      }
    });
  }

  void scorePoint(String scoringSide) {
    if (isReadOnly.value || liveState.value == null) return;
    engine.scorePoint(scoringSide);
    liveState.value = engine.state;
    _syncMatchState();

    if (engine.state.isMatchFinished) {
      finishMatch();
    }
  }

  void registerFault() {
    if (isReadOnly.value || liveState.value == null) return;
    engine.registerFault();
    liveState.value = engine.state;
    _syncMatchState();

    if (engine.state.isMatchFinished) {
      finishMatch();
    }
  }

  void advanceGame() {
    if (isReadOnly.value) return;
    engine.advanceGame();
    liveState.value = engine.state;
    _syncMatchState();
  }

  void undoLastAction() {
    if (isReadOnly.value) return;
    if (engine.canUndo) {
      engine.undo();
      liveState.value = engine.state;
      _syncMatchState();
    }
  }

  void undoGameCompletionPoint() {
    if (isReadOnly.value) return;
    if (engine.canUndo) {
      engine.undo();
      liveState.value = engine.state;
      _syncMatchState();
      Get.snackbar(
        'Game Undone',
        'The game-ending point was undone.',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: AppColors.cardSurface,
        colorText: Colors.white,
      );
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
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: AppColors.cardSurface,
        colorText: Colors.white,
      );
    }
  }

  void finishMatch() {
    engine.endMatch();
    liveState.value = engine.state;

    final winner = engine.state.matchWinner;
    String result = 'MATCH TIED';
    if (winner == 'sideA') {
      result = '${currentMatch.value?.homeTeam ?? "Side A"} won the match ${engine.state.sideAGamesWon}-${engine.state.sideBGamesWon} games!';
    } else if (winner == 'sideB') {
      result = '${currentMatch.value?.awayTeam ?? "Side B"} won the match ${engine.state.sideBGamesWon}-${engine.state.sideAGamesWon} games!';
    }

    _syncMatchState(isFinished: true, result: result);
  }

  Future<void> _syncMatchState({bool isFinished = false, String result = ''}) async {
    if (currentMatch.value == null) return;
    final updated = PickleballMatchModel(
      matchId: currentMatch.value!.matchId,
      userId: currentMatch.value!.userId,
      homeTeam: currentMatch.value!.homeTeam,
      awayTeam: currentMatch.value!.awayTeam,
      homeGamesWon: engine.state.sideAGamesWon,
      awayGamesWon: engine.state.sideBGamesWon,
      currentScoreDisplay: 'Game ${engine.state.currentGameIndex + 1}',
      isCompleted: isFinished || engine.state.isMatchFinished,
      matchResult: result.isNotEmpty ? result : currentMatch.value!.matchResult,
      engineState: engine.state.toJson(),
      updatedAt: DateTime.now(),
    );

    currentMatch.value = updated;
    try {
      await PickleballSqfliteService.updateMatch(updated);
    } catch (_) {}

    try {
      await FirebaseFirestore.instance
          .collection('pickleball_matches')
          .doc(updated.matchId)
          .set(updated.toFirebaseJson(), SetOptions(merge: true));
    } catch (_) {}
  }

  Future<void> restorePickleballMatchFromSqflite(PickleballMatchModel matchModel) async {
    currentMatchId.value = matchModel.matchId;
    currentMatch.value = matchModel;
    isReadOnly.value = false;

    if (matchModel.engineState != null) {
      final restoredState = PickleballMatchState.fromJson(matchModel.engineState!);
      engine = PickleballMatchEngine(restoredState);
      liveState.value = engine.state;
      isEngineReady.value = true;
      isMatchStarted.value = true;
      _listenToFirestore(matchModel.matchId);
    }
  }

  static Future<void> resumeMatch(String matchId) async {
    final controller = Get.isRegistered<PickleballController>()
        ? Get.find<PickleballController>()
        : Get.put(PickleballController());

    final matchData = await PickleballSqfliteService.getMatchById(matchId);
    if (matchData != null) {
      await controller.restorePickleballMatchFromSqflite(matchData);
      Get.to(() => const PickleballScoreboardScreen());
    }
  }
}
