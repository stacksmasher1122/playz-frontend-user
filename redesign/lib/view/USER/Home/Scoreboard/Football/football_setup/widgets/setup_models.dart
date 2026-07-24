import 'package:flutter/material.dart';
import 'package:redesign/score_engine/footballMatchEngine/football_match_engine.dart';

enum MatchMode { friendly, tournament }

enum TournamentType { knockout, league, hybrid }

enum TieBreaker { goalDifference, goalsScored, headToHead }

enum TimerType { countUp, countDown }

class Player {
  final String id;
  final String name;
  Player({required this.name})
    : id = DateTime.now().microsecondsSinceEpoch.toString();
}

class Team {
  String id;
  String name;
  String shortName;
  Color color;
  List<Player> players;
  bool isReady;

  Team({
    required this.name,
    this.shortName = '',
    this.color = Colors.grey,
    List<Player>? players,
    this.isReady = false,
  }) : id = DateTime.now().microsecondsSinceEpoch.toString(),
       players = players ?? [];

  bool get hasMinPlayers => players.length >= 7;

  MatchTeam toMatchTeam() {
    return MatchTeam(
      id: id,
      name: name,
      color: '0x${color.toARGB32().toRadixString(16).padLeft(8, '0')}',
      squad: players.asMap().entries.map((entry) {
        final index = entry.key;
        final p = entry.value;
        return MatchPlayer(
          id: p.id,
          name: p.name,
          number: index + 1,
          isStarter: index < 11,
          isOnPitch: index < 11,
        );
      }).toList(),
    );
  }
}

class MatchFixture {
  final String id;
  Team? home;
  Team? away;
  DateTime date;
  String? roundName;
  String? groupName;

  MatchFixture({
    this.home,
    this.away,
    required this.date,
    this.roundName,
    this.groupName,
  }) : id = DateTime.now().microsecondsSinceEpoch.toString();
}
