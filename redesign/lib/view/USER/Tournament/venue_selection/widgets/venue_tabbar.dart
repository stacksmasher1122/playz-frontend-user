import 'package:flutter/material.dart';
import 'package:redesign/theme/app_colors.dart';
import 'package:redesign/theme/app_typography.dart';
import 'package:redesign/theme/responsive_helper.dart';

class VenueTabbar extends StatefulWidget {
  final String selectedTab;
  final Function(String) onTabChanged;

  const VenueTabbar({
    super.key,
    required this.selectedTab,
    required this.onTabChanged,
  });

  @override
  State<VenueTabbar> createState() => _VenueTabbarState();
}

class _VenueTabbarState extends State<VenueTabbar> {
  final List<String> tabs = ["PlayZ Venues", "Other Venue"];

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: ResponsiveHelper.w(16)),
      height: ResponsiveHelper.h(48),
      decoration: BoxDecoration(
        color: AppColors.card,
        borderRadius: BorderRadius.circular(ResponsiveHelper.w(12)),
      ),
      child: Row(
        children: tabs.map((tab) {
          final isSelected = widget.selectedTab == tab;
          return Expanded(
            child: GestureDetector(
              onTap: () => widget.onTabChanged(tab),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: isSelected ? AppColors.surface : Colors.transparent,
                  borderRadius: BorderRadius.circular(ResponsiveHelper.w(12)),
                ),
                child: Text(
                  tab,
                  style: AppTypography.bodyMd.copyWith(
                    color: isSelected ? AppColors.onPrimary : AppColors.muted,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          );
        }).toList(),
      ),
    );
  }
}
