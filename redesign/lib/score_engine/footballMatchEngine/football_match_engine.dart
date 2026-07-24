import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

enum MatchPhase { preMatch, firstHalf, halfTime, secondHalf, extraTimeFirst, extraTimeHalf, extraTimeSecond, penalties, fullTime }
enum TeamSide { home, away }
enum EventType { whistle, goal, yellowCard, redCard, substitution, offside, freeKick, penaltyGoal, penaltyMiss, generic }

class MatchPlayer {
  String id;
  String name;
  int number;
  bool isStarter;
  bool isOnPitch;
  bool isSubstitutedOut;
  bool isSentOff;

  int goals = 0;
  int assists = 0;
  int yellowCards = 0;
  int redCards = 0;

  MatchPlayer({
    required this.id,
    required this.name,
    required this.number,
    this.isStarter = false,
    this.isOnPitch = false,
    this.isSubstitutedOut = false,
    this.isSentOff = false,
  });

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'number': number,
        'isStarter': isStarter,
        'isOnPitch': isOnPitch,
        'isSubstitutedOut': isSubstitutedOut,
        'isSentOff': isSentOff,
        'goals': goals,
        'assists': assists,
        'yellowCards': yellowCards,
        'redCards': redCards,
      };

  factory MatchPlayer.fromJson(Map<String, dynamic> json) => MatchPlayer(
        id: json['id'],
        name: json['name'],
        number: json['number'],
        isStarter: json['isStarter'] ?? false,
        isOnPitch: json['isOnPitch'] ?? false,
        isSubstitutedOut: json['isSubstitutedOut'] ?? false,
        isSentOff: json['isSentOff'] ?? false,
      )
        ..goals = json['goals'] ?? 0
        ..assists = json['assists'] ?? 0
        ..yellowCards = json['yellowCards'] ?? 0
        ..redCards = json['redCards'] ?? 0;
}

class MatchTeam {
  String id;
  String name;
  String color;
  List<MatchPlayer> squad;
  int substitutionsUsed;
  int penaltiesScored;
  int penaltiesMissed;

  MatchTeam({
    required this.id,
    required this.name,
    required this.color,
    required this.squad,
    this.substitutionsUsed = 0,
    this.penaltiesScored = 0,
    this.penaltiesMissed = 0,
  });

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'color': color,
        'substitutionsUsed': substitutionsUsed,
        'penaltiesScored': penaltiesScored,
        'penaltiesMissed': penaltiesMissed,
        'squad': squad.map((p) => p.toJson()).toList(),
      };

  factory MatchTeam.fromJson(Map<String, dynamic> json) => MatchTeam(
        id: json['id'],
        name: json['name'],
        color: json['color'] ?? '0xFF000000',
        substitutionsUsed: json['substitutionsUsed'] ?? 0,
        penaltiesScored: json['penaltiesScored'] ?? 0,
        penaltiesMissed: json['penaltiesMissed'] ?? 0,
        squad: (json['squad'] as List?)?.map((p) => MatchPlayer.fromJson(p)).toList() ?? [],
      );
}

class MatchEvent {
  final int realMinute;
  final int displayMinute;
  final int addedMinute;
  final EventType type;
  final TeamSide? side;
  final String title;
  final String subtitle;
  final IconData icon;
  final Color color;
  final String? playerId;
  final String? assistId;
  final String? subInId;
  final String? subOutId;

  MatchEvent({
    required this.realMinute,
    required this.displayMinute,
    required this.addedMinute,
    required this.type,
    this.side,
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.color,
    this.playerId,
    this.assistId,
    this.subInId,
    this.subOutId,
  });

  Map<String, dynamic> toJson() => {
        'realMinute': realMinute,
        'displayMinute': displayMinute,
        'addedMinute': addedMinute,
        'type': type.name,
        'side': side?.name,
        'title': title,
        'subtitle': subtitle,
        'icon': icon.codePoint,
        'color': color.value,
        'playerId': playerId,
        'assistId': assistId,
        'subInId': subInId,
        'subOutId': subOutId,
      };

  factory MatchEvent.fromJson(Map<String, dynamic> json) => MatchEvent(
        realMinute: json['realMinute'],
        displayMinute: json['displayMinute'],
        addedMinute: json['addedMinute'] ?? 0,
        type: EventType.values.firstWhere((e) => e.name == json['type']),
        side: json['side'] != null ? TeamSide.values.firstWhere((e) => e.name == json['side']) : null,
        title: json['title'],
        subtitle: json['subtitle'],
        icon: IconData(json['icon'], fontFamily: 'MaterialIcons'),
        color: Color(json['color']),
        playerId: json['playerId'],
        assistId: json['assistId'],
        subInId: json['subInId'],
        subOutId: json['subOutId'],
      );
}

