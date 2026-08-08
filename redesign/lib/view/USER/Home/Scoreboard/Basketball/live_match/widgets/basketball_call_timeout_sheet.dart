import 'package:flutter/material.dart';
import 'package:redesign/theme/app_colors.dart';
import 'package:redesign/theme/app_typography.dart';
import 'package:redesign/theme/responsive_helper.dart';
import 'package:redesign/controller/User_Controller/Home_Controller/Scoreboard_Controller/Basketball/basketball_controller.dart';

/// Modal bottom sheet for calling basketball team timeouts matching the design image.
class BasketballCallTimeoutSheet extends StatefulWidget {
  final BasketballController controller;

  const BasketballCallTimeoutSheet({
    super.key,
    required this.controller,
  });

  static void show(BuildContext context, BasketballController controller) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: const Color(0xFF10141E),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(ResponsiveHelper.w(24.0))),
      ),
      builder: (ctx) => BasketballCallTimeoutSheet(controller: controller),
    );
  }

  @override
  State<BasketballCallTimeoutSheet> createState() => _BasketballCallTimeoutSheetState();
}

class _BasketballCallTimeoutSheetState extends State<BasketballCallTimeoutSheet> {
  String _selectedTeam = 'sideA'; // 'sideA' or 'sideB'

  void _onConfirmTimeout() {
    widget.controller.useTimeout(_selectedTeam);
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    ResponsiveHelper.init(context);
    final state = widget.controller.liveState.value;

    final homeName = widget.controller.currentMatch.value?.homeTeam.isNotEmpty == true
        ? widget.controller.currentMatch.value!.homeTeam
        : 'Side A';
    final awayName = widget.controller.currentMatch.value?.awayTeam.isNotEmpty == true
        ? widget.controller.currentMatch.value!.awayTeam
        : 'Side B';

    final timeoutsA = state?.timeoutsRemainingA ?? 2;
    final timeoutsB = state?.timeoutsRemainingB ?? 2;

    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: ResponsiveHelper.w(20.0),
        vertical: ResponsiveHelper.h(12.0),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Top Drag Handle Pill
          Center(
            child: Container(
              width: ResponsiveHelper.w(44.0),
              height: ResponsiveHelper.h(4.5),
              margin: EdgeInsets.only(bottom: ResponsiveHelper.h(12.0)),
              decoration: BoxDecoration(
                color: Colors.white.withValues(alpha: 0.3),
                borderRadius: BorderRadius.circular(ResponsiveHelper.w(10.0)),
              ),
            ),
          ),

          // Header Row: Title + Close Button
          Row(
            children: [
              const Spacer(),
              Text(
                'Call Timeout',
                style: AppTypography.headlineSm.copyWith(
                  color: AppColors.textPrimary,
                  fontSize: ResponsiveHelper.sp(20.0),
                  fontWeight: FontWeight.w900,
                ).responsive(context),
              ),
              const Spacer(),
              IconButton(
                style: IconButton.styleFrom(
                  backgroundColor: Colors.white.withValues(alpha: 0.1),
                  shape: const CircleBorder(),
                ),
                icon: const Icon(Icons.close, color: AppColors.textPrimary, size: 20),
                onPressed: () => Navigator.pop(context),
              ),
            ],
          ),
          SizedBox(height: ResponsiveHelper.h(20.0)),

          // ─── TOP CIRCULAR TIMER GRAPHIC (60 SECONDS) ───
          Center(
            child: SizedBox(
              width: ResponsiveHelper.w(140.0),
              height: ResponsiveHelper.w(140.0),
              child: Stack(
                alignment: Alignment.center,
                children: [
                  // Circular Progress Indicator Ring
                  SizedBox(
                    width: ResponsiveHelper.w(135.0),
                    height: ResponsiveHelper.w(135.0),
                    child: CircularProgressIndicator(
                      value: 0.75, // Visual 60s arc ring matching design image
                      strokeWidth: 5.5,
                      backgroundColor: Colors.white.withValues(alpha: 0.08),
                      color: AppColors.accent,
                    ),
                  ),
                  // Center Text: 60 SECONDS
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        '60',
                        style: AppTypography.displayLg.copyWith(
                          color: AppColors.textPrimary,
                          fontSize: ResponsiveHelper.sp(44.0),
                          fontWeight: FontWeight.w900,
                          height: 1.0,
                        ).responsive(context),
                      ),
                      SizedBox(height: ResponsiveHelper.h(2.0)),
                      Text(
                        'SECONDS',
                        style: AppTypography.labelCaps.copyWith(
                          color: AppColors.mutedText,
                          fontSize: ResponsiveHelper.sp(10.0),
                          fontWeight: FontWeight.w800,
                          letterSpacing: 1.0,
                        ).responsive(context),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
          SizedBox(height: ResponsiveHelper.h(24.0)),

          // ─── TIMEOUT SELECTION LIST ───
          Text(
            'Select Timeout',
            style: AppTypography.labelCaps.copyWith(
              color: AppColors.mutedText,
              fontSize: ResponsiveHelper.sp(12.0),
              fontWeight: FontWeight.bold,
            ).responsive(context),
          ),
          SizedBox(height: ResponsiveHelper.h(10.0)),

          // Side A Timeout Card
          _buildTimeoutTeamTile(
            context,
            teamName: '$homeName Timeout',
            remaining: timeoutsA,
            side: 'sideA',
            accentColor: AppColors.accent,
            isSelected: _selectedTeam == 'sideA',
            onTap: () => setState(() => _selectedTeam = 'sideA'),
          ),
          SizedBox(height: ResponsiveHelper.h(10.0)),

          // Side B Timeout Card
          _buildTimeoutTeamTile(
            context,
            teamName: '$awayName Timeout',
            remaining: timeoutsB,
            side: 'sideB',
            accentColor: const Color(0xFF4D96FF),
            isSelected: _selectedTeam == 'sideB',
            onTap: () => setState(() => _selectedTeam = 'sideB'),
          ),
          SizedBox(height: ResponsiveHelper.h(20.0)),

          // ─── TIMEOUT RULES INFO CARD ───
          Container(
            padding: EdgeInsets.all(ResponsiveHelper.w(14.0)),
            decoration: BoxDecoration(
              color: const Color(0xFF141822),
              borderRadius: BorderRadius.circular(ResponsiveHelper.w(16.0)),
              border: Border.all(color: Colors.white.withValues(alpha: 0.08)),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Icon(
                      Icons.timer_outlined,
                      color: AppColors.accent,
                      size: ResponsiveHelper.w(20.0),
                    ),
                    SizedBox(width: ResponsiveHelper.w(8.0)),
                    Text(
                      'Timeout Rules',
                      style: AppTypography.headlineSm.copyWith(
                        color: AppColors.textPrimary,
                        fontSize: ResponsiveHelper.sp(14.0),
                        fontWeight: FontWeight.bold,
                      ).responsive(context),
                    ),
                  ],
                ),
                SizedBox(height: ResponsiveHelper.h(8.0)),
                _buildRuleBullet(context, 'Each team gets 2 timeouts per half'),
                _buildRuleBullet(context, 'Timeout duration is 60 seconds'),
                _buildRuleBullet(context, 'Unused timeouts do not carry over'),
              ],
            ),
          ),
          SizedBox(height: ResponsiveHelper.h(24.0)),

          // ─── CONFIRM TIMEOUT BUTTON ───
          SizedBox(
            width: double.infinity,
            height: ResponsiveHelper.h(50.0),
            child: ElevatedButton.icon(
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.accent,
                foregroundColor: Colors.black,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(ResponsiveHelper.w(14.0)),
                ),
                elevation: 0,
              ),
              onPressed: _onConfirmTimeout,
              icon: const Icon(Icons.sports_rounded, color: Colors.black, size: 20),
              label: Text(
                'CONFIRM TIMEOUT',
                style: AppTypography.headlineSm.copyWith(
                  color: Colors.black,
                  fontSize: ResponsiveHelper.sp(15.0),
                  fontWeight: FontWeight.w900,
                  letterSpacing: 0.8,
                ).responsive(context),
              ),
            ),
          ),
          SizedBox(height: ResponsiveHelper.h(16.0)),
        ],
      ),
    );
  }

  Widget _buildTimeoutTeamTile(
    BuildContext context, {
    required String teamName,
    required int remaining,
    required String side,
    required Color accentColor,
    required bool isSelected,
    required VoidCallback onTap,
  }) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(ResponsiveHelper.w(16.0)),
        child: Container(
          padding: EdgeInsets.symmetric(
            horizontal: ResponsiveHelper.w(14.0),
            vertical: ResponsiveHelper.h(14.0),
          ),
          decoration: BoxDecoration(
            color: const Color(0xFF141822),
            borderRadius: BorderRadius.circular(ResponsiveHelper.w(16.0)),
            border: Border.all(
              color: isSelected ? accentColor : Colors.white.withValues(alpha: 0.08),
              width: isSelected ? 1.5 : 1.0,
            ),
          ),
          child: Row(
            children: [
              Container(
                width: ResponsiveHelper.w(40.0),
                height: ResponsiveHelper.w(40.0),
                decoration: BoxDecoration(
                  color: accentColor.withValues(alpha: 0.15),
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  Icons.people_rounded,
                  color: accentColor,
                  size: ResponsiveHelper.w(22.0),
                ),
              ),
              SizedBox(width: ResponsiveHelper.w(14.0)),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      teamName,
                      style: AppTypography.headlineSm.copyWith(
                        color: isSelected ? accentColor : AppColors.textPrimary,
                        fontSize: ResponsiveHelper.sp(14.5),
                        fontWeight: FontWeight.bold,
                      ).responsive(context),
                    ),
                    SizedBox(height: ResponsiveHelper.h(2.0)),
                    Text(
                      'Remaining: $remaining / 2',
                      style: AppTypography.bodySm.copyWith(
                        color: AppColors.mutedText,
                        fontSize: ResponsiveHelper.sp(12.0),
                      ).responsive(context),
                    ),
                  ],
                ),
              ),
              Icon(
                isSelected ? Icons.check_circle_rounded : Icons.radio_button_unchecked_rounded,
                color: isSelected ? accentColor : AppColors.mutedText.withValues(alpha: 0.3),
                size: ResponsiveHelper.w(22.0),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildRuleBullet(BuildContext context, String text) {
    return Padding(
      padding: EdgeInsets.only(bottom: ResponsiveHelper.h(4.0)),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('• ', style: TextStyle(color: AppColors.mutedText, fontSize: ResponsiveHelper.sp(13.0))),
          Expanded(
            child: Text(
              text,
              style: AppTypography.bodySm.copyWith(
                color: AppColors.mutedText,
                fontSize: ResponsiveHelper.sp(12.0),
              ).responsive(context),
            ),
          ),
        ],
      ),
    );
  }
}
