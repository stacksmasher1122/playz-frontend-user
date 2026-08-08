import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:redesign/theme/app_colors.dart';
import 'package:redesign/theme/app_typography.dart';
import 'package:redesign/theme/responsive_helper.dart';

/// A reusable, app-themed Match Duration stepper card for sport setup screens.
/// Features a stepper (- / +) with custom label, duration display in minutes,
/// and optional quick-select preset duration chips.
class CommonMatchDurationCard extends StatelessWidget {
  final String title;
  final String subtitle;
  final RxInt durationMinutes;
  final VoidCallback onDecrement;
  final VoidCallback onIncrement;
  final List<int> presetMinutes;
  final ValueChanged<int>? onPresetSelected;
  final int step;
  final int minDuration;
  final int maxDuration;

  const CommonMatchDurationCard({
    super.key,
    this.title = 'MATCH DURATION',
    this.subtitle = 'Duration in\nMinutes',
    required this.durationMinutes,
    required this.onDecrement,
    required this.onIncrement,
    this.presetMinutes = const [10, 20, 30, 45, 90],
    this.onPresetSelected,
    this.step = 5,
    this.minDuration = 5,
    this.maxDuration = 180,
  });

  @override
  Widget build(BuildContext context) {
    ResponsiveHelper.init(context);

    return Container(
      decoration: BoxDecoration(
        color: AppColors.cardSurface,
        borderRadius: BorderRadius.circular(ResponsiveHelper.w(20.0)),
        border: Border.all(color: Colors.white.withValues(alpha: 0.05)),
      ),
      padding: EdgeInsets.all(ResponsiveHelper.w(20.0)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              // Left Title & Subtitle Column
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      title,
                      style: AppTypography.labelCaps.copyWith(
                        color: AppColors.mutedText,
                        fontSize: ResponsiveHelper.sp(11.0),
                        fontWeight: FontWeight.w800,
                        letterSpacing: 1.2,
                      ).responsive(context),
                    ),
                    SizedBox(height: ResponsiveHelper.h(6.0)),
                    Text(
                      subtitle,
                      style: AppTypography.headlineSm.copyWith(
                        color: AppColors.textPrimary,
                        fontSize: ResponsiveHelper.sp(16.0),
                        fontWeight: FontWeight.bold,
                        height: 1.2,
                      ).responsive(context),
                    ),
                  ],
                ),
              ),

              // Right Stepper Controls
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  _buildCircleButton(
                    context,
                    icon: Icons.remove,
                    onTap: onDecrement,
                  ),
                  SizedBox(width: ResponsiveHelper.w(14.0)),
                  Obx(
                    () => Text(
                      '${durationMinutes.value} m',
                      style: AppTypography.displayLg.copyWith(
                        color: AppColors.accent,
                        fontSize: ResponsiveHelper.sp(22.0),
                        fontWeight: FontWeight.w900,
                      ).responsive(context),
                    ),
                  ),
                  SizedBox(width: ResponsiveHelper.w(14.0)),
                  _buildCircleButton(
                    context,
                    icon: Icons.add,
                    onTap: onIncrement,
                  ),
                ],
              ),
            ],
          ),

          // Optional Preset Quick Select Chips
          if (presetMinutes.isNotEmpty && onPresetSelected != null) ...[
            SizedBox(height: ResponsiveHelper.h(16.0)),
            Divider(color: Colors.white.withValues(alpha: 0.06), height: 1.0),
            SizedBox(height: ResponsiveHelper.h(14.0)),
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: presetMinutes.map((mins) {
                  return Obx(() {
                    final bool isSelected = durationMinutes.value == mins;
                    return Padding(
                      padding: EdgeInsets.only(right: ResponsiveHelper.w(8.0)),
                      child: InkWell(
                        onTap: () => onPresetSelected!(mins),
                        borderRadius: BorderRadius.circular(ResponsiveHelper.w(12.0)),
                        child: Container(
                          padding: EdgeInsets.symmetric(
                            horizontal: ResponsiveHelper.w(14.0),
                            vertical: ResponsiveHelper.h(8.0),
                          ),
                          decoration: BoxDecoration(
                            color: isSelected
                                ? AppColors.accent.withValues(alpha: 0.2)
                                : const Color(0xFF131313),
                            borderRadius: BorderRadius.circular(ResponsiveHelper.w(12.0)),
                            border: Border.all(
                              color: isSelected
                                  ? AppColors.accent
                                  : Colors.white.withValues(alpha: 0.08),
                              width: isSelected ? 1.5 : 1.0,
                            ),
                          ),
                          child: Text(
                            '$mins mins',
                            style: AppTypography.bodySm.copyWith(
                              color: isSelected ? AppColors.accent : AppColors.textPrimary,
                              fontWeight: isSelected ? FontWeight.bold : FontWeight.w600,
                              fontSize: ResponsiveHelper.sp(12.0),
                            ).responsive(context),
                          ),
                        ),
                      ),
                    );
                  });
                }).toList(),
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildCircleButton(
    BuildContext context, {
    required IconData icon,
    required VoidCallback onTap,
  }) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(ResponsiveHelper.w(14.0)),
        child: Container(
          width: ResponsiveHelper.w(38.0),
          height: ResponsiveHelper.w(38.0),
          decoration: BoxDecoration(
            color: const Color(0xFF131313),
            borderRadius: BorderRadius.circular(ResponsiveHelper.w(14.0)),
            border: Border.all(color: Colors.white.withValues(alpha: 0.08)),
          ),
          child: Icon(
            icon,
            color: AppColors.accent,
            size: ResponsiveHelper.w(20.0),
          ),
        ),
      ),
    );
  }
}
