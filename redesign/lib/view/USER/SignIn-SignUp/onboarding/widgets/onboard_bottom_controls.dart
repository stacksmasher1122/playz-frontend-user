import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:redesign/theme/app_colors.dart';
import 'package:redesign/theme/responsive_helper.dart';

class OnboardBottomControls extends StatelessWidget {
  final int currentIndex;
  final int total;
  final VoidCallback onNext;

  const OnboardBottomControls({
    super.key,
    required this.currentIndex,
    required this.total,
    required this.onNext,
  });

  @override
  Widget build(BuildContext context) {
    final bool isLast = currentIndex == total - 1;

    return Padding(
      padding: EdgeInsets.fromLTRB(
        context.widthPct(6),
        context.heightPct(1),
        context.widthPct(6),
        context.heightPct(3),
      ),
      child: Row(
        children: [
          /// Progress dots
          Row(
            children: List.generate(
              total,
              (index) => AnimatedContainer(
                duration: const Duration(milliseconds: 300),
                margin: const EdgeInsets.only(right: 6),
                height: 6,
                width: currentIndex == index ? 24 : 6,
                decoration: BoxDecoration(
                  color: currentIndex == index
                      ? AppColors.spotifyGreen
                      : AppColors.textSecondary.withValues(alpha: 0.3),
                  borderRadius: BorderRadius.circular(3),
                ),
              ),
            ),
          ),
          const Spacer(),

          /// CTA Pill Button
          ElevatedButton(
            onPressed: onNext,
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.spotifyGreen,
              foregroundColor: AppColors.background,
              padding: EdgeInsets.symmetric(
                horizontal: context.widthPct(7),
                vertical: context.heightPct(1.6),
              ),
              shape: const StadiumBorder(),
              elevation: 0,
            ),
            child: Text(
              isLast ? "Let's Play" : 'Next',
              style: GoogleFonts.inter(
                fontWeight: FontWeight.w800,
                fontSize: context.responsiveFont(14),
                color: AppColors.background,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
