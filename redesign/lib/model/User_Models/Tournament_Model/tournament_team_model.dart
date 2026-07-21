class TournamentPlayerModel {
  final String userId;
  final String name;
  final String profileImageUrl;
  final String sportRole;

  TournamentPlayerModel({
    required this.userId,
    required this.name,
    required this.profileImageUrl,
    required this.sportRole,
  });

  Map<String, dynamic> toMap() {
    return {
      'userId': userId,
      'name': name,
      'profileImageUrl': profileImageUrl,
      'sportRole': sportRole,
    };
  }

  factory TournamentPlayerModel.fromMap(Map<String, dynamic> map) {
    return TournamentPlayerModel(
      userId: map['userId'] ?? '',
      name: map['name'] ?? '',
      profileImageUrl: map['profileImageUrl'] ?? '',
      sportRole: map['sportRole'] ?? '',
    );
  }
}

class TournamentTeamModel {
  final String? id;
  final String name;
  final String? logoUrl;
  final String registeredBy;
  final List<TournamentPlayerModel> players;
  final String paymentStatus;
  final String? paymentId;
  final DateTime? registeredAt;

  TournamentTeamModel({
    this.id,
    required this.name,
    this.logoUrl,
    required this.registeredBy,
    required this.players,
    required this.paymentStatus,
    this.paymentId,
    this.registeredAt,
  });

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'logoUrl': logoUrl,
      'registeredBy': registeredBy,
      'players': players.map((p) => p.toMap()).toList(),
      'paymentStatus': paymentStatus,
      'paymentId': paymentId,
      'registeredAt': registeredAt ?? DateTime.now(), // Firestore will override with serverTimestamp typically
    };
  }
}
