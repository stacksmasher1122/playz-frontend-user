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
    ResponsiveHelper.init(context);

    return Container(
      margin: EdgeInsets.symmetric(horizontal: context.widthPct(4)),
      height: context.heightPct(6).clamp(44.0, 52.0),
      decoration: BoxDecoration(
        color: AppColors.card,
        borderRadius: BorderRadius.circular(context.minDimensionPct(3.5)),
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
                  color: isSelected ? AppColors.surface : AppColors.card,
                  borderRadius: BorderRadius.circular(context.minDimensionPct(3.5)),
                ),
                child: FittedBox(
                  fit: BoxFit.scaleDown,
                  child: Text(
                    tab,
                    style: AppTypography.bodyMd.copyWith(
                      color: isSelected ? AppColors.textPrimary : AppColors.muted,
                      fontSize: context.responsiveFont(13.5),
                      fontWeight: FontWeight.bold,
                    ),
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
