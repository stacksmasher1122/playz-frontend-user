import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:redesign/theme/app_colors.dart';
import 'package:redesign/model/User_Models/Home_Models/Scoreboard_Model/Volleyball/volleyball_player_model.dart';
import 'package:redesign/model/User_Models/Home_Models/Scoreboard_Model/Volleyball/volleyball_team_model.dart';
import 'package:redesign/view/USER/Home/Scoreboard/Volleyball/final_review/volleyball_final_review_screen.dart';

class TeamLineupState {
  RxList<VolleyballPlayerModel> availablePlayers = <VolleyballPlayerModel>[].obs;
  RxMap<int, VolleyballPlayerModel?> courtPlayers = <int, VolleyballPlayerModel?>{
    1: null, 2: null, 3: null, 4: null, 5: null, 6: null,
  }.obs;
  Rx<VolleyballPlayerModel?> captain = Rx<VolleyballPlayerModel?>(null);
  Rx<VolleyballPlayerModel?> libero = Rx<VolleyballPlayerModel?>(null);
  RxBool lineupReady = false.obs;
}

class VolleyballStartingLineupController extends GetxController {
  late VolleyballTeamModel teamA;
  late VolleyballTeamModel teamB;

  RxBool isTeamAActive = true.obs;

  final TeamLineupState stateA = TeamLineupState();
  final TeamLineupState stateB = TeamLineupState();

  TeamLineupState get currentState => isTeamAActive.value ? stateA : stateB;
  VolleyballTeamModel get currentTeam => isTeamAActive.value ? teamA : teamB;

  void initializeWithTeams(VolleyballTeamModel a, VolleyballTeamModel b) {
    teamA = a;
    teamB = b;
    
    stateA.availablePlayers.value = List.from(a.players);
    stateB.availablePlayers.value = List.from(b.players);
    
    _updateRolesFromAvailable(stateA);
    _updateRolesFromAvailable(stateB);
  }

  void toggleTeam(bool isTeamA) {
    isTeamAActive.value = isTeamA;
  }

  void _updateRolesFromAvailable(TeamLineupState state) {
    state.captain.value = state.availablePlayers.firstWhereOrNull((p) => p.isCaptain);
    state.libero.value = state.availablePlayers.firstWhereOrNull((p) => p.isLibero);
  }

  void assignPlayer(int position, VolleyballPlayerModel player) {
    if (currentState.courtPlayers.containsValue(player)) {
      int prevPos = currentState.courtPlayers.keys.firstWhere((k) => currentState.courtPlayers[k] == player);
      currentState.courtPlayers[prevPos] = null;
    }
    currentState.courtPlayers[position] = player;
    validateLineup(currentState);
  }

  void removePlayer(int position) {
    currentState.courtPlayers[position] = null;
    validateLineup(currentState);
  }

  void selectCaptain(String playerId) {
    _updatePlayerRole(playerId, isCaptain: true);
    Get.snackbar("Success", "Captain assigned.", backgroundColor: AppColors.primaryContainer, colorText: Colors.black);
  }

  void selectLibero(String playerId) {
    _updatePlayerRole(playerId, isLibero: true);
    Get.snackbar("Success", "Libero assigned.", backgroundColor: AppColors.primaryContainer, colorText: Colors.black);
  }

  void _updatePlayerRole(String playerId, {bool? isCaptain, bool? isLibero}) {
    int index = currentState.availablePlayers.indexWhere((p) => p.id == playerId);
    if (index != -1) {
      if (isCaptain == true) {
        for (int i = 0; i < currentState.availablePlayers.length; i++) {
          currentState.availablePlayers[i] = currentState.availablePlayers[i].copyWith(isCaptain: false);
        }
      }
      if (isLibero == true) {
        for (int i = 0; i < currentState.availablePlayers.length; i++) {
          currentState.availablePlayers[i] = currentState.availablePlayers[i].copyWith(isLibero: false);
        }
      }

      currentState.availablePlayers[index] = currentState.availablePlayers[index].copyWith(
        isCaptain: isCaptain ?? currentState.availablePlayers[index].isCaptain,
        isLibero: isLibero ?? currentState.availablePlayers[index].isLibero,
      );

      for (var entry in currentState.courtPlayers.entries) {
        if (entry.value?.id == playerId) {
          currentState.courtPlayers[entry.key] = currentState.availablePlayers[index];
        } else if (entry.value != null) {
          if (isCaptain == true && entry.value!.isCaptain) {
            currentState.courtPlayers[entry.key] = entry.value!.copyWith(isCaptain: false);
          }
          if (isLibero == true && entry.value!.isLibero) {
            currentState.courtPlayers[entry.key] = entry.value!.copyWith(isLibero: false);
          }
        }
      }

      _updateRolesFromAvailable(currentState);
      validateLineup(currentState);
    }
  }

  void validateLineup(TeamLineupState state) {
    bool hasSix = state.courtPlayers.values.where((p) => p != null).length == 6;
    bool hasCaptain = state.captain.value != null;
    bool hasLibero = state.libero.value != null;
    state.lineupReady.value = hasSix && hasCaptain && hasLibero;
  }

  void confirmLineup(BuildContext context) {
    // BYPASSED VALIDATION AS REQUESTED FOR TESTING
    Get.snackbar("Success", "Lineup confirmed! Proceeding to final review...", backgroundColor: AppColors.primaryContainer, colorText: Colors.black);
    Navigator.push(context, MaterialPageRoute(builder: (_) => VolleyballFinalReviewScreen(teamA: teamA, teamB: teamB)));
  }
}
