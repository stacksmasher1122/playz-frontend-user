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
        return Icons.sports_cricket;
      case 'football':
        return Icons.sports_soccer;
      case 'tennis':
        return Icons.sports_tennis;
      case 'badminton':
        return Icons.sports_tennis; // Use similar icon if no specific badminton icon
      case 'basketball':
        return Icons.sports_basketball;
      default:
        return Icons.sports;
    }
  }

  
  @override
  State<SportCardWidget> createState() => _SportCardWidgetState();
}

class _SportCardWidgetState extends State<SportCardWidget> {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: widget.onTap,
      child: Container(
        width: ResponsiveHelper.w(80),
        height: ResponsiveHelper.h(100),
        margin: EdgeInsets.only(right: ResponsiveHelper.w(12)),
        decoration: BoxDecoration(
          color: widget.isSelected ? AppColors.accent.withValues(alpha: 0.1) : AppColors.card,
          borderRadius: BorderRadius.circular(ResponsiveHelper.w(12)),
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
              color: widget.isSelected ? AppColors.accent : AppColors.onPrimary,
              size: ResponsiveHelper.w(28),
            ),
            SizedBox(height: ResponsiveHelper.h(8)),
            Text(
              widget.sport,
              style: AppTypography.bodySm.copyWith(
                color: widget.isSelected ? AppColors.accent : AppColors.onPrimary,
                fontWeight: widget.isSelected ? FontWeight.bold : FontWeight.normal,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