class FootballMatchState {
  FootballMatchState();
  int seconds = 0;
  int addedSeconds = 0;
  MatchPhase phase = MatchPhase.preMatch;
  bool isRunning = false;
  List<MatchEvent> events = [];
  int homeScore = 0;
  int awayScore = 0;
  late MatchTeam homeTeam;
  late MatchTeam awayTeam;

  Map<String, dynamic> toJson() => {
        'seconds': seconds,
        'addedSeconds': addedSeconds,
        'phase': phase.name,
        'isRunning': isRunning,
        'events': events.map((e) => e.toJson()).toList(),
        'homeScore': homeScore,
        'awayScore': awayScore,
        'homeTeam': homeTeam.toJson(),
        'awayTeam': awayTeam.toJson(),
      };

  factory FootballMatchState.fromJson(Map<String, dynamic> json) {
    var state = FootballMatchState();
    state.seconds = json['seconds'] ?? 0;
    state.addedSeconds = json['addedSeconds'] ?? 0;
    state.phase = MatchPhase.values.firstWhere((e) => e.name == json['phase'], orElse: () => MatchPhase.preMatch);
    state.isRunning = json['isRunning'] ?? false;
    state.events = (json['events'] as List?)?.map((e) => MatchEvent.fromJson(e)).toList() ?? [];
    state.homeScore = json['homeScore'] ?? 0;
    state.awayScore = json['awayScore'] ?? 0;
    if (json['homeTeam'] != null) state.homeTeam = MatchTeam.fromJson(json['homeTeam']);
    if (json['awayTeam'] != null) state.awayTeam = MatchTeam.fromJson(json['awayTeam']);
    return state;
  }
}


class MatchEngine extends ChangeNotifier {
  FootballMatchState state = FootballMatchState();
  int halfDuration;
  bool extraTimeEnabled;
  bool penaltiesEnabled;
  int maxSubs;
  Timer? _timer;

  // Undo stack implementation
  final List<String> _history = [];
  bool get canUndo => _history.isNotEmpty;

  MatchEngine({
    this.halfDuration = 45,
    this.extraTimeEnabled = false,
    this.penaltiesEnabled = false,
    this.maxSubs = 5,
  });

  void loadState(FootballMatchState newState) {
    state = newState;
    notifyListeners();
  }

  void _saveSnapshot() {
    _history.add(jsonEncode(state.toJson()));
  }

