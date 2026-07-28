import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:redesign/theme/app_colors.dart';
import 'package:redesign/model/User_Models/Home_Models/Scoreboard_Model/Pickleball/pickleball_rule_engine.dart';

class PickleballInitializeMatchController extends GetxController {
  RxBool isLoading = false.obs;
  RxString selectedCategory = "Men's Doubles".obs;
  RxString selectedFormat = "11 Points".obs;
  RxString selectedMatchType = "Tournament".obs;
  RxString selectedSurface = "Indoor".obs;
  RxString selectedSkillLevel = "Professional".obs;
  RxString selectedServingRule = "Standard".obs;
  RxString selectedTournament = "".obs;
  Rx<DateTime?> selectedDate = Rx<DateTime?>(null);
  RxInt timeouts = 1.obs;
  RxInt maximumScore = 11.obs;
  RxBool winByTwo = true.obs;
  RxBool rallyScoring = false.obs;
  RxBool traditionalScoring = true.obs;
  RxBool goldenPoint = false.obs;
  RxBool medicalTimeout = true.obs;
  RxString courtSideSelection = "Random".obs;

  // Rule Engine Profile
  Rx<PickleballRuleProfile> currentProfile =
      PickleballRuleProfile.localTournament.obs;
  RxList<PickleballRuleProfile> availableProfiles = [
    PickleballRuleProfile.localTournament,
    PickleballRuleProfile.proTournament,
  ].obs;

  RxList<String> tournamentOptions = <String>[].obs;
  RxList<String> categoryOptions = <String>[].obs;
  RxList<String> formatOptions = <String>[].obs;
  RxList<String> matchTypeOptions = <String>[].obs;
  RxList<String> surfaceOptions = <String>[].obs;
  RxList<String> skillLevelOptions = <String>[].obs;
  RxList<String> servingRuleOptions = <String>[].obs;

  void initialize() {
    tournamentOptions.value = [
      "Masters Open",
      "Club League",
      "City Championship",
      "Regional Open",
    ];
    categoryOptions.value = [
      "Men's Singles",
      "Men's Doubles",
      "Women's Singles",
      "Women's Doubles",
      "Mixed",
    ];
    formatOptions.value = ["11 Points", "Best of 3", "Best of 5"];
    matchTypeOptions.value = [
      "Friendly",
      "Tournament",
      "Practice",
      "Championship",
    ];
    surfaceOptions.value = ["Indoor", "Outdoor", "Synthetic", "Wood"];
    skillLevelOptions.value = [
      "Beginner",
      "Intermediate",
      "Advanced",
      "Professional",
    ];
    servingRuleOptions.value = ["Standard", "Drop Serve", "Traditional"];
    loadDefaults();
  }

  void loadDefaults() {
    applyProfile(PickleballRuleProfile.localTournament);
    selectedCategory.value = "Men's Doubles";
    selectedMatchType.value = "Tournament";
    selectedSurface.value = "Indoor";
    selectedSkillLevel.value = "Professional";
    selectedServingRule.value = "Standard";
    selectedTournament.value = "";
    selectedDate.value = null;
    courtSideSelection.value = "Random";
  }

  void applyProfile(PickleballRuleProfile profile) {
    currentProfile.value = profile;

    // Sync to legacy variables
    selectedFormat.value = profile.matchFormat == PickleballMatchFormat.oneGame
        ? "11 Points"
        : profile.matchFormat == PickleballMatchFormat.bestOf3
        ? "Best of 3"
        : "Best of 5";
    timeouts.value = profile.timeoutsPerTeam;
    maximumScore.value = profile.winningPoints == WinningPoints.points11
        ? 11
        : profile.winningPoints == WinningPoints.points15
        ? 15
        : 21;
    winByTwo.value = profile.winByRule == WinByRule.winBy2;
    rallyScoring.value = profile.scoringSystem == ScoringSystem.rally;
    traditionalScoring.value =
        profile.scoringSystem == ScoringSystem.traditional;
    medicalTimeout.value = profile.medicalTimeoutEnabled;
  }

  void changeProfile(PickleballRuleProfile profile) {
    applyProfile(profile);
    showSuccess("Applied ${profile.profileName} Rules");
  }

  void selectCategory(String v) => selectedCategory.value = v;
  void selectFormat(String v) => selectedFormat.value = v;
  void changeMatchType(String v) => selectedMatchType.value = v;
  void changeCourtSurface(String v) => selectedSurface.value = v;
  void changeSkillLevel(String v) => selectedSkillLevel.value = v;
  void changeServingRule(String v) => selectedServingRule.value = v;
  void toggleWinByTwo() => winByTwo.toggle();

  void toggleRallyScoring() {
    rallyScoring.toggle();
    if (rallyScoring.value) {
      traditionalScoring.value = false;
    }
  }

  void toggleTraditional() {
    traditionalScoring.toggle();
    if (traditionalScoring.value) {
      rallyScoring.value = false;
    }
  }

  void toggleGoldenPoint() => goldenPoint.toggle();
  void toggleMedicalTimeout() => medicalTimeout.toggle();

  void incrementTimeouts() {
    if (timeouts.value < 2) timeouts.value++;
  }

  void decrementTimeouts() {
    if (timeouts.value > 0) timeouts.value--;
  }

  void selectMaxScore(int v) => maximumScore.value = v;
  void selectCourtSide(String v) => courtSideSelection.value = v;

  bool validateForm(String name, String court, DateTime? date) {
    return true; // Bypassed for UI Phase
  }

  void initializeMatch(
    String name,
    String court,
    DateTime? date,
    VoidCallback onSuccess,
  ) async {
    if (validateForm(name, court, date)) {
      isLoading.value = true;
      await Future.delayed(Duration(seconds: 1));
      isLoading.value = false;
      onSuccess();
    } else {
      showError("Please fill in all required fields");
    }
  }

  void saveTemplate() {
    showSuccess("Template Saved Successfully");
  }

  void resetForm() {
    loadDefaults();
  }

  void showSuccess(String msg) {
    Get.snackbar(
      "Success",
      msg,
      backgroundColor: AppColors.success,
      colorText: AppColors.onPrimary,
    );
  }

  void showError(String msg) {
    Get.snackbar(
      "Error",
      msg,
      backgroundColor: AppColors.error,
      colorText: AppColors.onPrimary,
    );
  }
}
