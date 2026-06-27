class GameData {
  final String hostName;
  final String time;
  final String price;
  final int currentPlayers;
  final int maxPlayers;
  final String address;
  final String distance;
  final String avatarUrl;
  final String sport;
  final String type;
  final bool isFull;

  const GameData({
    required this.hostName,
    required this.time,
    required this.price,
    required this.currentPlayers,
    required this.maxPlayers,
    required this.address,
    required this.distance,
    required this.avatarUrl,
    required this.sport,
    required this.type,
    this.isFull = false,
  });
}
