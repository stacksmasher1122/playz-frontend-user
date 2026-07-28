import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:collection/collection.dart';
import 'package:redesign/theme/app_colors.dart';
import 'package:redesign/model/User_Models/Home_Models/Scoreboard_Model/Volleyball/volleyball_player_model.dart';
import 'package:redesign/model/User_Models/Home_Models/Scoreboard_Model/Volleyball/court_player_model.dart';
import 'package:redesign/model/User_Models/Home_Models/Scoreboard_Model/Volleyball/rotation_model.dart';
import 'package:redesign/controller/User_Controller/Home_Controller/Scoreboard_Controller/Volleyball/volleyball_live_scoring_controller.dart';

class VolleyballRotationSubsController extends GetxController {
  // Reactive Court State (1 -> P1, 2 -> P2, ..., 6 -> P6)
  RxMap<int, CourtPlayerModel> courtPositions = <int, CourtPlayerModel>{}.obs;
  RxList<VolleyballPlayerModel> benchPlayers = <VolleyballPlayerModel>[].obs;
  
  // Track both teams
  RxMap<int, CourtPlayerModel> teamACourt = <int, CourtPlayerModel>{}.obs;
  RxMap<int, CourtPlayerModel> teamBCourt = <int, CourtPlayerModel>{}.obs;
  RxList<VolleyballPlayerModel> teamABench = <VolleyballPlayerModel>[].obs;
  RxList<VolleyballPlayerModel> teamBBench = <VolleyballPlayerModel>[].obs;
  
  RxBool isViewingTeamA = true.obs;
  
  Rx<VolleyballPlayerModel?> servingPlayer = Rx<VolleyballPlayerModel?>(null);
  Rx<VolleyballPlayerModel?> libero = Rx<VolleyballPlayerModel?>(null);
  Rx<VolleyballPlayerModel?> captain = Rx<VolleyballPlayerModel?>(null);

  RxInt rotationNumber = 1.obs;
  RxInt timeoutsUsed = 0.obs;
  RxInt substitutionsUsed = 0.obs;

  RxList<RotationModel> undoStack = <RotationModel>[].obs;
  
  // Match data for header display
  RxString servingTeam = "VALKYRIES VOLLEY".obs;
  RxString receivingTeam = "TITAN SQUAD".obs;
  
  String teamAName = "TEAM A";
  String teamBName = "TEAM B";
  
  int get teamScore => Get.isRegistered<VolleyballLiveScoringController>() 
      ? Get.find<VolleyballLiveScoringController>().teamAScore.value 
      : 21;
      
  int get oppScore => Get.isRegistered<VolleyballLiveScoringController>()
      ? Get.find<VolleyballLiveScoringController>().teamBScore.value
      : 19;
      
  int get currentSet => Get.isRegistered<VolleyballLiveScoringController>()
      ? Get.find<VolleyballLiveScoringController>().currentSet.value
      : 3;

  @override
  void onInit() {
    super.onInit();
    initializeCourt();
  }

  void initializeCourt() {
    bool hasRealData = false;
    try {
      if (Get.isRegistered<VolleyballLiveScoringController>()) {
        var liveController = Get.find<VolleyballLiveScoringController>();
        var teamA = liveController.initialData.teamA;
        var teamB = liveController.initialData.teamB;
        
        teamAName = teamA.teamName;
        teamBName = teamB.teamName;
        
        bool isTeamAServingFirst = liveController.isTeamAServing.value;
        isViewingTeamA.value = isTeamAServingFirst;
        
        servingTeam.value = isTeamAServingFirst ? teamA.teamName : teamB.teamName;
        receivingTeam.value = isTeamAServingFirst ? teamB.teamName : teamA.teamName;
        
        teamACourt.clear();
        teamBCourt.clear();
        teamABench.clear();
        teamBBench.clear();
        
        for (int i = 0; i < teamA.players.length; i++) {
          if (i < 6) {
            teamACourt[i + 1] = CourtPlayerModel(player: teamA.players[i], courtPosition: i + 1, isServing: i == 0);
          } else {
            teamABench.add(teamA.players[i]);
          }
        }
        
        for (int i = 0; i < teamB.players.length; i++) {
          if (i < 6) {
            teamBCourt[i + 1] = CourtPlayerModel(player: teamB.players[i], courtPosition: i + 1, isServing: i == 0);
          } else {
            teamBBench.add(teamB.players[i]);
          }
        }
        
        _updateActiveCourtView();
        hasRealData = true;
      }
    } catch (e) {
      // Fallback if not registered
    }

    if (!hasRealData) {
      // Generate dummy players for court
      for (int i = 1; i <= 6; i++) {
        VolleyballPlayerModel p = VolleyballPlayerModel(id: 'c$i', name: 'Player $i', jerseyNumber: '${10 + i}', position: _getRoleForPos(i));
        teamACourt[i] = CourtPlayerModel(player: p, courtPosition: i, isServing: i == 1);
        teamBCourt[i] = CourtPlayerModel(player: p, courtPosition: i, isServing: i == 1);
      }
      teamABench.value = List.generate(6, (i) => VolleyballPlayerModel(id: 'b$i', name: 'Bench $i', jerseyNumber: '${20 + i}', position: 'Outside Hitter'));
      teamBBench.value = List.generate(6, (i) => VolleyballPlayerModel(id: 'b$i', name: 'Bench $i', jerseyNumber: '${20 + i}', position: 'Outside Hitter'));
      
      _updateActiveCourtView();
    }
    
    _saveStateToUndo();
  }

