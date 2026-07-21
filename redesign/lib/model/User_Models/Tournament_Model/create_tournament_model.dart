import 'prize_tier_model.dart';

class FormatModel {
  final String teamMode; // singles, doubles, team
  final int teamSize;
  final String matchType; // knockout, roundRobinSingle, roundRobinDouble, groupToKnockout
  final Map<String, dynamic> sportRules;

  FormatModel({
    required this.teamMode,
    required this.teamSize,
    required this.matchType,
    required this.sportRules,
  });
}

class EntryFeeModel {
  final bool isFree;
  final num? amount;

  EntryFeeModel({
    required this.isFree,
    this.amount,
  });
}

class PrizePoolModel {
  final bool hasPrizePool;
  final List<PrizeTierModel> tiers;

  PrizePoolModel({
    required this.hasPrizePool,
    required this.tiers,
  });
}

class CreateTournamentModel {
  final String sport;
  final String? coverImage;
  final String tournamentName;
  final DateTime? startDate;
  final DateTime? endDate;
  final String preferredTiming;
  final bool isPublicAccess;
  final String description;
  FormatModel? format;
  EntryFeeModel? entryFee;
  PrizePoolModel? prizePool;

  CreateTournamentModel({
    required this.sport,
    this.coverImage,
    required this.tournamentName,
    this.startDate,
    this.endDate,
    required this.preferredTiming,
    required this.isPublicAccess,
    required this.description,
    this.format,
    this.entryFee,
    this.prizePool,
  });
}
