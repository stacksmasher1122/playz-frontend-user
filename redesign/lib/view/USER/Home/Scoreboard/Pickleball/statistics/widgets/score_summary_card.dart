import 'package:flutter/material.dart';
import 'package:redesign/theme/app_colors.dart';
import 'package:redesign/theme/app_typography.dart';
import 'package:redesign/controller/User_Controller/Home_Controller/Scoreboard_Controller/Pickleball/pickleball_stats_controller.dart';
import 'package:redesign/theme/responsive_helper.dart';

class ScoreSummaryCard extends StatelessWidget {
  final PickleballStatsController controller;

  ScoreSummaryCard({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    ResponsiveHelper.init(context);
    return Container(
      padding: EdgeInsets.symmetric(vertical: ResponsiveHelper.h(24), horizontal: ResponsiveHelper.w(16)),
      decoration: BoxDecoration(
        color: AppColors.card,
        borderRadius: BorderRadius.circular(ResponsiveHelper.w(16)),
        border: Border.all(color: AppColors.outlineVariant, width: 1),
      ),
      child: Column(
        children: [
          Text(
            'FINAL SCORE',
            style: AppTypography.labelCaps10.copyWith(color: AppColors.muted, fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 8),
          Text(
            'MATCH COMPLETE',
            style: AppTypography.headlineLg.copyWith(
              color: AppColors.accent,
              fontWeight: FontWeight.w900,
              fontStyle: FontStyle.italic,
            ),
          ),
          SizedBox(height: 24),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Column(
                children: [
                  Text('TEAM ALPHA', style: AppTypography.labelCaps10.copyWith(color: AppColors.muted)),
                  SizedBox(height: 8),
                  Text(
                    '${controller.teamAScore.value}',
                    style: TextStyle(
                      fontFamily: 'Inter',
                      fontSize: ResponsiveHelper.sp(64),
                      fontWeight: FontWeight.w900,
                      color: AppColors.accent,
                      height: ResponsiveHelper.h(1.0),
                    ),
                  ),
                ],
              ),
              SizedBox(width: 24),
              Column(
                children: [
                  Text('vs', style: AppTypography.labelCaps10.copyWith(color: AppColors.muted)),
                  SizedBox(height: 8),
                  Text(
                    '—',
                    style: TextStyle(
                      fontFamily: 'Inter',
                      fontSize: ResponsiveHelper.sp(48),
                      fontWeight: FontWeight.w100,
                      color: AppColors.muted,
                      height: ResponsiveHelper.h(1.0),
                    ),
                  ),
                ],
              ),
              SizedBox(width: 24),
              Column(
                children: [
                  Text('TEAM OMEGA', style: AppTypography.labelCaps10.copyWith(color: AppColors.muted)),
                  SizedBox(height: 8),
                  Text(
                    '${controller.teamBScore.value}',
                    style: TextStyle(
                      fontFamily: 'Inter',
                      fontSize: ResponsiveHelper.sp(64),
                      fontWeight: FontWeight.w900,
                      color: AppColors.accent,
                      height: ResponsiveHelper.h(1.0),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }
}
