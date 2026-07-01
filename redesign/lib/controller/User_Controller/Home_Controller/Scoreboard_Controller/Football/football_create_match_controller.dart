import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../../../model/User_Models/Home_Models/Scoreboard_Model/Football/team_model.dart';

class FootballCreateMatchController extends GetxController {
  final RxBool isLoading = false.obs;

  final RxString matchName = ''.obs;
  final RxString tournament = ''.obs; // empty = "Select Tournament" placeholder
  final RxString venue = 'Stade de France'.obs;
  final RxString referee = ''.obs;
  final Rx<DateTime?> selectedDate = Rx<DateTime?>(null);
  
  final RxString selectedFormat = '11v11'.obs;
  final RxDouble duration = 90.0.obs;
  final RxInt halves = 2.obs;
  final RxBool extraTime = true.obs;
  final RxBool penaltyShootout = true.obs;
  final RxBool varSimulation = false.obs;
  
  final Rx<TeamModel?> homeTeam = Rx<TeamModel?>(null);
  final Rx<TeamModel?> awayTeam = Rx<TeamModel?>(null);

  final RxList<String> matchFormats = <String>[
    '11v11',
    '7v7',
    '5v5',
    'Custom',
  ].obs;

  final RxList<String> tournamentOptions = <String>[
    'PlayZ Champions Cup',
    'Regional League',
    'Friendly Match',
  ].obs;

  void loadInitialData() {
    isLoading.value = true;
    // Mock loading delay
    Future.delayed(const Duration(milliseconds: 500), () {
      isLoading.value = false;
    });
  }

  void selectTournament(String? value) {
    if (value != null) tournament.value = value;
  }

  void selectHomeTeam(TeamModel team) {
    homeTeam.value = team;
  }

  void selectAwayTeam(TeamModel team) {
    awayTeam.value = team;
  }

  void uploadTeamLogo(bool isHome) {
    showSuccess("Logo Upload Coming Soon");
  }

  void selectVenue() {
    // In a real app, this would open a dialog or search screen
    venue.value = "Camp Nou";
  }

  Future<void> selectDateTime(BuildContext context) async {
    final date = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 365)),
      builder: (context, child) {
        return Theme(
          data: ThemeData.dark().copyWith(
            colorScheme: const ColorScheme.dark(
              primary: Color(0xFFC6FF00), // Lime green
              onPrimary: Colors.black,
              surface: Color(0xFF1E1E1E),
              onSurface: Colors.white,
            ),
          ),
          child: child!,
        );
      },
    );

    if (date != null && context.mounted) {
      final time = await showTimePicker(
        context: context,
        initialTime: TimeOfDay.now(),
        builder: (context, child) {
          return Theme(
            data: ThemeData.dark().copyWith(
              colorScheme: const ColorScheme.dark(
                primary: Color(0xFFC6FF00),
                onPrimary: Colors.black,
                surface: Color(0xFF1E1E1E),
                onSurface: Colors.white,
              ),
            ),
            child: child!,
          );
        },
      );

      if (time != null) {
        selectedDate.value = DateTime(
          date.year,
          date.month,
          date.day,
          time.hour,
          time.minute,
        );
      }
    }
  }

  void searchReferee(String query) {
    referee.value = query;
  }

  void selectMatchFormat(String value) {
    selectedFormat.value = value;
  }

  void increaseHalves() {
    if (halves.value < 4) halves.value++;
  }

  void decreaseHalves() {
    if (halves.value > 1) halves.value--;
  }

  void updateDuration(double value) {
    duration.value = value;
  }

  void toggleExtraTime() {
    extraTime.toggle();
  }

  void togglePenaltyShootout() {
    penaltyShootout.toggle();
  }

  void toggleVAR() {
    varSimulation.toggle();
  }

  void saveAsTemplate() {
    showSuccess("Template Saved Successfully");
  }

  void createMatch() {
    if (validateForm()) {
      showSuccess("Match Created Successfully");
    }
  }

  bool validateForm() {
    // UI Phase: Bypass validation so the user can freely navigate the flow
    // if (matchName.value.trim().isEmpty) {
    //   showError("Match Name is required");
    //   return false;
    // }
    return true;
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
      backgroundColor: const Color(0xFFC6FF00),
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
