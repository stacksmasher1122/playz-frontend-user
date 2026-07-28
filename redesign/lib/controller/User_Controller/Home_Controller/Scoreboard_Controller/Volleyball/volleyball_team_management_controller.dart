import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:redesign/theme/app_colors.dart';
import 'package:redesign/model/User_Models/Home_Models/Scoreboard_Model/Volleyball/volleyball_team_model.dart';
import 'package:redesign/model/User_Models/Home_Models/Scoreboard_Model/Volleyball/volleyball_player_model.dart';
import 'package:redesign/view/USER/Home/Scoreboard/Volleyball/starting_lineup/volleyball_starting_lineup_screen.dart';
import 'package:redesign/model/User_Models/Home_Models/Scoreboard_Model/Volleyball/volleyball_match_model.dart';
import 'package:redesign/sqflite/User_SQF/Home_SQF/Scoreboard_SQF/volleyballSqflite.dart';

class VolleyballTeamManagementController extends GetxController {
  Rx<VolleyballTeamModel> teamA = VolleyballTeamModel(
    id: 'A',
    teamName: 'VIPER ELITE',
    coachName: 'Sarah Jenkins',
    players: [],
    primaryColor: AppColors.accent,
  ).obs;

  Rx<VolleyballTeamModel> teamB = VolleyballTeamModel(
    id: 'B',
    teamName: 'VOLT ACADEMY',
    coachName: 'Robert Zhao',
    players: [],
    primaryColor: Colors.blue,
  ).obs;

  RxList<VolleyballPlayerModel> teamAPlayers = <VolleyballPlayerModel>[].obs;
  RxList<VolleyballPlayerModel> teamBPlayers = <VolleyballPlayerModel>[].obs;

  RxBool teamAReady = false.obs;
  RxBool teamBReady = false.obs;
  RxBool loading = false.obs;

  RxInt teamAActivePlayers = 0.obs;
  RxInt teamBActivePlayers = 0.obs;
  RxString currentMatchId = ''.obs;
  Rx<VolleyballMatchModel?> currentMatch = Rx<VolleyballMatchModel?>(null);

  @override
  void onInit() {
    super.onInit();
    loadTeams();
  }

  Future<void> loadTeams() async {
    loading.value = true;
    try {
      final latest = await VolleyballSqflite.instance.getAllMatches();
      if (latest.isNotEmpty) {
        final match = latest.first;
        currentMatch.value = match;
        currentMatchId.value = match.matchId;
        teamA.value = teamA.value.copyWith(
          teamName: match.homeTeamName.isNotEmpty
              ? match.homeTeamName
              : teamA.value.teamName,
          coachName: match.homeCoachName.isNotEmpty
              ? match.homeCoachName
              : teamA.value.coachName,
        );
        teamB.value = teamB.value.copyWith(
          teamName: match.awayTeamName.isNotEmpty
              ? match.awayTeamName
              : teamB.value.teamName,
          coachName: match.awayCoachName.isNotEmpty
              ? match.awayCoachName
              : teamB.value.coachName,
        );

        if (match.homeTeamPlayers.isNotEmpty) {
          teamAPlayers.assignAll(
            match.homeTeamPlayers.map((p) => _playerFromMap(p)).toList(),
          );
        }
        if (match.awayTeamPlayers.isNotEmpty) {
          teamBPlayers.assignAll(
            match.awayTeamPlayers.map((p) => _playerFromMap(p)).toList(),
          );
        }
      }
    } catch (_) {}

    if (teamAPlayers.isEmpty) {
      teamAPlayers.assignAll(_defaultTeamPlayers('A'));
    }
    if (teamBPlayers.isEmpty) {
      teamBPlayers.assignAll(_defaultTeamPlayers('B'));
    }

    _updateState();
    loading.value = false;
  }

  Future<void> loadPlayers(bool isTeamA) async {}

