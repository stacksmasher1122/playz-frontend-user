import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:redesign/theme/app_colors.dart';
import 'package:redesign/model/User_Models/Home_Models/Scoreboard_Model/Volleyball/volleyball_review_model.dart';
import 'package:redesign/model/User_Models/Home_Models/Scoreboard_Model/Volleyball/volleyball_team_model.dart';
import 'package:redesign/model/User_Models/Home_Models/Scoreboard_Model/Volleyball/volleyball_match_configuration_model.dart';
import 'package:redesign/view/USER/Home/Scoreboard/Volleyball/live_scoring/volleyball_live_scoring_screen.dart';

class VolleyballFinalReviewController extends GetxController {
  late VolleyballReviewModel reviewData;

  // Validation States
  RxBool configurationValid = false.obs;
  RxBool rulesValid = false.obs;
  RxBool officialReady = false.obs;
  RxBool teamAReady = false.obs;
  RxBool teamBReady = false.obs;
  RxBool rotationReady = false.obs;
  RxBool hardwareReady = false.obs;
  RxBool networkReady = false.obs;
  
  RxBool loading = true.obs;

  @override
  void onInit() {
    super.onInit();
    // We will initialize data when the screen loads
  }

  void loadMatchReview(VolleyballTeamModel teamA, VolleyballTeamModel teamB) {
    loading.value = true;
    
    // Mocking configuration data since it comes from earlier screens
    var mockConfig = VolleyballMatchConfigurationModel(
      matchName: 'PRO LEAGUE • FINALS',
      tournament: 'Pro League',
      date: 'Oct 24',
      time: '19:30 UTC',
      venue: 'Grand Olympic Arena',
      court: 'Center Court',
      referee: 'H. Jensen',
      assistantReferee: 'A. Rossi',
      lineJudge1: 'M. Silva',
      lineJudge2: 'K. Tanaka',
      category: 'Pro',
      format: 'Best of 5',
      pointsPerSet: 25,
      finalSetPoints: 15,
      timeouts: 2,
      substitutions: 6,
      technicalTimeout: true,
      liberoEnabled: true,
      challengeEnabled: true,
      videoReview: true,
      warmupDuration: 15,
      coinToss: true,
      winByTwo: true,
    );

    reviewData = VolleyballReviewModel(
      config: mockConfig,
      teamA: teamA,
      teamB: teamB,
    );

    // Run initial validations
    Future.delayed(Duration(milliseconds: 1500), () {
      _runAllValidations();
      loading.value = false;
    });
  }

  void _runAllValidations() {
    validateConfiguration();
    validateRules();
    validateOfficials();
    validateTeams();
    validateRotation();
    validateHardware();
    validateSystem();
  }

  void validateConfiguration() {
    configurationValid.value = reviewData.config.venue.isNotEmpty && reviewData.config.date.isNotEmpty;
  }

  void validateRules() {
    rulesValid.value = reviewData.config.pointsPerSet > 0;
  }

  void validateOfficials() {
    officialReady.value = reviewData.config.referee.isNotEmpty && reviewData.config.assistantReferee.isNotEmpty;
  }

  void validateTeams() {
    teamAReady.value = _isTeamValid(reviewData.teamA);
    teamBReady.value = _isTeamValid(reviewData.teamB);
  }

  bool _isTeamValid(VolleyballTeamModel team) {
    // Check if team has at least 6 players on court/roster and a captain. 
    // Usually starting lineup screen ensures this before reaching here.
    return team.players.length >= 6 && team.players.any((p) => p.isCaptain);
  }

  void validateRotation() {
    // Mock rotation validation success
    rotationReady.value = true;
  }

  void validateHardware() {
    // Mock hardware success
    hardwareReady.value = true;
  }

  void validateSystem() {
    // Mock network success
    networkReady.value = true;
  }

  void startMatch(BuildContext context) {
    if (!configurationValid.value || !rulesValid.value || !officialReady.value || 
        !teamAReady.value || !teamBReady.value || !rotationReady.value || 
        !hardwareReady.value || !networkReady.value) {
      Get.snackbar(
        "Validation Failed", 
        "Please resolve all pending warnings before starting the match.", 
        backgroundColor: AppColors.error, 
        colorText: AppColors.primary
      );
      return;
    }

    Get.snackbar("Match Started", "Clock initiated. Good luck!", backgroundColor: AppColors.primaryContainer, colorText: Colors.black);
    Navigator.push(context, MaterialPageRoute(builder: (_) => VolleyballLiveScoringScreen(reviewData: reviewData)));
  }

  void goBack(BuildContext context) {
    Navigator.pop(context);
  }
}
