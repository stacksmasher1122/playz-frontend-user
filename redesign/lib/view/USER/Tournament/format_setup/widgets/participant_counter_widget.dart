import 'package:flutter/material.dart';
import 'package:redesign/theme/app_colors.dart';
import 'package:redesign/theme/app_typography.dart';
import 'package:redesign/theme/responsive_helper.dart';

class ParticipantCounterWidget extends StatelessWidget {
  final String title;
  final String subtitle;
  final int count;
  final VoidCallback onIncrement;
  final VoidCallback onDecrement;
  final ValueChanged<int>? onPresetSelected;

  const ParticipantCounterWidget({
    super.key,
    this.title = "MAX NO. OF TEAMS",
    this.subtitle = "Powers of 2 (4, 8, 16, 32) make clean tournament brackets",
    required this.count,
    required this.onIncrement,
    required this.onDecrement,
    this.onPresetSelected,
  });

  static const List<int> presets = [4, 8, 16, 32];

  @override
  Widget build(BuildContext context) {
    ResponsiveHelper.init(context);

    return Container(
      padding: EdgeInsets.all(ResponsiveHelper.w(16.0)),
      decoration: BoxDecoration(
        color: AppColors.card,
        borderRadius: BorderRadius.circular(ResponsiveHelper.w(14.0)),
        border: Border.all(color: AppColors.borderDark, width: 1.0),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                Icons.emoji_events_rounded,
                color: AppColors.primary,
                size: ResponsiveHelper.w(20.0),
              ),
              SizedBox(width: ResponsiveHelper.w(10.0)),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: AppTypography.labelCaps.copyWith(
                        color: AppColors.textPrimary,
                        fontSize: ResponsiveHelper.sp(13.0),
                        fontWeight: FontWeight.w900,
                        letterSpacing: 0.8,
                      ).responsive(context),
                    ),
                    SizedBox(height: ResponsiveHelper.h(2.0)),
                    Text(
                      subtitle,
                      style: AppTypography.bodySm.copyWith(
                        color: AppColors.mutedText,
                        fontSize: ResponsiveHelper.sp(12.0),
                      ).responsive(context),
                    ),
                  ],
                ),
              ),
              Row(
                children: [
                  InkWell(
                    onTap: onDecrement,
                    borderRadius: BorderRadius.circular(ResponsiveHelper.w(8.0)),
                    child: Container(
                      width: ResponsiveHelper.w(32.0),
                      height: ResponsiveHelper.w(32.0),
                      decoration: BoxDecoration(
                        color: AppColors.surfaceElevated,
                        borderRadius: BorderRadius.circular(ResponsiveHelper.w(8.0)),
                        border: Border.all(color: AppColors.borderDark),
                      ),
                      child: Icon(
                        Icons.remove_rounded,
                        color: AppColors.textPrimary,
                        size: ResponsiveHelper.w(18.0),
                      ),
                    ),
                  ),
                  SizedBox(
                    width: ResponsiveHelper.w(38.0),
                    child: Text(
                      "$count",
                      textAlign: TextAlign.center,
                      style: AppTypography.headlineSm.copyWith(
                        color: AppColors.primary,
                        fontSize: ResponsiveHelper.sp(17.0),
                        fontWeight: FontWeight.w900,
                      ).responsive(context),
                    ),
                  ),
                  InkWell(
                    onTap: onIncrement,
                    borderRadius: BorderRadius.circular(ResponsiveHelper.w(8.0)),
                    child: Container(
                      width: ResponsiveHelper.w(32.0),
                      height: ResponsiveHelper.w(32.0),
                      decoration: BoxDecoration(
                        color: AppColors.primary,
                        borderRadius: BorderRadius.circular(ResponsiveHelper.w(8.0)),
                      ),
                      child: Icon(
                        Icons.add_rounded,
                        color: Colors.black,
                        size: ResponsiveHelper.w(18.0),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
          if (onPresetSelected != null) ...[
            SizedBox(height: ResponsiveHelper.h(14.0)),
            Row(
              children: presets.map((preset) {
                final isSelected = count == preset;
                return Expanded(
                  child: Padding(
                    padding: EdgeInsets.only(
                      right: preset != presets.last ? ResponsiveHelper.w(6.0) : 0,
                    ),
                    child: InkWell(
                      onTap: () => onPresetSelected!(preset),
                      borderRadius: BorderRadius.circular(ResponsiveHelper.w(8.0)),
                      child: Container(
                        padding: EdgeInsets.symmetric(
                          vertical: ResponsiveHelper.h(8.0),
                        ),
                        decoration: BoxDecoration(
                          color: isSelected
                              ? AppColors.primary.withValues(alpha: 0.15)
                              : AppColors.surfaceElevated,
                          borderRadius: BorderRadius.circular(ResponsiveHelper.w(8.0)),
                          border: Border.all(
                            color: isSelected ? AppColors.primary : AppColors.borderDark,
                            width: isSelected ? 1.5 : 1.0,
                          ),
                        ),
                        alignment: Alignment.center,
                        child: Text(
                          "$preset Teams",
                          style: AppTypography.bodySm.copyWith(
                            color: isSelected ? AppColors.primary : AppColors.mutedText,
                            fontSize: ResponsiveHelper.sp(11.5),
                            fontWeight: isSelected ? FontWeight.w900 : FontWeight.w600,
                          ).responsive(context),
                        ),
                      ),
                    ),
                  ),
                );
              }).toList(),
            ),
          ],
        ],
      ),
    );
  }
}
