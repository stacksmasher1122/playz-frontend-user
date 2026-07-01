class MatchStatisticsModel {
  final String matchId;
  final String matchStatus; // e.g., "LIVE"
  final String currentMinute;
  final int homeScore;
  final int awayScore;
  final String stadium;
  final String matchTime;
  final String homeTeam;
  final String awayTeam;
  final String homeLogo; // Adding logos for UI
  final String awayLogo;

  const MatchStatisticsModel({
    required this.matchId,
    required this.matchStatus,
    required this.currentMinute,
    required this.homeScore,
    required this.awayScore,
    required this.stadium,
    required this.matchTime,
    required this.homeTeam,
    required this.awayTeam,
    required this.homeLogo,
    required this.awayLogo,
  });

  MatchStatisticsModel copyWith({
    String? matchId,
    String? matchStatus,
    String? currentMinute,
    int? homeScore,
    int? awayScore,
    String? stadium,
    String? matchTime,
    String? homeTeam,
    String? awayTeam,
    String? homeLogo,
    String? awayLogo,
  }) {
    return MatchStatisticsModel(
      matchId: matchId ?? this.matchId,
      matchStatus: matchStatus ?? this.matchStatus,
      currentMinute: currentMinute ?? this.currentMinute,
      homeScore: homeScore ?? this.homeScore,
      awayScore: awayScore ?? this.awayScore,
      stadium: stadium ?? this.stadium,
      matchTime: matchTime ?? this.matchTime,
      homeTeam: homeTeam ?? this.homeTeam,
      awayTeam: awayTeam ?? this.awayTeam,
      homeLogo: homeLogo ?? this.homeLogo,
      awayLogo: awayLogo ?? this.awayLogo,
    );
  }
}
