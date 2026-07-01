class MatchSetupModel {
  final String matchName;
  final String tournament;
  final DateTime? dateTime;
  final String courtNumber;
  final String chairUmpire;
  final String category;
  final String setFormat;
  final bool noAdScoring;
  final bool advantageRule;
  final bool matchTiebreak;

  const MatchSetupModel({
    this.matchName = '',
    this.tournament = 'Summer Open 2024',
    this.dateTime,
    this.courtNumber = '',
    this.chairUmpire = '',
    this.category = "Men's Singles",
    this.setFormat = 'Best of 3',
    this.noAdScoring = false,
    this.advantageRule = true,
    this.matchTiebreak = false,
  });

  MatchSetupModel copyWith({
    String? matchName,
    String? tournament,
    DateTime? dateTime,
    String? courtNumber,
    String? chairUmpire,
    String? category,
    String? setFormat,
    bool? noAdScoring,
    bool? advantageRule,
    bool? matchTiebreak,
  }) {
    return MatchSetupModel(
      matchName: matchName ?? this.matchName,
      tournament: tournament ?? this.tournament,
      dateTime: dateTime ?? this.dateTime,
      courtNumber: courtNumber ?? this.courtNumber,
      chairUmpire: chairUmpire ?? this.chairUmpire,
      category: category ?? this.category,
      setFormat: setFormat ?? this.setFormat,
      noAdScoring: noAdScoring ?? this.noAdScoring,
      advantageRule: advantageRule ?? this.advantageRule,
      matchTiebreak: matchTiebreak ?? this.matchTiebreak,
    );
  }
}
