import 'package:flutter/material.dart';
import 'package:redesign/model/User_Models/Home_Models/Scoreboard_Model/cricket_state_models.dart';
import 'package:redesign/theme/app_colors.dart';
import 'package:redesign/theme/responsive_helper.dart';

class PlayerStatsTabs extends StatefulWidget {
  final Player? striker;
  final Player? nonStriker;
  final Player? currentBowler;
  final List<BallEvent> currentOverBalls;
  final double currentRunRate;
  final int partnershipRuns;
  final int partnershipBalls;
  final List<BallEvent> ballHistory;

  PlayerStatsTabs({
    super.key,
    required this.striker,
    required this.nonStriker,
    required this.currentBowler,
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
              _statsTab('Comm', 2),
            ],
          ),
          if (statsTabIndex == 0) _buildBattingStats(),
          if (statsTabIndex == 1) _buildBowlingStats(),
          if (statsTabIndex == 2) _buildCommentary(),
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
            color: selected ? Colors.white10 : Colors.transparent,
            borderRadius: BorderRadius.vertical(top: Radius.circular(ResponsiveHelper.w(18))),
          ),
          alignment: Alignment.center,
          child: Text(
            title,
            style: TextStyle(
              color: selected ? Colors.white : AppColors.muted,
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
          Text(
            'BATTERS',
            style: TextStyle(
              color: AppColors.muted,
              fontSize: ResponsiveHelper.sp(11),
              fontWeight: FontWeight.w600,
            ),
          ),
          SizedBox(height: 8),
          if (widget.striker != null) _batterRow(widget.striker!, isStriker: true),
          SizedBox(height: 8),
          if (widget.nonStriker != null) _batterRow(widget.nonStriker!, isStriker: false),
          SizedBox(height: 12),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Extras: ${widget.currentOverBalls.where((b) => b.isExtra).fold(0, (sum, b) => sum + b.extraRuns)}',
                style: TextStyle(color: AppColors.muted, fontSize: 12),
              ),
              Text(
                'Partnership: ${widget.partnershipRuns} (${widget.partnershipBalls})',
                style: TextStyle(color: AppColors.muted, fontSize: 12),
              ),
              Text(
                'Run Rate: ${widget.currentRunRate.toStringAsFixed(2)}',
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

  Widget _batterRow(Player p, {required bool isStriker}) {
    return Container(
      padding: EdgeInsets.all(ResponsiveHelper.w(12)),
      decoration: BoxDecoration(
        color: isStriker ? AppColors.accent.withValues(alpha: 0.1) : Colors.transparent,
        borderRadius: BorderRadius.circular(ResponsiveHelper.w(12)),
        border: isStriker ? Border.all(color: AppColors.accent.withValues(alpha: 0.3)) : null,
      ),
      child: Row(
        children: [
          if (isStriker)
            Icon(Icons.star, color: AppColors.accent, size: 16)
          else
            SizedBox(width: 16),
          SizedBox(width: 8),
          Expanded(
            child: Text(
              p.name,
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          SizedBox(
            width: ResponsiveHelper.w(40),
            child: Text(
              '${p.runs}',
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.w700,
              ),
              textAlign: TextAlign.center,
            ),
          ),
          SizedBox(
            width: ResponsiveHelper.w(40),
            child: Text(
              '${p.ballsFaced}',
              style: TextStyle(color: AppColors.muted),
              textAlign: TextAlign.center,
            ),
          ),
          SizedBox(
            width: ResponsiveHelper.w(32),
            child: Text(
              '${p.fours}',
              style: TextStyle(color: AppColors.muted),
              textAlign: TextAlign.center,
            ),
          ),
          SizedBox(
            width: ResponsiveHelper.w(32),
            child: Text(
              '${p.sixes}',
              style: TextStyle(color: AppColors.muted),
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
          Text(
            'BOWLERS',
            style: TextStyle(
              color: AppColors.muted,
              fontSize: ResponsiveHelper.sp(11),
              fontWeight: FontWeight.w600,
            ),
          ),
          SizedBox(height: 8),
          if (widget.currentBowler != null)
            _bowlerRow(widget.currentBowler!, isCurrent: true),
        ],
      ),
    );
  }

  Widget _bowlerRow(Player p, {required bool isCurrent}) {
    return Container(
      padding: EdgeInsets.all(ResponsiveHelper.w(12)),
      decoration: BoxDecoration(
        color: isCurrent ? AppColors.accent.withValues(alpha: 0.1) : Colors.transparent,
        borderRadius: BorderRadius.circular(ResponsiveHelper.w(12)),
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Text(
                      p.name,
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    if (isCurrent)
                      Container(
                        margin: EdgeInsets.only(left: 8),
                        padding: EdgeInsets.symmetric(
                          horizontal: 6,
                          vertical: 2,
                        ),
                        decoration: BoxDecoration(
                          color: AppColors.accent,
                          borderRadius: BorderRadius.circular(ResponsiveHelper.w(4)),
                        ),
                        child: Text(
                          'CURRENT',
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: ResponsiveHelper.sp(9),
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ),
                  ],
                ),
                SizedBox(height: 4),
                Text(
                  '${p.oversBowledDisplay} ov  ·  ${p.maidens} M  ·  ${p.runsConceded} R  ·  ${p.wicketsTaken} W',
                  style: TextStyle(color: AppColors.muted, fontSize: 12),
                ),
              ],
            ),
          ),
          Text(
            'Econ: ',
            style: TextStyle(color: Colors.white70, fontSize: 12),
          ),
          Text(
            p.economy.toStringAsFixed(1),
            style: TextStyle(color: Colors.amber, fontWeight: FontWeight.w600),
          ),
        ],
      ),
    );
  }

  Widget _buildCommentary() {
    final reversedHistory = widget.ballHistory.reversed.toList();
    if (reversedHistory.isEmpty) {
      return Padding(
        padding: EdgeInsets.all(ResponsiveHelper.w(24)),
        child: Center(
          child: Text(
            'Waiting for first ball...',
            style: TextStyle(color: AppColors.muted),
          ),
        ),
      );
    }
    return ListView.builder(
      shrinkWrap: true,
      physics: NeverScrollableScrollPhysics(),
      itemCount: reversedHistory.length,
      itemBuilder: (ctx, i) {
        final ball = reversedHistory[i];
        return Container(
          padding: EdgeInsets.all(ResponsiveHelper.w(12)),
          margin: EdgeInsets.symmetric(horizontal: ResponsiveHelper.w(16), vertical: ResponsiveHelper.h(4)),
          decoration: BoxDecoration(
            color: AppColors.surface,
            borderRadius: BorderRadius.circular(ResponsiveHelper.w(12)),
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: ResponsiveHelper.w(40),
                height: ResponsiveHelper.h(40),
                decoration: BoxDecoration(
                  color: ball.displayColor.withValues(alpha: 0.1),
                  shape: BoxShape.circle,
                ),
                alignment: Alignment.center,
                child: Text(
                  ball.displayText,
                  style: TextStyle(
                    color: ball.displayColor,
                    fontWeight: FontWeight.bold,
                    fontSize: ResponsiveHelper.sp(12),
                  ),
                ),
              ),
              SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Ov ${ball.overNumber}.${ball.ballNumber}',
                      style: TextStyle(color: AppColors.muted, fontSize: 11),
                    ),
                    SizedBox(height: 2),
                    Text(
                      ball.commentary,
                      style: TextStyle(
                        color: Colors.white70,
                        fontSize: ResponsiveHelper.sp(13),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
