import 'player_model.dart';

class TeamModel {
  final String id;
  String name;
  String? logoUrl;
  List<PlayerModel> players;

  TeamModel({
    required this.id,
    required this.name,
    this.logoUrl,
    List<PlayerModel>? players,
  }) : players = players ?? [];
}