  Future<void> addPlayer(bool isTeamA, VolleyballPlayerModel player) async {
    if (isTeamA) {
      teamAPlayers.add(player);
    } else {
      teamBPlayers.add(player);
    }
    _updateState();
    await saveCurrentMatchState(status: 'setup');
    Get.snackbar(
      'Player Added',
      '${player.name} is now part of the roster.',
      snackPosition: SnackPosition.BOTTOM,
      backgroundColor: AppColors.accent,
      colorText: Colors.black,
    );
  }

  Future<void> removePlayer(bool isTeamA, String playerId) async {
    if (isTeamA) {
      teamAPlayers.removeWhere((p) => p.id == playerId);
    } else {
      teamBPlayers.removeWhere((p) => p.id == playerId);
    }
    _updateState();
    await saveCurrentMatchState(status: 'setup');
  }

  Future<void> editPlayer(
    bool isTeamA,
    VolleyballPlayerModel updatedPlayer,
  ) async {}

  Future<void> assignCaptain(bool isTeamA, String playerId) async {
    var list = isTeamA ? teamAPlayers : teamBPlayers;
    for (int i = 0; i < list.length; i++) {
      list[i] = list[i].copyWith(isCaptain: list[i].id == playerId);
    }
    _updateState();
    await saveCurrentMatchState(status: 'setup');
  }

  Future<void> assignViceCaptain(bool isTeamA, String playerId) async {}

  Future<void> assignLibero(bool isTeamA, String playerId) async {
    var list = isTeamA ? teamAPlayers : teamBPlayers;
    for (int i = 0; i < list.length; i++) {
      list[i] = list[i].copyWith(isLibero: list[i].id == playerId);
    }
    _updateState();
    await saveCurrentMatchState(status: 'setup');
  }

  Future<void> selectCoach(bool isTeamA, String coachName) async {
    if (isTeamA) {
      teamA.value = teamA.value.copyWith(coachName: coachName);
    } else {
      teamB.value = teamB.value.copyWith(coachName: coachName);
    }
    _updateState();
    await saveCurrentMatchState(status: 'setup');
  }

  Future<void> updateTeamDetails(
    bool isTeamA,
    String teamName,
    String coachName,
  ) async {
    if (isTeamA) {
      teamA.value = teamA.value.copyWith(
        teamName: teamName,
        coachName: coachName,
      );
    } else {
      teamB.value = teamB.value.copyWith(
        teamName: teamName,
        coachName: coachName,
      );
    }
    _updateState();
    await saveCurrentMatchState(status: 'setup');
  }

  Future<void> bulkImportPlayers(bool isTeamA) async {
    final roster = _defaultTeamPlayers(isTeamA ? 'A' : 'B');
    if (isTeamA) {
      teamAPlayers.assignAll(roster);
    } else {
      teamBPlayers.assignAll(roster);
    }
    _updateState();
    await saveCurrentMatchState(status: 'setup');
    Get.snackbar(
      'Roster Loaded',
      'A ready-made roster was applied to ${isTeamA ? teamA.value.teamName : teamB.value.teamName}.',
      backgroundColor: AppColors.accent,
      colorText: Colors.black,
    );
  }

  Future<void> importPreviousTeam() async {
    try {
      final latest = await VolleyballSqflite.instance.getAllMatches();
      if (latest.isEmpty) {
        Get.snackbar(
          'No History',
          'No saved volleyball match found yet.',
          backgroundColor: AppColors.card,
          colorText: AppColors.accent,
        );
        return;
      }

      final match = latest.first;
      currentMatch.value = match;
      currentMatchId.value = match.matchId;
      teamA.value = teamA.value.copyWith(
        teamName: match.homeTeamName.isNotEmpty
            ? match.homeTeamName
            : teamA.value.teamName,
        coachName: match.homeCoachName.isNotEmpty
            ? match.homeCoachName
            : teamA.value.coachName,
      );
      teamB.value = teamB.value.copyWith(
        teamName: match.awayTeamName.isNotEmpty
            ? match.awayTeamName
            : teamB.value.teamName,
        coachName: match.awayCoachName.isNotEmpty
            ? match.awayCoachName
            : teamB.value.coachName,
      );
      if (match.homeTeamPlayers.isNotEmpty) {
        teamAPlayers.assignAll(
          match.homeTeamPlayers.map((p) => _playerFromMap(p)).toList(),
        );
      }
      if (match.awayTeamPlayers.isNotEmpty) {
        teamBPlayers.assignAll(
          match.awayTeamPlayers.map((p) => _playerFromMap(p)).toList(),
        );
      }
      _updateState();
      await saveCurrentMatchState(status: 'setup');
      Get.snackbar(
        'Roster Imported',
        'The previous match roster was restored.',
        backgroundColor: AppColors.accent,
        colorText: Colors.black,
      );
    } catch (e) {
      Get.snackbar(
        'Import Failed',
        e.toString(),
        backgroundColor: AppColors.error,
        colorText: Colors.white,
      );
    }
  }

