import 'package:flutter/material.dart';
import 'package:redesign/theme/app_colors.dart';
import 'package:redesign/theme/responsive_helper.dart';

Color kGreen = AppColors.accent;
Color kSurface = Color(0xFF0E0E0E);

class SportFilterRow extends StatelessWidget {
  final int selected;
  final ValueChanged<int> onChanged;

  SportFilterRow({
    super.key,
    required this.selected,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    ResponsiveHelper.init(context);
    final sports = ['All Sports', 'Cricket', 'Football', 'Badminton', 'Tennis'];

    return SizedBox(
      height: ResponsiveHelper.h(48),
      child: ListView.separated(
        padding: EdgeInsets.symmetric(horizontal: ResponsiveHelper.w(16)),
        scrollDirection: Axis.horizontal,
        itemCount: sports.length,
        separatorBuilder: (_, __) => SizedBox(width: 8),
        itemBuilder: (_, i) {
          final active = selected == i;
          return ChoiceChip(
            selected: active,
            label: Text(sports[i]),
            selectedColor: kGreen.withValues(alpha: 0.2),
            backgroundColor: kSurface,
            labelStyle: TextStyle(
              color: active ? kGreen : Colors.white,
              fontWeight: FontWeight.w600,
            ),
            onSelected: (_) => onChanged(i),
          );
        },
      ),
    );
  }
}
