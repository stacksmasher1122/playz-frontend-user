import 'dart:async';
import 'package:flutter/material.dart';
import 'package:redesign/theme/app_colors.dart';
import 'package:redesign/theme/app_typography.dart';
import 'package:redesign/theme/responsive_helper.dart';
import 'package:redesign/controller/User_Controller/Home_Controller/Scoreboard_Controller/Basketball/basketball_controller.dart';

/// High-fidelity modal bottom sheet displayed when a Basketball quarter or halftime period ends.
class BasketballQuarterEndedSheet extends StatefulWidget {
  final BasketballController controller;
  final int endedQuarter;
  final bool isOvertime;
  final VoidCallback onStartNextQuarter;

  const BasketballQuarterEndedSheet({
    super.key,
    required this.controller,
    required this.endedQuarter,
    this.isOvertime = false,
    required this.onStartNextQuarter,
  });

  static void show(
    BuildContext context, {
    required BasketballController controller,
    required int endedQuarter,
    bool isOvertime = false,
    required VoidCallback onStartNextQuarter,
  }) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      isDismissible: false,
      backgroundColor: const Color(0xFF10141E),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(ResponsiveHelper.w(24.0))),
      ),
      builder: (ctx) => BasketballQuarterEndedSheet(
        controller: controller,
        endedQuarter: endedQuarter,
        isOvertime: isOvertime,
        onStartNextQuarter: onStartNextQuarter,
      ),
    );
  }

  @override
  State<BasketballQuarterEndedSheet> createState() => _BasketballQuarterEndedSheetState();
}

class _BasketballQuarterEndedSheetState extends State<BasketballQuarterEndedSheet> {
  static const int _totalDuration = 60;
  int _secondsLeft = _totalDuration;
  Timer? _countdownTimer;

  @override
  void initState() {
    super.initState();
    _countdownTimer = Timer.periodic(const Duration(seconds: 1), (t) {
      if (_secondsLeft > 1) {
        if (mounted) {
          setState(() => _secondsLeft--);
        }
      } else {
        t.cancel();
        if (mounted && Navigator.canPop(context)) {
          Navigator.pop(context);
          widget.onStartNextQuarter();
        }
      }
    });
  }

  @override
  void dispose() {
    _countdownTimer?.cancel();
    super.dispose();
  }

  String _formatScore(int score) => score.toString().padLeft(2, '0');

  String _getQuarterTitle() {
    if (widget.isOvertime) {
      return 'Overtime Period (OT${widget.endedQuarter - 4}) Completed';
    }
    if (widget.endedQuarter == 2) {
      return 'Half-Time Break (Q2 Ended)';
    }
    return 'Quarter ${widget.endedQuarter} Completed';
  }

