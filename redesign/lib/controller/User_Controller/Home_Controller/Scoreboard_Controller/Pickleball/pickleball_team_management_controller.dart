import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:redesign/model/User_Models/Home_Models/Scoreboard_Model/Pickleball/pickleball_player_model.dart';
import 'package:redesign/theme/app_colors.dart';
import 'package:redesign/theme/app_typography.dart';
import 'package:redesign/view/USER/Home/Scoreboard/Pickleball/live_match/pickleball_scoreboard_screen.dart';
import 'package:redesign/controller/User_Controller/Home_Controller/Scoreboard_Controller/Pickleball/pickleball_initialize_match_controller.dart';

class PickleballTeamManagementController extends GetxController {
  RxBool isSingles = true.obs;
  RxBool isLoading = false.obs;
  RxList<PickleballPlayerModel> teamAPlayers = <PickleballPlayerModel>[].obs;
  RxList<PickleballPlayerModel> teamBPlayers = <PickleballPlayerModel>[].obs;
  RxInt selectedTeam = 0.obs;
  RxInt selectedSlot = 0.obs;

  int get maxPlayersPerTeam => isSingles.value ? 1 : 2;

  PickleballInitializeMatchController? get initController {
    try {
      return Get.find<PickleballInitializeMatchController>();
    } catch (_) {
      return null;
    }
  }

  // Head-to-Head Mock Data
  RxInt h2hWinsA = 12.obs;
  RxInt h2hWinsB = 8.obs;
  RxString avgMatchDuration = "45m".obs;
  RxString avgPoints = "22.5".obs;
  RxString lastWinner = "Marcus Vance".obs;

  bool get isTeamAReady => teamAPlayers.length == maxPlayersPerTeam;
  bool get isTeamBReady => teamBPlayers.length == maxPlayersPerTeam;
  bool get isMatchReady => isTeamAReady && isTeamBReady;

  final List<PickleballPlayerModel> _mockPool = [
    PickleballPlayerModel(
      id: 1,
      name: "Marcus Vance",
      club: "Northside Club",
      rating: "4.5 DUPR",
      country: "US",
      image: "https://i.pravatar.cc/150?u=1",
      gender: "M",
    ),
    PickleballPlayerModel(
      id: 2,
      name: "Emily Carter",
      club: "East Bay Club",
      rating: "4.2 DUPR",
      country: "US",
      image: "https://i.pravatar.cc/150?u=2",
      gender: "F",
    ),
    PickleballPlayerModel(
      id: 3,
      name: "David Wilson",
      club: "West Tennis",
      rating: "3.8 DUPR",
      country: "US",
      image: "https://i.pravatar.cc/150?u=3",
      gender: "M",
    ),
    PickleballPlayerModel(
      id: 4,
      name: "Sophia Green",
      club: "Metro Club",
      rating: "4.7 DUPR",
      country: "US",
      image: "https://i.pravatar.cc/150?u=4",
      gender: "F",
    ),
    PickleballPlayerModel(
      id: 5,
      name: "Ryan Scott",
      club: "City Sports",
      rating: "4.0 DUPR",
      country: "US",
      image: "https://i.pravatar.cc/150?u=5",
      gender: "M",
    ),
  ];

  int _poolIndex = 1;

  void initialize() {
    // Start with completely empty teams
  }

  void changeMode(bool singles) {
    isSingles.value = singles;
    if (singles) {
      if (teamAPlayers.length > 1) {
        teamAPlayers.removeRange(1, teamAPlayers.length);
      }
      if (teamBPlayers.length > 1) {
        teamBPlayers.removeRange(1, teamBPlayers.length);
      }
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

  void createPlayer(BuildContext context, {int? defaultTeam}) {
    int teamToAssign = defaultTeam ?? selectedTeam.value;
    if (teamToAssign == 0) teamToAssign = 1;

    TextEditingController nameController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          backgroundColor: AppColors.card,
          title: Text("Create New Player", style: AppTypography.headlineSm.copyWith(color: AppColors.onPrimary)),
          content: TextField(
            controller: nameController,
            style: TextStyle(color: Colors.white),
            decoration: InputDecoration(
              hintText: "Enter player name",
              hintStyle: TextStyle(color: Colors.grey),
              enabledBorder: OutlineInputBorder(borderSide: BorderSide(color: AppColors.muted)),
              focusedBorder: OutlineInputBorder(borderSide: BorderSide(color: AppColors.accent)),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text("Cancel", style: TextStyle(color: Colors.grey)),
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(backgroundColor: AppColors.accent),
              onPressed: () {
                if (nameController.text.isNotEmpty) {
                  addPlayer(teamToAssign, PickleballPlayerModel(
                    id: DateTime.now().millisecondsSinceEpoch,
                    name: nameController.text,
                    club: "Independent",
                    rating: "Unrated",
                    country: "US",
                    image: "",
                    gender: "U"
                  ));
                }
                Navigator.pop(context); // Close dialog
                if (Navigator.canPop(context) && Get.isBottomSheetOpen == true) {
                    Get.back(); // Close bottom sheet if open
                }
              },
              child: Text("Add Player", style: TextStyle(color: Colors.black)),
            ),
          ],
        );
      }
    );
  }

  void selectExistingPlayer(BuildContext context, int team, int slot) {
    if (Get.isBottomSheetOpen == true) {
      Get.back();
    }
    if (_poolIndex >= _mockPool.length) _poolIndex = 0;
    addPlayer(team, _mockPool[_poolIndex]);
    _poolIndex++;
  }

  void importTournamentPlayer() {
    Get.snackbar(
      "Info",
      "Import Coming Soon",
      backgroundColor: AppColors.card,
      colorText: AppColors.accent,
    );
  }

  bool validateTeams() {
    return teamAPlayers.length == maxPlayersPerTeam &&
        teamBPlayers.length == maxPlayersPerTeam;
  }

  void goNext(BuildContext context) {
    if (isMatchReady) {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (_) => const PickleballScoreboardScreen()),
      );
    } else {
      Get.snackbar(
        "Match Not Ready",
        "Please select players for both teams before starting the match.",
        backgroundColor: AppColors.error,
        colorText: AppColors.onPrimary,
      );
    }
  }

  void resetTeams() {
    teamAPlayers.clear();
    teamBPlayers.clear();
    isSingles.value = true;
  }

  void disposeResources() {}
}
