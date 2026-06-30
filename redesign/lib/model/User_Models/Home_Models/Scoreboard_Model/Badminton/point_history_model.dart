class PointHistoryModel {
  final int pointNumber;
  final String playerName;
  final String score;
  final String pointType; // e.g., 'SMASH', 'NET', 'DRIVE', 'DROP', 'OUT'
  final String time;
  final String description;

  const PointHistoryModel({
    required this.pointNumber,
    required this.playerName,
    required this.score,
    required this.pointType,
    required this.time,
    required this.description,
  });
}