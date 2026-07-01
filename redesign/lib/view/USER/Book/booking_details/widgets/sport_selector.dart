import 'package:flutter/material.dart';
import 'package:redesign/theme/app_colors.dart';
import 'package:redesign/theme/responsive_helper.dart';

class SportSelector extends StatelessWidget {
  final String? selectedSport;
  final ValueChanged<String> onSportSelected;

  SportSelector({
    super.key,
    required this.selectedSport,
    required this.onSportSelected,
  });

  @override
  Widget build(BuildContext context) {
    ResponsiveHelper.init(context);
    final sports = ['Football', 'Cricket', 'Tennis'];

    return Padding(
      padding: EdgeInsets.symmetric(horizontal: ResponsiveHelper.w(16)),
      child: Wrap(
        spacing: 12,
        runSpacing: 12,
        children: sports.map((sport) {
          final bool isActive = selectedSport == sport;

          return _SportPill(
            label: sport,
            active: isActive,
            onTap: () => onSportSelected(sport),
          );
        }).toList(),
      ),
    );
  }
}

class _SportPill extends StatelessWidget {
  final String label;
  final bool active;
  final VoidCallback onTap;

  _SportPill({
    required this.label,
    required this.active,
    required this.onTap,
  });

  static const _kGreen = AppColors.accent;

  @override
  Widget build(BuildContext context) {
    ResponsiveHelper.init(context);
    return InkWell(
      borderRadius: BorderRadius.circular(ResponsiveHelper.w(30)),
      onTap: onTap,
      child: AnimatedContainer(
        duration: Duration(milliseconds: 180),
        curve: Curves.easeOut,
        padding: EdgeInsets.symmetric(horizontal: ResponsiveHelper.w(18), vertical: ResponsiveHelper.h(10)),
        decoration: BoxDecoration(
          color: active ? _kGreen.withValues(alpha: 0.15) : Colors.black,
          borderRadius: BorderRadius.circular(ResponsiveHelper.w(30)),
          border: Border.all(
            color: active ? _kGreen : Colors.grey.shade700,
            width: active ? 1.4 : 1,
          ),
        ),
        child: Text(
          label,
          style: TextStyle(
            color: active ? _kGreen : Colors.white,
            fontSize: ResponsiveHelper.sp(14),
            fontWeight: FontWeight.w600,
            letterSpacing: 0.2,
          ),
        ),
      ),
    );
  }
}
