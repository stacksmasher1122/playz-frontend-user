import 'package:redesign/model/User_Models/Home_Models/Scoreboard_Model/Volleyball/volleyball_player_model.dart';

class TeamStatisticsModel {
  final int attackSuccessPercent;
  final int blocks;
  final int aces;
  final int digs;
  final int receptionQualityPercent;
  final int kills;
  final int errors;

  TeamStatisticsModel({
    required this.attackSuccessPercent,
    required this.blocks,
    required this.aces,
    required this.digs,
    required this.receptionQualityPercent,
    required this.kills,
    required this.errors,
  });
}

class PlayerStatisticsModel {
  final VolleyballPlayerModel player;
  final int totalPoints;
  final int aces;
  final int blocks;
  final int kills;
  final int attackSuccessPercent;

  PlayerStatisticsModel({
    required this.player,
    required this.totalPoints,
    required this.aces,
    required this.blocks,
    required this.kills,
    required this.attackSuccessPercent,
  });
}
