import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:uuid/uuid.dart';
import '../../../../../model/User_Models/Home_Models/Scoreboard_Model/Basketball/basketball_model.dart';
import '../../../../../model/User_Models/Home_Models/Scoreboard_Model/Basketball/basketball_state_models.dart';
import '../../../../../model/User_Models/Home_Models/Friends_Model/friends_model.dart';
import '../../../../../sqflite/User_SQF/Home_SQF/Scoreboard_SQF/Basketball/basketballSqflite.dart';
import '../../../../../shared_preferences/userPreferences.dart';
import '../../../../../score_engine/basketballMatchEngine/basketball_match_engine.dart';
import 'dart:async';

class BasketballController extends GetxController {
  // Setup Parameters
  var quarterLengthMinutes = 10.obs;
  var shotClockSeconds = 24.obs;
  var foulOutLimit = 5.obs;
  var timeoutsPerTeam = 5.obs;
  var isProfessionalMode = false.obs;

  var homeTeamName = ''.obs;
  var awayTeamName = ''.obs;

  final homeTeamController = TextEditingController(text: '');
  final awayTeamController = TextEditingController(text: '');

  var homeTeamPlayers = <String>[].obs; // email strings
  var awayTeamPlayers = <String>[].obs;

  var homeTeamRoster = <FriendModel>[].obs;
  var awayTeamRoster = <FriendModel>[].obs;

  var isLoading = false.obs;
  var currentUserFriendModel = Rxn<FriendModel>();

  // ════════════════════ LIVE MATCH STATE ════════════════════
  var currentMatchId = ''.obs;
  var currentMatch = Rxn<BasketballMatchModel>();
  late BasketballMatchEngine engine;
  var isEngineReady = false.obs;
  var liveState = Rxn<BasketballMatchState>();

  StreamSubscription? _matchSubscription;
  Timer? _gameTimer;
  Timer? _shotTimer;

  @override
  void onInit() {
    super.onInit();
    _loadCurrentUser();
    homeTeamController.addListener(() => homeTeamName.value = homeTeamController.text);
    awayTeamController.addListener(() => awayTeamName.value = awayTeamController.text);
  }

  @override
  void onClose() {
    homeTeamController.dispose();
    awayTeamController.dispose();
    _matchSubscription?.cancel();
    _gameTimer?.cancel();
    _shotTimer?.cancel();
    super.onClose();
  }

