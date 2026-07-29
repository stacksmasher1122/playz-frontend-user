import 'package:flutter/material.dart';
import 'package:redesign/theme/app_colors.dart';
import 'package:redesign/theme/app_dimensions.dart';
import 'package:redesign/theme/app_typography.dart';
import 'package:redesign/theme/responsive_helper.dart';

class SportFilterRow extends StatelessWidget {
  final int selected;
  final ValueChanged<int> onChanged;

  const SportFilterRow({
    super.key,
    required this.selected,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    ResponsiveHelper.init(context);
    final sports = const ['All Sports', 'Football', 'Cricket', 'Badminton', 'Tennis'];

    return SizedBox(
      height: context.heightPct(5.5).clamp(42.0, 50.0),
      child: ListView.separated(
        padding: EdgeInsets.symmetric(horizontal: context.widthPct(4)),
        scrollDirection: Axis.horizontal,
        physics: const BouncingScrollPhysics(),
        itemCount: sports.length,
        separatorBuilder: (_, __) => SizedBox(width: context.widthPct(2)),
        itemBuilder: (_, i) {
          final active = selected == i;
          return ChoiceChip(
            selected: active,
            label: Text(
              sports[i],
              style: AppTypography.bodySm.copyWith(
                color: active ? AppColors.background : AppColors.textPrimary,
                fontSize: context.responsiveFont(13),
                fontWeight: active ? FontWeight.bold : FontWeight.w500,
              ),
            ),
            selectedColor: AppColors.accent,
            backgroundColor: AppColors.card,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(AppDimensions.radiusFull),
              side: BorderSide(
                color: active ? AppColors.accent : AppColors.borderDark,
              ),
            ),
            showCheckmark: false,
            onSelected: (_) => onChanged(i),
          );
        },
      ),
    );
  }
}