  String _getNextQuarterButtonLabel() {
    if (widget.isOvertime) {
      return 'START NEXT OVERTIME';
    }
    if (widget.endedQuarter == 2) {
      return 'START 3RD QUARTER (2ND HALF)';
    }
    final nextQ = widget.endedQuarter + 1;
    return 'START QUARTER $nextQ NOW';
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

    final scoreA = state?.sideAScore ?? 0;
    final scoreB = state?.sideBScore ?? 0;
    final foulsA = state?.teamFoulsA ?? 0;
    final foulsB = state?.teamFoulsB ?? 0;
    final timeoutsA = state?.timeoutsRemainingA ?? 2;
    final timeoutsB = state?.timeoutsRemainingB ?? 2;

    final isHalfTime = widget.endedQuarter == 2;
    final progressVal = _secondsLeft / _totalDuration;

    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: ResponsiveHelper.w(20.0),
        vertical: ResponsiveHelper.h(14.0),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          // Top Drag Handle Pill
          Center(
            child: Container(
              width: ResponsiveHelper.w(44.0),
              height: ResponsiveHelper.h(4.5),
              margin: EdgeInsets.only(bottom: ResponsiveHelper.h(14.0)),
              decoration: BoxDecoration(
                color: Colors.white.withValues(alpha: 0.3),
                borderRadius: BorderRadius.circular(ResponsiveHelper.w(10.0)),
              ),
            ),
          ),

          // Basketball Icon Badge Header
          Container(
            width: ResponsiveHelper.w(56.0),
            height: ResponsiveHelper.w(56.0),
            decoration: BoxDecoration(
              color: AppColors.accent.withValues(alpha: 0.15),
              shape: BoxShape.circle,
              border: Border.all(color: AppColors.accent, width: 1.5),
              boxShadow: [
                BoxShadow(
                  color: AppColors.accent.withValues(alpha: 0.25),
                  blurRadius: 16.0,
                  spreadRadius: 2.0,
                ),
              ],
            ),
            child: Icon(
              Icons.sports_basketball_rounded,
              color: AppColors.accent,
              size: ResponsiveHelper.w(30.0),
            ),
          ),
          SizedBox(height: ResponsiveHelper.h(12.0)),

          // Title & Period Chip
          Text(
            _getQuarterTitle(),
            style: AppTypography.headlineSm.copyWith(
              color: AppColors.textPrimary,
              fontSize: ResponsiveHelper.sp(19.0),
              fontWeight: FontWeight.w900,
            ).responsive(context),
            textAlign: TextAlign.center,
          ),
          SizedBox(height: ResponsiveHelper.h(16.0)),

          // ─── MAIN SCORE DISPLAY CARD ───
          Container(
            padding: EdgeInsets.symmetric(
              horizontal: ResponsiveHelper.w(20.0),
              vertical: ResponsiveHelper.h(16.0),
            ),
            decoration: BoxDecoration(
              color: const Color(0xFF141822),
              borderRadius: BorderRadius.circular(ResponsiveHelper.w(20.0)),
              border: Border.all(color: Colors.white.withValues(alpha: 0.08)),
            ),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    // Team A Score Column
                    Column(
                      children: [
                        Text(
                          homeName.toUpperCase(),
                          style: AppTypography.labelCaps.copyWith(
                            color: AppColors.accent,
                            fontSize: ResponsiveHelper.sp(12.0),
                            fontWeight: FontWeight.bold,
                          ).responsive(context),
                        ),
                        SizedBox(height: ResponsiveHelper.h(4.0)),
                        Text(
                          _formatScore(scoreA),
                          style: AppTypography.displayScoreSora.copyWith(
                            color: AppColors.textPrimary,
                            fontSize: ResponsiveHelper.sp(38.0),
                            fontWeight: FontWeight.w900,
                          ).responsive(context),
                        ),
                      ],
                    ),

                    // VS Circle Badge
                    Container(
                      padding: EdgeInsets.all(ResponsiveHelper.w(8.0)),
                      decoration: BoxDecoration(
                        color: Colors.white.withValues(alpha: 0.05),
                        shape: BoxShape.circle,
                      ),
                      child: Text(
                        'VS',
                        style: AppTypography.labelCaps.copyWith(
                          color: AppColors.mutedText,
                          fontSize: ResponsiveHelper.sp(12.0),
                          fontWeight: FontWeight.w900,
                        ).responsive(context),
                      ),
                    ),

                    // Team B Score Column
                    Column(
                      children: [
                        Text(
                          awayName.toUpperCase(),
                          style: AppTypography.labelCaps.copyWith(
                            color: const Color(0xFF4D96FF),
                            fontSize: ResponsiveHelper.sp(12.0),
                            fontWeight: FontWeight.bold,
                          ).responsive(context),
                        ),
                        SizedBox(height: ResponsiveHelper.h(4.0)),
                        Text(
                          _formatScore(scoreB),
                          style: AppTypography.displayScoreSora.copyWith(
                            color: AppColors.textPrimary,
                            fontSize: ResponsiveHelper.sp(38.0),
                            fontWeight: FontWeight.w900,
                          ).responsive(context),
                        ),
                      ],
                    ),
                  ],
                ),

                SizedBox(height: ResponsiveHelper.h(14.0)),
                const Divider(color: Colors.white10, height: 1.0),
                SizedBox(height: ResponsiveHelper.h(12.0)),

