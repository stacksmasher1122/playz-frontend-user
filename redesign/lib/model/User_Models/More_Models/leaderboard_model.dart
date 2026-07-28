class LeaderboardPlayerModel {
  final int rank;
  final String name;
  final int points;
  final String avatarUrl;
  final bool isCurrentUser;

  const LeaderboardPlayerModel({
    required this.rank,
    required this.name,
    required this.points,
    required this.avatarUrl,
    this.isCurrentUser = false,
  });

  static List<LeaderboardPlayerModel> getSampleLeaderboard() {
    return const [
      LeaderboardPlayerModel(
        rank: 1,
        name: 'Marcus J.',
        points: 3120,
        avatarUrl: 'https://images.unsplash.com/photo-1534528741775-53994a69daeb?w=150',
      ),
      LeaderboardPlayerModel(
        rank: 2,
        name: 'Sarah M.',
        points: 2450,
        avatarUrl: 'https://images.unsplash.com/photo-1517841905240-472988babdf9?w=150',
      ),
      LeaderboardPlayerModel(
        rank: 3,
        name: 'Elena R.',
        points: 2100,
        avatarUrl: 'https://images.unsplash.com/photo-1539571696357-5a69c17a67c6?w=150',
      ),
      LeaderboardPlayerModel(
        rank: 4,
        name: 'Alex T.',
        points: 1890,
        avatarUrl: 'https://images.unsplash.com/photo-1507003211169-0a1dd7228f2d?w=150',
      ),
      LeaderboardPlayerModel(
        rank: 5,
        name: 'Jordan K.',
        points: 1750,
        avatarUrl: 'https://images.unsplash.com/photo-1500648767791-00dcc994a43e?w=150',
      ),
      LeaderboardPlayerModel(
        rank: 6,
        name: 'David L.',
        points: 1620,
        avatarUrl: 'https://images.unsplash.com/photo-1492562080023-ab3db95bfbce?w=150',
      ),
      LeaderboardPlayerModel(
        rank: 7,
        name: 'Chris P.',
        points: 1500,
        avatarUrl: 'https://images.unsplash.com/photo-1524504388940-b1c1722653e1?w=150',
      ),
      LeaderboardPlayerModel(
        rank: 8,
        name: 'Maya V.',
        points: 1410,
        avatarUrl: 'https://images.unsplash.com/photo-1544005313-94ddf0286df2?w=150',
      ),
      LeaderboardPlayerModel(
        rank: 47,
        name: 'You',
        points: 840,
        avatarUrl: 'https://images.unsplash.com/photo-1535713875002-d1d0cf377fde?w=150',
        isCurrentUser: true,
      ),
    ];
  }
}
