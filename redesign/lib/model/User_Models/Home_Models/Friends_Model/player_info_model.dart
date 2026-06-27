class PlayerInfoModel {
  final String email;
  final String fullName;
  final String profileImageUrl;
  final bool isOnline;
  final String bio;
  final int matchesPlayed;
  final int winRate;
  final String username;
  final DateTime? joinedAt;
  final DateTime? friendsSince;

  PlayerInfoModel({
    required this.email,
    required this.fullName,
    required this.profileImageUrl,
    required this.isOnline,
    this.bio = '',
    this.matchesPlayed = 0,
    this.winRate = 0,
    required this.username,
    this.joinedAt,
    this.friendsSince,
  });
}
