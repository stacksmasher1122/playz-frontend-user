import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:redesign/model/User_Models/Home_Models/Scoreboard_Model/Pickleball/pickleball_player_model.dart';
import 'package:redesign/theme/app_colors.dart';
import 'package:redesign/view/USER/Home/Scoreboard/Pickleball/final_review/pickleball_final_review_screen.dart';

class PickleballTeamManagementController extends GetxController {
  RxBool isSingles = true.obs;
  RxBool isLoading = false.obs;
  RxList<PickleballPlayerModel> teamAPlayers = <PickleballPlayerModel>[].obs;
  RxList<PickleballPlayerModel> teamBPlayers = <PickleballPlayerModel>[].obs;
  RxInt selectedTeam = 0.obs;
  RxInt selectedSlot = 0.obs;

  int get maxPlayersPerTeam => isSingles.value ? 1 : 2;

  final List<PickleballPlayerModel> _mockPool = [
    PickleballPlayerModel(id: 1, name: "Marcus Vance", club: "Northside Club", rating: "4.5 DUPR", country: "US", image: "https://i.pravatar.cc/150?u=1", gender: "M"),
    PickleballPlayerModel(id: 2, name: "Emily Carter", club: "East Bay Club", rating: "4.2 DUPR", country: "US", image: "https://i.pravatar.cc/150?u=2", gender: "F"),
    PickleballPlayerModel(id: 3, name: "David Wilson", club: "West Tennis", rating: "3.8 DUPR", country: "US", image: "https://i.pravatar.cc/150?u=3", gender: "M"),
    PickleballPlayerModel(id: 4, name: "Sophia Green", club: "Metro Club", rating: "4.7 DUPR", country: "US", image: "https://i.pravatar.cc/150?u=4", gender: "F"),
    PickleballPlayerModel(id: 5, name: "Ryan Scott", club: "City Sports", rating: "4.0 DUPR", country: "US", image: "https://i.pravatar.cc/150?u=5", gender: "M"),
  ];

  int _poolIndex = 1;

  void initialize() {
    teamAPlayers.add(_mockPool[0]);
  }

  void changeMode(bool singles) {
    isSingles.value = singles;
    if (singles) {
      if (teamAPlayers.length > 1) teamAPlayers.removeRange(1, teamAPlayers.length);
      if (teamBPlayers.length > 1) teamBPlayers.removeRange(1, teamBPlayers.length);
    }
  }

  void selectPlayer(int team, int slotIndex) {
    selectedTeam.value = team;
    selectedSlot.value = slotIndex;
  }

  void removePlayer(int team, int index) {
    if (team == 1) {
      if (index < teamAPlayers.length) teamAPlayers.removeAt(index);
    } else {
      if (index < teamBPlayers.length) teamBPlayers.removeAt(index);
    }
  }

  void replacePlayer(int team, int index) {
    selectPlayer(team, index);
  }

  void swapPlayers() {
    var temp = List<PickleballPlayerModel>.from(teamAPlayers);
    teamAPlayers.assignAll(teamBPlayers);
    teamBPlayers.assignAll(temp);
  }

  void addPlayer(int team, PickleballPlayerModel player) {
    if (team == 1 && teamAPlayers.length < maxPlayersPerTeam) {
      teamAPlayers.add(player);
    } else if (team == 2 && teamBPlayers.length < maxPlayersPerTeam) {
      teamBPlayers.add(player);
    }
  }

  void createPlayer() {
    Get.back();
    Get.snackbar("Info", "Create Player Coming Soon", backgroundColor: AppColors.surfaceContainerHigh, colorText: AppColors.primary);
  }

  void selectExistingPlayer(int team, int slot) {
    Get.back();
    if (_poolIndex >= _mockPool.length) _poolIndex = 0;
    addPlayer(team, _mockPool[_poolIndex]);
    _poolIndex++;
  }

  void importTournamentPlayer() {
    Get.back();
    Get.snackbar("Info", "Import Coming Soon", backgroundColor: AppColors.surfaceContainerHigh, colorText: AppColors.primary);
  }

  bool validateTeams() {
    return teamAPlayers.length == maxPlayersPerTeam && teamBPlayers.length == maxPlayersPerTeam;
  }

  void goNext(BuildContext context) {
    if (validateTeams()) {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (_) => const PickleballFinalReviewScreen()),
      );
    } else {
      // Bypass validation for UI phase
      Navigator.push(
        context,
        MaterialPageRoute(builder: (_) => const PickleballFinalReviewScreen()),
      );
    }
  }

  void resetTeams() {
    teamAPlayers.clear();
    teamBPlayers.clear();
    isSingles.value = true;
  }

  void disposeResources() {
  }
}
