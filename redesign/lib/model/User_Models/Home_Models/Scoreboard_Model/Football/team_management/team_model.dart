class TeamModel {
  final String teamId;
  final String teamName;
  final String clubLogo;
  final String division;
  final String stadiumName;
  final String headCoach;
  final int rosterCount;
  final DateTime createdDate;

  const TeamModel({
    required this.teamId,
    required this.teamName,
    required this.clubLogo,
    required this.division,
    required this.stadiumName,
    required this.headCoach,
    required this.rosterCount,
    required this.createdDate,
  });

  TeamModel copyWith({
    String? teamId,
    String? teamName,
    String? clubLogo,
    String? division,
    String? stadiumName,
    String? headCoach,
    int? rosterCount,
    DateTime? createdDate,
  }) {
    return TeamModel(
      teamId: teamId ?? this.teamId,
      teamName: teamName ?? this.teamName,
      clubLogo: clubLogo ?? this.clubLogo,
      division: division ?? this.division,
      stadiumName: stadiumName ?? this.stadiumName,
      headCoach: headCoach ?? this.headCoach,
      rosterCount: rosterCount ?? this.rosterCount,
      createdDate: createdDate ?? this.createdDate,
    );
  }
}
