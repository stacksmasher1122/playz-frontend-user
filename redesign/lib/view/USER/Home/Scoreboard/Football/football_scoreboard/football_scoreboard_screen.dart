import 'dart:async';
import 'package:flutter/material.dart';
import 'package:redesign/theme/app_colors.dart';
import 'package:flutter/services.dart';
import '../football_setup/widgets/setup_models.dart' as setup;

// Internal Imports
import 'widgets/scoreboard_header.dart';
import 'widgets/event_feed.dart';
import 'widgets/scoreboard_controls.dart';
import 'widgets/goal_workflow.dart';
import 'widgets/card_workflow.dart';
import 'widgets/sub_workflow.dart';
import 'package:redesign/theme/responsive_helper.dart';

// ─────────────────────────────────────────────────────────────────────────────
// 🎨 THEME & CONSTANTS (Spotify Dark)
// ─────────────────────────────────────────────────────────────────────────────

const kBg = AppColors.background;
const kSurface = Color(0xFF121212);
const kSurfaceHighlight = Color(0xFF2A2A2A);
const kAccent = AppColors.accent;
const kGoal = Color(0xFF22C55E);
const kYellow = Color(0xFFFACC15);
const kRed = Color(0xFFEF4444);
const kTextPrimary = Color(0xFFFFFFFF);
const kTextSecondary = AppColors.muted;
const kTextMuted = Color(0xFF777777);

const kSuccess = Color(0xFF22C55E);
const kWarning = Color(0xFFFACC15);
const kDivider = Color(0xFF2A2A2A);

// ─────────────────────────────────────────────────────────────────────────────
// 🧠 PROFESSIONAL MATCH MODELS
// ─────────────────────────────────────────────────────────────────────────────

enum MatchPhase {
  preMatch,
  firstHalf,
  halfTime,
  secondHalf,
  fullTime,
  extraTimeFirst,
  extraTimeHalf,
  extraTimeSecond,
  penalties,
}

enum EventType {
  goal,
  yellowCard,
  redCard,
  substitution,
  whistle,
  varCheck,
  injuryTime,
}

enum TeamSide { home, away }

class MatchPlayer {
  final String id;
  final String name;
  final int number;

  // State
  bool isStarter;
  bool isOnPitch;
  bool isSubstitutedOut;
  bool isSentOff;

  // Stats
  int goals = 0;
  int assists = 0;
  int yellowCards = 0;
  int redCards = 0;

  MatchPlayer({
    required this.id,
    required this.name,
    this.number = 0,
    this.isStarter = false,
  }) : isOnPitch = isStarter,
       isSubstitutedOut = false,
       isSentOff = false;
}

class MatchTeam {
  final String id;
  final String name;
  final Color color;
  final List<MatchPlayer> squad;

  // Rule State
  int substitutionsUsed = 0;
  int substitutionWindowsUsed = 0; // Professional rule: 3 windows max

  MatchTeam({
    required this.id,
    required this.name,
    required this.color,
    required this.squad,
  });

  List<MatchPlayer> get pitchPlayers =>
      squad.where((p) => p.isOnPitch).toList();
  List<MatchPlayer> get benchPlayers => squad
      .where((p) => !p.isOnPitch && !p.isSubstitutedOut && !p.isSentOff)
      .toList();
}

class MatchEvent {
  final String id;
  final int realMinute; // Actual minute of game
  final int displayMinute; // 45, 90, etc.
  final int addedMinute; // +2, +4
  final EventType type;
  final TeamSide? side;
  final String title;
  final String subtitle;
  final String? playerId;
  final String? assistId;
  final String? subInId;
  final String? subOutId;
  final IconData icon;
  final Color color;

  MatchEvent({
    required this.realMinute,
    required this.displayMinute,
    this.addedMinute = 0,
    required this.type,
    this.side,
    required this.title,
    required this.subtitle,
    this.playerId,
    this.assistId,
    this.subInId,
    this.subOutId,
    required this.icon,
    required this.color,
  }) : id = DateTime.now().microsecondsSinceEpoch
           .toString(); // Should use UUID in prod

