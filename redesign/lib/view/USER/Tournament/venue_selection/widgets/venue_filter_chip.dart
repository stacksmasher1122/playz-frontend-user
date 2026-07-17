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
    return GestureDetector(
      onTap: widget.onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        margin: EdgeInsets.only(right: ResponsiveHelper.w(12)),
        padding: EdgeInsets.symmetric(
          horizontal: ResponsiveHelper.w(16),
          vertical: ResponsiveHelper.h(8),
        ),
        decoration: BoxDecoration(
          color: widget.isSelected ? AppColors.accent : AppColors.card,
          borderRadius: BorderRadius.circular(ResponsiveHelper.w(20)),
          border: Border.all(
            color: widget.isSelected ? AppColors.accent : AppColors.card,
            width: 1,
          ),
        ),
        child: Text(
          widget.label,
          style: AppTypography.bodySm.copyWith(
            color: widget.isSelected ? AppColors.background : AppColors.onPrimary,
            fontWeight: widget.isSelected ? FontWeight.bold : FontWeight.normal,
          ),
        ),
      ),
    );
  }
}
