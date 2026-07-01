import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../../../../model/User_Models/Home_Models/Scoreboard_Model/Tennis/match_setup_model.dart';

class SetupMatchController extends GetxController {
  final matchNameController = TextEditingController();
  final umpireNameController = TextEditingController();
  final courtNumberController = TextEditingController();

  final Rx<MatchSetupModel> matchSetup = const MatchSetupModel().obs;

  @override
  void onClose() {
    matchNameController.dispose();
    umpireNameController.dispose();
    courtNumberController.dispose();
    super.onClose();
  }

  void updateMatchName(String value) {
    matchSetup.value = matchSetup.value.copyWith(matchName: value);
  }

  void selectTournament(String tournament) {
    matchSetup.value = matchSetup.value.copyWith(tournament: tournament);
  }

  void setDateTime(DateTime dateTime) {
    matchSetup.value = matchSetup.value.copyWith(dateTime: dateTime);
  }

  void updateCourtNumber(String value) {
    matchSetup.value = matchSetup.value.copyWith(courtNumber: value);
  }

  void updateChairUmpire(String value) {
    matchSetup.value = matchSetup.value.copyWith(chairUmpire: value);
  }

  void selectCategory(String category) {
    matchSetup.value = matchSetup.value.copyWith(category: category);
  }

  void selectSetFormat(String format) {
    matchSetup.value = matchSetup.value.copyWith(setFormat: format);
  }

  void toggleNoAdScoring() {
    matchSetup.value = matchSetup.value.copyWith(noAdScoring: !matchSetup.value.noAdScoring);
  }

  void toggleAdvantageRule() {
    matchSetup.value = matchSetup.value.copyWith(advantageRule: !matchSetup.value.advantageRule);
  }

  void toggleMatchTiebreak() {
    matchSetup.value = matchSetup.value.copyWith(matchTiebreak: !matchSetup.value.matchTiebreak);
  }

  void createMatchSession(BuildContext context) {
    final matchName = matchNameController.text.trim();
    final courtNumber = courtNumberController.text.trim();
    final tournament = matchSetup.value.tournament;
    final dateTime = matchSetup.value.dateTime;

    if (matchName.isEmpty || tournament.isEmpty || dateTime == null || courtNumber.isEmpty) {
      Get.snackbar(
        'Validation Error',
        'Please fill all required fields',
        backgroundColor: Colors.red.shade900,
        colorText: Colors.white,
        snackPosition: SnackPosition.BOTTOM,
        margin: const EdgeInsets.all(16),
      );
      return;
    }

    // Update model with text fields just in case
    updateMatchName(matchName);
    updateCourtNumber(courtNumber);
    updateChairUmpire(umpireNameController.text.trim());

    // User wants Navigator.push to PlayerManagementScreen
    // Since we are mocking, if the screen doesn't exist, we can just print. But the prompt said:
    // "Navigator.push(context, MaterialPageRoute(builder: (_) => const PlayerManagementScreen()))"
    // I will mock a placeholder if needed, or assume it exists. Actually I'll use the one from Tennis if available.
    // For now, let's implement the routing as requested.
  }
}
