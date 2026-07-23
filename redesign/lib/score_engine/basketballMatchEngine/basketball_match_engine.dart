import '../../model/User_Models/Home_Models/Scoreboard_Model/Basketball/basketball_state_models.dart';

class BasketballMatchEngine {
  late BasketballMatchState _state;
  final List<BasketballMatchState> _history = [];

  BasketballMatchEngine({
    required BasketballMatchConfig config,
    required List<BasketballPlayer> homeRoster,
    required List<BasketballPlayer> awayRoster,
    required String homeTeamName,
    required String awayTeamName,
  }) {
    _state = BasketballMatchState(
      config: config,
      homeTeam: BasketballTeamState(
        teamName: homeTeamName,
        timeoutsRemaining: config.timeoutsPerTeam,
        roster: homeRoster,
      ),
      awayTeam: BasketballTeamState(
        teamName: awayTeamName,
        timeoutsRemaining: config.timeoutsPerTeam,
        roster: awayRoster,
      ),
      gameClockSeconds: config.quarterLengthMinutes * 60,
      shotClockSeconds: config.shotClockSeconds,
      phase: MatchPhase.setup,
      quarterScores: {
        1: {'home': 0, 'away': 0},
        2: {'home': 0, 'away': 0},
        3: {'home': 0, 'away': 0},
        4: {'home': 0, 'away': 0},
      },
    );
  }

  BasketballMatchState get state => _state;
  bool get canUndo => _history.isNotEmpty;

  void _saveSnapshot() {
    _history.add(BasketballMatchState.fromJson(_state.toJson()));
  }

  void undo() {
    if (_history.isNotEmpty) {
      _state = _history.removeLast();
    }
  }

  void restoreState(Map<String, dynamic> json) {
    _state = BasketballMatchState.fromJson(json);
    _history.clear();
  }

  void setPhase(MatchPhase newPhase) {
    _saveSnapshot();
    _state = _state.copyWith(phase: newPhase);
  }

  void startMatch({required String wonTipOffTeamId, required String possessionArrowTeamId}) {
     _saveSnapshot();
     _state = _state.copyWith(
       phase: MatchPhase.live,
       possessionTeamId: wonTipOffTeamId,
       possessionArrowTeamId: possessionArrowTeamId,
     );
  }

  void setActivePlayers(String teamId, List<String> onCourtIds) {
    _saveSnapshot();
    if (teamId == 'home') {
      _state = _state.copyWith(homeTeam: _state.homeTeam.copyWith(onCourtIds: onCourtIds));
    } else {
      _state = _state.copyWith(awayTeam: _state.awayTeam.copyWith(onCourtIds: onCourtIds));
    }
  }

  void dispatch(BasketballEvent event) {
    _saveSnapshot();

    // Default clock behavior: stop clock on most dispatches (like fouls, timeouts) unless it's just a made bucket mid-quarter
    if (event.type == EventType.timeout || event.type == EventType.foul || event.type == EventType.substitution || event.type == EventType.freeThrowMade || event.type == EventType.freeThrowMissed) {
      _state = _state.copyWith(isClockRunning: false);
    }

    switch (event.type) {
      case EventType.fieldGoalMade:
        _handleScore(event.teamId!, event.playerId!, event.points!);
        _resetShotClock();
        _togglePossession(event.teamId!); // Opposing team gets ball after score
        break;
      case EventType.fieldGoalMissed:
        // Shot clock resets on defensive rebound, but engine doesn't automatically know who rebounded.
        // We leave it to the scorer to manually reset shot clock or swap possession.
        break;
      case EventType.freeThrowMade:
        _handleScore(event.teamId!, event.playerId!, 1, isFreeThrow: true);
        break;
      case EventType.freeThrowMissed:
        break;
      case EventType.foul:
        _handleFoul(event.teamId!, event.playerId!, event.foulType!);
        break;
      case EventType.timeout:
        _handleTimeout(event.teamId!);
        break;
      case EventType.substitution:
        // Subs are typically handled via UI updating active roster and calling setActivePlayers, but we log it here if needed
        break;
      case EventType.quarterEnd:
        _handleQuarterEnd();
        break;
      case EventType.jumpBall:
        _resolveJumpBall();
        break;
    }

    _checkMatchEnd();
  }

