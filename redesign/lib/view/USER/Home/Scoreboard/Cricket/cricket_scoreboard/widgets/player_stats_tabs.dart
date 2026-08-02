import 'package:flutter/material.dart';
import 'package:redesign/model/User_Models/Home_Models/Scoreboard_Model/cricket_state_models.dart';
import 'package:redesign/theme/app_colors.dart';
import 'package:redesign/theme/responsive_helper.dart';

class PlayerStatsTabs extends StatefulWidget {
  final Player? striker;
  final Player? nonStriker;
  final Player? currentBowler;
  final Player? previousBowler;
  final List<BallEvent> currentOverBalls;
  final double currentRunRate;
  final int partnershipRuns;
  final int partnershipBalls;
  final List<BallEvent> ballHistory;

  const PlayerStatsTabs({
    super.key,
    required this.striker,
    required this.nonStriker,
    required this.currentBowler,
    this.previousBowler,
    required this.currentOverBalls,
    required this.currentRunRate,
    required this.partnershipRuns,
    required this.partnershipBalls,
    required this.ballHistory,
  });

  @override
  State<PlayerStatsTabs> createState() => _PlayerStatsTabsState();
}

class _PlayerStatsTabsState extends State<PlayerStatsTabs> {
  int statsTabIndex = 0;

  String _truncate(String name) {
    if (name.length <= 8) return name;
    return '${name.substring(0, 8)}…';
  }

