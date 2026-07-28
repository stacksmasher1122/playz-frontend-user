import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:redesign/theme/app_colors.dart';
import 'package:redesign/model/User_Models/Home_Models/Scoreboard_Model/Volleyball/volleyball_review_model.dart';
import 'package:redesign/model/User_Models/Home_Models/Scoreboard_Model/Volleyball/volleyball_team_model.dart';
import 'package:redesign/model/User_Models/Home_Models/Scoreboard_Model/Volleyball/volleyball_match_configuration_model.dart';
import 'package:redesign/view/USER/Home/Scoreboard/Volleyball/live_scoring/volleyball_live_scoring_screen.dart';
import 'package:redesign/view/USER/Home/Scoreboard/Volleyball/final_review/widgets/coin_toss_bottom_sheet.dart';
import 'package:redesign/controller/User_Controller/Home_Controller/Scoreboard_Controller/Volleyball/volleyball_live_scoring_controller.dart';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:redesign/sqflite/User_SQF/Home_SQF/Scoreboard_SQF/volleyballSqflite.dart';
import 'package:redesign/model/User_Models/Home_Models/Scoreboard_Model/Volleyball/volleyball_match_model.dart';
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


  String _matchId = '';
  VolleyballMatchModel? _matchModel;

  void loadMatchReview(VolleyballTeamModel teamA, VolleyballTeamModel teamB) async {
    loading.value = true;
    
    final matches = await VolleyballSqflite.instance.getAllMatches();
    if (matches.isEmpty) {
      loading.value = false;
      return;
    }
    
    final latest = matches.first;
    _matchId = latest.matchId;
    _matchModel = latest;
    
    var realConfig = VolleyballMatchConfigurationModel(
      matchName: latest.matchName,
      tournament: latest.tournament,
      date: latest.date,
      time: latest.time,
      venue: latest.venue,
      court: latest.court,
      referee: latest.referee,
      assistantReferee: latest.assistantReferee,
      lineJudge1: '',
      lineJudge2: '',
      category: latest.category,
      format: latest.format,
      pointsPerSet: latest.pointsPerSet,
      finalSetPoints: latest.finalSetPoints,
      timeouts: latest.timeouts,
      substitutions: latest.substitutions,
      technicalTimeout: latest.technicalTimeout,
      liberoEnabled: latest.liberoEnabled,
      challengeEnabled: latest.challengeEnabled,
      videoReview: latest.videoReview,
      warmupDuration: 15,
      coinToss: true,
      winByTwo: latest.winByTwo,
    );

    reviewData = VolleyballReviewModel(
      config: realConfig,
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
    // Only require the main referee to be present
    officialReady.value = reviewData.config.referee.isNotEmpty;
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
        colorText: AppColors.accent
      );
      return;
    }

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => CoinTossBottomSheet(
        teamAName: reviewData.teamA.teamName,
        teamBName: reviewData.teamB.teamName,
        onTossComplete: (bool teamAServesFirst) async {
          Get.snackbar("Match Started", "Clock initiated. Good luck!", backgroundColor: AppColors.accent, colorText: Colors.black);
          
          if (_matchModel != null) {
            final updated = _matchModel!.copyWith(status: 'active');
            await VolleyballSqflite.instance.updateMatch(updated);
            try {
              await FirebaseFirestore.instance.collection('volleyball_matches').doc(_matchId).update({'status': 'active'});
            } catch (e) {
              debugPrint('Firestore update status failed: $e');
            }
          }

          var liveController = Get.put(VolleyballLiveScoringController());
          liveController.initializeMatch(reviewData, teamAServesFirst, _matchModel);
          if (!context.mounted) return;
          Navigator.push(context, MaterialPageRoute(builder: (_) => VolleyballLiveScoringScreen(
            reviewData: reviewData,
          )));
        },
      ),
    );
  }

  void goBack(BuildContext context) {
    Navigator.pop(context);
  }
}
