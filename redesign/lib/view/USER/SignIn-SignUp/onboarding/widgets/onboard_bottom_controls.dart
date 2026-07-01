import 'package:flutter/material.dart';
import 'package:redesign/theme/app_colors.dart';
import 'package:redesign/theme/responsive_helper.dart';

class OnboardBottomControls extends StatelessWidget {
  final int currentIndex;
  final int total;
  final VoidCallback onNext;

  OnboardBottomControls({
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
      padding: EdgeInsets.fromLTRB(24, 12, 24, 24),
      child: Row(
        children: [
          /// Progress dots
          Row(
            children: List.generate(
              total,
              (index) => AnimatedContainer(
                duration: Duration(milliseconds: 300),
                margin: EdgeInsets.only(right: 6),
                height: ResponsiveHelper.h(6),
                width: currentIndex == index ? 24 : 6,
                decoration: BoxDecoration(
                  color: currentIndex == index
                      ? AppColors.accent
                      : Colors.white24,
                  borderRadius: BorderRadius.circular(ResponsiveHelper.w(6)),
                ),
              ),
            ),
          ),
          Spacer(),

          /// CTA Button
          ElevatedButton(
            onPressed: onNext,
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.accent,
              foregroundColor: Colors.black,
              padding: EdgeInsets.symmetric(horizontal: ResponsiveHelper.w(22), vertical: ResponsiveHelper.h(14)),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(ResponsiveHelper.w(18)),
              ),
            ),
            child: Text(isLast ? "Let's Play" : 'Next →'),
          ),
        ],
      ),
    );
  }
}
