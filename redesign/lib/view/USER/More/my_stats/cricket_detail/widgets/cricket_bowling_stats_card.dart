import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:redesign/theme/app_colors.dart';
import 'package:redesign/theme/responsive_helper.dart';
import 'package:redesign/model/User_Models/More_Models/sport_stat_model.dart';

class CricketBowlingStatsCard extends StatelessWidget {
  final CricketTechnicalStats? cs;

  const CricketBowlingStatsCard({super.key, required this.cs});

  @override
  Widget build(BuildContext context) {
    ResponsiveHelper.init(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            const Icon(Icons.sports_baseball, color: AppColors.accent, size: 18),
            const SizedBox(width: 8),
            Text(
              'Bowling Technical Stats',
              style: GoogleFonts.inter(
                color: Colors.white,
                fontSize: ResponsiveHelper.sp(14),
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
        SizedBox(height: ResponsiveHelper.h(10)),
        Container(
          padding: EdgeInsets.all(ResponsiveHelper.w(14)),
          decoration: BoxDecoration(
            color: AppColors.surface,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: AppColors.divider),
          ),
          child: Column(
            children: [
              Row(
                children: [
                  Expanded(child: _TechStatTile(label: 'Wickets', value: '${cs?.wickets ?? 0}')),
                  Expanded(child: _TechStatTile(label: 'Overs Bowled', value: '${cs?.oversBowled ?? 0}')),
                  Expanded(child: _TechStatTile(label: 'Economy Rate', value: '${cs?.economyRate ?? 0}')),
                ],
              ),
              const Divider(color: AppColors.divider, height: 20),
              Row(
                children: [
                  Expanded(child: _TechStatTile(label: 'Maidens', value: '${cs?.maidens ?? 0}')),
                  Expanded(child: _TechStatTile(label: 'Bowling Avg', value: '${cs?.bowlingAvg ?? 0}')),
                  Expanded(child: _TechStatTile(label: 'Best Bowling', value: cs?.bestBowling ?? '-')),
                ],
              ),
              const Divider(color: AppColors.divider, height: 20),
              Row(
                children: [
                  Expanded(child: _TechStatTile(label: 'Dot Ball %', value: '${cs?.dotBallPercentage ?? 0}%')),
                  Expanded(child: _TechStatTile(label: 'Catches', value: '${cs?.catches ?? 0}')),
                  Expanded(child: _TechStatTile(label: 'Run Outs', value: '${cs?.runOuts ?? 0}')),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _TechStatTile extends StatelessWidget {
  final String label;
  final String value;

  const _TechStatTile({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        FittedBox(
          fit: BoxFit.scaleDown,
          child: Text(
            value,
            style: GoogleFonts.inter(
              color: Colors.white,
              fontSize: ResponsiveHelper.sp(15),
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        SizedBox(height: 2),
        Text(
          label,
          textAlign: TextAlign.center,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: GoogleFonts.inter(
            color: AppColors.muted,
            fontSize: ResponsiveHelper.sp(10),
          ),
        ),
      ],
    );
  }
}
