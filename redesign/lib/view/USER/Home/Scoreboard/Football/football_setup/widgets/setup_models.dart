import 'package:redesign/theme/app_colors.dart';
import 'package:flutter/material.dart';

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
