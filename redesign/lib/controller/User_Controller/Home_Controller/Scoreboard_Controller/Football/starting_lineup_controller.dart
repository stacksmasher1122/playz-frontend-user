import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../../../model/User_Models/Home_Models/Scoreboard_Model/Football/player_model.dart';
import '../../../../../../model/User_Models/Home_Models/Scoreboard_Model/Football/formation_model.dart';
import '../../../../../../view/USER/Home/Scoreboard/Football/kickoff_setup/kickoff_setup_screen.dart';

class StartingLineupController extends GetxController {
  final RxBool isLoading = false.obs;

  final RxString selectedFormation = '4-3-3'.obs;
  final RxList<String> formations = ['4-3-3', '4-4-2', '4-2-3-1', '3-5-2', '5-3-2'].obs;
  
  final RxList<PlayerModel> pitchPlayers = <PlayerModel>[].obs;
  final Rx<PlayerModel?> goalkeeper = Rx<PlayerModel?>(null);
  
  final RxList<PlayerModel> squadPlayers = <PlayerModel>[].obs;
  final RxString searchQuery = ''.obs;
  final RxInt matchWeek = 34.obs;
  final RxBool isFormationValid = false.obs;

  final Rx<FormationModel?> currentFormation = Rx<FormationModel?>(null);

  final List<PlayerModel> _mockAllSquad = [
    const PlayerModel(id: 'p1', name: 'Rodrygo Goes', jerseyNumber: '11', position: 'RW/LW', overall: 94, fitness: '94 PACE', availability: 'fit', form: '🔥'),
    const PlayerModel(id: 'p2', name: 'Jude Bellingham', jerseyNumber: '5', position: 'CAM/CM', overall: 88, fitness: '88 PHY', availability: 'fit', form: '⭐'),
    const PlayerModel(id: 'p3', name: 'David Alaba', jerseyNumber: '4', position: 'CB/LB', overall: 85, fitness: 'INJURED', availability: 'out', form: '', returnWeeks: '2w', isLocked: true),
    const PlayerModel(id: 'p4', name: 'Luka Modric', jerseyNumber: '10', position: 'CM', overall: 91, fitness: '91 PAS', availability: 'fit', form: '📈'),
    const PlayerModel(id: 'p5', name: 'Vini Jr', jerseyNumber: '7', position: 'LW', overall: 96, fitness: '96 PACE', availability: 'fit', form: '🔥'),
    const PlayerModel(id: 'p6', name: 'Mbappé', jerseyNumber: '9', position: 'ST', overall: 97, fitness: '97 SHO', availability: 'fit', form: '⭐'),
    const PlayerModel(id: 'p7', name: 'Valverde', jerseyNumber: '15', position: 'CM', overall: 89, fitness: '90 PHY', availability: 'fit', form: '🔥'),
    const PlayerModel(id: 'p8', name: 'Courtois', jerseyNumber: '1', position: 'GK', overall: 90, fitness: '90 REF', availability: 'fit', form: '⭐', isGoalkeeper: true),
  ];

  void initialize() {
    Future.microtask(() => isLoading.value = true);
    Future.delayed(const Duration(milliseconds: 500), () {
      loadPlayers();
      loadFormation();
      
      // Preset players per prompt:
      // Forward line: Vini Jr (LW) / Mbappé (ST) / Rodrygo (RW, empty image=dark placeholder)
      // Mid line: Bellingham (CM) / [EMPTY] / Valverde (CM)
      // GK: Courtois
      
      final currentPos = currentFormation.value!.positions.toList();
      
      // We know 4-3-3 has standard labels. Let's pre-assign some mock slots.
      // 0: LW, 1: ST, 2: RW, 3: LCM, 4: CM, 5: RCM, 6: LB, 7: LCB, 8: RCB, 9: RB
      _assignMock(currentPos, 'LW', 'p5'); // Vini
      _assignMock(currentPos, 'ST', 'p6'); // Mbappe
      _assignMock(currentPos, 'RW', 'p1'); // Rodrygo
      _assignMock(currentPos, 'LCM', 'p2'); // Bellingham
      _assignMock(currentPos, 'RCM', 'p7'); // Valverde
      
      currentFormation.value = currentFormation.value!.copyWith(positions: currentPos);
      
      // Remove assigned players from squadPlayers list
      final assignedIds = currentPos.map((e) => e.assignedPlayerId).whereType<String>().toSet();
      squadPlayers.removeWhere((p) => assignedIds.contains(p.id));
      
      goalkeeper.value = _mockAllSquad.firstWhere((p) => p.id == 'p8');
      
      validateFormation();
      isLoading.value = false;
    });
  }

