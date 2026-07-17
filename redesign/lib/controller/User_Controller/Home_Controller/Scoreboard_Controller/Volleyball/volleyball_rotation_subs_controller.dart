import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:redesign/theme/app_colors.dart';
import 'package:redesign/model/User_Models/Home_Models/Scoreboard_Model/Volleyball/volleyball_player_model.dart';
import 'package:redesign/model/User_Models/Home_Models/Scoreboard_Model/Volleyball/court_player_model.dart';
import 'package:redesign/model/User_Models/Home_Models/Scoreboard_Model/Volleyball/rotation_model.dart';
import 'package:redesign/model/User_Models/Home_Models/Scoreboard_Model/Volleyball/substitution_model.dart';

class VolleyballRotationSubsController extends GetxController {
  // Reactive Court State (1 -> P1, 2 -> P2, ..., 6 -> P6)
  RxMap<int, CourtPlayerModel> courtPositions = <int, CourtPlayerModel>{}.obs;
  RxList<VolleyballPlayerModel> benchPlayers = <VolleyballPlayerModel>[].obs;
  
  Rx<VolleyballPlayerModel?> servingPlayer = Rx<VolleyballPlayerModel?>(null);
  Rx<VolleyballPlayerModel?> libero = Rx<VolleyballPlayerModel?>(null);
  Rx<VolleyballPlayerModel?> captain = Rx<VolleyballPlayerModel?>(null);

  RxInt rotationNumber = 1.obs;
  RxInt timeoutsUsed = 0.obs;
  RxInt substitutionsUsed = 0.obs;

  RxList<RotationModel> undoStack = <RotationModel>[].obs;
  
  // Example dummy match data just for the header display
  String servingTeam = "VALKYRIES VOLLEY";
  String receivingTeam = "TITAN SQUAD";
  int teamScore = 21;
  int oppScore = 19;
  int currentSet = 3;

  @override
  void onInit() {
    super.onInit();
    initializeCourt();
  }

  void initializeCourt() {
    // Generate dummy players for court
    for (int i = 1; i <= 6; i++) {
      VolleyballPlayerModel p = VolleyballPlayerModel(
        id: 'c$i',
        name: 'Player $i',
        jerseyNumber: '${10 + i}',
        position: _getRoleForPos(i),
      );
      courtPositions[i] = CourtPlayerModel(player: p, courtPosition: i, isServing: i == 1);
      
      if (i == 1) servingPlayer.value = p;
      if (i == 2) captain.value = p;
      if (i == 6) libero.value = p;
    }

    // Generate bench players
    benchPlayers.value = List.generate(6, (i) => VolleyballPlayerModel(
      id: 'b$i',
      name: 'Bench $i',
      jerseyNumber: '${20 + i}',
      position: 'Outside Hitter',
    ));
    
    _saveStateToUndo();
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
      
      courtPositions.value = Map.from(previous.courtPositions);
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

    // Rotate clockwise: P1->P6, P6->P5, P5->P4, P4->P3, P3->P2, P2->P1
    var p1 = courtPositions[1]!.player;
    var p2 = courtPositions[2]!.player;
    var p3 = courtPositions[3]!.player;
    var p4 = courtPositions[4]!.player;
    var p5 = courtPositions[5]!.player;
    var p6 = courtPositions[6]!.player;

    courtPositions[6] = CourtPlayerModel(player: p1, courtPosition: 6);
    courtPositions[5] = CourtPlayerModel(player: p6, courtPosition: 5);
    courtPositions[4] = CourtPlayerModel(player: p5, courtPosition: 4);
    courtPositions[3] = CourtPlayerModel(player: p4, courtPosition: 3);
    courtPositions[2] = CourtPlayerModel(player: p3, courtPosition: 2);
    courtPositions[1] = CourtPlayerModel(player: p2, courtPosition: 1, isServing: true); // New P1 is serving

    servingPlayer.value = p2;
    rotationNumber.value++;
    
    Get.snackbar("Side-Out", "Rotated successfully. Player ${p2.jerseyNumber} is now serving.", backgroundColor: AppColors.accent, colorText: Colors.black);
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
