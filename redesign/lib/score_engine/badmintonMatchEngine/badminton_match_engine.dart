import 'package:redesign/model/User_Models/Home_Models/Scoreboard_Model/badminton_state_models.dart';

abstract class BadmintonEvent {}

class PointEvent extends BadmintonEvent {
  final PlayerSide side;
  final String? pointType; // Optional point type like SMASH, NET, ERROR, let, service_fault
  PointEvent({required this.side, this.pointType});
}

class IntervalEvent extends BadmintonEvent {}

class SwapEndsEvent extends BadmintonEvent {}

class ConductEvent extends BadmintonEvent {
  final PlayerSide side;
  final String conductType; // warning, fault, disqualify
  ConductEvent({required this.side, required this.conductType});
}

class RetireEvent extends BadmintonEvent {
  final PlayerSide retiringSide;
  RetireEvent({required this.retiringSide});
}

class BadmintonMatchEngine {
  BadmintonMatchState _state;
  final List<BadmintonMatchState> _history = [];

  BadmintonMatchEngine(this._state) {
    if (_state.games.isEmpty) {
      _state = _state.copyWith(
        games: [BadmintonGame()],
      );
    }
  }

  BadmintonMatchState get state => _state;
  List<BadmintonMatchState> get history => List.unmodifiable(_history);

  void _saveSnapshot() {
    _history.add(_state);
  }

  bool get canUndo => _history.isNotEmpty;

  void undo() {
    if (canUndo) {
      _state = _history.removeLast();
    }
  }

  void startMedicalTimeout() {
    _saveSnapshot();
    _state = _state.copyWith(status: MatchStatus.timeout);
  }

  void resumeFromTimeout() {
    _saveSnapshot();
    _state = _state.copyWith(status: MatchStatus.inProgress);
  }

  void retireMatch(PlayerSide retiringSide) {
    _saveSnapshot();
    _state = _state.copyWith(
      status: MatchStatus.completed,
      matchWinner: retiringSide == PlayerSide.sideA ? PlayerSide.sideB : PlayerSide.sideA,
    );
  }

  void dispatch(BadmintonEvent event) {
    _saveSnapshot();
    if (event is PointEvent) {
      if (event.pointType == 'let') {
        // Let = replay, no score change
      } else if (event.pointType == 'service_fault') {
        // B4 Fix: Service fault = point to receiving side
        final receivingSide = _state.servingSide == PlayerSide.sideA
            ? PlayerSide.sideB
            : PlayerSide.sideA;
        _handlePoint(receivingSide);
      } else {
        _handlePoint(event.side);
      }
    } else if (event is IntervalEvent) {
      _handleInterval();
    } else if (event is SwapEndsEvent) {
      _handleSwapEnds();
    } else if (event is ConductEvent) {
      _handleConduct(event);
    } else if (event is RetireEvent) {
      _state = _state.copyWith(
        status: MatchStatus.completed,
        matchWinner: event.retiringSide == PlayerSide.sideA ? PlayerSide.sideB : PlayerSide.sideA,
      );
    }
  }

  void _handleConduct(ConductEvent event) {
    if (event.conductType == 'fault') {
      // Award point to opponent
      _handlePoint(event.side == PlayerSide.sideA ? PlayerSide.sideB : PlayerSide.sideA);
    } else if (event.conductType == 'disqualify') {
      // Disqualify team
      _state = _state.copyWith(
        status: MatchStatus.completed,
        matchWinner: event.side == PlayerSide.sideA ? PlayerSide.sideB : PlayerSide.sideA,
      );
    }
    // Warning just logs, handled by controller
  }

