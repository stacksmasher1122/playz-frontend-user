import 'package:flutter/material.dart';
import 'package:redesign/theme/app_colors.dart';
import 'package:redesign/theme/app_typography.dart';
import 'package:redesign/theme/responsive_helper.dart';

class ModeSelector extends StatelessWidget {
  final bool isSingles;
  final ValueChanged<bool> onChanged;

  ModeSelector({
    super.key,
    required this.isSingles,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    ResponsiveHelper.init(context);
    return Container(
      width: ResponsiveHelper.w(240),
      height: ResponsiveHelper.h(48),
      decoration: BoxDecoration(
        color: AppColors.outlineVariant,
        borderRadius: BorderRadius.circular(ResponsiveHelper.w(24)),
      ),
      child: Row(
        children: [
          Expanded(
            child: GestureDetector(
              onTap: () => onChanged(true),
              child: AnimatedContainer(
                duration: Duration(milliseconds: 200),
                decoration: BoxDecoration(
                  color: isSingles ? AppColors.accent : Colors.transparent,
                  borderRadius: BorderRadius.circular(ResponsiveHelper.w(24)),
                ),
                child: Center(
                  child: Text(
                    'SINGLES',
                    style: AppTypography.labelCaps.copyWith(
                      color: isSingles ? Colors.black : AppColors.accent,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 1.5,
                    ),
                  ),
                ),
              ),
            ),
          ),
          Expanded(
            child: GestureDetector(
              onTap: () => onChanged(false),
              child: AnimatedContainer(
                duration: Duration(milliseconds: 200),
                decoration: BoxDecoration(
                  color: !isSingles ? AppColors.accent : Colors.transparent,
                  borderRadius: BorderRadius.circular(ResponsiveHelper.w(24)),
                ),
                child: Center(
                  child: Text(
                    'DOUBLES',
                    style: AppTypography.labelCaps.copyWith(
                      color: !isSingles ? Colors.black : AppColors.accent,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 1.5,
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
