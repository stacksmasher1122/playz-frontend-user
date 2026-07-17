import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';

import '../../../model/User_Models/Tournament_Model/team_model.dart';

class ReviewPublishController extends GetxController {
  // Publish Settings State
  final RxBool isPublic = true.obs;
  final RxBool isPublishing = false.obs;

  // Mock Tournament Data for Review
  final String tournamentName = "Midnight Rumble V";
  final String tournamentType = "5v5 Basketball";
  final String tournamentCategory = "Pro-Am";
  final String bannerImageUrl = "https://via.placeholder.com/600x300";

  final String venueName = "Downtown Metro Rec Center";
  final String dateRange = "Oct 15 - Oct 17, 2024";
  
  final String formatType = "Double Elimination";
  final String formatDetails = "16 Teams Max";
  
  final String prizeTotal = "\$5,000 Total";
  final String prizeDistribution = "1st: \$3,000 | 2nd: \$1,500 | 3rd: \$500";

  // Mock Registered Teams
  final RxList<TeamModel> registeredTeams = <TeamModel>[].obs;
  final int maxTeams = 16;
  final int currentTeams = 12;

  @override
  void onInit() {
    super.onInit();
    _loadMockTeams();
  }

  void _loadMockTeams() {
    registeredTeams.addAll([
      TeamModel(
        id: "rt1",
        name: "Neon Panthers",
        logoUrl: "https://via.placeholder.com/150",
      ),
      TeamModel(
        id: "rt2",
        name: "Volt Hoopers",
        logoUrl: "https://via.placeholder.com/150",
      ),
      TeamModel(
        id: "rt3",
        name: "City Kings",
        logoUrl: null, // Will use group icon fallback
      ),
    ]);
  }

  void togglePublicSetting(bool value) {
    isPublic.value = value;
  }

  void copyInviteLink() {
    Clipboard.setData(const ClipboardData(text: "https://playz.app/invite/mrv-2024"));
    Get.snackbar(
      "Link Copied",
      "Tournament invite link copied to clipboard",
      backgroundColor: Colors.black87,
      colorText: Colors.white,
      snackPosition: SnackPosition.BOTTOM,
      icon: const Icon(Icons.check_circle, color: Colors.green),
    );
  }

  void editAll(BuildContext context) {
    // Navigate back to the very first step in a real scenario
    Get.snackbar("Edit Mode", "Navigating to first step...");
  }

  void manageTeams(BuildContext context) {
    Navigator.pop(context); // Go back to Team Builder
  }

  void goBack(BuildContext context) {
    Navigator.pop(context);
  }

  Future<void> publishTournament(BuildContext context) async {
    isPublishing.value = true;
    
    // Simulate network delay
    await Future.delayed(const Duration(seconds: 2));
    
    isPublishing.value = false;
    
    // Show success and navigate away
    Get.snackbar(
      "Tournament Published!",
      "Your tournament is now live.",
      backgroundColor: Colors.green,
      colorText: Colors.white,
      snackPosition: SnackPosition.TOP,
      duration: const Duration(seconds: 3),
    );

    // In a real app, this would route to a dashboard or success screen
    // Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (_) => DashboardPage()), (route) => false);
  }
}
