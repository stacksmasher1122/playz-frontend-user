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
import '../../../../../shared_preferences/userPreferences.dart';

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

  // Format & Rules Rx state
  final RxInt maxAllowedPlayers = 11.obs;
  final RxBool subsEnabled = true.obs;
  final RxInt maxSubs = 5.obs;
  final RxBool allowProRules = false.obs;
  final RxDouble duration = 45.0.obs; // Half duration
  final RxBool extraTime = false.obs;
  final RxBool penaltyShootout = false.obs;

  // Teams & Friends
  final TextEditingController homeTeamController = TextEditingController(text: 'Home FC');
  final TextEditingController awayTeamController = TextEditingController(text: 'Away United');
  final RxString homeTeamName = 'Home FC'.obs;
  final RxString awayTeamName = 'Away United'.obs;

  final RxList<String> homeTeamPlayers = <String>[].obs;
  final RxList<String> awayTeamPlayers = <String>[].obs;
  
  final RxList<FriendModel> homeTeamRoster = <FriendModel>[].obs;
  final RxList<FriendModel> awayTeamRoster = <FriendModel>[].obs;

  final Rx<FriendModel?> currentUserFriendModel = Rx<FriendModel?>(null);

  void incrementDuration() {
    if (duration.value < 180) duration.value += 5;
  }

  void decrementDuration() {
    if (duration.value > 5) duration.value -= 5;
  }

  void setDuration(int mins) {
    duration.value = mins.toDouble();
  }

  void selectMatchFormat(String format) {
    if (format == '11v11') {
      maxAllowedPlayers.value = 11;
    } else if (format == '7v7') {
      maxAllowedPlayers.value = 7;
    } else if (format == '5v5') {
      maxAllowedPlayers.value = 5;
    }
  }

  void incrementSquadLimit() {
    if (maxAllowedPlayers.value < 11) maxAllowedPlayers.value++;
  }

  void decrementSquadLimit() {
    if (maxAllowedPlayers.value > 1) maxAllowedPlayers.value--;
  }

  void toggleSubs(bool val) {
    subsEnabled.value = val;
  }

  void incrementSubs() {
    if (maxSubs.value < 11) maxSubs.value++;
  }

  void decrementSubs() {
    if (maxSubs.value > 0) maxSubs.value--;
  }

  void toggleProRules(bool val) {
    allowProRules.value = val;
  }

  void updateDuration(double val) {
    duration.value = val;
  }

  void increaseHalves() {
    if (halves.value < 2) halves.value++;
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

  @override
  void onInit() {
    super.onInit();
    homeTeamController.addListener(() {
      homeTeamName.value = homeTeamController.text.trim();
    });
    awayTeamController.addListener(() {
      awayTeamName.value = awayTeamController.text.trim();
    });
    _loadCurrentUserProfile();
  }

  @override
  void onClose() {
    homeTeamController.dispose();
    awayTeamController.dispose();
    super.onClose();
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
        final docId = await UserPreferences.getDocId() ?? user.email ?? user.uid;
        final doc = await FirebaseFirestore.instance.collection('User').doc(docId).get();
        if (doc.exists) {
          currentUserFriendModel.value = FriendModel.fromMap(doc.data() as Map<String, dynamic>);
        }
      }
    } catch (e) {
      debugPrint("Error loading profile: $e");
    }
  }

  void updateFormat(String format, int players) {
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

  Future<void> createMatchAndStart(BuildContext context, {String? tossWinner, String? tossDecision}) async {
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
          'allowProRules': allowProRules.value,
          'halfDurationMinutes': duration.value.toInt(),
          'extraTimeEnabled': allowProRules.value ? extraTime.value : false,
          'penaltiesEnabled': allowProRules.value ? penaltyShootout.value : false,
          'maxSubs': subsEnabled.value ? maxSubs.value : 0,
          'tossWinner': tossWinner ?? homeTeamName.value,
          'tossDecision': tossDecision ?? 'kickoff',
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
      final mainController = Get.isRegistered<FootballController>()
          ? Get.find<FootballController>()
          : Get.put(FootballController());
          
      mainController.restoreFootballMatchFromSqflite(newMatch);

      // Navigate to Live Scoreboard directly via Navigator
      if (context.mounted) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (_) => FootballScoreboardScreen()),
        );
      } else {
        Get.offAll(() => FootballScoreboardScreen());
      }

    } catch(e) {
      Get.snackbar('Error', 'Failed to create match: $e');
    } finally {
      isLoading.value = false;
    }
  }
}
