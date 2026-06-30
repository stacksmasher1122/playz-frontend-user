class MatchMetricModel {
  final int matchDuration; // in minutes
  final int longestRally; // number of shots
  final int totalSmashes;
  final int fastestSmash; // km/h
  final int averageRally; // shots
  final String intensity; // e.g., "ABOVE AVERAGE INTENSITY"

  const MatchMetricModel({
    required this.matchDuration,
    required this.longestRally,
    required this.totalSmashes,
    required this.fastestSmash,
    required this.averageRally,
    required this.intensity,
  });
}