  Future<void> _loadCurrentUser() async {
    final email = await UserPreferences.getUserEmail() ?? await UserPreferences.getDocId() ?? '';
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
  void toggleMode(bool isPro) {
     isProfessionalMode.value = isPro;
     if (isPro) {
        quarterLengthMinutes.value = 12; // NBA style default
        foulOutLimit.value = 6;
     } else {
        quarterLengthMinutes.value = 10;
        foulOutLimit.value = 5;
     }
  }

  void updateQuarterLength(int val) => quarterLengthMinutes.value = val;
  void updateShotClock(int val) => shotClockSeconds.value = val;
  void updateFoulOutLimit(int val) => foulOutLimit.value = val;
  void updateTimeouts(int val) => timeoutsPerTeam.value = val;

  void addPlayerToHomeTeam(FriendModel player) {
    if (!homeTeamPlayers.contains(player.email)) {
      homeTeamPlayers.add(player.email);
      homeTeamRoster.add(player);
      awayTeamPlayers.remove(player.email);
      awayTeamRoster.removeWhere((p) => p.email == player.email);
      if (homeTeamName.value.isEmpty || homeTeamName.value == "Team ${player.fullName}") {
         homeTeamName.value = "Team ${player.fullName}";
         homeTeamController.text = homeTeamName.value;
      }
    }
  }

  void removePlayerFromHomeTeam(FriendModel player) {
    homeTeamPlayers.remove(player.email);
    homeTeamRoster.removeWhere((p) => p.email == player.email);
    if (homeTeamName.value == "Team ${player.fullName}") {
       if (homeTeamRoster.isNotEmpty) {
           homeTeamName.value = "Team ${homeTeamRoster.first.fullName}";
           homeTeamController.text = homeTeamName.value;
       } else {
           homeTeamName.value = "";
           homeTeamController.text = "";
       }
    }
  }

  void addPlayerToAwayTeam(FriendModel player) {
    if (!awayTeamPlayers.contains(player.email)) {
      awayTeamPlayers.add(player.email);
      awayTeamRoster.add(player);
      homeTeamPlayers.remove(player.email);
      homeTeamRoster.removeWhere((p) => p.email == player.email);
      if (awayTeamName.value.isEmpty || awayTeamName.value == "Team ${player.fullName}") {
         awayTeamName.value = "Team ${player.fullName}";
         awayTeamController.text = awayTeamName.value;
      }
    }
  }

  void removePlayerFromAwayTeam(FriendModel player) {
    awayTeamPlayers.remove(player.email);
    awayTeamRoster.removeWhere((p) => p.email == player.email);
    if (awayTeamName.value == "Team ${player.fullName}") {
       if (awayTeamRoster.isNotEmpty) {
           awayTeamName.value = "Team ${awayTeamRoster.first.fullName}";
           awayTeamController.text = awayTeamName.value;
       } else {
           awayTeamName.value = "";
           awayTeamController.text = "";
       }
    }
  }

  // ════════════════════ ENGINE INITIALIZATION ════════════════════
  Future<void> createMatch() async {
     try {
         isLoading.value = true;
         final uid = FirebaseAuth.instance.currentUser?.uid ?? '';
         final docId = const Uuid().v4();
         currentMatchId.value = docId;

         List<String> allPlayers = [];
         allPlayers.addAll(homeTeamPlayers);
         allPlayers.addAll(awayTeamPlayers);
         if (uid.isNotEmpty && !allPlayers.contains(uid)) {
            allPlayers.add(uid);
         }

         final config = BasketballMatchConfig(
             quarterLengthMinutes: quarterLengthMinutes.value,
             shotClockSeconds: shotClockSeconds.value,
             foulOutLimit: foulOutLimit.value,
             technicalFoulsEnabled: isProfessionalMode.value,
             timeoutsPerTeam: timeoutsPerTeam.value,
             mode: isProfessionalMode.value ? MatchMode.professional : MatchMode.friendly,
         );

         engine = BasketballMatchEngine(
             config: config,
             homeTeamName: homeTeamName.value,
             awayTeamName: awayTeamName.value,
             homeRoster: homeTeamRoster.map((p) => BasketballPlayer(id: p.email, name: p.fullName)).toList(),
             awayRoster: awayTeamRoster.map((p) => BasketballPlayer(id: p.email, name: p.fullName)).toList(),
         );

         liveState.value = engine.state;
         isEngineReady.value = true;

         final matchModel = BasketballMatchModel(
             id: docId,
             createdBy: uid,
             homeTeamName: homeTeamName.value,
             awayTeamName: awayTeamName.value,
             allPlayers: allPlayers,
             homeTeamPlayers: homeTeamPlayers,
             awayTeamPlayers: awayTeamPlayers,
             matchMode: isProfessionalMode.value ? 'professional' : 'friendly',
             config: config.toJson(),
             status: 'pending',
             engineState: engine.state.toJson(),
             createdAt: DateTime.now(),
         );

         currentMatch.value = matchModel;

         await BasketballSqflite.instance.insertMatch(matchModel);
         await FirebaseFirestore.instance.collection('matches').doc(docId).set(matchModel.toMap());

         _listenToMatchUpdates();
     } catch (e) {
         Get.snackbar('Error', 'Failed to create match: $e');
     } finally {
         isLoading.value = false;
     }
  }

  void _listenToMatchUpdates() {
     _matchSubscription?.cancel();
     _matchSubscription = FirebaseFirestore.instance
         .collection('matches')
         .doc(currentMatchId.value)
         .snapshots()
         .listen((doc) {
             if (doc.exists && doc.data() != null) {
                 final data = doc.data()!;
                 // When reading back, we only update local state if we aren't the ones who just wrote it,
                 // but for single-writer model, this listener mainly handles resume scenarios.
                 final updatedModel = BasketballMatchModel.fromMap(data, doc.id);
                 currentMatch.value = updatedModel;

                 // If engine wasn't ready (app restart), initialize it
                 if (!isEngineReady.value) {
                    final config = BasketballMatchConfig.fromJson(updatedModel.config);
                    engine = BasketballMatchEngine(
                       config: config,
                       homeTeamName: updatedModel.homeTeamName,
                       awayTeamName: updatedModel.awayTeamName,
                       homeRoster: [], // will be replaced by restoreState
                       awayRoster: [],
                    );
                    engine.restoreState(updatedModel.engineState);
                    liveState.value = engine.state;
                    isEngineReady.value = true;
                 }
             }
         });
  }

  Future<void> resumeMatch(String matchId) async {
      isLoading.value = true;
      currentMatchId.value = matchId;
      _listenToMatchUpdates(); // will initialize engine on first read
      isLoading.value = false;
  }

  // ════════════════════ ACTIONS ════════════════════
  Future<void> resolveTipOff(String winnerTeamId, String possessionArrowTeamId) async {
     engine.startMatch(wonTipOffTeamId: winnerTeamId, possessionArrowTeamId: possessionArrowTeamId);
     await _syncState();
  }

  Future<void> _syncState() async {
     liveState.value = engine.state;
     liveState.refresh();

     if (currentMatch.value != null) {
         String dbStatus = _mapPhaseToStatus(engine.state.phase);

         currentMatch.value = BasketballMatchModel(
             id: currentMatch.value!.id,
             createdBy: currentMatch.value!.createdBy,
             homeTeamName: currentMatch.value!.homeTeamName,
             awayTeamName: currentMatch.value!.awayTeamName,
             allPlayers: currentMatch.value!.allPlayers,
             homeTeamPlayers: currentMatch.value!.homeTeamPlayers,
             awayTeamPlayers: currentMatch.value!.awayTeamPlayers,
             matchMode: currentMatch.value!.matchMode,
             config: currentMatch.value!.config,
             status: dbStatus,
             engineState: engine.state.toJson(),
             matchResult: engine.state.matchResult,
             createdAt: currentMatch.value!.createdAt,
             lastUpdatedAt: DateTime.now(),
         );

         await BasketballSqflite.instance.updateMatch(currentMatch.value!);
         await FirebaseFirestore.instance.collection('matches').doc(currentMatchId.value).update({
             'status': dbStatus,
             'engineState': engine.state.toJson(),
             'matchResult': engine.state.matchResult,
             'lastUpdatedAt': FieldValue.serverTimestamp(),
         });
     }
  }

  String _mapPhaseToStatus(MatchPhase phase) {
      switch (phase) {
          case MatchPhase.setup:
          case MatchPhase.tipOff:
              return 'pending';
          case MatchPhase.completed:
              return 'completed';
          default:
              return 'live';
      }
  }

  Future<void> dispatchEvent(BasketballEvent event) async {
      engine.dispatch(event);
      await _syncState();

      // Save event to subcollection
      final eventMap = event.toJson();
      await BasketballSqflite.instance.insertPossession(currentMatchId.value, event.id, eventMap);
      await FirebaseFirestore.instance
         .collection('matches')
         .doc(currentMatchId.value)
         .collection('possessions')
         .doc(event.id)
         .set(eventMap);
  }

  Future<void> undo() async {
      if (engine.canUndo) {
          engine.undo();
          await _syncState();
          // Undoing a subcollection doc mathematically requires deleting the last one,
          // but we can skip that complexity and just trust engineState as source of truth.
      }
  }

  Future<void> completeMatchManual(String result) async {
      engine.completeMatchManual(result);
      await _syncState();
  }

  // Timer Actions

  void toggleClock() {
      if (engine.state.isClockRunning) {
         _pauseClocks();
      } else {
         _startClocks();
      }
  }

  void _startClocks() {
      engine.updateGameClock(engine.state.gameClockSeconds, isRunning: true);
      liveState.value = engine.state;
      liveState.refresh();

      _gameTimer?.cancel();
      _shotTimer?.cancel();

      _gameTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
          if (engine.state.gameClockSeconds > 0) {
             engine.updateGameClock(engine.state.gameClockSeconds - 1, isRunning: true);
             liveState.value = engine.state;
             liveState.refresh();
             if (engine.state.gameClockSeconds == 0) {
                _pauseClocks();
                dispatchEvent(BasketballEvent(
                    id: const Uuid().v4(),
                    type: EventType.quarterEnd,
                    quarter: engine.state.currentQuarter,
                    gameClockRemaining: 0,
                    timestamp: DateTime.now(),
                ));
             }
          }
      });

      _shotTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
          if (engine.state.shotClockSeconds > 0) {
             engine.updateShotClock(engine.state.shotClockSeconds - 1);
             liveState.value = engine.state;
             liveState.refresh();
          } else {
             _pauseClocks();
          }
      });
  }

  void _pauseClocks() {
      _gameTimer?.cancel();
      _shotTimer?.cancel();
      engine.updateGameClock(engine.state.gameClockSeconds, isRunning: false);
      liveState.value = engine.state;
      liveState.refresh();
  }

  void resetShotClockManual() {
      engine.resetShotClockManual();
      liveState.value = engine.state;
      liveState.refresh();
  }

  void startNextQuarter() {
      engine.startNextQuarter();
      _syncState();
  }
}
