import 'package:redesign/theme/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'setup_constants.dart';
import 'setup_models.dart';
import 'package:redesign/theme/responsive_helper.dart';

class TournamentTypeSelector extends StatelessWidget {
  final TournamentType selectedType;
  final Function(TournamentType) onTypeChanged;

  TournamentTypeSelector({
    super.key,
    required this.selectedType,
    required this.onTypeChanged,
  });

  @override
  Widget build(BuildContext context) {
    ResponsiveHelper.init(context);
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: ResponsiveHelper.w(24)),
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
        duration: Duration(milliseconds: 200),
        padding: EdgeInsets.symmetric(horizontal: ResponsiveHelper.w(16), vertical: ResponsiveHelper.h(12)),
        decoration: BoxDecoration(
          color: isSelected ? kAccentDim : kSurfaceHighlight,
          borderRadius: BorderRadius.circular(ResponsiveHelper.w(16)),
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
            SizedBox(height: 8),
            Text(
              type.name.toUpperCase(),
              style: TextStyle(
                color: isSelected ? kAccent : kTextMuted,
                fontWeight: FontWeight.bold,
                fontSize: ResponsiveHelper.sp(10),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
