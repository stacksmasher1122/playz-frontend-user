import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:redesign/sqflite/User_SQF/Home_SQF/Scoreboard_SQF/cricketSqflite.dart';
import 'package:redesign/sqflite/User_SQF/Home_SQF/Scoreboard_SQF/badmintonSqflite.dart';
import 'package:redesign/sqflite/User_SQF/Home_SQF/Scoreboard_SQF/footballSqflite.dart';
import 'package:redesign/controller/User_Controller/Home_Controller/Scoreboard_Controller/cricket_controller.dart';
import 'package:redesign/controller/User_Controller/Home_Controller/Scoreboard_Controller/badminton_controller.dart';
import 'package:redesign/controller/User_Controller/Home_Controller/Scoreboard_Controller/Football/football_controller.dart';
import 'package:redesign/view/USER/Home/Scoreboard/Cricket/cricket_scoreboard/cricket_scoreboard_screen.dart';
import 'package:redesign/view/USER/Home/Scoreboard/Badminton/live_match/badminton_scoreboard_screen.dart';
import 'package:redesign/view/USER/Home/Scoreboard/Football/football_scoreboard/football_scoreboard_screen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:redesign/model/User_Models/Home_Models/Scoreboard_Model/cricket_model.dart';
import 'package:redesign/model/User_Models/Home_Models/Scoreboard_Model/badminton_model.dart';
import 'package:redesign/model/football/football_model.dart';

class RecoverableMatchItem {
  final String matchId;
  final String sport;
  final String matchType; // 'SLOT_DEDICATED' vs 'NORMAL'
  final String? bookingId;
  final String title;
  final String subtitle;
  final DateTime lastUpdatedAt;
  final dynamic rawModel;

  const RecoverableMatchItem({
    required this.matchId,
    required this.sport,
    required this.matchType,
    this.bookingId,
    required this.title,
    required this.subtitle,
    required this.lastUpdatedAt,
    this.rawModel,
  });
}

class ScoreboardHubItem {
  final String matchId;
  final String sport;
  final String matchType; // 'SLOT_DEDICATED' vs 'NORMAL'
  final String status; // 'completed' or 'incomplete'
  final String title;
  final String subtitle;
  final DateTime lastUpdatedAt;
  final DateTime? createdAt;
  final dynamic rawModel;

  const ScoreboardHubItem({
    required this.matchId,
    required this.sport,
    required this.matchType,
    required this.status,
    required this.title,
    required this.subtitle,
    required this.lastUpdatedAt,
    this.createdAt,
    this.rawModel,
  });

  bool get isCompleted => status.toLowerCase() == 'completed';
  bool get isBooked => matchType == 'SLOT_DEDICATED' || matchId.startsWith('SLOT_');

  String get statusDisplay {
    if (isCompleted) {
      return isBooked ? 'Completed • Booked Slot' : 'Completed • Manual';
    }
    return 'Incomplete';
  }
}

class ScoreboardRecoveryManager {
  /// Unfinished Booked Slot Matches ONLY (shown in recovery box above Create Tournament)
  static Future<List<RecoverableMatchItem>> getUnfinishedBookedSlotMatches() async {
    final allUnfinished = await getUnfinishedMatches();
    return allUnfinished.where((m) => m.matchType == 'SLOT_DEDICATED' || m.matchId.startsWith('SLOT_')).toList();
  }

