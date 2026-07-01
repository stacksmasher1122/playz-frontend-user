class TeamModel {
  final String teamId;
  final String teamName;
  final String? teamLogo;
  final String? coach;
  final String? captain;
  final bool isHome;

  const TeamModel({
    required this.teamId,
    required this.teamName,
    this.teamLogo,
    this.coach,
    this.captain,
    required this.isHome,
  });

  TeamModel copyWith({
    String? teamId,
    String? teamName,
    String? teamLogo,
    String? coach,
    String? captain,
    bool? isHome,
  }) {
    return TeamModel(
      teamId: teamId ?? this.teamId,
      teamName: teamName ?? this.teamName,
      teamLogo: teamLogo ?? this.teamLogo,
      coach: coach ?? this.coach,
      captain: captain ?? this.captain,
      isHome: isHome ?? this.isHome,
    );
  }
}
