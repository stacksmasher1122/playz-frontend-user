import 'package:flutter/material.dart';

class MonthlyActivity {
  final String month;
  final int matches;
  final int wins;

  const MonthlyActivity({
    required this.month,
    required this.matches,
    required this.wins,
  });
}

class CricketTechnicalStats {
  final int innings;
  final int totalRuns;
  final int ballsFaced;
  final double strikeRate;
  final double battingAvg;
  final String highestScore;
  final int fours;
  final int sixes;
  final int fifties;
  final int hundreds;
  final int ducks;

  final double oversBowled;
  final int wickets;
  final double economyRate;
  final int maidens;
  final double bowlingAvg;
  final String bestBowling;
  final double dotBallPercentage;

  final int catches;
  final int runOuts;
  final List<String> strengths;
  final List<String> weaknesses;
  final Map<String, int> wagonWheelScoring;

  const CricketTechnicalStats({
    required this.innings,
    required this.totalRuns,
    required this.ballsFaced,
    required this.strikeRate,
    required this.battingAvg,
    required this.highestScore,
    required this.fours,
    required this.sixes,
    required this.fifties,
    required this.hundreds,
    required this.ducks,
    required this.oversBowled,
    required this.wickets,
    required this.economyRate,
    required this.maidens,
    required this.bowlingAvg,
    required this.bestBowling,
    required this.dotBallPercentage,
    required this.catches,
    required this.runOuts,
    required this.strengths,
    required this.weaknesses,
    required this.wagonWheelScoring,
  });
}

class FootballTechnicalStats {
  final int starts;
  final int goals;
  final int assists;
  final int totalShots;
  final int shotsOnTarget;
  final double shotConversionRate;
  final double expectedGoals; // xG
  final double expectedAssists; // xA

  final int totalPasses;
  final double passAccuracy;
  final int keyPasses;
  final int crossesCompleted;

  final double tacklesWonRate;
  final int interceptions;
  final double groundDuelsWonRate;
  final double distanceCoveredKm;
  final double topSpeedKmh;

  final List<String> strengths;
  final List<String> weaknesses;

  const FootballTechnicalStats({
    required this.starts,
    required this.goals,
    required this.assists,
    required this.totalShots,
    required this.shotsOnTarget,
    required this.shotConversionRate,
    required this.expectedGoals,
    required this.expectedAssists,
    required this.totalPasses,
    required this.passAccuracy,
    required this.keyPasses,
    required this.crossesCompleted,
    required this.tacklesWonRate,
    required this.interceptions,
    required this.groundDuelsWonRate,
    required this.distanceCoveredKm,
    required this.topSpeedKmh,
    required this.strengths,
    required this.weaknesses,
  });
}

class BadmintonTechnicalStats {
  final int totalSetsPlayed;
  final int setsWon;
  final int setsLost;
  final int totalPointsScored;
  final int totalPointsConceded;

  final int smashWinners;
  final double avgSmashSpeedKmh;
  final double topSmashSpeedKmh;
  final int netWinners;
  final int dropWinners;
  final int unforcedErrors;
  final double serveAccuracyRate;
  final double rallyWinRate;

  final Map<String, int> shotDistribution;
  final List<String> strengths;
  final List<String> weaknesses;

  const BadmintonTechnicalStats({
    required this.totalSetsPlayed,
    required this.setsWon,
    required this.setsLost,
    required this.totalPointsScored,
    required this.totalPointsConceded,
    required this.smashWinners,
    required this.avgSmashSpeedKmh,
    required this.topSmashSpeedKmh,
    required this.netWinners,
    required this.dropWinners,
    required this.unforcedErrors,
    required this.serveAccuracyRate,
    required this.rallyWinRate,
    required this.shotDistribution,
    required this.strengths,
    required this.weaknesses,
  });
}

class SportStatModel {
  final String name;
  final String category;
  final IconData icon;
  final int matchesPlayed;
  final int wins;
  final int losses;
  final int draws;
  final double hoursPlayed;
  final double skillRating;
  final String skillLevel;
  final int mvpCount;
  final List<String> recentForm;
  final List<MonthlyActivity> monthlyActivity;
  final CricketTechnicalStats? cricketStats;
  final FootballTechnicalStats? footballStats;
  final BadmintonTechnicalStats? badmintonStats;

  const SportStatModel({
    required this.name,
    required this.category,
    required this.icon,
    required this.matchesPlayed,
    required this.wins,
    required this.losses,
    this.draws = 0,
    required this.hoursPlayed,
    required this.skillRating,
    required this.skillLevel,
    this.mvpCount = 0,
    required this.recentForm,
    required this.monthlyActivity,
    this.cricketStats,
    this.footballStats,
    this.badmintonStats,
  });

  double get winRate {
    if (matchesPlayed == 0) return 0.0;
    return (wins / matchesPlayed) * 100;
  }

