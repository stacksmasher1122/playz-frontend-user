import 'package:flutter/material.dart';
import 'volleyball_player_model.dart';

class VolleyballTeamModel {
  final String id;
  final String teamName;
  final String logo;
  final String coachName;
  final String division;
  final String club;
  final Color primaryColor;
  final List<VolleyballPlayerModel> players;
  final VolleyballPlayerModel? captain;
  final VolleyballPlayerModel? viceCaptain;
  final VolleyballPlayerModel? libero;
  final bool isReady;

  VolleyballTeamModel({
    required this.id,
    required this.teamName,
    this.logo = '',
    this.coachName = '',
    this.division = '',
    this.club = '',
    this.primaryColor = Colors.green,
    required this.players,
    this.captain,
    this.viceCaptain,
    this.libero,
    this.isReady = false,
  });

  VolleyballTeamModel copyWith({
    String? id,
    String? teamName,
    String? logo,
    String? coachName,
    String? division,
    String? club,
    Color? primaryColor,
    List<VolleyballPlayerModel>? players,
    VolleyballPlayerModel? captain,
    VolleyballPlayerModel? viceCaptain,
    VolleyballPlayerModel? libero,
    bool? isReady,
  }) {
    return VolleyballTeamModel(
      id: id ?? this.id,
      teamName: teamName ?? this.teamName,
      logo: logo ?? this.logo,
      coachName: coachName ?? this.coachName,
      division: division ?? this.division,
      club: club ?? this.club,
      primaryColor: primaryColor ?? this.primaryColor,
      players: players ?? this.players,
      captain: captain ?? this.captain,
      viceCaptain: viceCaptain ?? this.viceCaptain,
      libero: libero ?? this.libero,
      isReady: isReady ?? this.isReady,
    );
  }
}
