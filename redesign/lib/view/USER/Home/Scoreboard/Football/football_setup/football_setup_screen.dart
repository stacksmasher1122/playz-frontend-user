import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:redesign/view/USER/Home/Scoreboard/Football/football_scoreboard/football_scoreboard_screen.dart'
    hide
        kBg,
        kSurface,
        kSurfaceHighlight,
        kAccent,
        kTextPrimary,
        kTextSecondary,
        kTextMuted,
        kSuccess,
        kWarning,
        kDivider;

// Widgets
import 'widgets/setup_constants.dart';
import 'widgets/setup_models.dart';
import 'widgets/setup_logic.dart';
import 'widgets/setup_header.dart';
import 'widgets/setup_quality_indicator.dart';
import 'widgets/setup_mode_toggle.dart';
import 'widgets/smart_presets_card.dart';
import 'widgets/setup_section_card.dart';
import 'widgets/team_row.dart';
import 'widgets/setup_controls.dart';
import 'widgets/tournament_type_selector.dart';
import 'widgets/engine_preview.dart';
import 'widgets/sticky_cta_button.dart';

class MatchSetupScreen extends StatefulWidget {
  const MatchSetupScreen({super.key});

  @override
  State<MatchSetupScreen> createState() => _MatchSetupScreenState();
}

