import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:redesign/theme/app_colors.dart';
import 'package:redesign/theme/responsive_helper.dart';

enum SortOption {
  matchesDesc, // More to less matches
  matchesAsc, // Less to more matches
  winRateDesc, // Win rate High to Low
  hoursDesc, // Hours High to Low
  alphabetical, // A-Z
}

class MyStatsFilterBar extends StatelessWidget {
  final String searchQuery;
  final ValueChanged<String> onSearchChanged;
  final String selectedCategory;
  final ValueChanged<String> onCategoryChanged;
  final SortOption selectedSort;
  final ValueChanged<SortOption> onSortChanged;

  const MyStatsFilterBar({
    super.key,
    required this.searchQuery,
    required this.onSearchChanged,
    required this.selectedCategory,
    required this.onCategoryChanged,
    required this.selectedSort,
    required this.onSortChanged,
  });

  String getSortLabel(SortOption option) {
    switch (option) {
      case SortOption.matchesDesc:
        return 'Matches: High to Low';
      case SortOption.matchesAsc:
        return 'Matches: Low to High';
      case SortOption.winRateDesc:
        return 'Win Rate: High to Low';
      case SortOption.hoursDesc:
        return 'Hours Played: High to Low';
      case SortOption.alphabetical:
        return 'Alphabetical (A-Z)';
    }
  }

  void _showSortBottomSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: AppColors.surface,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (ctx) {
        return Container(
          padding: EdgeInsets.all(ResponsiveHelper.w(20)),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Sort Sports Stats',
                    style: GoogleFonts.inter(
                      color: Colors.white,
                      fontSize: ResponsiveHelper.sp(16),
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.close, color: Colors.white70),
                    onPressed: () => Navigator.pop(ctx),
                  ),
                ],
              ),
              const Divider(color: AppColors.divider),
              ...SortOption.values.map((option) {
                final isSelected = option == selectedSort;
                return ListTile(
                  contentPadding: EdgeInsets.zero,
                  leading: Icon(
                    isSelected ? Icons.radio_button_checked : Icons.radio_button_off,
                    color: isSelected ? AppColors.accent : Colors.white54,
                  ),
                  title: Text(
                    getSortLabel(option),
                    style: GoogleFonts.inter(
                      color: isSelected ? AppColors.accent : Colors.white,
                      fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                    ),
                  ),
                  onTap: () {
                    onSortChanged(option);
                    Navigator.pop(ctx);
                  },
                );
              }),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    ResponsiveHelper.init(context);

    return Padding(
      padding: EdgeInsets.symmetric(horizontal: ResponsiveHelper.w(16)),
      child: Row(
        children: [
          // Search Input
          Expanded(
            child: Container(
              height: ResponsiveHelper.h(44),
              decoration: BoxDecoration(
                color: AppColors.surface,
                borderRadius: BorderRadius.circular(ResponsiveHelper.w(12)),
                border: Border.all(color: AppColors.divider),
              ),
              padding: EdgeInsets.symmetric(horizontal: ResponsiveHelper.w(12)),
              child: Row(
                children: [
                  const Icon(Icons.search, color: Colors.white54, size: 20),
                  SizedBox(width: ResponsiveHelper.w(8)),
                  Expanded(
                    child: TextField(
                      onChanged: onSearchChanged,
                      style: GoogleFonts.inter(
                        color: Colors.white,
                        fontSize: ResponsiveHelper.sp(13),
                      ),
                      decoration: InputDecoration(
                        hintText: 'Search sport...',
                        hintStyle: GoogleFonts.inter(
                          color: Colors.white38,
                          fontSize: ResponsiveHelper.sp(13),
                        ),
                        border: InputBorder.none,
                        isDense: true,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          SizedBox(width: ResponsiveHelper.w(10)),
          // Sort Button
          InkWell(
            onTap: () => _showSortBottomSheet(context),
            borderRadius: BorderRadius.circular(ResponsiveHelper.w(12)),
            child: Container(
              height: ResponsiveHelper.h(44),
              padding: EdgeInsets.symmetric(horizontal: ResponsiveHelper.w(12)),
              decoration: BoxDecoration(
                color: AppColors.surface,
                borderRadius: BorderRadius.circular(ResponsiveHelper.w(12)),
                border: Border.all(color: AppColors.divider),
              ),
              child: Row(
                children: [
                  const Icon(Icons.swap_vert_rounded, color: AppColors.accent, size: 20),
                  SizedBox(width: ResponsiveHelper.w(6)),
                  Text(
                    'Sort',
                    style: GoogleFonts.inter(
                      color: Colors.white,
                      fontSize: ResponsiveHelper.sp(12),
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
