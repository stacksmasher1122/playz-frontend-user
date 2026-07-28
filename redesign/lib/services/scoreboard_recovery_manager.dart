import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:redesign/sqflite/User_SQF/Home_SQF/Scoreboard_SQF/cricketSqflite.dart';
import 'package:redesign/sqflite/User_SQF/Home_SQF/Scoreboard_SQF/badmintonSqflite.dart';
import 'package:redesign/controller/User_Controller/Home_Controller/Scoreboard_Controller/cricket_controller.dart';
import 'package:redesign/controller/User_Controller/Home_Controller/Scoreboard_Controller/badminton_controller.dart';
import 'package:redesign/view/USER/Home/Scoreboard/Cricket/cricket_scoreboard/cricket_scoreboard_screen.dart';
import 'package:redesign/view/USER/Home/Scoreboard/Badminton/live_match/badminton_scoreboard_screen.dart';

class RecoverableMatchItem {
  final String matchId;
  final String sport;
  final String matchType; // 'SLOT_DEDICATED' vs 'NORMAL'
  final String? bookingId;
  final String title;
  final String subtitle;
  final DateTime lastUpdatedAt;

  const RecoverableMatchItem({
    required this.matchId,
    required this.sport,
    required this.matchType,
    this.bookingId,
    required this.title,
    required this.subtitle,
    required this.lastUpdatedAt,
  });
}

class ScoreboardRecoveryManager {
  static Future<List<RecoverableMatchItem>> getUnfinishedMatches() async {
    final List<RecoverableMatchItem> list = [];

    // 1. Check Cricket Matches from SQFlite
    try {
      final cricketMatches = await CricketSqflite.instance.getAllMatches();
      for (final m in cricketMatches) {
        if (m.status.toUpperCase() != 'COMPLETED') {
          final isSlot = m.matchId.startsWith('SLOT_');
          final teamA = m.homeTeamName.isNotEmpty ? m.homeTeamName : 'Team A';
          final teamB = m.awayTeamName.isNotEmpty ? m.awayTeamName : 'Team B';

          final DateTime updatedDate = m.lastUpdatedAt;

          list.add(
            RecoverableMatchItem(
              matchId: m.matchId,
              sport: 'Cricket',
              matchType: isSlot ? 'SLOT_DEDICATED' : 'NORMAL',
              title: '$teamA vs $teamB',
              subtitle: 'Cricket • ${m.overs} Overs • ${m.status}',
              lastUpdatedAt: updatedDate,
            ),
          );
        }
      }
    } catch (_) {}

    // 2. Check Badminton Matches from SQFlite
    try {
      final badmintonMatches = await BadmintonSqflite.instance.getAllMatches();
      for (final b in badmintonMatches) {
        if (b.status.toUpperCase() != 'COMPLETED') {
          final isSlot = b.matchId.startsWith('SLOT_');
          final teamA = b.teamAPlayers.isNotEmpty ? b.teamAPlayers.join(', ') : 'Team A';
          final teamB = b.teamBPlayers.isNotEmpty ? b.teamBPlayers.join(', ') : 'Team B';

          DateTime updatedDate = DateTime.now();
          if (b.lastUpdatedAt != null) {
            updatedDate = b.lastUpdatedAt!;
          }

          list.add(
            RecoverableMatchItem(
              matchId: b.matchId,
              sport: 'Badminton',
              matchType: isSlot ? 'SLOT_DEDICATED' : 'NORMAL',
              title: '$teamA vs $teamB',
              subtitle: 'Badminton • Best of ${b.gamesToWin * 2 - 1} • ${b.status}',
              lastUpdatedAt: updatedDate,
            ),
          );
        }
      }
    } catch (_) {}

    list.sort((a, b) => b.lastUpdatedAt.compareTo(a.lastUpdatedAt));
    return list;
  }

  static Future<void> resumeMatch(BuildContext context, RecoverableMatchItem item) async {
    if (item.sport == 'Cricket') {
      final controller = Get.isRegistered<CricketController>()
          ? Get.find<CricketController>()
          : Get.put(CricketController());

      final matchData = await CricketSqflite.instance.getMatch(item.matchId);
      if (matchData != null) {
        controller.restoreCricketMatchFromSqflite(matchData);
        if (context.mounted) {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => CricketScoreboardScreen()),
          );
        }
      }
    } else if (item.sport == 'Badminton') {
      final controller = Get.isRegistered<BadmintonController>()
          ? Get.find<BadmintonController>()
          : Get.put(BadmintonController());

      final matchData = await BadmintonSqflite.instance.getMatch(item.matchId);
      if (matchData != null) {
        controller.restoreBadmintonMatchFromSqflite(matchData);
        if (context.mounted) {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => BadmintonScoreboardScreen()),
          );
        }
      }
    }
  }

  static Future<void> discardMatch(RecoverableMatchItem item) async {
    if (item.sport == 'Cricket') {
      await CricketSqflite.instance.deleteMatch(item.matchId);
    } else if (item.sport == 'Badminton') {
      await BadmintonSqflite.instance.deleteMatch(item.matchId);
    }
  }
}
