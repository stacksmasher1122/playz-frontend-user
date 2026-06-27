import 'package:flutter/material.dart';
import 'package:redesign/theme/app_colors.dart';

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
      padding: const EdgeInsets.fromLTRB(24, 12, 24, 24),
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
                      ? AppColors.accent
                      : Colors.white24,
                  borderRadius: BorderRadius.circular(6),
                ),
              ),
            ),
          ),
          const Spacer(),

          /// CTA Button
          ElevatedButton(
            onPressed: onNext,
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.accent,
              foregroundColor: Colors.black,
              padding: const EdgeInsets.symmetric(horizontal: 22, vertical: 14),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(18),
              ),
            ),
            child: Text(isLast ? "Let's Play" : 'Next →'),
          ),
        ],
      ),
    );
  }
}
