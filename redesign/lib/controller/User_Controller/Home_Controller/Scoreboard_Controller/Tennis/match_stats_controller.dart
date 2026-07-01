import 'package:get/get.dart';
import '../../../../../../../model/User_Models/Home_Models/Scoreboard_Model/Tennis/match_stats_model.dart';

class MatchStatsController extends GetxController {
  final Rx<MatchStatsModel?> stats = Rx<MatchStatsModel?>(null);

  @override
  void onInit() {
    super.onInit();
    _loadMockData();
  }

  void _loadMockData() {
    stats.value = const MatchStatsModel(
      player1Name: 'Carlos Alcaraz',
      player1Country: 'ESP',
      player1Rank: 'ATP #2',
      player1SetsWon: 2,
      player1Image: 'https://images.unsplash.com/photo-1599586120429-48281b6f0ece?auto=format&fit=crop&q=80&w=300',
      player2Name: 'Jannik Sinner',
      player2Country: 'ITA',
      player2Rank: 'ATP #1',
      player2SetsWon: 1,
      p1Aces: 12,
      p2Aces: 8,
      p1DoubleFaults: 2,
      p2DoubleFaults: 5,
      p1Winners: 48,
      p2Winners: 42,
      p1UnforcedErrors: 19,
      p2UnforcedErrors: 28,
      p1FirstServePercent: 72,
      p2FirstServePercent: 65,
      setBreakdowns: [
        SetBreakdownModel(
          setNumber: 1,
          p1Score: 6,
          p2Score: 4,
          duration: '42 MINS',
          keyInsight: 'KEY: ACE STREAK',
          isP1Winner: true,
        ),
        SetBreakdownModel(
          setNumber: 2,
          p1Score: 4,
          p2Score: 6,
          duration: '55 MINS',
          keyInsight: 'KEY: DEFENSIVE RALLY',
          isP1Winner: false,
        ),
        SetBreakdownModel(
          setNumber: 3,
          p1Score: 7,
          p2Score: 5,
          duration: '1H 12M',
          keyInsight: 'MATCH POINT',
          isMatchPoint: true,
          isP1Winner: true,
        ),
      ],
      isPlayer1Mvp: true,
      mvpInsight: 'Alcaraz dominated the final set through extreme court coverage and a 92% win rate on first serve. His aggressive baseline play in the 11th game forced 3 unforced errors from Sinner, securing the critical break.',
    );
  }
}
