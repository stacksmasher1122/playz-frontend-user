import 'package:flutter/material.dart';
import 'package:redesign/theme/app_colors.dart';
import 'package:redesign/theme/app_typography.dart';
import 'package:redesign/theme/responsive_helper.dart';

class VenueFilterChip extends StatefulWidget {
  final String label;
  final bool isSelected;
  final VoidCallback onTap;

  const VenueFilterChip({
    super.key,
    required this.label,
    required this.isSelected,
    required this.onTap,
  });

  @override
  State<VenueFilterChip> createState() => _VenueFilterChipState();
}

class _VenueFilterChipState extends State<VenueFilterChip> {
  @override
  Widget build(BuildContext context) {
    ResponsiveHelper.init(context);

    return GestureDetector(
      onTap: widget.onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        margin: EdgeInsets.only(right: context.widthPct(3)),
        padding: EdgeInsets.symmetric(
          horizontal: context.widthPct(4),
          vertical: context.heightPct(1),
        ),
        decoration: BoxDecoration(
          color: widget.isSelected ? AppColors.accent : AppColors.card,
          borderRadius: BorderRadius.circular(context.minDimensionPct(5)),
          border: Border.all(
            color: widget.isSelected ? AppColors.accent : AppColors.card,
            width: 1,
          ),
        ),
        child: FittedBox(
          fit: BoxFit.scaleDown,
          child: Text(
            widget.label,
            style: AppTypography.bodySm.copyWith(
              color: widget.isSelected ? AppColors.background : AppColors.textPrimary,
              fontSize: context.responsiveFont(12.5),
              fontWeight: widget.isSelected ? FontWeight.bold : FontWeight.normal,
            ),
          ),
        ),
      ),
    );
  }
}