                // Team Fouls & Timeouts Live Breakdown
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    _buildStatPill(
                      context,
                      label: 'Fouls: $foulsA | $foulsB',
                      icon: Icons.sports_rounded,
                      color: AppColors.mutedText,
                    ),
                    _buildStatPill(
                      context,
                      label: 'Timeouts: $timeoutsA | $timeoutsB',
                      icon: Icons.timer_outlined,
                      color: AppColors.mutedText,
                    ),
                  ],
                ),

                if (isHalfTime) ...[
                  SizedBox(height: ResponsiveHelper.h(12.0)),
                  Container(
                    width: double.infinity,
                    padding: EdgeInsets.all(ResponsiveHelper.w(10.0)),
                    decoration: BoxDecoration(
                      color: const Color(0xFF181E2B),
                      borderRadius: BorderRadius.circular(ResponsiveHelper.w(12.0)),
                      border: Border.all(color: AppColors.accent.withValues(alpha: 0.3)),
                    ),
                    child: Row(
                      children: [
                        const Icon(Icons.bolt_rounded, color: AppColors.accent, size: 18),
                        SizedBox(width: ResponsiveHelper.w(8.0)),
                        Expanded(
                          child: Text(
                            'Half-Time Reset: Team fouls cleared & timeouts restored to 3 per team!',
                            style: AppTypography.bodySm.copyWith(
                              color: AppColors.textPrimary,
                              fontSize: ResponsiveHelper.sp(11.5),
                              fontWeight: FontWeight.w600,
                            ).responsive(context),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ],
            ),
          ),
          SizedBox(height: ResponsiveHelper.h(16.0)),

          // ─── AUTO-PROCEEDING TIMER BANNER WITH PROGRESS BAR ───
          Container(
            padding: EdgeInsets.all(ResponsiveHelper.w(12.0)),
            decoration: BoxDecoration(
              color: const Color(0xFF181E2B),
              borderRadius: BorderRadius.circular(ResponsiveHelper.w(14.0)),
              border: Border.all(color: Colors.white.withValues(alpha: 0.06)),
            ),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.timer_outlined,
                      color: AppColors.accent,
                      size: ResponsiveHelper.w(16.0),
                    ),
                    SizedBox(width: ResponsiveHelper.w(6.0)),
                    Text(
                      'Auto-proceeding in 00:${_secondsLeft.toString().padLeft(2, '0')}',
                      style: AppTypography.bodySm.copyWith(
                        color: AppColors.textPrimary,
                        fontSize: ResponsiveHelper.sp(12.5),
                        fontWeight: FontWeight.w700,
                      ).responsive(context),
                    ),
                  ],
                ),
                SizedBox(height: ResponsiveHelper.h(8.0)),
                ClipRRect(
                  borderRadius: BorderRadius.circular(ResponsiveHelper.w(4.0)),
                  child: LinearProgressIndicator(
                    value: progressVal,
                    minHeight: 4.0,
                    backgroundColor: Colors.white.withValues(alpha: 0.1),
                    color: AppColors.accent,
                  ),
                ),
              ],
            ),
          ),
          SizedBox(height: ResponsiveHelper.h(20.0)),

          // ─── ACTION BUTTONS ROW (UNDO | START NEXT QUARTER) ───
          Row(
            children: [
              if (widget.controller.engine.canUndo) ...[
                Expanded(
                  flex: 2,
                  child: SizedBox(
                    height: ResponsiveHelper.h(50.0),
                    child: OutlinedButton.icon(
                      style: OutlinedButton.styleFrom(
                        foregroundColor: AppColors.error,
                        side: BorderSide(color: AppColors.error.withValues(alpha: 0.5)),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(ResponsiveHelper.w(14.0)),
                        ),
                      ),
                      onPressed: () {
                        _countdownTimer?.cancel();
                        Navigator.pop(context);
                        widget.controller.undoLastAction();
                      },
                      icon: const Icon(Icons.undo_rounded, size: 18),
                      label: Text(
                        'UNDO',
                        style: AppTypography.labelCaps.copyWith(
                          color: AppColors.error,
                          fontSize: ResponsiveHelper.sp(11.5),
                          fontWeight: FontWeight.w900,
                        ).responsive(context),
                      ),
                    ),
                  ),
                ),
                SizedBox(width: ResponsiveHelper.w(10.0)),
              ],
              Expanded(
                flex: 3,
                child: SizedBox(
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
                    onPressed: () {
                      _countdownTimer?.cancel();
                      Navigator.pop(context);
                      widget.onStartNextQuarter();
                    },
                    icon: const Icon(Icons.arrow_forward_rounded, color: Colors.black, size: 20),
                    label: FittedBox(
                      fit: BoxFit.scaleDown,
                      child: Text(
                        _getNextQuarterButtonLabel(),
                        style: AppTypography.headlineSm.copyWith(
                          color: Colors.black,
                          fontSize: ResponsiveHelper.sp(13.5),
                          fontWeight: FontWeight.w900,
                          letterSpacing: 0.5,
                        ).responsive(context),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: ResponsiveHelper.h(14.0)),
        ],
      ),
    );
  }

  Widget _buildStatPill(
    BuildContext context, {
    required String label,
    required IconData icon,
    required Color color,
  }) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, color: color, size: ResponsiveHelper.w(14.0)),
        SizedBox(width: ResponsiveHelper.w(6.0)),
        Text(
          label,
          style: AppTypography.bodySm.copyWith(
            color: AppColors.textSecondary,
            fontSize: ResponsiveHelper.sp(11.5),
            fontWeight: FontWeight.w600,
          ).responsive(context),
        ),
      ],
    );
  }
}