  void _handlePoint(PlayerSide winningSide) {
    if (_state.status == MatchStatus.completed) return;

    // Status update if this is the first point
    var currentStatus = _state.status;
    if (currentStatus == MatchStatus.notStarted) {
      currentStatus = MatchStatus.inProgress;
    }

    int newScoreA = _state.currentScoreA;
    int newScoreB = _state.currentScoreB;
    PlayerSide newServingSide = _state.servingSide;
    int newServerIndexA = _state.serverIndexA;
    int newServerIndexB = _state.serverIndexB;

    bool isDoubles = _state.teamA.length == 2;

    if (winningSide == PlayerSide.sideA) {
      newScoreA++;
      if (_state.servingSide != PlayerSide.sideA) {
        newServingSide = PlayerSide.sideA;
      } else if (isDoubles) {
        // B5 Fix: Serving side won point in doubles → partners swap courts (serverIndex toggles)
        newServerIndexA = (_state.serverIndexA + 1) % 2;
      }
    } else {
      newScoreB++;
      if (_state.servingSide != PlayerSide.sideB) {
        newServingSide = PlayerSide.sideB;
      } else if (isDoubles) {
        // B5 Fix: Serving side won point in doubles → partners swap courts
        newServerIndexB = (_state.serverIndexB + 1) % 2;
      }
    }

    // Determine Service Court based on score
    int relevantScore = (newServingSide == PlayerSide.sideA) ? newScoreA : newScoreB;
    ServiceCourt newCourt = (relevantScore % 2 == 0) ? ServiceCourt.right : ServiceCourt.left;

    bool hasEndsChangedDecider = _state.hasEndsChangedDecider;
    bool endsSwapped = _state.endsSwapped;

    // B8 Fix: Check for mid-deciding-game 11-point swap
    if (_state.config.endsChangeEnabled && !_state.hasEndsChangedDecider) {
      final isDecidingGame = _state.currentGameIndex == (_state.config.gamesToWin * 2 - 2);
      if (isDecidingGame) {
        int swapThreshold = (_state.config.pointsToWin / 2).ceil();
        if (newScoreA == swapThreshold || newScoreB == swapThreshold) {
          hasEndsChangedDecider = true;
          endsSwapped = !endsSwapped;
        }
      }
    }

    _state = _state.copyWith(
      currentScoreA: newScoreA,
      currentScoreB: newScoreB,
      servingSide: newServingSide,
      serverIndexA: newServerIndexA,
      serverIndexB: newServerIndexB,
      serviceCourt: newCourt,
      hasEndsChangedDecider: hasEndsChangedDecider,
      endsSwapped: endsSwapped,
      status: currentStatus,
    );

    // Check interval
    if (_state.config.intervalsEnabled && !_state.hasIntervalOccurred) {
      int intervalThreshold = (_state.config.pointsToWin / 2).ceil();
      if (_state.currentScoreA == intervalThreshold || _state.currentScoreB == intervalThreshold) {
        _state = _state.copyWith(hasIntervalOccurred: true);
      }
    }

    // Check end of game
    _checkGameEnd();
  }

  void _handleInterval() {
    // Purely marker, ui handles timer
  }

  void _handleSwapEnds() {
    _state = _state.copyWith(
      hasEndsChangedDecider: true,
      endsSwapped: !_state.endsSwapped,
    );
  }

  void _checkGameEnd() {
    int scoreA = _state.currentScoreA;
    int scoreB = _state.currentScoreB;
    int toWin = _state.config.pointsToWin;
    int cap = _state.config.maxPointCap;
    bool winByTwo = _state.config.winByTwo;

    bool gameA = false;
    bool gameB = false;

    if (winByTwo) {
      if (scoreA >= toWin && (scoreA - scoreB) >= 2) gameA = true;
      if (scoreB >= toWin && (scoreB - scoreA) >= 2) gameB = true;

      // Hard cap
      if (scoreA == cap) gameA = true;
      if (scoreB == cap) gameB = true;
    } else {
      if (scoreA >= toWin) gameA = true;
      if (scoreB >= toWin) gameB = true;
    }

    if (gameA || gameB) {
      // Complete current game
      List<BadmintonGame> newGames = List.from(_state.games);
      newGames[_state.currentGameIndex] = BadmintonGame(
        scoreA: scoreA,
        scoreB: scoreB,
        isCompleted: true,
        winner: gameA ? PlayerSide.sideA : PlayerSide.sideB,
      );

      _state = _state.copyWith(
        games: newGames,
        currentScoreA: 0,
        currentScoreB: 0,
        hasIntervalOccurred: false,
        hasEndsChangedDecider: false,
      );

      _checkMatchEnd();

      // If match not over, prep next game
      if (_state.status != MatchStatus.completed) {
        bool newEndsSwapped = _state.config.endsChangeEnabled ? !_state.endsSwapped : _state.endsSwapped;
        _state = _state.copyWith(
          currentGameIndex: _state.currentGameIndex + 1,
          games: [..._state.games, BadmintonGame()],
          // Winner of prev game serves first
          servingSide: gameA ? PlayerSide.sideA : PlayerSide.sideB,
          serviceCourt: ServiceCourt.right,
          endsSwapped: newEndsSwapped,
        );
      }
    }
  }

  void _checkMatchEnd() {
    int gamesWonA = _state.games.where((g) => g.isCompleted && g.winner == PlayerSide.sideA).length;
    int gamesWonB = _state.games.where((g) => g.isCompleted && g.winner == PlayerSide.sideB).length;
    int needed = _state.config.gamesToWin;

    if (gamesWonA >= needed) {
      _state = _state.copyWith(status: MatchStatus.completed, matchWinner: PlayerSide.sideA);
    } else if (gamesWonB >= needed) {
      _state = _state.copyWith(status: MatchStatus.completed, matchWinner: PlayerSide.sideB);
    }
  }
}