  void undo() {
    if (_history.isEmpty) return;
    String previousStateStr = _history.removeLast();
    state = FootballMatchState.fromJson(jsonDecode(previousStateStr));
    notifyListeners();
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  void toggleTimer() {
    if (state.isRunning) {
      _stopTimer();
    } else {
      _startTimer();
    }
  }

  void _startTimer() {
    if (state.phase == MatchPhase.fullTime) return;
    if (state.phase == MatchPhase.penalties) return; // Clock doesn't run in penalties

    if (state.phase == MatchPhase.preMatch) {
      endPhase();
      return;
    }

    state.isRunning = true;
    _timer = Timer.periodic(Duration(seconds: 1), (_) {
      if (state.phase == MatchPhase.firstHalf && state.seconds >= halfDuration * 60) {
        state.addedSeconds++;
      } else if (state.phase == MatchPhase.secondHalf && state.seconds >= (halfDuration * 2) * 60) {
        state.addedSeconds++;
      } else if (state.phase == MatchPhase.extraTimeFirst && state.seconds >= (halfDuration * 2 + 15) * 60) {
        state.addedSeconds++;
      } else if (state.phase == MatchPhase.extraTimeSecond && state.seconds >= (halfDuration * 2 + 30) * 60) {
        state.addedSeconds++;
      } else {
        state.seconds++;
      }
      notifyListeners();
    });
    notifyListeners();
  }

  void _stopTimer() {
    state.isRunning = false;
    _timer?.cancel();
    notifyListeners();
  }

  void endPhase() {
    _saveSnapshot();
    _stopTimer();
    MatchPhase next = MatchPhase.fullTime;

    switch (state.phase) {
      case MatchPhase.preMatch:
        next = MatchPhase.firstHalf;
        state.seconds = 0;
        state.addedSeconds = 0;
        _log(EventType.whistle, null, "Match Started", "Kick Off");
        break;
      case MatchPhase.firstHalf:
        next = MatchPhase.halfTime;
        _log(EventType.whistle, null, "Half Time", "End of First Half");
        break;
      case MatchPhase.halfTime:
        next = MatchPhase.secondHalf;
        state.seconds = halfDuration * 60;
        state.addedSeconds = 0;
        _log(EventType.whistle, null, "Second Half", "Kick Off");
        break;
      case MatchPhase.secondHalf:
        if (state.homeScore == state.awayScore && extraTimeEnabled) {
          next = MatchPhase.extraTimeFirst;
          state.seconds = (halfDuration * 2) * 60;
          state.addedSeconds = 0;
          _log(EventType.whistle, null, "Extra Time", "First Half Kick Off");
        } else if (state.homeScore == state.awayScore && penaltiesEnabled) {
          next = MatchPhase.penalties;
          _log(EventType.whistle, null, "Penalties", "Penalty Shootout Begins");
        } else {
          next = MatchPhase.fullTime;
          _log(EventType.whistle, null, "Full Time", "Match Ended");
        }
        break;
      case MatchPhase.extraTimeFirst:
        next = MatchPhase.extraTimeHalf;
        _log(EventType.whistle, null, "ET Half Time", "End of ET First Half");
        break;
      case MatchPhase.extraTimeHalf:
        next = MatchPhase.extraTimeSecond;
        state.seconds = (halfDuration * 2 + 15) * 60;
        state.addedSeconds = 0;
        _log(EventType.whistle, null, "ET Second Half", "Kick Off");
        break;
      case MatchPhase.extraTimeSecond:
        if (state.homeScore == state.awayScore && penaltiesEnabled) {
          next = MatchPhase.penalties;
          _log(EventType.whistle, null, "Penalties", "Penalty Shootout Begins");
        } else {
          next = MatchPhase.fullTime;
          _log(EventType.whistle, null, "Full Time", "Match Ended");
        }
        break;
      case MatchPhase.penalties:
        next = MatchPhase.fullTime;
        _log(EventType.whistle, null, "Full Time", "Penalty Shootout Ended");
        break;
      default:
        break;
    }
    state.phase = next;
    notifyListeners();
  }

  void processGoal(TeamSide side, MatchPlayer? scorer, MatchPlayer? assist) {
    _saveSnapshot();
    if (side == TeamSide.home) {
      state.homeScore++;
      if (scorer != null) scorer.goals++;
      if (assist != null) assist.assists++;
    } else {
      state.awayScore++;
      if (scorer != null) scorer.goals++;
      if (assist != null) assist.assists++;
    }

    _log(
      EventType.goal,
      side,
      "GOAL!",
      "\${scorer?.name ?? 'Unknown'} (\${assist != null ? 'ast. \${assist.name}' : 'Solo'})",
      icon: Icons.sports_soccer,
      color: Colors.green, // Fallback, replaced in UI
      playerId: scorer?.id,
      assistId: assist?.id,
    );
    HapticFeedback.heavyImpact();
    notifyListeners();
  }

  void processPenalty(TeamSide side, MatchPlayer? taker, bool scored) {
      _saveSnapshot();
      if (scored) {
          if (side == TeamSide.home) {
              state.homeTeam.penaltiesScored++;
          } else {
              state.awayTeam.penaltiesScored++;
          }
          _log(EventType.penaltyGoal, side, "Penalty Scored", "\${taker?.name ?? 'Unknown'}", icon: Icons.sports_soccer, color: Colors.green, playerId: taker?.id);
      } else {
          if (side == TeamSide.home) {
              state.homeTeam.penaltiesMissed++;
          } else {
              state.awayTeam.penaltiesMissed++;
          }
          _log(EventType.penaltyMiss, side, "Penalty Missed", "\${taker?.name ?? 'Unknown'}", icon: Icons.close, color: Colors.red, playerId: taker?.id);
      }

      // Auto-determine shootout winner based on Standard 5 kicks logic
      int homeScored = state.homeTeam.penaltiesScored;
      int homeMissed = state.homeTeam.penaltiesMissed;
      int awayScored = state.awayTeam.penaltiesScored;
      int awayMissed = state.awayTeam.penaltiesMissed;

      int homeKicksTaken = homeScored + homeMissed;
      int awayKicksTaken = awayScored + awayMissed;

      int homeKicksRemaining = 5 - homeKicksTaken;
      if (homeKicksRemaining < 0) homeKicksRemaining = 0;
      int awayKicksRemaining = 5 - awayKicksTaken;
      if (awayKicksRemaining < 0) awayKicksRemaining = 0;

      bool suddenDeath = homeKicksTaken >= 5 && awayKicksTaken >= 5;

      bool matchOver = false;
      if (!suddenDeath) {
          if (homeScored > awayScored + awayKicksRemaining) {
              matchOver = true;
          } else if (awayScored > homeScored + homeKicksRemaining) {
              matchOver = true;
          }
      } else {
          if (homeKicksTaken == awayKicksTaken) {
              if (homeScored != awayScored) {
                  matchOver = true;
              }
          }
      }

      if (matchOver) {
          endPhase();
      } else {
          notifyListeners();
      }
  }

  void processOffside(TeamSide side, MatchPlayer? player) {
      _saveSnapshot();
      _log(EventType.offside, side, "Offside", "\${player?.name ?? 'Unknown'}", icon: Icons.flag, color: Colors.orange, playerId: player?.id);
      notifyListeners();
  }

  void processFreeKick(TeamSide side, MatchPlayer? player) {
      _saveSnapshot();
      _log(EventType.freeKick, side, "Free Kick", "\${player?.name ?? 'Unknown'}", icon: Icons.sports_kabaddi, color: Colors.blue, playerId: player?.id);
      notifyListeners();
  }

  void processCard(TeamSide side, MatchPlayer player, EventType type, String reason) {
    _saveSnapshot();
    if (type == EventType.yellowCard) {
      player.yellowCards++;
      if (player.yellowCards >= 2) {
        _log(EventType.yellowCard, side, "2nd Yellow Card", "\${player.name} (Sent Off)", color: Colors.amber, playerId: player.id);
        _executeRedCard(side, player, "Second Booking");
      } else {
        _log(EventType.yellowCard, side, "Yellow Card", player.name, color: Colors.amber, playerId: player.id);
      }
    } else {
      _executeRedCard(side, player, reason);
    }
    notifyListeners();
  }

  void _executeRedCard(TeamSide side, MatchPlayer player, String reason) {
    player.redCards++;
    player.isSentOff = true;
    player.isOnPitch = false;
    _log(EventType.redCard, side, "Red Card", "\${player.name} - \$reason", color: Colors.red, playerId: player.id);
    HapticFeedback.heavyImpact();
  }

  bool processSubstitution(TeamSide side, MatchPlayer subOut, MatchPlayer subIn) {
    _saveSnapshot();
    final team = side == TeamSide.home ? state.homeTeam : state.awayTeam;

    if (team.substitutionsUsed >= maxSubs) {
        _history.removeLast(); // Revert snapshot if failed
        return false;
    }

    subOut.isOnPitch = false;
    subOut.isSubstitutedOut = true;
    subIn.isOnPitch = true;

    team.substitutionsUsed++;

    _log(
      EventType.substitution,
      side,
      "Substitution",
      "IN: \${subIn.name}\nOUT: \${subOut.name}",
      icon: Icons.compare_arrows,
      color: Colors.blue,
      subInId: subIn.id,
      subOutId: subOut.id,
    );
    notifyListeners();
    return true;
  }

  void _log(
    EventType type,
    TeamSide? side,
    String title,
    String subtitle, {
    IconData? icon,
    Color? color,
    String? playerId,
    String? assistId,
    String? subInId,
    String? subOutId,
  }) {
    int currentMin = state.seconds ~/ 60;
    int displayMin = currentMin;
    int added = 0;

    if (state.phase == MatchPhase.firstHalf && currentMin >= halfDuration) {
      displayMin = halfDuration;
      added = currentMin - halfDuration;
    } else if (state.phase == MatchPhase.secondHalf && currentMin >= halfDuration * 2) {
      displayMin = halfDuration * 2;
      added = currentMin - (halfDuration * 2);
    } else if (state.phase == MatchPhase.extraTimeFirst && currentMin >= halfDuration * 2 + 15) {
      displayMin = halfDuration * 2 + 15;
      added = currentMin - (halfDuration * 2 + 15);
    } else if (state.phase == MatchPhase.extraTimeSecond && currentMin >= halfDuration * 2 + 30) {
      displayMin = halfDuration * 2 + 30;
      added = currentMin - (halfDuration * 2 + 30);
    } else if (state.phase == MatchPhase.penalties) {
        displayMin = halfDuration * 2 + (extraTimeEnabled ? 30 : 0);
    }

    final event = MatchEvent(
      realMinute: currentMin,
      displayMinute: displayMin,
      addedMinute: added,
      type: type,
      side: side,
      title: title,
      subtitle: subtitle,
      icon: icon ?? Icons.info,
      color: color ?? Colors.white,
      playerId: playerId,
      assistId: assistId,
      subInId: subInId,
      subOutId: subOutId,
    );

    state.events.insert(0, event);
  }
}
