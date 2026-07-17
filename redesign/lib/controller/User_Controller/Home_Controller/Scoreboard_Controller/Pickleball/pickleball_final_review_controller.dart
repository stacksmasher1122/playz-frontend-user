import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:redesign/theme/app_colors.dart';
import 'package:redesign/model/User_Models/Home_Models/Scoreboard_Model/Pickleball/pickleball_review_model.dart';
import 'package:redesign/view/USER/Home/Scoreboard/Pickleball/live_match/live_pickleball_match_screen.dart';

class PickleballFinalReviewController extends GetxController {
  late Rx<PickleballReviewModel> reviewData;
  RxBool isLoading = false.obs;
  RxBool isStarting = false.obs;

  @override
  void onInit() {
    super.onInit();
    reviewData = PickleballReviewModel(
      teamAName: "", teamBName: "", teamAImage: "", teamBImage: "",
      courtName: "", matchTime: "", gamesFormat: "", targetPoints: 0,
      winByTwo: false, scoringMode: "", timeLimit: "", switchSides: "", recordReplays: false,
    ).obs;
  }

  void loadReviewData() {
    reviewData.value = PickleballReviewModel(
      teamAName: "The Aces",
      teamBName: "Net Rippers",
      teamAImage: "",
      teamBImage: "",
      courtName: "CENTRAL COURT",
      matchTime: "3:30 PM",
      gamesFormat: "Best of 3",
      targetPoints: 11,
      winByTwo: true,
      scoringMode: "Rally",
      timeLimit: "None",
      switchSides: "Every Game",
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
    await Future.delayed(Duration(milliseconds: 1500));
    isStarting.value = false;
    showSuccess("Match started successfully!");
    Navigator.push(context, MaterialPageRoute(builder: (_) => LivePickleballMatchScreen()));
  }

  void showSuccess(String msg) {
    Get.snackbar("Success", msg, backgroundColor: AppColors.success, colorText: Colors.black);
  }

  void showError(String msg) {
    Get.snackbar("Error", msg, backgroundColor: AppColors.error, colorText: AppColors.accent);
  }
}
