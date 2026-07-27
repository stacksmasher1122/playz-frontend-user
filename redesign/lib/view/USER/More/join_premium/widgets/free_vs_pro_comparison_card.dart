import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:redesign/theme/app_colors.dart';
import 'package:redesign/theme/responsive_helper.dart';

class FreeVsProComparisonCard extends StatelessWidget {
  const FreeVsProComparisonCard({super.key});

  @override
  Widget build(BuildContext context) {
    ResponsiveHelper.init(context);

    return Container(
      padding: EdgeInsets.all(ResponsiveHelper.w(16)),
      decoration: BoxDecoration(
        color: const Color(0xFF141414),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.white.withValues(alpha: 0.05)),
      ),
      child: Column(
        children: [
          // Header Title
          Text(
            'Free vs Pro',
            style: GoogleFonts.inter(
              color: Colors.white,
              fontSize: ResponsiveHelper.sp(18),
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: ResponsiveHelper.h(14)),

          // Subheader Row: FREE | PRO
          Row(
            children: [
              const Expanded(flex: 4, child: SizedBox.shrink()),
              Expanded(
                flex: 3,
                child: Center(
                  child: Text(
                    'FREE',
                    style: GoogleFonts.inter(
                      color: AppColors.muted,
                      fontSize: ResponsiveHelper.sp(11),
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
              Expanded(
                flex: 3,
                child: Center(
                  child: Text(
                    'PRO',
                    style: GoogleFonts.inter(
                      color: AppColors.accent,
                      fontSize: ResponsiveHelper.sp(11),
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: ResponsiveHelper.h(10)),

          // Row 1: Match History
          _ComparisonRow(
            feature: 'Match History',
            freeVal: '30 Days',
            proVal: 'Unlimited',
          ),
          const Divider(color: Colors.white10, height: 20),

          // Row 2: Analytics
          _ComparisonRow(
            feature: 'Analytics',
            freeVal: 'Basic',
            proVal: 'Advanced',
          ),
          const Divider(color: Colors.white10, height: 20),

          // Row 3: AI Insights
          Row(
            children: [
              Expanded(
                flex: 4,
                child: Text(
                  'AI Insights',
                  style: GoogleFonts.inter(color: Colors.white, fontSize: ResponsiveHelper.sp(13)),
                ),
              ),
              const Expanded(
                flex: 3,
                child: Center(
                  child: Icon(Icons.close, color: AppColors.muted, size: 16),
                ),
              ),
              const Expanded(
                flex: 3,
                child: Center(
                  child: Icon(Icons.check_circle, color: AppColors.accent, size: 18),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _ComparisonRow extends StatelessWidget {
  final String feature;
  final String freeVal;
  final String proVal;

  const _ComparisonRow({
    required this.feature,
    required this.freeVal,
    required this.proVal,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          flex: 4,
          child: Text(
            feature,
            style: GoogleFonts.inter(
              color: Colors.white,
              fontSize: ResponsiveHelper.sp(13),
            ),
          ),
        ),
        Expanded(
          flex: 3,
          child: Center(
            child: Text(
              freeVal,
              style: GoogleFonts.inter(
                color: Colors.white70,
                fontSize: ResponsiveHelper.sp(12),
              ),
            ),
          ),
        ),
        Expanded(
          flex: 3,
          child: Center(
            child: Text(
              proVal,
              style: GoogleFonts.inter(
                color: AppColors.accent,
                fontSize: ResponsiveHelper.sp(12),
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
      ],
    );
  }
}