  /// All Unfinished Matches
  static Future<List<RecoverableMatchItem>> getUnfinishedMatches() async {
    final List<RecoverableMatchItem> list = [];

    // 1. Check Cricket Matches from SQFlite
    try {
      final cricketMatches = await CricketSqflite.instance.getAllMatches();
      for (final m in cricketMatches) {
        if (m.status.toLowerCase() != 'completed') {
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
              rawModel: m,
            ),
          );
        }
      }
    } catch (_) {}

    // 2. Check Badminton Matches from SQFlite
    try {
      final badmintonMatches = await BadmintonSqflite.instance.getAllMatches();
      for (final b in badmintonMatches) {
        if (b.status.toLowerCase() != 'completed') {
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
              rawModel: b,
            ),
          );
        }
      }
    } catch (_) {}

    // 3. Check Football Matches from SQFlite
    try {
      final footballMatches = await FootballSqflite.instance.getAllMatches();
      for (final f in footballMatches) {
        if (f.status.toLowerCase() != 'completed') {
          final isSlot = f.id.startsWith('SLOT_');
          final teamA = f.engineState.homeTeam.name.isNotEmpty ? f.engineState.homeTeam.name : 'Home';
          final teamB = f.engineState.awayTeam.name.isNotEmpty ? f.engineState.awayTeam.name : 'Away';

          list.add(
            RecoverableMatchItem(
              matchId: f.id,
              sport: 'Football',
              matchType: isSlot ? 'SLOT_DEDICATED' : 'NORMAL',
              title: '$teamA vs $teamB',
              subtitle: 'Football • ${f.config['halfDurationMinutes'] ?? 45}m • ${f.status}',
              lastUpdatedAt: f.lastUpdatedAt,
              rawModel: f,
            ),
          );
        }
      }
    } catch (_) {}

    list.sort((a, b) => b.lastUpdatedAt.compareTo(a.lastUpdatedAt));
    return list;
  }

  /// Scoreboards displayed below Create Scoreboard Hero Card
  static Future<List<ScoreboardHubItem>> getHubScoreboardMatches() async {
    final List<ScoreboardHubItem> list = [];

    // 1. Cricket Matches from SQFlite
    try {
      final cricketMatches = await CricketSqflite.instance.getAllMatches();
      for (final m in cricketMatches) {
        final isSlot = m.matchId.startsWith('SLOT_');
        final isCompleted = m.status.toLowerCase() == 'completed' || m.matchResult.isNotEmpty;
        final matchType = isSlot ? 'SLOT_DEDICATED' : 'NORMAL';

        if (isCompleted || (!isCompleted && !isSlot)) {
          final teamA = m.homeTeamName.isNotEmpty ? m.homeTeamName : 'Team Red';
          final teamB = m.awayTeamName.isNotEmpty ? m.awayTeamName : 'Team Blue';

          String sub = 'Cricket • ${m.overs} Overs';
          if (isCompleted && m.matchResult.isNotEmpty) {
            sub = m.matchResult;
          } else {
            sub = 'Cricket • ${m.overs} Overs • ${m.status}';
          }

          list.add(
            ScoreboardHubItem(
              matchId: m.matchId,
              sport: 'Cricket',
              matchType: matchType,
              status: isCompleted ? 'completed' : 'incomplete',
              title: '$teamA vs $teamB',
              subtitle: sub,
              lastUpdatedAt: m.lastUpdatedAt,
              createdAt: m.createdAt,
              rawModel: m,
            ),
          );
        }
      }
    } catch (_) {}

    // 2. Badminton Matches from SQFlite
    try {
      final badmintonMatches = await BadmintonSqflite.instance.getAllMatches();
      for (final b in badmintonMatches) {
        final isSlot = b.matchId.startsWith('SLOT_');
        final isCompleted = b.status.toLowerCase() == 'completed' || b.matchResult.isNotEmpty;
        final matchType = isSlot ? 'SLOT_DEDICATED' : 'NORMAL';

        if (isCompleted || (!isCompleted && !isSlot)) {
          final teamA = _formatBadmintonTeamNames(b, true);
          final teamB = _formatBadmintonTeamNames(b, false);

          DateTime updatedDate = b.lastUpdatedAt ?? DateTime.now();

          String sub = 'Badminton • Best of ${b.gamesToWin * 2 - 1}';
          if (isCompleted && b.matchResult.isNotEmpty) {
            sub = b.matchResult;
          }

          list.add(
            ScoreboardHubItem(
              matchId: b.matchId,
              sport: 'Badminton',
              matchType: matchType,
              status: isCompleted ? 'completed' : 'incomplete',
              title: '$teamA vs $teamB',
              subtitle: sub,
              lastUpdatedAt: updatedDate,
              createdAt: b.createdAt ?? updatedDate,
              rawModel: b,
            ),
          );
        }
      }
    } catch (_) {}

    // 3. Football Matches from SQFlite
    try {
      final footballMatches = await FootballSqflite.instance.getAllMatches();
      for (final f in footballMatches) {
        final isSlot = f.id.startsWith('SLOT_');
        final isCompleted = f.status.toLowerCase() == 'completed' || f.matchResult.isNotEmpty;
        final matchType = isSlot ? 'SLOT_DEDICATED' : 'NORMAL';

        if (isCompleted || (!isCompleted && !isSlot)) {
          final teamA = f.engineState.homeTeam.name.isNotEmpty ? f.engineState.homeTeam.name : 'Home';
          final teamB = f.engineState.awayTeam.name.isNotEmpty ? f.engineState.awayTeam.name : 'Away';

          String sub = 'Football • ${f.config['halfDurationMinutes'] ?? 45}m';
          if (isCompleted && f.matchResult.isNotEmpty) {
            sub = f.matchResult;
          }

          list.add(
            ScoreboardHubItem(
              matchId: f.id,
              sport: 'Football',
              matchType: matchType,
              status: isCompleted ? 'completed' : 'incomplete',
              title: '$teamA vs $teamB',
              subtitle: sub,
              lastUpdatedAt: f.lastUpdatedAt,
              createdAt: f.createdAt,
              rawModel: f,
            ),
          );
        }
      }
    } catch (_) {}

    // 4. Fetch from Firestore for participating teammates (completed matches)
    try {
      final uid = FirebaseAuth.instance.currentUser?.uid;
      if (uid != null) {
        final querySnapshot = await FirebaseFirestore.instance
            .collection('matches')
            .where('allPlayers', arrayContains: uid)
            .where('status', isEqualTo: 'completed')
            .get();

        for (final doc in querySnapshot.docs) {
          final data = doc.data();
          final matchId = doc.id;

          if (list.any((item) => item.matchId == matchId)) {
            continue;
          }

          final isSlot = matchId.startsWith('SLOT_');
          final matchType = isSlot ? 'SLOT_DEDICATED' : 'NORMAL';

          if (data.containsKey('homeTeamName')) {
            final m = CricketMatchModel.fromJson(data);
            final teamA = m.homeTeamName.isNotEmpty ? m.homeTeamName : 'Team Red';
            final teamB = m.awayTeamName.isNotEmpty ? m.awayTeamName : 'Team Blue';

            String sub = m.matchResult.isNotEmpty ? m.matchResult : 'Cricket • ${m.overs} Overs';

            list.add(
              ScoreboardHubItem(
                matchId: m.matchId,
                sport: 'Cricket',
                matchType: matchType,
                status: 'completed',
                title: '$teamA vs $teamB',
                subtitle: sub,
                lastUpdatedAt: m.lastUpdatedAt,
                createdAt: m.createdAt,
                rawModel: m,
              ),
            );
          } else if (data.containsKey('teamAPlayers')) {
            final b = BadmintonMatchModel.fromJson(data);
            final teamA = _formatBadmintonTeamNames(b, true);
            final teamB = _formatBadmintonTeamNames(b, false);

            DateTime updatedDate = b.lastUpdatedAt ?? DateTime.now();
            String sub = b.matchResult.isNotEmpty ? b.matchResult : 'Badminton';

            list.add(
              ScoreboardHubItem(
                matchId: b.matchId,
                sport: 'Badminton',
                matchType: matchType,
                status: 'completed',
                title: '$teamA vs $teamB',
                subtitle: sub,
                lastUpdatedAt: updatedDate,
                rawModel: b,
              ),
            );
          }
        }
      }
    } catch (e) {
      debugPrint("Error fetching teammates' matches from Firestore: $e");
    }

    list.sort((a, b) => b.lastUpdatedAt.compareTo(a.lastUpdatedAt));
    return list;
  }

  static String _formatBadmintonTeamNames(BadmintonMatchModel b, bool isTeamA) {
    if (b.engineState != null) {
      try {
        final teamKey = isTeamA ? 'teamA' : 'teamB';
        final playersList = b.engineState![teamKey] as List?;
        if (playersList != null && playersList.isNotEmpty) {
          final names = playersList
              .map((p) => p is Map ? (p['name'] ?? '').toString() : '')
              .where((n) => n.isNotEmpty)
              .toList();
          if (names.isNotEmpty) {
            return names.map(_cleanPlayerName).join(', ');
          }
        }
      } catch (_) {}
    }

    final rawList = isTeamA ? b.teamAPlayers : b.teamBPlayers;
    if (rawList.isEmpty) return isTeamA ? 'Side A' : 'Side B';
    return rawList.map(_cleanPlayerName).join(', ');
  }

  static String _cleanPlayerName(String raw) {
    if (raw.contains('@')) {
      final part = raw.split('@').first;
      final formatted = part
          .split(RegExp(r'[._\-]'))
          .map((s) => s.isEmpty ? '' : '${s[0].toUpperCase()}${s.substring(1)}')
          .join(' ');
      return formatted.isNotEmpty ? formatted : part;
    }
    return raw;
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
    } else if (item.sport == 'Football') {
      final controller = Get.isRegistered<FootballController>()
          ? Get.find<FootballController>()
          : Get.put(FootballController());

      final matchData = await FootballSqflite.instance.getMatch(item.matchId);
      if (matchData != null) {
        controller.restoreFootballMatchFromSqflite(matchData);
        if (context.mounted) {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => FootballScoreboardScreen()),
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
    } else if (item.sport == 'Football') {
      await FootballSqflite.instance.deleteMatch(item.matchId);
    }
  }
}
