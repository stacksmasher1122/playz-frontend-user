import 'package:redesign/model/User_Models/Home_Models/Scoreboard_Model/Volleyball/court_player_model.dart';
import 'package:redesign/model/User_Models/Home_Models/Scoreboard_Model/Volleyball/volleyball_player_model.dart';

class RotationModel {
  final Map<int, CourtPlayerModel> courtPositions; // 1 -> P1, 2 -> P2...
  final VolleyballPlayerModel? servingPlayer;
  final VolleyballPlayerModel? libero;
  final VolleyballPlayerModel? captain;
  final int rotationCount;

  RotationModel({
    required this.courtPositions,
    this.servingPlayer,
    this.libero,
    this.captain,
    required this.rotationCount,
  });

  RotationModel copyWith({
    Map<int, CourtPlayerModel>? courtPositions,
    VolleyballPlayerModel? servingPlayer,
    VolleyballPlayerModel? libero,
    VolleyballPlayerModel? captain,
    int? rotationCount,
  }) {
    return RotationModel(
      courtPositions: courtPositions ?? Map.from(this.courtPositions),
      servingPlayer: servingPlayer ?? this.servingPlayer,
      libero: libero ?? this.libero,
      captain: captain ?? this.captain,
      rotationCount: rotationCount ?? this.rotationCount,
    );
  }
}
