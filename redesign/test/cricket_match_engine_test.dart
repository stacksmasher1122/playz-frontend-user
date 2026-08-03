import 'package:flutter_test/flutter_test.dart';
import 'package:redesign/model/User_Models/Home_Models/Scoreboard_Model/cricket_state_models.dart';
import 'package:redesign/score_engine/cricketMatchEngine/cricket_match_engine.dart';

void main() {
  group('CricketMatchEngine - Comprehensive Test Suite', () {
    late MatchEngine engine;
    late List<Player> battingTeam;
    late List<Player> bowlingTeam;

    setUp(() {
      battingTeam = List.generate(
        11,
        (i) => Player(name: 'Batter ${i + 1}', status: PlayerStatus.batter),
      );
      bowlingTeam = List.generate(
        11,
        (i) => Player(name: 'Bowler ${i + 1}'),
      );

      engine = MatchEngine(
        maxOvers: 20,
        battingTeam: battingTeam,
        bowlingTeam: bowlingTeam,
      );

      engine.startInnings(
        strikerName: 'Batter 1',
        nonStrikerName: 'Batter 2',
        bowlerName: 'Bowler 1',
      );
    });

    test('1. Normal Scoring and Striker Stats', () {
      engine.dispatch(DeliveryEvent(runs: 4)); // 4 runs
      expect(engine.state.totalRuns, equals(4));
      expect(engine.state.striker!.runs, equals(4));
      expect(engine.state.striker!.fours, equals(1));
      expect(engine.state.striker!.ballsFaced, equals(1));
      expect(engine.state.balls, equals(1));
      expect(engine.state.currentBowler!.runsConceded, equals(4));
    });

    test('2. Free Hit Granting and Immunity Rules', () {
      // No ball grants Free Hit
      engine.dispatch(DeliveryEvent(extra: ExtraType.noBall, runs: 0));
      expect(engine.state.totalRuns, equals(1)); // 1 extra run penalty
      expect(engine.state.isFreeHit, isTrue);
      expect(engine.state.balls, equals(0)); // Does not consume legal ball

      // Bowled on Free Hit -> Protected by Immunity (Not Out)
      engine.dispatch(DeliveryEvent(wickets: const [
        WicketDetails(type: DismissalType.bowled, outPlayerName: 'Batter 1'),
      ]));

      expect(engine.state.wickets, equals(0)); // Wicket NOT taken
      expect(engine.state.striker!.status, equals(PlayerStatus.batter));
      expect(engine.state.isFreeHit, isFalse); // Free hit consumed by legal delivery
      expect(engine.state.balls, equals(1));

      // Re-arm Free Hit with No-Ball
      engine.dispatch(DeliveryEvent(extra: ExtraType.noBall, runs: 0));
      expect(engine.state.isFreeHit, isTrue);

      // Run Out on Free Hit -> Allowed (Is Out)
      engine.dispatch(DeliveryEvent(
        wickets: const [
          WicketDetails(type: DismissalType.runOut, outPlayerName: 'Batter 1'),
        ],
        newBatterName: 'Batter 3',
      ));

      expect(engine.state.wickets, equals(1)); // Run Out counts
      expect(engine.state.striker!.name, equals('Batter 3'));
    });

    test('3. Retire Batter (Hurt) - No Wicket Added', () {
      expect(engine.state.wickets, equals(0));

      engine.retireBatter('Batter 1', PlayerStatus.retiredHurt);

      final retiredPlayer = engine.state.battingTeam.firstWhere((p) => p.name == 'Batter 1');
      expect(retiredPlayer.status, equals(PlayerStatus.retiredHurt));
      expect(engine.state.wickets, equals(0)); // Wickets count remains 0
    });

    test('4. Retire Bowler (Hurt) and Replacement', () {
      expect(engine.state.currentBowler!.name, equals('Bowler 1'));

      engine.retireBowler('Bowler 2');

      final retiredBowler = engine.state.bowlingTeam.firstWhere((p) => p.name == 'Bowler 1');
      expect(retiredBowler.status, equals(PlayerStatus.retiredHurt));
      expect(engine.state.currentBowler!.name, equals('Bowler 2'));
    });

    test('5. Undo Delivery and Game Awareness', () {
      // Score a 6
      engine.dispatch(DeliveryEvent(runs: 6));
      expect(engine.state.totalRuns, equals(6));
      expect(engine.state.balls, equals(1));
      expect(engine.state.ballHistory.length, equals(1));

      // Take a Wicket
      engine.dispatch(DeliveryEvent(
        wickets: const [
          WicketDetails(type: DismissalType.caught, outPlayerName: 'Batter 1', fielderName: 'Bowler 2'),
        ],
        newBatterName: 'Batter 3',
      ));
      expect(engine.state.wickets, equals(1));
      expect(engine.state.ballHistory.length, equals(2));

      // Undo Wicket
      expect(engine.canUndo, isTrue);
      engine.undo();

      expect(engine.state.wickets, equals(0));
      expect(engine.state.striker!.name, equals('Batter 1'));
      expect(engine.state.striker!.status, equals(PlayerStatus.batter));
      expect(engine.state.ballHistory.length, equals(1));

      // Undo Score 6
      engine.undo();
      expect(engine.state.totalRuns, equals(0));
      expect(engine.state.balls, equals(0));
      expect(engine.state.ballHistory.isEmpty, isTrue);
    });

    test('6. Undo Free Hit & Extra State Restoral', () {
      // No ball
      engine.dispatch(DeliveryEvent(extra: ExtraType.noBall));
      expect(engine.state.isFreeHit, isTrue);

      // Undo No ball
      engine.undo();
      expect(engine.state.isFreeHit, isFalse);
      expect(engine.state.totalRuns, equals(0));
    });

    test('7. Multi-level chained undo restores each intermediate state', () {
      engine.dispatch(DeliveryEvent(runs: 1)); // Ball 1: 1 run
      engine.dispatch(DeliveryEvent(runs: 4)); // Ball 2: 4 runs
      engine.dispatch(DeliveryEvent(runs: 6)); // Ball 3: 6 runs
      expect(engine.state.totalRuns, equals(11));

      engine.undo(); // Undo ball 3
      expect(engine.state.totalRuns, equals(5));
      expect(engine.state.balls, equals(2));

      engine.undo(); // Undo ball 2
      expect(engine.state.totalRuns, equals(1));
      expect(engine.state.balls, equals(1));

      engine.undo(); // Undo ball 1
      expect(engine.state.totalRuns, equals(0));
      expect(engine.state.balls, equals(0));
    });

    test('8. Undo over-completing delivery restores full over state', () {
      for (int i = 0; i < 5; i++) {
        engine.dispatch(DeliveryEvent(runs: 0));
      }
      expect(engine.state.balls, equals(5));

      engine.dispatch(DeliveryEvent(runs: 0)); // 6th ball completes over
      expect(engine.state.overs, equals(1));
      expect(engine.state.balls, equals(0));
      expect(engine.state.currentOverBalls, isEmpty);

      engine.undo(); // Undo 6th ball
      expect(engine.state.overs, equals(0));
      expect(engine.state.balls, equals(5));
      expect(engine.state.currentOverBalls.length, equals(5));
    });

    test('9. Undo changeBowler restores previous bowler', () {
      for (int i = 0; i < 6; i++) {
        engine.dispatch(DeliveryEvent(runs: 0));
      }
      expect(engine.state.currentBowler!.name, equals('Bowler 1'));

      engine.changeBowler('Bowler 2');
      expect(engine.state.currentBowler!.name, equals('Bowler 2'));

      engine.undo(); // Undo bowler change
      expect(engine.state.currentBowler!.name, equals('Bowler 1'));
    });

    test('10. Undo delivery after free hit re-arms free hit', () {
      engine.dispatch(DeliveryEvent(extra: ExtraType.noBall));
      expect(engine.state.isFreeHit, isTrue);

      engine.dispatch(DeliveryEvent(runs: 2));
      expect(engine.state.isFreeHit, isFalse);

      engine.undo(); // Undo free hit delivery
      expect(engine.state.isFreeHit, isTrue);
    });

    test('11. Undo 6th ball of maiden over reverts maiden count', () {
      for (int i = 0; i < 5; i++) {
        engine.dispatch(DeliveryEvent(runs: 0));
      }
      engine.dispatch(DeliveryEvent(runs: 0)); // Completes maiden over
      expect(engine.state.currentBowler!.maidens, equals(1));

      engine.undo(); // Undo 6th ball
      expect(engine.state.overs, equals(0));
      final bowler = engine.state.bowlingTeam.firstWhere((p) => p.name == 'Bowler 1');
      expect(bowler.maidens, equals(0));
    });

    test('12. Undo stack is cleared at innings boundary', () {
      engine.dispatch(DeliveryEvent(runs: 4));
      engine.dispatch(DeliveryEvent(runs: 6));
      expect(engine.canUndo, isTrue);

      engine.declareInnings();
      engine.startSecondInnings();

      expect(engine.canUndo, isFalse);
    });

    test('13. Undo stack is cleared at Super Over boundary', () {
      engine.dispatch(DeliveryEvent(runs: 4));
      expect(engine.canUndo, isTrue);

      engine.startSuperOver();

      expect(engine.canUndo, isFalse);
    });

    test('14. Retire batter preserves undo history for prior deliveries', () {
      engine.dispatch(DeliveryEvent(runs: 4)); // Ball 1
      engine.dispatch(DeliveryEvent(runs: 6)); // Ball 2
      expect(engine.undoCount, greaterThanOrEqualTo(2));

      engine.retireBatter('Batter 1', PlayerStatus.retiredHurt);
      expect(engine.undoCount, greaterThanOrEqualTo(3));

      engine.undo(); // Undo retire
      expect(engine.state.battingTeam.firstWhere((p) => p.name == 'Batter 1').status, equals(PlayerStatus.batter));

      engine.undo(); // Undo ball 2
      expect(engine.state.totalRuns, equals(4));

      engine.undo(); // Undo ball 1
      expect(engine.state.totalRuns, equals(0));
    });

    test('15. patchState preserves undo history unlike restoreState', () {
      engine.dispatch(DeliveryEvent(runs: 4));
      engine.dispatch(DeliveryEvent(runs: 6));
      final historyCount = engine.undoCount;

      engine.patchState(engine.state.toJson());
      expect(engine.undoCount, equals(historyCount));

      engine.undo();
      expect(engine.state.totalRuns, equals(4));
    });

    test('16. Undo re-enables bowler below quota threshold', () {
      final shortEngine = MatchEngine(
        maxOvers: 5,
        battingTeam: battingTeam,
        bowlingTeam: bowlingTeam,
        matchConfig: const MatchConfig(maxOvers: 5, maxOversPerBowler: 1),
      );
      shortEngine.startInnings(
        strikerName: 'Batter 1',
        nonStrikerName: 'Batter 2',
        bowlerName: 'Bowler 1',
      );

      for (int i = 0; i < 5; i++) {
        shortEngine.dispatch(DeliveryEvent(runs: 0));
      }

      shortEngine.dispatch(DeliveryEvent(runs: 0));
      final bowlerAfter = shortEngine.state.bowlingTeam.firstWhere((p) => p.name == 'Bowler 1');
      expect(bowlerAfter.ballsBowled, equals(6));

      shortEngine.undo();
      final bowlerReverted = shortEngine.state.bowlingTeam.firstWhere((p) => p.name == 'Bowler 1');
      expect(bowlerReverted.ballsBowled, equals(5));
    });

    test('17. Undo delivery that completed match reverts to LIVE', () {
      final engine2 = MatchEngine(
        maxOvers: 20,
        targetScore: 2,
        battingTeam: battingTeam,
        bowlingTeam: bowlingTeam,
      );
      engine2.startInnings(
        strikerName: 'Batter 1',
        nonStrikerName: 'Batter 2',
        bowlerName: 'Bowler 1',
      );

      engine2.dispatch(DeliveryEvent(runs: 4)); // Match completed
      expect(engine2.state.matchStatus, equals('MATCH_COMPLETED'));

      engine2.undo();
      expect(engine2.state.matchStatus.startsWith('LIVE_'), isTrue);
      expect(engine2.state.totalRuns, equals(0));
    });

    test('18. Undo with empty history returns false safely', () {
      final freshEngine = MatchEngine(
        maxOvers: 20,
        battingTeam: battingTeam,
        bowlingTeam: bowlingTeam,
      );
      expect(freshEngine.canUndo, isFalse);
      expect(freshEngine.undo(), isFalse);
    });

    test('19. Match-end undo reverts matchStatus and allows single re-scoring', () {
      final matchEngine = MatchEngine(
        maxOvers: 20,
        targetScore: 4,
        battingTeam: battingTeam,
        bowlingTeam: bowlingTeam,
      );
      matchEngine.startInnings(
        strikerName: 'Batter 1',
        nonStrikerName: 'Batter 2',
        bowlerName: 'Bowler 1',
      );

      // Score 6 on 1st ball -> target 4 reached -> MATCH_COMPLETED
      matchEngine.dispatch(DeliveryEvent(runs: 6));
      expect(matchEngine.state.matchStatus, equals('MATCH_COMPLETED'));
      expect(matchEngine.state.totalRuns, equals(6));

      // Match-end undo: Revert last ball
      expect(matchEngine.canUndo, isTrue);
      final undoSuccess = matchEngine.undo();
      expect(undoSuccess, isTrue);
      expect(matchEngine.state.matchStatus, equals('LIVE_INNINGS_2'));
      expect(matchEngine.state.totalRuns, equals(0));

      // Re-score with a 4
      matchEngine.dispatch(DeliveryEvent(runs: 4));
      expect(matchEngine.state.matchStatus, equals('MATCH_COMPLETED'));
      expect(matchEngine.state.totalRuns, equals(4));
    });

    test('20. Retire batter (retiredOut) and selectIncomingBatter can be undone', () {
      final engineTest = MatchEngine(
        maxOvers: 20,
        battingTeam: battingTeam,
        bowlingTeam: bowlingTeam,
      );
      engineTest.startInnings(
        strikerName: 'Batter 1',
        nonStrikerName: 'Batter 2',
        bowlerName: 'Bowler 1',
      );

      engineTest.retireBatter('Batter 1', PlayerStatus.retiredOut);
      expect(engineTest.state.striker?.status, equals(PlayerStatus.retiredOut));

      engineTest.selectIncomingBatter(oldBatterName: 'Batter 1', newBatterName: 'Batter 3');
      expect(engineTest.state.striker?.name, equals('Batter 3'));

      // Undo selectIncomingBatter
      engineTest.undo();
      expect(engineTest.state.striker?.name, equals('Batter 1'));
      expect(engineTest.state.striker?.status, equals(PlayerStatus.retiredOut));

      // Undo retireBatter
      engineTest.undo();
      expect(engineTest.state.striker?.name, equals('Batter 1'));
      expect(engineTest.state.striker?.status, equals(PlayerStatus.batter));
    });

    test('21. Substitute batter and undo restores original batter at crease', () {
      final engineTest = MatchEngine(
        maxOvers: 20,
        battingTeam: battingTeam,
        bowlingTeam: bowlingTeam,
        matchConfig: const MatchConfig(allowSubstitutes: true),
      );
      engineTest.startInnings(
        strikerName: 'Batter 1',
        nonStrikerName: 'Batter 2',
        bowlerName: 'Bowler 1',
      );

      engineTest.substituteBatter(oldBatterName: 'Batter 2', newBatterName: 'Batter 4');
      expect(engineTest.state.nonStriker?.name, equals('Batter 4'));

      engineTest.undo();
      expect(engineTest.state.nonStriker?.name, equals('Batter 2'));
    });

    test('22. Substitute bowler and undo restores original bowler', () {
      final engineTest = MatchEngine(
        maxOvers: 20,
        battingTeam: battingTeam,
        bowlingTeam: bowlingTeam,
        matchConfig: const MatchConfig(allowSubstitutes: true),
      );
      engineTest.startInnings(
        strikerName: 'Batter 1',
        nonStrikerName: 'Batter 2',
        bowlerName: 'Bowler 1',
      );

      engineTest.substituteBowler(oldBowlerName: 'Bowler 1', newBowlerName: 'Bowler 2');
      expect(engineTest.state.currentBowler?.name, equals('Bowler 2'));

      engineTest.undo();
      expect(engineTest.state.currentBowler?.name, equals('Bowler 1'));
    });
  });
}
