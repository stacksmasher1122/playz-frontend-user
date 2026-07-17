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
    return Container(
      margin: EdgeInsets.symmetric(horizontal: ResponsiveHelper.w(16)),
      height: ResponsiveHelper.h(52),
      decoration: BoxDecoration(
        color: AppColors.card,
        borderRadius: BorderRadius.circular(ResponsiveHelper.w(26)),
        border: Border.all(color: AppColors.card, width: 1),
      ),
      child: TextField(
        controller: widget.controller,
        style: AppTypography.bodyMd.copyWith(color: AppColors.onPrimary),
        decoration: InputDecoration(
          hintText: "Search venues or cities...",
          hintStyle: AppTypography.bodyMd.copyWith(color: AppColors.muted),
          prefixIcon: Icon(
            Icons.search,
            color: AppColors.muted,
            size: ResponsiveHelper.w(24),
          ),
          suffixIcon: GestureDetector(
            onTap: widget.onLocationTap,
            child: Icon(
              Icons.my_location,
              color: AppColors.accent,
              size: ResponsiveHelper.w(24),
            ),
          ),
          border: InputBorder.none,
          contentPadding: EdgeInsets.symmetric(vertical: ResponsiveHelper.h(14)),
        ),
      ),
    );
  }
}
