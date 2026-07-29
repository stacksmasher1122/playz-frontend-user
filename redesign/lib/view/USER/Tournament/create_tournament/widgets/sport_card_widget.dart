import 'package:flutter/material.dart';
import 'package:redesign/theme/app_colors.dart';
import 'package:redesign/theme/app_typography.dart';
import 'package:redesign/theme/responsive_helper.dart';

class SportCardWidget extends StatefulWidget {
  final String sport;
  final bool isSelected;
  final VoidCallback onTap;

  const SportCardWidget({
    super.key,
    required this.sport,
    required this.isSelected,
    required this.onTap,
  });

  IconData _getIconForSport(String sport) {
    switch (sport.toLowerCase()) {
      case 'cricket':
        return Icons.sports_cricket_rounded;
      case 'football':
        return Icons.sports_soccer_rounded;
      case 'tennis':
        return Icons.sports_tennis_rounded;
      case 'badminton':
        return Icons.sports_tennis_rounded;
      case 'basketball':
        return Icons.sports_basketball_rounded;
      default:
        return Icons.sports_rounded;
    }
  }

  @override
  State<SportCardWidget> createState() => _SportCardWidgetState();
}

class _SportCardWidgetState extends State<SportCardWidget> {
  @override
  Widget build(BuildContext context) {
    ResponsiveHelper.init(context);

    return GestureDetector(
      onTap: widget.onTap,
      child: Container(
        width: context.widthPct(22).clamp(72.0, 96.0),
        height: context.heightPct(12).clamp(84.0, 110.0),
        margin: EdgeInsets.only(right: context.widthPct(3)),
        decoration: BoxDecoration(
          color: widget.isSelected ? AppColors.accent.withValues(alpha: 0.1) : AppColors.card,
          borderRadius: BorderRadius.circular(context.minDimensionPct(3.5)),
          border: Border.all(
            color: widget.isSelected ? AppColors.accent : AppColors.card,
            width: widget.isSelected ? 2 : 1,
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              widget._getIconForSport(widget.sport),
              color: widget.isSelected ? AppColors.accent : AppColors.textPrimary,
              size: context.responsiveFont(26),
            ),
            SizedBox(height: context.heightPct(0.8)),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: context.widthPct(1)),
              child: FittedBox(
                fit: BoxFit.scaleDown,
                child: Text(
                  widget.sport,
                  style: AppTypography.bodySm.copyWith(
                    color: widget.isSelected ? AppColors.accent : AppColors.textPrimary,
                    fontSize: context.responsiveFont(12.5),
                    fontWeight: widget.isSelected ? FontWeight.bold : FontWeight.normal,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