  static List<SportStatModel> getSampleStats() {
    return [
      // 1. CRICKET
      const SportStatModel(
        name: 'Cricket',
        category: 'Team Sports',
        icon: Icons.sports_cricket,
        matchesPlayed: 42,
        wins: 28,
        losses: 12,
        draws: 2,
        hoursPlayed: 142.5,
        skillRating: 4.8,
        skillLevel: 'Pro',
        mvpCount: 8,
        recentForm: ['W', 'W', 'L', 'W', 'W'],
        monthlyActivity: [
          MonthlyActivity(month: 'Jan', matches: 5, wins: 4),
          MonthlyActivity(month: 'Feb', matches: 8, wins: 5),
          MonthlyActivity(month: 'Mar', matches: 6, wins: 4),
          MonthlyActivity(month: 'Apr', matches: 10, wins: 7),
          MonthlyActivity(month: 'May', matches: 7, wins: 5),
          MonthlyActivity(month: 'Jun', matches: 6, wins: 3),
        ],
        cricketStats: CricketTechnicalStats(
          innings: 38,
          totalRuns: 1420,
          ballsFaced: 980,
          strikeRate: 144.9,
          battingAvg: 44.38,
          highestScore: '88*',
          fours: 134,
          sixes: 58,
          fifties: 9,
          hundreds: 1,
          ducks: 2,
          oversBowled: 112.4,
          wickets: 34,
          economyRate: 6.85,
          maidens: 8,
          bowlingAvg: 22.6,
          bestBowling: '4/18',
          dotBallPercentage: 48.5,
          catches: 18,
          runOuts: 5,
          strengths: [
            'Death overs power hitting (SR 182.4)',
            'Off-spin accuracy & tight stump line',
            'Agile slip & cover catching',
          ],
          weaknesses: [
            'Short ball against 140+ km/h pace',
            'Slower ball wide outside off-stump',
          ],
          wagonWheelScoring: {
            'Cover Drive': 28,
            'Mid-Wicket': 32,
            'Straight': 20,
            'Fine Leg': 12,
            'Third Man': 8,
          },
        ),
      ),

      // 2. FOOTBALL
      const SportStatModel(
        name: 'Football',
        category: 'Team Sports',
        icon: Icons.sports_soccer,
        matchesPlayed: 35,
        wins: 22,
        losses: 10,
        draws: 3,
        hoursPlayed: 105.0,
        skillRating: 4.2,
        skillLevel: 'Advanced',
        mvpCount: 5,
        recentForm: ['W', 'L', 'W', 'W', 'D'],
        monthlyActivity: [
          MonthlyActivity(month: 'Jan', matches: 4, wins: 3),
          MonthlyActivity(month: 'Feb', matches: 6, wins: 4),
          MonthlyActivity(month: 'Mar', matches: 7, wins: 5),
          MonthlyActivity(month: 'Apr', matches: 8, wins: 5),
          MonthlyActivity(month: 'May', matches: 5, wins: 3),
          MonthlyActivity(month: 'Jun', matches: 5, wins: 2),
        ],
        footballStats: FootballTechnicalStats(
          starts: 32,
          goals: 22,
          assists: 14,
          totalShots: 86,
          shotsOnTarget: 48,
          shotConversionRate: 25.6,
          expectedGoals: 18.4,
          expectedAssists: 11.2,
          totalPasses: 1240,
          passAccuracy: 86.0,
          keyPasses: 54,
          crossesCompleted: 38,
          tacklesWonRate: 68.0,
          interceptions: 28,
          groundDuelsWonRate: 62.5,
          distanceCoveredKm: 10.4,
          topSpeedKmh: 32.8,
          strengths: [
            'Clinical finishing inside penalty area',
            'Through-ball vision & key pass creation',
            'High intensity defensive pressing',
          ],
          weaknesses: [
            'Weak foot finishing accuracy',
            'Aerial duel consistency against tall defenders',
          ],
        ),
      ),

      // 3. BADMINTON
      const SportStatModel(
        name: 'Badminton',
        category: 'Racquet & Net',
        icon: Icons.sports,
        matchesPlayed: 50,
        wins: 35,
        losses: 15,
        draws: 0,
        hoursPlayed: 110.0,
        skillRating: 4.9,
        skillLevel: 'Pro',
        mvpCount: 12,
        recentForm: ['W', 'W', 'W', 'L', 'W'],
        monthlyActivity: [
          MonthlyActivity(month: 'Jan', matches: 8, wins: 6),
          MonthlyActivity(month: 'Feb', matches: 9, wins: 6),
          MonthlyActivity(month: 'Mar', matches: 10, wins: 7),
          MonthlyActivity(month: 'Apr', matches: 8, wins: 6),
          MonthlyActivity(month: 'May', matches: 8, wins: 5),
          MonthlyActivity(month: 'Jun', matches: 7, wins: 5),
        ],
        badmintonStats: BadmintonTechnicalStats(
          totalSetsPlayed: 122,
          setsWon: 82,
          setsLost: 40,
          totalPointsScored: 2340,
          totalPointsConceded: 1980,
          smashWinners: 248,
          avgSmashSpeedKmh: 285.0,
          topSmashSpeedKmh: 312.0,
          netWinners: 165,
          dropWinners: 142,
          unforcedErrors: 118,
          serveAccuracyRate: 91.2,
          rallyWinRate: 61.5,
          shotDistribution: {
            'Smash': 38,
            'Net Drop': 26,
            'Clear': 18,
            'Drive': 12,
            'Lift': 6,
          },
          strengths: [
            'Steep jump smash from rear court (312 km/h max)',
            'Deceptive hairpin net drop control',
            'Explosive lateral footwork & recovery',
          ],
          weaknesses: [
            'Deep backhand clear under extreme pressure',
            'Defense against flat drive exchanges',
          ],
        ),
      ),
    ];
  }
}
