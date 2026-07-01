import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../../../model/User_Models/Home_Models/Scoreboard_Model/Football/team_management/team_model.dart';
import '../../../../../../model/User_Models/Home_Models/Scoreboard_Model/Football/team_management/player_model.dart';
import '../../../../../../model/User_Models/Home_Models/Scoreboard_Model/Football/team_management/player_statistics_model.dart';

class FootballTeamManagementController extends GetxController {
  final RxBool isLoading = false.obs;
  final RxString searchText = ''.obs;
  final RxInt selectedFilter = 0.obs;
  
  final RxList<PlayerModel> players = <PlayerModel>[].obs;
  final RxList<PlayerModel> filteredPlayers = <PlayerModel>[].obs;
  
  final Rx<TeamModel?> team = Rx<TeamModel?>(null);
  final Rx<PlayerModel?> selectedPlayer = Rx<PlayerModel?>(null);

  void initialize() {
    isLoading.value = true;
    Future.delayed(const Duration(milliseconds: 600), () {
      loadTeam();
      loadPlayers();
      refreshRoster();
      isLoading.value = false;
    });
  }

  void loadTeam() {
    team.value = TeamModel(
      teamId: 'T1',
      teamName: 'SCORPION UNITED FC',
      clubLogo: 'https://images.unsplash.com/photo-1570295999919-56ceb5ecca61?q=80&w=150&auto=format&fit=crop', // placeholder
      division: 'PRO LICENSE DIVISION',
      stadiumName: 'Obsidian Arena',
      headCoach: 'Julian Draxler',
      rosterCount: 24,
      createdDate: DateTime.now(),
    );
  }

  void loadPlayers() {
    players.assignAll([
      PlayerModel(
        playerId: 'P1',
        playerName: 'Marcus Vane',
        playerNumber: '10',
        playerImage: 'https://images.unsplash.com/photo-1570295999919-56ceb5ecca61?q=80&w=150&auto=format&fit=crop',
        position: 'FWD / ATTACKING MID',
        captain: true,
        fitness: 'FIT',
        rating: 9.0,
        form: 'Good',
        statistics: const PlayerStatisticsModel(goals: 12, assists: 8),
      ),
      PlayerModel(
        playerId: 'P2',
        playerName: 'Elias Thorne',
        playerNumber: '4',
        playerImage: 'https://images.unsplash.com/photo-1570295999919-56ceb5ecca61?q=80&w=150&auto=format&fit=crop',
        position: 'DEF / CENTER BACK',
        captain: false,
        fitness: 'FIT',
        rating: 8.5,
        statistics: const PlayerStatisticsModel(tackles: 4.2, passAccuracy: 89),
      ),
      PlayerModel(
        playerId: 'P3',
        playerName: 'Kasper H.',
        playerNumber: '1',
        playerImage: 'https://images.unsplash.com/photo-1570295999919-56ceb5ecca61?q=80&w=150&auto=format&fit=crop',
        position: 'GK / GOALKEEPER',
        captain: false,
        fitness: 'FIT',
        rating: 8.2,
        statistics: const PlayerStatisticsModel(saves: 12, cleanSheets: 3, recovery: 72),
      ),
      PlayerModel(
        playerId: 'P4',
        playerName: 'Leo Rossi',
        playerNumber: '21',
        playerImage: 'https://images.unsplash.com/photo-1570295999919-56ceb5ecca61?q=80&w=150&auto=format&fit=crop',
        position: 'MID / BOX-TO-BOX',
        captain: false,
        fitness: 'FIT',
        rating: 7.8,
        statistics: const PlayerStatisticsModel(distance: 11.4, sprints: 42),
      ),
    ]);
  }

  void refreshRoster() {
    filterPlayers();
  }

  void searchPlayer(String query) {
    searchText.value = query;
    filterPlayers();
  }

  void filterPlayers() {
    // Simple filter based on search text for now
    if (searchText.value.isEmpty) {
      filteredPlayers.assignAll(players);
    } else {
      filteredPlayers.assignAll(players.where((p) =>
          p.playerName.toLowerCase().contains(searchText.value.toLowerCase())));
    }
    sortPlayers(); // re-apply sort
  }

  void sortPlayers() {
    // Stub for sort logic based on selectedFilter
    // Alphabetical, Rating, Goals, etc.
  }

  void selectPlayer(PlayerModel player) {
    selectedPlayer.value = player;
  }

  void removePlayer(PlayerModel player) {
    players.removeWhere((p) => p.playerId == player.playerId);
    refreshRoster();
    showSuccess('${player.playerName} removed from roster');
  }

  void updateFitness(PlayerModel player, String newFitness) {
    int index = players.indexWhere((p) => p.playerId == player.playerId);
    if (index != -1) {
      players[index] = players[index].copyWith(fitness: newFitness);
      refreshRoster();
      showSuccess('Fitness updated');
    }
  }

  void assignCaptain(PlayerModel newCaptain) {
    for (int i = 0; i < players.length; i++) {
      players[i] = players[i].copyWith(captain: players[i].playerId == newCaptain.playerId);
    }
    refreshRoster();
    showSuccess('${newCaptain.playerName} is now the Captain');
  }

  void bulkImport() {
    showSuccess('Bulk import started');
  }

  void addNewPlayer() {
    showSuccess('Add new prospect clicked');
  }

  void showPlayerMenu(PlayerModel player) {
    // Action called by view to open a bottom sheet, handled by UI,
    // but can prep state here.
  }

  void showSuccess(String message) {
    Get.snackbar(
      '',
      message,
      titleText: const SizedBox.shrink(),
      messageText: Text(
        message,
        style: const TextStyle(color: Colors.black, fontSize: 16, fontWeight: FontWeight.bold),
      ),
      backgroundColor: const Color(0xFFC6FF00),
      colorText: Colors.black,
      snackPosition: SnackPosition.TOP,
      margin: const EdgeInsets.all(16),
      duration: const Duration(seconds: 2),
    );
  }

  void showError(String message) {
    Get.snackbar(
      '',
      message,
      titleText: const SizedBox.shrink(),
      messageText: Text(
        message,
        style: const TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold),
      ),
      backgroundColor: Colors.red.shade900,
      snackPosition: SnackPosition.TOP,
      margin: const EdgeInsets.all(16),
    );
  }
}
