import 'package:flutter/material.dart';
import 'package:redesign/theme/app_colors.dart';
import 'package:redesign/theme/app_typography.dart';
import 'package:redesign/theme/responsive_helper.dart';

class TrainersToggle extends StatelessWidget {
  final bool isMyTrainers;
  final ValueChanged<bool> onChanged;

  const TrainersToggle({
    super.key,
    required this.isMyTrainers,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    ResponsiveHelper.init(context);
    return Container(
      margin: EdgeInsets.symmetric(
        horizontal: context.widthPct(4),
        vertical: context.heightPct(1.2),
      ),
      padding: EdgeInsets.all(context.widthPct(1)),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(context.minDimensionPct(7)),
      ),
      child: Row(
        children: [
          _tab(
            context: context,
            label: 'My Trainers',
            active: isMyTrainers,
            onTap: () => onChanged(true),
          ),
          _tab(
            context: context,
            label: 'Other Trainers',
            active: !isMyTrainers,
            onTap: () => onChanged(false),
          ),
        ],
      ),
    );
  }

  Widget _tab({
    required BuildContext context,
    required String label,
    required bool active,
    required VoidCallback onTap,
  }) {
    return Expanded(
      child: GestureDetector(
        onTap: onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 220),
          curve: Curves.easeOut,
          padding: EdgeInsets.symmetric(vertical: context.heightPct(1.4)),
          decoration: BoxDecoration(
            color: active ? AppColors.accent : Colors.transparent,
            borderRadius: BorderRadius.circular(context.minDimensionPct(6)),
          ),
          child: Text(
            label,
            textAlign: TextAlign.center,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: AppTypography.headlineSm.copyWith(
              color: active ? AppColors.background : AppColors.textPrimary,
              fontWeight: FontWeight.w600,
              fontSize: context.responsiveFont(13),
            ),
          ),
        ),
      ),
    );
  }
}
