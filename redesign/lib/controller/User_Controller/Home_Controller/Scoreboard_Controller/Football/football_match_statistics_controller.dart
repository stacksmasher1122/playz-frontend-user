import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../../../model/User_Models/Home_Models/Scoreboard_Model/Football/match_statistics/match_statistics_model.dart';
import '../../../../../../model/User_Models/Home_Models/Scoreboard_Model/Football/team_statistics_model.dart';
import '../../../../../../model/User_Models/Home_Models/Scoreboard_Model/Football/match_statistics/player_statistics_model.dart';

class MomentumPoint {
  final int minute;
  final double advantage; // Positive for home, negative for away

  MomentumPoint(this.minute, this.advantage);
}

class FootballMatchStatisticsController extends GetxController {
  final RxBool isLoading = false.obs;
  final RxString searchQuery = ''.obs;
  
  final RxList<PlayerStatisticsModel> players = <PlayerStatisticsModel>[].obs;
  final RxList<PlayerStatisticsModel> filteredPlayers = <PlayerStatisticsModel>[].obs;
  
  // Late initialization using dummy data for UI phase
  late final Rx<MatchStatisticsModel> match;
  late final Rx<TeamStatisticsModel> homeStatistics;
  late final Rx<TeamStatisticsModel> awayStatistics;
  
  final RxDouble possessionHome = 0.0.obs;
  final RxDouble possessionAway = 0.0.obs;
  final RxList<MomentumPoint> momentumPoints = <MomentumPoint>[].obs;

  @override
  void onInit() {
    super.onInit();
    // Initialize required Rx objects with dummy models to satisfy late init before loading
    match = MatchStatisticsModel(
      matchId: '', matchStatus: '', currentMinute: '', homeScore: 0, awayScore: 0,
      stadium: '', matchTime: '', homeTeam: '', awayTeam: '', homeLogo: '', awayLogo: '',
    ).obs;
    
    homeStatistics = TeamStatisticsModel(
      possession: 0, shots: 0, shotsOnTarget: 0, passes: 0, passAccuracy: 0, corners: 0, interceptions: 0, fouls: 0, yellowCards: 0, redCards: 0, expectedGoals: 0.0, xpPoints: 0.0,
    ).obs;
    
    awayStatistics = TeamStatisticsModel(
      possession: 0, shots: 0, shotsOnTarget: 0, passes: 0, passAccuracy: 0, corners: 0, interceptions: 0, fouls: 0, yellowCards: 0, redCards: 0, expectedGoals: 0.0, xpPoints: 0.0,
    ).obs;
  }

  void initialize() {
    isLoading.value = true;
    Future.delayed(Duration(milliseconds: 800), () {
      loadStatistics();
      loadComparison();
      loadMomentum();
      isLoading.value = false;
      showSuccess('Analytics Loaded');
    });
  }

  void loadStatistics() {
    match.value = MatchStatisticsModel(
      matchId: 'M1',
      matchStatus: 'LIVE',
      currentMinute: '78\'',
      homeScore: 2,
      awayScore: 1,
      stadium: 'ETIHAD STADIUM',
      matchTime: '90:00',
      homeTeam: 'MAN CITY',
      awayTeam: 'ARSENAL',
      homeLogo: 'https://via.placeholder.com/150',
      awayLogo: 'https://via.placeholder.com/150',
    );

    players.assignAll([
      PlayerStatisticsModel(
        playerId: 'P1', playerName: 'Erling Haaland', playerImage: 'https://via.placeholder.com/150',
        jerseyNumber: '9', position: 'CF', minutesPlayed: 78, goals: 1, assists: 0, expectedGoals: 0.84,
        rating: 8.5, yellowCard: false, redCard: false, teamName: 'MAN CITY',
      ),
      PlayerStatisticsModel(
        playerId: 'P2', playerName: 'Kevin De Bruyne', playerImage: 'https://via.placeholder.com/150',
        jerseyNumber: '17', position: 'CAM', minutesPlayed: 78, goals: 0, assists: 1, expectedGoals: 0.32,
        rating: 8.0, yellowCard: false, redCard: false, teamName: 'MAN CITY',
      ),
      PlayerStatisticsModel(
        playerId: 'P3', playerName: 'Martin Ødegaard', playerImage: 'https://via.placeholder.com/150',
        jerseyNumber: '8', position: 'CAM', minutesPlayed: 78, goals: 0, assists: 0, expectedGoals: 0.15,
        rating: 7.2, yellowCard: false, redCard: false, teamName: 'ARSENAL',
      ),
      PlayerStatisticsModel(
        playerId: 'P4', playerName: 'Declan Rice', playerImage: 'https://via.placeholder.com/150',
        jerseyNumber: '41', position: 'CDM', minutesPlayed: 78, goals: 0, assists: 0, expectedGoals: 0.05,
        rating: 6.8, yellowCard: true, redCard: false, teamName: 'ARSENAL',
      ),
    ]);
    
    filteredPlayers.assignAll(players);
  }