  String get timeLabel {
    if (addedMinute > 0) return "$displayMinute+$addedMinute'";
    return "$displayMinute'";
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// ⚙️ MATCH ENGINE (THE CORE)
// ─────────────────────────────────────────────────────────────────────────────

class MatchEngine extends ChangeNotifier {
  // Config
  final int halfDuration; // minutes
  final bool extraTimeEnabled;
  final bool penaltiesEnabled;
  final int maxSubs;

  // Teams
  late MatchTeam homeTeam;
  late MatchTeam awayTeam;

  // Unidirectional State Flow
  final ValueNotifier<int> seconds = ValueNotifier(0); // Raw seconds
  final ValueNotifier<int> addedSeconds = ValueNotifier(
    0,
  ); // Stoppage time accumulator
  final ValueNotifier<MatchPhase> phase = ValueNotifier(MatchPhase.preMatch);
  final ValueNotifier<bool> isRunning = ValueNotifier(false);
  final ValueNotifier<List<MatchEvent>> events = ValueNotifier([]);

  // Scores
  final ValueNotifier<int> homeScore = ValueNotifier(0);
  final ValueNotifier<int> awayScore = ValueNotifier(0);

  Timer? _timer;

  MatchEngine({
    required setup.Team home,
    required setup.Team away,
    this.halfDuration = 45,
    this.extraTimeEnabled = false,
    this.penaltiesEnabled = false,
    this.maxSubs = 5,
  }) {
    // Initialize Teams & Squads
    homeTeam = _initTeam(home);
    awayTeam = _initTeam(away);
  }

  MatchTeam _initTeam(setup.Team t) {
    // Logic to select starters vs bench (first 11 are starters for now)
    List<MatchPlayer> squad = [];
    for (int i = 0; i < t.players.length; i++) {
      squad.add(
        MatchPlayer(
          id: t.players[i].id,
          name: t.players[i].name,
          number: i + 1,
          isStarter: i < 11,
        ),
      );
    }
    // If no players, create dummy squad
    if (squad.isEmpty) {
      for (int i = 0; i < 16; i++) {
        squad.add(
          MatchPlayer(
            id: "p_$i",
            name: "Player ${i + 1}",
            number: i + 1,
            isStarter: i < 11,
          ),
        );
      }
    }

    return MatchTeam(id: t.id, name: t.name, color: t.color, squad: squad);
  }

  @override
  void dispose() {
    _timer?.cancel();
    seconds.dispose();
    addedSeconds.dispose();
    super.dispose();
  }

  // ─── CLOCK ENGINE ───

  void toggleTimer() {
    if (isRunning.value) {
      _stopTimer();
    } else {
      _startTimer();
    }
  }

  void _startTimer() {
    if (phase.value == MatchPhase.fullTime) return;

    if (phase.value == MatchPhase.preMatch) {
      endPhase(); // Start First Half
      return;
    }

    isRunning.value = true;
    _timer = Timer.periodic(Duration(seconds: 1), (_) {
      // Standard Time vs Stoppage Time Logic
      if (phase.value == MatchPhase.firstHalf &&
          seconds.value >= halfDuration * 60) {
        addedSeconds.value++;
      } else if (phase.value == MatchPhase.secondHalf &&
          seconds.value >= (halfDuration * 2) * 60) {
        addedSeconds.value++;
      } else {
        seconds.value++;
      }
    });
    notifyListeners();
  }

  void _stopTimer() {
    isRunning.value = false;
    _timer?.cancel();
    notifyListeners();
  }

  void endPhase() {
    _stopTimer();
    MatchPhase next = MatchPhase.fullTime;

    switch (phase.value) {
      case MatchPhase.preMatch:
        next = MatchPhase.firstHalf;
        seconds.value = 0;
        addedSeconds.value = 0;
        _log(EventType.whistle, null, "Match Started", "Kick Off");
        break;
      case MatchPhase.firstHalf:
        next = MatchPhase.halfTime;
        _log(EventType.whistle, null, "Half Time", "End of First Half");
        break;
      case MatchPhase.halfTime:
        next = MatchPhase.secondHalf;
        seconds.value = halfDuration * 60;
        addedSeconds.value = 0;
        _log(EventType.whistle, null, "Second Half", "Kick Off");
        break;
      case MatchPhase.secondHalf:
        // Check for Extra Time or End
        next = MatchPhase.fullTime;
        _log(EventType.whistle, null, "Full Time", "Match Ended");
        break;
      default:
        break;
    }
    phase.value = next;
    notifyListeners();
  }

  // ─── GAMEPLAY ACTIONS ───

  void processGoal(TeamSide side, MatchPlayer? scorer, MatchPlayer? assist) {
    if (side == TeamSide.home) {
      homeScore.value++;
      if (scorer != null) scorer.goals++;
      if (assist != null) assist.goals++; // Logic error fixed: assist.assists++
    } else {
      awayScore.value++;
      if (scorer != null) scorer.goals++;
    }

    _log(
      EventType.goal,
      side,
      "GOAL!",
      "${scorer?.name ?? 'Unknown'} (${assist != null ? 'ast. ${assist.name}' : 'Solo'})",
      icon: Icons.sports_soccer,
      color: kGoal,
      playerId: scorer?.id,
      assistId: assist?.id,
    );
    HapticFeedback.heavyImpact();
  }

  void processCard(
    TeamSide side,
    MatchPlayer player,
    EventType type,
    String reason,
  ) {
    if (type == EventType.yellowCard) {
      player.yellowCards++;
      if (player.yellowCards >= 2) {
        // Second Yellow -> Red Logiic
        _log(
          EventType.yellowCard,
          side,
          "2nd Yellow Card",
          "${player.name} (Sent Off)",
          color: kYellow,
          playerId: player.id,
        );
        _executeRedCard(side, player, "Second Booking");
      } else {
        _log(
          EventType.yellowCard,
          side,
          "Yellow Card",
          player.name,
          color: kYellow,
          playerId: player.id,
        );
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
    _log(
      EventType.redCard,
      side,
      "Red Card",
      "${player.name} - $reason",
      color: kRed,
      playerId: player.id,
    );
    HapticFeedback.heavyImpact();
  }

  bool processSubstitution(
    TeamSide side,
    MatchPlayer subOut,
    MatchPlayer subIn,
  ) {
    final team = side == TeamSide.home ? homeTeam : awayTeam;

    // Validate Rules
    if (team.substitutionsUsed >= maxSubs) return false;

    // Execute Sub
    subOut.isOnPitch = false;
    subOut.isSubstitutedOut = true;
    subIn.isOnPitch = true;

    team.substitutionsUsed++;

    _log(
      EventType.substitution,
      side,
      "Substitution",
      "IN: ${subIn.name}\nOUT: ${subOut.name}",
      icon: Icons.compare_arrows,
      color: kAccent,
      subInId: subIn.id,
      subOutId: subOut.id,
    );
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
    // Calculate Display Time
    int currentMin = seconds.value ~/ 60;
    int displayMin = currentMin;
    int added = 0;

    if (phase.value == MatchPhase.firstHalf && currentMin >= halfDuration) {
      displayMin = halfDuration;
      added = currentMin - halfDuration;
    } else if (phase.value == MatchPhase.secondHalf &&
        currentMin >= halfDuration * 2) {
      displayMin = halfDuration * 2;
      added = currentMin - (halfDuration * 2);
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
      color: color ?? kTextPrimary,
      playerId: playerId,
      assistId: assistId,
      subInId: subInId,
      subOutId: subOutId,
    );

    List<MatchEvent> list = List.from(events.value);
    list.insert(0, event);
    events.value = list;
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// 📱 MAIN SCREEN UI
// ─────────────────────────────────────────────────────────────────────────────

class FootballScoreboardScreen extends StatefulWidget {
  final setup.Team homeTeam;
  final setup.Team awayTeam;
  final int durationMinutes;

  FootballScoreboardScreen({
    super.key,
    required this.homeTeam,
    required this.awayTeam,
    required this.durationMinutes,
  });

  @override
  State<FootballScoreboardScreen> createState() =>
      _FootballScoreboardScreenState();
}

class _FootballScoreboardScreenState extends State<FootballScoreboardScreen> {
  late MatchEngine _engine;
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _engine = MatchEngine(
      home: widget.homeTeam,
      away: widget.awayTeam,
      halfDuration: widget.durationMinutes,
    );
  }

  @override
  void dispose() {
    _engine.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    ResponsiveHelper.init(context);
    return Scaffold(
      backgroundColor: kBg,
      body: SafeArea(
        child: Column(
          children: [
            ScoreboardHeader(engine: _engine),
            Container(height: ResponsiveHelper.h(1), color: kDivider),
            Expanded(
              child: CustomScrollView(
                controller: _scrollController,
                slivers: [EventFeed(engine: _engine)],
              ),
            ),
            ScoreboardControls(
              engine: _engine,
              showGoalModal: _showGoalModal,
              showCardModal: _showCardModal,
              showSubModal: _showSubModal,
            ),
          ],
        ),
      ),
    );
  }

  // ─── MODALS (PROFESSIONAL WORKFLOWS) ───

  void _showGoalModal() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (ctx) => GoalWorkflow(engine: _engine),
    );
  }

  void _showCardModal() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (ctx) => CardWorkflow(engine: _engine),
    );
  }

  void _showSubModal() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (ctx) => SubWorkflow(engine: _engine),
    );
  }
}
