import 'package:flutter/material.dart';
import 'package:redesign/theme/app_typography.dart';
import 'package:redesign/theme/app_colors.dart';
import 'package:redesign/theme/responsive_helper.dart';
import 'sport_card_widget.dart';

class SportSelectorWidget extends StatelessWidget {
  final List<String> sports;
  final String selectedSport;
  final ValueChanged<String> onSportSelected;
  final ValueChanged<String> onSearchChanged;
  final String searchQuery;

  const SportSelectorWidget({
    super.key,
    required this.sports,
    required this.selectedSport,
    required this.onSportSelected,
    required this.onSearchChanged,
    required this.searchQuery,
  });

  @override
  Widget build(BuildContext context) {
    ResponsiveHelper.init(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              "Select Sport",
              style: AppTypography.headlineSm.copyWith(
                color: AppColors.textPrimary,
                fontSize: ResponsiveHelper.sp(16.0),
                fontWeight: FontWeight.w900,
              ).responsive(context),
            ),
            Text(
              "${sports.length} Available",
              style: AppTypography.bodySm.copyWith(
                color: AppColors.mutedText,
                fontSize: ResponsiveHelper.sp(12.0),
                fontWeight: FontWeight.w600,
              ).responsive(context),
            ),
          ],
        ),
        SizedBox(height: ResponsiveHelper.h(10.0)),

        // Spotify Dark Theme Search Bar for Sports
        Container(
          height: ResponsiveHelper.h(48.0),
          decoration: BoxDecoration(
            color: AppColors.card,
            borderRadius: BorderRadius.circular(ResponsiveHelper.w(12.0)),
            border: Border.all(color: AppColors.borderDark, width: 1.0),
          ),
          child: TextField(
            onChanged: onSearchChanged,
            style: AppTypography.bodyMd.copyWith(
              color: AppColors.textPrimary,
              fontSize: ResponsiveHelper.sp(14.0),
            ).responsive(context),
            decoration: InputDecoration(
              hintText: 'Search sport (e.g. Cricket, Tennis, Football)...',
              hintStyle: AppTypography.bodySm.copyWith(
                color: AppColors.mutedText,
                fontSize: ResponsiveHelper.sp(13.0),
              ).responsive(context),
              prefixIcon: Icon(
                Icons.search_rounded,
                color: AppColors.primary,
                size: ResponsiveHelper.w(20.0),
              ),
              suffixIcon: searchQuery.isNotEmpty
                  ? IconButton(
                      icon: Icon(
                        Icons.close_rounded,
                        color: AppColors.muted,
                        size: ResponsiveHelper.w(18.0),
                      ),
                      onPressed: () => onSearchChanged(''),
                    )
                  : null,
              border: InputBorder.none,
              contentPadding: EdgeInsets.symmetric(
                vertical: ResponsiveHelper.h(12.0),
              ),
            ),
          ),
        ),
        SizedBox(height: ResponsiveHelper.h(14.0)),

        // Filtered Horizontal Sports Cards List
        if (sports.isEmpty)
          Container(
            padding: EdgeInsets.symmetric(vertical: ResponsiveHelper.h(16.0)),
            alignment: Alignment.center,
            child: Text(
              'No sports found matching "$searchQuery"',
              style: AppTypography.bodySm.copyWith(
                color: AppColors.mutedText,
                fontSize: ResponsiveHelper.sp(13.0),
                fontStyle: FontStyle.italic,
              ).responsive(context),
            ),
          )
        else
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            physics: const BouncingScrollPhysics(),
            child: Row(
              children: sports.map((sport) {
                return SportCardWidget(
                  sport: sport,
                  isSelected: sport == selectedSport,
                  onTap: () => onSportSelected(sport),
                );
              }).toList(),
            ),
          ),
      ],
    );
  }
}
