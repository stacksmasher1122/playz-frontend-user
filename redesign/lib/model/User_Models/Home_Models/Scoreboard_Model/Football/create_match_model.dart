class CreateMatchModel {
  final String matchName;
  final String tournament;
  final String venue;
  final String referee;
  final DateTime? dateTime;
  final String matchFormat;
  final double duration;
  final int numberOfHalves;
  final bool extraTime;
  final bool penaltyShootout;
  final bool varSimulation;

  const CreateMatchModel({
    this.matchName = '',
    this.tournament = '',
    this.venue = '',
    this.referee = '',
    this.dateTime,
    this.matchFormat = '11v11',
    this.duration = 90.0,
    this.numberOfHalves = 2,
    this.extraTime = true,
    this.penaltyShootout = true,
    this.varSimulation = false,
  });

  CreateMatchModel copyWith({
    String? matchName,
    String? tournament,
    String? venue,
    String? referee,
    DateTime? dateTime,
    String? matchFormat,
    double? duration,
    int? numberOfHalves,
    bool? extraTime,
    bool? penaltyShootout,
    bool? varSimulation,
  }) {
    return CreateMatchModel(
      matchName: matchName ?? this.matchName,
      tournament: tournament ?? this.tournament,
      venue: venue ?? this.venue,
      referee: referee ?? this.referee,
      dateTime: dateTime ?? this.dateTime,
      matchFormat: matchFormat ?? this.matchFormat,
      duration: duration ?? this.duration,
      numberOfHalves: numberOfHalves ?? this.numberOfHalves,
      extraTime: extraTime ?? this.extraTime,
      penaltyShootout: penaltyShootout ?? this.penaltyShootout,
      varSimulation: varSimulation ?? this.varSimulation,
    );
  }
}