  void _handleScore(String teamId, String playerId, int points, {bool isFreeThrow = false}) {
     if (teamId == 'home') {
       final newRoster = _state.homeTeam.roster.map((p) {
         if (p.id == playerId) {
           return p.copyWith(
             points: p.points + points,
             twoPointersMade: p.twoPointersMade + (points == 2 && !isFreeThrow ? 1 : 0),
             threePointersMade: p.threePointersMade + (points == 3 && !isFreeThrow ? 1 : 0),
             freeThrowsMade: p.freeThrowsMade + (isFreeThrow ? 1 : 0),
           );
         }
         return p;
       }).toList();

       final newScore = _state.homeTeam.score + points;

       Map<int, Map<String, int>> newQScores = Map.from(_state.quarterScores);
       newQScores[_state.currentQuarter] = Map.from(newQScores[_state.currentQuarter] ?? {'home': 0, 'away': 0});
       newQScores[_state.currentQuarter]!['home'] = (newQScores[_state.currentQuarter]!['home'] ?? 0) + points;

       _state = _state.copyWith(
         homeTeam: _state.homeTeam.copyWith(
           score: newScore,
           roster: newRoster,
         ),
         quarterScores: newQScores,
       );
     } else {
       final newRoster = _state.awayTeam.roster.map((p) {
         if (p.id == playerId) {
           return p.copyWith(
             points: p.points + points,
             twoPointersMade: p.twoPointersMade + (points == 2 && !isFreeThrow ? 1 : 0),
             threePointersMade: p.threePointersMade + (points == 3 && !isFreeThrow ? 1 : 0),
             freeThrowsMade: p.freeThrowsMade + (isFreeThrow ? 1 : 0),
           );
         }
         return p;
       }).toList();

       final newScore = _state.awayTeam.score + points;

       Map<int, Map<String, int>> newQScores = Map.from(_state.quarterScores);
       newQScores[_state.currentQuarter] = Map.from(newQScores[_state.currentQuarter] ?? {'home': 0, 'away': 0});
       newQScores[_state.currentQuarter]!['away'] = (newQScores[_state.currentQuarter]!['away'] ?? 0) + points;

       _state = _state.copyWith(
         awayTeam: _state.awayTeam.copyWith(
           score: newScore,
           roster: newRoster,
         ),
         quarterScores: newQScores,
       );
     }
  }

  void _handleFoul(String teamId, String playerId, FoulType type) {
      if (_state.config.mode == MatchMode.friendly && (type == FoulType.technical || type == FoulType.flagrant)) {
         return; // Gated to professional mode
      }

      BasketballTeamState teamState = teamId == 'home' ? _state.homeTeam : _state.awayTeam;

      final newRoster = teamState.roster.map((p) {
         if (p.id == playerId) {
            int newFouls = p.fouls + 1;
            int newTechs = p.technicalFouls + (type == FoulType.technical ? 1 : 0);

            bool isFouledOut = false;
            bool isEjected = false;

            if (_state.config.mode == MatchMode.professional) {
               isFouledOut = newFouls >= _state.config.foulOutLimit;
               isEjected = newTechs >= 2 || type == FoulType.flagrant; // simplified flagrant ejection rule
            }

            return p.copyWith(
              fouls: newFouls,
              technicalFouls: newTechs,
              isFouledOut: isFouledOut,
              isEjected: isEjected,
            );
         }
         return p;
      }).toList();

      int newTeamFouls = teamState.teamFoulsInQuarter + 1;
      bool isInBonus = newTeamFouls >= _state.config.bonusFoulLimit;

      teamState = teamState.copyWith(
         roster: newRoster,
         teamFoulsInQuarter: newTeamFouls,
         isInBonus: isInBonus,
      );

      if (teamId == 'home') {
         _state = _state.copyWith(homeTeam: teamState);
      } else {
         _state = _state.copyWith(awayTeam: teamState);
      }
  }

  void _handleTimeout(String teamId) {
      if (teamId == 'home') {
          _state = _state.copyWith(
             homeTeam: _state.homeTeam.copyWith(
                timeoutsRemaining: _state.homeTeam.timeoutsRemaining > 0 ? _state.homeTeam.timeoutsRemaining - 1 : 0
             )
          );
      } else {
          _state = _state.copyWith(
             awayTeam: _state.awayTeam.copyWith(
                timeoutsRemaining: _state.awayTeam.timeoutsRemaining > 0 ? _state.awayTeam.timeoutsRemaining - 1 : 0
             )
          );
      }
  }

