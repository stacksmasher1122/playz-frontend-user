import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'setup_constants.dart';
import 'setup_models.dart';

class TournamentTypeSelector extends StatelessWidget {
  final TournamentType selectedType;
  final Function(TournamentType) onTypeChanged;

  const TournamentTypeSelector({
    super.key,
    required this.selectedType,
    required this.onTypeChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: TournamentType.values
            .map((type) => _buildTypeCard(type))
            .toList(),
      ),
    );
  }

  Widget _buildTypeCard(TournamentType type) {
    bool isSelected = selectedType == type;
    return GestureDetector(
      onTap: () {
        HapticFeedback.lightImpact();
        onTypeChanged(type);
      },
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        decoration: BoxDecoration(
          color: isSelected ? kAccentDim : kSurfaceHighlight,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: isSelected ? kAccent : Colors.transparent),
        ),
        child: Column(
          children: [
            Icon(
              type == TournamentType.knockout
                  ? Icons.emoji_events
                  : type == TournamentType.league
                  ? Icons.grid_view
                  : Icons.schema,
              color: isSelected ? kAccent : kTextMuted,
            ),
            const SizedBox(height: 8),
            Text(
              type.name.toUpperCase(),
              style: TextStyle(
                color: isSelected ? kAccent : kTextMuted,
                fontWeight: FontWeight.bold,
                fontSize: 10,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
