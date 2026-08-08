import 'package:flutter/material.dart';
import 'package:redesign/theme/app_colors.dart';
import 'package:redesign/theme/app_typography.dart';
import 'package:redesign/theme/responsive_helper.dart';

class VenueTabbar extends StatelessWidget {
  final String selectedTab;
  final ValueChanged<String> onTabChanged;

  const VenueTabbar({
    super.key,
    required this.selectedTab,
    required this.onTabChanged,
  });

  static const List<String> tabs = ["PlayZ Venues", "Other Venue"];

  @override
  Widget build(BuildContext context) {
    ResponsiveHelper.init(context);

    return Container(
      margin: EdgeInsets.symmetric(horizontal: ResponsiveHelper.w(16.0)),
      height: ResponsiveHelper.h(48.0),
      padding: EdgeInsets.all(ResponsiveHelper.w(4.0)),
      decoration: BoxDecoration(
        color: AppColors.card,
        borderRadius: BorderRadius.circular(ResponsiveHelper.w(14.0)),
        border: Border.all(color: AppColors.borderDark, width: 1.0),
      ),
      child: Row(
        children: tabs.map((tab) {
          final isSelected = selectedTab == tab;
          return Expanded(
            child: GestureDetector(
              onTap: () => onTabChanged(tab),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: isSelected ? AppColors.primary : Colors.transparent,
                  borderRadius: BorderRadius.circular(ResponsiveHelper.w(10.0)),
                ),
                child: Text(
                  tab,
                  style: AppTypography.bodyMd.copyWith(
                    color: isSelected ? Colors.black : AppColors.mutedText,
                    fontSize: ResponsiveHelper.sp(13.5),
                    fontWeight: isSelected ? FontWeight.w900 : FontWeight.w600,
                  ).responsive(context),
                ),
              ),
            ),
          );
        }).toList(),
      ),
    );
  }
}
