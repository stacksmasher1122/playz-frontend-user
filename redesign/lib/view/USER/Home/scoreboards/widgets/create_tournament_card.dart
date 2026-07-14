import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:redesign/theme/app_colors.dart';
import 'package:redesign/theme/responsive_helper.dart';

class CreateTournamentCard extends StatelessWidget {
  final VoidCallback onTap;

  CreateTournamentCard({super.key, required this.onTap});

  @override
  Widget build(BuildContext context) {
    ResponsiveHelper.init(context);
    return Material(
      color: Colors.transparent,
      borderRadius: BorderRadius.circular(ResponsiveHelper.w(16)),
      child: InkWell(
        borderRadius: BorderRadius.circular(ResponsiveHelper.w(16)),
        onTap: onTap,
        splashColor: AppColors.accent.withValues(alpha: 0.15),
        highlightColor: AppColors.accent.withValues(alpha: 0.08),
        child: Container(
          padding: EdgeInsets.all(ResponsiveHelper.w(16)),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(ResponsiveHelper.w(16)),
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                AppColors.accent.withValues(alpha: 0.18),
                AppColors.background,
              ],
            ),
            border: Border.all(
              color: AppColors.accent.withValues(alpha: 0.5),
              width: ResponsiveHelper.w(1),
            ),
            boxShadow: [
              BoxShadow(
                color: AppColors.accent.withValues(alpha: 0.18),
                blurRadius: 5,
                offset: Offset(0, 0),
              ),
            ],
          ),
          child: Row(
            children: [
              /// LEFT ICON (Trophy)
              Container(
                width: ResponsiveHelper.w(44),
                height: ResponsiveHelper.h(44),
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: AppColors.accent.withValues(alpha: 0.2),
                ),
                child: Icon(
                  Icons.emoji_events_rounded,
                  color: AppColors.accent,
                  size: 22,
                ),
              ),

              SizedBox(width: 14),

              /// TEXT CONTENT
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Create a Tournament?',
                      style: GoogleFonts.inter(
                        color: Colors.white,
                        fontSize: ResponsiveHelper.sp(15),
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    SizedBox(height: 4),
                    Text(
                      'Set up brackets, leagues, custom rules, schedules, and crown your champions.',
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: GoogleFonts.inter(
                        color: AppColors.muted,
                        fontSize: ResponsiveHelper.sp(12.5),
                        height: ResponsiveHelper.h(1.4),
                      ),
                    ),
                  ],
                ),
              ),

              SizedBox(width: 12),

              /// CTA BUTTON
              Container(
                padding: EdgeInsets.symmetric(
                  horizontal: 14,
                  vertical: 8,
                ),
                decoration: BoxDecoration(
                  color: AppColors.accent,
                  borderRadius: BorderRadius.circular(ResponsiveHelper.w(22)),
                  border: Border.all(color: AppColors.accent, width: 1),
                ),
                child: Row(
                  children: [
                    Text(
                      'Create',
                      style: GoogleFonts.inter(
                        color: AppColors.background,
                        fontSize: ResponsiveHelper.sp(12.5),
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