class _MatchSetupScreenState extends State<MatchSetupScreen>
    with TickerProviderStateMixin {
  // ─── MASTER STATE ───
  MatchMode _mode = MatchMode.friendly;
  TournamentType _tournamentType = TournamentType.knockout;

  // ─── FRIENDLY STATE ───
  int _fPlayersPerSide = 7;
  int _fDuration = 20;
  bool _fRollingSubs = true;
  bool _fStats = true;
  bool _fCards = true;
  bool _fTimeline = true;

  // Result & Control
  bool _fAllowDraw = true;
  bool _fExtraTime = false;
  bool _fPenalties = false;
  TimerType _fTimerType = TimerType.countUp;
  bool _fManualControl = false;

  // Schedule
  DateTime _fDate = DateTime.now();
  TimeOfDay _fTime = const TimeOfDay(hour: 20, minute: 00);

  List<Team> _fTeams = [
    Team(name: 'Home FC', color: Colors.blueAccent, players: []),
    Team(name: 'Away United', color: Colors.redAccent, players: []),
  ];

  // ─── TOURNAMENT STATE ───
  String _tName = "Champions Cup 2026";
  String _tRegion = "International";
  String _tSeason = "2026/27";
  int _tTeamCount = 8;
  List<Team> _tTeams = [];

  // Knockout Settings
  bool _kThirdPlace = false;
  bool _kSeeded = false;
  bool _kTwoLegged = false;

  // Tournament Match Settings
  int _tPlayersPerSide = 11;
  int _tDuration = 45;
  bool _tExtraTime = true;
  bool _tPenalties = true;
  bool _tAwayGoals = false;

  // League Settings
  bool _lRelegation = true;
  int _lRelegationSpots = 3;
  int _lSquadSize = 25;
  String _lFormation = "4-3-3 Holding";
  bool _lDoubleRound = true;

  // Hybrid Settings
  int _hGroupCount = 2;
  int _hQualifyPerGroup = 2;

  // Engines Data
  List<MatchFixture> _knockoutBracket = [];
  List<MatchFixture> _leagueFixtures = [];
  Map<String, List<Team>> _hybridGroups = {};

  // UI STATE
  bool _isGenerating = false;
  late AnimationController _pulseController;

  @override
  void initState() {
    super.initState();
    _pulseController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    )..repeat(reverse: true);
    _initTeams();
  }

  @override
  void dispose() {
    _pulseController.dispose();
    super.dispose();
  }

  void _initTeams() {
    _tTeams = List.generate(
      _tTeamCount,
      (i) => Team(
        name: "Team ${i + 1}",
        color: Colors.primaries[i % Colors.primaries.length],
        isReady: true,
      ),
    );
    _regenerateEngine();
  }

  void _regenerateEngine() {
    setState(() => _isGenerating = true);
    HapticFeedback.mediumImpact();
    Future.delayed(const Duration(milliseconds: 800), () {
      if (!mounted) return;
      setState(() {
        if (_tournamentType == TournamentType.knockout) {
          _knockoutBracket = BracketEngine.generateKnockout(
            _tTeams,
            _kThirdPlace,
          );
        }
        if (_tournamentType == TournamentType.league) {
          _leagueFixtures = LeagueEngine.generateRoundRobin(
            _tTeams,
            _lDoubleRound,
          );
        }
        if (_tournamentType == TournamentType.hybrid) {
          _generateHybridDraw();
        }
        _isGenerating = false;
      });
    });
  }

  void _generateHybridDraw() {
    _hybridGroups.clear();
    List<Team> shuffled = List.from(_tTeams)..shuffle();
    int perGroup = _tTeamCount ~/ _hGroupCount;
    for (int i = 0; i < _hGroupCount; i++) {
      String groupName = "Group ${String.fromCharCode(65 + i)}";
      _hybridGroups[groupName] = shuffled
          .skip(i * perGroup)
          .take(perGroup)
          .toList();
    }
  }

  void _applyFriendlyPreset() {
    setState(() {
      _fPlayersPerSide = 7;
      _fDuration = 20;
      _fRollingSubs = true;
      _fAllowDraw = true;
      _fStats = true;
    });
    HapticFeedback.lightImpact();
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text("Standard Friendly Rules Applied"),
        backgroundColor: kSuccess,
        duration: Duration(milliseconds: 1500),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kBg,
      body: SafeArea(
        child: Column(
          children: [
            SetupHeader(mode: _mode),
            Expanded(
              child: CustomScrollView(
                slivers: [
                  SliverToBoxAdapter(child: _buildProgressIndicatorWrapper()),
                  SliverToBoxAdapter(
                    child: SetupModeToggle(
                      mode: _mode,
                      onModeChanged: (m) => setState(() => _mode = m),
                    ),
                  ),
                  SliverToBoxAdapter(
                    child: AnimatedSwitcher(
                      duration: const Duration(milliseconds: 400),
                      switchInCurve: Curves.easeOutCubic,
                      switchOutCurve: Curves.easeInCubic,
                      transitionBuilder: (child, animation) {
                        return FadeTransition(
                          opacity: animation,
                          child: SlideTransition(
                            position: Tween<Offset>(
                              begin: const Offset(0.02, 0),
                              end: Offset.zero,
                            ).animate(animation),
                            child: child,
                          ),
                        );
                      },
                      child: _mode == MatchMode.friendly
                          ? _buildFriendlySection()
                          : _buildTournamentSection(),
                    ),
                  ),
                  const SliverToBoxAdapter(child: SizedBox(height: 120)),
                ],
              ),
            ),
            StickyCtaButton(
              mode: _mode,
              isActive: _isCtaActive(),
              onTap: () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (_) => FootballScoreboardScreen(
                      homeTeam: _fTeams[0],
                      awayTeam: _fTeams[1],
                      durationMinutes: _fDuration,
                    ),
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  bool _isCtaActive() {
    if (_mode == MatchMode.friendly) {
      return ValidationEngine.validateFriendly(_fTeams, _fPlayersPerSide);
    } else {
      return ValidationEngine.validateTournament(_tTeams, _tTeamCount) &&
          !_isGenerating;
    }
  }

  Widget _buildProgressIndicatorWrapper() {
    double progress = 0.0;
    if (_mode == MatchMode.friendly) {
      if (_fTeams.every((t) => t.hasMinPlayers)) progress += 0.5;
      if (_fDuration > 0) progress += 0.2;
      progress += 0.3;
    } else {
      if (_tTeams.isNotEmpty) progress += 0.4;
      if (!_isGenerating &&
          (_knockoutBracket.isNotEmpty ||
              _leagueFixtures.isNotEmpty ||
              _hybridGroups.isNotEmpty))
        progress += 0.6;
    }
    return SetupQualityIndicator(progress: progress);
  }

  Widget _buildFriendlySection() {
    return Column(
      key: const ValueKey('Friendly'),
      children: [
        SmartPresetsCard(onApply: _applyFriendlyPreset),
        SetupSectionCard(
          title: "TEAMS",
          icon: Icons.people_outline,
          isExpanded: true,
          child: Column(
            children: _fTeams
                .map((team) => TeamRow(team: team, onAddPlayer: () {}))
                .toList(),
          ),
        ),
        SetupSectionCard(
          title: "FORMAT",
          icon: Icons.tune,
          isExpanded: true,
          child: Column(
            children: [
              StepperControl(
                label: "Players per Side",
                value: _fPlayersPerSide,
                onChanged: (v) => setState(() => _fPlayersPerSide = v),
                min: 3,
                max: 11,
              ),
              const SizedBox(height: 16),
              StepperControl(
                label: "Half Duration (mins)",
                value: _fDuration,
                onChanged: (v) => setState(() => _fDuration = v),
                step: 5,
              ),
            ],
          ),
        ),
        SetupSectionCard(
          title: "RULES & CONTROL",
          icon: Icons.gavel,
          isExpanded: false,
          child: Column(
            children: [
              SetupSwitch(
                label: "Rolling Substitutions",
                value: _fRollingSubs,
                onChanged: (v) => setState(() => _fRollingSubs = v),
              ),
              SetupSwitch(
                label: "Allow Draw",
                value: _fAllowDraw,
                onChanged: (v) => setState(() => _fAllowDraw = v),
              ),
              if (!_fAllowDraw) ...[
                SetupSwitch(
                  label: "Extra Time",
                  value: _fExtraTime,
                  onChanged: (v) => setState(() => _fExtraTime = v),
                ),
                SetupSwitch(
                  label: "Penalties",
                  value: _fPenalties,
                  onChanged: (v) => setState(() => _fPenalties = v),
                ),
              ],
              const Divider(color: kDivider, height: 24),
              SetupSwitch(
                label: "Manual Match Control",
                value: _fManualControl,
                onChanged: (v) => setState(() => _fManualControl = v),
              ),
              const SizedBox(height: 16),
              SegmentedControl(
                options: const ["Count Up", "Countdown"],
                selectedIndex: _fTimerType == TimerType.countUp ? 0 : 1,
                onSelect: (i) => setState(
                  () => _fTimerType = i == 0
                      ? TimerType.countUp
                      : TimerType.countDown,
                ),
              ),
            ],
          ),
        ),
        SetupSectionCard(
          title: "TRACKING",
          icon: Icons.bar_chart,
          isExpanded: false,
          child: Column(
            children: [
              SetupSwitch(
                label: "Track Player Stats",
                value: _fStats,
                onChanged: (v) => setState(() => _fStats = v),
              ),
              SetupSwitch(
                label: "Match Timeline",
                value: _fTimeline,
                onChanged: (v) => setState(() => _fTimeline = v),
              ),
              SetupSwitch(
                label: "Cards (Yellow/Red)",
                value: _fCards,
                onChanged: (v) => setState(() => _fCards = v),
              ),
            ],
          ),
        ),
        SetupSectionCard(
          title: "SCHEDULE",
          icon: Icons.calendar_today,
          child: Row(
            children: [
              Expanded(
                child: Text(
                  "Starts in ~${_fTime.hour - TimeOfDay.now().hour} hours",
                  style: const TextStyle(
                    color: kAccent,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              Text(
                "${_fDate.day}/${_fDate.month} • ${_fTime.format(context)}",
                style: const TextStyle(color: kTextPrimary),
              ),
            ],
          ),
        ),
        _buildFriendlyPreview(),
      ],
    );
  }

  Widget _buildTournamentSection() {
    return Column(
      key: const ValueKey('Tournament'),
      children: [
        TournamentTypeSelector(
          selectedType: _tournamentType,
          onTypeChanged: (type) {
            setState(() {
              _tournamentType = type;
              _regenerateEngine();
            });
          },
        ),
        const SizedBox(height: 24),
        AnimatedSwitcher(
          duration: const Duration(milliseconds: 400),
          child: _buildTournamentEngineUI(),
        ),
      ],
    );
  }

  Widget _buildTournamentEngineUI() {
    return Column(
      key: ValueKey(_tournamentType),
      children: [
        SetupSectionCard(
          title: "IDENTITY",
          icon: Icons.badge,
          child: Column(
            children: [
              SetupTextField(label: "Tournament Name", initialValue: _tName),
              const SizedBox(height: 12),
              Row(
                children: [
                  Expanded(
                    child: SetupTextField(
                      label: "Season",
                      initialValue: _tSeason,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: SetupTextField(
                      label: "Region",
                      initialValue: _tRegion,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              const SetupTextField(
                label: "Host Name",
                initialValue: "Official Organizer",
              ),
            ],
          ),
        ),
        SetupSectionCard(
          title: "MATCH FORMAT",
          icon: Icons.tune,
          child: Column(
            children: [
              StepperControl(
                label: "Players per Team",
                value: _tPlayersPerSide,
                onChanged: (v) => setState(() => _tPlayersPerSide = v),
                min: 3,
                max: 11,
              ),
              const SizedBox(height: 16),
              StepperControl(
                label: "Half Duration (mins)",
                value: _tDuration,
                onChanged: (v) => setState(() => _tDuration = v),
                step: 5,
              ),
            ],
          ),
        ),
        SetupSectionCard(
          title: "STRUCTURE",
          icon: Icons.settings_suggest,
          child: Column(
            children: [
              StepperControl(
                label: "Total Teams",
                value: _tTeamCount,
                onChanged: (v) {
                  setState(() => _tTeamCount = v);
                  _initTeams();
                },
                min: 2,
                max: 64,
              ),
              if (_tournamentType == TournamentType.league) ...[
                const SizedBox(height: 16),
                StepperControl(
                  label: "Relegation Spots",
                  value: _lRelegationSpots,
                  onChanged: (v) => setState(() => _lRelegationSpots = v),
                ),
                const SizedBox(height: 16),
                SetupSwitch(
                  label: "Double Round Robin",
                  value: _lDoubleRound,
                  onChanged: (v) {
                    setState(() => _lDoubleRound = v);
                    _regenerateEngine();
                  },
                ),
              ],
              if (_tournamentType == TournamentType.hybrid) ...[
                const SizedBox(height: 16),
                StepperControl(
                  label: "Number of Groups",
                  value: _hGroupCount,
                  onChanged: (v) {
                    setState(() => _hGroupCount = v);
                    _regenerateEngine();
                  },
                  min: 2,
                  max: 8,
                ),
                const SizedBox(height: 16),
                StepperControl(
                  label: "Qualify per Group",
                  value: _hQualifyPerGroup,
                  onChanged: (v) => setState(() => _hQualifyPerGroup = v),
                  min: 1,
                  max: 4,
                ),
              ],
            ],
          ),
        ),
        SetupSectionCard(
          title: "TOURNAMENT RULES",
          icon: Icons.gavel,
          isExpanded: false,
          child: Column(
            children: [
              SetupSwitch(
                label: "Extra Time",
                value: _tExtraTime,
                onChanged: (v) => setState(() => _tExtraTime = v),
              ),
              SetupSwitch(
                label: "Penalties",
                value: _tPenalties,
                onChanged: (v) => setState(() => _tPenalties = v),
              ),
              if (_tournamentType == TournamentType.knockout) ...[
                const Divider(color: kDivider, height: 24),
                SetupSwitch(
                  label: "Third Place Playoff",
                  value: _kThirdPlace,
                  onChanged: (v) {
                    setState(() => _kThirdPlace = v);
                    _regenerateEngine();
                  },
                ),
                SetupSwitch(
                  label: "Seeded Draw",
                  value: _kSeeded,
                  onChanged: (v) => setState(() => _kSeeded = v),
                ),
                SetupSwitch(
                  label: "Two-Legged Ties",
                  value: _kTwoLegged,
                  onChanged: (v) => setState(() => _kTwoLegged = v),
                ),
                if (_kTwoLegged)
                  SetupSwitch(
                    label: "Away Goals Rule",
                    value: _tAwayGoals,
                    onChanged: (v) => setState(() => _tAwayGoals = v),
                  ),
              ],
            ],
          ),
        ),
        if (_tournamentType == TournamentType.league)
          SetupSectionCard(
            title: "LEAGUE SETTINGS",
            icon: Icons.table_chart,
            isExpanded: false,
            child: Column(
              children: [
                SetupSwitch(
                  label: "Relegation System",
                  value: _lRelegation,
                  onChanged: (v) => setState(() => _lRelegation = v),
                ),
                if (_lRelegation) ...[
                  const SizedBox(height: 12),
                  StepperControl(
                    label: "Relegation Spots",
                    value: _lRelegationSpots,
                    onChanged: (v) => setState(() => _lRelegationSpots = v),
                    min: 1,
                    max: 4,
                  ),
                ],
                const SizedBox(height: 16),
                StepperControl(
                  label: "Squad Size",
                  value: _lSquadSize,
                  onChanged: (v) => setState(() => _lSquadSize = v),
                  min: 11,
                  max: 40,
                ),
                const SizedBox(height: 16),
                SetupTextField(
                  label: "Teams Formation",
                  initialValue: _lFormation,
                ),
                const SizedBox(height: 16),
                SetupSwitch(
                  label: "Double Round Robin",
                  value: _lDoubleRound,
                  onChanged: (v) {
                    setState(() => _lDoubleRound = v);
                    _regenerateEngine();
                  },
                ),
              ],
            ),
          ),
        SetupSectionCard(
          title: "ENGINE PREVIEW",
          icon: Icons.visibility,
          child: _isGenerating
              ? const Center(
                  child: Padding(
                    padding: EdgeInsets.all(24),
                    child: CircularProgressIndicator(color: kAccent),
                  ),
                )
              : EnginePreview(
                  tournamentType: _tournamentType,
                  knockoutBracket: _knockoutBracket,
                  leagueFixtures: _leagueFixtures,
                  hybridGroups: _hybridGroups,
                ),
        ),
        _buildSystemCheck(),
      ],
    );
  }

  Widget _buildSystemCheck() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: kSurfaceHighlight,
          borderRadius: BorderRadius.circular(16),
        ),
        child: Column(
          children: [
            _buildCheckItem("Format Validated", true),
            _buildCheckItem("Schedule Optimized", !_isGenerating),
            _buildCheckItem("Teams Ready", _tTeams.isNotEmpty),
          ],
        ),
      ),
    );
  }

  Widget _buildCheckItem(String label, bool checked) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        children: [
          Icon(
            checked ? Icons.check_circle : Icons.circle_outlined,
            color: checked ? kSuccess : kTextMuted,
            size: 16,
          ),
          const SizedBox(width: 8),
          Text(
            label,
            style: TextStyle(
              color: checked ? kTextPrimary : kTextMuted,
              fontSize: 13,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFriendlyPreview() {
    bool valid = ValidationEngine.validateFriendly(_fTeams, _fPlayersPerSide);
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: valid ? kAccentDim.withOpacity(0.1) : kSurfaceHighlight,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: valid ? kSuccess : kWarning.withOpacity(0.3),
          ),
        ),
        child: Column(
          children: [
            _buildCheckItem(
              "Teams have min 7 players",
              _fTeams.every((t) => t.hasMinPlayers),
            ),
            _buildCheckItem(
              "Format configured (${_fPlayersPerSide}v${_fPlayersPerSide})",
              true,
            ),
            _buildCheckItem("Rules set", true),
          ],
        ),
      ),
    );
  }
}
