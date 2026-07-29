import 'package:flutter/material.dart';
import 'package:redesign/theme/app_colors.dart';
import 'package:redesign/theme/app_typography.dart';
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

  IconData _getSportIcon(String sport) {
    switch (sport.toLowerCase()) {
      case 'football':
        return Icons.sports_soccer;
      case 'cricket':
        return Icons.sports_cricket;
      case 'badminton':
      case 'tennis':
      case 'table tennis':
      case 'squash':
      case 'padel':
      case 'pickleball':
        return Icons.sports_tennis;
      case 'basketball':
        return Icons.sports_basketball;
      case 'volleyball':
        return Icons.sports_volleyball;
      case 'golf':
        return Icons.sports_golf;
      case 'hockey':
        return Icons.sports_hockey;
      default:
        return Icons.sports;
    }
  }

  @override
  Widget build(BuildContext context) {
    ResponsiveHelper.init(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            const Icon(Icons.sports_rounded, color: AppColors.accent, size: 18),
            SizedBox(width: context.widthPct(2)),
            Text(
              'Select Sport',
              style: AppTypography.headlineSm.copyWith(
                color: AppColors.accent,
                fontWeight: FontWeight.bold,
                fontSize: context.responsiveFont(14),
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ),
        SizedBox(height: context.heightPct(1.2)),

        // SEARCH BAR
        TextField(
          controller: searchController,
          style: AppTypography.bodySm.copyWith(
            color: AppColors.textPrimary,
            fontSize: context.responsiveFont(14),
          ),
          decoration: InputDecoration(
            hintText: 'Search sport (Football, Cricket, Badminton...)...',
            hintStyle: AppTypography.bodySm.copyWith(
              color: AppColors.muted.withValues(alpha: 0.6),
              fontSize: context.responsiveFont(13),
            ),
            prefixIcon: const Icon(Icons.search, color: AppColors.accent),
            suffixIcon: searchQuery.isNotEmpty
                ? IconButton(
                    icon: const Icon(Icons.clear, color: AppColors.muted),
                    onPressed: onClearSearch,
                  )
                : null,
            filled: true,
            fillColor: AppColors.card,
            contentPadding: EdgeInsets.symmetric(vertical: context.heightPct(1.5)),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(context.minDimensionPct(3.5)),
              borderSide: const BorderSide(color: AppColors.borderDark),
            ),
          ),
          onChanged: onSearchChanged,
        ),

        SizedBox(height: context.heightPct(1.5)),

        if (searchQuery.isEmpty) ...[
          Text(
            'Popular Sports',
            style: AppTypography.bodySm.copyWith(
              color: AppColors.textSecondary,
              fontSize: context.responsiveFont(12),
              fontWeight: FontWeight.w600,
            ),
          ),
          SizedBox(height: context.heightPct(1)),
          Wrap(
            spacing: context.widthPct(2.5),
            runSpacing: context.heightPct(1.2),
            children: popularSports.map((sport) {
              final isSelected = selectedSport == sport;
              return FilterChip(
                showCheckmark: false,
                avatar: Icon(
                  _getSportIcon(sport),
                  size: 16,
                  color: isSelected ? AppColors.background : AppColors.accent,
                ),
                label: Text(sport),
                selected: isSelected,
                selectedColor: AppColors.accent,
                backgroundColor: AppColors.card,
                labelStyle: AppTypography.bodySm.copyWith(
                  color: isSelected ? AppColors.background : AppColors.textPrimary,
                  fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
                  fontSize: context.responsiveFont(12),
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(context.minDimensionPct(3.5)),
                  side: BorderSide(
                    color: isSelected ? AppColors.accent : AppColors.borderDark,
                  ),
                ),
                onSelected: (selected) {
                  onSportSelected(selected ? sport : null);
                },
              );
            }).toList(),
          ),
        ] else ...[
          Text(
            'Search Results (${filteredSports.length})',
            style: AppTypography.bodySm.copyWith(
              color: AppColors.textSecondary,
              fontSize: context.responsiveFont(12),
              fontWeight: FontWeight.w600,
            ),
          ),
          SizedBox(height: context.heightPct(1)),
          if (filteredSports.isEmpty)
            Padding(
              padding: EdgeInsets.symmetric(vertical: context.heightPct(2)),
              child: Center(
                child: Text(
                  'No sport found matching "$searchQuery"',
                  style: AppTypography.bodySm.copyWith(
                    color: AppColors.muted,
                    fontSize: context.responsiveFont(13),
                  ),
                ),
              ),
            )
          else
            Wrap(
              spacing: context.widthPct(2.5),
              runSpacing: context.heightPct(1.2),
              children: filteredSports.map((sport) {
                final isSelected = selectedSport == sport;
                return FilterChip(
                  showCheckmark: false,
                  avatar: Icon(
                    _getSportIcon(sport),
                    size: 16,
                    color: isSelected ? AppColors.background : AppColors.accent,
                  ),
                  label: Text(sport),
                  selected: isSelected,
                  selectedColor: AppColors.accent,
                  backgroundColor: AppColors.card,
                  labelStyle: AppTypography.bodySm.copyWith(
                    color: isSelected ? AppColors.background : AppColors.textPrimary,
                    fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
                    fontSize: context.responsiveFont(12),
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(context.minDimensionPct(3.5)),
                    side: BorderSide(
                      color: isSelected ? AppColors.accent : AppColors.borderDark,
                    ),
                  ),
                  onSelected: (selected) {
                    onSportSelected(selected ? sport : null);
                  },
                );
              }).toList(),
            ),
        ],
      ],
    );
  }
}
