import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../view/USER/Tournament/create_tournament_prize_pool/create_tournament_prize_pool_page.dart';
import 'create_tournament_controller.dart';

class FormatSetupController extends GetxController {
  final CreateTournamentController _createCtrl = Get.find<CreateTournamentController>();

  // Team Composition options
  final RxString teamMode = "team".obs; // singles, doubles, team
  final RxInt teamSize = 11.obs; // Squad size per team

  // Substitutes for Team Sports (non-racket, non-combat)
  final RxBool allowSubstitutes = true.obs;
  final RxInt substituteCount = 5.obs;

  // Match Type
  final RxString matchType = "knockout".obs; // knockout, roundRobinSingle, roundRobinDouble, groupToKnockout

  // Max Teams allowed (single registration cap card)
  final RxInt maxTeams = 8.obs;
  final RxInt participantCount = 8.obs;

  // Sport-specific rules
  final RxMap<String, dynamic> sportRules = <String, dynamic>{}.obs;

  // Group to Knockout specific rule
  final RxInt advancingTeamsPerGroup = 2.obs;

  String get selectedSport => _createCtrl.selectedSport.value;

  bool get isRacquetSport {
    final s = selectedSport.toLowerCase().trim();
    return s == "badminton" || s == "tennis" || s == "table tennis" || s == "squash" || s == "pickleball";
  }

  bool get isCombatSport {
    final s = selectedSport.toLowerCase().trim();
    return s == "boxing" || s == "mma" || s == "wrestling" || s == "judo" || s == "karate" || s == "taekwondo";
  }

  bool get isTeamSport => !isRacquetSport && !isCombatSport;

  @override
  void onInit() {
    super.onInit();
    _initializeDefaults();
  }

  void _initializeDefaults() {
    String sport = selectedSport;

    if (isRacquetSport) {
      teamMode.value = "singles";
      teamSize.value = 1;
      allowSubstitutes.value = false;
      sportRules.assignAll({
        "pointsPerGame": 21,
        "bestOf": 3,
        "matchMode": "professional"
      });
    } else if (isCombatSport) {
      teamMode.value = "singles";
      teamSize.value = 1;
      allowSubstitutes.value = false;
      sportRules.assignAll({
        "rounds": 3,
        "roundDurationMin": 3,
      });
    } else if (sport == "Cricket") {
      teamMode.value = "team";
      teamSize.value = 11;
      allowSubstitutes.value = true;
      substituteCount.value = 4;
      sportRules.assignAll({
        "overs": 20,
        "powerplayOvers": 6
      });
    } else if (sport == "Football" || sport == "Soccer") {
      teamMode.value = "team";
      teamSize.value = 11;
      allowSubstitutes.value = true;
      substituteCount.value = 5;
      sportRules.assignAll({
        "halfLength": 45,
        "extraTime": true,
        "penalties": true
      });
    } else if (sport == "Volleyball") {
      teamMode.value = "team";
      teamSize.value = 6;
      allowSubstitutes.value = true;
      substituteCount.value = 6;
      sportRules.assignAll({
        "pointsPerSet": 25,
        "bestOf": 5
      });
    } else if (sport == "Basketball") {
      teamMode.value = "team";
      teamSize.value = 5;
      allowSubstitutes.value = true;
      substituteCount.value = 7;
      sportRules.assignAll({
        "quarterLength": 10,
      });
    } else if (sport == "Hockey") {
      teamMode.value = "team";
      teamSize.value = 11;
      allowSubstitutes.value = true;
      substituteCount.value = 7;
      sportRules.assignAll({
        "quarterLength": 15,
      });
    } else if (sport == "Kabaddi" || sport == "Kho Kho") {
      teamMode.value = "team";
      teamSize.value = 7;
      allowSubstitutes.value = true;
      substituteCount.value = 5;
      sportRules.assignAll({});
    } else {
      teamMode.value = "team";
      teamSize.value = 5;
      allowSubstitutes.value = true;
      substituteCount.value = 3;
      sportRules.assignAll({});
    }
  }

  void setTeamMode(String mode) {
    teamMode.value = mode;
    if (mode == "singles") {
      teamSize.value = 1;
    } else if (mode == "doubles") {
      teamSize.value = 2;
    }
  }

  void incrementTeamSize() {
    teamSize.value += 1;
  }

  void decrementTeamSize() {
    if (teamSize.value > 1) {
      teamSize.value -= 1;
    }
  }

  void toggleSubstitutes(bool val) {
    allowSubstitutes.value = val;
  }

  void incrementSubstitutes() {
    substituteCount.value += 1;
  }

  void decrementSubstitutes() {
    if (substituteCount.value > 0) {
      substituteCount.value -= 1;
    }
  }

  void incrementMaxTeams() {
    maxTeams.value += 1;
    participantCount.value = maxTeams.value;
  }

  void decrementMaxTeams() {
    if (maxTeams.value > 2) {
      maxTeams.value -= 1;
      participantCount.value = maxTeams.value;
    }
  }

  void setMaxTeams(int count) {
    maxTeams.value = count;
    participantCount.value = count;
  }

  void updateRule(String key, dynamic value) {
    sportRules[key] = value;
  }

  void selectMatchType(String type) {
    matchType.value = type;
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
