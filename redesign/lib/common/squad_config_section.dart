import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:redesign/theme/app_colors.dart';
import 'package:redesign/theme/app_typography.dart';
import 'package:redesign/theme/responsive_helper.dart';

/// A reusable squad configuration section widget containing:
/// 1. Squad Limit Stepper Card
/// 2. Substitute Players Toggle Card
/// 3. Reserves / Max Substitutes Stepper Card (conditionally visible)
class SquadConfigSection extends StatelessWidget {
  final RxInt squadLimit;
  final VoidCallback onSquadLimitDecrement;
  final VoidCallback onSquadLimitIncrement;
  final RxBool subsEnabled;
  final ValueChanged<bool> onSubsToggle;
  final RxInt maxSubstitutes;
  final VoidCallback onMaxSubsDecrement;
  final VoidCallback onMaxSubsIncrement;

  const SquadConfigSection({
    super.key,
    required this.squadLimit,
    required this.onSquadLimitDecrement,
    required this.onSquadLimitIncrement,
    required this.subsEnabled,
    required this.onSubsToggle,
    required this.maxSubstitutes,
    required this.onMaxSubsDecrement,
    required this.onMaxSubsIncrement,
  });

  @override
  Widget build(BuildContext context) {
    ResponsiveHelper.init(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // 1. Squad Limit Card
        _buildStepperCard(
          context,
          title: 'SQUAD LIMIT',
          mainText: 'Players per\nTeam',
          valueStream: squadLimit,
          onDecrement: onSquadLimitDecrement,
          onIncrement: onSquadLimitIncrement,
        ),
        SizedBox(height: ResponsiveHelper.h(16.0)),

        // 2. Substitute Players Switch Card
        _buildSwitchCard(
          context,
          title: 'Substitute Players',
          subtitle: 'Enable mid-match\nrotations',
          icon: Icons.swap_horiz_rounded,
          valueStream: subsEnabled,
          onChanged: onSubsToggle,
        ),
        SizedBox(height: ResponsiveHelper.h(16.0)),

        // 3. Reserves / Max Substitutes Card (Visible only when subsEnabled is true)
        Obx(
          () => subsEnabled.value
              ? Column(
                  children: [
                    _buildStepperCard(
                      context,
                      title: 'RESERVES',
                      titleColor: AppColors.accent,
                      mainText: 'Max\nSubstitutes',
                      valueStream: maxSubstitutes,
                      onDecrement: onMaxSubsDecrement,
                      onIncrement: onMaxSubsIncrement,
                    ),
                    SizedBox(height: ResponsiveHelper.h(16.0)),
                  ],
                )
              : const SizedBox.shrink(),
        ),
      ],
    );
  }

  Widget _buildStepperCard(
    BuildContext context, {
    required String title,
    Color? titleColor,
    required String mainText,
    required RxInt valueStream,
    required VoidCallback onDecrement,
    required VoidCallback onIncrement,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.cardSurface,
        borderRadius: BorderRadius.circular(ResponsiveHelper.w(20.0)),
        border: Border.all(color: Colors.white.withValues(alpha: 0.05)),
      ),
      padding: EdgeInsets.symmetric(
        horizontal: ResponsiveHelper.w(20.0),
        vertical: ResponsiveHelper.h(18.0),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // Left Column
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  title,
                  style: AppTypography.labelCaps.copyWith(
                    color: titleColor ?? AppColors.mutedText,
                    fontSize: ResponsiveHelper.sp(11.0),
                    fontWeight: FontWeight.w800,
                    letterSpacing: 1.2,
                  ).responsive(context),
                ),
                SizedBox(height: ResponsiveHelper.h(6.0)),
                Text(
                  mainText,
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
                color: const Color(0xFF131313),
                iconColor: AppColors.accent.withValues(alpha: 0.7),
                onTap: onDecrement,
              ),
              SizedBox(width: ResponsiveHelper.w(16.0)),
              Obx(
                () => SizedBox(
                  width: ResponsiveHelper.w(36.0),
                  child: Text(
                    '${valueStream.value}',
                    textAlign: TextAlign.center,
                    style: AppTypography.displayScoreSora.copyWith(
                      color: AppColors.accent,
                      fontSize: ResponsiveHelper.sp(28.0),
                      fontWeight: FontWeight.bold,
                    ).responsive(context),
                  ),
                ),
              ),
              SizedBox(width: ResponsiveHelper.w(16.0)),
              _buildCircleButton(
                context,
                icon: Icons.add,
                color: AppColors.accent,
                iconColor: AppColors.background,
                onTap: onIncrement,
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildSwitchCard(
    BuildContext context, {
    required String title,
    required String subtitle,
    required IconData icon,
    required RxBool valueStream,
    required ValueChanged<bool> onChanged,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.cardSurface,
        borderRadius: BorderRadius.circular(ResponsiveHelper.w(20.0)),
        border: Border.all(color: Colors.white.withValues(alpha: 0.05)),
      ),
      padding: EdgeInsets.symmetric(
        horizontal: ResponsiveHelper.w(20.0),
        vertical: ResponsiveHelper.h(18.0),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // Left Icon + Column
          Expanded(
            child: Row(
              children: [
                Container(
                  padding: EdgeInsets.all(ResponsiveHelper.w(10.0)),
                  decoration: BoxDecoration(
                    color: AppColors.accent.withValues(alpha: 0.15),
                    borderRadius: BorderRadius.circular(ResponsiveHelper.w(12.0)),
                  ),
                  child: Icon(
                    icon,
                    color: AppColors.accent,
                    size: ResponsiveHelper.w(22.0),
                  ),
                ),
                SizedBox(width: ResponsiveHelper.w(14.0)),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        title,
                        style: AppTypography.headlineSm.copyWith(
                          color: AppColors.textPrimary,
                          fontSize: ResponsiveHelper.sp(15.0),
                          fontWeight: FontWeight.bold,
                        ).responsive(context),
                      ),
                      SizedBox(height: ResponsiveHelper.h(4.0)),
                      Text(
                        subtitle,
                        style: AppTypography.bodySm.copyWith(
                          color: AppColors.mutedText,
                          fontSize: ResponsiveHelper.sp(12.0),
                          height: 1.2,
                        ).responsive(context),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),

          // Switch
          Obx(
            () => Switch(
              value: valueStream.value,
              onChanged: onChanged,
              activeThumbColor: AppColors.background,
              activeTrackColor: AppColors.accent,
              inactiveThumbColor: AppColors.mutedText,
              inactiveTrackColor: const Color(0xFF131313),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCircleButton(
    BuildContext context, {
    required IconData icon,
    required Color color,
    required Color iconColor,
    required VoidCallback onTap,
  }) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        customBorder: const CircleBorder(),
        child: Ink(
          width: ResponsiveHelper.w(36.0),
          height: ResponsiveHelper.w(36.0),
          decoration: BoxDecoration(
            color: color,
            shape: BoxShape.circle,
          ),
          child: Icon(
            icon,
            color: iconColor,
            size: ResponsiveHelper.w(20.0),
          ),
        ),
      ),
    );
  }
}
