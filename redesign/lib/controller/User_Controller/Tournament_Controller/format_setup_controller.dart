import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../view/USER/Tournament/create_tournament_prize_pool/create_tournament_prize_pool_page.dart';
import 'create_tournament_controller.dart';
import '../../../model/User_Models/Tournament_Model/create_tournament_model.dart';

class FormatSetupController extends GetxController {
  final CreateTournamentController _createCtrl = Get.find<CreateTournamentController>();

  // Team Composition options
  final RxString teamMode = "team".obs; // singles, doubles, team
  final RxInt teamSize = 11.obs; // fallback default

  // Match Type
  final RxString matchType = "knockout".obs; // knockout, roundRobinSingle, roundRobinDouble, groupToKnockout

  // General Participant Count (teams)
  final RxInt participantCount = 8.obs;
  
  // Sport-specific rules
  final RxMap<String, dynamic> sportRules = <String, dynamic>{}.obs;

  // Group to Knockout specific rule
  final RxInt advancingTeamsPerGroup = 2.obs;

  String get selectedSport => _createCtrl.selectedSport.value;

  @override
  void onInit() {
    super.onInit();
    _initializeDefaults();
  }

  void _initializeDefaults() {
    String sport = selectedSport;

    // Initialize defaults based on sport
    if (sport == "Badminton" || sport == "Tennis" || sport == "Table Tennis" || sport == "Pickleball") {
      teamMode.value = "singles";
      teamSize.value = 1;
      sportRules.assignAll({
        "pointsPerGame": 21,
        "bestOf": 3
      });
    } else if (sport == "Cricket") {
      teamMode.value = "team";
      teamSize.value = 11;
      sportRules.assignAll({
        "overs": 20,
        "powerplayOvers": 6
      });
    } else if (sport == "Football") {
      teamMode.value = "team";
      teamSize.value = 11;
      sportRules.assignAll({
        "halfLength": 45,
        "extraTime": true,
        "penalties": true
      });
    } else if (sport == "Volleyball") {
      teamMode.value = "team";
      teamSize.value = 6;
      sportRules.assignAll({
        "pointsPerSet": 25,
        "bestOf": 5
      });
    } else if (sport == "Basketball") {
      teamMode.value = "team";
      teamSize.value = 5;
      sportRules.assignAll({
        "quarterLength": 10,
      });
    } else {
      teamMode.value = "team";
      teamSize.value = 5;
      sportRules.assignAll({});
    }
  }

  void setTeamMode(String mode) {
    teamMode.value = mode;
    if (mode == "singles") teamSize.value = 1;
    if (mode == "doubles") teamSize.value = 2;
  }

  void incrementParticipants() {
    participantCount.value += 1;
  }

  void decrementParticipants() {
    if (participantCount.value > 2) {
      participantCount.value -= 1;
    }
  }

  void updateRule(String key, dynamic value) {
    sportRules[key] = value;
  }

  void selectMatchType(String type) {
    matchType.value = type;
  }

  void saveFormatModel() {
    // Save these rules inside CreateTournamentModel or something accessible globally for later steps
    // For now, we assume _createCtrl holds the final model eventually, but we just hold state here.
  }

  void goBack(BuildContext context) {
    Navigator.pop(context);
  }

  void goNext(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => const CreateTournamentPrizePoolPage()),
    );
  }
}
