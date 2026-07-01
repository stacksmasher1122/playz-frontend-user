import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../../../model/User_Models/Home_Models/Scoreboard_Model/Football/venue_model.dart';
import '../../../../../../model/User_Models/Home_Models/Scoreboard_Model/Football/side_selection_model.dart';
import '../../../../../../view/USER/Home/Scoreboard/Football/live_dashboard/live_football_dashboard_screen.dart';

class KickoffSetupController extends GetxController {
  final RxBool isLoading = false.obs;
  
  final RxString matchId = ''.obs;
  final RxBool teamAOnLeft = true.obs;
  final RxString selectedPossession = 'A'.obs;
  final RxDouble ballPosition = 0.5.obs;
  final RxBool isValid = false.obs;

  final Rx<VenueModel?> venue = Rx<VenueModel?>(null);

  final Rx<SideSelectionModel> teamA = const SideSelectionModel(
    teamId: 'team_a',
    teamName: 'North Eagles',
    teamColor: '0xFF4285F4', // Blue tint
    isHome: true,
    side: 'left',
  ).obs;

  final Rx<SideSelectionModel> teamB = const SideSelectionModel(
    teamId: 'team_b',
    teamName: 'Valley Titans',
    teamColor: '0xFF333333', // Dark grey
    isHome: false,
    side: 'right',
  ).obs;

  void initialize() {
    Future.microtask(() => isLoading.value = true);
    Future.delayed(const Duration(milliseconds: 500), () {
      loadMatch();
      loadVenue();
      validateKickoff();
      updateBall(animated: false);
      isLoading.value = false;
    });
  }

  void loadMatch() {
    matchId.value = '8829-X';
  }

  void loadVenue() {
    venue.value = const VenueModel(
      venueName: 'Stade de France',
      status: 'LIVE READY',
      duration: 90,
      format: '11 VS 11',
      weatherTemp: '12°C',
      weatherCondition: 'Clear',
      weatherIcon: 'cloud', // mock icon name
      referee: 'Marcus Drant',
      recordingSystem: 'Dual 4K ScoutCam',
    );
  }

  void swapSides() {
    teamAOnLeft.toggle();
    _syncTeamSides();
    updateBall(animated: true);
  }
  
  void _syncTeamSides() {
    teamA.value = teamA.value.copyWith(side: teamAOnLeft.value ? 'left' : 'right');
    teamB.value = teamB.value.copyWith(side: teamAOnLeft.value ? 'right' : 'left');
  }

  void dragTeam(String teamId, String targetSide) {
    // If dropped on the same side, do nothing. If dropped on opposite side, swap.
    if (teamId == teamA.value.teamId && teamA.value.side != targetSide) {
      swapSides();
    } else if (teamId == teamB.value.teamId && teamB.value.side != targetSide) {
      swapSides();
    }
  }

  void dropTeam(String teamId, String targetSide) {
    dragTeam(teamId, targetSide);
  }

  void changePossession(String team) {
    selectedPossession.value = team;
    updateBall(animated: true);
  }

  void updateBall({bool animated = true}) {
    if (selectedPossession.value == 'A') {
      ballPosition.value = teamAOnLeft.value ? 0.2 : 0.8;
    } else {
      ballPosition.value = teamAOnLeft.value ? 0.8 : 0.2;
    }
  }

  void validateKickoff() {
    isValid.value = matchId.value.isNotEmpty;
  }

  void startMatch(BuildContext context) {
    validateKickoff();
    // UI Phase bypass: Always allow navigation regardless of validation
    // if (isValid.value) {
      Navigator.push(context, MaterialPageRoute(builder: (_) => const LiveFootballDashboardScreen()));
    // } else {
    //   showError("Please complete kickoff setup before starting.");
    // }
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
}
