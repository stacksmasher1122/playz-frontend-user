import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:redesign/theme/app_colors.dart';
import 'package:redesign/theme/responsive_helper.dart';
import 'package:redesign/model/User_Models/More_Models/sport_stat_model.dart';

class BadmintonShotStatsCard extends StatelessWidget {
  final BadmintonTechnicalStats? bs;

  const BadmintonShotStatsCard({super.key, required this.bs});

  @override
  Widget build(BuildContext context) {
    ResponsiveHelper.init(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            const Icon(Icons.speed, color: AppColors.accent, size: 18),
            const SizedBox(width: 8),
            Text(
              'Technical Shot & Winner Metrics',
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
                  Expanded(child: _TechStatTile(label: 'Smash Winners', value: '${bs?.smashWinners ?? 0}')),
                  Expanded(child: _TechStatTile(label: 'Avg Smash Speed', value: '${bs?.avgSmashSpeedKmh ?? 0} km/h')),
                  Expanded(child: _TechStatTile(label: 'Top Smash Speed', value: '${bs?.topSmashSpeedKmh ?? 0} km/h')),
                ],
              ),
              const Divider(color: AppColors.divider, height: 20),
              Row(
                children: [
                  Expanded(child: _TechStatTile(label: 'Net Winners', value: '${bs?.netWinners ?? 0}')),
                  Expanded(child: _TechStatTile(label: 'Drop Winners', value: '${bs?.dropWinners ?? 0}')),
                  Expanded(child: _TechStatTile(label: 'Unforced Errors', value: '${bs?.unforcedErrors ?? 0}')),
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