  void _assignMock(List<PositionSlot> slots, String label, String playerId) {
    final idx = slots.indexWhere((s) => s.label == label);
    if (idx != -1) {
      slots[idx] = slots[idx].copyWith(assignedPlayerId: playerId);
    }
  }

  void loadPlayers() {
    squadPlayers.assignAll(_mockAllSquad.where((p) => p.id != 'p8')); // skip GK
  }

  void loadFormation() {
    if (selectedFormation.value == '4-3-3') {
      currentFormation.value = const FormationModel(
        id: '1',
        name: '4-3-3',
        positions: [
          PositionSlot(label: 'LW', x: 0.2, y: 0.15),
          PositionSlot(label: 'ST', x: 0.5, y: 0.1),
          PositionSlot(label: 'RW', x: 0.8, y: 0.15),
          PositionSlot(label: 'LCM', x: 0.25, y: 0.4),
          PositionSlot(label: 'CM', x: 0.5, y: 0.45),
          PositionSlot(label: 'RCM', x: 0.75, y: 0.4),
          PositionSlot(label: 'LB', x: 0.15, y: 0.7),
          PositionSlot(label: 'LCB', x: 0.38, y: 0.75),
          PositionSlot(label: 'RCB', x: 0.62, y: 0.75),
          PositionSlot(label: 'RB', x: 0.85, y: 0.7),
        ],
      );
    } else {
      // Mock fallback for other formations
      currentFormation.value = FormationModel(
        id: '2',
        name: selectedFormation.value,
        positions: [
          const PositionSlot(label: 'FW1', x: 0.3, y: 0.15),
          const PositionSlot(label: 'FW2', x: 0.7, y: 0.15),
          const PositionSlot(label: 'M1', x: 0.2, y: 0.4),
          const PositionSlot(label: 'M2', x: 0.5, y: 0.45),
          const PositionSlot(label: 'M3', x: 0.8, y: 0.4),
          const PositionSlot(label: 'D1', x: 0.1, y: 0.75),
          const PositionSlot(label: 'D2', x: 0.35, y: 0.8),
          const PositionSlot(label: 'D3', x: 0.65, y: 0.8),
          const PositionSlot(label: 'D4', x: 0.9, y: 0.75),
        ],
      );
    }
  }

  void changeFormation(String name) {
    // Collect currently assigned players to return to squad
    final currentPos = currentFormation.value?.positions ?? [];
    final assignedIds = currentPos.map((e) => e.assignedPlayerId).whereType<String>().toList();
    
    for (var id in assignedIds) {
      final p = _mockAllSquad.firstWhereOrNull((player) => player.id == id);
      if (p != null && !squadPlayers.any((s) => s.id == p.id)) {
        squadPlayers.add(p);
      }
    }
    
    selectedFormation.value = name;
    loadFormation();
    validateFormation();
  }

  void assignPlayer(String slotLabel, PlayerModel player) {
    if (player.isLocked || player.isGoalkeeper) return;
    
    final currentPos = currentFormation.value?.positions.toList();
    if (currentPos == null) return;
    
    final slotIdx = currentPos.indexWhere((s) => s.label == slotLabel);
    if (slotIdx == -1) return;
    
    // Check if slot already has player, if so, return them to squad
    final existingId = currentPos[slotIdx].assignedPlayerId;
    if (existingId != null && existingId.isNotEmpty) {
      final oldP = _mockAllSquad.firstWhereOrNull((p) => p.id == existingId);
      if (oldP != null && !squadPlayers.any((s) => s.id == oldP.id)) {
        squadPlayers.add(oldP);
      }
    }
    
    // Assign new player
    currentPos[slotIdx] = currentPos[slotIdx].copyWith(assignedPlayerId: player.id);
    currentFormation.value = currentFormation.value!.copyWith(positions: currentPos);
    
    // Remove from squad
    squadPlayers.removeWhere((p) => p.id == player.id);
    validateFormation();
  }

