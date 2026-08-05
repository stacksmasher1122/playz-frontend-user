import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:redesign/theme/app_colors.dart';
import 'package:redesign/model/User_Models/Home_Models/Scoreboard_Model/Pickleball/pickleball_review_model.dart';
import 'package:redesign/view/USER/Home/Scoreboard/Pickleball/live_match/pickleball_scoreboard_screen.dart';
import 'package:redesign/controller/User_Controller/Home_Controller/Scoreboard_Controller/Pickleball/pickleball_initialize_match_controller.dart';
import 'package:redesign/controller/User_Controller/Home_Controller/Scoreboard_Controller/Pickleball/pickleball_team_management_controller.dart';
import 'package:redesign/model/User_Models/Home_Models/Scoreboard_Model/Pickleball/pickleball_rule_engine.dart';

class PickleballFinalReviewController extends GetxController {
  late Rx<PickleballReviewModel> reviewData;
  RxBool isLoading = false.obs;
  RxBool isStarting = false.obs;

  @override
  void onInit() {
    super.onInit();
    reviewData = PickleballReviewModel(
      teamAName: "",
      teamBName: "",
      teamAImage: "",
      teamBImage: "",
      courtName: "",
      matchTime: "",
      gamesFormat: "",
      targetPoints: 0,
      winByTwo: false,
      scoringMode: "",
      timeLimit: "",
      switchSides: "",
      recordReplays: false,
    ).obs;
  }

  void loadReviewData() {
    PickleballInitializeMatchController? initController;
    PickleballTeamManagementController? teamController;
    
    try {
      initController = Get.find<PickleballInitializeMatchController>();
    } catch (_) {}
    try {
      teamController = Get.find<PickleballTeamManagementController>();
    } catch (_) {}

    String teamA = "TEAM A";
    if (teamController != null && teamController.teamAPlayers.isNotEmpty) {
      teamA = teamController.isSingles.value 
        ? teamController.teamAPlayers.first.name 
        : "${teamController.teamAPlayers.first.name} & Co";
    }
    
    String teamB = "TEAM B";
    if (teamController != null && teamController.teamBPlayers.isNotEmpty) {
      teamB = teamController.isSingles.value 
        ? teamController.teamBPlayers.first.name 
        : "${teamController.teamBPlayers.first.name} & Co";
    }

    var rules = initController?.currentProfile.value;

    String format = "Best of 3";
    if (rules?.matchFormat == PickleballMatchFormat.oneGame) format = "1 Game";
    if (rules?.matchFormat == PickleballMatchFormat.bestOf5) format = "Best of 5";

    int target = 11;
    if (rules?.winningPoints == WinningPoints.points15) target = 15;
    if (rules?.winningPoints == WinningPoints.points21) target = 21;

    String teamAImage = "";
    if (teamController != null && teamController.teamAPlayers.isNotEmpty) {
      teamAImage = teamController.teamAPlayers.first.image;
    }
    String teamBImage = "";
    if (teamController != null && teamController.teamBPlayers.isNotEmpty) {
      teamBImage = teamController.teamBPlayers.first.image;
    }


    reviewData.value = PickleballReviewModel(
      teamAName: teamA,
      teamBName: teamB,
      teamAImage: teamAImage,
      teamBImage: teamBImage,
      courtName: initController?.selectedSurface.value != null && initController!.selectedSurface.value.isNotEmpty
          ? initController.selectedSurface.value 
          : "CENTRAL COURT",
      matchTime: "Now", 
      gamesFormat: format,
      targetPoints: target,
      winByTwo: rules?.winByRule == WinByRule.winBy2,
      scoringMode: rules?.scoringSystem == ScoringSystem.rally ? "Rally" : "Traditional",
      timeLimit: "None",
      switchSides: rules?.sideChangeRule == SideChangeRule.afterGame ? "Every Game" : "Never",
      recordReplays: true,
    );
  }

  void editMatch(BuildContext context) {
    // Go back to settings (might require multiple pops depending on stack, but keeping it simple as requested)
    Navigator.pop(context);
  }

  void editTeams(BuildContext context) {
    Navigator.pop(context);
  }

  void startMatch(BuildContext context) async {
    isStarting.value = true;
    await Future.delayed(const Duration(milliseconds: 1500));
    isStarting.value = false;
    showSuccess("Match started successfully!");
    if (context.mounted) {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (_) => const PickleballScoreboardScreen()),
      );
    }
  }

  void showSuccess(String msg) {
    Get.snackbar(
      "Success",
      msg,
      backgroundColor: AppColors.success,
      colorText: Colors.black,
    );
  }

  void showError(String msg) {
    Get.snackbar(
      "Error",
      msg,
      backgroundColor: AppColors.error,
      colorText: AppColors.accent,
    );
  }
}
