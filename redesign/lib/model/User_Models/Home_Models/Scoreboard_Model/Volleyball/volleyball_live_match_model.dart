import 'package:redesign/model/User_Models/Home_Models/Scoreboard_Model/Volleyball/volleyball_team_model.dart';
import 'package:redesign/model/User_Models/Home_Models/Scoreboard_Model/Volleyball/volleyball_match_configuration_model.dart';

class VolleyballLiveMatchModel {
  final VolleyballMatchConfigurationModel config;
  final VolleyballTeamModel teamA;
  final VolleyballTeamModel teamB;

  final int scoreA;
  final int scoreB;
  final int setsWonA;
  final int setsWonB;
  
  final int currentSet;
  final bool isTeamAServing;
  final int elapsedSeconds;

  final String latestAction;
  final DateTime timestamp;

  VolleyballLiveMatchModel({
    required this.config,
    required this.teamA,
    required this.teamB,
    required this.scoreA,
    required this.scoreB,
    required this.setsWonA,
    required this.setsWonB,
    required this.currentSet,
    required this.isTeamAServing,
    required this.elapsedSeconds,
    required this.latestAction,
    required this.timestamp,
  });

  VolleyballLiveMatchModel copyWith({
    VolleyballMatchConfigurationModel? config,
    VolleyballTeamModel? teamA,
    VolleyballTeamModel? teamB,
    int? scoreA,
    int? scoreB,
    int? setsWonA,
    int? setsWonB,
    int? currentSet,
    bool? isTeamAServing,
    int? elapsedSeconds,
    String? latestAction,
    DateTime? timestamp,
  }) {
    return VolleyballLiveMatchModel(
      config: config ?? this.config,
      teamA: teamA ?? this.teamA,
      teamB: teamB ?? this.teamB,
      scoreA: scoreA ?? this.scoreA,
      scoreB: scoreB ?? this.scoreB,
      setsWonA: setsWonA ?? this.setsWonA,
      setsWonB: setsWonB ?? this.setsWonB,
      currentSet: currentSet ?? this.currentSet,
      isTeamAServing: isTeamAServing ?? this.isTeamAServing,
      elapsedSeconds: elapsedSeconds ?? this.elapsedSeconds,
      latestAction: latestAction ?? this.latestAction,
      timestamp: timestamp ?? this.timestamp,
    );
  }
}
