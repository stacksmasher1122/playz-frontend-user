import 'package:get/get.dart';
import '../../../../../../../model/User_Models/Home_Models/Scoreboard_Model/Tennis/live_match_stats_model.dart';

class LiveScoringController extends GetxController {
  final Rx<LiveMatchStatsModel> matchStats = LiveMatchStatsModel().obs;

  void addPointPlayerA() {
    String currentPoints = matchStats.value.playerAPoints;
    String newPoints = _incrementTennisScore(currentPoints);
    matchStats.value = matchStats.value.copyWith(
      playerAPoints: newPoints,
      isPlayerAServing: true,
    );
  }

  void addPointPlayerB() {
    String currentPoints = matchStats.value.playerBPoints;
    String newPoints = _incrementTennisScore(currentPoints);
    matchStats.value = matchStats.value.copyWith(
      playerBPoints: newPoints,
      isPlayerAServing: false,
    );
  }

  String _incrementTennisScore(String current) {
    switch (current) {
      case '0': return '15';
      case '15': return '30';
      case '30': return '40';
      case '40': return 'Ad';
      case 'Ad': return '0'; // Win game, reset to 0 in mock
      default: return '15';
    }
  }

  void recordAce() {
    Get.snackbar('Action Recorded', 'Ace added', snackPosition: SnackPosition.TOP);
  }

  void recordWinner() {
    Get.snackbar('Action Recorded', 'Winner added', snackPosition: SnackPosition.TOP);
  }

  void recordFault() {
    Get.snackbar('Action Recorded', 'Fault added', snackPosition: SnackPosition.TOP);
  }

  void recordUnforcedError() {
    Get.snackbar('Action Recorded', 'Unforced error added', snackPosition: SnackPosition.TOP);
  }
}
