import 'package:redesign/model/User_Models/Home_Models/Scoreboard_Model/Squash/squash_state_models.dart';

class SquashMatchEngine {
  SquashMatchState _state;
  final List<SquashMatchState> _historyStack = [];

  SquashMatchEngine(this._state);

  SquashMatchState get state => _state;
  bool get canUndo => _historyStack.isNotEmpty;

  void resetEngine(SquashMatchState initialState) {
    _state = initialState;
    _historyStack.clear();
  }

  void _pushHistory() {
    _historyStack.add(_state);
  }

  bool undo() {
    if (_historyStack.isEmpty) return false;
    _state = _historyStack.removeLast();
    return true;
  }

  /// Sets the service box when a server chooses or changes their serving side.
  void selectServeBox(ServeBox box) {
    if (_state.isMatchFinished) return;
    _pushHistory();
    _state = _state.copyWith(
      currentServeBox: box,
      mustSelectServeBox: false,
    );
  }

  /// 1-tap direct box switch (L <-> R)
  void switchServeBox() {
    if (_state.isMatchFinished) return;
    _pushHistory();
    final nextBox = _state.currentServeBox == ServeBox.left
        ? ServeBox.right
        : ServeBox.left;
    _state = _state.copyWith(
      currentServeBox: nextBox,
      mustSelectServeBox: false,
    );
  }

  /// Scores a rally win for [winnerSide].
  void scoreRally(PlayerSide winnerSide) {
    if (_state.isMatchFinished) return;
    _pushHistory();

    final isServer = winnerSide == _state.currentServer;
    final isPars = _state.config.scoringSystem == SquashScoringSystem.pars;

    if (isPars) {
      // ════════════════ PARS (Point-a-Rally) SCORING ════════════════
      int newScoreA = _state.sideAPointScore;
      int newScoreB = _state.sideBPointScore;

      if (winnerSide == PlayerSide.sideA) {
        newScoreA++;
      } else {
        newScoreB++;
      }

      ServeBox nextBox = _state.currentServeBox;
      bool choiceNeeded = _state.mustSelectServeBox;

      if (isServer) {
        // Server won rally: alternate service box
        nextBox = _state.currentServeBox == ServeBox.left
            ? ServeBox.right
            : ServeBox.left;
        choiceNeeded = false;
      } else {
        // Turnover: new server chooses serving box
        choiceNeeded = true;
      }

      // Handle Doubles server rotation index
      int nextServerIndex = _state.serverPlayerIndex;
      if (!isServer && _state.config.isDoubles) {
        nextServerIndex = (nextServerIndex + 1) % 2;
      }

      _state = _state.copyWith(
        sideAPointScore: newScoreA,
        sideBPointScore: newScoreB,
        currentServer: winnerSide,
        serverPlayerIndex: nextServerIndex,
        currentServeBox: nextBox,
        mustSelectServeBox: choiceNeeded,
      );

      _checkGameStatus();
    } else {
      // ════════════════ HIHO (Hand-In / Hand-Out) SCORING ════════════════
      if (isServer) {
        // Server wins rally: +1 point & alternate service box
        int newScoreA = _state.sideAPointScore;
        int newScoreB = _state.sideBPointScore;

        if (winnerSide == PlayerSide.sideA) {
          newScoreA++;
        } else {
          newScoreB++;
        }

        final nextBox = _state.currentServeBox == ServeBox.left
            ? ServeBox.right
            : ServeBox.left;

        _state = _state.copyWith(
          sideAPointScore: newScoreA,
          sideBPointScore: newScoreB,
          currentServeBox: nextBox,
          mustSelectServeBox: false,
        );

        _checkHihoGameStatus();
      } else {
        // Receiver wins rally: Hand-out (0 points added), serve transfers
        int nextServerIndex = _state.serverPlayerIndex;
        if (_state.config.isDoubles) {
          nextServerIndex = (nextServerIndex + 1) % 2;
        }

        _state = _state.copyWith(
          currentServer: winnerSide,
          serverPlayerIndex: nextServerIndex,
          mustSelectServeBox: true,
        );
      }
    }
  }

  /// Referee Call: Stroke awarded to [awardedSide].
  void recordStroke(PlayerSide awardedSide) {
    scoreRally(awardedSide);
  }

  /// Referee Call: Let (replay rally).
  /// No point scored, server re-serves from the SAME service box.
  void recordLet() {
    if (_state.isMatchFinished) return;
    _pushHistory();
    // Replay rally: preserves exact state
  }

  /// Referee Call: No Let (appeal rejected).
  /// Rally awarded to non-appealing side.
  void recordNoLet(PlayerSide recipientSide) {
    scoreRally(recipientSide);
  }

  /// WSF Rule 15: Conduct Warning
  void recordConductWarning(PlayerSide side, String reason) {
    if (_state.isMatchFinished) return;
    _pushHistory();
    final sideName = side == PlayerSide.sideA ? 'Side A' : 'Side B';
    final logEntry = 'Conduct Warning: $sideName ($reason)';
    final newLog = List<String>.from(_state.conductLog)..add(logEntry);
    _state = _state.copyWith(conductLog: newLog);
  }

