import 'package:flutter/material.dart';
import 'package:redesign/theme/app_typography.dart';
import 'package:redesign/theme/app_colors.dart';
import 'package:redesign/theme/responsive_helper.dart';
import 'sport_card_widget.dart';

class SportSelectorWidget extends StatefulWidget {
  final List<String> sports;
  final String selectedSport;
  final Function(String) onSportSelected;

  const SportSelectorWidget({
    super.key,
    required this.sports,
    required this.selectedSport,
    required this.onSportSelected,
  });

  
  @override
  State<SportSelectorWidget> createState() => _SportSelectorWidgetState();
}

class _SportSelectorWidgetState extends State<SportSelectorWidget> {
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "Select Sport",
          style: AppTypography.headlineMd.copyWith(
            color: AppColors.onPrimary,
            fontWeight: FontWeight.bold,
          ),
        ),
        SizedBox(height: ResponsiveHelper.h(12)),
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          physics: const BouncingScrollPhysics(),
          child: Row(
            children: widget.sports.map((sport) {
              return SportCardWidget(
                sport: sport,
                isSelected: sport == widget.selectedSport,
                onTap: () => widget.onSportSelected(sport),
              );
            }).toList(),
          ),
        ),
      ],
    );
  }
}
