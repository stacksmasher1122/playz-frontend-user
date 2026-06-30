class PerformanceMetricModel {
  // 5 axes for the pentagon radar chart
  final double speed;
  final double power;
  final double netPlay;
  final double tactics;
  final double defense; // 5th axis

  // For the comparison bars below
  final int playerOneWinners;
  final int playerTwoWinners;
  final int playerOneSmashes;
  final int playerTwoSmashes;
  final int playerOneNetWinners;
  final int playerTwoNetWinners;
  final int playerOneUnforcedErrors;
  final int playerTwoUnforcedErrors;

  const PerformanceMetricModel({
    required this.speed,
    required this.power,
    required this.netPlay,
    required this.tactics,
    required this.defense,
    required this.playerOneWinners,
    required this.playerTwoWinners,
    required this.playerOneSmashes,
    required this.playerTwoSmashes,
    required this.playerOneNetWinners,
    required this.playerTwoNetWinners,
    required this.playerOneUnforcedErrors,
    required this.playerTwoUnforcedErrors,
  });
}
