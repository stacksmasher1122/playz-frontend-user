class PositionSlot {
  final String label;
  final double x; // normalized 0.0 to 1.0 (left to right)
  final double y; // normalized 0.0 to 1.0 (top to bottom)
  final String? assignedPlayerId;

  const PositionSlot({
    required this.label,
    required this.x,
    required this.y,
    this.assignedPlayerId,
  });

  PositionSlot copyWith({
    String? label,
    double? x,
    double? y,
    String? assignedPlayerId,
  }) {
    // We allow assignedPlayerId to be cleared by passing an empty string
    return PositionSlot(
      label: label ?? this.label,
      x: x ?? this.x,
      y: y ?? this.y,
      assignedPlayerId: (assignedPlayerId != null && assignedPlayerId.isEmpty) 
          ? null 
          : (assignedPlayerId ?? this.assignedPlayerId),
    );
  }
}

class FormationModel {
  final String id;
  final String name; // 4-3-3, 4-4-2, etc.
  final List<PositionSlot> positions;

  const FormationModel({
    required this.id,
    required this.name,
    required this.positions,
  });

  FormationModel copyWith({
    String? id,
    String? name,
    List<PositionSlot>? positions,
  }) {
    return FormationModel(
      id: id ?? this.id,
      name: name ?? this.name,
      positions: positions ?? this.positions,
    );
  }
}
