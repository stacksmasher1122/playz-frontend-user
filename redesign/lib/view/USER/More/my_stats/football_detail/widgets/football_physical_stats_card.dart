import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:redesign/theme/app_colors.dart';
import 'package:redesign/theme/responsive_helper.dart';
import 'package:redesign/model/User_Models/More_Models/sport_stat_model.dart';

class FootballPhysicalStatsCard extends StatelessWidget {
  final FootballTechnicalStats? fs;

  const FootballPhysicalStatsCard({super.key, required this.fs});

  @override
  Widget build(BuildContext context) {
    ResponsiveHelper.init(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            const Icon(Icons.fitness_center, color: AppColors.accent, size: 18),
            const SizedBox(width: 8),
            Text(
              'Physical & Athletic Metrics',
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
          child: Row(
            children: [
              Expanded(child: _TechStatTile(label: 'Ground Duels %', value: '${fs?.groundDuelsWonRate ?? 0}%')),
              Expanded(child: _TechStatTile(label: 'Distance / Match', value: '${fs?.distanceCoveredKm ?? 0} km')),
              Expanded(child: _TechStatTile(label: 'Top Speed', value: '${fs?.topSpeedKmh ?? 0} km/h')),
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
