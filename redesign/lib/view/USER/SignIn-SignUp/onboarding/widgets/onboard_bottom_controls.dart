import 'package:flutter/material.dart';
import 'package:redesign/theme/app_colors.dart';
import 'package:redesign/theme/app_typography.dart';
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
    ResponsiveHelper.init(context);

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
                height: context.heightPct(0.8).clamp(5.0, 7.0),
                width: currentIndex == index ? context.widthPct(6) : context.heightPct(0.8).clamp(5.0, 7.0),
                decoration: BoxDecoration(
                  color: currentIndex == index
                      ? AppColors.accent
                      : AppColors.textSecondary.withValues(alpha: 0.3),
                  borderRadius: BorderRadius.circular(3),
                ),
              ),
            ),
          ),
          const Spacer(),

          /// CTA Pill Button
          SizedBox(
            height: context.heightPct(5.5).clamp(44.0, 52.0),
            child: ElevatedButton(
              onPressed: onNext,
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.accent,
                foregroundColor: AppColors.background,
                padding: EdgeInsets.symmetric(
                  horizontal: context.widthPct(7),
                ),
                shape: const StadiumBorder(),
                elevation: 0,
              ),
              child: FittedBox(
                fit: BoxFit.scaleDown,
                child: Text(
                  isLast ? "Let's Play" : 'Next',
                  style: AppTypography.labelCaps10.copyWith(
                    fontWeight: FontWeight.w800,
                    fontSize: context.responsiveFont(14),
                    color: AppColors.background,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
