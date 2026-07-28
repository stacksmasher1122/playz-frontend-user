import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:redesign/theme/app_colors.dart';
import 'package:redesign/theme/responsive_helper.dart';

class BadmintonDistributionCard extends StatelessWidget {
  final Map<String, int> distribution;

  const BadmintonDistributionCard({super.key, required this.distribution});

  @override
  Widget build(BuildContext context) {
    ResponsiveHelper.init(context);

    if (distribution.isEmpty) return const SizedBox.shrink();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            const Icon(Icons.bar_chart, color: AppColors.accent, size: 18),
            const SizedBox(width: 8),
            Text(
              'Shot Type Distribution (%)',
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
            children: distribution.entries.map((entry) {
              return Padding(
                padding: EdgeInsets.only(bottom: ResponsiveHelper.h(8)),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          entry.key,
                          style: GoogleFonts.inter(color: Colors.white, fontSize: 12),
                        ),
                        Text(
                          '${entry.value}%',
                          style: GoogleFonts.inter(
                            color: AppColors.accent,
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 4),
                    ClipRRect(
                      borderRadius: BorderRadius.circular(4),
                      child: LinearProgressIndicator(
                        value: entry.value / 100,
                        backgroundColor: AppColors.card,
                        valueColor: const AlwaysStoppedAnimation<Color>(AppColors.accent),
                        minHeight: 6,
                      ),
                    ),
                  ],
                ),
              );
            }).toList(),
          ),
        ),
      ],
    );
  }
}
