import 'package:get/get.dart';
import 'package:redesign/model/User_Models/Home_Models/Scoreboard_Model/Pickleball/live_pickleball_match_model.dart';
import 'package:redesign/controller/User_Controller/Home_Controller/Scoreboard_Controller/Pickleball/pickleball_sync_service.dart';
import 'package:redesign/controller/User_Controller/Home_Controller/Scoreboard_Controller/Pickleball/live_pickleball_match_controller.dart';
import 'package:redesign/view/USER/Home/Scoreboard/Pickleball/live_match/live_pickleball_match_screen.dart';
import 'package:flutter/material.dart';

class PickleballMatchHistoryController extends GetxController {
  final PickleballSyncService _syncService = Get.put(PickleballSyncService());
  
  RxList<LivePickleballMatchModel> matches = <LivePickleballMatchModel>[].obs;
  RxBool isLoading = true.obs;

  @override
  void onInit() {
    super.onInit();
    fetchMatches();
  }

  Future<void> fetchMatches() async {
    isLoading.value = true;
    try {
      var offlineMatches = await _syncService.getOfflineMatches();
      matches.assignAll(offlineMatches);
    } catch (e) {
      print("Error fetching match history: $e");
    } finally {
      isLoading.value = false;
    }
  }

  void resumeMatch(LivePickleballMatchModel match) {
    if (match.status == "COMPLETED") {
      Get.snackbar(
        "Match Completed",
        "You cannot resume a completed match.",
        backgroundColor: Colors.orange,
        colorText: Colors.white,
      );
      return;
    }

    // Load the match into Live Controller
    final liveController = Get.put(LivePickleballMatchController());
    liveController.loadMatch(match);
    
    // Navigate to Live Screen
    Get.to(() => LivePickleballMatchScreen());
  }
}