  void _handleQuarterEnd() {
      _state = _state.copyWith(
          isClockRunning: false,
          gameClockSeconds: 0,
          shotClockSeconds: 0,
          homeTeam: _state.homeTeam.copyWith(teamFoulsInQuarter: 0, isInBonus: false),
          awayTeam: _state.awayTeam.copyWith(teamFoulsInQuarter: 0, isInBonus: false),
      );
      _checkMatchEnd();
  }

  void _resolveJumpBall() {
      // Toggle possession arrow
      String newArrow = _state.possessionArrowTeamId == 'home' ? 'away' : 'home';
      _state = _state.copyWith(
         possessionTeamId: _state.possessionArrowTeamId,
         possessionArrowTeamId: newArrow,
      );
      _resetShotClock();
  }

  void _togglePossession(String scoringTeamId) {
      String newPossession = scoringTeamId == 'home' ? 'away' : 'home';
      _state = _state.copyWith(possessionTeamId: newPossession);
  }

  void _resetShotClock() {
      _state = _state.copyWith(shotClockSeconds: _state.config.shotClockSeconds);
  }

  // Scorer manual overrides
  void updateGameClock(int seconds, {bool isRunning = false}) {
     _state = _state.copyWith(gameClockSeconds: seconds, isClockRunning: isRunning);
  }

  void updateShotClock(int seconds) {
     _state = _state.copyWith(shotClockSeconds: seconds);
  }

  void setPossession(String teamId) {
     _saveSnapshot();
     _state = _state.copyWith(possessionTeamId: teamId);
  }

  void resetShotClockManual() {
     _saveSnapshot();
     _resetShotClock();
  }

  void startNextQuarter() {
     _saveSnapshot();
     int nextQ = _state.currentQuarter + 1;
     int nextClock = nextQ > 4 ? _state.config.overtimeLengthMinutes * 60 : _state.config.quarterLengthMinutes * 60;

     _state = _state.copyWith(
        currentQuarter: nextQ,
        gameClockSeconds: nextClock,
        shotClockSeconds: _state.config.shotClockSeconds,
        phase: nextQ > 4 ? MatchPhase.overtime : MatchPhase.live,
        isClockRunning: false,
     );
  }

  void _checkMatchEnd() {
     if (_state.gameClockSeconds == 0) {
         if (_state.currentQuarter >= 4) {
             if (_state.homeTeam.score != _state.awayTeam.score) {
                 // Game over
                 String winner = _state.homeTeam.score > _state.awayTeam.score ? 'Home won' : 'Away won';
                 _state = _state.copyWith(
                    phase: MatchPhase.completed,
                    matchResult: winner,
                 );
             } else {
                 // Tie at end of Q4 or OT -> needs another OT
                 _state = _state.copyWith(phase: MatchPhase.quarterBreak); // wait for startNextQuarter
             }
         } else {
             // End of Q1, Q2, Q3
             _state = _state.copyWith(phase: _state.currentQuarter == 2 ? MatchPhase.halfTime : MatchPhase.quarterBreak);
         }
     }
  }

  void completeMatchManual(String result) {
     _saveSnapshot();
     _state = _state.copyWith(phase: MatchPhase.completed, matchResult: result);
  }

  Map<String, dynamic> generateMatchSummary() {
      List<Map<String, dynamic>> homeScorers = _state.homeTeam.roster.where((p) => p.points > 0 || p.fouls > 0).map((p) => {
         'name': p.name,
         'points': p.points,
         'fouls': p.fouls,
      }).toList();
      homeScorers.sort((a, b) => (b['points'] as int).compareTo(a['points'] as int));

      List<Map<String, dynamic>> awayScorers = _state.awayTeam.roster.where((p) => p.points > 0 || p.fouls > 0).map((p) => {
         'name': p.name,
         'points': p.points,
         'fouls': p.fouls,
      }).toList();
      awayScorers.sort((a, b) => (b['points'] as int).compareTo(a['points'] as int));

      return {
         'winner': _state.matchResult ?? 'Draw',
         'homeScore': _state.homeTeam.score,
         'awayScore': _state.awayTeam.score,
         'homeFouls': _state.homeTeam.roster.fold<int>(0, (sum, p) => sum + p.fouls),
         'awayFouls': _state.awayTeam.roster.fold<int>(0, (sum, p) => sum + p.fouls),
         'quarterScores': _state.quarterScores,
         'homeScorers': homeScorers,
         'awayScorers': awayScorers,
      };
  }
}
