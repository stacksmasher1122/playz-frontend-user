import 'package:flutter/material.dart';
import 'package:redesign/theme/responsive_helper.dart';

const kSurface = Color(0xFF161616);
const kGreen = Color(0xFF6EDC6A);
const kMuted = Colors.white54;

class SportSelector extends StatelessWidget {
  final List<String> sports;
  final String selectedSport;
  final Function(String) onSportSelected;

  SportSelector({
    super.key,
    required this.sports,
    required this.selectedSport,
    required this.onSportSelected,
  });

  @override
  Widget build(BuildContext context) {
    ResponsiveHelper.init(context);
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      physics: BouncingScrollPhysics(),
      child: Row(
        children: sports.map((sport) {
          final isSelected = selectedSport == sport;
          return Padding(
            padding: EdgeInsets.only(right: 12),
            child: InkWell(
              onTap: () => onSportSelected(sport),
              borderRadius: BorderRadius.circular(ResponsiveHelper.w(20)),
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: ResponsiveHelper.w(20), vertical: ResponsiveHelper.h(10)),
                decoration: BoxDecoration(
                  color: isSelected ? Colors.transparent : kSurface,
                  borderRadius: BorderRadius.circular(ResponsiveHelper.w(20)),
                  border: Border.all(
                    color: isSelected ? kGreen : Colors.transparent,
                    width: ResponsiveHelper.w(1),
                  ),
                ),
                child: Text(
                  sport,
                  style: TextStyle(
                    color: isSelected ? kGreen : kMuted,
                    fontSize: ResponsiveHelper.sp(13),
                    fontWeight: FontWeight.w600,
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
