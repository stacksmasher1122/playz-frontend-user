import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:redesign/theme/app_colors.dart';
import 'package:redesign/theme/responsive_helper.dart';

class MatchSlotsCard extends StatelessWidget {
  final int currentPlayers;
  final int maxPlayers;

  const MatchSlotsCard({
    super.key,
    this.currentPlayers = 6,
    this.maxPlayers = 10,
  });

  @override
  Widget build(BuildContext context) {
    ResponsiveHelper.init(context);
    final progress = (currentPlayers / (maxPlayers > 0 ? maxPlayers : 1)).clamp(0.0, 1.0);
    final isFull = currentPlayers >= maxPlayers;

    return Container(
      padding: EdgeInsets.all(ResponsiveHelper.w(18)),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(ResponsiveHelper.w(18)),
        border: Border.all(color: Colors.white.withValues(alpha: 0.08)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Slots Filling Status",
                    style: GoogleFonts.inter(
                      fontSize: ResponsiveHelper.sp(12),
                      color: AppColors.muted,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  SizedBox(height: 4),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.baseline,
                    textBaseline: TextBaseline.alphabetic,
                    children: [
                      Text(
                        "$currentPlayers",
                        style: GoogleFonts.inter(
                          fontSize: ResponsiveHelper.sp(32),
                          fontWeight: FontWeight.bold,
                          color: isFull ? Colors.redAccent : AppColors.accent,
                        ),
                      ),
                      Text(
                        " / $maxPlayers Players",
                        style: GoogleFonts.inter(
                          fontSize: ResponsiveHelper.sp(14),
                          color: Colors.white70,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              Container(
                padding: EdgeInsets.symmetric(
                  horizontal: ResponsiveHelper.w(12),
                  vertical: ResponsiveHelper.h(6),
                ),
                decoration: BoxDecoration(
                  color: isFull
                      ? Colors.redAccent.withValues(alpha: 0.15)
                      : AppColors.accent.withValues(alpha: 0.15),
                  borderRadius: BorderRadius.circular(ResponsiveHelper.w(20)),
                  border: Border.all(
                    color: isFull
                        ? Colors.redAccent.withValues(alpha: 0.4)
                        : AppColors.accent.withValues(alpha: 0.4),
                  ),
                ),
                child: Text(
                  isFull ? "Match Full 🔴" : "Filling Fast ⚡",
                  style: GoogleFonts.inter(
                    fontSize: ResponsiveHelper.sp(12),
                    fontWeight: FontWeight.bold,
                    color: isFull ? Colors.redAccent : AppColors.accent,
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: 16),

          /// PROGRESS BAR
          Stack(
            children: [
              Container(
                height: ResponsiveHelper.h(8),
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.08),
                  borderRadius: BorderRadius.circular(ResponsiveHelper.w(4)),
                ),
              ),
              FractionallySizedBox(
                widthFactor: progress,
                child: Container(
                  height: ResponsiveHelper.h(8),
                  decoration: BoxDecoration(
                    color: isFull ? Colors.redAccent : AppColors.accent,
                    borderRadius: BorderRadius.circular(ResponsiveHelper.w(4)),
                    boxShadow: [
                      BoxShadow(
                        color: (isFull ? Colors.redAccent : AppColors.accent).withValues(alpha: 0.4),
                        blurRadius: 6,
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: 16),
          const Divider(color: Colors.white10),
          SizedBox(height: 12),

          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: const [
              Expanded(child: _StatColumn("Average Rating", "4.8 ⭐")),
              Expanded(child: _StatColumn("Skill Level", "Balanced ⚖️")),
              Expanded(child: _StatColumn("Cancellation", "100% Free")),
            ],
          ),
        ],
      ),
    );
  }
}

class _StatColumn extends StatelessWidget {
  final String label;
  final String value;

  const _StatColumn(this.label, this.value);

  @override
  Widget build(BuildContext context) {
    ResponsiveHelper.init(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: GoogleFonts.inter(
            fontSize: ResponsiveHelper.sp(11),
            color: AppColors.muted,
          ),
        ),
        SizedBox(height: 2),
        Text(
          value,
          style: GoogleFonts.inter(
            fontSize: ResponsiveHelper.sp(12.5),
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
      ],
    );
  }
}