  Future<void> cloneTeam(bool isTeamA) async {
    final source = isTeamA ? teamAPlayers : teamBPlayers;
    final target = isTeamA ? teamBPlayers : teamAPlayers;
    target.assignAll(
      source
          .map(
            (player) => player.copyWith(
              id: '${player.id}-clone-${DateTime.now().millisecondsSinceEpoch}',
            ),
          )
          .toList(),
    );
    _updateState();
    await saveCurrentMatchState(status: 'setup');
    Get.snackbar(
      'Team Cloned',
      'The roster was copied to the other side.',
      backgroundColor: AppColors.accent,
      colorText: Colors.black,
    );
  }

  Future<void> randomizeNumbers(bool isTeamA) async {
    final list = isTeamA ? teamAPlayers : teamBPlayers;
    final random = Random();
    for (int i = 0; i < list.length; i++) {
      final number = random.nextInt(99) + 1;
      list[i] = list[i].copyWith(
        jerseyNumber: number.toString().padLeft(2, '0'),
      );
    }
    if (isTeamA) {
      teamAPlayers.assignAll(list);
    } else {
      teamBPlayers.assignAll(list);
    }
    _updateState();
    await saveCurrentMatchState(status: 'setup');
  }

  Future<void> saveCurrentMatchState({
    required String status,
    Map<String, dynamic>? metadataOverrides,
  }) async {
    final fallbackMatch = currentMatch.value;
    if (fallbackMatch == null) {
      final latestMatches = await VolleyballSqflite.instance.getAllMatches();
      if (latestMatches.isEmpty) return;
      currentMatch.value = latestMatches.first;
      currentMatchId.value = latestMatches.first.matchId;
    }

    final current = currentMatch.value;
    if (current == null) return;

    final metadata = {
      ...current.metadata,
      if (metadataOverrides != null) ...metadataOverrides,
      'lastUpdated': DateTime.now().toIso8601String(),
      'teamAReady': teamAReady.value,
      'teamBReady': teamBReady.value,
    };

    final updated = current.copyWith(
      homeTeamName: teamA.value.teamName,
      awayTeamName: teamB.value.teamName,
      homeCoachName: teamA.value.coachName,
      awayCoachName: teamB.value.coachName,
      homeTeamPlayers: teamAPlayers
          .map(
            (p) => {
              'id': p.id,
              'name': p.name,
              'jerseyNumber': p.jerseyNumber,
              'position': p.position,
              'isCaptain': p.isCaptain,
              'isLibero': p.isLibero,
            },
          )
          .toList(),
      awayTeamPlayers: teamBPlayers
          .map(
            (p) => {
              'id': p.id,
              'name': p.name,
              'jerseyNumber': p.jerseyNumber,
              'position': p.position,
              'isCaptain': p.isCaptain,
              'isLibero': p.isLibero,
            },
          )
          .toList(),
      status: status,
      metadata: metadata,
    );

    await VolleyballSqflite.instance.updateMatch(updated);
    currentMatch.value = updated;
    currentMatchId.value = updated.matchId;

    try {
      await FirebaseFirestore.instance
          .collection('volleyball_matches')
          .doc(updated.matchId)
          .set(updated.toJson(), SetOptions(merge: true));
    } catch (e) {
      debugPrint('Firestore update failed for volleyball match: $e');
    }
  }

