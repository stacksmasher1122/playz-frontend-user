import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:uuid/uuid.dart';

import '../../../model/User_Models/Tournament_Model/player_model.dart';
import '../../../model/User_Models/Tournament_Model/team_model.dart';
import '../../../view/USER/Tournament/create_tournament_review_publish/create_tournament_review_publish_page.dart';

class TeamBuilderController extends GetxController {
  final _uuid = const Uuid();

  // Max teams available based on step 3 Format Setup (dummy 8 for now)
  final int maxTeams = 8;

  // Active teams in the builder
  final RxList<TeamModel> teams = <TeamModel>[].obs;
  
  // To handle the expand/collapse state. null = none expanded
  final RxnString expandedTeamId = RxnString(null);

  // Search logic for the expanded team
  final TextEditingController searchController = TextEditingController();
  final RxString searchQuery = "".obs;

  // Mock Master List of Players to search from
  final List<PlayerModel> masterPlayerList = [
    PlayerModel(
      id: "p1",
      name: "Marcus Rashford",
      jerseyNumber: "10",
      position: "Forward",
      imageUrl: "https://via.placeholder.com/150",
    ),
    PlayerModel(
      id: "p2",
      name: "David De Gea",
      jerseyNumber: "1",
      position: "GK",
      imageUrl: "https://via.placeholder.com/150",
    ),
    PlayerModel(
      id: "p3",
      name: "Lionel Messi",
      jerseyNumber: "10",
      position: "Forward",
      imageUrl: "https://via.placeholder.com/150",
    ),
    PlayerModel(
      id: "p4",
      name: "Kevin De Bruyne",
      jerseyNumber: "17",
      position: "Midfielder",
      imageUrl: "https://via.placeholder.com/150",
    ),
  ];

  @override
  void onInit() {
    super.onInit();
    _loadDummyTeams();

    searchController.addListener(() {
      searchQuery.value = searchController.text.toLowerCase();
    });
  }

  @override
  void onClose() {
    searchController.dispose();
    super.onClose();
  }

  void _loadDummyTeams() {
    teams.addAll([
      TeamModel(
        id: "t1",
        name: "Metro City FC",
        logoUrl: "https://via.placeholder.com/150",
        players: [masterPlayerList[0], masterPlayerList[1]],
      ),
      TeamModel(
        id: "t2",
        name: "Team Beta",
        logoUrl: null, // No logo
        players: [],
      ),
    ]);
  }

  List<PlayerModel> getFilteredPlayers() {
    if (searchQuery.value.isEmpty) return masterPlayerList;
    return masterPlayerList.where((p) => p.name.toLowerCase().contains(searchQuery.value)).toList();
  }

  void toggleExpand(String teamId) {
    if (expandedTeamId.value == teamId) {
      expandedTeamId.value = null; // collapse if already expanded
    } else {
      expandedTeamId.value = teamId;
      searchController.clear(); // Reset search when opening a new team
    }
  }

  void addTeam(String name, String? logoUrl) {
    if (teams.length >= maxTeams) {
      Get.snackbar(
        "Limit Reached",
        "You cannot add more than $maxTeams teams.",
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
      return;
    }
    
    final newTeamId = _uuid.v4();
    teams.add(
      TeamModel(
        id: newTeamId,
        name: name,
        logoUrl: logoUrl,
        players: [],
      ),
    );
    
    // Automatically expand the new team
    toggleExpand(newTeamId);
  }

  void addPlayerToTeam(String teamId, PlayerModel player) {
    final teamIndex = teams.indexWhere((t) => t.id == teamId);
    if (teamIndex != -1) {
      final team = teams[teamIndex];
      // Prevent duplicates
      if (!team.players.any((p) => p.id == player.id)) {
        team.players.add(player);
        teams.refresh();
      } else {
        Get.snackbar("Notice", "Player already in team", snackPosition: SnackPosition.BOTTOM);
      }
    }
  }

  void removePlayerFromTeam(String teamId, String playerId) {
    final teamIndex = teams.indexWhere((t) => t.id == teamId);
    if (teamIndex != -1) {
      teams[teamIndex].players.removeWhere((p) => p.id == playerId);
      teams.refresh();
    }
  }

  void goBack(BuildContext context) {
    Navigator.pop(context);
  }

  void goNext(BuildContext context) {
    if (teams.length < 2) {
      Get.snackbar(
        "Validation Error",
        "You need at least 2 teams to create a tournament.",
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
      return;
    }

    Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => const CreateTournamentReviewPublishPage()),
    );
  }
}