  void _updateActiveCourtView() {
    if (isViewingTeamA.value) {
      courtPositions.value = Map.from(teamACourt);
      benchPlayers.value = List.from(teamABench);
      servingTeam.value = teamAName;
      receivingTeam.value = teamBName;
    } else {
      courtPositions.value = Map.from(teamBCourt);
      benchPlayers.value = List.from(teamBBench);
      servingTeam.value = teamBName;
      receivingTeam.value = teamAName;
    }
    
    // Find current captain/libero for active team
    var activeTeam = isViewingTeamA.value ? teamACourt : teamBCourt;
    servingPlayer.value = activeTeam.values.firstWhereOrNull((p) => p.isServing)?.player ?? activeTeam[1]?.player;
  }

  String _getRoleForPos(int pos) {
    if (pos == 1) return 'Setter (S)';
    if (pos == 2) return 'Opposite (OPP)';
    if (pos == 3) return 'Middle Blocker (MB)';
    if (pos == 4) return 'Outside Hitter (OH)';
    if (pos == 5) return 'Outside Hitter (OH)';
    if (pos == 6) return 'Libero (L)';
    return 'Player';
  }

  void _saveStateToUndo() {
    undoStack.add(RotationModel(
      courtPositions: Map.from(courtPositions),
      servingPlayer: servingPlayer.value,
      libero: libero.value,
      captain: captain.value,
      rotationCount: rotationNumber.value,
    ));
  }

  void undoLastAction() {
    if (undoStack.length > 1) {
      undoStack.removeLast(); // Pop current state
      RotationModel previous = undoStack.last; // Peek previous state
      
      teamACourt.value = Map.from(previous.courtPositions); // Naive undo, would need more robust tracking for both teams
      _updateActiveCourtView();
      servingPlayer.value = previous.servingPlayer;
      libero.value = previous.libero;
      captain.value = previous.captain;
      rotationNumber.value = previous.rotationCount;
      
      Get.snackbar("Undo", "Restored previous rotation state.", backgroundColor: AppColors.card, colorText: AppColors.accent);
    } else {
      Get.snackbar("Undo", "No previous actions to undo.", backgroundColor: AppColors.error, colorText: AppColors.accent);
    }
  }

  void performSideOut() {
    _saveStateToUndo();
    
    // Switch sides
    isViewingTeamA.value = !isViewingTeamA.value;
    
    var activeCourt = isViewingTeamA.value ? teamACourt : teamBCourt;

    // Rotate clockwise: P1->P6, P6->P5, P5->P4, P4->P3, P3->P2, P2->P1
    if (activeCourt.isNotEmpty && activeCourt.length >= 6) {
      var p1 = activeCourt[1]!.player;
      var p2 = activeCourt[2]!.player;
      var p3 = activeCourt[3]!.player;
      var p4 = activeCourt[4]!.player;
      var p5 = activeCourt[5]!.player;
      var p6 = activeCourt[6]!.player;

      activeCourt[6] = CourtPlayerModel(player: p1, courtPosition: 6);
      activeCourt[5] = CourtPlayerModel(player: p6, courtPosition: 5);
      activeCourt[4] = CourtPlayerModel(player: p5, courtPosition: 4);
      activeCourt[3] = CourtPlayerModel(player: p4, courtPosition: 3);
      activeCourt[2] = CourtPlayerModel(player: p3, courtPosition: 2);
      activeCourt[1] = CourtPlayerModel(player: p2, courtPosition: 1, isServing: true); // New P1 is serving
    }

    rotationNumber.value++;
    _updateActiveCourtView();
    
    Get.snackbar("Side-Out", "Switched to ${servingTeam.value}. Players rotated.", backgroundColor: AppColors.accent, colorText: Colors.black);
  }

  void requestTimeout() {
    if (timeoutsUsed.value >= 2) {
      Get.snackbar("Timeout Limit", "Maximum timeouts (2) already used.", backgroundColor: AppColors.error, colorText: AppColors.accent);
      return;
    }
    timeoutsUsed.value++;
    Get.snackbar("Timeout", "Timeout called. Total used: ${timeoutsUsed.value}/2.", backgroundColor: Colors.orange, colorText: Colors.white);
  }

  void substitutePlayer(int position, VolleyballPlayerModel playerIn) {
    if (substitutionsUsed.value >= 6) {
      Get.snackbar("Substitutions Limit", "Maximum substitutions (6) already used.", backgroundColor: AppColors.error, colorText: AppColors.accent);
      return;
    }

    _saveStateToUndo();

    var playerOut = courtPositions[position]!.player;
    
    // Swap
    benchPlayers.removeWhere((p) => p.id == playerIn.id);
    benchPlayers.add(playerOut);
    
    courtPositions[position] = CourtPlayerModel(
      player: playerIn, 
      courtPosition: position,
      isServing: position == 1,
    );
    
    if (position == 1) servingPlayer.value = playerIn;
    if (captain.value?.id == playerOut.id) captain.value = playerIn;
    if (libero.value?.id == playerOut.id) libero.value = playerIn;

    substitutionsUsed.value++;
    
    Get.snackbar(
      "Substitution", 
      "${playerIn.name} IN, ${playerOut.name} OUT.", 
      backgroundColor: AppColors.accent, 
      colorText: Colors.black
    );
  }
}
