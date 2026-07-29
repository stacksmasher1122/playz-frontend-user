import 'package:flutter/material.dart';
import 'package:redesign/theme/app_colors.dart';
import 'package:redesign/theme/app_typography.dart';
import 'package:redesign/theme/responsive_helper.dart';

class VenueSearchBar extends StatefulWidget {
  final TextEditingController controller;
  final VoidCallback onLocationTap;

  const VenueSearchBar({
    super.key,
    required this.controller,
    required this.onLocationTap,
  });

  @override
  State<VenueSearchBar> createState() => _VenueSearchBarState();
}

class _VenueSearchBarState extends State<VenueSearchBar> {
  @override
  Widget build(BuildContext context) {
    ResponsiveHelper.init(context);

    return Container(
      margin: EdgeInsets.symmetric(horizontal: context.widthPct(4)),
      height: context.heightPct(6.5).clamp(48.0, 56.0),
      decoration: BoxDecoration(
        color: AppColors.card,
        borderRadius: BorderRadius.circular(context.minDimensionPct(6.5)),
        border: Border.all(color: AppColors.borderDark, width: 1),
      ),
      child: TextField(
        controller: widget.controller,
        style: AppTypography.bodyMd.copyWith(
          color: AppColors.textPrimary,
          fontSize: context.responsiveFont(14),
        ),
        decoration: InputDecoration(
          hintText: "Search venues or cities...",
          hintStyle: AppTypography.bodyMd.copyWith(
            color: AppColors.muted,
            fontSize: context.responsiveFont(13.5),
          ),
          prefixIcon: Icon(
            Icons.search_rounded,
            color: AppColors.muted,
            size: context.responsiveFont(22),
          ),
          suffixIcon: GestureDetector(
            onTap: widget.onLocationTap,
            child: Icon(
              Icons.my_location_rounded,
              color: AppColors.accent,
              size: context.responsiveFont(22),
            ),
          ),
          border: InputBorder.none,
          contentPadding: EdgeInsets.symmetric(vertical: context.heightPct(1.5)),
        ),
      ),
    );
  }
}
