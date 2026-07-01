import 'package:redesign/model/User_Models/Home_Models/Scoreboard_Model/Volleyball/volleyball_player_model.dart';
import 'package:redesign/model/User_Models/Home_Models/Scoreboard_Model/Volleyball/rotation_model.dart';

class SubstitutionModel {
  final VolleyballPlayerModel playerIn;
  final VolleyballPlayerModel playerOut;
  final int courtPosition;
  final DateTime timestamp;
  final RotationModel previousRotationState;

  SubstitutionModel({
    required this.playerIn,
    required this.playerOut,
    required this.courtPosition,
    required this.timestamp,
    required this.previousRotationState,
  });
}