  void _updateState() {
    teamAActivePlayers.value = teamAPlayers.length;
    teamBActivePlayers.value = teamBPlayers.length;

    teamA.value = teamA.value.copyWith(
      players: teamAPlayers,
      captain: teamAPlayers.firstWhereOrNull((p) => p.isCaptain),
      libero: teamAPlayers.firstWhereOrNull((p) => p.isLibero),
    );
    teamB.value = teamB.value.copyWith(
      players: teamBPlayers,
      captain: teamBPlayers.firstWhereOrNull((p) => p.isCaptain),
      libero: teamBPlayers.firstWhereOrNull((p) => p.isLibero),
    );

    validateRoster();
  }

  void validateRoster() {
    teamAReady.value = _validateTeam(teamA.value);
    teamBReady.value = _validateTeam(teamB.value);
  }

  bool _validateTeam(VolleyballTeamModel team) {
    if (team.coachName.isEmpty) return false;
    if (team.players.length < 6) return false;
    if (team.captain == null) return false;
    return true;
  }

  bool validateTeams() {
    if (teamAPlayers.length < 6 || teamBPlayers.length < 6) {
      Get.snackbar(
        'Roster Incomplete',
        'Each team needs at least 6 players before continuing.',
        backgroundColor: AppColors.error,
        colorText: Colors.white,
      );
      return false;
    }
    if (teamA.value.captain == null || teamB.value.captain == null) {
      Get.snackbar(
        'Captain Required',
        'Please assign a captain to both teams.',
        backgroundColor: AppColors.warning,
        colorText: Colors.black,
      );
      return false;
    }
    return true;
  }

  Future<void> goToNextScreen(BuildContext context) async {
    if (!validateTeams()) return;

    loading.value = true;
    try {
      await saveCurrentMatchState(status: 'ready');
      if (!context.mounted) return;
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (_) => VolleyballStartingLineupScreen(
            teamA: teamA.value,
            teamB: teamB.value,
          ),
        ),
      );
    } finally {
      loading.value = false;
    }
  }

  List<VolleyballPlayerModel> _defaultTeamPlayers(String side) {
    final base = side == 'A'
        ? [
            'Marcus Chen',
            'David Miller',
            'Alex Rivera',
            'Jordan Smith',
            'Chris Lane',
            'Sam Ortiz',
          ]
        : [
            'Lucas Van Der',
            'Tyson Wu',
            'Jin Kazama',
            'Ryu Hoshi',
            'Ken Masters',
            'Chun Li',
          ];
    final positions = side == 'A'
        ? [
            'Setter (S)',
            'Outside Hitter (OH)',
            'Libero (L)',
            'Middle Blocker (MB)',
            'Opposite (OPP)',
            'Defensive Specialist (DS)',
          ]
        : [
            'Opposite (OPP)',
            'Setter (S)',
            'Middle Blocker (MB)',
            'Outside Hitter (OH)',
            'Libero (L)',
            'Defensive Specialist (DS)',
          ];
    final jerseys = side == 'A'
        ? ['04', '12', '07', '21', '09', '13']
        : ['15', '01', '09', '10', '11', '12'];
    return List.generate(base.length, (index) {
      final name = base[index];
      final position = positions[index];
      final jersey = jerseys[index];
      return VolleyballPlayerModel(
        id: '${side.toLowerCase()}-$index-${DateTime.now().millisecondsSinceEpoch}',
        name: name,
        jerseyNumber: jersey,
        position: position,
        isCaptain: index == 0,
        isLibero: position.contains('Libero'),
      );
    });
  }

  VolleyballPlayerModel _playerFromMap(Map<String, dynamic> map) {
    return VolleyballPlayerModel(
      id:
          map['id']?.toString() ??
          DateTime.now().millisecondsSinceEpoch.toString(),
      name: map['name']?.toString() ?? 'Unnamed Player',
      jerseyNumber: map['jerseyNumber']?.toString() ?? '',
      position: map['position']?.toString() ?? 'Outside Hitter (OH)',
      isCaptain: map['isCaptain'] == true,
      isLibero: map['isLibero'] == true,
    );
  }
}