  void refreshStatistics() {
    isLoading.value = true;
    Future.delayed(Duration(milliseconds: 500), () {
      isLoading.value = false;
      showSuccess('Refresh Completed');
    });
  }

  void searchPlayers(String query) {
    searchQuery.value = query;
    filterPlayers();
  }

  void filterPlayers() {
    if (searchQuery.value.isEmpty) {
      filteredPlayers.assignAll(players);
    } else {
      filteredPlayers.assignAll(players.where((p) => 
        p.playerName.toLowerCase().contains(searchQuery.value.toLowerCase())));
    }
  }

  void sortPlayers() {
    // Basic sorting stub
  }

  void loadMomentum() {
    momentumPoints.assignAll([
      MomentumPoint(0, 0),
      MomentumPoint(10, 20),
      MomentumPoint(20, 50),
      MomentumPoint(30, -10),
      MomentumPoint(40, 10),
      MomentumPoint(50, -30),
      MomentumPoint(60, -50),
      MomentumPoint(70, 80), // Goal spike
      MomentumPoint(78, 60),
    ]);
  }

  void loadComparison() {
    homeStatistics.value = TeamStatisticsModel(
      possession: 62, shots: 14, shotsOnTarget: 8, passes: 512, passAccuracy: 85, corners: 9, interceptions: 10, fouls: 12, yellowCards: 1, redCards: 0, expectedGoals: 2.1, xpPoints: 2.1,
    );
    awayStatistics.value = TeamStatisticsModel(
      possession: 38, shots: 6, shotsOnTarget: 3, passes: 324, passAccuracy: 75, corners: 4, interceptions: 6, fouls: 15, yellowCards: 3, redCards: 0, expectedGoals: 0.9, xpPoints: 1.2,
    );
    
    possessionHome.value = homeStatistics.value.possession.toDouble();
    possessionAway.value = awayStatistics.value.possession.toDouble();
  }

  void openPlayerProfile(PlayerStatisticsModel player) {
    // Action stub
  }

  void openFullAnalytics() {
    // Action stub
    showSuccess('Opening Full Analytics...');
  }

  void showSuccess(String message) {
    Get.snackbar(
      '',
      message,
      titleText: SizedBox.shrink(),
      messageText: Text(
        message,
        style: TextStyle(color: Colors.black, fontSize: 16, fontWeight: FontWeight.bold),
      ),
      backgroundColor: Color(0xFFC6FF00),
      colorText: Colors.black,
      snackPosition: SnackPosition.TOP,
      margin: EdgeInsets.all(16),
      duration: Duration(seconds: 2),
    );
  }

  void showError(String message) {
    Get.snackbar(
      '',
      message,
      titleText: SizedBox.shrink(),
      messageText: Text(
        message,
        style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold),
      ),
      backgroundColor: Colors.red.shade900,
      snackPosition: SnackPosition.TOP,
      margin: EdgeInsets.all(16),
    );
  }
}




