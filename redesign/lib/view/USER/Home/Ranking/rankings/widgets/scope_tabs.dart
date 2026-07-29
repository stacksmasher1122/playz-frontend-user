import 'package:flutter/material.dart';
import 'package:redesign/theme/app_colors.dart';
import 'package:redesign/theme/app_dimensions.dart';
import 'package:redesign/theme/app_typography.dart';
import 'package:redesign/theme/responsive_helper.dart';

class ScopeTabs extends StatelessWidget {
  final int selected;
  final ValueChanged<int> onChanged;

  const ScopeTabs({
    super.key,
    required this.selected,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    ResponsiveHelper.init(context);
    final tabs = const ['Global', 'Friends', 'Groups'];

    return Padding(
      padding: EdgeInsets.symmetric(
        horizontal: context.widthPct(4),
        vertical: context.heightPct(1),
      ),
      child: Container(
        padding: EdgeInsets.all(context.widthPct(1)),
        decoration: BoxDecoration(
          color: AppColors.card,
          borderRadius: BorderRadius.circular(AppDimensions.radiusLg),
          border: Border.all(color: AppColors.borderDark),
        ),
        child: Row(
          children: List.generate(tabs.length, (i) {
            final active = selected == i;
            return Expanded(
              child: GestureDetector(
                onTap: () => onChanged(i),
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 200),
                  padding: EdgeInsets.symmetric(vertical: context.heightPct(1.2)),
                  decoration: BoxDecoration(
                    color: active ? AppColors.accent : Colors.transparent,
                    borderRadius: BorderRadius.circular(AppDimensions.radiusMd),
                  ),
                  child: Text(
                    tabs[i],
                    textAlign: TextAlign.center,
                    style: AppTypography.headlineSm.copyWith(
                      color: active ? AppColors.background : AppColors.textSecondary,
                      fontSize: context.responsiveFont(13),
                      fontWeight: active ? FontWeight.bold : FontWeight.w600,
                    ),
                  ),
                ),
              ),
            );
          }),
        ),
      ),
    );
  }
}
