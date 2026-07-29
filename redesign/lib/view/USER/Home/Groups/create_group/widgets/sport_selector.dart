import 'package:flutter/material.dart';
import 'package:redesign/theme/app_colors.dart';
import 'package:redesign/theme/app_typography.dart';
import 'package:redesign/theme/responsive_helper.dart';

class SportSelector extends StatefulWidget {
  final List<String> sports;
  final String selectedSport;
  final Function(String) onSportSelected;

  const SportSelector({
    super.key,
    required this.sports,
    required this.selectedSport,
    required this.onSportSelected,
  });

  @override
  State<SportSelector> createState() => _SportSelectorState();
}

class _SportSelectorState extends State<SportSelector> {
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';

  @override
  void initState() {
    super.initState();
    _searchController.addListener(() {
      setState(() {
        _searchQuery = _searchController.text.trim();
      });
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    ResponsiveHelper.init(context);

    // Filter sports list based on search query
    final filteredSports = widget.sports
        .where((sport) => sport.toLowerCase().contains(_searchQuery.toLowerCase()))
        .toList();

    // Check if query matches any sport in full list
    final hasExactMatch = widget.sports.any(
      (s) => s.toLowerCase() == _searchQuery.toLowerCase(),
    );

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Spotify Style Search Bar
        Container(
          height: context.heightPct(5.5).clamp(44.0, 50.0),
          decoration: BoxDecoration(
            color: AppColors.surface,
            borderRadius: BorderRadius.circular(context.minDimensionPct(50)),
            border: Border.all(color: AppColors.borderDark),
          ),
          child: TextField(
            controller: _searchController,
            style: AppTypography.bodyMd.copyWith(
              color: AppColors.textPrimary,
              fontSize: context.responsiveFont(13.5),
            ),
            decoration: InputDecoration(
              hintText: 'Search sport...',
              hintStyle: AppTypography.bodyMd.copyWith(
                color: AppColors.muted,
                fontSize: context.responsiveFont(13),
              ),
              prefixIcon: Icon(
                Icons.search_rounded,
                color: AppColors.muted,
                size: context.responsiveFont(20),
              ),
              suffixIcon: _searchQuery.isNotEmpty
                  ? IconButton(
                      icon: Icon(
                        Icons.close_rounded,
                        color: AppColors.muted,
                        size: context.responsiveFont(18),
                      ),
                      onPressed: () => _searchController.clear(),
                    )
                  : null,
              border: InputBorder.none,
              contentPadding: EdgeInsets.symmetric(
                vertical: context.heightPct(1.2),
              ),
            ),
          ),
        ),
        SizedBox(height: context.heightPct(1.5)),

        // Spotify Style Sports Pills (Clean Flat Design, No Glow)
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          physics: const BouncingScrollPhysics(),
          child: Row(
            children: [
              ...filteredSports.map((sport) {
                final isSelected = widget.selectedSport == sport;
                return Padding(
                  padding: EdgeInsets.only(right: context.widthPct(2.5)),
                  child: InkWell(
                    onTap: () => widget.onSportSelected(sport),
                    borderRadius: BorderRadius.circular(context.minDimensionPct(50)),
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 200),
                      padding: EdgeInsets.symmetric(
                        horizontal: context.widthPct(4.5),
                        vertical: context.heightPct(1.1),
                      ),
                      decoration: BoxDecoration(
                        color: isSelected ? AppColors.accent : AppColors.surface,
                        borderRadius: BorderRadius.circular(context.minDimensionPct(50)),
                      ),
                      child: FittedBox(
                        fit: BoxFit.scaleDown,
                        child: Text(
                          sport,
                          style: AppTypography.bodySm.copyWith(
                            color: isSelected ? AppColors.background : AppColors.textPrimary,
                            fontSize: context.responsiveFont(13),
                            fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
                          ),
                        ),
                      ),
                    ),
                  ),
                );
              }),

              if (_searchQuery.isNotEmpty && !hasExactMatch)
                Padding(
                  padding: EdgeInsets.only(right: context.widthPct(2.5)),
                  child: InkWell(
                    onTap: () => widget.onSportSelected(_searchQuery),
                    borderRadius: BorderRadius.circular(context.minDimensionPct(50)),
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 200),
                      padding: EdgeInsets.symmetric(
                        horizontal: context.widthPct(4.5),
                        vertical: context.heightPct(1.1),
                      ),
                      decoration: BoxDecoration(
                        color: widget.selectedSport == _searchQuery
                            ? AppColors.accent
                            : AppColors.card,
                        borderRadius: BorderRadius.circular(context.minDimensionPct(50)),
                        border: Border.all(
                          color: widget.selectedSport == _searchQuery
                              ? AppColors.accent
                              : AppColors.borderDark,
                          width: 1,
                        ),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            Icons.add_rounded,
                            color: widget.selectedSport == _searchQuery
                                ? AppColors.background
                                : AppColors.accent,
                            size: context.responsiveFont(16),
                          ),
                          SizedBox(width: context.widthPct(1)),
                          Text(
                            _searchQuery,
                            style: AppTypography.bodySm.copyWith(
                              color: widget.selectedSport == _searchQuery
                                  ? AppColors.background
                                  : AppColors.accent,
                              fontSize: context.responsiveFont(13),
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
            ],
          ),
        ),
      ],
    );
  }
}
