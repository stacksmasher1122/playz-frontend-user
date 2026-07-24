import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../../../../../../model/User_Models/Home_Models/Friends_Model/friends_model.dart';
import '../../../../../../model/football/football_model.dart';
import '../../../../../../score_engine/footballMatchEngine/football_match_engine.dart';
import 'package:uuid/uuid.dart';
import '../../../../../sqflite/User_SQF/Home_SQF/Scoreboard_SQF/footballSqflite.dart';
import 'football_controller.dart';
import '../../../../../view/USER/Home/Scoreboard/Football/football_scoreboard/football_scoreboard_screen.dart';

class FootballCreateMatchController extends GetxController {
  final RxBool isLoading = false.obs;

  final RxString matchName = ''.obs;
  final RxString tournament = ''.obs;
  final RxList<String> tournamentOptions = <String>[
    'Friendly Match',
    'PlayZ Champions Cup',
    'Local League',
    'Weekend Knockout',
  ].obs;
  final Rx<DateTime?> selectedDate = Rx<DateTime?>(null);
  final RxString venue = ''.obs;
  final RxString referee = ''.obs;
  final RxInt halves = 2.obs;
  final RxBool varSimulation = false.obs;

  void selectTournament(String? val) {
    tournament.value = val ?? '';
  }

  Future<void> selectDateTime(BuildContext context) async {
    final date = await showDatePicker(
      context: context,
      initialDate: selectedDate.value ?? DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 365)),
    );
    if (date != null && context.mounted) {
      final time = await showTimePicker(
        context: context,
        initialTime: TimeOfDay.fromDateTime(selectedDate.value ?? DateTime.now()),
      );
      if (time != null) {
        selectedDate.value = DateTime(date.year, date.month, date.day, time.hour, time.minute);
      }
    }
  }

  void selectVenue() {
    venue.value = 'Main Turf Arena';
  }

  void searchReferee(String query) {
    referee.value = query;
  }

  void selectMatchFormat(String format) {
    selectedFormat.value = format;
    if (format == '11v11') {
      maxAllowedPlayers.value = 11;
    } else if (format == '7v7') {
      maxAllowedPlayers.value = 7;
    } else if (format == '5v5') {
      maxAllowedPlayers.value = 5;
    }
  }

  void updateDuration(double val) {
    duration.value = val;
  }

  void increaseHalves() {
    if (halves.value < 4) halves.value++;
  }

  void decreaseHalves() {
    if (halves.value > 1) halves.value--;
  }

  void toggleExtraTime() {
    extraTime.value = !extraTime.value;
  }

  void togglePenaltyShootout() {
    penaltyShootout.value = !penaltyShootout.value;
  }

  void toggleVAR() {
    varSimulation.value = !varSimulation.value;
  }
  
  // Format settings
  final RxString selectedFormat = '11v11'.obs;
  final RxDouble duration = 45.0.obs; // Half duration
  final RxInt maxAllowedPlayers = 11.obs;
  final RxInt maxSubs = 5.obs;
  final RxBool extraTime = false.obs;
  final RxBool penaltyShootout = false.obs;

  // Teams & Friends
  final RxString homeTeamName = ''.obs;
  final RxString awayTeamName = ''.obs;

  final RxList<String> homeTeamPlayers = <String>[].obs;
  final RxList<String> awayTeamPlayers = <String>[].obs;
  
  final RxList<FriendModel> homeTeamRoster = <FriendModel>[].obs;
  final RxList<FriendModel> awayTeamRoster = <FriendModel>[].obs;

  final Rx<FriendModel?> currentUserFriendModel = Rx<FriendModel?>(null);

  @override
  void onInit() {
    super.onInit();
    _loadCurrentUserProfile();
  }

  void loadInitialData() {
    isLoading.value = true;
    Future.delayed(Duration(milliseconds: 500), () {
      isLoading.value = false;
    });
  }

  Future<void> _loadCurrentUserProfile() async {
    try {
      final user = FirebaseAuth.instance.currentUser;
      if (user != null) {
        final doc = await FirebaseFirestore.instance.collection('users').doc(user.uid).get();
        if (doc.exists) {
          currentUserFriendModel.value = FriendModel.fromMap(doc.data() as Map<String, dynamic>);
        }
      }
    } catch (e) {
      debugPrint("Error loading profile: \$e");
    }
  }

  void updateFormat(String format, int players) {
    selectedFormat.value = format;
    maxAllowedPlayers.value = players;
  }

  void addTeamPlayer(bool isHome, FriendModel player) {
    List<String> currentEmails = isHome ? homeTeamPlayers : awayTeamPlayers;
    List<FriendModel> currentRoster = isHome ? homeTeamRoster : awayTeamRoster;

    if (currentEmails.length >= maxAllowedPlayers.value) {
      Get.snackbar('Team Full', 'Cannot add more players.');
      return;
    }

    if (!currentEmails.contains(player.email)) {
      if (isHome) {
        if (awayTeamPlayers.contains(player.email)) {
          awayTeamPlayers.remove(player.email);
          awayTeamRoster.removeWhere((p) => p.email == player.email);
        }
      } else {
        if (homeTeamPlayers.contains(player.email)) {
          homeTeamPlayers.remove(player.email);
          homeTeamRoster.removeWhere((p) => p.email == player.email);
        }
      }
      currentEmails.add(player.email);
      currentRoster.add(player);
    }
  }

  void removeTeamPlayer(bool isHome, FriendModel player) {
    if (isHome) {
      homeTeamPlayers.remove(player.email);
      homeTeamRoster.removeWhere((p) => p.email == player.email);
    } else {
      awayTeamPlayers.remove(player.email);
      awayTeamRoster.removeWhere((p) => p.email == player.email);
    }
  }

  bool validateForm() {
    if (homeTeamName.value.trim().isEmpty || awayTeamName.value.trim().isEmpty) {
      Get.snackbar('Error', 'Please provide names for both teams.');
      return false;
    }
    return true;
  }

  void saveAsTemplate() {
    Get.snackbar('Success', 'Template saved successfully.');
  }

  Future<void> createMatchAndStart() async {
    if (!validateForm()) return;

    isLoading.value = true;
    try {
      final matchId = const Uuid().v4();
      final now = DateTime.now();

      final homeSquad = homeTeamRoster.map((p) => MatchPlayer(
          id: p.email, name: p.fullName.isNotEmpty ? p.fullName : p.email, number: 0, isStarter: true, isOnPitch: true)).toList();
      final awaySquad = awayTeamRoster.map((p) => MatchPlayer(
          id: p.email, name: p.fullName.isNotEmpty ? p.fullName : p.email, number: 0, isStarter: true, isOnPitch: true)).toList();

      final engineState = FootballMatchState();
      engineState.homeTeam = MatchTeam(id: 'home', name: homeTeamName.value, color: '0xFF1DB954', squad: homeSquad);
      engineState.awayTeam = MatchTeam(id: 'away', name: awayTeamName.value, color: '0xFFE53935', squad: awaySquad);

      final List<String> allEmails = [...homeTeamPlayers, ...awayTeamPlayers];

      final newMatch = FootballMatchModel(
        id: matchId,
        createdBy: FirebaseAuth.instance.currentUser?.uid ?? 'unknown',
        sport: 'football',
        allPlayers: allEmails,
        homeTeamPlayers: homeTeamPlayers,
        awayTeamPlayers: awayTeamPlayers,
        config: {
          'halfDurationMinutes': duration.value.toInt(),
          'extraTimeEnabled': extraTime.value,
          'penaltiesEnabled': penaltyShootout.value,
          'maxSubs': maxSubs.value,
        },
        status: 'pending',
        engineState: engineState,
        lastUpdatedAt: now,
        createdAt: now,
      );

      // Save to SQLite
      await FootballSqflite.instance.createMatch(newMatch);

      // Save to Firestore
      await FirebaseFirestore.instance.collection('matches').doc(matchId).set(newMatch.toJson());

      // Prepare Controller
      final mainController = Get.put(FootballController());
      mainController.currentMatchId.value = matchId;
      mainController.engine.loadState(engineState);

      // Navigate to Live Scoreboard directly (Bypassing lineup for now to mirror badminton parity)
      Get.offAll(() => FootballScoreboardScreen());

    } catch(e) {
      Get.snackbar('Error', 'Failed to create match: \$e');
    } finally {
      isLoading.value = false;
    }
  }
}