  @override
  Widget build(BuildContext context) {
    ResponsiveHelper.init(context);
    return Container(
      margin: EdgeInsets.symmetric(horizontal: ResponsiveHelper.w(16)),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(ResponsiveHelper.w(18)),
      ),
      child: Column(
        children: [
          Row(
            children: [
              _statsTab('Batting', 0),
              _statsTab('Bowling', 1),
            ],
          ),
          if (statsTabIndex == 0) _buildBattingStats(),
          if (statsTabIndex == 1) _buildBowlingStats(),
        ],
      ),
    );
  }

  Widget _statsTab(String title, int index) {
    final selected = statsTabIndex == index;
    return Expanded(
      child: GestureDetector(
        onTap: () => setState(() => statsTabIndex = index),
        child: Container(
          padding: EdgeInsets.symmetric(vertical: ResponsiveHelper.h(12)),
          decoration: BoxDecoration(
            color: selected ? AppColors.textPrimary.withValues(alpha: 0.1) : Colors.transparent,
            borderRadius: BorderRadius.vertical(
              top: Radius.circular(ResponsiveHelper.w(18)),
            ),
          ),
          alignment: Alignment.center,
          child: Text(
            title,
            style: TextStyle(
              color: selected ? AppColors.textPrimary : AppColors.muted,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildBattingStats() {
    return Padding(
      padding: EdgeInsets.all(ResponsiveHelper.w(16)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Column Headers
          Padding(
            padding: EdgeInsets.symmetric(horizontal: ResponsiveHelper.w(8), vertical: ResponsiveHelper.h(4)),
            child: Row(
              children: [
                SizedBox(width: ResponsiveHelper.w(20)),
                Expanded(
                  child: Text(
                    'Batter',
                    style: TextStyle(
                      color: AppColors.muted,
                      fontSize: ResponsiveHelper.sp(10),
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
                _headerCell('R', 32),
                _headerCell('B', 32),
                _headerCell('4s', 28),
                _headerCell('6s', 28),
                _headerCell('SR', 44),
              ],
            ),
          ),
          SizedBox(height: ResponsiveHelper.h(4)),
          if (widget.striker != null)
            _batterRow(widget.striker!, isStriker: true),
          SizedBox(height: ResponsiveHelper.h(6)),
          if (widget.nonStriker != null)
            _batterRow(widget.nonStriker!, isStriker: false),
          SizedBox(height: ResponsiveHelper.h(12)),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Extras: ${widget.currentOverBalls.where((b) => b.isExtra).fold(0, (sum, b) => sum + b.extraRuns)}',
                style: TextStyle(color: AppColors.muted, fontSize: ResponsiveHelper.sp(12)),
              ),
              Text(
                'Partnership: ${widget.partnershipRuns} (${widget.partnershipBalls})',
                style: TextStyle(color: AppColors.muted, fontSize: ResponsiveHelper.sp(12)),
              ),
              Text(
                'RR: ${widget.currentRunRate.toStringAsFixed(2)}',
                style: TextStyle(
                  color: AppColors.accent,
                  fontSize: ResponsiveHelper.sp(12),
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _headerCell(String label, double width) {
    return SizedBox(
      width: ResponsiveHelper.w(width),
      child: Text(
        label,
        style: TextStyle(
          color: AppColors.muted,
          fontSize: ResponsiveHelper.sp(10),
          fontWeight: FontWeight.w600,
        ),
        textAlign: TextAlign.center,
      ),
    );
  }

  Widget _batterRow(Player p, {required bool isStriker}) {
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: ResponsiveHelper.w(8),
        vertical: ResponsiveHelper.h(10),
      ),
      decoration: BoxDecoration(
        color: isStriker
            ? AppColors.accent.withValues(alpha: 0.1)
            : Colors.transparent,
        borderRadius: BorderRadius.circular(ResponsiveHelper.w(10)),
        border: isStriker
            ? Border.all(color: AppColors.accent.withValues(alpha: 0.3))
            : null,
      ),
      child: Row(
        children: [
          SizedBox(
            width: ResponsiveHelper.w(20),
            child: isStriker
                ? Icon(Icons.star, color: AppColors.accent, size: ResponsiveHelper.sp(14))
                : const SizedBox.shrink(),
          ),
          Expanded(
            child: Text(
              _truncate(p.name),
              style: TextStyle(
                color: AppColors.textPrimary,
                fontWeight: FontWeight.w600,
                fontSize: ResponsiveHelper.sp(13),
              ),
            ),
          ),
          SizedBox(
            width: ResponsiveHelper.w(32),
            child: Text(
              '${p.runs}',
              style: TextStyle(
                color: AppColors.textPrimary,
                fontWeight: FontWeight.w700,
                fontSize: ResponsiveHelper.sp(13),
              ),
              textAlign: TextAlign.center,
            ),
          ),
          SizedBox(
            width: ResponsiveHelper.w(32),
            child: Text(
              '${p.ballsFaced}',
              style: TextStyle(color: AppColors.muted, fontSize: ResponsiveHelper.sp(12)),
              textAlign: TextAlign.center,
            ),
          ),
          SizedBox(
            width: ResponsiveHelper.w(28),
            child: Text(
              '${p.fours}',
              style: TextStyle(color: AppColors.muted, fontSize: ResponsiveHelper.sp(12)),
              textAlign: TextAlign.center,
            ),
          ),
          SizedBox(
            width: ResponsiveHelper.w(28),
            child: Text(
              '${p.sixes}',
              style: TextStyle(color: AppColors.muted, fontSize: ResponsiveHelper.sp(12)),
              textAlign: TextAlign.center,
            ),
          ),
          SizedBox(
            width: ResponsiveHelper.w(44),
            child: Text(
              p.strikeRate.toStringAsFixed(1),
              style: TextStyle(color: AppColors.coinsGold, fontSize: ResponsiveHelper.sp(11), fontWeight: FontWeight.w600),
              textAlign: TextAlign.center,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBowlingStats() {
    return Padding(
      padding: EdgeInsets.all(ResponsiveHelper.w(16)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Column Headers
          Padding(
            padding: EdgeInsets.symmetric(horizontal: ResponsiveHelper.w(8), vertical: ResponsiveHelper.h(4)),
            child: Row(
              children: [
                Expanded(
                  child: Text(
                    'Bowler',
                    style: TextStyle(
                      color: AppColors.muted,
                      fontSize: ResponsiveHelper.sp(10),
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
                _headerCell('O', 32),
                _headerCell('M', 28),
                _headerCell('R', 32),
                _headerCell('W', 28),
                _headerCell('Econ', 44),
              ],
            ),
          ),
          SizedBox(height: ResponsiveHelper.h(4)),
          if (widget.currentBowler != null)
            _bowlerRow(widget.currentBowler!, isCurrent: true),
          if (widget.previousBowler != null) ...[
            SizedBox(height: ResponsiveHelper.h(6)),
            _bowlerRow(widget.previousBowler!, isCurrent: false),
          ],
        ],
      ),
    );
  }

  Widget _bowlerRow(Player p, {bool isCurrent = true}) {
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: ResponsiveHelper.w(8),
        vertical: ResponsiveHelper.h(10),
      ),
      decoration: BoxDecoration(
        color: isCurrent
            ? AppColors.accent.withValues(alpha: 0.1)
            : Colors.transparent,
        borderRadius: BorderRadius.circular(ResponsiveHelper.w(10)),
        border: isCurrent
            ? Border.all(color: AppColors.accent.withValues(alpha: 0.3))
            : null,
      ),
      child: Row(
        children: [
          Expanded(
            child: Text(
              _truncate(p.name),
              style: TextStyle(
                color: isCurrent ? AppColors.textPrimary : AppColors.textSecondary,
                fontWeight: isCurrent ? FontWeight.w600 : FontWeight.normal,
                fontSize: ResponsiveHelper.sp(13),
              ),
            ),
          ),
          SizedBox(
            width: ResponsiveHelper.w(32),
            child: Text(
              p.oversBowledDisplay,
              style: TextStyle(
                color: isCurrent ? AppColors.textPrimary : AppColors.muted,
                fontWeight: isCurrent ? FontWeight.w600 : FontWeight.normal,
                fontSize: ResponsiveHelper.sp(12),
              ),
              textAlign: TextAlign.center,
            ),
          ),
          SizedBox(
            width: ResponsiveHelper.w(28),
            child: Text(
              '${p.maidens}',
              style: TextStyle(color: AppColors.muted, fontSize: ResponsiveHelper.sp(12)),
              textAlign: TextAlign.center,
            ),
          ),
          SizedBox(
            width: ResponsiveHelper.w(32),
            child: Text(
              '${p.runsConceded}',
              style: TextStyle(color: AppColors.muted, fontSize: ResponsiveHelper.sp(12)),
              textAlign: TextAlign.center,
            ),
          ),
          SizedBox(
            width: ResponsiveHelper.w(28),
            child: Text(
              '${p.wicketsTaken}',
              style: TextStyle(
                color: isCurrent ? AppColors.textPrimary : AppColors.muted,
                fontWeight: isCurrent ? FontWeight.w700 : FontWeight.normal,
                fontSize: ResponsiveHelper.sp(12),
              ),
              textAlign: TextAlign.center,
            ),
          ),
          SizedBox(
            width: ResponsiveHelper.w(44),
            child: Text(
              p.economy.toStringAsFixed(1),
              style: TextStyle(
                color: isCurrent ? AppColors.coinsGold : AppColors.muted,
                fontSize: ResponsiveHelper.sp(11),
                fontWeight: FontWeight.w600,
              ),
              textAlign: TextAlign.center,
            ),
          ),
        ],
      ),
    );
  }
}
