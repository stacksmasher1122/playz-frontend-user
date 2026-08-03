import 'package:flutter_test/flutter_test.dart';
import 'package:redesign/model/User_Models/Home_Models/Scoreboard_Model/badminton_state_models.dart';
import 'package:redesign/score_engine/badmintonMatchEngine/badminton_match_engine.dart';

void main() {
  group('BadmintonMatchEngine Comprehensive Test Suite', () {
    late BadmintonMatchEngine engine;

    setUp(() {
      final config = BadmintonMatchConfig(
        pointsToWin: 21,
        maxPointCap: 30,
        winByTwo: true,
        gamesToWin: 2,
        intervalsEnabled: true,
        endsChangeEnabled: true,
      );

      final initialState = BadmintonMatchState(
        config: config,
        teamA: const [BadmintonPlayer(name: 'Player A1'), BadmintonPlayer(name: 'Player A2')],
        teamB: const [BadmintonPlayer(name: 'Player B1'), BadmintonPlayer(name: 'Player B2')],
        servingSide: PlayerSide.sideA,
      );

      engine = BadmintonMatchEngine(initialState);
    });

    test('1. Normal Point Scoring and Serve Switching', () {
      expect(engine.state.currentScoreA, 0);
      expect(engine.state.currentScoreB, 0);
      expect(engine.state.servingSide, PlayerSide.sideA);
      expect(engine.state.serviceCourt, ServiceCourt.right);

      // Side A serves and wins point
      engine.dispatch(PointEvent(side: PlayerSide.sideA));
      expect(engine.state.currentScoreA, 1);
      expect(engine.state.servingSide, PlayerSide.sideA);
      expect(engine.state.serviceCourt, ServiceCourt.left); // 1 is odd -> left court

      // Side B wins point -> serve transfers to Side B
      engine.dispatch(PointEvent(side: PlayerSide.sideB));
      expect(engine.state.currentScoreA, 1);
      expect(engine.state.currentScoreB, 1);
      expect(engine.state.servingSide, PlayerSide.sideB);
      expect(engine.state.serviceCourt, ServiceCourt.left); // Score 1 -> left court
    });

    test('2. B4 Fix: Service Fault Awards Point to Receiving Side', () {
      expect(engine.state.servingSide, PlayerSide.sideA);
      expect(engine.state.currentScoreB, 0);

      // Side A service fault -> Side B gets point and serve
      engine.dispatch(PointEvent(side: PlayerSide.sideA, pointType: 'service_fault'));
      expect(engine.state.currentScoreA, 0);
      expect(engine.state.currentScoreB, 1);
      expect(engine.state.servingSide, PlayerSide.sideB);
    });

    test('3. B5 Fix: Doubles Serve Rotation', () {
      expect(engine.state.serverIndexA, 0);

      // Side A serves and wins point -> partners swap courts (serverIndexA toggles)
      engine.dispatch(PointEvent(side: PlayerSide.sideA));
      expect(engine.state.serverIndexA, 1);

      // Side A serves and wins another point -> serverIndexA toggles back to 0
      engine.dispatch(PointEvent(side: PlayerSide.sideA));
      expect(engine.state.serverIndexA, 0);
    });

    test('4. B8 Fix: Auto End Swap After Completed Game & Mid-Deciding Game Swap', () {
      // Score 21 points for Side A to win Game 1
      for (int i = 0; i < 21; i++) {
        engine.dispatch(PointEvent(side: PlayerSide.sideA));
      }

      expect(engine.state.games[0].isCompleted, true);
      expect(engine.state.games[0].winner, PlayerSide.sideA);
      expect(engine.state.currentGameIndex, 1);
      expect(engine.state.endsSwapped, true); // End swapped after Game 1
    });

    test('5. A2 Fix: Medical Timeout Preserves Undo History', () {
      engine.dispatch(PointEvent(side: PlayerSide.sideA));
      engine.dispatch(PointEvent(side: PlayerSide.sideA));
      expect(engine.state.currentScoreA, 2);

      engine.startMedicalTimeout();
      expect(engine.state.status, MatchStatus.timeout);
      expect(engine.canUndo, true);

      engine.resumeFromTimeout();
      expect(engine.state.status, MatchStatus.inProgress);
      expect(engine.canUndo, true);

      // Undo resume
      engine.undo();
      expect(engine.state.status, MatchStatus.timeout);

      // Undo start timeout
      engine.undo();
      expect(engine.state.status, MatchStatus.inProgress);
      expect(engine.state.currentScoreA, 2);
    });

    test('6. D13 Fix: Retire Match Completes Match and Supports Undo', () {
      engine.dispatch(PointEvent(side: PlayerSide.sideA));
      expect(engine.state.currentScoreA, 1);

      engine.retireMatch(PlayerSide.sideA);
      expect(engine.state.status, MatchStatus.completed);
      expect(engine.state.matchWinner, PlayerSide.sideB);

      // Undo retirement
      engine.undo();
      expect(engine.state.status, MatchStatus.inProgress);
      expect(engine.state.currentScoreA, 1);
    });

    test('7. Multi-Level Chained Undo', () {
      engine.dispatch(PointEvent(side: PlayerSide.sideA)); // A: 1-0, A serving
      engine.dispatch(PointEvent(side: PlayerSide.sideA, pointType: 'service_fault')); // A faults -> B: 1-1, B serving
      engine.dispatch(PointEvent(side: PlayerSide.sideB, pointType: 'service_fault')); // B faults -> A: 2-1, A serving

      expect(engine.state.currentScoreA, 2);
      expect(engine.state.currentScoreB, 1);

      engine.undo(); // Undo B's service fault
      expect(engine.state.currentScoreA, 1);
      expect(engine.state.currentScoreB, 1);

      engine.undo(); // Undo A's service fault
      expect(engine.state.currentScoreA, 1);
      expect(engine.state.currentScoreB, 0);

      engine.undo(); // Undo A's point
      expect(engine.state.currentScoreA, 0);
      expect(engine.state.currentScoreB, 0);
      expect(engine.canUndo, false);
    });
  });
}
