class SideSelectionModel {
  final String teamId;
  final String teamName;
  final String teamColor; // hex string e.g., "0xFF1A73E8"
  final bool isHome;
  final String side; // "left" or "right"

  const SideSelectionModel({
    required this.teamId,
    required this.teamName,
    required this.teamColor,
    required this.isHome,
    required this.side,
  });

  SideSelectionModel copyWith({
    String? teamId,
    String? teamName,
    String? teamColor,
    bool? isHome,
    String? side,
  }) {
    return SideSelectionModel(
      teamId: teamId ?? this.teamId,
      teamName: teamName ?? this.teamName,
      teamColor: teamColor ?? this.teamColor,
      isHome: isHome ?? this.isHome,
      side: side ?? this.side,
    );
  }
}