  /// WSF Rule 15: Conduct Stroke (penalty point & serve transfer to opponent)
  void recordConductStroke(PlayerSide recipientSide) {
    if (_state.isMatchFinished) return;
    final logEntry = 'Conduct Stroke awarded to ${recipientSide == PlayerSide.sideA ? 'Side A' : 'Side B'}';
    final newLog = List<String>.from(_state.conductLog)..add(logEntry);
    _state = _state.copyWith(conductLog: newLog);
    scoreRally(recipientSide);
  }

  /// WSF Rule 15: Conduct Game (penalty game awarded to opponent)
  void recordConductGame(PlayerSide recipientSide) {
    if (_state.isMatchFinished) return;
    _pushHistory();
    final logEntry = 'Conduct Game awarded to ${recipientSide == PlayerSide.sideA ? 'Side A' : 'Side B'}';
    final newLog = List<String>.from(_state.conductLog)..add(logEntry);
    _state = _state.copyWith(conductLog: newLog);
    _finishGame(recipientSide);
  }

  /// HIHO Deuce option selection at 8-8: "Set 1" (target 9) vs "Set 2" (target 10).
  void selectHihoDeuceOption(int chosenTarget) {
    if (!_state.isDeuceChoicePending) return;
    _pushHistory();
    _state = _state.copyWith(
      hihoTargetPoints: chosenTarget,
      isDeuceChoicePending: false,
    );
  }

  void _checkGameStatus() {
    final scoreA = _state.sideAPointScore;
    final scoreB = _state.sideBPointScore;
    final target = _state.config.pointsToWin;
    final winByTwo = _state.config.winByTwo;

    bool gameWon = false;
    PlayerSide? gameWinner;

    if (scoreA >= target || scoreB >= target) {
      final diff = (scoreA - scoreB).abs();
      if (!winByTwo || diff >= 2) {
        gameWon = true;
        gameWinner = scoreA > scoreB ? PlayerSide.sideA : PlayerSide.sideB;
      }
    }

    if (gameWon && gameWinner != null) {
      _finishGame(gameWinner);
    }
  }

  void _checkHihoGameStatus() {
    final scoreA = _state.sideAPointScore;
    final scoreB = _state.sideBPointScore;

    // Check for 8-8 deuce choice trigger
    if (scoreA == 8 && scoreB == 8 && _state.hihoTargetPoints == 9 && !_state.isDeuceChoicePending) {
      _state = _state.copyWith(isDeuceChoicePending: true);
      return;
    }

    final target = _state.hihoTargetPoints;
    bool gameWon = false;
    PlayerSide? gameWinner;

    // WSF HIHO Rule Fix: If target == 10 ("Set 2"), sudden death at 10 (no win-by-2 needed)
    if (target == 10) {
      if (scoreA >= 10 || scoreB >= 10) {
        gameWon = true;
        gameWinner = scoreA > scoreB ? PlayerSide.sideA : PlayerSide.sideB;
      }
    } else {
      if (scoreA >= target || scoreB >= target) {
        gameWon = true;
        gameWinner = scoreA > scoreB ? PlayerSide.sideA : PlayerSide.sideB;
      }
    }

    if (gameWon && gameWinner != null) {
      _finishGame(gameWinner);
    }
  }

  void _finishGame(PlayerSide winner) {
    int gamesA = _state.sideAGamesWon;
    int gamesB = _state.sideBGamesWon;

    if (winner == PlayerSide.sideA) {
      gamesA++;
    } else {
      gamesB++;
    }

    final newResult = SquashGameResult(
      gameNumber: _state.currentGameIndex,
      sideAScore: _state.sideAPointScore,
      sideBScore: _state.sideBPointScore,
      winner: winner,
    );

    final newHistory = List<SquashGameResult>.from(_state.gameHistory)..add(newResult);

    final isMatchOver = gamesA >= _state.config.gamesToWin || gamesB >= _state.config.gamesToWin;
    final matchWinner = isMatchOver ? (gamesA > gamesB ? PlayerSide.sideA : PlayerSide.sideB) : null;

    _state = _state.copyWith(
      sideAGamesWon: gamesA,
      sideBGamesWon: gamesB,
      gameHistory: newHistory,
      isGameFinished: true,
      isMatchFinished: isMatchOver,
      matchWinner: matchWinner,
    );
  }

  /// Navigates from completed game to the next game.
  void startNextGame() {
    if (!_state.isGameFinished || _state.isMatchFinished) return;
    _pushHistory();

    final lastWinner = _state.gameHistory.last.winner;

    // WSF Rule 4.2 Fix: Game winner serves first in next game, MUST choose their initial serving box
    _state = _state.copyWith(
      sideAPointScore: 0,
      sideBPointScore: 0,
      currentGameIndex: _state.currentGameIndex + 1,
      currentServer: lastWinner,
      serverPlayerIndex: 0,
      currentServeBox: ServeBox.right,
      mustSelectServeBox: true, // Server chooses box at start of every game!
      isGameFinished: false,
      isDeuceChoicePending: false,
      hihoTargetPoints: _state.config.pointsToWin,
    );
  }
}
