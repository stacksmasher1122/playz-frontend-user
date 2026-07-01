import 'package:redesign/model/User_Models/Home_Models/Scoreboard_Model/Volleyball/volleyball_match_configuration_model.dart';
import 'package:redesign/model/User_Models/Home_Models/Scoreboard_Model/Volleyball/volleyball_team_model.dart';

class VolleyballReviewModel {
  final VolleyballMatchConfigurationModel config;
  final VolleyballTeamModel teamA;
  final VolleyballTeamModel teamB;

  VolleyballReviewModel({
    required this.config,
    required this.teamA,
    required this.teamB,
  });
}
