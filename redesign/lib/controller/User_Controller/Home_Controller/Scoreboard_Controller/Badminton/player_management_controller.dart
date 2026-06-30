import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../../model/User_Models/Home_Models/Scoreboard_Model/Badminton/player_model.dart';
import '../../../../../../view/USER/Home/Scoreboard/Badminton/live_match/live_match_screen.dart';
// Note: Normally we'd import AppColors etc., but we'll use standard GetX Snackbars 
// that can be styled later if AppColors is missing in the actual project structure.
// If AppColors is in common, we would import it. We'll use a placeholder neon color.

class PlayerManagementController extends GetxController {
  final RxBool isLoading = false.obs;
  
  final Rx<PlayerModel?> playerOne = Rx<PlayerModel?>(null);
  final Rx<PlayerModel?> playerTwo = Rx<PlayerModel?>(null);
  
  final RxInt totalGames = 3.obs;
  final RxInt pointsPerGame = 21.obs;
  final RxInt warmupDuration = 2.obs;
  
  final RxString sideChangePoint = '11 pts'.obs;
  final RxString intervalDuration = '60s'.obs;
  
  final RxBool autoSync = true.obs;

  void loadPlayers() async {
    isLoading.value = true;
    await Future.delayed(const Duration(milliseconds: 600));
    
    playerOne.value = const PlayerModel(
      id: 1,
      name: 'Viktor Axelsen',
      avatar: 'https://i.pravatar.cc/150?img=11', // network placeholder
      ranking: 1,
      country: 'DEN',
      isSelected: true,
    );
    
    playerTwo.value = const PlayerModel(
      id: 2,
      name: 'Lee Zii Jia',
      avatar: 'https://i.pravatar.cc/150?img=12', // network placeholder
      ranking: 3,
      country: 'MAS',
      isSelected: true,
    );
    
    isLoading.value = false;
  }

  void loadRules() {
    totalGames.value = 3;
    pointsPerGame.value = 21;
    warmupDuration.value = 2;
    sideChangePoint.value = '11 pts';
    intervalDuration.value = '60s';
    autoSync.value = true;
  }

  void selectPlayerOne() {
    // Placeholder for future picker
  }

  void selectPlayerTwo() {
    // Placeholder for future picker
  }

  void updateNumberOfGames(double v) {
    totalGames.value = v.toInt();
  }

  void incrementPoints() {
    if (pointsPerGame.value < 30) {
      pointsPerGame.value++;
    }
  }

  void decrementPoints() {
    if (pointsPerGame.value > 5) {
      pointsPerGame.value--;
    }
  }

  void updateWarmupDuration(double v) {
    warmupDuration.value = v.toInt();
  }

  void toggleAutoSync() {
    autoSync.toggle();
    if (autoSync.value) {
      showSuccess('Auto-Sync Enabled');
    } else {
      showError('Auto-Sync Disabled');
    }
  }

  bool validateConfiguration() {
    if (playerOne.value == null || playerTwo.value == null) {
      showError('Both players must be selected');
      return false;
    }
    return true;
  }

  void startMatch(BuildContext context) {
    if (validateConfiguration()) {
      showSuccess('Match Configured! Starting...');
      Navigator.push(
        context,
        MaterialPageRoute(builder: (_) => const LiveMatchScreen()),
      );
    }
  }

  void resetConfiguration() {
    loadRules();
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
      backgroundColor: const Color(0xFFC6FF00), // Neon Yellow-Green
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
}
