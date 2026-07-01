import 'package:redesign/model/User_Models/Home_Models/Scoreboard_Model/Volleyball/volleyball_player_model.dart';

class CourtPlayerModel {
  final VolleyballPlayerModel player;
  final int courtPosition; // 1 to 6 (P1..P6)
  final bool isServing;

  CourtPlayerModel({
    required this.player,
    required this.courtPosition,
    this.isServing = false,
  });

  CourtPlayerModel copyWith({
    VolleyballPlayerModel? player,
    int? courtPosition,
    bool? isServing,
  }) {
    return CourtPlayerModel(
      player: player ?? this.player,
      courtPosition: courtPosition ?? this.courtPosition,
      isServing: isServing ?? this.isServing,
    );
  }
}
