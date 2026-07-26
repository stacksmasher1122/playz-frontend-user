import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:redesign/theme/app_colors.dart';
import 'package:redesign/theme/responsive_helper.dart';

class SportSelectionSection extends StatelessWidget {
  final TextEditingController searchController;
  final String searchQuery;
  final String? selectedSport;
  final List<String> popularSports;
  final List<String> filteredSports;
  final ValueChanged<String> onSearchChanged;
  final ValueChanged<String?> onSportSelected;
  final VoidCallback onClearSearch;

  const SportSelectionSection({
    super.key,
    required this.searchController,
    required this.searchQuery,
    required this.selectedSport,
    required this.popularSports,
    required this.filteredSports,
    required this.onSearchChanged,
    required this.onSportSelected,
    required this.onClearSearch,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Section Title
        Row(
          children: [
            const Icon(Icons.sports, color: AppColors.accent, size: 18),
            const SizedBox(width: 8),
            Text(
              'Select Sport',
              style: GoogleFonts.inter(
                color: AppColors.accent,
                fontWeight: FontWeight.bold,
                fontSize: ResponsiveHelper.sp(14),
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),

        // Sports Search Bar
        TextField(
          controller: searchController,
          style: const TextStyle(color: Colors.white),
          decoration: InputDecoration(
            hintText: 'Search sports (e.g. Football, Cricket)...',
            hintStyle: const TextStyle(color: Colors.white38),
            prefixIcon: const Icon(Icons.search, color: AppColors.accent),
            suffixIcon: searchQuery.isNotEmpty
                ? IconButton(
                    icon: const Icon(Icons.clear, color: Colors.white54),
                    onPressed: onClearSearch,
                  )
                : null,
            filled: true,
            fillColor: AppColors.card,
            contentPadding: const EdgeInsets.symmetric(vertical: 12),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(14),
              borderSide: const BorderSide(color: Colors.white12),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(14),
              borderSide: const BorderSide(color: AppColors.accent),
            ),
          ),
          onChanged: onSearchChanged,
        ),
        const SizedBox(height: 10),

        // 1. AFTER SELECTING A SPORT: Search results & Popular Sports are replaced by selected sport pill (with cross X icon)
        if (selectedSport != null) ...[
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
            decoration: BoxDecoration(
              color: AppColors.accent,
              borderRadius: BorderRadius.circular(20),
              boxShadow: [
                BoxShadow(
                  color: AppColors.accent.withValues(alpha: 0.3),
                  blurRadius: 8,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  selectedSport!,
                  style: GoogleFonts.inter(
                    color: Colors.black,
                    fontWeight: FontWeight.bold,
                    fontSize: ResponsiveHelper.sp(13),
                  ),
                ),
                const SizedBox(width: 8),
                GestureDetector(
                  onTap: () => onSportSelected(null),
                  child: const Icon(
                    Icons.cancel,
                    color: Colors.black54,
                    size: 18,
                  ),
                ),
              ],
            ),
          ),
        ]
        // 2. IF NO SPORT IS SELECTED & USER IS SEARCHING: Show Search Results Pills below search bar
        else if (searchQuery.isNotEmpty) ...[
          Text(
            'Search Results:',
            style: GoogleFonts.inter(
              color: Colors.white54,
              fontSize: ResponsiveHelper.sp(12),
            ),
          ),
          const SizedBox(height: 6),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: filteredSports.map((sport) {
              return GestureDetector(
                onTap: () => onSportSelected(sport),
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                  decoration: BoxDecoration(
                    color: AppColors.card,
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(color: Colors.white12),
                  ),
                  child: Text(
                    sport,
                    style: GoogleFonts.inter(
                      color: Colors.white,
                      fontWeight: FontWeight.w500,
                      fontSize: ResponsiveHelper.sp(13),
                    ),
                  ),
                ),
              );
            }).toList(),
          ),
        ]
        // 3. POPULAR SPORTS SECTION (Only visible when NO sport is selected)
        else ...[
          Text(
            'Popular Sports',
            style: GoogleFonts.inter(
              color: Colors.white70,
              fontWeight: FontWeight.w600,
              fontSize: ResponsiveHelper.sp(12),
            ),
          ),
          const SizedBox(height: 8),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: popularSports.map((sport) {
              return ChoiceChip(
                showCheckmark: false, // NO TICK ICON
                label: Text(sport),
                selected: false,
                selectedColor: AppColors.accent,
                backgroundColor: AppColors.card,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                  side: const BorderSide(color: Colors.white12),
                ),
                labelStyle: GoogleFonts.inter(
                  color: Colors.white70,
                  fontWeight: FontWeight.w500,
                  fontSize: ResponsiveHelper.sp(13),
                ),
                onSelected: (val) {
                  if (val) onSportSelected(sport);
                },
              );
            }).toList(),
          ),
        ],
      ],
    );
  }
}
