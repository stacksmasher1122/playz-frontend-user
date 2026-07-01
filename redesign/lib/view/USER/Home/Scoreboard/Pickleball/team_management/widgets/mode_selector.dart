import 'package:flutter/material.dart';
import 'package:redesign/theme/app_colors.dart';
import 'package:redesign/theme/app_typography.dart';

class ModeSelector extends StatelessWidget {
  final bool isSingles;
  final ValueChanged<bool> onChanged;

  const ModeSelector({
    super.key,
    required this.isSingles,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 240,
      height: 48,
      decoration: BoxDecoration(
        color: AppColors.surfaceContainerHighest,
        borderRadius: BorderRadius.circular(24),
      ),
      child: Row(
        children: [
          Expanded(
            child: GestureDetector(
              onTap: () => onChanged(true),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                decoration: BoxDecoration(
                  color: isSingles ? AppColors.primaryContainer : Colors.transparent,
                  borderRadius: BorderRadius.circular(24),
                ),
                child: Center(
                  child: Text(
                    'SINGLES',
                    style: AppTypography.labelCaps.copyWith(
                      color: isSingles ? Colors.black : AppColors.primary,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 1.5,
                    ),
                  ),
                ),
              ),
            ),
          ),
          Expanded(
            child: GestureDetector(
              onTap: () => onChanged(false),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                decoration: BoxDecoration(
                  color: !isSingles ? AppColors.primaryContainer : Colors.transparent,
                  borderRadius: BorderRadius.circular(24),
                ),
                child: Center(
                  child: Text(
                    'DOUBLES',
                    style: AppTypography.labelCaps.copyWith(
                      color: !isSingles ? Colors.black : AppColors.primary,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 1.5,
                    ),
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