  void removePlayer(String slotLabel) {
    final currentPos = currentFormation.value?.positions.toList();
    if (currentPos == null) return;
    
    final slotIdx = currentPos.indexWhere((s) => s.label == slotLabel);
    if (slotIdx == -1) return;
    
    final existingId = currentPos[slotIdx].assignedPlayerId;
    if (existingId != null && existingId.isNotEmpty) {
      final oldP = _mockAllSquad.firstWhereOrNull((p) => p.id == existingId);
      if (oldP != null && !squadPlayers.any((s) => s.id == oldP.id)) {
        squadPlayers.add(oldP);
      }
      currentPos[slotIdx] = currentPos[slotIdx].copyWith(assignedPlayerId: '');
      currentFormation.value = currentFormation.value!.copyWith(positions: currentPos);
    }
    validateFormation();
  }

  void swapPlayers(String slotALabel, String slotBLabel) {
    final currentPos = currentFormation.value?.positions.toList();
    if (currentPos == null) return;
    
    final idxA = currentPos.indexWhere((s) => s.label == slotALabel);
    final idxB = currentPos.indexWhere((s) => s.label == slotBLabel);
    if (idxA == -1 || idxB == -1) return;
    
    final idA = currentPos[idxA].assignedPlayerId;
    final idB = currentPos[idxB].assignedPlayerId;
    
    currentPos[idxA] = currentPos[idxA].copyWith(assignedPlayerId: idB ?? '');
    currentPos[idxB] = currentPos[idxB].copyWith(assignedPlayerId: idA ?? '');
    
    currentFormation.value = currentFormation.value!.copyWith(positions: currentPos);
    validateFormation();
  }

  void dragPlayer(String slotLabel, PlayerModel player) {
    assignPlayer(slotLabel, player);
  }
  
  void dropPlayer(String slotLabel, PlayerModel player) {
    assignPlayer(slotLabel, player);
  }

  void confirmSquad(BuildContext context) {
    validateFormation();
    // UI Phase bypass: Always allow navigation regardless of validation
    // if (isFormationValid.value) {
      Navigator.push(context, MaterialPageRoute(builder: (_) => const KickoffSetupScreen()));
    // } else {
    //   showError("Complete your lineup before continuing.");
    // }
  }

  void validateFormation() {
    final currentPos = currentFormation.value?.positions;
    if (currentPos == null) {
      isFormationValid.value = false;
      return;
    }
    
    bool allFilled = currentPos.every((s) => s.assignedPlayerId != null && s.assignedPlayerId!.isNotEmpty);
    bool hasGk = goalkeeper.value != null;
    
    isFormationValid.value = allFilled && hasGk;
  }

  void clearFormation() {
    final currentPos = currentFormation.value?.positions.toList();
    if (currentPos == null) return;
    
    for (int i = 0; i < currentPos.length; i++) {
      final existingId = currentPos[i].assignedPlayerId;
      if (existingId != null && existingId.isNotEmpty) {
        final oldP = _mockAllSquad.firstWhereOrNull((p) => p.id == existingId);
        if (oldP != null && !squadPlayers.any((s) => s.id == oldP.id)) {
          squadPlayers.add(oldP);
        }
      }
      currentPos[i] = currentPos[i].copyWith(assignedPlayerId: '');
    }
    
    currentFormation.value = currentFormation.value!.copyWith(positions: currentPos);
    validateFormation();
  }

  void searchPlayers(String query) {
    searchQuery.value = query;
    if (query.isEmpty) {
      loadPlayers(); // resets but doesn't pull assigned players
      final currentPos = currentFormation.value?.positions ?? [];
      final assignedIds = currentPos.map((e) => e.assignedPlayerId).whereType<String>().toSet();
      squadPlayers.removeWhere((p) => assignedIds.contains(p.id));
    } else {
      squadPlayers.assignAll(squadPlayers.where((p) => p.name.toLowerCase().contains(query.toLowerCase())));
    }
  }

  void filterPlayers(String filters) {
    // Mock
  }

  void sortPlayers(String criteria) {
    // Mock
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
      backgroundColor: const Color(0xFFC6FF00), // Lime Green
      colorText: Colors.black,
      snackPosition: SnackPosition.BOTTOM,
      margin: const EdgeInsets.all(16),
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
      snackPosition: SnackPosition.BOTTOM,
      margin: const EdgeInsets.all(16),
    );
  }

  PlayerModel? getPlayerById(String? id) {
    if (id == null || id.isEmpty) return null;
    return _mockAllSquad.firstWhereOrNull((p) => p.id == id);
  }
}
