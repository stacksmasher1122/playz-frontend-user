import 'package:flutter/material.dart';
import 'package:redesign/theme/app_colors.dart';
import 'package:redesign/theme/app_typography.dart';
import 'package:redesign/theme/responsive_helper.dart';

class SportCardWidget extends StatelessWidget {
  final String sport;
  final bool isSelected;
  final VoidCallback onTap;

  const SportCardWidget({
    super.key,
    required this.sport,
    required this.isSelected,
    required this.onTap,
  });

  IconData _getIconForSport(String sport) {
    final s = sport.toLowerCase().trim();
    switch (s) {
      case 'cricket':
        return Icons.sports_cricket_rounded;
      case 'football':
      case 'soccer':
        return Icons.sports_soccer_rounded;
      case 'basketball':
        return Icons.sports_basketball_rounded;
      case 'tennis':
      case 'badminton':
      case 'table tennis':
      case 'squash':
      case 'pickleball':
        return Icons.sports_tennis_rounded;
      case 'volleyball':
        return Icons.sports_volleyball_rounded;
      case 'hockey':
        return Icons.sports_hockey_rounded;
      case 'kabaddi':
      case 'wrestling':
      case 'judo':
      case 'karate':
      case 'taekwondo':
        return Icons.sports_kabaddi_rounded;
      case 'kho kho':
        return Icons.directions_run_rounded;
      case 'boxing':
      case 'mma':
        return Icons.sports_mma_rounded;
      default:
        return Icons.sports_rounded;
    }
  }

  @override
  Widget build(BuildContext context) {
    ResponsiveHelper.init(context);

    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        width: ResponsiveHelper.w(86.0),
        height: ResponsiveHelper.h(90.0),
        margin: EdgeInsets.only(right: ResponsiveHelper.w(10.0)),
        decoration: BoxDecoration(
          color: isSelected
              ? AppColors.primary.withValues(alpha: 0.15)
              : AppColors.card,
          borderRadius: BorderRadius.circular(ResponsiveHelper.w(14.0)),
          border: Border.all(
            color: isSelected ? AppColors.primary : AppColors.borderDark,
            width: isSelected ? 2.0 : 1.0,
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              _getIconForSport(sport),
              color: isSelected ? AppColors.primary : AppColors.muted,
              size: ResponsiveHelper.w(26.0),
            ),
            SizedBox(height: ResponsiveHelper.h(6.0)),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: ResponsiveHelper.w(4.0)),
              child: FittedBox(
                fit: BoxFit.scaleDown,
                child: Text(
                  sport,
                  textAlign: TextAlign.center,
                  style: AppTypography.bodySm.copyWith(
                    color: isSelected ? AppColors.primary : AppColors.textPrimary,
                    fontSize: ResponsiveHelper.sp(12.0),
                    fontWeight: isSelected ? FontWeight.w900 : FontWeight.w600,
                  ).responsive(context),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
