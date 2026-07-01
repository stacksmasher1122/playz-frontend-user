import 'package:flutter/material.dart';
import 'package:redesign/model/User_Models/Home_Models/Scoreboard_Model/cricket_state_models.dart';
import 'package:redesign/theme/app_colors.dart';

class PlayerStatsTabs extends StatefulWidget {
  final Player? striker;
  final Player? nonStriker;
  final Player? currentBowler;
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
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(18),
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
          padding: const EdgeInsets.symmetric(vertical: 12),
          decoration: BoxDecoration(
            color: selected ? Colors.white10 : Colors.transparent,
            borderRadius: const BorderRadius.vertical(top: Radius.circular(18)),
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
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'BATTERS',
            style: TextStyle(
              color: AppColors.muted,
              fontSize: 11,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 8),
          if (widget.striker != null) _batterRow(widget.striker!, isStriker: true),
          const SizedBox(height: 8),
          if (widget.nonStriker != null) _batterRow(widget.nonStriker!, isStriker: false),
          const SizedBox(height: 12),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Extras: ${widget.currentOverBalls.where((b) => b.isExtra).fold(0, (sum, b) => sum + b.extraRuns)}',
                style: const TextStyle(color: AppColors.muted, fontSize: 12),
              ),
              Text(
                'Partnership: ${widget.partnershipRuns} (${widget.partnershipBalls})',
                style: const TextStyle(color: AppColors.muted, fontSize: 12),
              ),
              Text(
                'Run Rate: ${widget.currentRunRate.toStringAsFixed(2)}',
                style: const TextStyle(
                  color: AppColors.accent,
                  fontSize: 12,
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
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: isStriker ? AppColors.accent.withValues(alpha: 0.1) : Colors.transparent,
        borderRadius: BorderRadius.circular(12),
        border: isStriker ? Border.all(color: AppColors.accent.withValues(alpha: 0.3)) : null,
      ),
      child: Row(
        children: [
          if (isStriker)
            const Icon(Icons.star, color: AppColors.accent, size: 16)
          else
            const SizedBox(width: 16),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              p.name,
              style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          SizedBox(
            width: 40,
            child: Text(
              '${p.runs}',
              style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.w700,
              ),
              textAlign: TextAlign.center,
            ),
          ),
          SizedBox(
            width: 40,
            child: Text(
              '${p.ballsFaced}',
              style: const TextStyle(color: AppColors.muted),
              textAlign: TextAlign.center,
            ),
          ),
          SizedBox(
            width: 32,
            child: Text(
              '${p.fours}',
              style: const TextStyle(color: AppColors.muted),
              textAlign: TextAlign.center,
            ),
          ),
          SizedBox(
            width: 32,
            child: Text(
              '${p.sixes}',
              style: const TextStyle(color: AppColors.muted),
              textAlign: TextAlign.center,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBowlingStats() {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'BOWLERS',
            style: TextStyle(
              color: AppColors.muted,
              fontSize: 11,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 8),
          if (widget.currentBowler != null)
            _bowlerRow(widget.currentBowler!, isCurrent: true),
        ],
      ),
    );
  }

  Widget _bowlerRow(Player p, {required bool isCurrent}) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: isCurrent ? AppColors.accent.withValues(alpha: 0.1) : Colors.transparent,
        borderRadius: BorderRadius.circular(12),
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
                      style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    if (isCurrent)
                      Container(
                        margin: const EdgeInsets.only(left: 8),
                        padding: const EdgeInsets.symmetric(
                          horizontal: 6,
                          vertical: 2,
                        ),
                        decoration: BoxDecoration(
                          color: AppColors.accent,
                          borderRadius: BorderRadius.circular(4),
                        ),
                        child: const Text(
                          'CURRENT',
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: 9,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ),
                  ],
                ),
                const SizedBox(height: 4),
                Text(
                  '${p.oversBowledDisplay} ov  ·  ${p.maidens} M  ·  ${p.runsConceded} R  ·  ${p.wicketsTaken} W',
                  style: const TextStyle(color: AppColors.muted, fontSize: 12),
                ),
              ],
            ),
          ),
          const Text(
            'Econ: ',
            style: TextStyle(color: Colors.white70, fontSize: 12),
          ),
          Text(
            p.economy.toStringAsFixed(1),
            style: const TextStyle(color: Colors.amber, fontWeight: FontWeight.w600),
          ),
        ],
      ),
    );
  }

  Widget _buildCommentary() {
    final reversedHistory = widget.ballHistory.reversed.toList();
    if (reversedHistory.isEmpty) {
      return const Padding(
        padding: EdgeInsets.all(24),
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
      physics: const NeverScrollableScrollPhysics(),
      itemCount: reversedHistory.length,
      itemBuilder: (ctx, i) {
        final ball = reversedHistory[i];
        return Container(
          padding: const EdgeInsets.all(12),
          margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
          decoration: BoxDecoration(
            color: AppColors.surface,
            borderRadius: BorderRadius.circular(12),
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: 40,
                height: 40,
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
                    fontSize: 12,
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Ov ${ball.overNumber}.${ball.ballNumber}',
                      style: const TextStyle(color: AppColors.muted, fontSize: 11),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      ball.commentary,
                      style: const TextStyle(
                        color: Colors.white70,
                        fontSize: 13,
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
