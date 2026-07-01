class VolleyballPlayerModel {
  final String id;
  final String name;
  final String photo;
  final String jerseyNumber;
  final String position;
  final String height;
  final String role;
  final bool isCaptain;
  final bool isViceCaptain;
  final bool isLibero;
  final bool isStarter;
  final int rotationPosition;

  VolleyballPlayerModel({
    required this.id,
    required this.name,
    this.photo = '',
    required this.jerseyNumber,
    required this.position,
    this.height = '',
    this.role = '',
    this.isCaptain = false,
    this.isViceCaptain = false,
    this.isLibero = false,
    this.isStarter = false,
    this.rotationPosition = 0,
  });

  VolleyballPlayerModel copyWith({
    String? id,
    String? name,
    String? photo,
    String? jerseyNumber,
    String? position,
    String? height,
    String? role,
    bool? isCaptain,
    bool? isViceCaptain,
    bool? isLibero,
    bool? isStarter,
    int? rotationPosition,
  }) {
    return VolleyballPlayerModel(
      id: id ?? this.id,
      name: name ?? this.name,
      photo: photo ?? this.photo,
      jerseyNumber: jerseyNumber ?? this.jerseyNumber,
      position: position ?? this.position,
      height: height ?? this.height,
      role: role ?? this.role,
      isCaptain: isCaptain ?? this.isCaptain,
      isViceCaptain: isViceCaptain ?? this.isViceCaptain,
      isLibero: isLibero ?? this.isLibero,
      isStarter: isStarter ?? this.isStarter,
      rotationPosition: rotationPosition ?? this.rotationPosition,
    );
  }
}
